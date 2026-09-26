include "macros/macros.inc"
include "constants/mobile_adapter_constants.inc"

section "Mobile Adapter Fixed-Bank API", rom0[$3e00]

; Fixed-bank API slots used by the Mobile Adapter library in ROM bank $30.
; The caller selects bank $30 before entering these stubs so their internal
; calls/jumps into $4000-$7FFF resolve to the driver implementation.
MobileAdapter_Dispatch::
    jp MobileAdapter_DispatchImpl
    nop

MobileAdapter_SerialService::
    jp MobileAdapter_SerialServiceImpl
    nop

MobileAdapter_LCDStatService::
    jp MobileAdapter_LCDStatServiceImpl
    nop

MobileAdapter_StatusPointer::
    dw wMobileAdapterStatus

MobileAdapter_CommandTypeTablePointer::
    dw MobileAdapter_CommandTypeTable

MobileAdapter_DispatchImpl::
    cp $02
    ld [$d188], a
    ld a, l
    ld [$d186], a
    ld a, h
    ld [$d187], a
    jr nz, .startDriver
    ld [$d182], a
    ld a, l
    ld [$d181], a
    ld hl, $d183
    ld a, c
    ld [hli], a
    ld a, b
    ld [hl], a
.startDriver
    ld hl, $d022
    set 6, [hl]
    jp MobileAdapter_DriverDispatch

; Callback/epilogue used by the bank-$30 driver to publish A/HL as the
; completed result and clear the request-active bit before returning.
MobileAdapter_ReturnResult::
    ld [$d186], a
    ld a, l
    ld [$d187], a
    ld a, h
    ld [$d188], a
    ld hl, $d022
    res 6, [hl]
    ld hl, $d187
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [$d186]
    ret

MobileAdapter_SerialServiceImpl::
    push af
    push bc
    push de
    push hl
    call MobileAdapter_DriverSerialInterrupt
    pop hl
    pop de
    pop bc
    pop af
    ret

MobileAdapter_LCDStatServiceImpl::
    push af
    push bc
    push de
    push hl
    xor a
    ldh [rTAC], a
    ldh a, [rIF]
    and IF_CLEAR_TIMER_MASK
    ldh [rIF], a
    ld a, [$d06a]
    or a
    jr z, .doneLCDStat
    ld a, [$d022]
    bit 1, a
    jr nz, .reloadTimer
    ldh a, [rSC]
    and SC_TRANSFER_START_MASK
    jr nz, .reloadTimer
    call MobileAdapter_DriverLCDStatInterrupt
.reloadTimer
    ldh a, [rTMA]
    ldh [rTIMA], a
    ld a, TAC_65536_HZ
    ldh [rTAC], a
    ld a, TAC_ENABLE_65536_HZ
    ldh [rTAC], a
.doneLCDStat
    pop hl
    pop de
    pop bc
    pop af
    ret

; Command byte -> driver request-type mapping used by the ROM0 command bridge.
MobileAdapter_CommandTypeTable::
    db MOBILE_ADAPTER_REQUEST_02, MOBILE_ADAPTER_REQUEST_12, MOBILE_ADAPTER_REQUEST_0A, MOBILE_ADAPTER_REQUEST_14
    db MOBILE_ADAPTER_REQUEST_16, MOBILE_ADAPTER_REQUEST_18, MOBILE_ADAPTER_REQUEST_1A, MOBILE_ADAPTER_REQUEST_1E
    db MOBILE_ADAPTER_REQUEST_20, MOBILE_ADAPTER_REQUEST_22, MOBILE_ADAPTER_REQUEST_24, MOBILE_ADAPTER_REQUEST_26
    db MOBILE_ADAPTER_REQUEST_28, MOBILE_ADAPTER_REQUEST_1C, MOBILE_ADAPTER_REQUEST_2A, MOBILE_ADAPTER_REQUEST_2C
    db MOBILE_ADAPTER_REQUEST_0C, MOBILE_ADAPTER_REQUEST_0E, MOBILE_ADAPTER_REQUEST_10, MOBILE_ADAPTER_REQUEST_36
    db MOBILE_ADAPTER_REQUEST_3C, MOBILE_ADAPTER_REQUEST_06, MOBILE_ADAPTER_REQUEST_08, MOBILE_ADAPTER_REQUEST_00
    db MOBILE_ADAPTER_REQUEST_34, MOBILE_ADAPTER_REQUEST_00, MOBILE_ADAPTER_REQUEST_00, MOBILE_ADAPTER_REQUEST_00
