include "macros/macros.inc"
include "constants/unit_constants.inc"

; transport-state gate used by the Unit Action Menu builder.
; Returns A = 1 when the selected scratch unit has no carried children or when
; the selected unit is itself carried. Returns A = 0 only for a top-level unit
; that currently carries at least one child unit.
section "Bank $0B Unit transport carried-or-empty test", romx[$5cb0], bank[$0b]

UnitTransport_TestCarriedOrNoCargo::
    ld a, [wUnitRecordScratch + UNIT_RECORD_CARRIED_COUNT_OFFSET]
    and a
    jr z, .reject

    ld a, [wUnitRecordScratch + UNIT_RECORD_STATUS_OFFSET]
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr nz, .reject

    xor a
    jr .done

.reject
    ld a, 1

.done
    ret

    assert @ == $5cc3
