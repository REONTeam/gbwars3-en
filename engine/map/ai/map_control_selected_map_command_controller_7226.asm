include "macros/macros.inc"
include "constants/unit_constants.inc"

; Selected-map command controller. The shared menu graphics provide the stable
; player-facing identities for all dispatched IDs in this family:
; Unit/Status/Option/Yield/Save/Map/Call/End/Recv/Retry/Intrpt.
;
; $746D is independently reused by the following map-phase/Call family and is
; retained as the next hard ownership boundary.

DEF wSelectedMapRetryChoice      EQU $c021

section "Selected Map Command Controller", romx[$7226], bank[$0b]
MapControl_RunSelectedMapCommandController::
    call $717d
    call $4700
    call $3056
    call $5108
    ld a, $0b
    call $3844
    call $4fc0
    push af
    call $515f
    pop af
    cp $01
    jr z, $7277
    cp $02
    jr z, $727f
    cp $03
    jr z, $7284
    cp $04
    jr z, $7289
    cp $1e
    jr z, $7294
    cp $05
    jr z, $729f
    cp $07
    jp z, $72a7
    cp $08
    jp z, $72ac
    cp $19
    jp z, $72b0
    cp $06
    jr z, $72b6
    cp $1d
    jr z, $72bb
    ld a, $00
    ret
    ld a, $01
    ret
    ld a, $02
    ret
    call $72c7
    and a
    jr z, $726e
    jr $7271
    call $730a
    jr $7271
    call $7318
    jr $7271
    call $7323
    ld a, [$ca94]
    and a
    jr nz, $726e
    jr $7271
    call $733e
    ld a, [$ca94]
    and a
    jr nz, $726e
    jr $7271
    call $7359
    and a
    jr z, $7274
    jr $7271
    call $7486
    jr $726e
    call $743c
    ret
    call $7462
    jp $7271
    call $7613
    jr $7271
    call $737d
    and a
    jr z, $72c4
    ld a, $03
    ret
    ld a, $00
    ret
MapControl_ExecuteSelectedMapCommandUnit::
    call $2164
    call $07b4
    ld a, $00
    farcall UnitList_RunController
    cp $ff
    jr z, $7303
    ld d, a
    ld c, $03
    farcall UnitRecord_GetByte
    bit 1, a
    jr nz, $72f9
    ld a, d
    ld c, $01
    farcall UnitRecord_GetByte
    ld b, a
    ld a, d
    ld c, $02
    farcall UnitRecord_GetByte
    ld c, a
    call $7acb
    ld a, $ff
    jr $7303
    ld a, d
    farcall UnitDeployment_RunReservePlacementController
    and a
    jr z, $7303
    jr $72c7
    push af
    farcall MapControl_UpdateForceStateIndicator
    pop af
    ret
MapControl_ExecuteSelectedMapCommandStatus::
    call $2164
    call $07b4
    call $7c2f
    farcall MapStatus_Run
    ret
MapControl_ExecuteSelectedMapCommandOption::
    call $2164
    call $07b4
    farcall Options_Run
    ret
MapControl_ExecuteSelectedMapCommandYield::
    call $2164
    farcall MapYieldPrompt_Run
    cp $01
    ret nz
    ld a, $03
    ld [$ca95], a
    ld a, [$c633]
    and $01
    xor $01
    inc a
    ld [$ca94], a
    ret
MapControl_ExecuteSelectedMapCommandInterrupt::
    call $2164
    farcall MapInterruptPrompt_Run
    cp $01
    ret nz
    ld a, $03
    ld [$ca95], a
    ld a, [$c633]
    and $01
    xor $01
    inc a
    ld [$ca94], a
    ret
MapControl_ExecuteSelectedMapCommandSave::
    ld a, [$c62f]
    cp $03
    jr c, $7369
    call $2164
    farcall MapSave_RunEditorPresentation
    jr $7378
    call $2164
    call $07b4
    ld a, $01
    ld [$cc9a], a
    farcall MapSave_RunGameplayPresentation
    farcall MapSaveContinuePrompt_Run
    ret
MapControl_RunSelectedMapRetryPrompt::
    call $4700
    call $3056
    call $04d2
    farcall SharedGraphics_LoadMenuFontTiles
    ld bc, $0020
    ld de, $1405
    farcall UIWindow_DrawFrame
    ld hl, $741f
    call $336e
    ld hl, $7431
    call $336e
    ld hl, $7437
    call $336e
    ld a, $68
    call $4822
    xor a
    ld [$c021], a
    ld a, $55
    call $7408
    call $05a2
    call $3056
    ldh a, [$ff92]
    bit 7, a
    jr nz, $73ef
    bit 6, a
    jr nz, $73ef
    bit 0, a
    jr nz, $73da
    bit 1, a
    jr nz, $73ce
    jr $73b4
    ld a, $0c
    call $3844
    ld a, $00
    ld [$c021], a
    jr $73df
    ld a, $02
    call $3844
    farcall LCDScanlineTransition_Reset
    farcall MapCursor_LoadGraphics
    farcall MapCursor_Show
    ld a, [$c021]
    ret
    xor a
    call $7408
    ld a, [$c021]
    inc a
    and $01
    ld [$c021], a
    ld a, $55
    call $7408
    ld a, $01
    call $3844
    jr $73b4
MapControl_DrawSelectedMapRetryChoice::
    push af
    ld a, [$c021]
    add a, a
    ld hl, $741b
    call $29bc
    ld b, [hl]
    inc hl
    ld c, [hl]
    pop af
    call $34ed
    ret
    db $08, $22, $08, $23
MapControl_SelectedMapRetryPromptLine0::
    ld bc, $6a21
    ld a, c
    jr nz, $7475
    ld b, l
    ld h, b
    add a, b
    call nc, $75d8
    ld h, l
    ld l, h
    ld a, a
    ld l, l
    ld h, [hl]
    nop
MapControl_SelectedMapRetryPromptLine1::
    add hl, bc
    ld [hli], a
    ld h, d
    ld h, d
    ld h, h
    nop
MapControl_SelectedMapRetryPromptLine2::
    add hl, bc
    inc hl
    ld a, d
    ld h, d
    nop
MapControl_ExecuteSelectedMapCommandEnd::
    farcall MapControl_PrepareSelectedMapEndCommand
    ld a, [$c630]
    and a
    jr nz, $744c
    call $746d
    ld a, $00
    ret
    farcall MapInfrared_ExchangeTurnState
    and a
    jr nz, $745f
    ld a, [$c633]
    and $01
    farcall Unit_ClearEndTurnFlagsForSide
    call $428a
    ld a, $01
    ret
MapControl_ExecuteSelectedMapCommandReceive::
    farcall MapInfrared_ExchangeTurnState
    and a
    jr nz, $746c
    call $746d
    ret
    assert @ == $746d
