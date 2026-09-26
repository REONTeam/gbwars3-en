include "macros/macros.inc"
include "constants/unit_constants.inc"

; ROM0 map-coordinate helpers used by the phase-analysis search paths.
section "Map Grid Base Tile Reader", rom0[$0985]
MapGrid_GetBaseTileAtCoordinates::
    ldh a, [hWRAMBank]
    push af
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call $15f8
    ld h, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, h
    and $3f
    ret

    assert @ == $099b

section "Terrain Name Index ROM0", rom0[$099b]
Terrain_GetNameIndexROM0::
    ld hl, TerrainNameIndexByMapTile
    add l
    ld l, a
    ld a, h
    adc 0
    ld h, a
    ld a, [hl]
    ret

    assert @ == $09a6

section "Map Record Prefix Loader", rom0[$28a0]

; Load the fixed map-record prefix selected in wMapRecordFarPointer into WRAM.
; The copied prefix is exactly 46 bytes:
;   32-byte header + 8-byte name + 4 map fields + width + height.
; Retail then normalizes NUL bytes in the copied display name to spaces.
MapRecord_LoadPrefix::
    push bc
    push de
    push hl
    ldh a, [hROMBank]
    push af

    ld a, [wMapRecordFarPointer]
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, [wMapRecordFarPointer + 1]
    ld e, a
    ld a, [wMapRecordFarPointer + 2]
    ld d, a
    ld hl, wMapRecordBuffer
    ld bc, MAP_RECORD_PREFIX_SIZE
    call Memcpy

    ld hl, wMapRecordName
    ld c, MAP_RECORD_NAME_SIZE
.normalize_name
    ld a, [hl]
    and a
    jr nz, .next_name_byte
    ld a, $20
    ld [hl], a
.next_name_byte
    inc hl
    dec c
    jr nz, .normalize_name

    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    pop hl
    pop de
    pop bc
    ret

section "8-bit Multiply", rom0[$2995]

; Multiply unsigned A by unsigned B. Returns the 16-bit product in HL while
; preserving BC and DE.
MultiplyAByB::
    push bc
    push de
    ld hl, 0
    ld e, b
    ld d, 0
    ld b, 8
.loop
    rrca
    jr nc, .no_add
    add hl, de
.no_add
    sla e
    rl d
    dec b
    jr nz, .loop
    pop de
    pop bc
    ret

section "Add A to HL", rom0[$29bc]

; Add unsigned 8-bit A to HL.
AddAtoHL::
    add l
    ld l, a
    ld a, h
    adc 0
    ld h, a
    ret

section "Bitfield Test", rom0[$3ac7]

; Test bit A in the bitfield beginning at HL.
; Returns A = selected byte AND mask; Z is set when the bit is clear.
Bitfield_Test::
    push bc
    push hl
    call Bitfield_GetAddressAndMask
    ld a, [hl]
    and c
    pop hl
    pop bc
    ret

section "Bitfield Set", rom0[$3ad1]

; Set bit A in the bitfield beginning at HL.
Bitfield_Set::
    push bc
    push hl
    call Bitfield_GetAddressAndMask
    ld a, [hl]
    or c
    ld [hl], a
    pop hl
    pop bc
    ret

section "Bitfield Clear", rom0[$3adc]

; Clear bit A in the bitfield beginning at HL.
Bitfield_Clear::
    push bc
    push hl
    call Bitfield_GetAddressAndMask
    ld a, c
    cpl
    ld b, [hl]
    and b
    ld [hl], a
    pop hl
    pop bc
    ret

section "Bitfield Address and Mask", rom0[$3ae9]

; Resolve bit index A against a bitfield base in HL.
; Returns HL = byte address and C = one-bit mask. B is scratch.
Bitfield_GetAddressAndMask::
    ld b, a
    srl a
    srl a
    srl a
    add l
    ld l, a
    ld a, h
    adc 0
    ld h, a
    ld a, b
    and 7
    ld b, a
    ld c, 1
.loop
    ld a, b
    and a
    jr z, .done
    dec b
    sla c
    jr .loop
.done
    ret

; Convert map-grid coordinate B/C to the 2x2 BG-map cell used by the
; gameplay map renderer. The visible map wraps within the $9800 tilemap.
section "Map Screen Tilemap Coordinate", rom0[$15dd]
MapScreenTilemapCoord::
    ld a, c
    and $0f
    rrca
    rrca
    ld l, a
    and $0f
    add $98
    ld h, a
    ld a, l
    and $f0
    ld l, a
    ld a, b
    and $0f
    rlca
    add l
    ld l, a
    ld a, c
    and 1
    add l
    ld l, a
    ret

    assert @ == $15f8

; B = X coordinate, C = Y coordinate within the 64-byte-stride map grid.
; Returns HL = WRAM bank 1 $D000 + Y * $40 + X.
section "Map Grid Coordinate", rom0[$15f8]
MapGridCoord::
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add $d0
    ld h, a
    ld a, l
    and $f0
    add b
    ld l, a
    ret

    assert @ == $1607

; Return the 8-byte definition for metatile index A. Each definition contains
; four tile/attribute pairs in TL, TR, BL, BR order.
section "Map Metatile Definition Lookup", rom0[$1607]
MapMetatileDefinition_Get::
    push de
    ld h, 0
    ld l, a
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, MapMetatileDefinitions
    add hl, de
    pop de
    ret

    assert @ == $1614

; Load a variable map body from wMapDataBank:wMapDataPointer. The pointer may
; address ROMX (< $A000) or SRAM (>= $A000); both paths converge on the same
; body decoder. The decoder restores the 46-byte editor/map block, copies the
; width x height terrain rectangle into the 64-byte-stride WRAM grid, then
; applies trailing 3-byte setup records until the $FF terminator.
section "Map Data Body Loader", rom0[$1614]
MapData_LoadBody::
    ld a, [wMapDataPointer]
    ld l, a
    ld a, [wMapDataPointer + 1]
    ld h, a
    cp $a0
    jr nc, .from_sram

    ldh a, [hROMBank]
    push af
    ldh a, [hWRAMBank]
    push af
    ld a, [wMapDataBank]
    ldh [hROMBank], a
    ld [rROMB0], a
    call .decode_body
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

.from_sram
    ldh a, [hROMBank]
    push af
    ldh a, [hWRAMBank]
    push af
    call SRAM_Enable
    ld a, [wMapDataBank]
    call SwitchSRAMBank
    call .decode_body
    call SRAM_Disable
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

.decode_body
    farcall MapGrid_ResetWorkingState
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [wMapPhaseNumber]
    ld [$c884], a
    ld d, h
    ld e, l
    ld hl, $c885
    ld bc, MAP_RECORD_PREFIX_SIZE
    call Memcpy
    ld a, [$c8b1]
    ld [$c989], a
    ld a, [$c8b2]
    ld [$c98a], a
    ld c, $00
.row
    ld b, $00
    call MapGridCoord
.column
    ld a, [de]
    inc de
    ld [hli], a
    inc b
    ld a, [$c989]
    cp b
    jr nz, .column
    inc c
    ld a, [$c98a]
    cp c
    jr nz, .row

    ld a, $02
    ldh [hWRAMBank], a
    ldh [rSVBK], a
.setup_loop
    ld a, [de]
    cp $ff
    jr z, .done
    ld b, a
    inc de
    ld a, [de]
    ld c, a
    inc de
    ld a, [de]
    inc de
    farcall MapUnit_CreateInitial
    jr .setup_loop
.done
    ret

    assert @ == $16b6

; Incremental gameplay-map redraw used by the standard VBlank handler.
; hMapTileUpdateFlags bit 7 marks a pending strip; bits 0/1 select the
; traversal variant. The strip routines stop early when LY reaches $8E and
; preserve the remaining count for the next VBlank.
section "Basic Map Tile Update", rom0[$16b6]
BasicMapTileUpdate::
    ldh a, [hMapTileUpdateFlags]
    bit 7, a
    jr z, .idle
    bit 1, a
    jr nz, .draw_vertical
    bit 0, a
    jr nz, .draw_diagonal
    call MapTileUpdate_DrawHorizontalStrip
    and a
    jr nz, .done
    jr .finished
.draw_vertical
    call MapTileUpdate_DrawVerticalStrip
    and a
    jr nz, .done
    jr .finished
.draw_diagonal
    call MapTileUpdate_DrawDiagonalStrip
    and a
    jr nz, .done
    jr .finished
.finished
    ldh a, [hMapTileUpdateFlags]
    res 7, a
    set 6, a
    ldh [hMapTileUpdateFlags], a
.done
    ret
.idle
    ldh a, [hMapAnimationFlags]
    bit 0, a
    ret z
    call MapTerrainAnimation_Update
    ret

MapTileUpdate_DrawVerticalStrip::
    ldh a, [hVRAMBank]
    push af
    ldh a, [hWRAMBank]
    push af
    ldh a, [hMapTileUpdateX]
    ld b, a
    ldh a, [hMapTileUpdateY]
    ld c, a
    ldh a, [hMapTileUpdateCount]
    ld d, a
.loop
    call MapTile_DrawCell
    ldh a, [rLY]
    cp $8e
    jr c, .save
    inc c
    dec d
    jr nz, .loop
.save
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, c
    ldh [hMapTileUpdateY], a
    ld a, d
    ldh [hMapTileUpdateCount], a
    ret

MapTileUpdate_DrawDiagonalStrip::
    ldh a, [hVRAMBank]
    push af
    ldh a, [hWRAMBank]
    push af
    ldh a, [hMapTileUpdateY]
    ld c, a
    ldh a, [hMapTileUpdateCount]
    ld d, a
.loop
    ldh a, [hMapTileUpdateX]
    ld b, a
    bit 0, c
    jr z, .draw
    dec b
.draw
    call MapTile_DrawCell
    ldh a, [rLY]
    cp $8e
    jr c, .save
    inc c
    dec d
    jr nz, .loop
.save
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, c
    ldh [hMapTileUpdateY], a
    ld a, d
    ldh [hMapTileUpdateCount], a
    ret

MapTileUpdate_DrawHorizontalStrip::
    ldh a, [hVRAMBank]
    push af
    ldh a, [hWRAMBank]
    push af
    ldh a, [hMapTileUpdateX]
    ld b, a
    ldh a, [hMapTileUpdateY]
    ld c, a
    ldh a, [hMapTileUpdateCount]
    ld d, a
.loop
    call MapTile_DrawCell
    ldh a, [rLY]
    cp $8e
    jr c, .save
    inc b
    dec d
    jr nz, .loop
.save
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, b
    ldh [hMapTileUpdateX], a
    ld a, d
    ldh [hMapTileUpdateCount], a
    ret

; Render one logical 16x16 map cell. WRAM bank 1 holds the base terrain byte
; and WRAM bank 2 holds the map overlay byte. The low six terrain bits select
; the base metatile; high terrain bits are rendered as the bottom-right owner
; marker when present. Nonzero overlays select definitions beginning at $34.
MapTile_DrawCell::
    push de
    call MapGridCoord
    ld a, 1
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld d, [hl]
    ld a, 2
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld e, [hl]
    bit 7, e
    jr nz, .overlay_priority
    ld a, d
    and $c0
    jr nz, .owned_terrain
    ld a, e
    and a
    jr nz, .overlay
    ld a, d
    jr .plain_metatile
.overlay
    add $34
.plain_metatile
    call MapTile_WriteMetatile
    pop de
    ret
.owned_terrain
    ld a, e
    and a
    jr nz, .owned_overlay
    ld a, d
    and $3f
    jr .owned_metatile
.owned_overlay
    add $34
    jr .owned_metatile
.overlay_priority
    ld a, e
    and $7f
    jr nz, .priority_overlay
    ld a, d
    and $3f
    jr .priority_metatile
.priority_overlay
    add $34
.priority_metatile
    ld d, 0
.owned_metatile
    call MapTile_WriteMetatileWithOwnerMarker
    xor a
    ldh [rVBK], a
    ld a, d
    rlca
    rlca
    and 3
    add $b4
    ld [hl], a
    ld a, 1
    ldh [rVBK], a
    ld a, $00
    ld [hl], a
    pop de
    ret

; A = map metatile definition ID. Writes all four tile/attribute pairs.
MapTile_WriteMetatile::
    push bc
    push de
    ld e, a
    call MapScreenTilemapCoord
    push hl
    ld h, 0
    ld l, e
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, MapMetatileDefinitions
    add hl, de
    ld b, h
    ld c, l
    pop hl
    xor a
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    ld a, 1
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    push hl
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    xor a
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    ld a, 1
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    pop hl
    ld de, $20
    add hl, de
    ld a, h
    and $9b
    ld h, a
    xor a
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    ld a, 1
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    xor a
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    ld a, 1
    ldh [rVBK], a
    ld a, [bc]
    ld [hl], a
    pop de
    pop bc
    ret

; Same layout as MapTile_WriteMetatile, but leave the bottom-right quadrant
; address in HL so the caller can install the property-owner marker.
MapTile_WriteMetatileWithOwnerMarker::
    push bc
    push de
    ld e, a
    call MapScreenTilemapCoord
    push hl
    ld h, 0
    ld l, e
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, MapMetatileDefinitions
    add hl, de
    ld b, h
    ld c, l
    pop hl
    xor a
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    ld a, 1
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    push hl
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    xor a
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    ld a, 1
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    pop hl
    ld de, $20
    add hl, de
    ld a, h
    and $9b
    ld h, a
    xor a
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    ld a, 1
    ldh [rVBK], a
    ld a, [bc]
    inc bc
    ld [hl], a
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    pop de
    pop bc
    ret

    assert @ == $1899

section "Terrain Name Index By Map Tile", rom0[$18ab]
; Map-grid byte -> Terrain_Name_Strings pointer-table index. This proves the
; natural terrain IDs $20-$2A and maps animated sea variants $2B-$31 to SEA.
TerrainNameIndexByMapTile::
    db $00
    db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b
    db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b
    db $02, $03, $04, $05, $06, $07, $09, $0a, $0b
    db $0c, $0d, $0e, $0f, $10, $11, $12, $13, $14, $15, $16
    db $15, $15, $15, $15, $15, $15, $15
    db $04, $03
TerrainNameIndexByMapTile_End::
    assert TerrainNameIndexByMapTile_End - TerrainNameIndexByMapTile == $34
    assert @ == $18df

; Resolve one of the six neighboring hex coordinates around B/C. E selects the
; direction 0-5. The table differs for even/odd rows. Returns B/C = candidate
; coordinate and carry set when the result lies outside the active map bounds.
section "Hex Grid Neighbor Coordinate", rom0[$28d9]
HexGrid_GetNeighborCoord::
    ld a, c
    and $01
    add a, a
    add a, a
    add a, a
    add a, a
    add e
    add e
    ld hl, .offsets
    add l
    ld l, a
    ld a, h
    adc 0
    ld h, a
    ld a, [hli]
    add b
    ld b, a
    ld a, [hl]
    add c
    ld c, a
    ld a, [wMapGridWidth]
    dec a
    cp b
    ret c
    ld a, [wMapGridHeight]
    dec a
    cp c
    ret

.offsets:
    db -1, -1,  0, -1, -1, 0,  1, 0, -1, 1,  0, 1,  0, 0,  0, 0
    db  0, -1,  1, -1, -1, 0,  1, 0,  0, 1,  1, 1,  0, 0,  0, 0

    assert @ == $291d

; Hex-grid distance helper used by map-control candidate searches and other
; coordinate ranking paths. B/C and D/E are two map coordinates; A returns
; the hex distance. All input register pairs are preserved.
section "Hex Grid Distance", rom0[$291d]
HexGrid_GetDistance::
    push bc
    push de
    push hl
    ld a, d
    cp b
    jr nc, .ordered_x
    ld a, b
    ld b, d
    ld d, a
    ld a, c
    ld c, e
    ld e, a
.ordered_x
    ld a, d
    sub b
    ld h, a
    ld a, e
    sub c
    call AbsA
    ld l, a
    srl a
    cp h
    jr nc, .vertical_dominates
    cpl
    inc a
    add h
    add l
    bit 0, l
    jr z, .done
    rrc c
    sbc 0
    jr .done
.vertical_dominates
    ld a, l
.done
    pop hl
    pop de
    pop bc
    ret

    assert @ == $294b

; Convert an unsigned byte in A to packed two-digit BCD. Values used by the
; move-status overlay are HP and fuel and therefore fit in the two decimal
; digits represented by the helper. B and C are preserved.
section "Byte to packed BCD", rom0[$297e]
Number_ByteToPackedBCD::
    push bc
    ld b, 0
.tens
    sub 10
    jr c, .done_tens
    inc b
    jr .tens
.done_tens
    add 10
    swap b
    or b
    pop bc
    ret

    assert @ == $298f

section "Absolute A", rom0[$298f]
AbsA::
    bit 7, a
    ret z
    cpl
    inc a
    ret

    assert @ == $2995

section "Base Map Metatile Definitions", rom0[$1c6c]
MapMetatileDefinitions::
    ; $00
    map_metatile $00, $01, $00, $01, $00, $01, $00, $01
    ; $01
    map_metatile $01, $05, $02, $05, $03, $05, $04, $05
    ; $02
    map_metatile $05, $05, $06, $05, $07, $05, $08, $05
    ; $03
    map_metatile $09, $05, $0a, $05, $0b, $05, $0c, $05
    ; $04
    map_metatile $0d, $05, $0e, $05, $0f, $05, $10, $05
    ; $05
    map_metatile $11, $05, $12, $05, $13, $05, $14, $05
    ; $06
    map_metatile $15, $05, $16, $05, $17, $05, $18, $05
    ; $07
    map_metatile $19, $05, $1a, $05, $1b, $05, $1c, $05
    ; $08
    map_metatile $1d, $05, $1e, $05, $1f, $05, $20, $05
    ; $09
    map_metatile $21, $05, $22, $05, $23, $05, $24, $05
    ; $0A
    map_metatile $25, $05, $26, $05, $27, $05, $28, $05
    ; $0B
    map_metatile $29, $05, $2a, $05, $2b, $05, $2c, $05
    ; $0C
    map_metatile $01, $03, $02, $03, $03, $03, $04, $03
    ; $0D
    map_metatile $05, $03, $06, $03, $07, $03, $08, $03
    ; $0E
    map_metatile $09, $03, $0a, $03, $0b, $03, $0c, $03
    ; $0F
    map_metatile $0d, $03, $0e, $03, $0f, $03, $10, $03
    ; $10
    map_metatile $11, $03, $12, $03, $13, $03, $14, $03
    ; $11
    map_metatile $15, $03, $16, $03, $17, $03, $18, $03
    ; $12
    map_metatile $19, $03, $1a, $03, $1b, $03, $1c, $03
    ; $13
    map_metatile $1d, $03, $1e, $03, $1f, $03, $20, $03
    ; $14
    map_metatile $21, $03, $22, $03, $23, $03, $24, $03
    ; $15
    map_metatile $25, $03, $26, $03, $27, $03, $28, $03
    ; $16
    map_metatile $29, $03, $2a, $03, $2b, $03, $2c, $03
    ; $17
    map_metatile $05, $04, $06, $04, $07, $04, $08, $04
    ; $18
    map_metatile $09, $04, $0a, $04, $0b, $04, $0c, $04
    ; $19
    map_metatile $0d, $04, $0e, $04, $0f, $04, $10, $04
    ; $1A
    map_metatile $11, $04, $12, $04, $13, $04, $14, $04
    ; $1B
    map_metatile $15, $04, $16, $04, $17, $04, $18, $04
    ; $1C
    map_metatile $19, $04, $1a, $04, $1b, $04, $1c, $04
    ; $1D
    map_metatile $21, $04, $22, $04, $23, $04, $24, $04
    ; $1E
    map_metatile $25, $04, $26, $04, $27, $04, $28, $04
    ; $1F
    map_metatile $29, $04, $2a, $04, $2b, $04, $2c, $04
MapMetatile_Plain::
    ; $20
    map_metatile $2d, $04, $2e, $04, $2f, $04, $30, $04
MapMetatile_Road::
    ; $21
    map_metatile $31, $03, $32, $03, $33, $03, $34, $03
MapMetatile_Bridge1::
    ; $22
    map_metatile $35, $01, $36, $01, $37, $01, $38, $01
MapMetatile_Bridge2::
    ; $23
    map_metatile $39, $01, $3a, $01, $3b, $01, $3c, $01
MapMetatile_Mountain::
    ; $24
    map_metatile $3d, $02, $3e, $02, $3f, $02, $40, $02
MapMetatile_Wood::
    ; $25
    map_metatile $41, $04, $42, $04, $43, $04, $44, $04
MapMetatile_Wasteland::
    ; $26
    map_metatile $45, $02, $46, $02, $47, $02, $48, $02
MapMetatile_Desert::
    ; $27
    map_metatile $49, $02, $4a, $02, $4b, $02, $4c, $02
MapMetatile_River::
    ; $28
    map_metatile $4d, $06, $4e, $06, $4f, $06, $50, $06
MapMetatile_Sea::
    ; $29
    map_metatile $51, $06, $52, $06, $53, $06, $54, $06
MapMetatile_Shoal::
    ; $2A
    map_metatile $55, $06, $56, $06, $57, $06, $58, $06
    ; $2B
    map_metatile $51, $06, $59, $06, $53, $06, $5a, $06
    ; $2C
    map_metatile $5b, $06, $5c, $06, $53, $06, $5a, $06
    ; $2D
    map_metatile $5e, $06, $5c, $06, $53, $06, $5a, $06
    ; $2E
    map_metatile $5e, $06, $5f, $06, $53, $06, $54, $06
    ; $2F
    map_metatile $5b, $06, $5f, $06, $53, $06, $54, $06
    ; $30
    map_metatile $5d, $06, $52, $06, $53, $06, $54, $06
    ; $31
    map_metatile $5d, $06, $59, $06, $53, $06, $5a, $06
    ; $32
    map_metatile $00, $01, $00, $01, $00, $01, $00, $01
    ; $33
    map_metatile $00, $01, $00, $01, $00, $01, $00, $01
MapMetatileDefinitions_BaseEnd::
    assert MapMetatileDefinitions_BaseEnd - MapMetatileDefinitions == MAP_BASE_METATILE_COUNT * MAP_METATILE_DEFINITION_SIZE
    assert @ == $1e0c

section "Map Overlay Metatile Definitions", rom0[$1e0c]
; Overlay bytes from WRAM bank 2 are added to $34 by MapTile_DrawCell.
; Values $00-$69 correspond exactly to the encoded UnitData type/side byte:
; (UnitData index << 1) | side. $9E is one additional special overlay.
MapMetatileDefinitions_Overlay::
    ; $34: unit 00 empty, side 0 / encoded $00
    map_metatile $00, $09, $00, $09, $00, $09, $00, $09
    ; $35: unit 00 empty, side 1 / encoded $01
    map_metatile $c8, $0e, $c9, $0e, $d8, $0e, $d9, $0e
    ; $36: unit 01 infantry, side 0 / encoded $02
    map_metatile $00, $0d, $01, $0d, $10, $0d, $11, $0d
    ; $37: unit 01 infantry, side 1 / encoded $03
    map_metatile $01, $2b, $00, $2b, $11, $2b, $10, $2b
    ; $38: unit 02 missile_infantry, side 0 / encoded $04
    map_metatile $02, $0d, $03, $0d, $12, $0d, $13, $0d
    ; $39: unit 02 missile_infantry, side 1 / encoded $05
    map_metatile $03, $2b, $02, $2b, $13, $2b, $12, $2b
    ; $3A: unit 03 mercenary_infantry, side 0 / encoded $06
    map_metatile $04, $0d, $05, $0d, $14, $0d, $15, $0d
    ; $3B: unit 03 mercenary_infantry, side 1 / encoded $07
    map_metatile $05, $2b, $04, $2b, $15, $2b, $14, $2b
    ; $3C: unit 04 construction_truck, side 0 / encoded $08
    map_metatile $06, $0d, $07, $0d, $16, $0d, $17, $0d
    ; $3D: unit 04 construction_truck, side 1 / encoded $09
    map_metatile $07, $2b, $06, $2b, $17, $2b, $16, $2b
    ; $3E: unit 05 supply_truck, side 0 / encoded $0A
    map_metatile $08, $0d, $09, $0d, $18, $0d, $19, $0d
    ; $3F: unit 05 supply_truck, side 1 / encoded $0B
    map_metatile $09, $2b, $08, $2b, $19, $2b, $18, $2b
    ; $40: unit 06 supply_truck_s, side 0 / encoded $0C
    map_metatile $0a, $0d, $0b, $0d, $1a, $0d, $1b, $0d
    ; $41: unit 06 supply_truck_s, side 1 / encoded $0D
    map_metatile $0b, $2b, $0a, $2b, $1b, $2b, $1a, $2b
    ; $42: unit 07 transport_truck, side 0 / encoded $0E
    map_metatile $0c, $0d, $0d, $0d, $1c, $0d, $1d, $0d
    ; $43: unit 07 transport_truck, side 1 / encoded $0F
    map_metatile $0d, $2b, $0c, $2b, $1d, $2b, $1c, $2b
    ; $44: unit 08 transport_truck_s, side 0 / encoded $10
    map_metatile $0e, $0d, $0f, $0d, $1e, $0d, $1f, $0d
    ; $45: unit 08 transport_truck_s, side 1 / encoded $11
    map_metatile $0f, $2b, $0e, $2b, $1f, $2b, $1e, $2b
    ; $46: unit 09 combat_buggy, side 0 / encoded $12
    map_metatile $20, $0d, $21, $0d, $30, $0d, $31, $0d
    ; $47: unit 09 combat_buggy, side 1 / encoded $13
    map_metatile $21, $2b, $20, $2b, $31, $2b, $30, $2b
    ; $48: unit 10 combat_buggy_s, side 0 / encoded $14
    map_metatile $22, $0d, $23, $0d, $32, $0d, $33, $0d
    ; $49: unit 10 combat_buggy_s, side 1 / encoded $15
    map_metatile $23, $2b, $22, $2b, $33, $2b, $32, $2b
    ; $4A: unit 11 combat_vehicle, side 0 / encoded $16
    map_metatile $24, $0d, $25, $0d, $34, $0d, $35, $0d
    ; $4B: unit 11 combat_vehicle, side 1 / encoded $17
    map_metatile $25, $2b, $24, $2b, $35, $2b, $34, $2b
    ; $4C: unit 12 combat_vehicle_s, side 0 / encoded $18
    map_metatile $26, $0d, $27, $0d, $36, $0d, $37, $0d
    ; $4D: unit 12 combat_vehicle_s, side 1 / encoded $19
    map_metatile $27, $2b, $26, $2b, $37, $2b, $36, $2b
    ; $4E: unit 13 apc, side 0 / encoded $1A
    map_metatile $28, $0d, $29, $0d, $38, $0d, $39, $0d
    ; $4F: unit 13 apc, side 1 / encoded $1B
    map_metatile $29, $2b, $28, $2b, $39, $2b, $38, $2b
    ; $50: unit 14 apc_s, side 0 / encoded $1C
    map_metatile $2a, $0d, $2b, $0d, $3a, $0d, $3b, $0d
    ; $51: unit 14 apc_s, side 1 / encoded $1D
    map_metatile $2b, $2b, $2a, $2b, $3b, $2b, $3a, $2b
    ; $52: unit 15 rocket_launcher, side 0 / encoded $1E
    map_metatile $2c, $0d, $2d, $0d, $3c, $0d, $3d, $0d
    ; $53: unit 15 rocket_launcher, side 1 / encoded $1F
    map_metatile $2d, $2b, $2c, $2b, $3d, $2b, $3c, $2b
    ; $54: unit 16 rocket_launcher_s, side 0 / encoded $20
    map_metatile $2e, $0d, $2f, $0d, $3e, $0d, $3f, $0d
    ; $55: unit 16 rocket_launcher_s, side 1 / encoded $21
    map_metatile $2f, $2b, $2e, $2b, $3f, $2b, $3e, $2b
    ; $56: unit 17 anti_air_tank, side 0 / encoded $22
    map_metatile $40, $0d, $41, $0d, $50, $0d, $51, $0d
    ; $57: unit 17 anti_air_tank, side 1 / encoded $23
    map_metatile $41, $2b, $40, $2b, $51, $2b, $50, $2b
    ; $58: unit 18 mercenary_anti_air_missiles, side 0 / encoded $24
    map_metatile $42, $0d, $43, $0d, $52, $0d, $53, $0d
    ; $59: unit 18 mercenary_anti_air_missiles, side 1 / encoded $25
    map_metatile $43, $2b, $42, $2b, $53, $2b, $52, $2b
    ; $5A: unit 19 anti_air_missiles, side 0 / encoded $26
    map_metatile $44, $0d, $45, $0d, $54, $0d, $55, $0d
    ; $5B: unit 19 anti_air_missiles, side 1 / encoded $27
    map_metatile $45, $2b, $44, $2b, $55, $2b, $54, $2b
    ; $5C: unit 20 anti_air_missiles_s, side 0 / encoded $28
    map_metatile $46, $0d, $47, $0d, $56, $0d, $57, $0d
    ; $5D: unit 20 anti_air_missiles_s, side 1 / encoded $29
    map_metatile $47, $2b, $46, $2b, $57, $2b, $56, $2b
    ; $5E: unit 21 artillery, side 0 / encoded $2A
    map_metatile $48, $0d, $49, $0d, $58, $0d, $59, $0d
    ; $5F: unit 21 artillery, side 1 / encoded $2B
    map_metatile $49, $2b, $48, $2b, $59, $2b, $58, $2b
    ; $60: unit 22 artillery_s, side 0 / encoded $2C
    map_metatile $4a, $0d, $4b, $0d, $5a, $0d, $5b, $0d
    ; $61: unit 22 artillery_s, side 1 / encoded $2D
    map_metatile $4b, $2b, $4a, $2b, $5b, $2b, $5a, $2b
    ; $62: unit 23 ifv, side 0 / encoded $2E
    map_metatile $4c, $0d, $4d, $0d, $5c, $0d, $5d, $0d
    ; $63: unit 23 ifv, side 1 / encoded $2F
    map_metatile $4d, $2b, $4c, $2b, $5d, $2b, $5c, $2b
    ; $64: unit 24 ifv_s, side 0 / encoded $30
    map_metatile $4e, $0d, $4f, $0d, $5e, $0d, $5f, $0d
    ; $65: unit 24 ifv_s, side 1 / encoded $31
    map_metatile $4f, $2b, $4e, $2b, $5f, $2b, $5e, $2b
    ; $66: unit 25 tank_destroyer, side 0 / encoded $32
    map_metatile $60, $0d, $61, $0d, $70, $0d, $71, $0d
    ; $67: unit 25 tank_destroyer, side 1 / encoded $33
    map_metatile $61, $2b, $60, $2b, $71, $2b, $70, $2b
    ; $68: unit 26 tank_destroyer_s, side 0 / encoded $34
    map_metatile $62, $0d, $63, $0d, $72, $0d, $73, $0d
    ; $69: unit 26 tank_destroyer_s, side 1 / encoded $35
    map_metatile $63, $2b, $62, $2b, $73, $2b, $72, $2b
    ; $6A: unit 27 tank, side 0 / encoded $36
    map_metatile $64, $0d, $65, $0d, $74, $0d, $75, $0d
    ; $6B: unit 27 tank, side 1 / encoded $37
    map_metatile $65, $2b, $64, $2b, $75, $2b, $74, $2b
    ; $6C: unit 28 mercenary_tank, side 0 / encoded $38
    map_metatile $66, $0d, $67, $0d, $76, $0d, $77, $0d
    ; $6D: unit 28 mercenary_tank, side 1 / encoded $39
    map_metatile $67, $2b, $66, $2b, $77, $2b, $76, $2b
    ; $6E: unit 29 fighter_plane_a, side 0 / encoded $3A
    map_metatile $68, $0d, $69, $0d, $78, $0d, $79, $0d
    ; $6F: unit 29 fighter_plane_a, side 1 / encoded $3B
    map_metatile $69, $2b, $68, $2b, $79, $2b, $78, $2b
    ; $70: unit 30 fighter_plane_b, side 0 / encoded $3C
    map_metatile $6a, $0d, $6b, $0d, $7a, $0d, $7b, $0d
    ; $71: unit 30 fighter_plane_b, side 1 / encoded $3D
    map_metatile $6b, $2b, $6a, $2b, $7b, $2b, $7a, $2b
    ; $72: unit 31 fighter_plane_s, side 0 / encoded $3E
    map_metatile $6c, $0d, $6d, $0d, $7c, $0d, $7d, $0d
    ; $73: unit 31 fighter_plane_s, side 1 / encoded $3F
    map_metatile $6d, $2b, $6c, $2b, $7d, $2b, $7c, $2b
    ; $74: unit 32 attack_plane_a, side 0 / encoded $40
    map_metatile $6e, $0d, $6f, $0d, $7e, $0d, $7f, $0d
    ; $75: unit 32 attack_plane_a, side 1 / encoded $41
    map_metatile $6f, $2b, $6e, $2b, $7f, $2b, $7e, $2b
    ; $76: unit 33 attack_plane_b, side 0 / encoded $42
    map_metatile $80, $0d, $81, $0d, $90, $0d, $91, $0d
    ; $77: unit 33 attack_plane_b, side 1 / encoded $43
    map_metatile $81, $2b, $80, $2b, $91, $2b, $90, $2b
    ; $78: unit 34 attack_plane_s, side 0 / encoded $44
    map_metatile $82, $0d, $83, $0d, $92, $0d, $93, $0d
    ; $79: unit 34 attack_plane_s, side 1 / encoded $45
    map_metatile $83, $2b, $82, $2b, $93, $2b, $92, $2b
    ; $7A: unit 35 bomber, side 0 / encoded $46
    map_metatile $84, $0d, $85, $0d, $94, $0d, $95, $0d
    ; $7B: unit 35 bomber, side 1 / encoded $47
    map_metatile $85, $2b, $84, $2b, $95, $2b, $94, $2b
    ; $7C: unit 36 mercenary_bomber, side 0 / encoded $48
    map_metatile $86, $0d, $87, $0d, $96, $0d, $97, $0d
    ; $7D: unit 36 mercenary_bomber, side 1 / encoded $49
    map_metatile $87, $2b, $86, $2b, $97, $2b, $96, $2b
    ; $7E: unit 37 transport_plane, side 0 / encoded $4A
    map_metatile $88, $0d, $89, $0d, $98, $0d, $99, $0d
    ; $7F: unit 37 transport_plane, side 1 / encoded $4B
    map_metatile $89, $2b, $88, $2b, $99, $2b, $98, $2b
    ; $80: unit 38 refueling_plane, side 0 / encoded $4C
    map_metatile $8a, $0d, $8b, $0d, $9a, $0d, $9b, $0d
    ; $81: unit 38 refueling_plane, side 1 / encoded $4D
    map_metatile $8b, $2b, $8a, $2b, $9b, $2b, $9a, $2b
    ; $82: unit 39 battle_helicopter, side 0 / encoded $4E
    map_metatile $8c, $0d, $8d, $0d, $9c, $0d, $9d, $0d
    ; $83: unit 39 battle_helicopter, side 1 / encoded $4F
    map_metatile $8d, $2b, $8c, $2b, $9d, $2b, $9c, $2b
    ; $84: unit 40 battle_helicopter_s, side 0 / encoded $50
    map_metatile $8e, $0d, $8f, $0d, $9e, $0d, $9f, $0d
    ; $85: unit 40 battle_helicopter_s, side 1 / encoded $51
    map_metatile $8f, $2b, $8e, $2b, $9f, $2b, $9e, $2b
    ; $86: unit 41 anti_sub_helicopter, side 0 / encoded $52
    map_metatile $a0, $0d, $a1, $0d, $b0, $0d, $b1, $0d
    ; $87: unit 41 anti_sub_helicopter, side 1 / encoded $53
    map_metatile $a1, $2b, $a0, $2b, $b1, $2b, $b0, $2b
    ; $88: unit 42 transport_helicopter, side 0 / encoded $54
    map_metatile $a2, $0d, $a3, $0d, $b2, $0d, $b3, $0d
    ; $89: unit 42 transport_helicopter, side 1 / encoded $55
    map_metatile $a3, $2b, $a2, $2b, $b3, $2b, $b2, $2b
    ; $8A: unit 43 transport_helicopter_s, side 0 / encoded $56
    map_metatile $a4, $0d, $a5, $0d, $b4, $0d, $b5, $0d
    ; $8B: unit 43 transport_helicopter_s, side 1 / encoded $57
    map_metatile $a5, $2b, $a4, $2b, $b5, $2b, $b4, $2b
    ; $8C: unit 44 aegis_warship, side 0 / encoded $58
    map_metatile $a6, $0d, $a7, $0d, $b6, $0d, $b7, $0d
    ; $8D: unit 44 aegis_warship, side 1 / encoded $59
    map_metatile $a7, $2b, $a6, $2b, $b7, $2b, $b6, $2b
    ; $8E: unit 45 mercenary_missile_frigate, side 0 / encoded $5A
    map_metatile $a8, $0d, $a9, $0d, $b8, $0d, $b9, $0d
    ; $8F: unit 45 mercenary_missile_frigate, side 1 / encoded $5B
    map_metatile $a9, $2b, $a8, $2b, $b9, $2b, $b8, $2b
    ; $90: unit 46 large_carrier, side 0 / encoded $5C
    map_metatile $aa, $0d, $ab, $0d, $ba, $0d, $bb, $0d
    ; $91: unit 46 large_carrier, side 1 / encoded $5D
    map_metatile $ab, $2b, $aa, $2b, $bb, $2b, $ba, $2b
    ; $92: unit 47 small_carrier, side 0 / encoded $5E
    map_metatile $ac, $0d, $ad, $0d, $bc, $0d, $bd, $0d
    ; $93: unit 47 small_carrier, side 1 / encoded $5F
    map_metatile $ad, $2b, $ac, $2b, $bd, $2b, $bc, $2b
    ; $94: unit 48 transport_ship, side 0 / encoded $60
    map_metatile $ae, $0d, $af, $0d, $be, $0d, $bf, $0d
    ; $95: unit 48 transport_ship, side 1 / encoded $61
    map_metatile $af, $2b, $ae, $2b, $bf, $2b, $be, $2b
    ; $96: unit 49 supply_tanker, side 0 / encoded $62
    map_metatile $c0, $0d, $c1, $0d, $d0, $0d, $d1, $0d
    ; $97: unit 49 supply_tanker, side 1 / encoded $63
    map_metatile $c1, $2b, $c0, $2b, $d1, $2b, $d0, $2b
    ; $98: unit 50 submarine, side 0 / encoded $64
    map_metatile $c2, $0d, $c3, $0d, $d2, $0d, $d3, $0d
    ; $99: unit 50 submarine, side 1 / encoded $65
    map_metatile $c3, $2b, $c2, $2b, $d3, $2b, $d2, $2b
    ; $9A: unit 51 submarine_s, side 0 / encoded $66
    map_metatile $c4, $0d, $c5, $0d, $d4, $0d, $d5, $0d
    ; $9B: unit 51 submarine_s, side 1 / encoded $67
    map_metatile $c5, $2b, $c4, $2b, $d5, $2b, $d4, $2b
    ; $9C: unit 52 dummy, side 0 / encoded $68
    map_metatile $c6, $0d, $c7, $0d, $d6, $0d, $d7, $0d
    ; $9D: unit 52 dummy, side 1 / encoded $69
    map_metatile $c6, $0b, $c7, $0b, $d6, $0b, $d7, $0b
    ; $9E: special overlay; higher-level writer/meaning still unresolved
    map_metatile $c8, $0e, $c9, $0e, $d8, $0e, $d9, $0e
MapMetatileDefinitions_OverlayEnd::
    assert MapMetatileDefinitions_OverlayEnd - MapMetatileDefinitions_Overlay == MAP_OVERLAY_METATILE_COUNT * MAP_METATILE_DEFINITION_SIZE
    assert MapMetatileDefinitions_OverlayEnd - MapMetatileDefinitions == MAP_METATILE_COUNT * MAP_METATILE_DEFINITION_SIZE
    assert @ == $2164
; Periodic map-terrain animation. The 90-frame timer has three 30-frame
; phases. During the first five update slots of each phase it refreshes one
; four-tile group per frame: Bridge 1, Bridge 2, River, Shoal, then Sea.
section "Map Terrain Animation Runtime", rom0[$2164]
MapTerrainAnimation_Reset::
    xor a
    ldh [hMapAnimationFlags], a
    ldh [hMapAnimationTimer], a
    ret

MapTerrainAnimation_Update::
    ldh a, [hMapAnimationTimer]
    inc a
    ldh [hMapAnimationTimer], a
    cp 30
    jr c, .phase0
    cp 60
    jr c, .phase1
    cp 90
    jr nz, .phase2
    xor a
    ldh [hMapAnimationTimer], a
    jp .done
.phase0
    ld b, 0
    jr .select_slot
.phase1
    ld b, 5
    sub 30
    jr .select_slot
.phase2
    ld b, 10
    sub 60
.select_slot
    ld hl, .update_slot_by_frame
    add l
    ld l, a
    ld a, h
    adc 0
    ld h, a
    ld a, [hl]
    and a
    jp z, .done
    dec a
    add b
    ld hl, .update_handlers
    add a
    add l
    ld l, a
    ld a, h
    adc 0
    ld h, a
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp hl

.update_slot_by_frame
    db 0, 1, 2, 3, 4, 5
    ds 24, 0

.update_handlers
    dw .bridge1_phase0, .bridge2_phase0, .river_phase0, .shoal_phase0, .sea_phase0
    dw .bridge1_phase1, .bridge2_phase1, .river_phase1, .shoal_phase1, .sea_phase1
    dw .bridge1_phase2, .bridge2_phase2, .river_phase2, .shoal_phase2, .sea_phase2

.bridge1_phase0
    ld de, MapTerrainAnimation_Bridge1
    ld hl, $9350
    jr .copy_tiles
.bridge1_phase1
    ld de, MapTerrainAnimation_Bridge1 + $40
    ld hl, $9350
    jr .copy_tiles
.bridge1_phase2
    ld de, MapTerrainAnimation_Bridge1 + $80
    ld hl, $9350
    jr .copy_tiles
.bridge2_phase0
    ld de, MapTerrainAnimation_Bridge2
    ld hl, $9390
    jr .copy_tiles
.bridge2_phase1
    ld de, MapTerrainAnimation_Bridge2 + $40
    ld hl, $9390
    jr .copy_tiles
.bridge2_phase2
    ld de, MapTerrainAnimation_Bridge2 + $80
    ld hl, $9390
    jr .copy_tiles
.river_phase0
    ld de, MapTerrainAnimation_River
    ld hl, $94d0
    jr .copy_tiles
.river_phase1
    ld de, MapTerrainAnimation_River + $40
    ld hl, $94d0
    jr .copy_tiles
.river_phase2
    ld de, MapTerrainAnimation_River + $80
    ld hl, $94d0
    jr .copy_tiles
.shoal_phase0
    ld de, MapTerrainAnimation_Shoal
    ld hl, $9550
    jr .copy_tiles
.shoal_phase1
    ld de, MapTerrainAnimation_Shoal + $40
    ld hl, $9550
    jr .copy_tiles
.shoal_phase2
    ld de, MapTerrainAnimation_Shoal + $80
    ld hl, $9550
    jr .copy_tiles
.sea_phase0
    ld de, MapTerrainAnimation_Sea
    ld hl, $9510
    jr .copy_tiles
.sea_phase1
    ld de, MapTerrainAnimation_Sea + $40
    ld hl, $9510
    jr .copy_tiles
.sea_phase2
    ld de, MapTerrainAnimation_Sea + $80
    ld hl, $9510
.copy_tiles
    ldh a, [hVRAMBank]
    push af
    xor a
    ldh [rVBK], a
    ld c, $40
.copy_loop
    ld a, [de]
    ld [hli], a
    inc de
    dec c
    jr nz, .copy_loop
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
.done
    ret

    assert @ == $2273

section "Map Terrain Animation Sea", rom0[$2273]
MapTerrainAnimation_Sea::
    incbin "gfx/environment/map/animations/sea.2bpp"
    assert @ == $2333

section "Map Terrain Animation River", rom0[$2333]
MapTerrainAnimation_River::
    incbin "gfx/environment/map/animations/river.2bpp"
    assert @ == $23f3

section "Map Terrain Animation Bridge 1", rom0[$23f3]
MapTerrainAnimation_Bridge1::
    incbin "gfx/environment/map/animations/bridge1.2bpp"
    assert @ == $24b3

section "Map Terrain Animation Bridge 2", rom0[$24b3]
MapTerrainAnimation_Bridge2::
    incbin "gfx/environment/map/animations/bridge2.2bpp"
    assert @ == $2573

section "Map Terrain Animation Shoal", rom0[$2573]
MapTerrainAnimation_Shoal::
    incbin "gfx/environment/map/animations/shoal.2bpp"
    assert @ == $2633


; callback-driven six-neighbor flood-fill primitives used by the
; map-control movement-cost workspace. The queue itself lives in WRAM bank 7
; at $DE00 and is indexed by the transient HRAM head/tail bytes at $FFA1/$FFA2.
section "Hex Grid Callback Flood Fill", rom0[$0850]
HexGrid_RunCallbackFloodFill::
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, 7
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ldh [$ffa1], a ; queue head
    ldh [$ffa2], a ; queue tail

    ld hl, $ffa3
    call CallIndirectFromPointer
.loop
    ldh a, [$ffa1]
    ld l, a
    ld h, 0
    add hl, hl
    ld a, h
    add $de
    ld h, a
    ld b, [hl]
    inc hl
    ld c, [hl]

    ld hl, $ffa5
    call CallIndirectFromPointer
    ld e, 0
.neighbor_loop
    push bc
    push de
    call HexGrid_GetNeighborCoord
    jr c, .next_neighbor

    ld hl, $ffa7
    call CallIndirectFromPointer
    and a
    jr nz, .next_neighbor

    ld hl, $ffa9
    call CallIndirectFromPointer
    ldh a, [$ffa2]
    ld l, a
    ld h, 0
    add hl, hl
    ld a, h
    add $de
    ld h, a
    ld [hl], b
    inc hl
    ld [hl], c
    ld hl, $ffa2
    inc [hl]

.next_neighbor
    pop de
    pop bc
    inc e
    ld a, e
    cp 6
    jr nz, .neighbor_loop

    ld hl, $ffa1
    inc [hl]
    ldh a, [$ffa2]
    cp [hl]
    jr nz, .loop

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret

    assert @ == $08bb

; HL points at a little-endian callback address. Tail-call that address.
CallIndirectFromPointer::
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp hl
    ret ; unreachable retail byte retained for exact ROM reconstruction

; Store DE as a little-endian word at HL and advance HL by two.
StoreDEAtHL::
    ld [hl], e
    inc hl
    ld [hl], d
    inc hl
    ret

; Append B/C to the WRAM-bank-7 flood-fill queue and advance its tail index.
HexGrid_FloodFillEnqueueBC::
    ldh a, [$ffa2]
    ld l, a
    ld h, 0
    add hl, hl
    ld a, h
    add $de
    ld h, a
    ld [hl], b
    inc hl
    ld [hl], c
    ld hl, $ffa2
    inc [hl]
    ret

; Return the WRAM-bank-1 gameplay-map byte address for B/C in HL.
MapGrid_GetRawTilePointer::
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add $d0
    ld h, a
    ld a, l
    and $f0
    add b
    ld l, a
    ret

; Return a coordinate-indexed plane address in HL. A supplies the plane's
; high-byte base (for example $A0); B/C supply X/Y.
MapGrid_GetPlanePointer::
    ld h, a
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add h
    ld h, a
    ld a, l
    and $f0
    add b
    ld l, a
    ret

    assert @ == $08f5
