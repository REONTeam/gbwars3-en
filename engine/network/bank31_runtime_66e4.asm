
; fourth Bank-$31 stream-conversion helper reached from Bank $22.
; It consumes two source bytes and appends fallback code $0A if destination space remains.
section "Bank31 Fallback Two-Byte Append", romx[$66e4], bank[$31]
Bank31_AppendFallbackCodeAndConsumeTwoBytes::
    push hl
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    ld a, $0a
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
    call Math_CompareHLToDE
    jr z, .full
    pop af
    ld [hl], a
    inc hl
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    pop hl
    inc hl
    inc hl
    ret
.full
    ld hl, $dc0e
    ld [hl], $00
    ld hl, $dc0f
    ld [hl], $00
    pop af
    pop hl
    inc hl
    ret

    assert @ == $6716
