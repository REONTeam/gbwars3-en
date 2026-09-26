include "macros/macros.inc"

; Top-level mode router entered after boot/save validation. It owns title return,
; suspended-game resume, main-menu selection, file selection, and dispatch into
; Beginner/Campaign/Standard/Map/Versus flows.
section "Main Mode Dispatcher", romx[$4805], bank[$14]
Main_ModeDispatcher::
    farcall Startup_TitleAttractLoop
    farcall MapRuntime_ResetDemoState
    farcall Main_ResetModeSubsystemState
    call Main_TryResumeSuspendedGame
    and a
jr_014_4815:
    jr z, jr_014_482b
    farcall MapSRAM_LoadResumeSlot
    ld [wActiveGameMode], a
    ld a, $03
    farcall Bank0B_MapSetup_40EE
    farcall MapControl_StageForceStateModeFromGameMode
    jp Jump_014_4920
Jump_014_482b:
jr_014_482b:
    xor a
    ld [$ca96], a
    call MainMenu_RunSelection
    cp $ff
    jr z, Main_ModeDispatcher
    cp $00
    jr z, jr_014_4856
    cp $01
    jr z, jr_014_484d
    cp $02
    jp z, Main_RunVersusMode
    cp $03
    jp z, Main_RunMapMenuMode
    cp $04
    jp z, Main_ModeDispatcherTail
jr_014_484d:
    call Main_StartNewGameFromFileSelect
    cp $ff
    jr z, jr_014_482b
    jr jr_014_4856
Jump_014_4856:
jr_014_4856:
    call Main_SelectExistingSave
    cp $ff
    jr z, jr_014_482b
    ld a, b
    ld [wActiveGameMode], a
    farcall MapControl_StageForceStateModeFromGameMode
    farcall MapSave_CloseFileSelect
    ld a, [wActiveGameMode]
    ld b, a
    ld a, [$c628]
    farcall MapSRAM_SlotHasCategoryData
    jr z, jr_014_4880
    ld a, [$c628]
    farcall Bank0B_MapSetup_40EE
    jp Jump_014_4920
jr_014_4880:
    ld a, [wActiveGameMode]
    cp $00
    jr z, jr_014_4891
    cp $01
    jp z, Main_RunCampaignSelection
    cp $02
    jp z, Main_RunStandardPostAwards
jr_014_4891:
    farcall BattleSceneBank31Runtime_5113
    cp $ff
    jp z, Jump_014_4856
    ld a, [$ca1f]
    ld [$c6a3], a
    call Audio_StopMusic
    jp Jump_014_4920
Main_RunBeginnerMode:
    farcall BeginnerMode_RunResultFlow
    cp $01
    jr nz, jr_014_4891
    jp Main_ModeDispatcher
Main_RunCampaignSelection:
jr_014_48b1:
    ld a, $15
    call Audio_PlayMusic
    ld a, [$c6a4]
    farcall MapRecord_SelectCampaign
    ld a, $01
    farcall CampaignStats_UpdateBestValue
jr_014_48c3:
    ld a, [$c6a4]
    farcall CampaignMapSelect_OpenSelectable
    cp $ff
    jr z, jr_014_4856
    ld [$c6a4], a
jr_014_48d1:
    ld a, [$c6a4]
    ld b, $00
    farcall MapBriefing_OpenModal
    cp $ff
    jr z, jr_014_48c3
jr_014_48de:
    farcall MapRuntime_PrepareSelectedMap
    cp $ff
    jr z, jr_014_48d1
    call FadeToWhite8
    farcall MapEconomy_RecalculateIncome
    farcall MapStatus_Run
    cp $ff
    jr z, jr_014_48de
    call Audio_StopMusic
    jp Jump_014_4920
Main_RunCampaignMode:
    farcall CampaignMode_RunResultFlow
    cp $01
    jr nz, Main_RunCampaignSelection
    jp Main_ModeDispatcher
Main_RunStandardPostAwards:
jr_014_4906:
    farcall MapSave_PostOverwriteFlow
    cp $ff
    jp z, Jump_014_4856
    ld a, [$ca1f]
    ld [$c6a5], a
    call Audio_StopMusic
    jr jr_014_4920
Main_RunStandardMode:
    farcall CampaignMedals_HandleResultAwards
    jr Main_RunStandardPostAwards
Jump_014_4920:
jr_014_4920:
    farcall MapControl_RunSelectedMapController
    ld a, [$ca96]
    and a
    jp nz, Main_ModeDispatcher
    ld a, [wActiveGameMode]
    ld hl, Main_ModeJumpTable
    call WordTable_Get
    jp hl
Main_ModeJumpTable:
    dw Main_RunBeginnerMode
    dw Main_RunCampaignMode
    dw Main_RunStandardMode
    dw Main_RunMapMenuMode
    dw Main_RunVersusMode

Main_ModeDispatcherTail::
    ld a, $04
    ld [wActiveGameMode], a
    farcall Versus_OpenNetworkMapMenu
    jp Jump_014_482b
Main_RunMapMenuMode:
    ld a, $03
    ld [wActiveGameMode], a
    farcall MapMenu_Runtime4B86
    jp Jump_014_482b
Main_RunVersusMode:
    ld a, $04
    ld [wActiveGameMode], a
    ld a, $05
    farcall MapSRAM_LoadSlotStateBlock
    ld a, $05
    farcall MapSRAM_SlotHasCategoryData
    jr nz, jr_014_4972
    farcall MapControl_StageForceStateModeFromGameMode
    farcall Bank0B_Helper6D18
jr_014_4972:
    farcall Versus_EnterMapSelection
    ld a, [$ca96]
    and a
    jp nz, Main_ModeDispatcher
    jp Jump_014_482b
Main_TryResumeSuspendedGame:
    ld a, $00
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$a00e]
    call SRAM_Disable
    and a
    ret z
    ld a, $02
    call Audio_PlayMusic
    farcall SuspendResume_Runtime
    ret
MainMenu_RunSelection:
    call $04f3
    call $0f02
    farcall MainMenu_Runtime
    farcall MapRuntime_ResetDemoState
    ld a, $00
    ld [$c62a], a
    farcall MapSRAM_HasAnyPrimarySlotData
    and a
    jr nz, jr_014_49b9
    ld a, $01
    ld [$c62a], a
jr_014_49b9:
    farcall MainMenu_UpdateCursor
    call FadeFromWhite8
Jump_014_49c0:
jr_014_49c0:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 6, a
    jr z, jr_014_49ea
    ld a, [$c62a]
    dec a
    cp $ff
    jr nz, jr_014_49dc
    ld a, $04
jr_014_49dc:
    ld [$c62a], a
jr_014_49df:
    ld a, $01
    call Audio_PlaySFX
    farcall MainMenu_UpdateCursor
    jr jr_014_49c0
jr_014_49ea:
    bit 7, a
    jr z, jr_014_4a05
    ld a, [$c62a]
    inc a
    cp $05
    jr nz, jr_014_49f7
    xor a
jr_014_49f7:
    ld [$c62a], a
    ld a, $01
    call Audio_PlaySFX
    farcall MainMenu_UpdateCursor
    jr jr_014_4a3a
jr_014_4a05:
    bit 0, a
    jr z, jr_014_4a29
    ld a, [$c62a]
    cp $00
    jr nz, jr_014_4a3d
    farcall MapSRAM_HasAnyPrimarySlotData
    and a
    jr z, jr_014_4a22
    ld a, [$cc9c]
    farcall SpriteTransition_SlideRightOffscreen
    ld a, $00
    jr jr_014_4a46
jr_014_4a22:
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jr jr_014_49c0
jr_014_4a29:
    bit 1, a
    jr z, jr_014_4a3a
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    xor a
    call Audio_PlayMusic
    ld a, $ff
    jr jr_014_4a46
jr_014_4a3a:
    jp Jump_014_49c0
jr_014_4a3d:
    push af
    ld a, [$cc9c]
    farcall SpriteTransition_SlideRightOffscreen
    pop af
jr_014_4a46:
    push af
    farcall MainMenu_DestroyCursorSprites
    call FadeToWhite8
    pop af
    ret
Main_StartNewGameFromFileSelect:
    ld a, $00
    ld [$c629], a
    farcall MapSave_OpenFileSelect
    call FadeFromWhite8
jr_014_4a5c:
    farcall MapSave_RunFileSelectController
    cp $ff
    jr z, jr_014_4a9e
    farcall MapSRAM_GetSlotStatusByte
    bit 0, a
    jr z, jr_014_4a72
    call FileSlotConfirm_Run
    and a
    jr z, jr_014_4a5c
jr_014_4a72:
    farcall MapSave_CloseFileSelect
    ld a, $00
    farcall TextInput_Run
    ld a, [$c628]
    farcall MapSRAM_ResetNewSlotState
    ld a, [$c628]
    ld hl, $cc2f
    farcall MapSRAM_CopyCurrentPreviewHeader
    ld a, [$c628]
    farcall MapSRAM_StoreCurrentPreviewHeaderToSlot
    ld a, [$c628]
    farcall MapSRAM_WriteSlotChecksum
    ld a, [$c628]
jr_014_4a9e:
    push af
    farcall MapSave_CloseFileSelect
    pop af
    ret
FileSlotConfirm_Run:
    push bc
    push hl
    call FileSlotConfirm_Open
jr_014_4aaa:
    call Joypad_Update
    call Sprite_Update
    ld a, $70
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff91]
    bit 5, a
    jr z, jr_014_4ac9
    ld a, $01
    call Audio_PlaySFX
    call FileSlotConfirm_DrawYesSelected
    ld a, $01
    ld [$cc73], a
jr_014_4ac9:
    ldh a, [$ff91]
    bit 4, a
    jr z, jr_014_4adb
    ld a, $01
    call Audio_PlaySFX
    call FileSlotConfirm_DrawNoSelected
    xor a
    ld [$cc73], a
jr_014_4adb:
    ldh a, [$ff91]
    bit 0, a
    jr z, jr_014_4ae6
    ld a, [$cc73]
    jr jr_014_4af2
jr_014_4ae6:
    ldh a, [$ff91]
    bit 1, a
    jr z, jr_014_4aaa
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    xor a
jr_014_4af2:
    push af
    cp $00
    jr z, jr_014_4af9
    jr jr_014_4b00
jr_014_4af9:
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    jr jr_014_4b05
jr_014_4b00:
    ld a, $02
    call Audio_PlaySFX
jr_014_4b05:
    farcall UIWindowStack_PopRestore
    pop af
    pop hl
    pop bc
    ret
Main_SelectExistingSave:
    ld a, $01
    ld [$c629], a
    farcall MapSave_OpenFileSelect
    call FadeFromWhite8
    ld a, $02
    call Audio_PlayMusic
    farcall MapSave_RunFileSelectController
    cp $ff
    jr z, jr_014_4b30
    ld a, [$c628]
    farcall MapSRAM_LoadSlotStateBlock
    ld a, [$c628]
jr_014_4b30:
    push af
    push bc
    farcall MapSave_CloseFileSelect
    pop bc
    pop af
    ret

    assert @ == $4b39
