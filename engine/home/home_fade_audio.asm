include "macros/macros.inc"

; Shared eight-step RGB555 fade wrappers and interpolation engine.

section "Fade To White", rom0[$07b4]

; Fade all BG and OBJ palettes to white over eight steps while preserving the
; caller's active ROM bank.
FadeToWhite8::
    ldh a, [hROMBank]
    push af
    ld de, $7fff
    ld hl, wFadeTargetPals
    ld bc, $0040
    call FillWords
    ld a, $10
    ldh [hROMBank], a
    ld [rROMB0], a
    call Fade_CacheOBJPaletteColor0s
    ld a, $01
    ld [wFadeActive], a
    ld a, $08
    ld [wFadeStepsRemaining], a
.loop
    call DelayFrame
    call Fade_StepAllPals
    ld a, [wFadeActive]
    and a
    jr nz, .loop
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

assert @ == $07ea

; BG-only companion used when object palettes must remain unchanged.
FadeBGToWhite8::
    ldh a, [hROMBank]
    push af
    ld de, $7fff
    ld hl, wFadeTargetPals
    ld bc, $0020
    call FillWords
    ld a, $10
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, $01
    ld [wFadeActive], a
    ld a, $08
    ld [wFadeStepsRemaining], a
.loop
    call DelayFrame
    call Fade_StepBGPals
    ld a, [wFadeActive]
    and a
    jr nz, .loop
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

assert @ == $081d

section "Fade From White", rom0[$081d]

; Prepare the live palette buffer as white and interpolate toward the target
; palettes over eight frames, enabling the LCD before the visible transition.
FadeFromWhite8::
    ldh a, [hROMBank]
    push af
    ld a, $10
    ldh [hROMBank], a
    ld [rROMB0], a
    call Fade_PrepareFromWhite
    call Fade_CacheOBJPaletteColor0s
    call Vram_ApplyPals
    ld a, $01
    ld [wFadeActive], a
    ld a, $08
    ld [wFadeStepsRemaining], a
    call LCD_Enable
.loop
    call DelayFrame
    call Fade_StepAllPals
    ld a, [wFadeActive]
    and a
    jr nz, .loop
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

assert @ == $0850

section "Palette Fade Engine", romx[$4b55], bank[$10]

; Copy the configured palettes into the fade target and replace the live
; palette work buffer with RGB555 white.
Fade_PrepareFromWhite::
    ld de, wPals
    ld hl, wFadeTargetPals
    ld bc, $0080
    call Memcpy
    ld de, $7fff
    ld hl, wPals
    ld bc, $0040
    call FillWords
    ret

assert @ == $4b6e

; Cache color 0 of each target OBJ palette using the engine's eight-byte stride.
Fade_CacheOBJPaletteColor0s::
    ld hl, wFadeTargetPals + $40
    ld de, wFadeOBJPaletteColor0Cache
    ld c, $08
.loop
    push bc
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl]
    ld [de], a
    ld bc, $0007
    add hl, bc
    ld a, c
    add e
    ld e, a
    ld a, b
    adc d
    ld d, a
    pop bc
    dec c
    jr nz, .loop
    ret

assert @ == $4b8b

Fade_StepAllPals::
    call Fade_InterpolateAllPals
    call Vram_ApplyPals
    ld a, [wFadeStepsRemaining]
    dec a
    ld [wFadeStepsRemaining], a
    jr nz, .done
    ld [wFadeActive], a
.done
    ret

assert @ == $4b9e

Fade_StepBGPals::
    call Fade_InterpolateBGPals
    call Vram_ApplyBGPals
    ld a, [wFadeStepsRemaining]
    dec a
    ld [wFadeStepsRemaining], a
    jr nz, .done
    ld [wFadeActive], a
.done
    ret

assert @ == $4bb1

Fade_InterpolateBGPals::
    ld c, $20
    ld hl, wPals
    ld de, wFadeTargetPals
    jr Fade_InterpolateColors

assert @ == $4bbb

Fade_InterpolateAllPals::
    ld c, $40
    ld hl, wPals
    ld de, wFadeTargetPals

; Interpolate C RGB555 colors in-place at HL toward the matching targets at DE.
Fade_InterpolateColors:
.loop
    push bc
    ld a, [de]
    inc de
    ld c, a
    ld a, [de]
    inc de
    ld b, a
    push de
    push bc
    ld c, [hl]
    inc hl
    ld b, [hl]
    pop de
    call Fade_InterpolateColor
    ld [hl-], a
    ld [hl], c
    inc hl
    inc hl
    pop de
    pop bc
    dec c
    jr nz, .loop
    ret

assert @ == $4bdd

; BC=current RGB555 color, DE=target. Return the next color in AC, moving each
; five-bit component toward its target by at most four levels.
Fade_InterpolateColor:
    push hl
    ld a, c
    cp e
    jr nz, .red_differs
    ld a, b
    cp d
    jr z, .unchanged
    ld a, c
    and $1f
    ld [wFadeComponentScratch], a
    jr .green_blue
.red_differs
    ld a, e
    and $1f
    ld l, a
    ld a, c
    and $1f
    call Fade_MoveComponentToward
    ld [wFadeComponentScratch], a
.green_blue
    ld a, e
    and $e0
    ld l, a
    ld a, d
    and $03
    or l
    swap a
    rrca
    ld l, a
    ld a, c
    and $e0
    ld h, a
    ld a, b
    and $03
    or h
    swap a
    rrca
    call Fade_MoveComponentToward
    rlca
    swap a
    ld h, a
    and $03
    ld [wFadeComponentCarryScratch], a
    ld a, $e0
    and h
    ld h, a
    ld a, [wFadeComponentScratch]
    or h
    ld h, a
    ld a, d
    and $7c
    rrca
    rrca
    ld l, a
    ld a, b
    and $7c
    rrca
    rrca
    call Fade_MoveComponentToward
    rlca
    rlca
    ld b, a
    ld a, [wFadeComponentCarryScratch]
    or b
    ld c, h
.unchanged
    pop hl
    ret

assert @ == $4c3f

Fade_MoveComponentToward:
    cp l
    ret z
    jr nc, .decrease
    inc a
    cp l
    ret z
    inc a
    cp l
    ret z
    inc a
    cp l
    ret z
    inc a
    ret
.decrease
    dec a
    cp l
    ret z
    dec a
    cp l
    ret z
    dec a
    cp l
    ret z
    dec a
    ret

assert @ == $4c59
