include "macros/macros.inc"
include "constants/unit_constants.inc"

; Shared LCD scanline transition helpers immediately following the
; sourced map-tile runtime. $4822 is called throughout the map editor/action UI
; with A supplying the target scanline; $4860 is the matched teardown/reset.
;
; The adjacent $4871 predicate is the FORTIFY availability check used by the
; Unit Action Menu. B/C are the action-target coordinates. It accepts only a
; Construction Truck standing on either neutral property ruins or a property
; owned by the current phase side, then rejects properties whose sourced
; Bank-$0C property-state record is already at the terrain-specific maximum.

section "Bank $0B scanline transition runtime", romx[$4822], bank[$0b]

LCDScanlineTransition_RunToTarget::
    push hl
    di
    ldh [hLCDScanlineTarget], a
    ld hl, LCDScanlineTransition_STATHandler
    call SetLCDStatInterrupt
    ld hl, rSTAT
    set STAT_LYC_INT_F, [hl] ; enable the LYC=LY STAT interrupt source
    ld a, $8c
    ldh [rLYC], a
    ldh [hWY], a
    ldh [rWY], a
    ld a, $07
    ldh [hWX], a
    ldh [rWX], a
    call Interrupt_EnableLCDStat
    ei
    call LCD_EnableWindow
    ldh a, [hLCDScanlineTarget]
    ld c, a
    ld b, $8c
.loop
    call DelayFrame
    dec b
    dec b
    dec b
    dec b
    ld a, b
    dec a
    ldh [rLYC], a
    ld a, b
    ldh [hWY], a
    ldh [rWY], a
    cp c
    jr nz, .loop
    pop hl
    ret

    assert @ == $4860

LCDScanlineTransition_Reset::
    call LCD_DisableWindow
    di
    call Interrupt_DisableLCDStat
    ld hl, rSTAT
    res STAT_LYC_INT_F, [hl] ; disable the LYC=LY STAT interrupt source
    call DisableLCDStatInterrupt
    ei
    ret

    assert @ == $4871

; B/C = candidate action coordinates.
; Returns A = 0 when FORTIFY may be offered, A = 1 when unavailable.
UnitFortify_IsAvailableAtCoordinates::
    push de
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    srl a
    cp UNIT_TYPE_CONSTRUCTION_TRUCK
    jr nz, .unavailable

    call MapTile_GetBaseIdAtCoordinates
    ld d, a
    call MapTile_IsNeutralPropertyRuins
    and a
    jr nz, .not_neutral_ruins
    jr .development_state_test

.not_neutral_ruins
    ld a, d
    call MapTile_GetPhaseOwnershipClass
    cp MAP_TILE_PHASE_CLASS_CURRENT_PROPERTY
    jr nz, .unavailable

.development_state_test
    farcall $0c, PropertyState_CompareCurrentToTerrainMaximum
    jr z, .unavailable
    xor a
    jr .done

.unavailable
    ld a, $01
.done
    pop de
    ret

    assert @ == $489c
