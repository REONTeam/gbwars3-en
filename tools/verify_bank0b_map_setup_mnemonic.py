#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'engine/map/bank0b_map_setup_runtime_4000.asm'
BANK=0x0B
RANGES=[(0x4000,0x4078),(0x4088,0x4178),(0x4178,0x4524),(0x4524,0x4551)]
TABLE=(0x4078,0x4088)
EXPECTED_SHA1='c86ec3c64e8f6f6ba483e9737de62d403bf38d18'
PUBLIC={0x4000:'Bank0B_MapSetupFrontend4000',0x4088:'MapRuntime_PrepareSelectedMapState',0x4178:'MapGrid_RebuildTileCountsAndHQCoordinates',0x4524:'MapGrid_ResetWorkingState'}
SEM={0x762B:'MapSetup_ResetRuntimeScratchToFF',0x6CFD:'MapControl_StageForceStateModeFromGameMode',0x41BE:'MapGrid_RecordSetupTile',0x41DB:'MapGrid_IncrementTileCount',0x41E7:'MapGrid_DecrementTileCount',0x4277:'UnitCount_IncrementForRecordIndex',0x4282:'MapPresentation_ResetTileUpdateAndAnimationState'}
FARCALL_SEM={(0x0C,0x5626):'PropertyState_RebuildRecordsFromMap'}
MEM={0xc646:'wMapSide0HQCoordinates',0xc647:'wMapSide0HQCoordinates + 1',0xc648:'wMapSide1HQCoordinates',0xc649:'wMapSide1HQCoordinates + 1',0xc64a:'wMapTileCountsById',0xcd09:'wUnitCountBySide',0xcd0a:'wUnitCountBySide + 1',0xc989:'wMapGridWidth',0xc98a:'wMapGridHeight'}
HREG={0xff70:'rSVBK',0xff82:'hWRAMBank'}
def addr(x): return MEM.get(x,h16(x))
def hreg(x): return HREG.get(x,h16(x))
R=['b','c','d','e','h','l','[hl]','a']; ROT=['rlc','rrc','rl','rr','sla','sra','swap','srl']; ALU=['add a,','adc a,','sub','sbc a,','and','xor','or','cp']
def h8(x): return f'${x:02x}'
def h16(x): return f'${x:04x}'
def s8(x): return x-256 if x>=128 else x
def norm(s):
 s=re.sub(r'\s+',' ',s.strip().lower()).replace(' ,',',')
 return s.replace('map_tile_side0_hq','$01').replace('map_tile_side1_hq','$0c')
def rom_chunk(rom,s,e):
 o=BANK*0x4000+(s-0x4000); return rom[o:o+e-s]
def decode_one(c,i,a,target,labels):
 op=c[i]; word=lambda:c[i+1]|c[i+2]<<8; imm=lambda:c[i+1]
 if op==0xef:
  bank=imm(); d=c[i+2]|c[i+3]<<8; name=FARCALL_SEM.get((bank,d), labels.get(d,h16(d)) if bank==BANK else h16(d))
  return 4,f'farcall ${bank:02x}, {name}'
 if op==0xcb:
  q=c[i+1]; x,y,z=q>>6,(q>>3)&7,q&7
  return 2,(f'{ROT[y]} {R[z]}' if x==0 else f'bit {y}, {R[z]}' if x==1 else f'res {y}, {R[z]}' if x==2 else f'set {y}, {R[z]}')
 T={0x00:(1,'nop'),0x01:(3,lambda:f'ld bc, {h16(word())}'),0x02:(1,'ld [bc], a'),0x03:(1,'inc bc'),0x04:(1,'inc b'),0x05:(1,'dec b'),0x06:(2,lambda:f'ld b, {h8(imm())}'),0x07:(1,'rlca'),0x08:(3,lambda:f'ld [{h16(word())}], sp'),0x09:(1,'add hl, bc'),0x0a:(1,'ld a, [bc]'),0x0b:(1,'dec bc'),0x0c:(1,'inc c'),0x0d:(1,'dec c'),0x0e:(2,lambda:f'ld c, {h8(imm())}'),0x0f:(1,'rrca'),0x10:(2,'stop'),0x11:(3,lambda:f'ld de, {h16(word())}'),0x12:(1,'ld [de], a'),0x13:(1,'inc de'),0x14:(1,'inc d'),0x15:(1,'dec d'),0x16:(2,lambda:f'ld d, {h8(imm())}'),0x17:(1,'rla'),0x18:(2,lambda:f'jr {target((a+2+s8(imm()))&0xffff)}'),0x19:(1,'add hl, de'),0x1a:(1,'ld a, [de]'),0x1b:(1,'dec de'),0x1c:(1,'inc e'),0x1d:(1,'dec e'),0x1e:(2,lambda:f'ld e, {h8(imm())}'),0x1f:(1,'rra'),0x20:(2,lambda:f'jr nz, {target((a+2+s8(imm()))&0xffff)}'),0x21:(3,lambda:f'ld hl, {addr(word())}'),0x22:(1,'ld [hli], a'),0x23:(1,'inc hl'),0x24:(1,'inc h'),0x25:(1,'dec h'),0x26:(2,lambda:f'ld h, {h8(imm())}'),0x27:(1,'daa'),0x28:(2,lambda:f'jr z, {target((a+2+s8(imm()))&0xffff)}'),0x29:(1,'add hl, hl'),0x2a:(1,'ld a, [hli]'),0x2b:(1,'dec hl'),0x2c:(1,'inc l'),0x2d:(1,'dec l'),0x2e:(2,lambda:f'ld l, {h8(imm())}'),0x2f:(1,'cpl'),0x30:(2,lambda:f'jr nc, {target((a+2+s8(imm()))&0xffff)}'),0x31:(3,lambda:f'ld sp, {h16(word())}'),0x32:(1,'ld [hld], a'),0x33:(1,'inc sp'),0x34:(1,'inc [hl]'),0x35:(1,'dec [hl]'),0x36:(2,lambda:f'ld [hl], {h8(imm())}'),0x37:(1,'scf'),0x38:(2,lambda:f'jr c, {target((a+2+s8(imm()))&0xffff)}'),0x39:(1,'add hl, sp'),0x3a:(1,'ld a, [hld]'),0x3b:(1,'dec sp'),0x3c:(1,'inc a'),0x3d:(1,'dec a'),0x3e:(2,lambda:f'ld a, {h8(imm())}'),0x3f:(1,'ccf')}
 if op in T: n,v=T[op]; return n,v() if callable(v) else v
 if 0x40<=op<=0x7f: return (1,'halt') if op==0x76 else (1,f'ld {R[(op>>3)&7]}, {R[op&7]}')
 if 0x80<=op<=0xbf: return 1,f'{ALU[(op>>3)&7]} {R[op&7]}'
 T={0xc0:(1,'ret nz'),0xc1:(1,'pop bc'),0xc2:(3,lambda:f'jp nz, {target(word())}'),0xc3:(3,lambda:f'jp {target(word())}'),0xc4:(3,lambda:f'call nz, {target(word())}'),0xc5:(1,'push bc'),0xc6:(2,lambda:f'add a, {h8(imm())}'),0xc7:(1,'rst $00'),0xc8:(1,'ret z'),0xc9:(1,'ret'),0xca:(3,lambda:f'jp z, {target(word())}'),0xcc:(3,lambda:f'call z, {target(word())}'),0xcd:(3,lambda:f'call {SEM.get(word(),target(word()))}'),0xce:(2,lambda:f'adc a, {h8(imm())}'),0xcf:(1,'rst $08'),0xd0:(1,'ret nc'),0xd1:(1,'pop de'),0xd2:(3,lambda:f'jp nc, {target(word())}'),0xd4:(3,lambda:f'call nc, {target(word())}'),0xd5:(1,'push de'),0xd6:(2,lambda:f'sub {h8(imm())}'),0xd7:(1,'rst $10'),0xd8:(1,'ret c'),0xd9:(1,'reti'),0xda:(3,lambda:f'jp c, {target(word())}'),0xdc:(3,lambda:f'call c, {target(word())}'),0xde:(2,lambda:f'sbc a, {h8(imm())}'),0xdf:(1,'rst $18'),0xe0:(2,lambda:f'ldh [{hreg(0xff00|imm())}], a'),0xe1:(1,'pop hl'),0xe2:(1,'ldh [c], a'),0xe5:(1,'push hl'),0xe6:(2,lambda:f'and {h8(imm())}'),0xe7:(1,'rst $20'),0xe8:(2,lambda:f'add sp, {s8(imm())}'),0xe9:(1,'jp hl'),0xea:(3,lambda:f'ld [{addr(word())}], a'),0xee:(2,lambda:f'xor {h8(imm())}'),0xf0:(2,lambda:f'ldh a, [{hreg(0xff00|imm())}]'),0xf1:(1,'pop af'),0xf2:(1,'ldh a, [c]'),0xf3:(1,'di'),0xf5:(1,'push af'),0xf6:(2,lambda:f'or {h8(imm())}'),0xf7:(1,'rst $30'),0xf8:(2,lambda:f'ld hl, sp + {s8(imm())}'),0xf9:(1,'ld sp, hl'),0xfa:(3,lambda:f'ld a, [{addr(word())}]'),0xfb:(1,'ei'),0xfe:(2,lambda:f'cp {h8(imm())}'),0xff:(1,'rst $38')}
 if op not in T: raise SystemExit(f'[fail] unsupported opcode ${op:02X} at ${a:04X}')
 n,v=T[op]; return n,v() if callable(v) else v
def expected(rom):
 raw=[]
 for s,e in RANGES:
  c=rom_chunk(rom,s,e); i=0;a=s
  while i<len(c): n,t=decode_one(c,i,a,lambda x:h16(x),PUBLIC); raw.append((a,n,t)); i+=n;a+=n
 labels=dict(PUBLIC)
 for a,n,t in raw:
  if t.startswith(('jr ','jp ','call ')):
   for m in re.finditer(r'\$([0-9a-f]{4})',t):
    d=int(m.group(1),16)
    if any(s<=d<e for s,e in RANGES) and d not in labels: labels[d]=f'Bank0B_MapSetup_{d:04X}'
 def target(x): return labels.get(x,SEM.get(x,h16(x)))
 out=[]
 for s,e in RANGES:
  c=rom_chunk(rom,s,e); i=0;a=s
  while i<len(c): n,t=decode_one(c,i,a,target,labels); out.append(norm(t)); i+=n;a+=n
 return out
def actual():
 out=[]; active=False
 for raw in SRC.read_text().splitlines():
  line=raw.split(';',1)[0].strip()
  if line.lower().startswith('section '):
   active=any(f'romx[${s:04x}]' in line.lower() for s,e in RANGES); continue
  if not active or not line or line.endswith(':') or line.lower().startswith(('include ','assert ','db ')): continue
  out.append(norm(line))
 return out
def main():
 candidates=[Path(x) for x in sys.argv[1:]]+[ROOT/'baserom.gbc',Path('/mnt/data/baserom.gbc')]
 rompath=next((x for x in candidates if x.is_file()),None)
 if not rompath: raise SystemExit('[fail] baserom.gbc not found')
 rom=rompath.read_bytes(); whole=b''.join(rom_chunk(rom,s,e) for s,e in RANGES[:1])
 s,e=0x4000,0x4551; full=rom_chunk(rom,s,e)
 if hashlib.sha1(full).hexdigest()!=EXPECTED_SHA1: raise SystemExit('[fail] early Bank $0B retail range SHA-1 mismatch')
 table=rom_chunk(rom,*TABLE); src=SRC.read_text().lower()
 want=' '.join(f'${b:02x}' for b in table)
 data=[]
 in_table=False
 for raw in SRC.read_text().splitlines():
  l=raw.split(';',1)[0].strip().lower()
  if 'romx[$4078]' in l: in_table=True; continue
  if in_table and l.startswith('section '): in_table=False
  if in_table and l.startswith('db '): data += [int(x.strip().replace('$',''),16) for x in l[3:].split(',')]
 if bytes(data)!=table: raise SystemExit('[fail] $4078-$4087 data table differs from retail')
 exp,act=expected(rom),actual()
 if exp!=act:
  for i,(a,b) in enumerate(zip(act,exp)):
   if a!=b: raise SystemExit(f"[fail] instruction {i}: source '{a}' != retail '{b}'")
  raise SystemExit(f'[fail] instruction count source={len(act)} retail={len(exp)}')
 print(f'[ok] Bank $0B:$4000-$4550 retail SHA-1 {EXPECTED_SHA1}')
 print(f'[ok] mnemonic source matches all {len(exp)} decoded executable instructions')
 print('[ok] $4078-$4087 remains a byte-exact 16-byte data table')
 print('[ok] no raw db executable bytes remain in $4000-$4550')
if __name__=='__main__': main()
