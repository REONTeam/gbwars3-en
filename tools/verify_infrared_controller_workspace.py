#!/usr/bin/env python3
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
symbols=(ROOT/'symbols.asm').read_text()
src=(ROOT/'engine/home/home_infrared_controller.asm').read_text()
expected={
'wInfraredControllerState':0xC61A,
'wInfraredSessionSelector':0xC61B,
'wInfraredPeerCompareByte':0xC61C,
'wInfraredTransferDirection':0xC61D,
'wInfraredTransferBufferAddress':0xC61E,
'wInfraredTransferLengthLo':0xC620,
'wInfraredTransferLengthHi':0xC621,
'wInfraredTransferBufferBank':0xC622,
}
for name,addr in expected.items():
    pat=rf'^{name}\s+equ\s+\${addr:04x}\s*$'
    if not re.search(pat,symbols,re.M|re.I):
        raise SystemExit(f'missing/wrong alias {name}')
    if name not in src:
        raise SystemExit(f'controller does not use {name}')
# Reject direct little-endian address pairs for this workspace in the IR controller source.
for addr in range(0xC61A,0xC623):
    lo=addr&0xff; hi=addr>>8
    if re.search(rf'\${lo:02x}\s*,\s*\${hi:02x}',src,re.I):
        raise SystemExit(f'raw IR workspace address remains in controller: ${addr:04X}')
if 'lifetime-scoped aliases' not in (ROOT/'docs/infrared/infrared_controller_workspace.md').read_text():
    raise SystemExit('workspace lifetime warning missing')
print('[ok] IR controller workspace $C61A-$C622 typed as lifetime-scoped aliases')
