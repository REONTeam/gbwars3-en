include "macros/macros.inc"

; Bank $19 Network/Mobile selector-pair runtime continuation.
; $4A2A is independently farcalled by Bank $1A/$31 callers after loading A/B
; selector values. It stages A -> $DEF4 and B -> $DEF5 while temporarily
; selecting WRAM bank 7, then enters the established Network runtime/controller.
; The tranche stops before independently farcalled $4D41. Labels inside this
; range are limited to direct same-bank call/jump destinations.

section "Bank19 Network Runtime 4A2A", romx[$4a2a], bank[$19]
NetworkRuntime_StageSelectorPairAndRun::
    ld d, a
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ld [$def4], a
    ld a, b
    ld [$def5], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$cacb], a
    ld a, $01
    call $6e78
    cp $00
    jr z, $4a65
    cp $01
    jr z, $4a57
    cp $fe
    jr z, $4a6a
    ret
    ld a, $01
    call $6b4c
    jr $4a45
    db $3e, $02, $cd, $4c, $6b, $18, $e0
    call $6581
    jr $4a45
    call $4983
    farcall BANK_26, Bank26_Entry_56AC
    xor a
    ld [$cbdd], a
    ld [$cace], a
    ld [$cada], a
    ld [$cadb], a
    ld [$cadc], a
    ld [$cad9], a
    ld [$cbf8], a
    ld [$cc21], a
    ld [$caca], a
    ld [$cbde], a
    ld a, $01
    ld [$dee3], a
    call $081d
    farcall BANK_32, Bank32_Entry_4D25
    call $038b
    call $2a83
    farcall MapMenuMessage_ServiceFrame
    call $2acc
    ld a, [$dee3]
    cp $05
    jr z, $4adc
    ld a, [$dee3]
    cp $06
    jr z, $4adc
    ld a, [$dee3]
    cp $07
    jr z, $4adc
    ld a, [$dee3]
    cp $08
    jr z, $4adc
    ld a, [$cad9]
    cp $01
    jr z, $4adc
    ldh a, [$ff91]
    bit 1, a
    jr z, $4adc
    ld a, $0c
    call $3844
    ld a, $01
    ld [$cad9], a
    call $4195
    ld a, [$dee3]
    cp $fe
    jr z, $4b03
    cp $fd
    jr z, $4af1
    cp $ff
    jp z, $4b8c
    jr $4aa2
    ld a, $01
    ld [$cbde], a
    ld a, $0b
    ld [$dee3], a
    call $4bb7
    farcall BANK_27, Bank27_Entry_6841
    ret
    xor a
    ld [$cbdd], a
    ld a, [$cbf8]
    cp $01
    jr z, $4b34
    ld a, [$caca]
    cp $01
    jr nz, $4b21
    ld a, $18
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $17
    farcall BANK_32, Bank32_Entry_4659
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff91]
    bit 0, a
    jr z, $4b32
    ld a, $02
    call $3844
    jr $4b34
    jr $4b21
    call $49dd
    call $4a0b
    ld a, [$def4]
    cp $05
    jr nz, $4b5c
    ld a, [$cace]
    cp $01
    jr z, $4b87
    ld a, [$caca]
    cp $01
    jr z, $4b87
    ld a, [$cad9]
    cp $01
    jr z, $4b87
    farcall Bank31_AdvancePersistentCursorB_624F
    jr $4b87
    ld a, [$cace]
    cp $01
    jr z, $4b87
    ld a, [$cad9]
    cp $01
    jr z, $4b87
    ld a, [$caca]
    cp $01
    jr z, $4b87
    ld a, [$cbf8]
    cp $01
    jr z, $4b87
    ld a, [$def4]
    cp $80
    jr nz, $4b87
    farcall Bank31_AdvancePersistentCursorA_61D6
    farcall BANK_26, Bank26_Entry_5D37
    farcall BANK_27, Bank27_Entry_6841
    ret
NetworkRuntime_4B8C:
    ld a, $01
    ld [$cbdd], a
    ld a, $0b
    ld [$dee3], a
    call $4bb7
    ld a, $02
    farcall BANK_32, Bank32_Entry_4D2C
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 0, a
    jr z, $4bb0
    ld a, $02
    call $3844
    jr $4bb2
    jr $4b9f
    farcall BANK_27, Bank27_Entry_6841
    ret
NetworkRuntime_4BB7:
    farcall MapMenuMessage_ServiceFrame
    farcall Bank31_PairedStateDispatcher_5AC0
    ld a, [$dee3]
    cp $fe
    jr nz, $4bb7
    ret
NetworkRuntime_StageSelectorPairAlternate::
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ld [$def4], a
    ld a, b
    ld [$def5], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    farcall BANK_31, Bank31_Entry_704C
    call $4983
    farcall BANK_26, Bank26_Entry_56AC
    xor a
    ld [$dee4], a
    ld [$dee5], a
    ld [$cbf6], a
    ld [$cbf7], a
    ld [$dee8], a
    ld [$dee9], a
    ld [$deeb], a
    ld [$deec], a
    ld [$deea], a
    ld [$deed], a
    ld [$cad0], a
    ld [$cada], a
    ld [$cadb], a
    ld [$cadc], a
    ld [$cad9], a
    ld [$cacc], a
    ld [$cbfa], a
    ld [$cace], a
    ld a, $0e
    call $058d
    call $0593
    ld a, [$ba39]
    ld c, a
    ld a, $14
    sub c
    ld [$cacd], a
    call $059b
    ld a, $01
    ld [$dee3], a
    ld [$cc21], a
    call $081d
    farcall BANK_32, Bank32_Entry_4D25
    call $038b
    call $2a83
    farcall MapMenuMessage_ServiceFrame
    call $2acc
    ld a, [$dee3]
    cp $05
    jr z, $4c83
    ld a, [$dee3]
    cp $06
    jr z, $4c83
    ld a, [$dee3]
    cp $07
    jr z, $4c83
    ld a, [$dee3]
    cp $08
    jr z, $4c83
    ld a, [$cad9]
    cp $01
    jr z, $4c83
    ldh a, [$ff91]
    bit 1, a
    jr z, $4c83
    ld a, $0c
    call $3844
    ld a, $01
    ld [$cad9], a
    call $458f
    ld a, [$dee3]
    cp $fe
    jr z, $4c97
    cp $fd
    jr z, $4cc1
    cp $ff
    jr z, $4d0d
    jr $4c49
    ld a, [$cace]
    cp $00
    jr z, $4cb1
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff91]
    bit 0, a
    jr z, $4caf
    ld a, $02
    call $3844
    jr $4cb1
    jr $4c97
    farcall BANK_27, Bank27_Entry_6866
    ld a, [$deed]
    cp $00
    jr z, $4cc0
    farcall BANK_26, Bank26_Entry_563A
    ret
    ld a, $0b
    ld [$dee3], a
    ld a, $17
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $15
    farcall BANK_32, Bank32_Entry_4659
    call $4bb7
    ld a, $11
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $0e
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0307
    ld a, $82
    farcall BANK_27, Bank27_Entry_6A61
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff91]
    bit 0, a
    jr z, $4cfb
    ld a, $02
    call $3844
    jr $4cfd
    jr $4cea
    farcall BANK_27, Bank27_Entry_6841
    ld a, [$deed]
    cp $00
    jr z, $4d0c
    farcall BANK_26, Bank26_Entry_563A
    ret
    ld a, $0b
    ld [$dee3], a
    call $4bb7
    ld a, $02
    farcall BANK_32, Bank32_Entry_4D2C
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 0, a
    jr z, $4d2c
    ld a, $02
    call $3844
    jr $4d2e
    jr $4d1b
    call $4a0b
    farcall BANK_27, Bank27_Entry_6841
    ld a, [$deed]
    cp $00
    jr z, $4d40
    farcall BANK_26, Bank26_Entry_563A
    ret
    assert @ == $4d41
