include "macros/macros.inc"
include "constants/presentation_constants.inc"

DEF wPresentationPaletteToggle EQU $d33a
DEF wPresentationPaletteTimer  EQU $d33b

section "Presentation Alternating Palette Wait Slow", romx[$4067], bank[$31]

; Wait DE frames while polling A/B/Start. Every ten frames alternate between
; the two palette indices staged at $C4A0/wPresentationParam1, applying them through the
; shared Bank-$27 palette helper. Input A chooses the final palette restored on
; timeout/cancel. Carry is set when cancelled.
Presentation_WaitWithAlternatingPaletteSlow::
    ld c, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, c
    push af
    xor a
    ld [wPresentationPaletteToggle], a
    ld [wPresentationPaletteTimer], a
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
    jr .timeout
.check_input
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, .cancel
    bit 1, a
    jr nz, .cancel
    bit 3, a
    jr nz, .cancel
    jr .tick_palette
.cancel
    jr .cancel_return
.tick_palette
    push hl
    ld a, [wPresentationPaletteTimer]
    cp $0a
    jr nz, .increment_timer
    ld a, [wPresentationPaletteToggle]
    cp $00
    jr z, .use_second
    xor a
    ld [wPresentationPaletteToggle], a
    ld a, [wPresentationParam1]
    jr .apply_palette
.use_second
    ld a, $01
    ld [wPresentationPaletteToggle], a
    ld a, [$c4a0]
.apply_palette
    push hl
    push bc
    push de
    farcall $27, Presentation_ApplyBackgroundPalette
    pop de
    pop bc
    pop hl
    xor a
    ld [wPresentationPaletteTimer], a
.increment_timer
    ld a, [wPresentationPaletteTimer]
    inc a
    ld [wPresentationPaletteTimer], a
    pop hl
    inc hl
    jr .loop
.timeout
    pop hl
    pop af
    cp $00
    jr z, .timeout_palette_alt
    ld a, [$c4a0]
    jr .timeout_apply
.timeout_palette_alt
    ld a, [wPresentationParam1]
.timeout_apply
    farcall $27, Presentation_ApplyBackgroundPalette
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ret
.cancel_return
    pop hl
    pop af
    cp $00
    jr z, .cancel_palette_alt
    ld a, [$c4a0]
    jr .cancel_apply
.cancel_palette_alt
    ld a, [wPresentationParam1]
.cancel_apply
    farcall $27, Presentation_ApplyBackgroundPalette
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    scf
    ret

    assert @ == $4113

section "Presentation Alternating Palette Wait", romx[$4113], bank[$31]

; Wait DE frames while polling A/B/Start. Every five frames alternate between
; the two palette indices staged at $C4A0/wPresentationParam1, applying them through the
; shared Bank-$27 palette helper. Input A chooses the final palette restored on
; timeout/cancel. Carry is set when cancelled.
Presentation_WaitWithAlternatingPalette::
    ld c, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, c
    push af
    xor a
    ld [wPresentationPaletteToggle], a
    ld [wPresentationPaletteTimer], a
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
    jr .timeout
.check_input
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, .cancel
    bit 1, a
    jr nz, .cancel
    bit 3, a
    jr nz, .cancel
    jr .tick_palette
.cancel
    jr .cancel_return
.tick_palette
    push hl
    ld a, [wPresentationPaletteTimer]
    cp $05
    jr nz, .increment_timer
    ld a, [wPresentationPaletteToggle]
    cp $00
    jr z, .use_second
    xor a
    ld [wPresentationPaletteToggle], a
    ld a, [wPresentationParam1]
    jr .apply_palette
.use_second
    ld a, $01
    ld [wPresentationPaletteToggle], a
    ld a, [$c4a0]
.apply_palette
    push hl
    push bc
    push de
    farcall $27, Presentation_ApplyBackgroundPalette
    pop de
    pop bc
    pop hl
    xor a
    ld [wPresentationPaletteTimer], a
.increment_timer
    ld a, [wPresentationPaletteTimer]
    inc a
    ld [wPresentationPaletteTimer], a
    pop hl
    inc hl
    jr .loop
.timeout
    pop hl
    pop af
    cp $00
    jr z, .timeout_palette_alt
    ld a, [$c4a0]
    jr .timeout_apply
.timeout_palette_alt
    ld a, [wPresentationParam1]
.timeout_apply
    farcall $27, Presentation_ApplyBackgroundPalette
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ret
.cancel_return
    pop hl
    pop af
    cp $00
    jr z, .cancel_palette_alt
    ld a, [$c4a0]
    jr .cancel_apply
.cancel_palette_alt
    ld a, [wPresentationParam1]
.cancel_apply
    farcall $27, Presentation_ApplyBackgroundPalette
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    scf
    ret

    assert @ == $41bf
