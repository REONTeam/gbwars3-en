include "macros/macros.inc"

; Bank $19 Network/Mobile registration and presentation runtime.
; Executable spans are mnemonic; the persistent registration signature is retained as data.

section "Bank19 Network Registration Validator", romx[$4d41], bank[$19]
NetworkRegistration_ValidateOrInitializeSignature::
    ld a, $0e
    call $058d
    call $0593
    ld b, $1a
    ld hl, $a000
    ld de, $4d6f
    ld a, [de]
    cp [hl]
    jr nz, $4d61
    inc hl
    inc de
    dec b
    jr nz, $4d51
    xor a
    push af
    call $059b
    pop af
    ret
    ld a, [de]
    ld [hli], a
    inc de
    dec b
    jr nz, $4d61
    call $7059
    call $059b
    scf
    ret
    assert @ == $4d6f

section "Bank19 Network Registration Signature", romx[$4d6f], bank[$19]
NetworkRegistration_Signature::
    db $47, $61, $6d, $65, $42, $6f, $79, $57, $61, $72, $73, $33, $2d, $55, $53, $45
    db $52, $2d, $52, $45, $47, $49, $53, $54, $32, $35
    assert @ == $4d89

section "Bank19 Network Runtime 4D89", romx[$4d89], bank[$19]
NetworkRuntime_4D89::
    ld a, [$da33]
    cp $00
    jr z, $4d98
    cp $01
    jr z, $4da0
    cp $02
    jr z, $4da8
    ld hl, $d839
    ld de, $dc10
    jr $4db0
    ld hl, $d846
    ld de, $dc10
    jr $4db0
    ld hl, $d853
    ld de, $dc10
    jr $4db0
    farcall Text_ConvertGameCodeToShiftJISStream
    ld a, $0e
    call $058d
    call $0593
    ld a, [$da33]
    cp $00
    jr z, $4dcb
    cp $01
    jr z, $4dd6
    cp $02
    jr z, $4de1
    ld de, $dc10
    ld hl, $a01a
    ld bc, $0019
    jr $4dec
    ld de, $dc10
    ld hl, $a033
    ld bc, $0019
    jr $4dec
    ld de, $dc10
    ld hl, $a04c
    ld bc, $000d
    jr $4dec
    call $3b50
    call $059b
    ret
    ld a, $0e
    call $058d
    call $0593
    ld a, [$cbe2]
    ld [$a062], a
    call $059b
    ret
    ld a, $0e
    call $058d
    call $0593
    ld de, $d85a
    ld hl, $a059
    ld bc, $0008
    call $3b50
    call $059b
    ret
    ld a, $0e
    call $058d
    call $0593
    ld a, [$d865]
    ld [$a064], a
    call $059b
    ret
    ld a, [$da96]
    cp $00
    jr z, $4e3e
    cp $01
    jr z, $4e61
    cp $02
    jr z, $4e99
    ld hl, $d867
    ld de, $dc10
    farcall Text_ConvertGameCodeToShiftJISStream
    ld a, $0e
    call $058d
    call $0593
    ld de, $dc10
    ld hl, $a066
    ld bc, $0031
    call $3b50
    call $059b
    jr $4ed1
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba3a]
    cp $00
    jr z, $4e72
    jr $4e8a
    ld hl, $cab3
    ld de, $dc10
    farcall Text_ConvertGameCodeToShiftJISStream
    ld de, $dc10
    ld hl, $a0ba
    ld bc, $0011
    call $3b50
    jr $4e94
    ld hl, $a0ba
    ld bc, $0011
    xor a
    call $3b79
    call $059b
    jr $4ed1
    ld hl, $d8eb
    ld de, $dc10
    farcall Text_ConvertGameCodeToShiftJISStream
    ld a, $0e
    call $058d
    call $0593
    ld a, [$bb5b]
    cp $00
    jr z, $4eb4
    jr $4ec2
    ld de, $dc10
    ld hl, $a0ea
    ld bc, $0011
    call $3b50
    jr $4ecc
    ld hl, $a0ea
    ld bc, $0011
    xor a
    call $3b79
    call $059b
    jr $4ed1
    ret
    xor a
    ld [$cacb], a
    ld a, $01
    call $6e78
    cp $00
    jr z, $4ef6
    cp $01
    jr z, $4ee8
    cp $fe
    jr z, $4efb
    ret
    ld a, $01
    call $6b4c
    jr $4ed6
    ld a, $02
    call $6b4c
    jr $4ed6
    call $6581
    jr $4ed6
    call $4bc7
    ret
    ret
    call $7d0f
    cp $ff
    ret z
    call $7a81
    cp $ff
    jr z, $4f00
    ret
NetworkRuntime_4F0E::
    ld a, [hli]
    cp $30
    jr nz, $4f1f
    ld a, [hli]
    cp $30
    jr nz, $4f1f
    ld a, [hli]
    cp $30
    jr nz, $4f1f
    jr $4f21
    xor a
    ret
    scf
    ret
    ld a, [hli]
    cp $30
    jr nz, $4f4d
    ld a, [hli]
    cp $30
    jr nz, $4f4d
    ld a, [hli]
    cp $30
    jr nz, $4f4d
    ld a, [hli]
    cp $30
    jr nz, $4f4d
    ld a, [hli]
    cp $30
    jr nz, $4f4d
    ld a, [hli]
    cp $30
    jr nz, $4f4d
    ld a, [hli]
    cp $30
    jr nz, $4f4d
    ld a, [hli]
    cp $30
    jr nz, $4f4d
    jr $4f4f
    xor a
    ret
    scf
    ret
    cp $00
    jr z, $4f58
    xor a
    jr $4f5d
    jr $4f71
    call $4831
    cp $00
    jr z, $4f71
    cp $01
    jr z, $4fa3
    cp $02
    jr z, $4fce
    cp $03
    jp z, $4fe5
    cp $ff
    ret z
    ld a, $06
    farcall MapMenu_Runtime47E3
    cp $ff
    jr nz, $4f7e
    ret
    jr $4f58
    ld [$cbc7], a
    call $48cc
    cp $ff
    jr z, $4f71
    ld hl, $cbee
    farcall NetworkRuntime_4F0E
    jr c, $4f9a
    ld b, $02
    ld a, $03
    farcall NetworkRuntime_StageSelectorPairAndRun
    ret
    ld b, $00
    ld a, $80
    farcall NetworkRuntime_StageSelectorPairAndRun
    ret
    ld a, $07
    farcall MapMenu_Runtime47E3
    cp $ff
    jr z, $4f58
    ld [$cbc7], a
    ld a, $08
    farcall MapMenu_Runtime47E3
    cp $ff
    jr z, $4fa3
    ld [$cbc8], a
    ld b, $02
    ld a, $01
    farcall NetworkRuntime_StageSelectorPairAndRun
    cp $ff
    jr z, $4fa3
    farcall BANK_26, Bank26_Entry_69D6
    ret
    ld a, $09
    farcall MapMenu_Runtime47E3
    cp $ff
    jp z, $4f58
    ld [$cbc8], a
    ld b, $02
    ld a, $0a
    farcall NetworkRuntime_StageSelectorPairAndRun
    ret
    ld a, $0a
    farcall MapMenu_Runtime47E3
    cp $ff
    jp z, $4f58
    ld [$cbc8], a
    ld b, $02
    ld a, $02
    farcall NetworkRuntime_StageSelectorPairAndRun
    ret
    call $5a8b
    cp $00
    jr z, $501f
    cp $01
    jr z, $5029
    cp $02
    jr z, $5033
    cp $03
    jr z, $503d
    cp $04
    jr z, $5042
    cp $05
    jr z, $5047
    cp $fe
    jr z, $5059
    cp $ff
    ret z
    ret
    ld b, $01
    ld a, $00
    farcall BANK_32, Bank32_Entry_550C
    jr $4ffc
    ld b, $01
    ld a, $01
    farcall BANK_32, Bank32_Entry_550C
    jr $4ffc
    ld b, $01
    ld a, $02
    farcall BANK_32, Bank32_Entry_550C
    jr $4ffc
    call $5e93
    jr $4ffc
    call $5fce
    jr $4ffc
    call $6132
    cp $ff
    jr z, $4ffc
    ld a, $00
    call $6b4c
    cp $ff
    jr z, $5047
    jr $4ffc
    ld b, $02
    ld a, $00
    call $4a2a
    jr $501e
    xor a
    ld [$cacb], a
    ld a, $01
    call $6e78
    cp $00
    jp z, $5098
    cp $01
    jp z, $508a
    cp $fe
    jr z, $5081
    cp $ff
    jp z, $4ffc
    jp $4ffc
    ld b, $02
    ld a, $00
    call $4a2a
    jr $501e
    ld a, $01
    call $6b4c
    jr $5059
    ld a, $02
    call $6b4c
    jr $5059
    call $6581
    jr $5059
    call $5402
    cp $00
    jr z, $50b6
    cp $01
    jr z, $50dd
    cp $02
    jr z, $5108
    cp $ff
    ret z
    jr $509d
    ret
    xor a
    ld [$cacb], a
    xor a
    call $6e78
    cp $00
    jp z, $50d8
    cp $01
    jp z, $50ca
    cp $ff
    jr z, $509d
    jr $509d
    ld a, $01
    call $6b4c
    jr $50b6
    ld a, $02
    call $6b4c
    jr $50b6
    call $6581
    jr $50b6
    ld a, $01
    call $5306
    cp $00
    jr z, $50f0
    cp $01
    jr z, $509d
    cp $ff
    jr z, $509d
    jr $509d
    ld b, $02
    ld a, $0b
    call $4a2a
    ld a, $0e
    call $058d
    call $0593
    ld a, $01
    ld [$bb5d], a
    call $059b
    ret
    ld a, $02
    call $5306
    cp $01
    jr z, $509d
    cp $ff
    jr z, $509d
    call $5a8b
    cp $00
    jr z, $513c
    cp $01
    jr z, $5146
    cp $02
    jr z, $5150
    cp $03
    jr z, $515a
    cp $04
    jr z, $515f
    cp $05
    jr z, $5164
    cp $fe
    jr z, $5177
    cp $ff
    jp z, $509d
    jp $509d
    ld b, $01
    ld a, $00
    farcall BANK_32, Bank32_Entry_550C
    jr $5108
    ld b, $01
    ld a, $01
    farcall BANK_32, Bank32_Entry_550C
    jr $5108
    ld b, $01
    ld a, $02
    farcall BANK_32, Bank32_Entry_550C
    jr $5108
    call $5e93
    jr $5108
    call $5fce
    jr $5108
    call $6132
    cp $ff
    jr z, $5108
    ld a, $00
    call $6b4c
    cp $ff
    jr z, $5164
    jp $509d
    ld b, $02
    ld a, $0c
    call $4a2a
    ld a, $0e
    call $058d
    call $0593
    ld a, $01
    ld [$bb5e], a
    call $059b
    ret
NetworkUI_RunMobileMenuController::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$dc2b], a
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$cc23], a
    call $56a2
    cp $00
    jr z, $51d7
    cp $01
    jr z, $51e8
    cp $02
    jr z, $51bb
    cp $ff
    jr z, $51f8
    jr $51a2
    call $4ed2
    cp $ff
    jr z, $51a2
    ld a, [$cbf6]
    ld h, a
    ld a, [$cbf7]
    ld l, a
    ld de, $0000
    call $29ca
    jr z, $51a2
    ld a, $01
    ld [$cc23], a
    call $4f00
    cp $80
    jp z, $51e1
    jr $51a2
    ld a, $01
    call $4f51
    jr $51a2
    xor a
    call $4f51
    jr $51a2
    call $4ffc
    jr $51a2
    call $509d
    jr $51a2
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $ff
    ret
    push af
    farcall NetworkUI_InitializeMobileMenu
    ld a, $01
    ld [$dee0], a
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
    ld bc, $0101
    ld de, $1204
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $0106
    ld de, $120b
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $070b
    farcall Gfx_DrawTwoChoiceHighlightFirst
    pop af
    cp $00
    jr z, $524c
    cp $01
    jr z, $525c
    jr $526f
    assert @ == $524c
