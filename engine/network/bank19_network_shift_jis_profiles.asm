include "macros/macros.inc"

; later Bank $19 Network/Mobile Shift-JIS caller clusters.
; These routines prove two persistent presentation shapes:
;   - one optional 17-byte SRAM-backed field converted into a 17-byte game-text cache;
;   - three 34-byte workspace records, each split into primary/secondary 17-byte Shift-JIS fields.
; User-facing field names remain neutral until their surrounding menu labels are source-backed.

section "Bank19 Network Saved Field17 Converter", romx[$574e], bank[$19]
NetworkText_ConvertOptionalSavedField17::
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3a]
    cp $01
    jr z, $577e
    ld hl, $a0ba
    ld de, $daa8
    farcall Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld de, $daa8
    ld hl, $cab3
    ld bc, $0011
    call $3b50
    jr $577e
    call $059b
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $5787

section "Bank19 Network Saved Field17 Cache Clear", romx[$5787], bank[$19]
NetworkText_ClearSavedField17CacheWhenPresent::
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3a]
    cp $00
    jr z, $57a1
    ld hl, $cab3
    ld bc, $0011
    ld a, $00
    call $3b79
    call $059b
    ret
    assert @ == $57a5

section "Bank19 Network Profile Record0 Secondary Field", romx[$63eb], bank[$19]
NetworkProfile_RenderRecord0SecondaryField::
    xor a
    farcall Bank31_GetIndexed34ByteRecordAddress
    ld a, $11
    call $29bc
    ld de, $daa8
    farcall Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld a, [$daa8]
    cp $00
    jr z, $640c
    ld bc, $0207
    ld hl, $daa8
    call $3353
    xor a
    assert @ == $640d

section "Bank19 Network Profile Record0 Primary Field", romx[$640d], bank[$19]
NetworkProfile_RenderRecord0PrimaryField::
    farcall Bank31_GetIndexed34ByteRecordAddress
    ld a, $00
    call $29bc
    ld de, $daa8
    farcall Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld a, [$daa8]
    cp $00
    jr z, $642f
    ld bc, $0208
    ld hl, $daa8
    call $3353
    jr $6438
    ld bc, $0208
    ld hl, $64d7
    call $3353
    assert @ == $6438

section "Bank19 Network Profile Record1 Secondary Field", romx[$6438], bank[$19]
NetworkProfile_RenderRecord1SecondaryField::
    ld a, $01
    farcall Bank31_GetIndexed34ByteRecordAddress
    ld a, $11
    call $29bc
    ld de, $daa8
    farcall Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld a, [$daa8]
    cp $00
    jr z, $645a
    ld bc, $020a
    ld hl, $daa8
    call $3353
    assert @ == $645a

section "Bank19 Network Profile Record1 Primary Field", romx[$645a], bank[$19]
NetworkProfile_RenderRecord1PrimaryField::
    ld a, $01
    farcall Bank31_GetIndexed34ByteRecordAddress
    ld a, $00
    call $29bc
    ld de, $daa8
    farcall Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld a, [$daa8]
    cp $00
    jr z, $647e
    ld bc, $020b
    ld hl, $daa8
    call $3353
    jr $6487
    ld bc, $020b
    ld hl, $64d7
    call $3353
    assert @ == $6487

section "Bank19 Network Profile Record2 Secondary Field", romx[$6487], bank[$19]
NetworkProfile_RenderRecord2SecondaryField::
    ld a, $02
    farcall Bank31_GetIndexed34ByteRecordAddress
    ld a, $11
    call $29bc
    ld de, $daa8
    farcall Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld a, [$daa8]
    cp $00
    jr z, $64a9
    ld bc, $020d
    ld hl, $daa8
    call $3353
    assert @ == $64a9

section "Bank19 Network Profile Record2 Primary Field", romx[$64a9], bank[$19]
NetworkProfile_RenderRecord2PrimaryField::
    ld a, $02
    farcall Bank31_GetIndexed34ByteRecordAddress
    ld a, $00
    call $29bc
    ld de, $daa8
    farcall Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld a, [$daa8]
    cp $00
    jr z, $64cd
    ld bc, $020e
    ld hl, $daa8
    call $3353
    jr $64d6
    ld bc, $020e
    ld hl, $64d7
    call $3353
    ret
    assert @ == $64d7

section "Bank19 Network Profile Empty Primary Placeholder", romx[$64d7], bank[$19]
NetworkProfile_EmptyPrimaryFieldPlaceholder::
    db $8f, $af, $73, $64, $6b, $7a, $82, $85, $62, $74, $ab, $85, $62, $9d, $7a, $af
    db $00
    assert @ == $64e8
