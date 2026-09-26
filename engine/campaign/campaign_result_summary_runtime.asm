include "macros/macros.inc"

; Campaign result summary modal. The source-owned detail renderer prepares the
; page; this controller owns the fade/input lifetime and temporary WRAM-bank 4
; selection used by the result workspace.
section "Campaign Result Summary Runtime", romx[$7c84], bank[$27]
CampaignResult_ShowSummary::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call CampaignResult_DrawSummaryScreen
    call FadeFromWhite8
.loop
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .loopTrampoline
    ld a, $02
    call Audio_PlaySFX
    jr .finish
.loopTrampoline
    jr .loop
.finish
    call FadeToWhite8
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ == $7cb7
