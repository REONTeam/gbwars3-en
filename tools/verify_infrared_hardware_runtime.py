#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
ROOT=Path(__file__).resolve().parents[1]
ROM=ROOT/'baserom.gbc'
SRC=ROOT/'engine/home/home_infrared.asm'
HW=ROOT/'constants/hardware.inc'
START,END=0x1214,0x156d
EXPECTED='bd34f1ccebc5de98721ae028f20cc754f4af1705'
labels=[
'InfraredHW_InitializeTiming','InfraredHW_EnableReceiver','InfraredHW_DisablePort',
'InfraredHW_WaitReceiveBitSet','InfraredHW_WaitReceiveBitClear',
'InfraredHW_WaitReceiveBitClearExtended','InfraredHW_DrivePulseC1',
'InfraredHW_DrivePulseC0','InfraredHW_DrivePulseC0Long','InfraredHW_NegotiateLinkRole',
'InfraredHW_LinkRoleReceiveFirst','InfraredHW_LinkRoleSendFirst',
'InfraredHW_WritePortAndResetStatus','InfraredHW_SendBuffer','InfraredHW_SendRawBytes',
'InfraredHW_SetTimeoutError','InfraredHW_SetChecksumError','InfraredHW_SetFramingError',
'InfraredHW_ReceiveBuffer','InfraredHW_ReceiveRawBytes','InfraredHW_SendControlByte',
'InfraredHW_ReceiveControlByte','InfraredHW_PollJoypad']
text=SRC.read_text()
for label in labels:
    if not re.search(r'^'+re.escape(label)+r'::',text,re.M):
        raise SystemExit(f'missing label: {label}')
if 'rom0[$1214]' not in text or 'assert @ == $156d' not in text:
    raise SystemExit('wrong source boundaries')
if 'DEF rRP   EQU $FF56' not in HW.read_text():
    raise SystemExit('rRP hardware constant missing')
if not ROM.exists():
    print('[skip] baserom.gbc unavailable; structural IR hardware checks passed')
    sys.exit(0)
data=ROM.read_bytes()[START:END]
sha=hashlib.sha1(data).hexdigest()
if sha != EXPECTED:
    raise SystemExit(f'ROM hash mismatch for ${START:04X}-${END-1:04X}: {sha}')
# Reconstruct all db bytes from the dedicated source; this module intentionally keeps
# cycle-sensitive code in exact byte rows while its contracts are being established.
vals=[]
for line in text.splitlines():
    code=line.split(';',1)[0].strip()
    if not code.startswith('db '): continue
    for tok in code[3:].split(','):
        tok=tok.strip()
        if tok.startswith('$'): vals.append(int(tok[1:],16))
if bytes(vals)!=data:
    raise SystemExit(f'source byte reconstruction mismatch: {len(vals)} vs {len(data)} bytes')
print(f'[ok] IR hardware runtime ${START:04X}-${END-1:04X}: {len(data)} bytes, SHA-1 {sha}')
