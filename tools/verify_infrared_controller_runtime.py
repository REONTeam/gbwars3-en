#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys

ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / 'baserom.gbc'
SRC = ROOT / 'engine/home/home_infrared_controller.asm'
START, END = 0x0C30, 0x0ED4
EXPECTED = 'bcfed9dfd9a425e542b171a58a8eca1a07ddb9e9'

labels = {
    'InfraredController_Run': 0x0C30,
    'InfraredController_DispatchState': 0x0C73,
    'InfraredController_StateTable': 0x0C9E,
    'InfraredController_State00': 0x0CB0,
    'InfraredController_State06': 0x0CE5,
    'InfraredController_State01': 0x0D30,
    'InfraredController_State07': 0x0D4D,
    'InfraredController_State02': 0x0D63,
    'InfraredController_ResultTextA': 0x0DB8,
    'InfraredController_ResultTextB': 0x0DC2,
    'InfraredController_State08': 0x0DCC,
    'InfraredController_State03': 0x0DEC,
    'InfraredController_State04': 0x0E0B,
    'InfraredController_State05': 0x0E2A,
    'InfraredController_TransferChunks': 0x0E3A,
    'InfraredController_TransferChunk': 0x0E9B,
    'InfraredController_LoadTransferTiles': 0x0EB1,
}
state_order = [
    'InfraredController_State00','InfraredController_State01','InfraredController_State02',
    'InfraredController_State03','InfraredController_State04','InfraredController_State05',
    'InfraredController_State06','InfraredController_State07','InfraredController_State08',
]

text = SRC.read_text()
for label in labels:
    if not re.search(r'^' + re.escape(label) + r'::', text, re.M):
        raise SystemExit(f'missing label: {label}')
if 'rom0[$0c30]' not in text.lower() or 'assert @ == $0ed4' not in text.lower():
    raise SystemExit('wrong controller source boundaries')

# Build a byte stream from exact db rows, symbolic LOW/HIGH WRAM aliases, and the state-pointer table.
workspace = {
    'wInfraredControllerState': 0xC61A,
    'wInfraredSessionSelector': 0xC61B,
    'wInfraredPeerCompareByte': 0xC61C,
    'wInfraredTransferDirection': 0xC61D,
    'wInfraredTransferBufferAddress': 0xC61E,
    'wInfraredTransferLengthLo': 0xC620,
    'wInfraredTransferLengthHi': 0xC621,
    'wInfraredTransferBufferBank': 0xC622,
}

def parse_db(tok):
    tok = tok.strip()
    if tok.startswith('$'):
        return int(tok[1:], 16)
    m = re.fullmatch(r'(LOW|HIGH)\((w\w+)(?: \+ (\d+))?\)', tok)
    if not m or m.group(2) not in workspace:
        raise SystemExit(f'unsupported db token: {tok}')
    value = workspace[m.group(2)] + int(m.group(3) or 0)
    return value & 0xff if m.group(1) == 'LOW' else (value >> 8) & 0xff

vals = []
for line in text.splitlines():
    code = line.split(';', 1)[0].strip()
    if code.startswith('db '):
        for tok in code[3:].split(','):
            tok = tok.strip()
            vals.append(parse_db(tok))
    elif code.startswith('dw '):
        tok = code[3:].strip()
        if tok not in labels:
            raise SystemExit(f'unexpected dw target: {tok}')
        addr = labels[tok]
        vals.extend([addr & 0xFF, addr >> 8])

if len(vals) != END - START:
    raise SystemExit(f'controller source reconstructed {len(vals)} bytes, expected {END-START}')

expected_table = [labels[x] for x in state_order]
table_off = 0x0C9E - START
actual_table = [vals[table_off+i] | (vals[table_off+i+1] << 8) for i in range(0, 18, 2)]
if actual_table != expected_table:
    raise SystemExit(f'state table mismatch: {actual_table!r}')

if not ROM.exists():
    print('[skip] baserom.gbc unavailable; structural IR controller checks passed')
    sys.exit(0)
data = ROM.read_bytes()[START:END]
sha = hashlib.sha1(data).hexdigest()
if sha != EXPECTED:
    raise SystemExit(f'ROM hash mismatch for ${START:04X}-${END-1:04X}: {sha}')
if bytes(vals) != data:
    raise SystemExit('controller source byte reconstruction mismatch')
print(f'[ok] IR controller ${START:04X}-${END-1:04X}: {len(data)} bytes, SHA-1 {sha}')
