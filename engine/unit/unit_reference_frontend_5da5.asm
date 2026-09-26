include "macros/macros.inc"

; Unit-reference / detailed-unit-information frontend used from gameplay,
; Unit List, carried-unit selection and unit-creation screens.
;
; Public entry contract:
;   A = unit type, or $FF to open the internal type chooser first
;   B = side/palette selector
; The detail viewer returns through the same frontend; direct-detail callers
; leave when the viewer backs out, while chooser mode returns to the chooser.

DEF wUnitReferenceInitialType        EQU $cd77
DEF wUnitReferenceSide               EQU $cd78
DEF wUnitReferenceListRow            EQU $d979
DEF wUnitReferenceListColumn         EQU $d97a
DEF wUnitReferenceSubmenuIndex       EQU $d97c
DEF wUnitReferenceScratchDA40        EQU $da40
DEF wUnitReferenceScratch0           EQU $d9ca
DEF wUnitReferenceScratch1           EQU $d9cb
DEF wUnitReferenceScratch2           EQU $d9cc
DEF wUnitReferenceScratch3           EQU $d9cd
DEF wUnitReferenceCurrentType        EQU $d9ba
DEF wUnitReferenceClassIndex         EQU $d9bb
DEF wUnitReferenceTextBuffer         EQU $cd28

section "Unit Reference Frontend", romx[$5da5], bank[$25]

UnitReference_Open::
    push af
    ld a, b
    ld [wUnitReferenceSide], a
    pop af
    ld [wUnitReferenceInitialType], a
    cp $ff
    jr nz, .open_details

.choose_type
    call UnitReference_ChooseType
    cp $ff
    jr z, .done

.open_details
    push af
    ld a, [wUnitReferenceInitialType]
    cp $ff
    jr z, .restore_selected_type
    ld [wUnitReferenceInitialType], a
    pop af
    jr .run_details
.restore_selected_type
    pop af
.run_details
    call UnitReference_RunDetailController
    cp $ff
    jr z, .backed_out
    jr .done
.backed_out
    ld a, [wUnitReferenceInitialType]
    cp $ff
    jr z, .choose_type
.done
    ret
    assert @ == $5dd9

; Clear the WRAM3 navigation/detail scratch used by the Unit Reference UI.
UnitReference_ResetWorkState::
    ldh a, [hWRAMBank]
    push af
    ld a, 3
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [wUnitReferenceListRow], a
    ld [wUnitReferenceListColumn], a
    ld [wUnitReferenceSubmenuIndex], a
    ld [wUnitReferenceScratchDA40], a
    ld [wUnitReferenceScratch0], a
    ld [wUnitReferenceScratch1], a
    ld [wUnitReferenceScratch2], a
    ld [wUnitReferenceScratch3], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
    assert @ == $5e01

; Structural helper used by the deeper detail pages.
UnitReference_DrawText6500::
    ld hl, UnitReference_String_DetailMarker
    call TextPut
    ret
    assert @ == $5e08

; A = unit type, BC = TextPut destination.
UnitReference_DrawUnitName::
    push bc
    sla a
    farcall UnitData_CopyNameToBuffer
    ld hl, wUnitReferenceTextBuffer
    farcall UnitList_EncodeDisplayValue
    pop bc
    ld hl, wUnitReferenceTextBuffer
    call TextPut
    ret
    assert @ == $5e1e

; Resolve the current unit's five-way display class and print the matching
; ARMORED / UNARMORED / AIR / SEA / SUB label at BC.
UnitReference_DrawUnitClassName::
    push bc
    ld a, [wUnitReferenceCurrentType]
    sla a
    ld c, $18
    farcall UnitData_GetByte
    ld [wUnitReferenceClassIndex], a
    add a
    ld hl, UnitReference_ClassStringPointers
    call AddAtoHL
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld h, d
    ld l, e
    pop bc
    call TextPut
    ret
    assert @ == $5e3f

UnitReference_ClassStringPointers::
    dw UnitStatus_Type_Armored
    dw UnitStatus_Type_Unarmored
    dw UnitStatus_Type_Air
    dw UnitStatus_Type_Sea
    dw UnitStatus_Type_Submarine
    assert @ == $5e49
