include "macros/macros.inc"

; resolve the currently selected carried child into the active-unit
; scratch context and refresh the child-detail presentation.
section "Bank $0B selected carried-child resolver", romx[$5d6c], bank[$0b]

UnitTransport_ResolveSelectedCarriedChildAndRedraw::
    ld a, [wCarriedChildSelectionIndex]
    ld hl, wCarriedUnitList
    call AddAtoHL
    ld a, [hl]
    ld [wMapAIActiveUnitIndex], a
    farcall $12, UnitRecord_CopyToScratch
    call UnitSelection_RefreshScratchUnitMapPresentation
    call UnitSelection_DrawSelectedUnitDetails
    ret

    assert @ == $5d84
