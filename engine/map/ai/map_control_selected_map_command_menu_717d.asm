include "macros/macros.inc"

; Selected-map command-menu construction used by the controller at $7226.
; Command IDs are tied directly to the 31-slice Action Menu graphics table,
; so the player-facing Unit/Status/Option/Yield/Save/Map/Call/End/Recv/Retry/Intrpt
; identities are now stable constants rather than anonymous numeric IDs.

DEF wSelectedMapCommandGateState EQU $c9b5
DEF wSelectedMapSide0State       EQU $c655
DEF wSelectedMapSide1State       EQU $c660

section "Bank $0B Selected Map Command Menu", romx[$717d], bank[$0b]

MapControl_BuildSelectedMapCommandMenu::
    push bc
    ld a, $c0
    call UnitActionMenu_Reset

    ; UNIT is present only while the active side has at least one unit.
    ld a, [wMapPhaseNumber]
    and $01
    ld c, a
    ld b, $00
    ld hl, wUnitCountBySide
    add hl, bc
    ld a, [hl]
    and a
    jr z, .skip_command_01
    ld a, MAP_COMMAND_UNIT
    call UnitActionMenu_AddEntry
.skip_command_01

    ld a, MAP_COMMAND_STATUS
    call UnitActionMenu_AddEntry
    ld a, MAP_COMMAND_OPTION
    call UnitActionMenu_AddEntry

    ld a, [wMapControlInfraredBattleMode]
    cp $01
    jr z, .append_command_1e
    ld a, MAP_COMMAND_YIELD
    call UnitActionMenu_AddEntry
    jr .after_command_04_1e
.append_command_1e
    ld a, MAP_COMMAND_INTERRUPT
    call UnitActionMenu_AddEntry
.after_command_04_1e

    ld a, [wActiveGameMode]
    cp $00
    jr z, .skip_command_05
    call MapControl_TestSaveCommandAvailability
    jr z, .skip_command_05
    ld a, MAP_COMMAND_SAVE
    call UnitActionMenu_AddEntry
.skip_command_05

    ld a, MAP_COMMAND_MAP
    call UnitActionMenu_AddEntry

    ld hl, wSelectedMapSide0State
    ld a, [wMapPhaseNumber]
    and $01
    jr z, .have_side_state
    ld hl, wSelectedMapSide1State
.have_side_state
    ld a, [hl]
    and a
    jr z, .skip_command_07
    farcall $11, CampaignStats_TestProcuredFlag35
    jr nz, .skip_command_07
    ld a, MAP_COMMAND_CALL
    call UnitActionMenu_AddEntry
.skip_command_07

    ld a, [wActiveGameMode]
    cp $00
    jr nz, .skip_command_1d
    ld a, MAP_COMMAND_RETRY
    call UnitActionMenu_AddEntry
.skip_command_1d

    call MapControl_TestEndCommandAvailability
    jr z, .append_command_19
    ld a, MAP_COMMAND_END
    call UnitActionMenu_AddEntry
    jr .done_tail
.append_command_19
    ld a, MAP_COMMAND_RECEIVE
    call UnitActionMenu_AddEntry
.done_tail
    pop bc
    ret

; END is available only when infrared battle mode is active and $C9B5 == 1.
MapControl_TestEndCommandAvailability::
MapControl_TestCommand08Availability:: ; compatibility alias
    ld a, [wMapControlInfraredBattleMode]
    cp $01
    ret nz
    ld a, [wSelectedMapCommandGateState]
    cp $01
    ret

; SAVE requires infrared battle mode is active, rejects $C9B5 == 1, and then requires the
; side bit of wMapPhaseNumber to be 1.
MapControl_TestSaveCommandAvailability::
MapControl_TestCommand05Availability:: ; compatibility alias
    ld a, [wMapControlInfraredBattleMode]
    cp $01
    ret nz
    ld a, [wSelectedMapCommandGateState]
    cp $01
    ret z
    ld a, [wMapPhaseNumber]
    and $01
    cp $01
    ret

    assert @ == $7226
