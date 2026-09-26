include "macros/macros.inc"
; close the independently-called Bank $19 helper family immediately
; before the existing three-record Shift-JIS renderer. $61E6 is
; behavior-backed as a zero-terminated byte-string length helper. Later
; helper names describe proven buffer/layout contracts without assigning
; unsupported player-facing field identities.

section "Bank19 Network Text Length", romx[$61e6], bank[$19]
NetworkText_GetZeroTerminatedLength::
    xor a
    push af
    ld a, [hli]
    cp $00
    jr nz, $61f0
    pop af
    jr $61f4
    pop af
    inc a
    jr $61e7
    ret
    assert @ == $61f5

section "Bank19 Network Profile Helper 61F5", romx[$61f5], bank[$19]
NetworkProfile_PrepareDisplayField::
    ld hl, $da50
    ld bc, $0011
    xor a
    call $3b79
    ld a, [$da96]
    cp $00
    jr z, $6238
    cp $01
    jr z, $620e
    cp $02
    jr z, $6213
    ld hl, $cab3
    jr $6216
    ld hl, $d8eb
    call $61e6
    cp $00
    jr z, $6238
    push af
    ld hl, $da50
    ld bc, $0011
    xor a
    call $3b79
    xor a
    ld [$da60], a
    pop af
    ld b, $00
    ld c, a
    ld hl, $da50
    ld a, $01
    call $3b79
    ret
    assert @ == $6239

section "Bank19 Network Profile Helper 6239", romx[$6239], bank[$19]
NetworkProfile_PrepareListBuffers::
    ld hl, $da61
    ld bc, $0011
    ld a, $00
    call $3b79
    ld hl, $da72
    ld bc, $0011
    ld a, $00
    call $3b79
    ld hl, $da83
    ld bc, $0011
    ld a, $00
    call $3b79
    ld a, [$da96]
    cp $00
    jr z, $6269
    cp $01
    jr z, $6277
    cp $02
    jr z, $6285
    ld de, $d867
    ld hl, $da61
    ld bc, $0010
    call $3b50
    jr $6293
    ld de, $cab3
    ld hl, $da61
    ld bc, $0010
    call $3b50
    jr $62ab
    ld de, $d8eb
    ld hl, $da61
    ld bc, $0010
    call $3b50
    jr $62ab
    ld de, $d877
    ld hl, $da72
    ld bc, $0010
    call $3b50
    ld de, $d887
    ld hl, $da83
    ld bc, $0010
    call $3b50
    farcall Bank31_RuntimeValidateList_57E6
    ld hl, $da72
    call $61e6
    cp $00
    jr z, $62d5
    ld hl, $da72
    ld bc, $0207
    call $3353
    ld hl, $da83
    call $61e6
    cp $00
    jr z, $62d5
    ld hl, $da83
    ld bc, $0208
    call $3353
    ret
    assert @ == $62d6

section "Bank19 Network Profile Helper 62D6", romx[$62d6], bank[$19]
NetworkProfile_GetLayoutByte::
    ld a, $11
    ld b, a
    ld a, [$da4e]
    call $2995
    ld a, [$da4d]
    ld b, $00
    ld c, a
    add hl, bc
    ld a, $67
    ld b, a
    ld a, $7c
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [$da94], a
    ret
    assert @ == $62f2

section "Bank19 Network Profile Helper 62F2", romx[$62f2], bank[$19]
NetworkProfile_GetDisplayCoordinates::
    ld a, [$da4f]
    ld b, $10
    farcall Math_DivideAByB
    ld d, a
    ld a, [$da4f]
    ld b, $10
    farcall Math_DivideAByB
    ld a, b
    ld e, a
    ld b, d
    ld c, e
    ld a, b
    add a, $02
    ld b, a
    ld a, c
    add a, $06
    ld c, a
    ret
NetworkProfile_GetDisplayCoordinatesNextRow::
    ld a, [$da4f]
    inc a
    ld b, $10
    farcall Math_DivideAByB
    ld d, a
    ld a, [$da4f]
    inc a
    ld b, $10
    farcall Math_DivideAByB
    ld a, b
    ld e, a
    ld b, d
    ld c, e
    ld a, b
    add a, $02
    ld b, a
    ld a, c
    add a, $06
    ld c, a
    ret
    assert @ == $6334

section "Bank19 Network Profile Helper 6334", romx[$6334], bank[$19]
NetworkProfile_RenderSelectedField::
    call $574e
    ld a, [$da96]
    cp $00
    jr z, $6346
    cp $01
    jr z, $634b
    cp $02
    jr z, $6350
    ld hl, $d867
    jr $6353
    ld hl, $cab3
    jr $6353
    ld hl, $d8eb
    call $61e6
    ld [$da4f], a
    ld a, [$da4f]
    push af
    ld a, [$da96]
    cp $00
    jr z, $636c
    cp $01
    jr z, $6371
    cp $02
    jr z, $6371
    ld a, $2f
    ld c, a
    jr $6374
    ld a, $0f
    ld c, a
    pop af
    cp c
    jr z, $637c
    jr c, $637c
    jr $63b3
    ld [$da4f], a
    call $62f2
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    push bc
    ld a, $15
    ld de, $0101
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    pop bc
    ld a, $08
    ld de, $0101
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$da4f]
    inc a
    ld [$da4f], a
    jr $6359
    ld a, [$da96]
    cp $00
    jr z, $63c2
    cp $01
    jr z, $63c7
    cp $02
    jr z, $63cc
    ld hl, $d867
    jr $63cf
    ld hl, $cab3
    jr $63cf
    ld hl, $d8eb
    call $61e6
    ld [$da4f], a
    ret
    assert @ == $63d6

section "Bank19 Network Profile Helper 63D6", romx[$63d6], bank[$19]
NetworkProfile_TestIndexedRecord::
    farcall Bank31_GetIndexed34ByteRecordAddress
    ld a, $00
    call $29bc
    ld a, [hl]
    cp $00
    jr z, $63e6
    jr $63e9
    xor a
    scf
    ret
    xor a
    ret
    assert @ == $63eb
