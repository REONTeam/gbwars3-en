include "macros/macros.inc"

; small selected-unit interaction presentation wrappers.
; The first entry prepares the visible interaction state and runs the established
; LCD scanline transition to $68. The second tears the presentation down and
; resets that transition. The map-cursor show/hide primitives are now source-backed;
; Sprite_Update is the shared source-backed ROM0 frame-refresh service.

section "Bank $0B selected-unit interaction presentation", romx[$655b], bank[$0b]

UnitSelection_ShowInteractionPresentation::
    call MapCursor_Hide
    call Sprite_Update
    ld a, $68
    call LCDScanlineTransition_RunToTarget
    ret

UnitSelection_HideInteractionPresentation::
    call MapCursor_Show
    call LCDScanlineTransition_Reset
    ret

    assert @ == $656e
