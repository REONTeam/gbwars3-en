#!/usr/bin/env python3
from pathlib import Path
import argparse, re

BANK_SIZE = 0x4000
TABLES = ((0x41DC,60),(0x4290,1),(0x4293,16),(0x42C3,45))
HEADER_SIZE = 32
SIDECAR_OFFSET = 31

def off(bank, addr):
    return addr if bank == 0 else bank * BANK_SIZE + (addr - 0x4000)

def direct_refs(rom, address):
    # LR35902 instructions with a literal 16-bit immediate/address operand.
    ops = {0x01,0x11,0x21,0x31,0x08,0xEA,0xFA}
    pat = bytes((address & 0xff, address >> 8))
    hits=[]; pos=0
    while True:
        i=rom.find(pat,pos)
        if i < 0: break
        if i and rom[i-1] in ops:
            pc=i-1; bank=pc//BANK_SIZE
            addr=pc if bank==0 else 0x4000+(pc%BANK_SIZE)
            hits.append((bank,addr,rom[i-1]))
        pos=i+1
    return hits

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('rom', nargs='?', default='baserom.gbc')
    args=ap.parse_args()
    root=Path(__file__).resolve().parents[1]
    rom=Path(args.rom).read_bytes()

    # All retail ROM map records reserve header byte $1F as zero.
    count=0
    for table_addr,n in TABLES:
        t=off(0x28,table_addr)
        for i in range(n):
            p=t+i*3
            bank=rom[p]; addr=rom[p+1]|rom[p+2]<<8
            h=off(bank,addr)
            if rom[h+SIDECAR_OFFSET] != 0:
                raise SystemExit(f'map {bank:02X}:{addr:04X} header+$1F is {rom[h+SIDECAR_OFFSET]:02X}, expected 00')
            count += 1
    if count != 122: raise SystemExit(f'expected 122 records, got {count}')

    # The proposed runtime/editor sidecar bytes are not directly addressed by retail code.
    for addr,name in ((0xCA40,'wMapRecordNameExtra'),(0xC8A4,'wEditorMapNameExtra')):
        hits=direct_refs(rom,addr)
        if hits:
            desc=', '.join(f'{b:02X}:{a:04X}' for b,a,_ in hits)
            raise SystemExit(f'{name} ${addr:04X} has direct retail references: {desc}')

    const=(root/'constants/map_constants.inc').read_text()
    for token in ('MAP_RECORD_NAME_EXTRA_HEADER_OFFSET EQU MAP_RECORD_HEADER_SIZE - 1',
                  'MAP_RECORD_NAME_LEGACY_SIZE EQU 8'):
        if token not in const: raise SystemExit(f'missing constant: {token}')
    syms=(root/'symbols.asm').read_text()
    for token in ('sym $00, $ca40, wMapRecordNameExtra','sym $00, $c8a4, wEditorMapNameExtra'):
        if token not in syms: raise SystemExit(f'missing sidecar symbol: {token}')

    # Existing editor creation zeros the whole header, and SRAM serialization/deserialization
    # preserve the complete prefix; therefore legacy slots naturally present sidecar=0.
    editor=(root/'engine/map/map_editor.asm').read_text()
    if not re.search(r'ld hl, wEditorMapRecordBuffer\s+ld bc, MAP_RECORD_HEADER_SIZE\s+xor a\s+call Memset', editor):
        raise SystemExit('editor no longer proves zero-filled 32-byte header')
    sram=(root/'engine/map/map_sram.asm').read_text()
    home=(root/'engine/home/home_map.asm').read_text()
    if 'ld de, $c885' not in sram or 'ld bc, $002e' not in sram:
        raise SystemExit('SRAM serializer no longer copies the complete 46-byte editor prefix')
    if 'MAP_RECORD_PREFIX_SIZE' not in home:
        raise SystemExit('common ROM/SRAM map body loader no longer uses the complete prefix size')

    print('map-name sidecar migration audit: [ok]')
    print('  122/122 retail map records: header+$1F == $00')
    print('  proposed sidecars: $CA40 and $C8A4 have no direct retail code references')
    print('  editor fresh-map path zero-fills the full header')
    print('  SRAM path preserves the 46-byte prefix, including header+$1F')
    print('  result: ninth character can be sidecar-stored without moving fields/terrain/save offsets')

if __name__ == '__main__':
    main()
