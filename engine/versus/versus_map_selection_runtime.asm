include "macros/macros.inc"

; Versus map/style selection frontend. Executable source is mnemonic and
; byte-exact; unresolved provider names remain conservative by bank/address.
DEF Vram_SetPalsWithIncrementedE EQU $4073 ; mid-instruction entry: INC E; CALL Vram_SetPals; RET
DEF VersusSetup_UIProvider_67FD EQU $67fd
DEF VersusSetup_UIProvider_6A09 EQU $6a09
DEF VersusSetup_UIProvider_6AD3 EQU $6ad3

section "Versus Map Selection Runtime", romx[$5bc8], bank[$18]
Versus_ResetMapSelectionState::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$dc52], a
    ld [$dc54], a
    ld [$dc56], a
    ld [$dc58], a
    ld [$dc5a], a
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$dc2b], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
Versus_EnterMapSelection::
    jp Versus_RunStyleMapSelection
    ret
Versus_OpenNetworkMapMenu::
    farcall $19, NetworkUI_RunMobileMenuController
    ret
Versus_RunStyleMapSelection::
    call $5e65
    cp $00
    jp z, Versus_RunSavedMapRecordBranchA
    cp $01
    jp z, Versus_RunSavedMapRecordBranchB
    ret
Versus_RunTransferMapSelection::
    call $62a4
    cp $00
    jr z, Versus_SelectSendMap
    cp $01
    jr z, Versus_SelectReceiveMap
    ret
Versus_SelectSendMap::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$dc2b], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $04
    farcall $13, MapMenu_Runtime47E3
    cp $ff
    jr z, Versus_RunTransferMapSelection
    farcall $0c, MapInfrared_SendSelectedMap
    cp $01
    jr z, Versus_SelectSendMap
    jr $5c60
Versus_SelectReceiveMap::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    xor a
    ld [$dc2b], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $05
    farcall $13, MapMenu_Runtime47E3
    cp $ff
    jr z, Versus_RunTransferMapSelection
    farcall $0c, MapInfrared_ReceiveSelectedMap
    cp $01
    jr z, Versus_SelectReceiveMap
    jr $5c60
    jp Versus_RunTransferMapSelection
Versus_RunLocalMapSelection::
    call $5e65
    cp $00
    jr z, Versus_RunSavedMapRecordBranchA
    cp $01
    jp z, Versus_RunSavedMapRecordBranchB
    ret
Versus_RunSavedMapRecordBranchA::
    farcall $0f, Versus_RunSavedMapRecordFlow
    cp $00
    jr z, Versus_PrepareSavedMapRecordBranchA
    cp $01
    jp z, Versus_RunMapCategorySelection
    cp $ff
    jp Versus_RunLocalMapSelection
Versus_PrepareSavedMapRecordBranchA::
    farcall $0f, Versus_PrepareSelectedMapRecord
    ld a, $04
    ld [$c62f], a
    farcall $0b, MapControl_RunSelectedMapController
    xor a
    ret
Versus_RunMapChoiceBranchA::
    call $60c6
    cp $00
    jp z, Versus_RunMapCategorySelection
    cp $01
    jp z, Versus_RunSecondaryMapChoice
    jr Versus_RunLocalMapSelection
Versus_RunSavedMapRecordBranchB::
    farcall $0f, Versus_RunSavedMapRecordFlow
    cp $00
    jr z, Versus_PrepareSavedMapRecordBranchB
    cp $01
    jr z, Versus_RunMapChoiceBranchB
    cp $ff
    jp Versus_RunLocalMapSelection
Versus_PrepareSavedMapRecordBranchB::
    farcall $0b, Vram_SetPalsWithIncrementedE
    ld a, $00
    farcall $0c, MapInfrared_RunInitialStateExchange
    cp $01
    jp z, Versus_RunLocalMapSelection
    ld a, $04
    ld [$c62f], a
    farcall $0b, MapControl_RunSelectedMapController
    xor a
    ret
Versus_RunMapChoiceBranchB::
    call $60c6
    cp $00
    jr z, Versus_RunMapCategorySelection
    cp $01
    jp z, Versus_RunSecondaryMapChoice
    jp Versus_RunLocalMapSelection
Versus_RunMapCategorySelection::
    call $6547
    cp $00
    jr z, Versus_SelectStandardMap
    cp $01
    jr z, Versus_SelectAlternateMap
    ld a, [$c630]
    cp $00
    jp z, Versus_RunLocalMapSelection
    cp $01
    jp z, Versus_RunMapChoiceBranchA
Versus_SelectStandardMap::
    farcall $15, MapSave_PostOverwriteFlow
    cp $ff
    jr z, Versus_RunMapCategorySelection
    jr Versus_FinishStandardMapSelection
Versus_SelectAlternateMap::
    ld a, $01
    farcall $13, MapMenu_Runtime47E3
    cp $ff
    jr z, Versus_RunMapCategorySelection
    farcall $28, MapRuntime_PrepareSelectedMap
    cp $ff
    jr nz, Versus_FinishAlternateMapSelection
    jr Versus_SelectAlternateMap
Versus_FinishStandardMapSelection::
    ld a, [$c630]
    cp $00
    jr z, $5d1b
    cp $01
    jr z, $5d26
    ld a, $04
    ld [$c62f], a
    farcall $0b, MapControl_RunSelectedMapController
    xor a
    ret
    ld a, $00
    farcall $0c, MapInfrared_RunInitialStateExchange
    cp $01
    jr z, Versus_SelectStandardMap
    ld a, $04
    ld [$c62f], a
    farcall $0b, MapControl_RunSelectedMapController
    xor a
    ret
Versus_FinishAlternateMapSelection::
    ld a, [$c630]
    cp $00
    jr z, $5d46
    cp $01
    jr z, $5d51
    ld a, $04
    ld [$c62f], a
    farcall $0b, MapControl_RunSelectedMapController
    xor a
    ret
    ld a, $00
    farcall $0c, MapInfrared_RunInitialStateExchange
    cp $01
    jr z, Versus_SelectAlternateMap
    ld a, $04
    ld [$c62f], a
    farcall $0b, MapControl_RunSelectedMapController
    xor a
    ret
Versus_RunSecondaryMapChoice::
    ld a, $01
    farcall $0c, MapInfrared_RunInitialStateExchange
    cp $01
    jp z, Versus_RunMapChoiceBranchA
    ld a, $04
    ld [$c62f], a
    farcall $0b, MapControl_RunSelectedMapController
    xor a
    ret
Versus_DrawStyleSelectionScreen::
    call $04f3
    call $34ce
    call $2d7c
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    farcall $10, UIWindowStack_Init
    farcall $01, SharedGraphics_LoadMainFontBG
    call $0618
    call $0f02
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall $15, Gfx_LoadCommonScreenAssets
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $76e2
    ld hl, $9000
    ld bc, $0260
    farcall $15, Memcpy
    ld de, $67c1
    ld hl, $9260
    ld bc, $0040
    farcall $14, Memcpy
    ld a, $00
    ld b, $08
    ld hl, $7942
    ld c, $15
    call $06d9
    call $06af
    call $06f2
    ld bc, $0301
    ld de, $0e03
    farcall $10, VersusSetup_UIProvider_6A09
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0402
    ld de, $0c01
    xor a
    farcall $15, VersusSetup_UIProvider_6AD3
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $010c
    ld de, $1205
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $0502
    ld hl, $5e5b
    call $3353
    ld a, $0a
    ld bc, $0606
    ld de, $0802
    ld h, $01
    farcall $15, VersusSetup_UIProvider_67FD
    ld a, $0a
    ld bc, $0608
    ld de, $0802
    ld h, $11
    farcall $15, VersusSetup_UIProvider_67FD
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $26
    farcall $15, VersusSetup_UIProvider_67FD
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $27
    farcall $15, VersusSetup_UIProvider_67FD
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$dc53], a
    call $5f0b
    farcall $27, Versus_DrawStyleDescription
    ret

    assert @ == $5e5b, "Versus map selection runtime boundary moved"
