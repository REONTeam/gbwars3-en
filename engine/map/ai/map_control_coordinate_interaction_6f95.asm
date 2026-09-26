include "macros/macros.inc"

; selected-map coordinate interaction dispatcher.
; B/C are taken from wMapActionTargetX/Y. An occupied coordinate enters the
; selected-unit interaction path. An empty coordinate may enter Unit Creation
; when the current property is eligible near the current side's HQ. Successful
; interaction paths refresh the map force-state indicator and return 1;
; an ineligible empty coordinate returns 0.
section "Bank $0B Selected Map Coordinate Interaction", romx[$6f95], bank[$0b]

MapControl_HandleCoordinateInteraction::
    ld a, [wMapActionTargetX]
    ld b, a
    ld a, [wMapActionTargetY]
    ld c, a
    call MapTile_GetOverlayIdAtCoordinates
    and a
    jr nz, .occupied_coordinate

    call UnitCreation_GetEligiblePropertyTypeNearHQ
    and a
    jr z, .done

    push af
    ld a, SFX_CONFIRM
    call Audio_RequestSFX
    pop af
    call UnitCreation_RunSelectionController
    farcall $0d, MapControl_UpdateForceStateIndicator
    ld a, 1
    jr .done

.occupied_coordinate
    ld a, SFX_CONFIRM
    call Audio_RequestSFX
    call UnitSelection_StagePrimaryAtCoordinates
    farcall $0d, MapControl_UpdateForceStateIndicator
    ld a, 1

.done
    ret

    assert @ == $6fca
