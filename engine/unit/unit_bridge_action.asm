include "macros/macros.inc"
include "constants/unit_constants.inc"

; Construction Truck bridge-building executor. BC is the River cell.
; Retail consumes two first-weapon charges, replaces the base terrain with
; BRIDGE_1, and records a developed-property statistic.

section "Unit Bridge Construction Action", romx[$4bf2], bank[$0b]

Unit_BuildBridgeAtCoordinates::
    ld a, [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET]
    sub 2
    ld [wUnitRecordScratch + UNIT_RECORD_WEAPON1_AMMO_OFFSET], a
    push bc
    ld a, 5
    farcall $0c, UnitAction_PresentActionEffect
    pop bc
    ld a, MAP_TERRAIN_BRIDGE_1
    call MapTile_SetBaseIdAtCoordinates
    call $43d1
    farcall $11, CampaignStats_SetProcuredFlag36ForPrimarySide
    farcall $11, CampaignStats_IncrementDevelopedProperties
    ld a, 10
    call Audio_RequestSFX
    ret

    assert @ == $4c18
