include "macros/macros.inc"
include "constants/unit_constants.inc"

; Map-side control and active-force helpers in physical Bank $0D.
; Older reference notes called this Bank $14; corrects that attribution
; from direct same-bank CALL sites in the retail ROM.

section "Map Control Unit Eligibility Mask", romx[$4b91], bank[$0d]
MapControl_RebuildCaptureTargetMask::
    push bc
    push de
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld hl, $dd80
    ld bc, $000d
    xor a
    call $3b79
    ld e, $00
    ld hl, $dd81
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [hli]
    ld b, [hl]
    inc hl
    ld c, [hl]
    inc hl
    push hl
    cp $ff
    jr z, $4bd2
    call $0985
    farcall MapControl_IsCaptureTargetRejected
    and a
    jr nz, $4bd2
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, e
    ld hl, $dd80
    call $3ad1
    pop hl
    inc e
    ld a, e
    cp $64
    jr nz, $4bab
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop de
    pop bc
    ret
    assert @ == $4be1

section "Map Control Derived Map Buffer", romx[$5c42], bank[$0d]
MapControl_BuildMapAnalysisBuffer::
    ldh a, [$ff82]
    push af
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0c
    call $058d
    call $0593
    ld hl, $a000
    ld bc, $0d80
    xor a
    call $3b79
    ld a, $01
    ldh [$ff99], a
    ld hl, $ffa3
    ld de, $5cbc
    call $08c0
    ld de, $08bf
    call $08c0
    ld de, $5cc0
    call $08c0
    ld de, $08bf
    call $08c0
    ld c, $00
    ld b, $00
    push bc
    xor a
    ldh [$ff9a], a
    call $5cc0
    and a
    jr nz, $5c9e
    call $0850
    ldh a, [$ff9a]
    and a
    jr nz, $5c99
    ldh a, [$ff99]
    call $5d06
    jr $5c9e
    ldh a, [$ff99]
    inc a
    ldh [$ff99], a
    pop bc
    inc b
    ld a, [$c989]
    cp b
    jr nz, $5c80
    inc c
    ld a, [$c98a]
    cp c
    jr nz, $5c7e
    ldh a, [$ff99]
    dec a
    ld [$c60c], a
    call $059b
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $5cbc

section "Map Player Control Initialization", romx[$6618], bank[$0d]
MapControl_InitializePlayers::
    ld a, [$c62f]
    cp $05
    jr z, $6647
    ld a, $00
    ld [$c631], a
    ld [$c632], a
    ld a, [$c62f]
    cp $04
    jr z, $664f
    cp $02
    jr nz, $6640
    ld a, [$c883]
    cp $1e
    jr c, $6640
    ld a, $01
    ld [$c631], a
    jr $664f
    ld a, $01
    ld [$c632], a
    jr $664f
    ld a, $01
    ld [$c631], a
    ld [$c632], a
    ret
    assert @ == $6650

section "Map Control Runtime Setup", romx[$6650], bank[$0d]
MapControl_InitializeRuntimeOnce::
    ld a, [$c99f]
    and a
    jr nz, $6678
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    call $5c42
    call $66b1
    ld a, $01
    ld [$c99f], a
    xor a
    ld [$c99c], a
    ld a, $04
    ld [$dea1], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
MapControl_InitializePhaseRuntime::
    call $3056
    call $4b91
    call $6870
    xor a
    ld [$c9de], a
    ld [$c9dd], a
    ld a, [$c633]
    and $01
    jr nz, $6695
    ld hl, $66a9
    jr $6698
    ld hl, $66ad
    ld a, [hli]
    ld [$c99e], a
    ld a, [hli]
    ld [$c9a2], a
    ld a, [hli]
    ld [$c9a3], a
    ld a, [hli]
    ld [$c9a4], a
    ret
MapControl_PhaseParamsSide0:
    nop
    nop
    ld [hld], a
    nop
MapControl_PhaseParamsSide1:
    ld bc, $0032
    dec bc
MapControl_ClassifyForceBalance::
    push bc
    push de
    ld b, $00
    call $670e
    ld a, l
    ldh [$ff99], a
    ld a, h
    ldh [$ff9a], a
    push hl
    ld b, $32
    call $670e
    ld a, l
    ldh [$ff9b], a
    ld a, h
    ldh [$ff9c], a
    pop de
    srl d
    rr e
    call $29ca
    jr z, $66e8
    jr c, $66e8
    srl d
    rr e
    call $29ca
    jr z, $66e5
    jr c, $66e5
    ld a, $01
    jr $6708
    xor a
    jr $6708
    ldh a, [$ff99]
    ld e, a
    ldh a, [$ff9a]
    ld d, a
    srl h
    rr l
    call $29ca
    jr nc, $6706
    srl h
    rr l
    call $29ca
    jr nc, $6704
    ld a, $03
    jr $6708
    ld a, $02
    ld a, $ff
    ld [$c9a0], a
    pop de
    pop bc
    ret
    assert @ == $670e

section "Active Unit Force Value", romx[$670e], bank[$0d]
UnitForceValue_CalcSideTotal::
    push de
    ld hl, $0000
    ld c, $32
    ld a, b
    call $671f
    add hl, de
    inc b
    dec c
    jr nz, $6714
    pop de
    ret
UnitForceValue_CalcUnitContribution::
    push bc
    push hl
    ld b, a
    ld c, $03
    call $090b
    bit 1, a
    jr nz, $6752
    ld a, b
    ld c, $00
    call $090b
    and a
    jr z, $6752
    ld c, $10
    farcall UnitData_GetWord
    push de
    ld a, b
    ld c, $04
    call $090b
    pop hl
    ld e, a
    ld d, $00
    call $29d8
    ld d, h
    ld e, l
    ld bc, $000a
    call $2a21
    jr $6755
    ld de, $0000
    pop hl
    pop bc
    ret
    assert @ == $6758

section "Map Control Force-State Continuation", romx[$6758], bank[$0d]
MapControl_GetPhaseForceRelation::
    push bc
    ld a, [$c9a0]
    cp $ff
    jr z, $6773
    srl a
    ld b, a
    ld a, [$c633]
    and $01
    cp b
    jr nz, $676f
    ld a, $01
    jr $6774
    ld a, $02
    jr $6774
    xor a
    pop bc
    ret
MapControl_UpdateForceStateIndicator::
    push bc
    ld a, [$c686]
    and a
    jr z, $678f
    call $66b1
    ld a, [$c686]
    call $6794
    ld hl, $c9a1
    cp [hl]
    jr z, $6792
    ld [$c9a1], a
    call $3816
    pop bc
    ret
MapControl_ComputeForceStateValue::
    push bc
    dec a
    add a, a
    ld b, a
    add a, a
    add a, b
    add a, $03
    ld b, a
    ld a, [$c633]
    and $01
    ld c, a
    add a, a
    add a, b
    add a, c
    ld b, a
    call $6758
    add a, b
    pop bc
    ret
MapControl_CheckLatePhaseResolution::
    ld a, [$c685]
    bit 5, a
    jr z, $67e4
    ld a, [$c99c]
    and a
    jr nz, $67e4
    ld a, [$c633]
    srl a
    cp $0a
    jr c, $67e4
    call $67e6
    and a
    jr z, $67e4
    call $680d
    and a
    jr z, $67e4
    call $66b1
    call $6758
    cp $02
    jr nz, $67e4
    ld a, [$c9a0]
    bit 0, a
    jr z, $67e4
    ld a, $01
    jr $67e5
    xor a
    ret
MapControl_CheckSevereUnitCountDisadvantage::
    push bc
    ld a, [$c99e]
    xor $01
    ld hl, $cd09
    call $29bc
    ld a, [hl]
    cp $0a
    jr c, $680a
    ld b, a
    ld a, [$c99e]
    ld hl, $cd09
    call $29bc
    ld a, [hl]
    add a, a
    cp b
    jr nc, $680a
    ld a, $01
    jr $680b
    xor a
    pop bc
    ret
MapControl_CheckActiveSideValueThreshold::
    push bc
    ld a, [$c99e]
    add a, a
    ld hl, $c642
    call $29bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld hl, $001e
    call $29ca
    jr nc, $6827
    ld a, $01
    jr $6828
    xor a
    pop bc
    ret
MapControl_TriggerLatePhaseResolution::
    push bc
    ld b, $03
    push bc
    ld a, $13
    farcall MapControl_ResolutionSceneRefresh
    ld a, $1e
    call $3baf
    pop bc
    dec b
    jr nz, $682d
    call $2164
    ld a, $01
    ld [$c99c], a
    ld a, [$c633]
    and $01
    farcall MapSurrenderPrompt_Run
    and a
    jr nz, $685c
    farcall CampaignStats_IncrementResolutionCounter
    farcall MapControl_ReinitializeAfterResolution
    xor a
    jr $686e
    ld a, $03
    ld [$ca95], a
    ld a, [$c633]
    and $01
    xor $01
    inc a
    ld [$ca94], a
    ld a, $01
    pop bc
    ret
    assert @ == $6870

section "Map Control Phase Refresh", romx[$6870], bank[$0d]
MapControl_RefreshPhaseState::
    ldh a, [$ff82]
    push af
    ld a, $02
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$dea0], a
    call $59d4
    ld a, b
    ld [$de9a], a
    ld a, c
    ld [$de9b], a
    call $5da5
    ld a, $02
    call $58a2
    call $5d9c
    ld a, $a0
    call $08e6
    call $0593
    ld a, $0d
    call $058d
    ld d, [hl]
    call $059b
    ld a, d
    cp $ff
    jr z, $68b1
    ld a, [$dea0]
    set 0, a
    ld [$dea0], a
    ld a, [$dea0]
    set 1, a
    ld [$dea0], a
    call $5a86
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $68c2
