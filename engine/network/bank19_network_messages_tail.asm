include "macros/macros.inc"

DEF Bank31_Runtime_6F93 EQU $6f93
DEF Bank22_Runtime_621A EQU $621a
DEF Bank15_Runtime_67FD EQU $67fd
DEF Bank22_Runtime_78FA EQU $78fa
DEF Bank22_Runtime_7AE6 EQU $7ae6
DEF Bank22_Runtime_7761 EQU $7761
DEF Bank31_Runtime_732A EQU $732a
DEF Bank22_Runtime_7BAF EQU $7baf
DEF Bank22_Runtime_7F3E EQU $7f3e
DEF Bank22_Runtime_77D2 EQU $77d2
DEF Bank22_Runtime_7824 EQU $7824
DEF Bank22_Runtime_7714 EQU $7714
DEF Bank22_Runtime_787C EQU $787c
DEF Bank22_Runtime_7794 EQU $7794
DEF Bank22_Runtime_7874 EQU $7874
DEF Bank22_Runtime_7D54 EQU $7d54
DEF Bank22_Runtime_79FE EQU $79fe
DEF Bank22_Runtime_79D8 EQU $79d8
DEF Bank31_Runtime_544C EQU $544c
DEF Bank22_Runtime_620D EQU $620d
DEF Bank15_Runtime_6AD3 EQU $6ad3
DEF Bank10_Runtime_6901 EQU $6901
DEF Bank10_Runtime_6908 EQU $6908
DEF Bank22_Runtime_79C8 EQU $79c8
DEF Bank22_Runtime_791C EQU $791c


; late Bank $19 Network/Messages runtime immediately after the
; preserved custom-English Mobile_Mail_Header at $792C-$7937.  No
; independent Bank $19 farcall target enters this tail; executable content
; ends at $7E8C and the remainder of the bank is retail $FF padding.

section "Bank19 Network Messages Tail", romx[$7938], bank[$19]
NetworkMessages_Runtime::
NetworkMessages_SetupScreen::
    farcall $31, Bank31_Runtime_6F93
    ld hl, Mobile_Mail_Header
    call CoordTextPut
    ld bc, $0205
    farcall $22, Bank22_Runtime_621A
    ld bc, $0207
    farcall $22, Bank22_Runtime_621A
    ld bc, $0209
    farcall $22, Bank22_Runtime_621A
    ld bc, $020b
    farcall $22, Bank22_Runtime_621A
    ld bc, $020d
    farcall $22, Bank22_Runtime_621A
    ld bc, $020f
    farcall $22, Bank22_Runtime_621A
    ld a, $0a
    ld bc, $0111
    ld de, $0301
    ld h, $41
    farcall $15, Bank15_Runtime_67FD
    ld a, $08
    ld bc, $0411
    ld de, $0301
    ld h, $49
    farcall $15, Bank15_Runtime_67FD
    ld a, $0a
    ld bc, $0711
    ld de, $0301
    ld h, $44
    farcall $15, Bank15_Runtime_67FD
    ld a, $08
    ld bc, $0a11
    ld de, $0201
    ld h, $54
    farcall $15, Bank15_Runtime_67FD
    ld a, $0a
    ld bc, $0c11
    ld de, $0101
    ld h, $47
    farcall $15, Bank15_Runtime_67FD
    ld a, $08
    ld bc, $0d11
    ld de, $0201
    ld h, $60
    farcall $15, Bank15_Runtime_67FD
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $48
    farcall $15, Bank15_Runtime_67FD
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $62
    farcall $15, Bank15_Runtime_67FD
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call SpriteObject_Create
    ld [$df23], a
    ld bc, $582c
    call SpriteObject_SetPosition
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [$df24], a
    ld bc, $5894
    call SpriteObject_SetPosition
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call SpriteObject_Create
    ld [$df22], a
    farcall $22, Bank22_Runtime_78FA
    call NetworkMessages_UpdateSelectionDisplay
    farcall $22, Bank22_Runtime_7AE6
    farcall $22, Bank22_Runtime_7761
    ld a, [$ba38]
    cp $00
    jr nz, .done
    ld a, [$df22]
    call SpriteObject_Hide
.done
    ret

assert @ == $7a32

NetworkMessages_UpdateSelectionDisplay::
    ld a, [$ba38]
    cp $00
    jr nz, .have_entries
    call NetworkMessages_HidePrimarySelectionCursor
    call NetworkMessages_HideSecondarySelectionCursor
    ret
.have_entries
    ld a, [$cc26]
    cp $00
    jr nz, .show_primary
    call NetworkMessages_HidePrimarySelectionCursor
    jr .primary_done
.show_primary
    call NetworkMessages_ShowPrimarySelectionCursor
.primary_done
    ld a, [$cc26]
    inc a
    add a, $06
    ld c, a
    ld a, [$ba38]
    cp c
    jr nc, .show_secondary
    call NetworkMessages_HideSecondarySelectionCursor
    jr .secondary_done
.show_secondary
    call NetworkMessages_ShowSecondarySelectionCursor
.secondary_done
    ret

NetworkMessages_ShowPrimarySelectionCursor::
NetworkMessages_DrawCurrentPrimary::
    ld a, [$df23]
    call SpriteObject_Show
    ret

NetworkMessages_HidePrimarySelectionCursor::
NetworkMessages_DrawPreviousPrimary::
    ld a, [$df23]
    call SpriteObject_Hide
    ret

NetworkMessages_ShowSecondarySelectionCursor::
NetworkMessages_DrawCurrentSecondary::
    ld a, [$df24]
    call SpriteObject_Show
    ret

NetworkMessages_HideSecondarySelectionCursor::
NetworkMessages_DrawNextPrimary::
    ld a, [$df24]
    call SpriteObject_Hide
    ret

NetworkMessages_PrepareInteractiveController::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    farcall $31, Bank31_Runtime_732A
    xor a
    ld [$cc28], a
    ld a, [$cc25]
    ld c, a
    ld a, [$cc26]
    add a, c
    ld [$cc27], a
    farcall $22, Bank22_Runtime_7BAF
    farcall $22, Bank22_Runtime_7F3E
    farcall $22, Bank22_Runtime_77D2
    farcall $22, Bank22_Runtime_7824
    call VBlankFIFO_Process
    call FadeFromWhite8

assert @ == $7ab2
NetworkMessages_StateCommonReturn::
    farcall $22, MapMenuMessage_ServiceFrame
    ldh a, [hJoyRepeat]
    bit 1, a
    jr z, .check_bit6
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    farcall $22, Bank22_Runtime_7714
    ld a, $ff
    jp NetworkMessages_ControllerSpecialPath

.check_bit6
    bit 6, a
    jr z, .check_bit7
    ld a, [$cc28]
    dec a
    cp $ff
    jr nz, .store_decremented_subselection
    jp NetworkMessages_ControllerCommonExit

.store_decremented_subselection
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [$cc28], a
    farcall $22, Bank22_Runtime_7F3E
    farcall $22, Bank22_Runtime_77D2
    call VBlankFIFO_WaitEmpty
    jp NetworkMessages_ControllerCommonExit

.check_bit7
    bit 7, a
    jr z, .check_bit4
    ld a, [$cc29]
    sub $0c
    jp c, NetworkMessages_ControllerCommonExit
    push af
    ld a, [$cc28]
    ld c, a
    pop af
    cp c
    jp z, NetworkMessages_ControllerCommonExit
    jp c, NetworkMessages_ControllerCommonExit
    ld a, $01
    call Audio_PlaySFX
    ld a, [$cc28]
    inc a
    ld [$cc28], a
    farcall $22, Bank22_Runtime_7F3E
    farcall $22, Bank22_Runtime_77D2
    farcall $22, Bank22_Runtime_7824
    call VBlankFIFO_WaitEmpty
    jp NetworkMessages_ControllerCommonExit

.check_bit4
    bit 4, a
    jr z, .check_bit5
    ld a, [$cc27]
    inc a
    ld c, a
    ld a, [$ba38]
    cp c
    jr nz, .advance_primary_index
    jr NetworkMessages_ControllerCommonExit

.advance_primary_index
    ld a, c
    ld [$cc27], a
    farcall $22, Bank22_Runtime_787C
    xor a
    ld [$cc28], a
    farcall $22, Bank22_Runtime_7BAF
    farcall $22, Bank22_Runtime_7F3E
    farcall $22, Bank22_Runtime_7794
    farcall $22, Bank22_Runtime_77D2
    farcall $22, Bank22_Runtime_7824
    ld a, [$cc27]
    farcall $22, Bank22_Runtime_7874
    farcall $31, Bank31_Runtime_544C
    call VBlankFIFO_WaitEmpty
    ld a, $01
    call Audio_PlaySFX
    jr NetworkMessages_ControllerCommonExit

.check_bit5
    bit 5, a
    jr z, NetworkMessages_ControllerCommonExit
    ld a, [$cc27]
    dec a
    cp $ff
    jr nz, .retreat_primary_index
    jr NetworkMessages_ControllerCommonExit

.retreat_primary_index
    ld [$cc27], a
    farcall $22, Bank22_Runtime_787C
    xor a
    ld [$cc28], a
    farcall $22, Bank22_Runtime_7BAF
    farcall $22, Bank22_Runtime_7F3E
    farcall $22, Bank22_Runtime_7794
    farcall $22, Bank22_Runtime_77D2
    farcall $22, Bank22_Runtime_7824
    ld a, [$cc27]
    farcall $22, Bank22_Runtime_7874
    farcall $31, Bank31_Runtime_544C
    call VBlankFIFO_WaitEmpty
    ld a, $01
    call Audio_PlaySFX
    jr NetworkMessages_ControllerCommonExit

NetworkMessages_ControllerCommonExit::
    jp NetworkMessages_StateCommonReturn

assert @ == $7bb3

NetworkMessages_ControllerSpecialPath::
    call SRAM_Disable
    push af
    call FadeToWhite8
    call $2e67
    pop af
    ret

NetworkMessages_TestIndexedEntry::
    ld [$df2c], a
    inc a
    ld [$df2b], a
.loop
    ld a, [$df2b]
    ld b, a
    ld a, [$df2c]
    ld c, a
    ld a, [$ba38]
    cp b
    jr z, .done
    farcall $22, Bank22_Runtime_7D54
    ld a, [$df2b]
    inc a
    ld [$df2b], a
    ld a, [$df2c]
    inc a
    ld [$df2c], a
    jr .loop
.done
    ret

NetworkMessages_TestCurrentSelectionEntry::
    ld a, [$cc25]
    ld c, a
    ld a, [$cc26]
    add a, c
    farcall $22, Bank22_Runtime_79FE
    ld bc, $0000
    add hl, bc
    ld a, [hl]
    cp $01
    jr z, .set_carry
    jr .clear_carry
.unused_return
    ret
.set_carry
    scf
    ret
.clear_carry
    xor a
    ret

NetworkMessages_ReturnClear::
    ld a, [$ba38]
    cp $00
    jr z, .refresh_views
    ld a, [$cc25]
    ld c, a
    ld a, [$cc26]
    add a, c
    call NetworkMessages_TestIndexedEntry
    ld a, [$ba38]
    dec a
    ld [$ba38], a
    ld a, [$cc26]
    dec a
    cp $ff
    jr z, .clamp_secondary_index
    jr .store_secondary_index
.clamp_secondary_index
    xor a
.store_secondary_index
    ld [$cc26], a
    farcall $22, Bank22_Runtime_79D8
.refresh_views
    farcall $22, Bank22_Runtime_7AE6
    farcall $22, Bank22_Runtime_7761
    ret

assert @ == $7c39

NetworkMessages_RefreshSelectedEntry::
    ld a, [$df22]
    call SpriteObject_Hide
    call Sprite_Update
    call $04d2
    ld bc, $0103
    ld de, $1204
    farcall $10, Bank10_Runtime_6901
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0204
    ld de, $1002
    farcall $15, Bank15_Runtime_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, NetworkMessages_RefreshPrompt0
    call CoordTextPut
    ld hl, NetworkMessages_RefreshPrompt1
    call CoordTextPut
.loop
    farcall $22, Bank22_Runtime_620D
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .check_cancel
    ld a, $02
    call Audio_PlaySFX
    jr .close
.check_cancel
    bit 1, a
    jr z, .wait
    ld a, $02
    call Audio_PlaySFX
    jr .close
.wait
    jr .loop
.close
    farcall $10, Bank10_Runtime_6908
    ld a, [$df22]
    call SpriteObject_Show
    call Sprite_Update
    call $04d2
    ret

NetworkMessages_RefreshPrompt0::
    db $02, $04, $9a, $7d, $af, $86, $6c, $aa, $8d, $8e, $00
NetworkMessages_RefreshPrompt1::
    db $02, $05, $31, $30, $72, $9d, $86, $86, $78, $00

NetworkMessages_ApplySelectionState::
    ld a, [$cc25]
    ld c, a
    ld a, [$cc26]
    add a, c
    farcall $22, Bank22_Runtime_79FE
    ld a, [hl]
    cp $00
    jr z, .increment_state
    ld a, [$ba39]
    dec a
    ld [$ba39], a
    xor a
    jr .store
.increment_state
    ld a, [$ba39]
    cp $0a
    jr z, .refresh
    ld a, [$ba39]
    inc a
    ld [$ba39], a
    ld a, $01
    jr .store
.store
    ld [hl], a
    farcall $22, Bank22_Runtime_7AE6
    farcall $22, Bank22_Runtime_7761
    ret
.refresh
    call NetworkMessages_RefreshSelectedEntry
    ret

NetworkMessages_TestSelectionEntry::
    ld a, [$ba38]
    cp $00
    jr z, .set_carry
    ld a, [$cc25]
    ld c, a
    ld a, [$cc26]
    add a, c
    farcall $22, Bank22_Runtime_79FE
    ld a, [hl]
    cp $00
    jr z, .clear
.set_carry
    scf
    ret
.clear
    xor a
    ret

NetworkMessages_RestartSelectionUI::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    call NetworkMessages_SetupScreen
    ld a, $02
    call $3816
    call FadeFromWhite8

assert @ == $7d22

NetworkMessages_InteractiveController::
.loop
    farcall $22, Bank22_Runtime_620D
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .check_cancel
    ld a, [$ba38]
    cp $00
    jr nz, .open_selected
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jp NetworkMessages_FinalizeState
.open_selected
    ld a, [$df22]
    farcall $15, SpriteTransition_SlideRightOffscreen
    farcall $22, Bank22_Runtime_79C8
    ld a, [$cc25]
    ld c, a
    ld a, [$cc26]
    add a, c
    farcall $31, Bank31_Runtime_544C
    jp NetworkMessages_SetPendingState
.check_cancel
    bit 1, a
    jr z, .check_up
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jp NetworkMessages_SetPendingState
.check_up
    bit 6, a
    jr z, .check_down
    ld a, [$ba38]
    cp $00
    jp z, NetworkMessages_FinalizeState
    ld a, [$cc25]
    dec a
    cp $ff
    jr nz, .move_primary_up
    ld a, [$cc26]
    dec a
    cp $ff
    jr nz, .move_secondary_up
    xor a
    ld [$cc26], a
    call NetworkMessages_UpdateSelectionDisplay
    jp NetworkMessages_FinalizeState
.move_secondary_up
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [$cc26], a
    farcall $22, Bank22_Runtime_7AE6
    farcall $22, Bank22_Runtime_7761
    call NetworkMessages_UpdateSelectionDisplay
    jp NetworkMessages_FinalizeState
.move_primary_up
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [$cc25], a
    farcall $22, Bank22_Runtime_78FA
    farcall $22, Bank22_Runtime_7761
    jp NetworkMessages_FinalizeState
.check_down
    bit 7, a
    jr z, .check_action2
    ld a, [$ba38]
    cp $00
    jp z, NetworkMessages_FinalizeState
    ld a, [$cc25]
    inc a
    push af
    ld a, [$ba38]
    ld c, a
    pop af
    cp c
    jp z, NetworkMessages_FinalizeState
    cp $06
    jr nz, .move_primary_down
    ld a, [$cc25]
    ld c, a
    ld a, [$cc26]
    inc a
    add a, c
    ld c, a
    ld a, [$ba38]
    cp c
    jr nz, .move_secondary_down
    call NetworkMessages_UpdateSelectionDisplay
    jp NetworkMessages_FinalizeState
.move_secondary_down
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [$cc26]
    inc a
    ld [$cc26], a
    ld a, [$ba38]
    cp $00
    jr nz, .refresh_down
    xor a
    ld [$cc26], a
.refresh_down
    farcall $22, Bank22_Runtime_7AE6
    farcall $22, Bank22_Runtime_7761
    call NetworkMessages_UpdateSelectionDisplay
    jr NetworkMessages_FinalizeState
.move_primary_down
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [$cc25], a
    farcall $22, Bank22_Runtime_78FA
    farcall $22, Bank22_Runtime_7761
    jr NetworkMessages_FinalizeState
.check_action2
    bit 2, a
    jr z, .check_action3
    ld a, $02
    call Audio_PlaySFX
    call NetworkMessages_ApplySelectionState
    ld a, [$cc25]
    ld c, a
    ld a, [$cc26]
    add a, c
    farcall $31, Bank31_Runtime_544C
    jr NetworkMessages_FinalizeState
.check_action3
    bit 3, a
    jr z, NetworkMessages_FinalizeState
    call NetworkMessages_TestSelectionEntry
    jr c, .invalid_action
    ld a, $02
    call Audio_PlaySFX
    farcall $22, Bank22_Runtime_791C
    jr c, .cancelled_action
    ld a, $02
    call Audio_PlaySFX
    call $7c05
    farcall $31, Bank31_Runtime_544C
    ld a, [$ba38]
    cp $00
    jr nz, .refresh_after_action
    ld a, [$df22]
    call SpriteObject_Hide
.refresh_after_action
    call NetworkMessages_UpdateSelectionDisplay
    jr NetworkMessages_FinalizeState
.invalid_action
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jr NetworkMessages_FinalizeState
.cancelled_action
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    jr NetworkMessages_FinalizeState

NetworkMessages_FinalizeState::
    jp NetworkMessages_InteractiveController

NetworkMessages_SetPendingState::
    call SRAM_Disable
    push af
    call FadeToWhite8
    call $2e67
    pop af
    ret
assert @ == $7e8d

NetworkMessages_Bank19Padding::
    ds $8000 - @, $ff
assert @ == $8000
