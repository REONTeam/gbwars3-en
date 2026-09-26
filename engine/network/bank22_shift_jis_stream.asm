include "macros/macros.inc"

; Bank $22 Shift-JIS stream conversion family used by Bank $19.
; Source pointer is staged at $DF00/$DF01 and destination pointer at $DF04/$DF05.

section "Bank22 Shift-JIS Two-Byte Append", romx[$6362], bank[$22]
Bank22_ConvertShiftJISTwoByteAndAppend::
    push hl
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    call Text_ConvertShiftJISToGameCode
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
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

section "Bank22 Fallback Two-Byte Append", romx[$6382], bank[$22]
Bank22_AppendFallbackCodeAndConsumeTwoBytes::
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

section "Bank22 Shift-JIS Single-Byte Append", romx[$63a1], bank[$22]
Bank22_ConvertShiftJISSingleByteAndAppend::
    push hl
    xor a
    ld b, a
    ld a, [hl]
    ld c, a
    call Text_ConvertShiftJISToGameCode
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
    pop af
    ld [hl], a
    inc hl
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    pop hl
    inc hl
    ret

section "Bank22 Fallback Single-Byte Append", romx[$63c0], bank[$22]
Bank22_AppendFallbackCodeAndConsumeOneByte::
    push hl
    xor a
    ld b, a
    ld a, [hl]
    ld c, a
    ld a, $0a
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
    pop af
    ld [hl], a
    inc hl
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    pop hl
    inc hl
    ret

section "Bank22 Shift-JIS Single-Byte Class Test", romx[$63de], bank[$22]
Text_IsShiftJISSingleByteClass::
    cp $80
    jr c, .yes
    cp $a1
    jr c, .no
    cp $e0
    jr c, .yes
    jr .no
.no
    xor a
    ret
.yes
    scf
    ret

section "Bank22 Shift-JIS Lead Byte Test", romx[$63f0], bank[$22]
Text_IsShiftJISLeadByte::
    cp $81
    jr c, .no
    cp $a0
    jr c, .yes
    cp $e0
    jr c, .no
    cp $f0
    jr c, .yes
    ret
.no
    xor a
    ret
.yes
    scf
    ret

section "Bank22 Shift-JIS Local Stream Converter", romx[$6405], bank[$22]
Bank22_ConvertShiftJISStreamAndClearTextBuffer::
    ld a, h
    ld [$df00], a
    ld a, l
    ld [$df01], a
    ld a, d
    ld [$df04], a
    ld a, e
    ld [$df05], a
    xor a
    ld [$df02], a
    ld [$df03], a
    ld [$df06], a
    ld [$df07], a
    ld hl, $daa8
    ld bc, $0168
    ld a, $00
    call $3b79
.loop
    ld a, [$df00]
    ld h, a
    ld a, [$df01]
    ld l, a
    ld a, [hl]
    cp $00
    jr z, .done
    push af
    call Text_IsShiftJISSingleByteClass
    jr c, .single
    pop af
    push af
    call Text_IsShiftJISLeadByte
    jr c, .double
    jr .fallback_two
.double
    pop af
    call Bank22_ConvertShiftJISTwoByteAndAppend
    jr .loop
.single
    pop af
    call Bank22_ConvertShiftJISSingleByteAndAppend
    jr .loop
.fallback_two
    pop af
    call Bank22_AppendFallbackCodeAndConsumeTwoBytes
    jr .loop
.fallback_one
    pop af
    call Bank22_AppendFallbackCodeAndConsumeOneByte
    jr .loop
.done
    ret

section "Bank22 Shift-JIS Bank31 Stream Converter", romx[$6462], bank[$22]
Bank22_ConvertShiftJISStreamViaBank31Helpers::
    ld a, h
    ld [$df00], a
    ld a, l
    ld [$df01], a
    ld a, d
    ld [$df04], a
    ld a, e
    ld [$df05], a
    xor a
    ld [$df02], a
    ld [$df03], a
    ld [$df06], a
    ld [$df07], a
.loop
    ld a, [$df00]
    ld h, a
    ld a, [$df01]
    ld l, a
    ld a, [hl]
    cp $00
    jr z, .done
    push af
    call Text_IsShiftJISSingleByteClass
    jr c, .single
    pop af
    push af
    call Text_IsShiftJISLeadByte
    jr c, .double
    jr .fallback_two
.double
    pop af
    farcall $31, Bank31_ConvertShiftJISTwoByteAndAppend
    jr .loop
.single
    pop af
    farcall $31, Bank31_ConvertShiftJISSingleByteAndAppend
    jr .loop
.fallback_two
    pop af
    farcall $31, Bank31_AppendFallbackCodeAndConsumeTwoBytes
    jr .loop
.fallback_one
    pop af
    farcall $31, Bank31_AppendFallbackCodeAndConsumeOneByte
    jr .loop
.done
    ret

    assert @ == $64b8
