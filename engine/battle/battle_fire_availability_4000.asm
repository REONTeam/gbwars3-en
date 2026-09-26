include "macros/macros.inc"
include "constants/unit_constants.inc"

; FIRE availability target scan. The acting unit is staged as the battle
; attacker, every live unit in the opposing 50-slot pool is tested, and the
; IDs of attackable targets are written to the same DBF7/DBF8 scratch list
; consumed by the interactive FIRE selector at $418F.
DEF wFireAvailabilityCandidateTypeSide EQU $c941
DEF wFireAvailabilityTargetCount       EQU $dbf7
DEF wFireAvailabilityTargetIDs         EQU $dbf8

section "Bank $0C Unit Action FIRE Availability", romx[$4000], bank[$0c]

; A = acting live-unit index, B/C = attack origin.
; Returns A=0 when at least one target is attackable, A=1 otherwise.
UnitAction_CheckFireAvailable::
    call FireTargetList_BuildAttackableUnits
    and a
    jr nz, .available
    ld a, 1
    jr .done
.available
    xor a
.done
    ret

; A = acting live-unit index, B/C = attack origin.
; Returns A = number of attackable targets and fills DBF8+ with their live-unit
; indices. Carried/reserve units are ignored. Weapon suitability is delegated
; to the already-source-backed battle weapon selector using the computed hex
; distance and target unit class.
FireTargetList_BuildAttackableUnits::
    push bc
    push de
    push hl
    ld e, a

    ldh a, [hWRAMBank]
    push af
    ld a, 4
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld a, e
    ld [wBattleAttackerUnitID], a
    farcall $12, UnitWeapon_BuildSummary
    ld a, b
    ld [wBattleOtherX], a
    ld a, c
    ld [wBattleOtherY], a

    xor a
    ld [wFireAvailabilityTargetCount], a
    ld [wBattleDefenderUnitID], a
    ld e, UNITS_PER_SIDE
    ld a, [wUnitRecordScratch + UNIT_RECORD_TYPE_SIDE_OFFSET]
    and UNIT_SIDE_1
    jr nz, .scan
    ld a, UNITS_PER_SIDE
    ld [wBattleDefenderUnitID], a

.scan
    push de
    call .check_candidate
    cp $ff
    jr z, .next
    ld a, [wFireAvailabilityTargetCount]
    ld hl, wFireAvailabilityTargetIDs
    call AddAtoHL
    ld a, [wBattleDefenderUnitID]
    ld [hl], a
    ld hl, wFireAvailabilityTargetCount
    inc [hl]
.next
    pop de
    ld a, [wBattleDefenderUnitID]
    inc a
    ld [wBattleDefenderUnitID], a
    dec e
    jr nz, .scan

    ld a, [wFireAvailabilityTargetCount]
    ld b, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, b
    pop hl
    pop de
    pop bc
    ret

.check_candidate
    push bc
    push de
    push hl

    ld a, [wBattleDefenderUnitID]
    ld c, UNIT_RECORD_TYPE_SIDE_OFFSET
    farcall $12, UnitRecord_GetByte
    and a
    jp z, .reject
    ld [wFireAvailabilityCandidateTypeSide], a

    ld a, [wBattleDefenderUnitID]
    ld c, UNIT_RECORD_STATUS_OFFSET
    farcall $12, UnitRecord_GetByte
    bit UNIT_RECORD_STATUS_CARRIED_F, a
    jr nz, .reject
    bit UNIT_RECORD_STATUS_RESERVE_F, a
    jr nz, .reject

    ld a, [wBattleDefenderUnitID]
    ld c, UNIT_RECORD_X_OFFSET
    farcall $12, UnitRecord_GetWord
    ld b, e
    ld c, d
    ld a, [wBattleOtherX]
    ld d, a
    ld a, [wBattleOtherY]
    ld e, a
    farcall $0b, HexGrid_GetDistance
    ld [wBattleDistance], a
    ld b, a

    ld a, [wFireAvailabilityCandidateTypeSide]
    call Battle_SelectWeaponAttackIgnoringAmmo
    and a
    jr z, .reject
    xor a
    jr .done
.reject
    ld a, $ff
.done
    pop hl
    pop de
    pop bc
    ret

    assert @ == $40c1
