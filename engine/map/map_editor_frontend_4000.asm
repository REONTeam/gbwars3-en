include "macros/macros.inc"

; complete Bank $0F editor/save frontend immediately before the already-owned
; MapEditor_InitNewMapRecord at $40EB. The range is byte-authoritative while labels and
; comments expose only caller/control-flow contracts proven by the current source/ROM.

section "Map Editor Frontend 4000", romx[$4000], bank[$0f]
MapEditor_OpenSelectedRecord::
    ld [$ca4f], a
    call $40b4
    ld a, [$ca1d]
    bit 1, a
    jr nz, $4012
    call $40eb
    jr $4035
    ld a, [$ca4f]
    farcall BANK_13, Bank13_Entry_5D37
    farcall Bank0B_MapSetup_41F3
    ld a, [$c8b1]
    ld [$c989], a
    ld a, [$c8b2]
    ld [$c98a], a
    farcall MapGrid_RebuildTileCountsAndHQCoordinates
    farcall MapRuntime_PrepareSelectedMap
    cp $ff
    jr z, $403c
    call $4170
    call $2e67
    xor a
    ret
MapMenu_PreparePlayRecord::
    ld a, $04
    farcall MapSRAM_LoadSlotStateBlock
    ld a, $04
    farcall Bank0B_MapSetup_40EE
    farcall MapControl_RunSelectedMapController
    ret
MapEditor_TestSelectedRecord::
    ld [$ca4f], a
    farcall MapRuntime_PrepareSelectedMap
    cp $ff
    jr z, $405e
    farcall MapControl_RunSelectedMapController
    xor a
    ret
MapMenu_RunPlayRecordFlow::
    push bc
    ld a, $04
    ld b, $03
    call $4080
    pop bc
    ret
Versus_RunSavedMapRecordFlow::
    push bc
    ld a, $05
    ld b, $04
    call $4080
    pop bc
    ret
Versus_PrepareSelectedMapRecord::
    ld a, $05
    farcall MapSRAM_LoadSlotStateBlock
    ld a, $05
    farcall Bank0B_MapSetup_40EE
    ret
MapEditor_RunSavedRecordContinueFlow::
    push de
    push hl
    ld [$ca68], a
    farcall MapSRAM_SlotHasCategoryData
    jr z, $40af
    push bc
    ld a, [$ca68]
    farcall Bank0B_MapSetup_40EE
    ld de, $c87e
    ld hl, $ca1a
    ld bc, $0035
    call $3b50
    farcall MapMenu_RunContinueFromSavePrompt
    pop bc
    cp $01
    jr nz, $40b1
    ld a, [$ca68]
    farcall BANK_13, Bank13_Entry_5938
    ld a, $01
    pop de
    pop hl
    ret
MapEditor_ResetWorkingState::
    ld a, $01
    ld hl, $ca59
    ld bc, $0005
    call $3b79
    ld a, $01
    ld hl, $ca5e
    ld bc, $0007
    call $3b79
    xor a
    ld [$ca52], a
    ld [$ca57], a
    ld [$ca58], a
    call $5226
    xor a
    ld [$c98b], a
    ld [$c98c], a
    ld a, $04
    ld [$c98f], a
    ld [$c990], a
    farcall UnitRecords_ClearAllAndCounts
    ret
    assert @ == $40eb
