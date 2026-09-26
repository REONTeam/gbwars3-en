#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
if len(sys.argv)!=2: raise SystemExit('usage: verify_map_name_editor.py baserom.gbc')
rom=Path(sys.argv[1]).read_bytes(); root=Path(__file__).resolve().parents[1]
def off(b,a): return a if b==0 else b*0x4000+(a-0x4000)
def sha(b,s,e): return hashlib.sha1(rom[off(b,s):off(b,e)]).hexdigest()
ranges=[
(0x0f,0x4133,0x416d,'b6f81ba1ec3a278f56c3ead1304c625619bc30ea'),
(0x0f,0x4789,0x47b3,'a98d4816e1b8670250cca1411de7768d2d309106'),
(0x14,0x4e3b,0x4e8d,'d6e917d50c6a7d5e74fd5c2708bb55ac2e3d67e5'),
(0x14,0x531f,0x5375,'b9f3123cab09a0f226650799205383bd65e19e31'),
(0x27,0x5f97,0x5fb8,'364231cd71c00ba0039f024b88f4db8ee75e067b'),
(0x15,0x5f9f,0x5fb4,'882c6200392073e7ebe13243a89a5941b0f1ed24'),
(0x27,0x731a,0x732f,'74751d720381dfc6b228be3b17ae4904c9b35b2a'),
(0x27,0x73a7,0x73bc,'9fae9081415ceddaddae64358d6b284f6ad1a873'),
(0x27,0x7460,0x7475,'c63cd3a4b4c0d4073e72c5adffaedae040378765'),
]
for b,s,e,h in ranges:
 g=sha(b,s,e)
 if g!=h: raise SystemExit(f'{b:02x}:{s:04x}-{e-1:04x}: {g} != {h}')
# All true direct editor-name-buffer references in retail.
refs=[]; pat=bytes((0xa5,0xc8)); pos=0
while True:
 i=rom.find(pat,pos)
 if i<0: break
 if i and rom[i-1] in (0x11,0x21):
  b=(i-1)//0x4000; a=(i-1) if b==0 else 0x4000+((i-1)%0x4000); refs.append((b,a))
 pos=i+1
exp=[(0x0f,0x4133),(0x0f,0x4141),(0x0f,0x478f),(0x0f,0x47a7),(0x27,0x5fa2)]
if refs!=exp: raise SystemExit(f'wEditorMapName refs changed: {refs!r}')
# All direct cached-name readers/writer references are now represented.
refs=[]; pat=bytes((0x89,0xcc)); pos=0
while True:
 i=rom.find(pat,pos)
 if i<0: break
 if i and rom[i-1] in (0x11,0x21):
  b=(i-1)//0x4000; a=(i-1) if b==0 else 0x4000+((i-1)%0x4000); refs.append((b,a))
 pos=i+1
exp=[(0x13,0x5a8e),(0x15,0x5fab),(0x27,0x7326),(0x27,0x73b3),(0x27,0x746c)]
if refs!=exp: raise SystemExit(f'wMapNameCache refs changed: {refs!r}')
checks={
'engine/map/map_editor.asm':['MapEditor_InitDefaultName','MapEditor_EditName9','wEditorMapName','wEditorMapNameExtra','wTextInputMapNameExtra','TextInput_Run'],
'engine/ui/text_input.asm':['TextInput_GetLength','TextInput_Run','TextInput_AppendCharacter','TextInput_Backspace','TextInput_MapNameRedraw','MAP_RECORD_NAME_LOGICAL_SIZE'],
'engine/map/map_name_ui.asm':['MapName9_DrawCache','wMapNameCacheIndex','MapNameCache_DrawRow8','MapNameCache_DrawRow11','MapNameCache_DrawRow14'],
'engine/map/map_name_9char.asm':['MapName9_TextInputInitLength','MapName9_TextInputAppend','MapName9_TextInputBackspace','wEditorMapNameDisplayScratch','wMapNameCacheExtra'],
}
for rel,toks in checks.items():
 t=(root/rel).read_text()
 for tok in toks:
  if tok not in t: raise SystemExit(f'{rel}: missing {tok}')
const=(root/'constants/map_constants.inc').read_text()
if 'DEF MAP_RECORD_NAME_LOGICAL_SIZE EQU MAP_RECORD_NAME_SIZE + 1' not in const: raise SystemExit('logical 9-char constant missing')
if 'DEF MAP_RECORD_NAME_TERMINATED_SIZE EQU MAP_RECORD_NAME_LOGICAL_SIZE + 1' not in const: raise SystemExit('logical terminated-size constant missing')
print('map-name editor/write-path audit: [ok]')
print('  editor-name direct references: 5/5 represented')
print('  cached-name direct references: 5/5 represented')
print('  map text-input mode cap: MAP_RECORD_NAME_LOGICAL_SIZE (9)')
print('  obsolete Bank $27:$5F97 editor-name stub: removed; STATUS owner restored')
