include "macros/macros.inc"

; Redraw the text-input field for the retail six-character modes. Mode 2 is the
; Map Editor name path and branches into the project's nine-character redraw
; hook instead.
section "Text Input Redraw Runtime", romx[$5245], bank[$14]

TextInput_RedrawCurrentValue::
    ld a, [$cc43]
    cp $02
    jr z, TextInput_MapNameRedrawHook

    ld a, [hVBlankFIFO_Bank]
    push af
    ld hl, $982c
    ld a, [$cc3a]
    call AddAtoHL
    ld d, h
    ld e, l
    push de
    ld a, [$cc3a]
    ld c, a
    ld a, $06
    sub c
    ld b, a
    push bc
    ld a, [$cc3a]
    cp $06
    jr z, .skip_first_fill
    ld hl, $522a
    call VBlankFIFO_Queue
.skip_first_fill
    ld a, $01
    ld [hVBlankFIFO_Bank], a
    pop bc
    pop de
    ld a, [$cc3a]
    cp $06
    jr z, .skip_second_fill
    ld hl, $5233
    call VBlankFIFO_Queue
.skip_second_fill
    ld a, $01
    ld [hVBlankFIFO_Bank], a
    ld de, $982c
    ld a, [$cc3a]
    ld b, a
    cp $00
    jr z, .skip_cursor_fill
    ld hl, $523c
    call VBlankFIFO_Queue
.skip_cursor_fill
    xor a
    ld [hVBlankFIFO_Bank], a
    ld a, [$cc3a]
    cp $00
    jr z, .restore_bank
    ld bc, $0c01
    ld hl, wTextInputBuffer
    call TextPut
.restore_bank
    pop af
    ld [hVBlankFIFO_Bank], a
    jr TextInput_RedrawReturn

    assert @ == $52b6

section "Text Input Redraw Return", romx[$531e], bank[$14]
TextInput_RedrawReturn::
    ret

    assert @ == $531f
