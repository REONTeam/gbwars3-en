include "macros/macros.inc"

; caller-backed Bank $0B continuation after the corrected
; MapControl_ReinitializeAfterResolution boundary. Public names stay at the
; level proven by concrete presentation/state behavior.
section "Bank $0B resolution presentation reset and HQ staging", romx[$6a23], bank[$0b]
MapControl_ResetResolutionPresentationState::
    xor a
    ld b, $10
    ld hl, $6a86
    call $06bc
    call $06f2
    call $04d2
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $9800
    ld bc, $0400
    xor a
    call $3b84
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $9800
    ld bc, $0400
    xor a
    call $3b79
    call $4000
    call $45c1
    call $430a
    xor a
    ld [$ca92], a
    ld [$ca93], a
    ld [$ca94], a
    ld [$ca95], a
    ld [$ca96], a
    ld [$c9a1], a
MapControl_StageCurrentSideUnitPoolBase::
    set 0, a
    ldh [$ffb1], a
    farcall MapControl_UpdateForceStateIndicator
    ld b, $00
    ld a, [$c633]
    and $01
    jr z, $6a81
    ld b, $32
    ld a, b
    ld [$ca99], a
    ret
MapControl_ResolutionZeroPaletteData::
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
MapControl_CacheHQCoordinatesAndApplyCurrentSide::
    ld de, $c646
    ld hl, $c993
    ld bc, $0004
    call $3b50
    ld a, [$c633]
    and $01
    add a, a
    ld hl, $c646
    call $29bc
    ld a, [hli]
    ld b, a
    ld c, [hl]
    farcall MapViewport_CenterOnCoordinates
    ret
    assert @ == $6b26
