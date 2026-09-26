include "macros/macros.inc"

; complete the Campaign statistics/runtime gap immediately after the
; resolution counter and before the preserved Action Menu graphics.
; Names are behavior-backed where the byte-level contract is clear; the final
; setup dispatcher remains structural until its caller-side UI/state role is proven.

section "Campaign Procured Flag 36 Clear", romx[$4d7b], bank[$11]
CampaignStats_ClearProcuredFlag36::
    ld a, [$c62f]
    cp $01
    ret nz
    ld a, $36
    ld hl, $c77d
    call $3adc
    ret
    assert @ == $4d8a

section "Campaign Procured Flag 36 Set", romx[$4d8a], bank[$11]
CampaignStats_SetProcuredFlag36ForPrimarySide::
    ld a, [$c62f]
    cp $01
    ret nz
    ld a, [$c633]
    and $01
    ret nz
    ld a, $36
    ld hl, $c77d
    call $3ad1
    ret
    assert @ == $4d9f

section "Campaign Procured Flag 35 Clear", romx[$4d9f], bank[$11]
CampaignStats_ClearProcuredFlag35::
    ld a, $35
    ld hl, $c77d
    call $3adc
    ret
    assert @ == $4da8

section "Campaign Procured Flag 35 Set", romx[$4da8], bank[$11]
CampaignStats_SetProcuredFlag35::
    ld a, $35
    ld hl, $c77d
    call $3ad1
    ret
    assert @ == $4db1

section "Campaign Procured Flag 35 Test", romx[$4db1], bank[$11]
CampaignStats_TestProcuredFlag35::
    ld a, $35
    ld hl, $c77d
    call $3ac7
    ret
    assert @ == $4dba

section "Campaign Saturating Byte Increment", romx[$4dba], bank[$11]
CampaignStats_IncrementByteUnlessFF::
    ld a, [$c62f]
    cp $01
    ret nz
    ld a, [hl]
    cp $ff
    ret z
    inc [hl]
    ret
    assert @ == $4dc6

section "Campaign Saturating Word Increment", romx[$4dc6], bank[$11]
CampaignStats_IncrementWordUnlessFFFF::
    ld a, [$c62f]
    cp $01
    ret nz
    push de
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, d
    and e
    cp $ff
    jr z, $4ddd
    inc e
    jr nz, $4dda
    inc d
    ld [hl], d
    dec hl
    ld [hl], e
    pop de
    ret
    assert @ == $4ddf

section "Campaign Threshold Pair Compare", romx[$4ddf], bank[$11]
CampaignStats_CompareHLToWordAtDE::
    push bc
    push de
    ld a, [de]
    ld b, a
    inc de
    ld a, [de]
    ld d, a
    ld e, b
    call $29ca
    pop de
    pop bc
    ret
    assert @ == $4ded

section "Campaign SRAM Indexed Minimum", romx[$4ded], bank[$11]
CampaignStats_UpdateIndexedSRAMMinimum::
    push af
    call $0593
    ld a, $00
    call $058d
    pop af
    ld hl, $a012
    call $29bc
    ld a, [hl]
    cp b
    jr c, $4e02
    ld [hl], b
    call $059b
    ret
    assert @ == $4e06

section "Campaign SRAM Indexed Read", romx[$4e06], bank[$11]
CampaignStats_ReadIndexedSRAMValue::
    ld hl, $a012
    call $29bc
    call $0593
    ld a, $00
    call $058d
    ld a, [hl]
    call $059b
    ret
    assert @ == $4e19

section "Campaign Statistics Setup Dispatcher", romx[$4e19], bank[$11]
CampaignStats_RunSetupDispatcher::
    push bc
    ld a, [$c62f]
    cp $00
    jr nz, $4e86
    ld a, [$c883]
    cp $02
    jr z, $4e36
    cp $03
    jr z, $4e4c
    cp $07
    jr z, $4e70
    cp $09
    jr z, $4e7b
    jr $4e86
    ld a, $00
    ld b, $01
    ld c, $08
    farcall UnitRecord_SetByte
    ld a, $01
    ld b, $01
    ld c, $08
    farcall UnitRecord_SetByte
    jr $4e86
    ld b, $04
    ld a, $01
    ld c, $04
    farcall UnitRecord_SetByte
    ld b, $02
    ld a, $00
    farcall UnitRecord_SetByte
    ld b, $02
    ld a, $02
    farcall UnitRecord_SetByte
    ld b, $02
    ld a, $03
    farcall UnitRecord_SetByte
    jr $4e86
    xor a
    ld b, $02
    ld c, $08
    farcall UnitRecord_SetByte
    jr $4e86
    xor a
    ld b, $17
    ld c, $07
    farcall UnitRecord_SetByte
    jr $4e86
    pop bc
    ret
    assert @ == $4e88
