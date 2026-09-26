include "macros/macros.inc"
include "constants/unit_constants.inc"

; shared Unit Action executor. The active-unit and MOVE context-menu
; controllers both pass the selected action ID in A. The dispatcher returns 0
; when the action completes and $FF when its caller must rebuild/re-enter the
; Action Menu.
;
; proved that action IDs index 128-byte labels in the preserved custom-
; English Action Menu graphic. That mechanically closes the display identities
; used below (Fire/Fortify/Fly/Join/Delete/Pave/Build/Bomb/Supply/Drop) without
; inferring names from still-structural lower-level helpers.
;
; The range ends exactly at $63CF, the already source-backed carried-child
; controller used by both FLY ($0C) and DROP ($1C).

section "Unit Action Executor", romx[$6283], bank[$0b]

UnitAction_ExecuteSelected::
    cp UNIT_ACTION_MOVE
    jr z, .move
    cp UNIT_ACTION_PAVE
    jr z, .pave
    cp UNIT_ACTION_SUPPLY
    jr z, .supply
    cp UNIT_ACTION_FIRE
    jr z, .fire
    cp UNIT_ACTION_LOAD_INTO_CARRIER
    jr z, .load
    cp UNIT_ACTION_JOIN
    jp z, .join
    cp UNIT_ACTION_FORTIFY
    jp z, .fortify
    cp UNIT_ACTION_BUILD
    jp z, .build
    cp UNIT_ACTION_CAPTURE
    jp z, .capture
    cp UNIT_ACTION_BOMB
    jp z, .bomb
    cp UNIT_ACTION_DELETE
    jp z, .delete
    cp UNIT_ACTION_WAIT
    jp z, .wait
    cp UNIT_ACTION_FLY
    jr z, .carried_child
    cp UNIT_ACTION_DROP
    jr z, .carried_child
    jp .cancel_or_retry

.carried_child
    call UnitTransport_RunCarriedChildActionController
    ret

.move
    call UnitAction_RunMove
    cp $ff
    jp nz, .complete
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    push bc
    call MapControl_PanToCoordinates
    pop bc
    ld a, $ff
    ret

.pave
    ld a, $01
    ld [$c9dd], a
    jr .move

.supply
    farcall UnitSupply_Execute
    jp .complete

.fire
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    ld a, [$c9d8]
    farcall $0c, UnitAction_RunFireTargetSelection
    cp $ff
    jp nz, .complete
    ld a, [$cce1]
    ld [$ca9f], a
    ld a, [$cce4]
    ld [$caa0], a
    jp .cancel_or_retry

.load
    call UnitAction_FinalizeActiveUnitActionState
    call Unit_LoadIntoCarrierAtActionTarget
    jp .complete

.join
    call UnitHPTransfer_Run
    cp $ff
    jp z, .cancel_or_retry
    ld a, $04
    farcall $0c, UnitAction_PresentActionEffect
    ld a, SFX_UNIT_LIST_DELETE
    call MapControl_ResolutionSceneRefresh
    ld a, SFX_ACTION_EXECUTE
    call Audio_PlaySFX
    jp .complete

.fortify
    call Unit_DevelopTerrainAtCurrentPosition
    cp $ff
    jp z, .cancel_or_retry
    call UnitAction_FinalizeActiveUnitActionState
    call UnitAction_AwardCurrentHPAsExperience
    call MapEconomy_RecalculateIncome
    jp .complete

.build
    call Construction_RunTerrainActionController
    cp $ff
    jr z, .cancel_or_retry
    call UnitAction_FinalizeActiveUnitActionState
    call UnitAction_AwardCurrentHPAsExperience
    call MapEconomy_RecalculateIncome
    jr .complete

.capture
    call UnitAction_FinalizeActiveUnitActionState
    call Unit_CapturePropertyAtCurrentPosition
    jr .complete

.bomb
    ld a, [$c9d8]
    farcall $0c, UnitAction_RunBombTargetSelection
    cp $ff
    jr z, .cancel_or_retry
    call UnitAction_FinalizeActiveUnitActionState
    ld a, [$c9d8]
    farcall $12, UnitRecord_CopyToScratch
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    farcall $0c, MapAI_ApplyAreaAttackAroundTarget
    push af
    ld a, [$c9d8]
    farcall $12, UnitRecord_CopyFromScratch
    pop af
    add a, $0a
    ld l, a
    ld h, $00
    ld a, [$c9d8]
    farcall $12, UnitRecord_AddExperienceClamped
    call MapEconomy_RecalculateIncome
    call $04d2
    call $04d2
    call $04d2
    call $04d2
    ld a, [$ccde]
    ld b, a
    ld a, [$ccdf]
    ld c, a
    farcall $0b, MapControl_PanToCoordinates
    jr .complete

.wait
    call UnitAction_FinalizeActiveUnitActionState
    ld a, $04
    farcall $0c, UnitAction_PresentActionEffect
    call UnitAction_FinalizeWait
    jr .complete

.delete
    call UnitAction_DeleteAtActionTarget
    jr .complete

.complete
    xor a
    ret

.cancel_or_retry
    ld a, $ff
    ret

    assert @ == $63cf
