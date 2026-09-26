include "macros/macros.inc"

; closes the genuine Bank $19 gap between the preserved translated
; Network service text ending at $5306 and the custom main-menu owner at $55C3.
; External entries are retained at $547E/$54A9/$5502/$550B; direct same-bank
; call targets are labeled structurally. User-facing identities stay conservative.

section "Bank19 Network Runtime 5306", romx[$5306], bank[$19]
NetworkRuntime_5306::
    call $5200
    call $081d
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 5, a
    jr z, $5328
    ld a, $01
    call $3844
    xor a
    ld [$dee0], a
    ld bc, $070b
    farcall Gfx_DrawTwoChoiceHighlightSecond
    jr $535a
    bit 4, a
    jr z, $533f
    ld a, $01
    call $3844
    ld a, $01
    ld [$dee0], a
    ld bc, $070b
    farcall Gfx_DrawTwoChoiceHighlightFirst
    jr $535a
    bit 0, a
    jr z, $534d
    ld a, $02
    call $3844
    ld a, [$dee0]
    jr $535c
    bit 1, a
    jr z, $535a
    ld a, $0c
    call $3844
    ld a, $ff
    jr $535c
    jr $530c
    push af
    call $07b4
    call $2e67
    pop af
    ret
NetworkRuntime_5365:
    farcall NetworkUI_InitializeMobileMenu
    farcall NetworkUI_CopyBootstrapResource
    ld a, $0a
    ld bc, $0500
    ld de, $0a02
    ld h, $15
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $48
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $62
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0102
    ld de, $1209
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $010c
    ld de, $1205
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, $53de
    call $336e
    ld hl, $53ed
    call $336e
    ld hl, $53f7
    call $336e
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$da31], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    farcall Bank31_RuntimePositionHelper_5906
    ld a, $02
    call $3816
    ret
    db $03, $04, $6e, $72, $97, $68, $6e, $af, $73, $62, $7d, $8d, $6a, $63, $00, $03
    db $05, $bb, $2d, $ee, $bd, $73, $62, $6c, $00, $03, $06, $bb, $2d, $ee, $bd, $6b
    db $62, $66, $62, $00
NetworkRuntime_5402:
    call $5365
    call $081d
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 6, a
    jr z, $542a
    ld a, $01
    call $3844
    ld a, [$cbe4]
    dec a
    cp $ff
    jr nz, $5421
    ld a, $02
    ld [$cbe4], a
    farcall Bank31_RuntimePositionHelper_5906
    jr $5473
    bit 7, a
    jr z, $5445
    ld a, $01
    call $3844
    ld a, [$cbe4]
    inc a
    cp $03
    jr nz, $543c
    xor a
    ld [$cbe4], a
    farcall Bank31_RuntimePositionHelper_5906
    jr $5473
    bit 0, a
    jr z, $5466
    ld a, [$cbe4]
    call $5636
    jr c, $5473
    ld a, [$cbe4]
    farcall Bank31_SavePromptState_5502
    jr c, $5473
    ld a, [$da31]
    farcall SpriteTransition_SlideRightOffscreen
    ld a, [$cbe4]
    jr $5475
    bit 1, a
    jr z, $5473
    ld a, $0c
    call $3844
    ld a, $ff
    jr $5475
    jr $5408
    push af
    call $07b4
    call $2e67
    pop af
    ret
    assert @ == $547e

section "Bank19 Network Runtime 547E", romx[$547e], bank[$19]
NetworkRuntime_547E::
    push de
    farcall BANK_26, Bank26_Entry_5695
    cp $00
    jr z, $548c
    ld hl, $cbcd
    jr $548f
    ld hl, $0000
    ld hl, $cbcd
    pop de
    farcall BANK_0A, Bank0A_Entry_40C0
    ld hl, $d8cc
    ld de, $dc10
    farcall Text_ConvertGameCodeToShiftJISStream
    ld hl, $dc10
    farcall BANK_0A, Bank0A_Entry_40C3
    ret
    assert @ == $54a9

section "Bank19 Network Runtime 54A9", romx[$54a9], bank[$19]
NetworkRuntime_54A9::
    ld a, [$cbc7]
    ld b, $05
    farcall MapSRAM_LoadSlotToWRAMBank
    farcall BANK_26, Bank26_Entry_56AC
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld de, $cbcd
    ld hl, $d008
    ld bc, $0008
    call $3b50
    ld a, [$d002]
    ld l, a
    ld a, [$d003]
    ld h, a
    ld a, [$d000]
    call $29bc
    ld a, h
    ld [$cbc5], a
    ld a, l
    ld [$cbc6], a
    ld hl, $d000
    ld a, [$cbc5]
    ld b, a
    ld a, [$cbc6]
    ld c, a
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [hli]
    farcall BANK_0A, Bank0A_Entry_40CC
    dec bc
    ld a, b
    or c
    jr nz, $54ec
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $5502

section "Bank19 Network Skip ASCII Zeroes", romx[$5502], bank[$19]
NetworkText_SkipLeadingASCIIZeroes::
    ld a, [hl]
    cp $30
    jr nz, $550a
    inc hl
    jr $5502
    ret
    assert @ == $550b

section "Bank19 Network Skip Zero Bytes", romx[$550b], bank[$19]
NetworkText_SkipZeroBytes::
    ld a, [hl]
    cp $00
    jr z, $5511
    ret
    inc hl
    jr $550b
NetworkRuntime_5514:
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $020d
    ld de, $1003
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$cbdf]
    ld bc, $020d
    farcall Bank31_PrintIndexedMessage_5CE6
    ret
NetworkRuntime_5538:
    ld a, [$cbdf]
    ld b, $08
    call $2995
    ld a, l
    add a, $44
    ld c, a
    ld b, $1c
    ld a, [$da32]
    call $2eae
    call $5514
    ret
NetworkRuntime_5550:
    farcall NetworkUI_InitializeMobileMenu
    farcall NetworkUI_CopyBootstrapResource
    ld a, $0a
    ld bc, $0501
    ld de, $0a02
    ld h, $15
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $48
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $62
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0104
    ld de, $1207
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, $55c3
    call $336e
    ld hl, $55ce
    call $336e
    ld hl, $55de
    call $336e
    ld bc, $010c
    ld de, $1205
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$da32], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    call $5538
    ret
    assert @ == $55c3
