include "macros/macros.inc"
include "constants/unit_constants.inc"
include "constants/map_analysis_constants.inc"
include "constants/presentation_constants.inc"

; Shared unit-action presentation selector/stager. A selects one of ten action
; presentation contexts. When map presentation is enabled, the selected stager
; derives the neutral wPresentationParam0/1 values and returns the Bank-$1A
; presentation-sequence index to run.
;
; $C9AF-$C9B1 are a second lifetime-scoped staging triplet used by the carried-
; child MOVE path: the preparation entry at $6804 records its later sequence and
; unit-type parameters, then selector 4 consumes them when the action resolves.
DEF wUnitActionPresentationStagedSequence EQU $c9af
DEF wUnitActionPresentationStagedParam0   EQU $c9b0
DEF wUnitActionPresentationStagedParam1   EQU $c9b1
DEF wUnitActionPresentationChainFlag      EQU $c9de

section "Unit Action Presentation Runtime", romx[$66bb], bank[$0c]

UnitAction_PresentActionEffect::
    push bc
    push de
    ld b, a
    ld a, [wMapAnalysisOptions]
    bit 2, a
    jr z, .done

    ld a, b
    cp $04
    jr z, .selector_04

    ld a, [wUnitActionPresentationChainFlag]
    and a
    jr nz, .run_chained_04
    jr .run_normal

.run_chained_04
    ld a, $04
    call UnitAction_SelectPresentationSequence
    call UnitAction_RunPresentationSequence
    ld a, b
    call UnitAction_SelectPresentationSequence
    farcall $1a, Presentation_RunSequenceByIndex
    farcall $0b, MapControl_ReinitializeAfterResolution
    jr .done

.selector_04
    ld a, [wUnitActionPresentationChainFlag]
    and a
    jr z, .done
    ld b, $04

.run_normal
    ld a, b
    call UnitAction_SelectPresentationSequence
    call UnitAction_RunPresentationSequence
    farcall $0b, MapControl_ReinitializeAfterResolution

.done
    pop de
    pop bc
    ret

UnitAction_SelectPresentationSequence:
    push bc
    push af
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    ld [wSpritePaletteVariant], a
    pop af
    ld hl, UnitAction_PresentationStagerTable
    call $3a8f
    pop bc
    ret

UnitAction_RunPresentationSequence:
    push bc
    push af
    farcall $0b, MapCursor_Hide
    call Sprite_Update
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    farcall $0c, BattleScene_RenderBattleMapContext
    call DelayFrame
    call FadeToWhite8
    pop af
    farcall $1a, Presentation_RunSequenceByIndex
    pop bc
    ret

UnitAction_PresentationStagerTable:
    dw UnitAction_StagePropertyPresentation
    dw UnitAction_StageDevelopmentPresentation
    dw UnitAction_StageSupplyPresentation
    dw UnitAction_StageLoadPresentation
    dw UnitAction_StagePreparedMovementPresentation
    dw UnitAction_StageBridgePresentation
    dw UnitAction_StageRunwayPresentation
    dw UnitAction_StageClearPresentation
    dw UnitAction_StageSelector8Presentation
    dw UnitAction_StageSelector9Presentation

UnitAction_StagePropertyPresentation:
    push bc
    push de
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    ld e, a
    farcall $0b, Terrain_GetNameIndex
    ld hl, UnitAction_PropertyPresentationClassTable
    call AddAtoHL
    ld a, [hl]
    ld [wPresentationParam0], a
    ld a, e
    cp $17
    jr nc, .terrain_band_2
    cp $0c
    jr nc, .terrain_band_1
    xor a
    jr .have_terrain_band
.terrain_band_1
    ld a, $01
    jr .have_terrain_band
.terrain_band_2
    ld a, $02
    jr .have_terrain_band
.have_terrain_band
    ld [wPresentationParam1], a
    farcall $0c, PropertyState_GetAtCoordinates
    ld d, a
    ld a, [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET]
    cp d
    jr nc, .sequence_0
    ld a, PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_PROGRESS
    jr .done
.sequence_0
    ld a, PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_COMPLETE
.done
    pop de
    pop bc
    ret

UnitAction_PropertyPresentationClassTable:
    db $ff, $00, $01, $01, $02, $02, $04, $04
    db $05, $03, $03, $08, $ff, $07, $06

UnitAction_StageDevelopmentPresentation:
    call UnitAction_StagePropertyPresentation
    ld a, PRESENTATION_SEQUENCE_TERRAIN_TRANSFORMATION
    ret

UnitAction_StageSupplyPresentation:
    ld a, [wAdjacentSupplyUnitList]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    srl a
    ld [wPresentationParam0], a
    ld a, [wMapAIActiveUnitIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    srl a
    ld [wPresentationParam1], a
    ld a, PRESENTATION_SEQUENCE_SUPPLY
    ret

UnitAction_StageLoadPresentation:
    ld a, [wMapAIActiveUnitIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    srl a
    ld [wPresentationParam0], a
    ld a, [wMapAIActiveUnitIndex]
    ld c, UNIT_RECORD_CARRIER_INDEX_OFFSET
    farcall $12, UnitRecord_GetByte
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    srl a
    cp $2e
    jr z, .special_carrier
    cp $2f
    jr z, .special_carrier
    ld [wPresentationParam1], a
    ld a, PRESENTATION_SEQUENCE_LOAD
    jr .done
.special_carrier
    ld a, PRESENTATION_SEQUENCE_LOAD_SPECIAL_CARRIER
.done
    ret

UnitAction_StagePreparedMovementPresentation:
    ld a, [wUnitActionPresentationStagedParam0]
    ld [wPresentationParam0], a
    ld a, [wUnitActionPresentationStagedParam1]
    ld [wPresentationParam1], a
    ld a, [wUnitActionPresentationStagedSequence]
    ret

UnitAction_PrepareCarriedChildMovePresentation::
    ld a, [wMapAIActiveUnitIndex]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    srl a
    ld [wUnitActionPresentationStagedParam0], a
    ld a, [wMapAIActiveUnitIndex]
    ld c, UNIT_RECORD_CARRIER_INDEX_OFFSET
    farcall $12, UnitRecord_GetByte
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    srl a
    cp $2e
    jr z, .special_carrier
    cp $2f
    jr z, .special_carrier
    ld [wUnitActionPresentationStagedParam1], a
    ld a, PRESENTATION_SEQUENCE_CARRIED_CHILD_MOVE
    jr .store_sequence
.special_carrier
    ld a, PRESENTATION_SEQUENCE_CARRIED_CHILD_MOVE_SPECIAL_CARRIER
.store_sequence
    ld [wUnitActionPresentationStagedSequence], a
    ret

UnitAction_StageBridgePresentation:
    ld a, $06
    ld [wPresentationParam0], a
    ld a, PRESENTATION_SEQUENCE_TERRAIN_TRANSFORMATION
    ret

UnitAction_StageRunwayPresentation:
    ld a, $05
    ld [wPresentationParam0], a
    ld a, [wSpritePaletteVariant]
    ld [wPresentationParam1], a
    ld a, PRESENTATION_SEQUENCE_TERRAIN_TRANSFORMATION
    ret

UnitAction_StageClearPresentation:
    ld a, $09
    ld [wPresentationParam0], a
    ld a, [wSpritePaletteVariant]
    ld [wPresentationParam1], a
    ld a, PRESENTATION_SEQUENCE_TERRAIN_TRANSFORMATION
    ret

UnitAction_StageSelector9Presentation:
    ld a, $07
    ld [wPresentationParam0], a
    ld a, PRESENTATION_SEQUENCE_TERRAIN_TRANSFORMATION
    ret

UnitAction_StageSelector8Presentation:
    ld a, PRESENTATION_SEQUENCE_8
    ret

    assert @ == $6867
