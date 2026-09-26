include "macros/macros.inc"

; detect the transition where either side's live-unit count reaches
; zero after that side has previously fielded at least one unit. The latched
; side-presence bits prevent an initially empty side from being treated as an
; elimination. The resulting controller pair at wMapControlWinningSide/wMapControlResolutionType remains structural
; beyond the exact values written here.

section "Map Control Unit Elimination Update", romx[$6d69], bank[$0b]

MapControl_PostDirectAttackUpdate::
    ld hl, wMapControlSeenLiveUnitsFlags

    ld a, [wUnitCountBySide]
    and a
    jr z, .check_side_0_eliminated
    set 0, [hl]
    jr .check_side_1

.check_side_0_eliminated
    bit 0, [hl]
    jr nz, .side_0_eliminated

.check_side_1
    ld a, [wUnitCountBySide + 1]
    and a
    jr z, .check_side_1_eliminated
    set 1, [hl]
    jr .no_new_elimination

.check_side_1_eliminated
    bit 1, [hl]
    jr nz, .side_1_eliminated

.no_new_elimination
    xor a
    jr .done

.side_1_eliminated
    ld a, 1
    jr .stage_winner

.side_0_eliminated
    ld a, 2

.stage_winner
    ld [wMapControlWinningSide], a
    ld a, MAP_RESOLUTION_TYPE_FORCE_DEFEAT
    ld [wMapControlResolutionType], a

.done
    ret

    assert @ == $6d9a

; SHA-1 $09ce0da2b3a192154cbd167d66f853177222ffaa ($6D69-$6D99)
