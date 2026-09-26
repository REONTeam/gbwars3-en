include "macros/macros.inc"

; Shared nine-way presentation dispatcher used by the HQ-loss result path and
; two Bank-$0C presentation callers. A selects a sequence entry 0-8. The
; routine resets advanced sprites/display state first, then dispatches through
; the fixed pointer table.

section "Presentation Sequence Dispatcher", romx[$4541], bank[$1a]
Presentation_RunSequenceByIndex::
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    push de
    farcall $17, AdvancedSprite_Reset
    farcall $27, Presentation_ResetDisplayState
    pop de
    ld a, d
    ld hl, PresentationSequencePointers
    call $3a8f
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

PresentationSequencePointers::
    dw PresentationSequence_PropertyCaptureComplete, PresentationSequence_PropertyCaptureProgress
    dw PresentationSequence_TerrainTransformation, PresentationSequence_Supply
    dw PresentationSequence_Load, PresentationSequence_CarriedChildMove
    dw PresentationSequence_CarriedChildMoveSpecialCarrier, PresentationSequence_LoadSpecialCarrier
    dw PresentationSequence_8

Presentation_AddScrollXFromC::
    ldh a, [hSCX]
    add c
    ldh [hSCX], a
    ret

    assert @ == $457a
