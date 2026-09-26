include "macros/macros.inc"

; Shared property-state presentation layer.  The setup path prepares a three-row
; lower-screen window for the property at B/C, including the property metatile,
; localized property name, ownership palette, and a segmented state meter.
;
; The generic segmented-meter helpers are also used by the infrared UI.  They
; are kept neutral here instead of being named only for capture/development.

DEF wPropertyStateMeterMapTileId   EQU $c9a7
DEF wPropertyStateMeterInitialValue EQU $c9a8

section "Property State Meter Setup", romx[$571b], bank[$0c]

; B/C = property map coordinates.
; Returns A = 0 after the meter/window is prepared, or $FF when no property
; state record exists at B/C.
PropertyStateMeter_Setup::
    push bc
    push de
    call PropertyState_GetAtCoordinates
    cp $ff
    jp z, .done
    ld [wPropertyStateMeterInitialValue], a

    farcall $0b, MapTile_GetBaseIdAtCoordinates
    ld [wPropertyStateMeterMapTileId], a

    ld a, $03
    farcall $0b, Vram_ClearPanelRowsBothBanks

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $8d00
    ld de, PropertyStateMeterGraphics
    ld bc, $0130
    call MemcpyWaitLCD

    ld hl, PropertyStateMeterOwnershipPalettes
    ld a, [wPropertyStateMeterMapTileId]
    cp MAP_TILE_SIDE1_PROPERTY_FIRST
    jr c, .palette_ready
    ld bc, $0008
    add hl, bc
    cp MAP_TILE_NEUTRAL_PROPERTY_FIRST
    jr c, .palette_ready
    add hl, bc
.palette_ready
    ld a, $07
    ld b, $01
    call Vram_SetPals
    ld bc, $8000
    call Vram_ApplySelectedPals

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $8c00
    ld a, [wPropertyStateMeterMapTileId]
    farcall $0b, MapMetatile_LoadTiles

    ld hl, $9c20
    ld a, [wPropertyStateMeterMapTileId]
    ld d, a
    ld b, $00
    ld c, $03
    ld a, $c0
    farcall $0b, MapMetatile_DrawTilemap

    ld a, [wPropertyStateMeterMapTileId]
    farcall $0b, Terrain_GetNameIndex
    ld hl, Property_Name_Strings
    call WordTable_Get
    ld bc, $0320
    call TextPut

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [wPropertyStateMeterMapTileId]
    farcall $0b, Terrain_GetNameIndex
    call PropertyState_GetMaximumForTerrainClass
    ld b, a
    ld c, $01
.meter_width_loop
    inc c
    inc c
    ld a, b
    sub $05
    ld b, a
    jr c, .meter_width_ready
    jr nz, .meter_width_loop
.meter_width_ready
    ld b, $00
    ld de, PropertyStateMeterFrameTileTemplate
    ld hl, $9c23
    call MemcpyWaitLCD

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9c43
    ld bc, $0010
    ld a, $07
    call MemsetWaitLCD

    ld a, [wPropertyStateMeterInitialValue]
    call PropertyStateMeter_DrawValue

    ld a, [wMapGridHeight]
    dec a
    dec a
    ld b, a
    ld a, [wMapActionTargetY]
    cp b
    jr c, .show_window
    farcall $0b, MapCursor_Hide
    call Sprite_Update
    call DelayFrame
.show_window
    ld a, $78
    farcall $0b, LCDScanlineTransition_RunToTarget
    xor a
.done
    pop de
    pop bc
    ret

    assert @ == $57fa

; $57FA-$57FB are two retail bytes with no proven consumer.  They intentionally
; remain inherited from the base ROM rather than being absorbed by proximity.

section "Property State Meter Frame Tile Template", romx[$57fc], bank[$0c]

; Variable-width top-row tile template copied according to maximum / 5.
; The setup routine copies at most the first 17 bytes; the final zero is the
; retail trailing byte immediately before the renderer entry.
PropertyStateMeterFrameTileTemplate::
    db $d8, $d9, $d8, $da, $db, $dc, $dd, $de, $db
    db $df, $dd, $e0, $db, $e1, $dd, $e2, $db, $00

    assert @ == $580e

section "Property State and Segmented Meter Renderer", romx[$580e], bank[$0c]

; A = property-state value.  Uses the property tile selected by Setup to obtain
; the terrain-specific maximum, then draws the meter at the fixed window row.
PropertyStateMeter_DrawValue::
    push bc
    push de
    ld d, a
    ld a, [wPropertyStateMeterMapTileId]
    farcall $0b, Terrain_GetNameIndex
    call PropertyState_GetMaximumForTerrainClass
    ld b, a
    ld a, d
    ld c, $d0
    ld hl, $9c43
    call SegmentedMeter_Draw
    pop de
    pop bc
    ret

; HL = VRAM destination.  Copy the eight generic fill-pattern tiles shared by
; property-state and infrared meters.
SegmentedMeter_LoadGraphics::
    push bc
    push de
    ld de, PropertyStateMeterGraphics
    ld bc, $0080
    call MemcpyWaitLCD
    pop de
    pop bc
    ret

; A = current value, B = maximum (a positive multiple of five),
; C = base tile ID, HL = destination tilemap address.
; Draws maximum/5 two-tile segments using fill states 0..5.
SegmentedMeter_Draw::
    push bc
    push de
    push hl
    ld d, a
    push hl
    ld e, $00
.count_segments
    inc e
    ld a, b
    sub $05
    ld b, a
    jr c, .count_segments
    jr nz, .count_segments
    pop hl

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
.draw_segment
    ld a, d
    sub $05
    jr nc, .full_segment
    ld a, d
    ld d, $00
    jr .have_fill
.full_segment
    ld d, a
    ld a, $05
.have_fill
    push hl
    add a, a
    ld hl, SegmentedMeterFillTilePairs
    call AddAtoHL
    ld a, [hli]
    ld b, [hl]
    pop hl
    add a, c
    call Vram_PutWaitBlank
    inc hl
    ld a, b
    add a, c
    call Vram_PutWaitBlank
    inc hl
    dec e
    jr nz, .draw_segment
    pop hl
    pop de
    pop bc
    ret

; Two tile offsets for each fill amount from 0 through 5.
SegmentedMeterFillTilePairs::
    db $00, $04
    db $01, $04
    db $02, $04
    db $03, $05
    db $03, $06
    db $03, $07

    assert @ == $5883

section "Property State Meter Graphics", romx[$59fb], bank[$0c]

PropertyStateMeterGraphics::
    INCBIN "gfx/ui/property_state_meter.2bpp"

    assert @ == $5b2b

section "Property State Meter Ownership Palettes", romx[$5b2b], bank[$0c]

; Four-color BGR555 palettes selected by raw property ownership range:
; side 0, side 1, then neutral property/ruins.
PropertyStateMeterOwnershipPalettes::
    dw $0000, $004e, $7fff, $009c
    dw $0000, $24e7, $7fff, $45cd
    dw $0000, $0280, $7fff, $03ec

    assert @ == $5b43
