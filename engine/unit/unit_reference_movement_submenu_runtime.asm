include "macros/macros.inc"

; Movement-loss detail page used by the Unit Reference screen.  The page
; presents the current unit's per-terrain movement costs in a paged 3x6 grid.
; The custom-English text at $6F34 remains owned by unit_status.asm.

DEF wUnitReferenceCurrentType              EQU $d9ba
DEF wUnitReferenceScrollUpSpriteID         EQU $d9bc
DEF wUnitReferenceScrollDownSpriteID       EQU $d9bd
DEF wUnitReferenceMovementCursorSpriteID   EQU $d9c9
DEF wUnitReferenceMovementPage             EQU $d9cb
DEF wUnitReferenceMovementColumn           EQU $d9cc
DEF wUnitReferenceMovementRow              EQU $d9cd
DEF wUnitReferenceMovementTerrainIndex     EQU $d9ce
DEF wUnitReferenceMovementGridIndex        EQU $d9cf
DEF wUnitReferenceMovementDrawIndex        EQU $d9d1
DEF wUnitReferenceMovementClass            EQU $d9d2
DEF wUnitReferenceMovementCellX            EQU $d9d3
DEF wUnitReferenceMovementCellY            EQU $d9d4
DEF wUnitReferenceMovementFirstTile        EQU $d9d5
DEF wUnitReferenceMovementMapTile          EQU $d9d6
DEF wUnitReferenceMovementCost             EQU $d9d7

section "Unit Reference Movement Terrain Graphics", romx[$6b7d], bank[$25]

; Stage the terrain metatiles used by the two-page movement-loss grid.
UnitReference_LoadMovementTerrainGraphics::
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $01
    ld hl, $9000
    call UnitReference_AdjustIndexPlus11ForSideBelow17
    farcall MapMetatile_LoadTiles
    ld a, $02
    ld hl, $9040
    call UnitReference_AdjustIndexPlus11ForSideBelow17
    farcall MapMetatile_LoadTiles
    ld a, $04
    ld hl, $9080
    call UnitReference_AdjustIndexPlus11ForSideBelow17
    farcall MapMetatile_LoadTiles
    ld a, $06
    ld hl, $90c0
    call UnitReference_AdjustIndexPlus11ForSideBelow17
    farcall MapMetatile_LoadTiles
    ld a, $09
    ld hl, $9100
    call UnitReference_AdjustIndexPlus11ForSideBelow17
    farcall MapMetatile_LoadTiles
    ld a, $0b
    ld hl, $9140
    call UnitReference_AdjustIndexPlus11ForSideBelow17
    farcall MapMetatile_LoadTiles
    ld a, $08
    ld hl, $9180
    call UnitReference_AdjustIndexPlus11ForSideBelow17
    farcall MapMetatile_LoadTiles
    ld a, $18
    ld hl, $91c0
    farcall MapMetatile_LoadTiles
    ld a, $1a
    ld hl, $9200
    farcall MapMetatile_LoadTiles
    ld a, $1c
    ld hl, $9240
    farcall MapMetatile_LoadTiles
    ld a, $1e
    ld hl, $9280
    farcall MapMetatile_LoadTiles
    ld a, $20
    ld hl, $92c0
    farcall MapMetatile_LoadTiles
    ld a, $24
    ld hl, $9300
    farcall MapMetatile_LoadTiles
    ld a, $25
    ld hl, $9340
    farcall MapMetatile_LoadTiles
    ld a, $26
    ld hl, $9380
    farcall MapMetatile_LoadTiles
    ld a, $27
    ld hl, $93c0
    farcall MapMetatile_LoadTiles
    ld a, $21
    ld hl, $9400
    farcall MapMetatile_LoadTiles
    ld a, $28
    ld hl, $9440
    farcall MapMetatile_LoadTiles
    ld a, $22
    ld hl, $9480
    farcall MapMetatile_LoadTiles
    ld a, $2a
    ld hl, $94c0
    farcall MapMetatile_LoadTiles
    ld a, $29
    ld hl, $9500
    farcall MapMetatile_LoadTiles
    ld a, $17
    ld hl, $9540
    farcall MapMetatile_LoadTiles
    ld a, $19
    ld hl, $9580
    farcall MapMetatile_LoadTiles
    ld a, $1b
    ld hl, $95c0
    farcall MapMetatile_LoadTiles
    ld a, $1d
    ld hl, $9600
    farcall MapMetatile_LoadTiles
    ld a, $1f
    ld hl, $9640
    farcall MapMetatile_LoadTiles
    ret

    assert @ == $6c83

; A = descriptor index. Cache its four-byte {x, y, first tile, map tile}
; record for the row/grid renderers.
UnitReference_LoadMovementCellDescriptor::
    add a, a
    ld hl, UnitReference_MovementCellDescriptorPointers
    call AddAtoHL
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    ld a, [hli]
    ld [wUnitReferenceMovementCellX], a
    ld a, [hli]
    ld [wUnitReferenceMovementCellY], a
    ld a, [hli]
    ld [wUnitReferenceMovementFirstTile], a
    ld a, [hl]
    ld [wUnitReferenceMovementMapTile], a
    ret

    assert @ == $6ca1

; Draw the numeric movement loss for the descriptor currently cached above.
UnitReference_DrawMovementCellValue::
    ld a, [wUnitReferenceMovementPage]
    cp $00
    jr z, .page_adjusted
    ld a, [wUnitReferenceMovementCellY]
    sub $02
    ld [wUnitReferenceMovementCellY], a
.page_adjusted
    ld hl, wMovementCostByMapTile
    ld a, [wUnitReferenceMovementMapTile]
    call AddAtoHL
    ld a, [hl]
    cp $00
    jr z, .draw_blank
    ld [wUnitReferenceMovementCost], a
    ld a, [wUnitReferenceMovementCellX]
    add a, $02
    ld b, a
    ld a, [wUnitReferenceMovementCellY]
    inc a
    ld c, a
    ld a, [wUnitReferenceMovementCost]
    srl a
    srl a
    srl a
    srl a
    ld d, $01
    call $31f5
    ld a, [wUnitReferenceMovementCellX]
    add a, $03
    ld b, a
    ld a, [wUnitReferenceMovementCellY]
    inc a
    ld c, a
    ld hl, UnitReference_MovementLossSeparator
    call TextPut
    ld a, [wUnitReferenceMovementCellX]
    add a, $04
    ld b, a
    ld a, [wUnitReferenceMovementCellY]
    inc a
    ld c, a
    ld a, [wUnitReferenceMovementCost]
    sla a
    sla a
    sla a
    sla a
    srl a
    srl a
    srl a
    srl a
    ld d, $01
    ld hl, UnitReference_MovementLossLowNibbleDisplayTable
    call AddAtoHL
    ld a, [hl]
    call $31f5
    ret
.draw_blank
    ld a, [wUnitReferenceMovementCellX]
    add a, $02
    ld b, a
    ld a, [wUnitReferenceMovementCellY]
    inc a
    ld c, a
    ld hl, UnitReference_MovementLossBlankText
    call TextPut
    ret

UnitReference_MovementLossBlankText::
    db $03, $03, $03, $00

    assert @ == $6d2e

; Draw the visible 18 terrain cells for the current page.
UnitReference_DrawMovementTerrainGrid::
    xor a
    ld [wUnitReferenceMovementDrawIndex], a
.loop
    ld a, [wUnitReferenceMovementDrawIndex]
    cp $12
    jp z, .done
    ld a, [wUnitReferenceMovementPage]
    ld c, a
    ld a, [wUnitReferenceMovementDrawIndex]
    add a, c
    call UnitReference_LoadMovementCellDescriptor
    ld a, [wUnitReferenceMovementCellX]
    ld b, a
    ld a, [wUnitReferenceMovementCellY]
    ld c, a
    ld a, [wUnitReferenceMovementPage]
    cp $00
    jr z, .have_coord
    ld a, [wUnitReferenceMovementCellY]
    sub $02
    ld c, a
.have_coord
    call Vram_TilemapCoord
    ld a, [wUnitReferenceMovementMapTile]
    call UnitReference_AdjustIndexPlus11ForSideBelow17
    ld d, a
    ld a, [wUnitReferenceMovementFirstTile]
    ld b, $01
    ld c, $03
    farcall MapMetatile_DrawTilemap
    call UnitReference_DrawMovementCellValue
    ld a, [wUnitReferenceMovementDrawIndex]
    inc a
    ld [wUnitReferenceMovementDrawIndex], a
    jp .loop
.done
    ret

UnitReference_MovementLossSeparator::
    db $02, $00
UnitReference_MovementLossLowNibbleDisplayTable::
    db $00, $01, $01, $02, $03, $03, $04, $04
    db $05, $06, $06, $07, $08, $08, $09, $09

UnitReference_MovementCellDescriptorPointers::
    dw .cell00, .cell01, .cell02, .cell03, .cell04, .cell05
    dw .cell06, .cell07, .cell08, .cell09, .cell10, .cell11
    dw .cell12, .cell13, .cell14, .cell15, .cell16, .cell17
    dw .cell18, .cell19, .cell20, .cell21, .cell22, .cell23
    dw .cell24, .cell25
.cell00: db $02, $05, $00, $01
.cell01: db $08, $05, $1c, $18
.cell02: db $0e, $05, $38, $26
.cell03: db $02, $07, $04, $02
.cell04: db $08, $07, $20, $1a
.cell05: db $0e, $07, $3c, $27
.cell06: db $02, $09, $08, $04
.cell07: db $08, $09, $24, $1c
.cell08: db $0e, $09, $40, $21
.cell09: db $02, $0b, $0c, $06
.cell10: db $08, $0b, $28, $1e
.cell11: db $0e, $0b, $44, $28
.cell12: db $02, $0d, $10, $09
.cell13: db $08, $0d, $2c, $20
.cell14: db $0e, $0d, $48, $22
.cell15: db $02, $0f, $14, $0b
.cell16: db $08, $0f, $30, $24
.cell17: db $0e, $0f, $4c, $2a
.cell18: db $02, $11, $18, $08
.cell19: db $08, $11, $34, $25
.cell20: db $0e, $11, $50, $29
.cell21: db $0e, $11, $54, $17
.cell22: db $0e, $11, $58, $19
.cell23: db $0e, $11, $5c, $1b
.cell24: db $0e, $11, $60, $1d
.cell25: db $0e, $11, $64, $1f

    assert @ == $6e2b

; Position the movement-grid cursor from its column/row indices.
UnitReference_UpdateMovementCursorPosition::
    ld a, [wUnitReferenceMovementColumn]
    ld b, $30
    call MultiplyAByB
    ld a, l
    add a, $14
    ld d, a
    push de
    ld a, [wUnitReferenceMovementRow]
    ld b, $10
    call MultiplyAByB
    ld a, l
    add a, $40
    pop de
    ld b, d
    ld c, a
    ld a, [wUnitReferenceMovementCursorSpriteID]
    call SpriteObject_SetPosition
    ret

; The two grid pages use opposite scroll-arrow visibility states.
UnitReference_UpdateMovementPageArrows::
    ld a, [wUnitReferenceMovementPage]
    cp $00
    jr z, .first_page
    jr .second_page
.first_page
    call UnitReference_HideScrollUpArrow
    call UnitReference_ShowScrollDownArrow
    ret
.second_page
    call UnitReference_ShowScrollUpArrow
    call UnitReference_HideScrollDownArrow
    ret

    assert @ == $6e64

; Build and draw the movement-loss page for the current unit type.
UnitReference_DrawMovementSubmenu::
    call UnitReference_SetupScreen
    ld a, $07
    ld b, $01
    ld hl, $6c9a
    ld c, $15
    call $06d9
    ld a, $01
    ld b, $06
    ld hl, $5868
    ld c, $01
    call $06d9
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
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $af
    ld bc, $1303
    ld b, $13
    ld de, $0101
    ld h, $ee
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0103
    call Vram_TilemapCoord
    ld a, $0f
    ld bc, $0012
    call $3b84
    call UnitReference_LoadMovementTerrainGraphics
    ld a, [wUnitReferenceCurrentType]
    ld bc, $0101
    call UnitReference_DrawUnitName
    ld a, $08
    ld bc, $0102
    ld de, $0101
    ld h, $f1
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0302
    ld hl, $6349
    call TextPut
    ld bc, $0f02
    call UnitReference_DrawMovementPower
    ld bc, $0104
    ld hl, UnitStatus_Submenu_Move
    call TextPut
    call VBlankFIFO_Process
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $19
    farcall $12, UnitData_GetByte
    ld [wUnitReferenceMovementClass], a
    ld a, [wUnitReferenceMovementClass]
    farcall $12, MovementData_BuildMapTileCosts
    ldh a, [hVRAMBank]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f98
    call SpriteObject_Create
    ld [wUnitReferenceMovementCursorSpriteID], a
    call UnitReference_UpdateMovementCursorPosition
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call UnitReference_CreateScrollArrowsTop2C
    call UnitReference_UpdateMovementPageArrows
    call UnitReference_DrawMovementTerrainGrid
    call VBlankFIFO_Process
    ret

    assert @ == $6f34

section "Unit Reference Movement Selection Helpers", romx[$6f3a], bank[$25]

; Convert cursor row/column/page into the selected terrain-grid indices used by
; the deeper movement explanation screen.
UnitReference_UpdateMovementTerrainSelection::
    ld a, [wUnitReferenceMovementRow]
    ld b, $03
    call MultiplyAByB
    ld a, l
    ld c, a
    ld a, [wUnitReferenceMovementColumn]
    add a, c
    ld [wUnitReferenceMovementTerrainIndex], a
    ld a, [wUnitReferenceMovementPage]
    cp $00
    ret z
    ld a, [wUnitReferenceMovementRow]
    inc a
    ld b, $03
    call MultiplyAByB
    ld a, l
    ld c, a
    ld a, [wUnitReferenceMovementColumn]
    add a, c
    ld [wUnitReferenceMovementTerrainIndex], a
    ret

UnitReference_UpdateMovementGridSelection::
    ld a, [wUnitReferenceMovementColumn]
    ld b, $07
    call MultiplyAByB
    ld a, l
    ld c, a
    ld a, [wUnitReferenceMovementRow]
    add a, c
    ld [wUnitReferenceMovementGridIndex], a
    ld a, [wUnitReferenceMovementPage]
    cp $00
    ret z
    ld a, [wUnitReferenceMovementGridIndex]
    inc a
    ld [wUnitReferenceMovementGridIndex], a
    ret

    assert @ == $6f83
