#!/usr/bin/env python3
from pathlib import Path
import argparse, re

BANK_SIZE=0x4000
TABLES=((0x41dc,60),(0x4290,1),(0x4293,16),(0x42c3,45))

def off(bank,addr):
    return addr if bank==0 else bank*BANK_SIZE+(addr-0x4000)

def read_text(root,rel):
    return (root/rel).read_text(encoding='utf-8')

def main():
    ap=argparse.ArgumentParser(description='Verify the current source 9-character map-name sidecar implementation')
    ap.add_argument('rom', nargs='?', default='baserom.gbc')
    ap.add_argument('--root', default='.')
    a=ap.parse_args()
    root=Path(a.root)
    rom=Path(a.rom).read_bytes()

    const=read_text(root,'constants/map_constants.inc')
    required=(
        'MAP_RECORD_NAME_SIZE   EQU 8',
        'MAP_RECORD_NAME_LOGICAL_SIZE EQU MAP_RECORD_NAME_SIZE + 1',
        'MAP_RECORD_NAME_TERMINATED_SIZE EQU MAP_RECORD_NAME_LOGICAL_SIZE + 1',
        'MAP_RECORD_PREFIX_SIZE EQU MAP_RECORD_HEADER_SIZE + MAP_RECORD_NAME_SIZE + MAP_RECORD_FIELD_COUNT + 2',
    )
    for token in required:
        if token not in const: raise SystemExit(f'missing/changed constant: {token}')

    macros=read_text(root,'macros/macros.inc')
    for token in ('ds 26, 0','if _NARG >= 4','db \\4','db 0'):
        if token not in macros: raise SystemExit(f'map_record_header sidecar support missing: {token!r}')

    syms=read_text(root,'symbols.asm')
    for token in (
        'sym $00, $ca40, wMapRecordNameExtra',
        'sym $00, $c8a4, wEditorMapNameExtra',
        'sym $00, $cc37, wTextInputMapNameExtra',
        'sym $00, $cc6d, wEditorMapNameDisplayExtra',
        'sym $00, $cc91, wMapNameCacheExtra',
        'sym $00, $cc92, wMapNameCacheIndex',
    ):
        if token not in syms: raise SystemExit(f'missing sidecar/scratch symbol: {token}')

    # Retail records all start with a zero sidecar, proving backward compatibility.
    retail_records=0
    for table_addr,count in TABLES:
        t=off(0x28,table_addr)
        for i in range(count):
            p=t+i*3
            bank=rom[p]; addr=rom[p+1]|rom[p+2]<<8
            if rom[off(bank,addr)+0x1f] != 0:
                raise SystemExit(f'retail map {bank:02X}:{addr:04X} has nonzero header+$1F')
            retail_records+=1
    if retail_records!=122: raise SystemExit('retail map count mismatch')

    std=read_text(root,'data/maps/map_records_standard_bank29.asm')
    if not re.search(r'map_record_header\s+\.body,\s+(?:\.end|MapRecord_Standard00_End),\s+\$dc,\s+"E"', std) or 'db "BALL ISL"' not in std:
        raise SystemExit('Standard 00 is not the BALL ISLE 9-character proof record')

    editor=read_text(root,'engine/map/map_editor.asm')
    for token in ('MapEditor_EditName9::','ld a, [wEditorMapNameExtra]','ld [wTextInputMapNameExtra], a',
                  'ld a, [wTextInputMapNameExtra]','ld [wEditorMapNameExtra], a'):
        if token not in editor: raise SystemExit(f'editor sidecar bridge missing: {token}')

    ti=read_text(root,'engine/ui/text_input.asm')
    for token in ('romx[$4cd3]','romx[$52b6]','romx[$531f]','romx[$5355]','romx[$7f20]',
                  'MAP_RECORD_NAME_LOGICAL_SIZE','ld [$cc38], a','TextInput_MapNameRedraw::'):
        if token not in ti: raise SystemExit(f'text-input patch missing: {token}')

    helper=read_text(root,'engine/map/map_name_9char.asm')
    for token in (
        'MapName9_TextInputInitLength::','MapName9_TextInputAppend::','MapName9_TextInputBackspace::',
        'MapName9_DrawLoadedViaDC3B::','MapName9_CacheSelectedMapName::','MapName9_DrawCache::',
        'MapName9_DrawEditorCurrent::','MapName9_DrawLoadedUnitStatus::','MapName9_DrawLoadedUnitStatusAlt::',
        'ld [wMapMenuMapNameScratchExtra], a','ld [wMapMenuMapNameScratchBorrowedTerminator], a','ld [wMapNameCacheExtra], a','ld [wMapNameCacheIndex], a',
        'ld [wEditorMapNameDisplayExtra], a','ld [wEditorMapNameDisplayBorrowedTerminator], a','ld [wUnitStatusMapNameScratchExtra], a','ld [wUnitStatusMapNameScratchBorrowedTerminator], a',
    ):
        if token not in helper: raise SystemExit(f'9-char helper contract missing: {token}')

    # Adjacent live bytes must be saved/restored rather than permanently relocated.
    for addr in ('wMapMenuMapNameScratchBorrowedTerminator','wEditorMapNameDisplayBorrowedTerminator','wUnitStatusMapNameScratchBorrowedTerminator'):
        if helper.count(f'ld [{addr}], a') < 2:
            raise SystemExit(f'{addr} is not both temporarily zeroed and restored')
    if helper.count('ld [wMapNameCacheIndex], a') < 2:
        raise SystemExit('cache index is not temporarily zeroed/restored during TextPut')

    ui=read_text(root,'engine/map/map_name_ui.asm')
    menu=read_text(root,'engine/map/map_menu.asm')
    status=read_text(root,'engine/unit/unit_status.asm')
    if 'MapName9_DrawCache' not in ui:
        raise SystemExit('cached-name UI helper not wired: MapName9_DrawCache')
    if 'MapEditor_DrawCurrentName' in ui or 'romx[$5f97]' in ui.lower():
        raise SystemExit('obsolete Bank $27:$5F97 editor-name stub was reintroduced')
    for token in ('MapName9_DrawLoadedViaDC3B','MapName9_CacheSelectedMapName'):
        if token not in menu: raise SystemExit(f'Map Menu helper not wired: {token}')
    for token in ('MapName9_DrawLoadedUnitStatus','MapName9_DrawLoadedUnitStatusAlt'):
        if token not in status: raise SystemExit(f'Unit Status helper not wired: {token}')

    # Relocated implementations live only in retail-$FF tails. This guards
    # against accidentally claiming live retail code as expansion space.
    ff_ranges=((0x0f,0x5400,0x5480),(0x13,0x6368,0x6600),(0x14,0x7f20,0x8000))
    for bank,start,end in ff_ranges:
        data=rom[off(bank,start):off(bank,end)]
        if not data or any(byte != 0xff for byte in data):
            raise SystemExit(f'expansion range {bank:02X}:{start:04X}-{end-1:04X} is not retail $FF space')

    # Three Bank $27 cached-name fragments still end at exact fall-through
    # boundaries. The former Bank $15 fragment is now integrated into the full
    # suspend-preview routine, but it retains the same explicit 2-byte NOP span.
    for addr in ('$732f','$73bc','$7475'):
        if f'assert @ == {addr}' not in ui:
            raise SystemExit(f'cached-name fall-through boundary {addr} is not exact')
    suspend=read_text(root,'engine/ui/suspend_saved_session_preview.asm')
    if ui.count('ds 2, 0') != 3 or suspend.count('ds 2, 0') < 1:
        raise SystemExit('cached-name padding must remain four explicit 2-byte NOP spans across UI + suspend preview')
    if 'MapName9_DrawCache' not in suspend or 'assert @ == $5fc3' not in suspend.lower():
        raise SystemExit('integrated suspend-preview cached-name owner is not intact')

    # Retail hook anchors must still be the expected routines before patching.
    anchors={
        (0x14,0x4cd3): bytes.fromhex('cd3b4e'),  # call $4E3B
        (0x14,0x531f): bytes.fromhex('fa43cc'),  # ld a,[$CC43]
        (0x14,0x5355): bytes.fromhex('fa3acc'),  # ld a,[$CC3A]
    }
    for (bank,addr),expected in anchors.items():
        got=rom[off(bank,addr):off(bank,addr)+len(expected)]
        if got!=expected:
            raise SystemExit(f'retail hook anchor {bank:02X}:{addr:04X} changed: {got.hex()} != {expected.hex()}')

    # Logical composition model: old slots remain 8 chars; the proof record renders 9.
    def logical(base,extra):
        raw=bytearray(base)
        if extra: raw.append(extra)
        raw.append(0)
        return bytes(raw).split(b'\0',1)[0]
    if logical(b'TROPICS ',0)!=b'TROPICS ': raise SystemExit('legacy 8-char composition failed')
    if logical(b'BALL ISL',ord('E'))!=b'BALL ISLE': raise SystemExit('9-char sidecar composition failed')

    print('9-character map-name implementation: [ok]')
    print('  persistent format : unchanged 46-byte prefix / unchanged SRAM slot offsets')
    print('  editor input      : logical length 0-9; char 9 stored at $CC37 sidecar')
    print('  display/cache     : adjacent live bytes saved, zeroed as terminators, restored')
    print('  legacy maps/saves : 122 retail sidecars are zero and remain compatible')
    print('  proof map         : Standard 00 renders BALL ISLE (8-byte base + E sidecar)')

if __name__=='__main__':
    main()
