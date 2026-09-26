include "macros/macros.inc"
include "constants/unit_constants.inc"

; Player / map-AI property-capture executor. The acting unit gains experience
; equal to its current HP, the property's capture-progress state is advanced,
; and a completed capture rewrites the map tile to the current side's owned
; property variant before refreshing income and Campaign statistics.
;
; A few lower-level Bank-$0B/$0C map-presentation helpers remain address-based
; because their internal contracts are still structural; all control flow and
; already-proven record/tile/statistic operations are mnemonic.

section "Unit Property Capture Action", romx[$648c], bank[$0b]

Unit_CapturePropertyAtCurrentPosition::
    ld a, $00
    farcall $0c, UnitAction_PresentActionEffect

    ; Capturing awards experience equal to the acting unit's current HP.
    ld a, [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET]
    ld l, a
    ld h, $00
    ld a, [wMapAIActiveUnitIndex]
    farcall $12, UnitRecord_AddExperienceClamped

    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a

    ; Subtract current HP from the property's state. The sourced Bank-$0C
    ; runtime clamps at zero and returns nonzero while capture is incomplete.
    ld a, [wUnitRecordScratch + UNIT_RECORD_HP_OFFSET]
    cpl
    inc a
    farcall $0c, PropertyState_ApplyDeltaWithPresentation
    and a
    jp nz, .finish

    ; Completed capture: update the raw property tile and presentation state.
    call MapTile_GetBaseIdAtCoordinates
    call MapGrid_DecrementTileCount
    call Terrain_GetNameIndex
    push af
    farcall $0c, PropertyState_GetBaseForTerrainClass
    farcall $0c, PropertyState_SetAtCoordinates

    ld e, $00
    ld a, [wMapPhaseNumber]
    and MAP_PHASE_ACTIVE_SIDE_MASK
    jr z, .have_owner_offset
    ld e, $0b
.have_owner_offset
    pop af
    ld d, a
    add a, e
    call MapGrid_IncrementTileCount
    call MapTile_SetBaseIdAtCoordinates
    call $43d1

    ; Convert the terrain-name class into the map-control presentation class.
    ld a, d
    cp $01
    jr z, .class_01_or_default
    cp $02
    jr z, .class_02
    cp $04
    jr z, .class_04
    cp $06
    jr z, .class_06
    cp $08
    jr z, .class_08
    cp $09
    jr z, .class_09
    cp $0b
    jr z, .class_0b
.class_01_or_default
    ld a, $0d
    jr .refresh
.class_02
    ld a, $01
    jr .refresh
.class_04
    ld a, $11
    jr .refresh
.class_06
    ld a, $02
    jr .refresh
.class_08
    ld a, $04
    jr .refresh
.class_09
    ld a, $03
    jr .refresh
.class_0b
    ld a, $12

.refresh
    call MapControl_ResolutionSceneRefresh
    call MapEconomy_RecalculateIncome
    farcall $11, CampaignStats_IncrementCapturedProperties

.finish
    ld a, SFX_PROPERTY_CAPTURE
    call Audio_PlaySFX
    ret

    assert @ == $6524
