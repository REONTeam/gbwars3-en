include "macros/macros.inc"

; Gameplay SAVE presentation wrapper. This stages save mode 2, opens the shared
; Bank $27 save UI, restores the map palette, and preserves the UI result while
; the common completion service runs.
section "Map Save Gameplay Presentation", romx[$4b39], bank[$14]
MapSave_RunGameplayPresentation::
    ld a, $02
    ld [$c629], a
    farcall $27, MapSave_OpenFileSelect
    call FadeFromWhite8
    farcall $27, MapSave_RunFileSelectController
    push af
    farcall $27, MapSave_CloseFileSelect
    pop af
    ret

; Map Editor SAVE controller. WRAM bank 4 owns the prompt choice scratch at
; $DC69; A confirms, B cancels, and left/right select the two choices.
section "Map Save Editor Presentation", romx[$5ede], bank[$15]
MapSave_RunEditorPresentation::
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call FadeToWhite8
    call MapSave_SetupPromptScreen
    call FadeFromWhite8
.loop
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .checkB

    ld a, $02
    call Audio_PlaySFX
    ld a, [$dc69]
    cp $01
    jr z, .confirmSave
    jr .finish

.confirmSave
    call MapSave_WriteModeSlot
    call MapSave_ShowSavedConfirmation
    jr .finish

.checkB
    bit 1, a
    jr z, .checkLeft
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    ld [$dc69], a
    jr .finish

.checkLeft
    bit 4, a
    jr z, .checkRight
    xor a
    ld [$dc69], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0709
    call Gfx_DrawTwoChoiceHighlightFirst
    jr .loopTail

.checkRight
    bit 5, a
    jr z, .loopTail
    ld a, $01
    ld [$dc69], a
    ld a, $01
    call Audio_PlaySFX
    ld bc, $0709
    call Gfx_DrawTwoChoiceHighlightSecond
    jr .loopTail

.loopTail
    jr .loop

.finish
    call FadeToWhite8
    ld a, [$dc69]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret
