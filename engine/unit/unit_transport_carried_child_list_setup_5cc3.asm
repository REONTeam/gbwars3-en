include "macros/macros.inc"

; transport-list setup wrapper used by the carried-unit action flow.
; Clears one local transport-selection/state byte, then rebuilds the carried
; child list for wMapAIActiveUnitIndex through the established Bank $12 helper.
section "Bank $0B carried-child list setup", romx[$5cc3], bank[$0b]

UnitTransport_SetupActiveCarriedChildList::
    xor a
    ld [wCarriedChildSelectionIndex], a

    ld a, [wMapAIActiveUnitIndex]
    farcall $12, Unit_BuildCarriedChildList
    ret

    assert @ == $5ccf
