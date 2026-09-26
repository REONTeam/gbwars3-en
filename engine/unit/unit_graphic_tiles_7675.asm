include "macros/macros.inc"

; Load the four 8x8 tiles referenced by a map-metatile definition into VRAM.
; The public unit wrapper converts a unit type into the unit-icon metatile
; range; the generic entry accepts a complete metatile-definition index.
;
; UnitGraphic_LoadTiles:
;   a  = unit type
;   hl = VRAM destination
;
; MapMetatile_LoadTiles:
;   a  = metatile-definition index
;   hl = VRAM destination
section "Metatile graphics loader", romx[$7675], bank[$0b]

UnitGraphic_LoadTiles::
    add MAP_UNIT_OVERLAY_METATILE_FIRST

MapMetatile_LoadTiles::
    push bc
    push de
    push hl
    push hl
    push af
    call MapMetatileDefinition_Get
    ld d, h
    ld e, l
    ld b, 4
    pop af
    pop hl
    cp MAP_UNIT_OVERLAY_METATILE_FIRST
    jr nc, .unit_tiles

.terrain_tiles
    ld a, [de]
    inc de
    inc de
    call .copy_terrain_tile
    dec b
    jr nz, .terrain_tiles
    jr .done

.unit_tiles
    ld a, [de]
    inc de
    inc de
    call .copy_unit_tile
    dec b
    jr nz, .unit_tiles

.done
    pop hl
    pop de
    pop bc
    ret

.copy_terrain_tile
    push de
    ld de, MapTerrainTiles
    call .copy_indexed_tile
    pop de
    ret

.copy_unit_tile
    push de
    ld de, Image_Unit_Map_Icons
    call .copy_indexed_tile
    pop de
    ret

.copy_indexed_tile
    push bc
    push hl
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, de
    ld d, h
    ld e, l
    pop hl
    ld bc, 16
    farcall $01, MemcpyWaitLCD
    pop bc
    ret

    assert @ == $76c9
