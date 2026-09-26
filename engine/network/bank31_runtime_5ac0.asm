include "macros/macros.inc"

; Bank $31 continuation from the externally reached $5AC0 entry.
; $5AC0 dispatches on the paired-state byte at $DEE3 and consumes the earlier
; direct-index bitfield operations. $5B73/$5C29 are separate externally reached UI/setup
; families with embedded resource records; exact higher-level screen identities remain conservative.

section "Bank31 Paired-State Dispatcher", romx[$5ac0], bank[$31]
Bank31_PairedStateDispatcher_5AC0::
    ld a, [$dee3]
    cp $0b
    jp z, $5ae1
    cp $0c
    jp z, $5af3
    cp $05
    jp z, $5b11
    cp $06
    jp z, $5b29
    cp $07
    jp z, $5b46
    cp $08
    jp z, $5b58
    ld a, $05
    farcall BANK_31, Bank31_Entry_5A87
    jr nz, $5aef
    ld a, $05
    ld [$dee3], a
    ret
    farcall BANK_0A, Bank0A_Entry_40F0
    farcall BANK_0A, Bank0A_Entry_40F3
    jp c, $5b05
    or a
    jr nz, $5aff
    jr $5b05
    ld a, $0c
    ld [$dee3], a
    ret
    ld a, $05
    farcall BANK_31, Bank31_Entry_5A7D
    ld a, $05
    ld [$dee3], a
    ret
    ld a, $17
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $02
    farcall BANK_31, Bank31_Entry_5A87
    jr nz, $5b25
    ld a, $07
    ld [$dee3], a
    ret
    farcall BANK_0A, Bank0A_Entry_43D4
    farcall BANK_0A, Bank0A_Entry_43EB
    jr c, $5b3a
    or a
    jr nz, $5b34
    jr $5b3a
    ld a, $06
    ld [$dee3], a
    ret
    ld a, $02
    farcall BANK_31, Bank31_Entry_5A7D
    ld a, $07
    ld [$dee3], a
    ret
    ld a, $03
    farcall BANK_31, Bank31_Entry_5A87
    jr nz, $5b54
    ld a, $fe
    ld [$dee3], a
    ret
    farcall BANK_0A, Bank0A_Entry_406B
    farcall BANK_0A, Bank0A_Entry_4070
    or a
    jr nz, $5b61
    jr $5b67
    ld a, $08
    ld [$dee3], a
    ret
    ld a, $03
    farcall BANK_31, Bank31_Entry_5A7D
    ld a, $fe
    ld [$dee3], a
    ret
    assert @ == $5b73

section "Bank31 Runtime Setup 5B73", romx[$5b73], bank[$31]
Bank31_RuntimeSetup_5B73::
    farcall NetworkUI_InitializeMobileMenu
    farcall NetworkUI_CopyBootstrapResource
    ld bc, $0102
    ld de, $1209
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $010c
    ld de, $1205
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, $5bf1
    call $336e
    ld hl, $5c00
    call $336e
    ld hl, $5c0f
    call $336e
    ld hl, $5c1c
    call $336e
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
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$deee], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    farcall Bank31_RuntimeDrawValue_5A19
    farcall BANK_26, Bank26_Entry_54C8
    ret
    db $03, $04, $cf, $ff, $f4, $eb, $2d, $c0, $e8, $b3, $dd, $db, $2d, $ec, $00, $03
    db $05, $cf, $ff, $f4, $eb, $2d, $c0, $b1, $ff, $f4, $db, $2d, $ec, $00, $03, $06
    db $cf, $ff, $f4, $eb, $2d, $c0, $eb, $d8, $2d, $c4, $00, $03, $07, $cf, $ff, $f4
    db $eb, $2d, $c0, $74, $63, $6a, $63, $00
    assert @ == $5c29

section "Bank31 Runtime Setup 5C29", romx[$5c29], bank[$31]
Bank31_RuntimeSetup_5C29::
    farcall NetworkUI_InitializeMobileMenu
    ld a, $03
    ld [$deef], a
    ld bc, $0504
    ld de, $0a05
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $010a
    ld de, $1205
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, $0a
    ld bc, $0501
    ld de, $0a02
    ld h, $29
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0f10
    ld de, $0101
    ld h, $48
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1010
    ld de, $0301
    ld h, $62
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld hl, $5cc1
    ld bc, $020b
    call $2b38
    ld hl, $cbee
    ld bc, $0008
    ld a, $00
    call $3b79
    ldh a, [$ff83]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call $2de8
    ld [$def0], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call $2de8
    ld [$def1], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    farcall Bank31_RuntimeDrawDecimalFields_59E0
    ld hl, $cbee
    ld bc, $0007
    ld a, $30
    call $3b79
    ld bc, $0806
    farcall Bank31_RuntimeBufferClear_5983
    ret
    db $e8, $b3, $dd, $db, $2d, $ec, $6c, $70, $62, $01, $cf, $ff, $f4, $eb, $2d, $c0
    db $79, $9d, $8d, $92, $63, $60, $01, $76, $ad, $63, $88, $ae, $68, $6c, $73, $68
    db $98, $6b, $62, $2e, $00
    assert @ == $5ce6
