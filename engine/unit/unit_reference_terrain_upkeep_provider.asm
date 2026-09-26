include "macros/macros.inc"

; Selected-terrain detail and upkeep pages used by the Unit Reference UI.
; The terrain descriptor table maps the 46 retail map-tile IDs to the
; terrain-graphics index, description/list index, and side/palette selector.

DEF wUnitReferenceSide                    EQU $cd78
DEF wUnitReferenceCurrentType             EQU $d9ba
DEF wUnitReferenceMovementTerrainIndex    EQU $d9ce
DEF wUnitReferenceMovementGridIndex       EQU $d9cf
DEF wUnitReferenceMovementFirstTile       EQU $d9d5
DEF wUnitReferenceMovementMapTile         EQU $d9d6
DEF wUnitReferenceSubmenuScrollOffset     EQU $da40
DEF wUnitReferenceSubmenuItemCount        EQU $da42
DEF wUnitReferenceSubmenuVisibleRows      EQU $da43

section "Unit Reference Selected Terrain Detail Renderer", romx[$7061], bank[$25]

UnitReference_DrawSelectedTerrainDetail::
    call UnitReference_SetupScreen
    ld a, $07
    ld b, $01
    ld hl, $6c9a
    ld c, $15
    call Vram_SetFarPals
    ld a, $01
    ld b, $06
    ld hl, $5868
    ld c, $01
    call Vram_SetFarPals
    call Vram_ApplyPals
    ld a, $0f
    farcall $10, UIWindowStack_SetAttributes
    call UnitReference_DrawScreenFrame
    ld bc, $0003
    call UnitReference_DrawDividerRow
    ld bc, $0003
    ld a, $0f
    ld de, $0101
    ld h, $ee
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $af
    ld bc, $1303
    ld b, $13
    ld de, $0101
    ld h, $ee
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0103
    call Vram_TilemapCoord
    ld a, $0f
    ld bc, $0012
    call MemsetWaitLCD
    call UnitReference_LoadMovementTerrainGraphics
    ld a, [wUnitReferenceMovementTerrainIndex]
    call UnitReference_LoadMovementCellDescriptor
    ld bc, $0101
    call Vram_TilemapCoord
    ld a, [wUnitReferenceMovementMapTile]
    call UnitReference_AdjustIndexPlus11ForSideBelow17
    ld d, a
    ld a, [wUnitReferenceMovementFirstTile]
    ld b, $01
    ld c, $03
    farcall $0b, MapMetatile_DrawTilemap
    ld bc, $0402
    ld hl, UnitStatus_Submenu_Terrain_Def
    call TextPut
    ld a, [wUnitReferenceMovementMapTile]
    farcall $0b, Terrain_GetNameIndex
    farcall $0f, MapEditor_Arrange_CopyTerrainNameToBuffer
    ld hl, $c011
    farcall $18, UnitList_EncodeDisplayValue
    ld hl, $c011
    ld bc, $0401
    call TextPut
    ld a, [wUnitReferenceMovementMapTile]
    farcall $0c, Battle_GetCoverValue
    ld bc, $0c02
    ld d, $02
    call $31f5
    ld a, $0d
    ld [wUnitReferenceSubmenuVisibleRows], a
    xor a
    ld [wUnitReferenceSubmenuScrollOffset], a
    ld a, [wUnitReferenceMovementGridIndex]
    farcall $32, Description_GetTerrainText
    farcall $32, Description_CountLines
    ld a, [wUnitReferenceMovementGridIndex]
    farcall $32, Description_DrawTerrainText
    call UnitReference_CreateScrollArrowsTop2C
    call UnitReference_UpdateSubmenuScrollArrows
    call VBlankFIFO_Process
    ret

    assert @ == $7139

section "Unit Reference Terrain Detail Descriptor Loader", romx[$7142], bank[$25]

; A = terrain descriptor index.
UnitReference_OpenTerrainDetailByDescriptorIndex::
    ld d, a
    ldh a, [$ff82]
    push af
    ld a, $03
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    call UnitReference_LoadTerrainDetailDescriptor
    call UnitReference_OpenSelectedTerrainDetail
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret

UnitReference_LoadTerrainDetailDescriptor::
    ld b, $03
    call MultiplyAByB
    ld bc, UnitReference_TerrainDetailDescriptors
    add hl, bc
    ld a, [hli]
    ld [wUnitReferenceMovementTerrainIndex], a
    ld a, [hli]
    ld [wUnitReferenceMovementGridIndex], a
    ld a, [hl]
    ld [wUnitReferenceSide], a
    ret

    assert @ == $716f

section "Unit Reference Terrain Detail Descriptors", romx[$716f], bank[$25]

; {movement terrain graphics index, description/grid index, side selector}
UnitReference_TerrainDetailDescriptors::
    db $00, $00, $00 ; $00
    db $00, $00, $00 ; $01
    db $03, $01, $00 ; $02
    db $00, $00, $00 ; $03
    db $06, $02, $00 ; $04
    db $00, $00, $00 ; $05
    db $09, $03, $00 ; $06
    db $00, $00, $00 ; $07
    db $12, $06, $00 ; $08
    db $0c, $04, $00 ; $09
    db $00, $00, $00 ; $0a
    db $0f, $05, $00 ; $0b
    db $00, $00, $01 ; $0c
    db $03, $01, $01 ; $0d
    db $00, $00, $01 ; $0e
    db $06, $02, $01 ; $0f
    db $00, $00, $01 ; $10
    db $09, $03, $01 ; $11
    db $00, $00, $01 ; $12
    db $12, $06, $01 ; $13
    db $0c, $04, $01 ; $14
    db $00, $00, $01 ; $15
    db $0f, $05, $01 ; $16
    db $15, $01, $00 ; $17
    db $01, $07, $00 ; $18
    db $16, $02, $00 ; $19
    db $04, $08, $00 ; $1a
    db $17, $03, $00 ; $1b
    db $07, $09, $00 ; $1c
    db $18, $04, $00 ; $1d
    db $0a, $0a, $00 ; $1e
    db $19, $05, $00 ; $1f
    db $0d, $0b, $00 ; $20
    db $08, $10, $00 ; $21
    db $0e, $12, $00 ; $22
    db $0e, $12, $00 ; $23
    db $10, $0c, $00 ; $24
    db $13, $0d, $00 ; $25
    db $02, $0e, $00 ; $26
    db $05, $0f, $00 ; $27
    db $0b, $11, $00 ; $28
    db $14, $14, $00 ; $29
    db $11, $13, $00 ; $2a
    db $11, $13, $00 ; $2b
    db $11, $13, $00 ; $2c
    db $11, $13, $00 ; $2d

    assert @ == $71f9

section "Unit Reference Selected Terrain Detail Controller", romx[$71f9], bank[$25]

UnitReference_OpenSelectedTerrainDetail::
    call UnitReference_DrawSelectedTerrainDetail
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    call .scroll_up
    jr .continue
.check_down
    bit 7, a
    jr z, .check_back
    call .scroll_down
    jr .continue
.check_back
    bit 1, a
    jr z, .continue
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .finish
.continue
    jr .loop
.finish
    push af
    call FadeToWhite8
    call SpriteObject_DestroyAll
    pop af
    ret
.scroll_up
    ld a, [wUnitReferenceSubmenuScrollOffset]
    dec a
    cp $ff
    jr nz, .store_up
    jr .up_done
.store_up
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [wUnitReferenceSubmenuScrollOffset], a
    ld a, [wUnitReferenceMovementGridIndex]
    farcall $32, Description_DrawTerrainText
    call UnitReference_UpdateSubmenuScrollArrows
.up_done
    ret
.scroll_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    cp c
    jr z, .down_done
    jr c, .down_done
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
    ld c, a
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld d, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub d
    cp c
    jr nc, .advance_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub c
    jr .store_down
.advance_down
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
.store_down
    ld [wUnitReferenceSubmenuScrollOffset], a
    ld a, [wUnitReferenceMovementGridIndex]
    farcall $32, Description_DrawTerrainText
    call UnitReference_UpdateSubmenuScrollArrows
.down_done
    ret

    assert @ == $728a

section "Unit Reference Upkeep Provider", romx[$728a], bank[$25]

UnitReference_DrawUpkeepSubmenu::
    call UnitReference_SetupScreen
    call UnitReference_DrawScreenFrame
    ld bc, $0004
    call UnitReference_DrawDividerRow
    ld a, [wUnitReferenceCurrentType]
    ld bc, $0101
    call UnitReference_DrawUnitName
    ld a, $08
    ld bc, $0102
    ld de, $0101
    ld h, $f2
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0302
    ld hl, UnitStatus_Submenu_Upkeep_MaxFuel
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $0b
    farcall $12, UnitData_GetByte
    ld bc, $1102
    ld d, $02
    call $31f5
    ld a, [wUnitReferenceCurrentType]
    farcall $18, BattleScene_ClassifyMapTile3Way
    cp $01
    jr nz, .descriptions
    ld hl, UnitStatus_Submenu_Upkeep
    ld bc, $0103
    call TextPut
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $0f
    farcall $12, UnitData_GetByte
    cp $00
    jr z, .no_flight_cost
    ld bc, $1103
    ld d, $02
    call $31f5
    jr .descriptions
.no_flight_cost
    ld bc, $1103
    ld hl, UnitReference_String_DetailMarker
    call TextPut
.descriptions
    ld a, $0c
    ld [wUnitReferenceSubmenuVisibleRows], a
    xor a
    ld [wUnitReferenceSubmenuScrollOffset], a
    ld a, [wUnitReferenceCurrentType]
    ld hl, $7b6b
    farcall $32, Description_CountLines
    farcall $32, Description_DrawGasExplanation
    call UnitReference_CreateScrollArrowsTop34
    call UnitReference_UpdateSubmenuScrollArrows
    ret

    assert @ == $731d
