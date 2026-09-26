include "macros/macros.inc"

; completion helpers reached only by the shared Unit Action executor.
; The DELETE identity is closed by the preserved Action Menu plus the direct
; Unit_DeleteWithCarriedAtCoordinates call. WAIT remains a compact completion
; path that refreshes map presentation and requests the established SFX.

section "Bank $0B Unit Action DELETE completion", romx[$6524], bank[$0b]

UnitAction_DeleteAtActionTarget::
    ld a, [$c9d9]
    ld b, a
    ld a, [$c9da]
    ld c, a
    ld a, [$c9db]
    call $4740
    ld a, [$c9dc]
    call $4758
    call $43d1
    ld a, [$c9d8]
    farcall $12, Unit_DeleteWithCarriedAtCoordinates
    call UnitSelection_ClearCoordinateMapPresentation
    ld a, SFX_MEDAL_DETAIL
    call MapControl_ResolutionSceneRefresh
    ld a, SFX_UNIT_DELETE
    call Audio_RequestSFX
    ret

    assert @ == $6550

section "Bank $0B Unit Action WAIT completion", romx[$6550], bank[$0b]

UnitAction_FinalizeWait::
    ld a, SFX_UNIT_CREATE
    call MapControl_ResolutionSceneRefresh
    ld a, SFX_WAIT_ACTION
    call Audio_RequestSFX
    ret

    assert @ == $655b
