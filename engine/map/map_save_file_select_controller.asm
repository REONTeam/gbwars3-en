include "macros/macros.inc"

; File-select/save presentation runtime shared by gameplay SAVE and the editor.
; Localized prompt strings and the nine-character map-name display patches are
; separate fixed-address resources interleaved with this Bank $27 runtime.

section "Map Save File Select Frontend", romx[$6b46], bank[$27]
MapSave_OpenFileSelect::
    ld [$cc6e], a
    push af
    farcall $14, MapSave_PrepareFileSelectDisplay
    call $04f3
    call $0f02
    call $0618
    call MapSave_SetupFileSelectScreen
    pop af
    call $0593
    ld a, $00
    call $058d
    ld a, [$a00d]
    call $059b
    ld [$c62a], a
    call MapSave_DrawSlotFrames
    ld a, [$c62a]
    call MapSave_LoadSelectedSlotPreview
    call $3537
    call MapSave_CreateCursorSprites
    ld a, [$cc6e]
    cp $01
    jr nz, jr_027_6b84

    jr jr_027_6b88

jr_027_6b84:
    xor a
    ld [$cc81], a

jr_027_6b88:
    call MapSave_PositionSlotCursor
    call MapSave_UpdatePreviewSpriteVisibility
    call MapSave_UpdateCategoryFromSelectedSlot
    call MapSave_DrawPrompt
    ret

MapSave_ResetCategorySelection::
    xor a
    ld [$cc81], a
    ret

MapSave_RebuildFileSelect::
    ld [$cc6e], a
    push af
    farcall $14, MapSave_PrepareFileSelectDisplay
    call $04f3
    call $0f02
    call $0618
    pop af
    call MapSave_SetupFileSelectScreen
    call MapSave_DrawSlotFrames
    ld a, [$c62a]
    call MapSave_LoadSelectedSlotPreview
    call MapSave_CreateCursorSprites
    call MapSave_PositionSlotCursor
    call MapSave_UpdatePreviewSpriteVisibility
    call MapSave_UpdateCategoryFromSelectedSlot
    call MapSave_DrawPrompt
    ret

MapSave_CloseFileSelect::
    call $07b4
    xor a
    ldh [$ff97], a
    ldh [$ff98], a
    call $051f
    call MapSave_DestroyCursorSprites
    ret

MapSave_CanConfirmCurrentSlot::
    call MapSave_CategorySwitchAllowed
    ld a, [$cc6e]
    cp $00
    jr z, jr_027_6be9

    cp $01
    jr z, jr_027_6beb

    cp $02
    jr z, jr_027_6be9

jr_027_6be9:
    scf
    ret

jr_027_6beb:
    ld a, [$c62a]
    farcall $13, MapSRAM_GetSlotStatusByte
    bit 0, a
    jr nz, jr_027_6bf8

    jr jr_027_6bfe

jr_027_6bf8:
    farcall $15, MapSave_ResetOverwritePromptState
    scf
    ret

jr_027_6bfe:
    xor a
    ret

MapSave_DrawPrompt::
    ld a, [$c629]
    cp $01
    jr z, jr_027_6c0c

    ld hl, File_Menu_Strings
    jr jr_027_6c2a

jr_027_6c0c:
    ld a, [$cc81]
    cp $00
    jr z, jr_027_6c1b

    cp $01
    jr z, jr_027_6c20

    cp $02
    jr z, jr_027_6c25

jr_027_6c1b:
    ld hl, $6c42
    jr jr_027_6c2a

jr_027_6c20:
    ld hl, $6c56
    jr jr_027_6c2a

jr_027_6c25:
    ld hl, $6c6a
    jr jr_027_6c2a

jr_027_6c2a:
    call $336e
    ret

assert @ == $6c2e

section "Map Save Confirmation Presentation", romx[$6c7e], bank[$27]
MapSave_DrawSavedConfirmation::
    ld bc, $0103
    ld de, $1204
    farcall $10, UIWindowStack_PushAndDrawAnimated
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld bc, $0204
    ld de, $1002
    xor a
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld hl, Unk_Save_Confirmation
    call $336e
    ret

assert @ == $6ca8

section "Map Save File Select Controller", romx[$6cb2], bank[$27]
MapSave_WaitSavedConfirmation::
    call MapSave_DrawSavedConfirmation

jr_027_6cb5:
    call $05a2
    call $3056
    ld a, $70
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff91]
    bit 0, a
    jr z, jr_027_6cce

    ld a, $02
    call $3844
    jr jr_027_6cdb

jr_027_6cce:
    bit 1, a
    jr z, jr_027_6cd9

    ld a, $02
    call $3844
    jr jr_027_6cdb

jr_027_6cd9:
    jr jr_027_6cb5

jr_027_6cdb:
    call $04d2
    farcall $10, UIWindowStack_PopRestore
    ret

MapSave_ApplyCategoryToSlot::
    ld a, [$cc81]
    cp $00
    jr z, jr_027_6cf2

    cp $01
    jr z, jr_027_6cf6

    cp $02
    jr z, jr_027_6cfa

jr_027_6cf2:
    ld b, $00
    jr jr_027_6cfc

jr_027_6cf6:
    ld b, $01
    jr jr_027_6cfc

jr_027_6cfa:
    ld b, $02

jr_027_6cfc:
    ld a, [$cc83]
    farcall $13, MapSRAM_LoadSlotSummaryRow
    ret

MapSave_RunFileSelectController::
    call $05a2
    call $3056
    ld a, $70
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    ld hl, MapSave_InputJumpTable
    call $3a9e
    jp hl

MapSave_InputA::
    call MapSave_CanConfirmCurrentSlot
    jr c, jr_027_6d20

    jr jr_027_6d79

jr_027_6d20:
    ld a, [$c629]
    cp $01
    jr z, jr_027_6d45

    cp $00
    jr z, jr_027_6d60

    ld a, $02
    call $3844
    ld a, [$c62a]
    farcall $13, MapSRAM_SaveGameplayToSlot
    ld a, [$c62a]
    call MapSave_LoadSelectedSlotPreview
    call MapSave_WaitSavedConfirmation
    call MapSave_DrawPrompt
    jr MapSave_RunFileSelectController

jr_027_6d45:
    ld a, [$cc70]
    farcall $15, SpriteTransition_SlideRightOffscreen
    ld a, [$c62a]
    ld [$c628], a
    push af
    ld a, [$cc81]
    ld b, a
    pop af
    push af
    push bc
    call MapSave_ApplyCategoryToSlot
    pop bc
    pop af
    ret

jr_027_6d60:
    ld a, $02
    call $3844
    ld a, [$c62a]
    ld [$c628], a
    push af
    ld a, [$cc81]
    ld b, a
    pop af
    push af
    push bc
    call MapSave_ApplyCategoryToSlot
    pop bc
    pop af
    ret

jr_027_6d79:
    ld a, $03
    call $3844
    jr MapSave_RunFileSelectController

MapSave_InputB::
    ld a, $0c
    call $3844
    ld a, [$c62a]
    ld a, $ff
    ret

MapSave_InputStart::
    ld a, [$c629]
    cp $01
    jp nz, MapSave_RunFileSelectController

    ld a, [$c62a]
    farcall $13, MapSRAM_GetSlotStatusByte
    bit 0, a
    jr nz, jr_027_6da6

    ld a, $03
    call $3844
    jp MapSave_RunFileSelectController

jr_027_6da6:
    ld a, $02
    call $3844
    ld a, [$c62a]
    push af
    call $07b4
    farcall $14, MapSave_OpenSelectedSlotView
    ld a, [$c629]
    call MapSave_RebuildFileSelect
    pop af
    ld [$c62a], a
    call $081d
    jp MapSave_RunFileSelectController

MapSave_InputSelect::
    ld a, [$c629]
    cp $01
    jp nz, MapSave_RunFileSelectController

    ld a, [$c62a]
    farcall $13, MapSRAM_GetSlotStatusByte
    bit 0, a
    jr nz, jr_027_6de1

    ld a, $03
    call $3844
    jp MapSave_RunFileSelectController

jr_027_6de1:
    ld a, $02
    call $3844
    ld a, [$c62a]
    push af
    call $07b4
    ld a, [$c62a]
    farcall $13, MapSRAM_LoadSlotStateBlock
    ld a, [$c62a]
    ld b, $01
    farcall $13, MapSRAM_LoadSlotSummaryRow
    ld a, [$cc92]

Call_027_6e00:
    farcall $25, CampaignMapSelect_OpenViewOnly
    ld a, [$c629]
    call MapSave_RebuildFileSelect
    pop af
    ld [$c62a], a
    call $081d
    jp MapSave_RunFileSelectController

MapSave_InputLeft::
    ld a, $01
    call $3844
    ld a, [$c62a]
    dec a
    cp $ff
    jr nz, jr_027_6e23

    ld a, $02

jr_027_6e23:
    ld [$c62a], a
    call MapSave_PositionSlotCursor
    ld a, [$c62a]
    call MapSave_LoadSelectedSlotPreview
    call MapSave_UpdateCategoryFromSelectedSlot
    call MapSave_UpdatePreviewSpriteVisibility
    call MapSave_DrawPrompt
    call MapSave_CheckCurrentSlot
    jp nc, Jump_027_6e3e

Jump_027_6e3e:
    jp MapSave_RunFileSelectController

MapSave_InputRight::
    ld a, $01
    call $3844
    ld a, [$c62a]
    inc a
    cp $03
    jr nz, jr_027_6e4f

    xor a

jr_027_6e4f:
    ld [$c62a], a
    call MapSave_PositionSlotCursor
    ld a, [$c62a]
    call MapSave_LoadSelectedSlotPreview
    call MapSave_UpdateCategoryFromSelectedSlot
    call MapSave_UpdatePreviewSpriteVisibility
    call MapSave_DrawPrompt
    call MapSave_CheckCurrentSlot
    jp nc, Jump_027_6e6a

Jump_027_6e6a:
    jp MapSave_RunFileSelectController

MapSave_InputUp::
    call MapSave_CategorySwitchAllowed
    jp c, MapSave_RunFileSelectController

    call MapSave_CheckCurrentSlot
    jp c, MapSave_RunFileSelectController

    ld a, [$cc81]
    dec a
    cp $ff
    jr nz, jr_027_6ea9

    ld a, $02

jr_027_6e83:
    ld [$cc81], a
    ld a, $01
    call $3844
    call MapSave_PositionCategoryCursor
    call MapSave_DrawPrompt
    jp MapSave_RunFileSelectController

MapSave_InputDown::
    call MapSave_CategorySwitchAllowed
    jp c, MapSave_RunFileSelectController

    call MapSave_CheckCurrentSlot
    jp c, MapSave_RunFileSelectController

    ld a, [$cc81]
    inc a
    cp $03
    jr nz, jr_027_6e83

    xor a

jr_027_6ea9:
    ld [$cc81], a
    ld a, $01
    call $3844
    call MapSave_PositionCategoryCursor
    call MapSave_DrawPrompt
    jp MapSave_RunFileSelectController

MapSave_InputJumpTable::
    dw MapSave_InputA
    dw MapSave_InputB
    dw MapSave_InputSelect
    dw MapSave_InputStart
    dw MapSave_InputRight
    dw MapSave_InputLeft
    dw MapSave_InputUp
    dw MapSave_InputDown
    dw MapSave_RunFileSelectController

assert @ == $6ecc

section "Map Save Slot State Helpers", romx[$6ecc], bank[$27]
MapSave_CheckCurrentSlot::
    ld a, [$c62a]
    farcall $13, MapSRAM_GetSlotStatusByte
    bit 0, a
    jr z, .empty
    xor a
    ret
.empty
    scf
    ret

MapSave_CategorySwitchAllowed::
    ld a, [$cc6e]
    cp $00
    jr z, .allowed
    cp $02
    jr z, .allowed
    xor a
    ret
.allowed
    scf
    ret

assert @ == $6eea
