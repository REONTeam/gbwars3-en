#!/usr/bin/env python3
from pathlib import Path
import hashlib,sys
ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()
assert len(rom)>=0x13*0x4000
bank=0x12
def chunk(a,b):
 o=bank*0x4000+(a-0x4000); return rom[o:o+b-a]
checks=[
(0x4837,0x4855,'ee770f793851f9193a8fd339e88ac5dee2bea2f7'),
(0x4855,0x4862,'27e6f05691577e47be37ddf1b9fd1acd1e0fa791'),
(0x4862,0x48fc,'3bea2c39a35031a2a22a14014dfe54eb6660bfda'),
(0x48fc,0x490b,'63f55f749a11ac92bb47050de6cea5833a3b65a9'),
(0x490b,0x4926,'677394216b46f047fc273ec39bb8623189db5396'),
(0x4926,0x494a,'05a0eb3ba0a9219d640ad2edb9e44a0d11811f99'),
(0x494a,0x4958,'fe9887dc30fb7d3faccbdd6937020149068f3f11'),
(0x4958,0x497f,'1470637bfda2cb10feb59709a0e8cad67ea429d7'),
(0x4837,0x497f,'ff63367029af7e292e55b9e5c1c4e38cbbf350cd')]
for a,b,h in checks: assert hashlib.sha1(chunk(a,b)).hexdigest()==h,(hex(a),hex(b))
assert chunk(0x497f,0x4986)==bytes.fromhex('b6 aa aa 6a eb d6 07')
p=chunk(0x4986,0x49a6); ptr=[p[i]|p[i+1]<<8 for i in range(0,32,2)]
assert ptr==[0x49a6,0x49a6,0x49ad,0x49b4,0x49bb,0x49c2,0x49c9,0x49d0,0x49d7,0x49de,0x49e5,0x49ec,0x49f3,0x49fa,0x4a01,0x4a08]
assert len(chunk(0x49a6,0x4a0f))==105
assert len(chunk(0x4a0f,0x4a43))==52
assert hashlib.sha1(chunk(0x4837,0x4a43)).hexdigest()=='7c35176196c2d9a2cc5b3e565a37d243b7bd94e9'
assert hashlib.sha1(chunk(0x497f,0x4a43)).hexdigest()=='7dc224f3daad336e2bc470481027795330250cae'
src=(ROOT/'engine/unit/unit_setup.asm').read_text()
for t in ['section "Unit Weapon Summary Runtime", romx[$4837], bank[$12]','section "Temporary Unit List Runtime", romx[$490b], bank[$12]','section "Unit Purchase And Promotion Data", romx[$497f], bank[$12]','assert @ == $4a43']:
 assert t in src,t
print('[ok] retail ROM locks Bank $12:$4837-$497E code (328 bytes), SHA-1 ff63367029af7e292e55b9e5c1c4e38cbbf350cd')
print('[ok] complete Bank $12:$4837-$4A42 tranche: 524 bytes, SHA-1 7c35176196c2d9a2cc5b3e565a37d243b7bd94e9')
print('[ok] purchase data: 7-byte header, 16 pointers, 15x7-byte lists, 52-byte promotion table')
