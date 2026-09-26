include "macros/macros.inc"

; end-of-game opponent-cancel prompt. This screen is reached only
; through MapControl_FinalizeTransitionResult's infrared-battle finalization path. It builds a
; small modal presentation, draws the three embedded Japanese message records,
; waits for a button press, then tears the screen down.
;
; The embedded retail text reads, literally:
;   "The game has ended."
;   "The opponent should select 'Cancel'."
;   "Please select it."
;
; The caller reaches this prompt only for the infrared-battle mode; the visible
; prompt itself is unambiguous and is kept byte-identical to retail.

section "Map Control Opponent Cancel Prompt", romx[$6f1e], bank[$0b]
MapControl_ShowOpponentCancelPrompt::
    call $04f3
    farcall SharedGraphics_LoadMainFontBG
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    call $0618
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld bc, $0105
    ld de, $1207
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, $6f65
    call $336e
    ld hl, $6f76
    call $336e
    ld hl, $6f88
    call $336e
    call $081d
    call $05ac
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff91]
    and $0b
    jr z, $6f52
    call $07b4
    ret
MapControl_GameEndedMessage::
    ld [bc], a
    ld b, $e1
    dec l
    pop de
    adc a, [hl]
    ld l, h
    xor l
    ld h, e
    adc a, b
    xor [hl]
    ld h, e
    ld l, h
    ld a, a
    ld l, h
    ld [hl], b
    nop
MapControl_OpponentCancelMessage::
    ld [bc], a
    rlca
    ld [hl], b
    ld h, d
    ld l, [hl]
    adc a, l
    ld h, c
    ld h, d
    ld [hl], e
    ld a, d
    dec de
    ld [hl], c
    xor l
    ld h, e
    ld l, h
    dec e
    ld h, b
    nop
MapControl_SelectCancelMessage::
    ld [bc], a
    ld [$8d6e], sp
    ld [hl], b
    ld l, b
    ld l, h
    ld [hl], e
    ld l, b
    sbc a, b
    ld l, e
    ld h, d
    nop
    assert @ == $6f95
