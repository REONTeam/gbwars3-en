include "macros/macros.inc"

; Decimal-number renderers shared by unit details and the map economy panel.
; The temporary byte string uses tile IDs $80-$8A: $80 is a leading blank,
; $81 is digit 0, and $82-$8A are digits 1-9.  $CC45 tracks whether a
; non-leading digit has already been emitted and $CC46 holds the zero-terminated
; row that is ultimately drawn through Vram_DrawZeroTerminatedRow.

section "Three-digit number renderer", romx[$792a], bank[$0b]

; A = unsigned value (0-255)
; B/C = tilemap coordinates
; D = displayed width (1-3), right-aligned within the three-digit buffer
DrawNumber3Digits::
    push bc
    push de
    push hl
    ld l, a
    ld h, $00
    ld a, $80
    ld [wNumberRenderLeadingState], a
    push bc
    push de
    ld de, wNumberRenderBuffer
    ld bc, -100
    call NumberRenderer_AppendDigit
    ld bc, -10
    call NumberRenderer_AppendDigit
    ld a, $81
    ld [wNumberRenderLeadingState], a
    ld bc, -1
    call NumberRenderer_AppendDigit
    ld a, $00
    ld [de], a
    pop de
    pop bc
    call Vram_TilemapCoord
    ld a, 3
    sub d
    ld de, wNumberRenderBuffer
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call Vram_DrawZeroTerminatedRow
    pop hl
    pop de
    pop bc
    ret

    assert @ == $7972

section "Five-digit number renderer", romx[$7972], bank[$0b]

; HL = unsigned 16-bit value
; B/C = tilemap coordinates
; D = displayed width (1-5), right-aligned within the five-digit buffer
DrawNumber5Digits::
    push bc
    push de
    push hl
    ld a, $80
    ld [wNumberRenderLeadingState], a
    push bc
    push de
    ld de, wNumberRenderBuffer
    ld bc, -10000
    call NumberRenderer_AppendDigit
    ld bc, -1000
    call NumberRenderer_AppendDigit
    ld bc, -100
    call NumberRenderer_AppendDigit
    ld bc, -10
    call NumberRenderer_AppendDigit
    ld bc, -1
    ld a, $81
    ld [wNumberRenderLeadingState], a
    call NumberRenderer_AppendDigit
    ld a, $00
    ld [de], a
    pop de
    pop bc
    call Vram_TilemapCoord
    ld a, 5
    sub d
    ld de, wNumberRenderBuffer
    add e
    ld e, a
    ld a, $00
    adc d
    ld d, a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call Vram_DrawZeroTerminatedRow
    pop hl
    pop de
    pop bc
    ret

    assert @ == $79c3

section "Current-side gold renderer", romx[$79c3], bank[$0b]

; Render the active side's 24-bit Gold value as a five-digit decimal number.
; Gold is stored as three bytes per side.  The high byte is 0 or 1 for the
; representable five-digit range.  When it is 1, 65536 is decomposed as
; 60000 + 5536 so the ordinary 16-bit repeated-subtraction digit path can be
; reused without a 24-bit divider.
; B/C = destination tilemap coordinates.
MapEconomy_DrawCurrentSideGold::
    push bc
    push de
    push hl
    ld a, [wMapPhaseNumber]
    and $01
    ld e, a
    add a
    add e
    add $02
    ld hl, wMapSide0Gold
    call AddAtoHL
    ld d, [hl]
    dec hl
    dec hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, $80
    ld [wNumberRenderLeadingState], a
    push bc
    ld a, d
    and a
    jr z, .normal_ten_thousands
    ld bc, $15a0 ; 65536 - 60000
    add hl, bc
    ld a, $86     ; pre-account for six ten-thousands
    ld bc, -10000
    ld de, wNumberRenderBuffer
    call NumberRenderer_AppendDigitFromA
    jr .thousands
.normal_ten_thousands
    ld de, wNumberRenderBuffer
    ld bc, -10000
    call NumberRenderer_AppendDigit
.thousands
    ld bc, -1000
    call NumberRenderer_AppendDigit
    ld bc, -100
    call NumberRenderer_AppendDigit
    ld bc, -10
    call NumberRenderer_AppendDigit
    ld bc, -1
    ld a, $81
    ld [wNumberRenderLeadingState], a
    call NumberRenderer_AppendDigit
    ld a, $00
    ld [de], a
    pop bc
    call Vram_TilemapCoord
    ld de, wNumberRenderBuffer
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call Vram_DrawZeroTerminatedRow
    pop hl
    pop de
    pop bc
    ret

    assert @ == $7a34

; Append one decimal digit to [DE] by repeatedly adding the negative place
; value in BC to the remaining value in HL.  Leading zeroes are emitted as the
; current wNumberRenderLeadingState ($80 until the first significant digit).
NumberRenderer_AppendDigit::
    ld a, $80
NumberRenderer_AppendDigitFromA::
.loop
    inc a
    add hl, bc
    jr c, .loop
    cp $81
    jr z, .leading_zero
    push af
    ld a, $81
    ld [wNumberRenderLeadingState], a
    pop af
    jr .store
.leading_zero
    ld a, [wNumberRenderLeadingState]
.store
    ld [de], a
    inc de
    ld a, l
    sub c
    ld l, a
    ld a, h
    sbc b
    ld h, a
    ret

    assert @ == $7a53
