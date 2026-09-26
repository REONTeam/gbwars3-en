include "macros/macros.inc"

; earliest Bank $19 network/mobile runtime caller cluster.
; Two routines copy fixed-width SRAM-backed byte fields, convert the staged Shift-JIS
; stream through the Bank $22 parser, and copy game-text bytes to destination work buffers.
; Other state-control labels remain deliberately neutral until later Bank $19 callers are sourced.

section "Bank19 Network Runtime 4000", romx[$4000], bank[$19]
NetworkRuntime_StateDispatchFrontEnd::
    ld a, [$dee3]
    cp $01
    jr z, $402f
    cp $02
    jr z, $4033
    cp $13
    jr z, $406b
    cp $14
    jr z, $406f
    cp $15
    jp z, $40b4
    cp $16
    jp z, $40b8
    cp $29
    jr z, $404b
    cp $2a
    jr z, $404f
    cp $07
    jp z, $40fd
    cp $08
    jp z, $4101
    farcall BANK_0A, Bank0A_Entry_4039
    farcall BANK_0A, Bank0A_Entry_4068
    jp c, $4118
    or a
    jr nz, $403f
    jr $4045
    ld a, $02
    ld [$dee3], a
    ret
    ld a, $29
    ld [$dee3], a
    ret
    farcall BANK_0A, Bank0A_Entry_442F
    farcall BANK_0A, Bank0A_Entry_4445
    jp c, $4118
    or a
    jr nz, $405b
    jr $4061
    ld a, $2a
    ld [$dee3], a
    ret
    farcall Bank31_PersistentSetup_5EA0
    ld a, $13
    ld [$dee3], a
    ret
    farcall BANK_0A, Bank0A_Entry_4417
    farcall BANK_0A, Bank0A_Entry_442D
    jp c, $4118
    or a
    jr nz, $407b
    jr $4081
    ld a, $14
    ld [$dee3], a
    ret
    assert @ == $4081

section "Bank19 Network Runtime 4081", romx[$4081], bank[$19]
NetworkText_ConvertSavedField33::
    ld a, $0f
    call $058d
    call $0593
    ld de, $a0cc
    ld hl, $d938
    ld bc, $0021
    call $3b50
    call $059b
    ld hl, $d938
    ld de, $daa8
    farcall Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld de, $daa8
    ld hl, $d89a
    ld bc, $0021
    call $3b50
    ld a, $15
    ld [$dee3], a
    ret
    assert @ == $40b4

section "Bank19 Network Runtime 40B4", romx[$40b4], bank[$19]
NetworkRuntime_State15_16Gate::
    farcall BANK_0A, Bank0A_Entry_43EE
    farcall BANK_0A, Bank0A_Entry_4404
    jp c, $4118
    or a
    jr nz, $40c4
    jr $40ca
    ld a, $16
    ld [$dee3], a
    ret
    assert @ == $40ca

section "Bank19 Network Runtime 40CA", romx[$40ca], bank[$19]
NetworkText_ConvertSavedField31::
    ld a, $0f
    call $058d
    call $0593
    ld de, $a0cc
    ld hl, $d96a
    ld bc, $001f
    call $3b50
    call $059b
    ld hl, $d96a
    ld de, $daa8
    farcall Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld de, $daa8
    ld hl, $d8cc
    ld bc, $001f
    call $3b50
    ld a, $07
    ld [$dee3], a
    ret
    assert @ == $40fd

section "Bank19 Network Runtime 40FD", romx[$40fd], bank[$19]
NetworkRuntime_State07_08Gate::
    farcall BANK_0A, Bank0A_Entry_406B
    farcall BANK_0A, Bank0A_Entry_4070
    jr c, $4118
    or a
    jr nz, $410c
    jr $4112
    ld a, $08
    ld [$dee3], a
    ret
    ld a, $fe
    ld [$dee3], a
    ret
    assert @ == $4118

section "Bank19 Network Runtime 4118", romx[$4118], bank[$19]
NetworkRuntime_StageSharedBytes::
    ld a, [$c8bb]
    ld [$cab0], a
    ld a, [$c8bc]
    ld [$cab1], a
    ld a, [$c8bd]
    ld [$cab2], a
    ld a, $ff
    push af
    farcall BANK_0A, Bank0A_Entry_406B
    farcall BANK_0A, Bank0A_Entry_4070
    or a
    jr nz, $4131
    pop af
    ret
    assert @ == $413a

section "Bank19 Network Runtime 413A", romx[$413a], bank[$19]
NetworkRuntime_BankedStateCopy::
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0e
    call $058d
    call $0593
    ld a, [$cace]
    cp $01
    jr z, $418c
    ld a, [$def4]
    cp $01
    jr z, $4176
    cp $0a
    jr z, $417e
    cp $03
    jr z, $4167
    cp $02
    jr z, $4186
    jr $418c
    ld a, [$def5]
    cp $02
    jr nz, $418c
    ld a, [$cad1]
    ld [$bb3e], a
    jr $418c
    ld a, [$cad1]
    ld [$bb3f], a
    jr $418c
    ld a, [$cad1]
    ld [$bb40], a
    jr $418c
    ld a, [$cad1]
    ld [$bb41], a
    call $059b
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $4195
