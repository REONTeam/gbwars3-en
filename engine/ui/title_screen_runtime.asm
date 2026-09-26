include "macros/macros.inc"
include "constants/sprite_constants.inc"

; Title-screen PRESS START sprite and input wait path.

section "Title Screen Wait", romx[$43dc], bank[$27]

; Wait for DE frames while advancing input, OAM, advanced-sprite behavior, and
; optional SCX/SCY deltas in B/C. Returns $FF for A/Start or 0 on timeout.
TitleScreen_WaitForInput::
    push hl
    ld hl, $0000
.loop
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    farcall $17, AdvancedSprite_UpdateSpawnFirst
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr nz, .check_input
    xor a
    jr .done
.check_input
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, .pressed
    bit 3, a
    jr nz, .pressed
    jr .advance
.pressed
    ld a, $ff
    jr .done
.advance
    ldh a, [hSCX]
    add b
    ldh [hSCX], a
    ldh a, [hSCY]
    add c
    ldh [hSCY], a
    inc hl
    jr .loop
.done
    pop hl
    ret

assert @ == $4417

; Build the PRESS START sprite and wait up to 1920 frames (32 seconds).
TitleScreen_ShowAndWait::
    call LCD_Disable
    farcall $17, AdvancedSprite_Reset
    farcall $10, TitleScreen_LoadBackgroundAssets
    xor a
    ld [wSpritePaletteVariant], a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld a, SPRITE_GROUP_PRESS_START
    ld hl, $8000
    farcall $1a, SpriteGroup_LoadGraphicsAndPalettes

    ld a, SPRITE_ANIM_PRESS_START
    farcall $1a, SpriteAnimation_GetFarPointer
    ; Retail code explicitly reloads this same animation pointer afterwards.
    ld de, SpriteAnimation_PressStart
    ld a, $20
    ld c, $00
    call SpriteObject_Create
    ld bc, $5878
    call SpriteObject_SetPosition

    ld a, $01
    call Audio_PlayMusic
    call FadeFromWhite8

    ld de, $0780
    ld bc, $0000
    call TitleScreen_WaitForInput
    push af
    call FadeToWhite8
    call SpriteObject_DestroyAll
    pop af
    ret

assert @ == $4465
