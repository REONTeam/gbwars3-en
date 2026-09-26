include "macros/macros.inc"

DEF Bank22_Runtime_64B8 EQU $64b8
DEF Bank10_Runtime_6901 EQU $6901
DEF Bank15_Runtime_67FD EQU $67fd
DEF Bank15_Runtime_6AD3 EQU $6ad3
DEF Bank19_Runtime_715E EQU $715e
DEF Bank14_Runtime_3B50 EQU $3b50
DEF Bank22_Runtime_3B50 EQU $3b50
DEF Bank27_Runtime_6833 EQU $6833
DEF Bank32_Runtime_4D25 EQU $4d25
DEF Bank32_Runtime_403B EQU $403b
DEF Bank27_Runtime_69E4 EQU $69e4
DEF Bank10_Runtime_6908 EQU $6908

; Bank $19 Network/Mobile UI continuation immediately after the
; three-record Shift-JIS profile renderer.  No external Bank $19 farcall
; target occurs again before $7059, so this tranche is kept byte-authoritative
; while its internal menu/state roles are traced from later callers.

section "Bank19 Network UI Continuation ", romx[$64e8], bank[$19]
NetworkUI_ProfileListContinuation::
    farcall $19, NetworkUI_InitializeMobileMenu
    farcall $22, Bank22_Runtime_64B8
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
    ld bc, $0101
    ld de, $1204
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, NetworkUI_ProfileListLabel0
    call CoordTextPut
    ld hl, NetworkUI_ProfileListLabel1
    call CoordTextPut
    ld bc, $0105
    ld de, $120c
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes
    ldh a, [hVRAMBank]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call SpriteObject_Create
    ld [$cbe7], a
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$ba3b]
    cp $ff
    jr z, .no_saved_profile
    jr .store_profile_index
.no_saved_profile
    xor a
    jr .save_profile_index
.store_profile_index
    ld a, [$ba3b]
.save_profile_index
    ld [$cbe8], a
    call SRAM_Disable
    farcall $31, Bank31_RuntimePositionHelper_58F1
    call NetworkProfile_RenderRecord0SecondaryField
    ret

NetworkUI_ProfileListLabel0::
    db $02, $02, $88, $8d, $86, $af, $ad, $8f, $af, $73, $64, $86, $00
NetworkUI_ProfileListLabel1::
    db $02, $03, $7a, $83, $7d, $6e, $76, $9d, $78, $6a, $3f, $00


; Saved-profile list input loop.  A confirms the highlighted record when it is
; valid, B cancels, and Up/Down wrap across the three profile slots.
NetworkUI_RunProfileListInput::
    ldh a, [hWRAMBank]
    push af
    ld a, $07
    ldh [hWRAMBank], a
    ldh [rSVBK], a
.loop
    call NetworkUI_ProfileListContinuation
    call FadeFromWhite8
.input_loop
    farcall $22, MapMenuMessage_ServiceFrame
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .check_b
    ld a, [$cbe8]
    call NetworkProfile_TestIndexedRecord
    jr c, .invalid_profile
    jr .accept_profile
.invalid_profile
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jr .redraw
.accept_profile
    ld a, [$cbe7]
    farcall $15, SpriteTransition_SlideRightOffscreen
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$cbe8]
    ld a, $00
    ld [$ba3b], a
    call SRAM_Disable
    xor a
    jr .return
.check_b
    bit 1, a
    jr z, .check_up
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .return
.check_up
    bit 6, a
    jr z, .check_down
    ld a, $01
    call Audio_PlaySFX
    ld a, [$cbe8]
    dec a
    cp $ff
    jr nz, .store_selection_up
    ld a, $02
.store_selection_up
    ld [$cbe8], a
    farcall $31, Bank31_RuntimePositionHelper_58F1
    jr .redraw
.check_down
    bit 7, a
    jr z, .redraw
    ld a, $01
    call Audio_PlaySFX
    ld a, [$cbe8]
    inc a
    cp $03
    jr nz, .store_selection_down
    xor a
.store_selection_down
    ld [$cbe8], a
    farcall $31, Bank31_RuntimePositionHelper_58F1
    jr .redraw
.redraw
    jr .input_loop
.return
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    push af
    call FadeToWhite8
    call $2e67
    pop af
    ret

; Profile/character-entry screen setup. This is the executable frontend for the
; character grid and editable profile buffers that begin immediately afterward.
NetworkUI_SetupProfileCharacterEntry::
    call NetworkText_ConvertOptionalSavedField17
    farcall $19, Bank19_Runtime_715E
    xor a
    ld [$da95], a
    farcall $22, Bank22_Runtime_64B8

    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $56f8
    ld hl, $9000
    ld bc, $0270
    farcall $14, Bank14_Runtime_3B50
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld a, $00
    ld b, $08
    ld hl, $5968
    ld c, $14
    call $06d9
    call $06af
    call $06f2

    ld a, $0a
    ld bc, $0811
    ld de, $0301
    ld h, $20
    farcall $15, Bank15_Runtime_67FD
    ld a, $08
    ld bc, $0b11
    ld de, $0401
    ld h, $23
    farcall $15, Bank15_Runtime_67FD
    ld a, $0a
    ld bc, $1011
    ld de, $0101
    ld h, $16
    farcall $15, Bank15_Runtime_67FD
    ld a, $08
    ld bc, $1111
    ld de, $0201
    ld h, $17
    farcall $15, Bank15_Runtime_67FD

    ld bc, $0101
    ld de, $1204
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $0105
    ld de, $120c
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes

    ld a, [$da96]
    cp $00
    jr z, .draw_mode0_header
    cp $01
    jr z, .draw_mode1_header
.draw_mode0_header
    ld hl, NetworkUI_CharacterEntryHeader_Mode0
    call CoordTextPut
    jr .draw_common_header
.draw_mode1_header
    ld hl, NetworkUI_CharacterEntryHeader_Mode1
    call CoordTextPut
    jr .draw_common_header
.draw_common_header
    ld hl, NetworkUI_CharacterEntryHeader_Common
    call CoordTextPut

    ld hl, NetworkUI_CharacterRow0
    ld bc, $020a
    call $3353
    ld hl, NetworkUI_CharacterRow1
    ld bc, $020b
    call $3353
    ld hl, NetworkUI_CharacterRow2
    ld bc, $020c
    call $3353
    ld hl, NetworkUI_CharacterRow3
    ld bc, $020d
    call $3353
    ld hl, NetworkUI_CharacterRow4
    ld bc, $020e
    call $3353
    ld hl, NetworkUI_CharacterRow5
    ld bc, $020f
    call $3353

    xor a
    ld [$da4d], a
    ld [$da4e], a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $619d
    ld hl, $8000
    ld bc, $0030
    farcall $22, Bank22_Runtime_3B50

    ld a, $08
    ld b, $03
    ld hl, $61cd
    ld c, $22
    call $06d9
    call $06f2

    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $20
    ld c, $00
    ld b, $22
    ld de, $618f
    call SpriteObject_Create
    ld [$da4c], a
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    call NetworkProfile_RenderSelectedField
    call NetworkText_GetZeroTerminatedLength
    call $61c3
    call NetworkProfile_PrepareDisplayField
    call NetworkProfile_PrepareListBuffers
    call NetworkProfile_GetLayoutByte
    call $3537
    ret

assert @ == $6759

NetworkUI_CharacterEntryHeader_Mode0::
    db $02, $02, $f0, $0d, $fa, $b1, $d8, $fb, $c8, $ae, $00
NetworkUI_CharacterEntryHeader_Common::
    db $02, $03, $8a, $a4, $64, $a9, $a6, $6e, $76, $85, $6e, $7f, $74, $62, $00
NetworkUI_CharacterEntryHeader_Mode1::
    db $02, $02, $e0, $c8, $fd, $0d, $d8, $ae, $00
NetworkUI_CharacterRow0::
    db $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $00
NetworkUI_CharacterRow1::
    db $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $11, $12, $13, $14, $15, $16, $00
NetworkUI_CharacterRow2::
    db $17, $18, $19, $1a, $1b, $1c, $1e, $1d, $1f, $20, $21, $22, $23, $24, $25, $26, $00
NetworkUI_CharacterRow3::
    db $27, $28, $29, $2a, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $01, $3f, $00
NetworkUI_CharacterRow4::
    db $10, $0e, $0d, $0b, $2f, $5e, $0f, $3a, $3b, $07, $02, $0a, $3d, $03, $04, $05, $00
NetworkUI_CharacterRow5::
    db $06, $2c, $08, $09, $3c, $3e, $2b, $2d, $5b, $5d, $40, $5c, $2e, $0c, $00, $00, $00
assert @ == $67e2

NetworkUI_CharacterCursorLeft::
.loop
    ld a, [$da4d]
    dec a
    cp $ff
    jr nz, .store
    ld a, $0f
.store
    ld [$da4d], a
    call $61c3
    call NetworkProfile_GetLayoutByte
    ld a, [$da94]
    cp $00
    jr nz, .done
    jr .loop
.done
    ret

assert @ == $67ff

NetworkUI_CharacterCursorRight::
.loop
    ld a, [$da4d]
    inc a
    cp $10
    jr nz, .store
    xor a
.store
    ld [$da4d], a
    call $61c3
    call NetworkProfile_GetLayoutByte
    ld a, [$da94]
    cp $00
    jr nz, .done
    jr .loop
.done
    ret

assert @ == $681b

NetworkUI_CharacterCursorUp::
.loop
    ld a, [$da4e]
    dec a
    cp $ff
    jr nz, .store
    ld a, $05
.store
    ld [$da4e], a
    call $61c3
    call NetworkProfile_GetLayoutByte
    ld a, [$da94]
    cp $00
    jr nz, .done
    jr .loop
.done
    ret

assert @ == $6838

NetworkUI_CharacterCursorDown::
.loop
    ld a, [$da4e]
    inc a
    cp $06
    jr nz, .store
    xor a
.store
    ld [$da4e], a
    call $61c3
    call NetworkProfile_GetLayoutByte
    ld a, [$da94]
    cp $00
    jr nz, .done
    jr .loop
.done
    ret

assert @ == $6854

NetworkUI_InsertSelectedCharacter::
    call NetworkProfile_GetDisplayCoordinates
    call NetworkUI_ClearCharacterCursorTiles
    ld a, [$da96]
    cp $00
    jr z, .mode0
    cp $01
    jr z, .mode1
    cp $02
    jr z, .mode2
.mode0
    ld hl, $d867
    jr .have_buffer
.mode1
    ld hl, $cab3
    jr .have_buffer
.mode2
    ld hl, $d8eb
.have_buffer
    ld a, [$da4f]
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [$da94]
    ld [hl], a
    ld a, [$da4f]
    inc a
    ld [$da4f], a
    ret

assert @ == $6889

NetworkUI_AdvanceCharacterEntryCursor::
    ld a, [$da96]
    cp $00
    jr z, .mode0_limit
    cp $01
    jr z, .short_limit
    cp $02
    jr z, .short_limit
.mode0_limit
    ld a, [$da4f]
    cp $30
    jr z, .advance_index
    jr .prepare
.short_limit
    ld a, [$da4f]
    cp $10
    jr z, .advance_index
.prepare
    call NetworkProfile_GetDisplayCoordinates
    ld a, [$da95]
    cp $08
    jp c, .advance_index
    xor a
    ld [$da95], a
    ld a, [$da97]
    cp $00
    jp z, .phase_a
    call NetworkUI_DrawCharacterCursorPhaseB
    xor a
    jr .store_phase
.phase_a
    call NetworkUI_DrawCharacterCursorPhaseA
    ld a, $01
    jr .store_phase
.store_phase
    ld [$da97], a
.advance_index
    ld a, [$da95]
    inc a
    ld [$da95], a
    ret

assert @ == $68d7

NetworkUI_DrawCharacterCursorPhaseB::
    ld a, [$ffcb]
    push af
    push bc
    ld a, $01
    ld [$ffcb], a
    ld a, $08
    call $34ed
    pop bc
    xor a
    ld [$ffcb], a
    ld a, $15
    call $34ed
    pop af
    ld [$ffcb], a
    xor a
    ld [$da97], a
    ret

assert @ == $68f9

NetworkUI_DrawCharacterCursorPhaseA::
    ld a, [$ffcb]
    push af
    push bc
    ld a, $01
    ld [$ffcb], a
    ld a, $0a
    call $34ed
    pop bc
    xor a
    ld [$ffcb], a
    xor a
    call $34ed
    pop af
    ld [$ffcb], a
    ret

assert @ == $6916

NetworkUI_ClearCharacterCursorTiles::
    ld a, [$ffcb]
    push af
    push bc
    ld a, $01
    ld [$ffcb], a
    xor a
    call $34ed
    pop bc
    xor a
    ld [$ffcb], a
    xor a
    call $34ed
    pop af
    ld [$ffcb], a
    ret

assert @ == $6932

NetworkUI_DeletePreviousCharacter::
    ld a, [$da96]
    cp $00
    jr z, .mode0_limit
    cp $01
    jr z, .short_limit
    cp $02
    jr z, .short_limit
.mode0_limit
    ld a, [$da4f]
    cp $30
    jr z, .redraw_cursor
    jr .prepare
.short_limit
    ld a, [$da4f]
    cp $10
    jr z, .redraw_cursor
    jr .prepare
.prepare
    call NetworkProfile_GetDisplayCoordinates
    call NetworkUI_DrawCharacterCursorPhaseB
.redraw_cursor
    ld a, [$da96]
    cp $00
    jr z, .mode0
    cp $01
    jr z, .mode1
    cp $02
    jr z, .mode2
.mode0
    ld hl, $d867
    jr .have_buffer
.mode1
    farcall $27, Bank27_Runtime_6833
    ld hl, $cab3
    jr .have_buffer
.mode2
    farcall $27, Bank27_Runtime_6833
    ld hl, $d8eb
.have_buffer
    ld a, [$da4f]
    dec a
    ld b, $00
    ld c, a
    add hl, bc
    ld a, $00
    ld [hl], a
    ld a, [$da4f]
    dec a
    ld [$da4f], a
    ret

assert @ == $6990

; Profile-field modal/confirmation controller.  Mode 0 presents the full
; three-field profile view; the other modes use the compact confirmation view.
NetworkUI_RunProfileFieldConfirmation::
    push af
    push bc
    push de
    ld a, [$da96]
    cp $00
    jr nz, .loc_699c
    jr .loc_69d5
.loc_699c:
    ld bc, $0307
    ld de, $0e08
    farcall $10, Bank10_Runtime_6901
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0408
    ld de, $0c06
    farcall $15, Bank15_Runtime_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, NetworkUI_ProfileFieldPromptLabel0
    call $336e
    ld hl, NetworkUI_ProfileFieldPromptLabel1
    call $336e
    ld bc, $070c
    farcall $15, Gfx_DrawTwoChoiceHighlightFirst
    jp .loc_6a61
.loc_69d5:
    ld bc, $0101
    ld de, $1205
    farcall $10, Bank10_Runtime_6901
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0202
    ld de, $1003
    farcall $15, Bank15_Runtime_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $da61
    call $61e6
    cp $00
    jr z, .loc_6a31
    ld hl, $da61
    ld bc, $0202
    call $3353
    ld hl, $da72
    call $61e6
    cp $00
    jr z, .loc_6a31
    ld hl, $da72
    ld bc, $0203
    call $3353
    ld hl, $da83
    call $61e6
    cp $00
    jr z, .loc_6a31
    ld hl, $da83
    ld bc, $0204
    call $3353
.loc_6a31:
    ld bc, $0407
    ld de, $0c07
    farcall $10, Bank10_Runtime_6901
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0508
    ld de, $0a05
    farcall $15, Bank15_Runtime_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $6b41
    call $336e
    ld bc, $070c
    farcall $15, Gfx_DrawTwoChoiceHighlightFirst
.loc_6a61:
    ld a, $01
    ld [$daa7], a
.loc_6a66:
    farcall $22, MapMenuMessage_ServiceFrame
    ldh a, [hJoyPressed]
    bit 5, a
    jr z, .loc_6a82
    ld a, $01
    call $3844
    xor a
    ld [$daa7], a
    ld bc, $070c
    farcall $15, Gfx_DrawTwoChoiceHighlightSecond
    jr .loc_6a66
.loc_6a82:
    ldh a, [hJoyPressed]
    bit 4, a
    jr z, .loc_6a9b
    ld a, $01
    call $3844
    ld a, $01
    ld [$daa7], a
    ld bc, $070c
    farcall $15, Gfx_DrawTwoChoiceHighlightFirst
    jr .loc_6a66
.loc_6a9b:
    ldh a, [hJoyPressed]
    bit 0, a
    jr z, .loc_6b10
    ld a, [$daa7]
    cp $00
    jr z, .loc_6aac
    cp $01
    jr z, .loc_6ade
.loc_6aac:
    ld a, $02
    call $3844
    ld a, $0e
    call $058d
    call $0593
    ld a, [$da96]
    cp $00
    jr z, .loc_6ad6
    cp $01
    jr z, .loc_6aca
    cp $02
    jr z, .loc_6ad1
    jr .loc_6ad6
.loc_6aca:
    ld a, $00
    ld [$ba3a], a
    jr .loc_6ad6
.loc_6ad1:
    ld a, $00
    ld [$bb5b], a
.loc_6ad6:
    call $059b
    call $4e2f
    jr .loc_6b23
.loc_6ade:
    ld a, $0c
    call $3844
    ld a, $0e
    call $058d
    call $0593
    ld a, [$da96]
    cp $00
    jr z, .loc_6b08
    cp $01
    jr z, .loc_6afc
    cp $02
    jr z, .loc_6b03
    jr .loc_6b08
.loc_6afc:
    ld a, $01
    ld [$ba3a], a
    jr .loc_6b08
.loc_6b03:
    ld a, $01
    ld [$bb5b], a
.loc_6b08:
    call $059b
    call $4e2f
    jr .loc_6b23
.loc_6b10:
    ldh a, [hJoyPressed]
    bit 1, a
    jp z, .loc_6a66
    ld a, $0c
    call $3844
    ld a, $ff
    ld [$daa7], a
    jr .loc_6b23
.loc_6b23:
    ld a, [$da4c]
    call $2f45
    pop de
    pop bc
    pop af
    ret

NetworkUI_ProfileFieldPromptLabel0::
    db $06, $09, $e0, $c8, $fd, $0d, $d8, $ae, $00
NetworkUI_ProfileFieldPromptLabel1::
    db $06, $0a, $6c, $68, $6e, $76, $9d, $78, $6a, $3f, $00

assert @ == $6b41
NetworkUI_CharacterEntryPromptLabel::
    db $06, $09, $a7, $ac, $76, $62, $86, $78, $6a, $3f, $00

assert @ == $6b4c
NetworkUI_RunCharacterEntryEditor::
    ld c, a
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ld [$da96], a
    call NetworkUI_SetupProfileCharacterEntry
    call $081d
.loop
    farcall MapMenuMessage_ServiceFrame
    call NetworkUI_AdvanceCharacterEntryCursor
    ldh a, [hJoyRepeat]
    bit 5, a
    jr z, .check_right
    ld a, $01
    call $3844
    call NetworkUI_CharacterCursorLeft
    jr .loop
.check_right
    bit 4, a
    jr z, .check_up
    ld a, $01
    call $3844
    call NetworkUI_CharacterCursorRight
    jr .loop
.check_up
    bit 6, a
    jr z, .check_down
    ld a, $01
    call $3844
    call NetworkUI_CharacterCursorUp
    jr .loop
.check_down
    bit 7, a
    jr z, .check_a
    ld a, $01
    call $3844
    call NetworkUI_CharacterCursorDown
    jr .loop
.check_a
    bit 0, a
    jr z, .check_b
    ld a, $02
    call $3844
    ld a, [$da96]
    cp $00
    jr z, .mode0_or_other
    cp $01
    jr z, .mode1_or_2
    cp $02
    jr z, .mode1_or_2
.mode0_or_other
    ld a, [$da4f]
    cp $30
    jr z, .finish_or_loop
    jr .insert_character
.mode1_or_2
    ld a, [$da4f]
    cp $10
    jr z, .finish_or_loop
.insert_character
    call NetworkUI_InsertSelectedCharacter
    call NetworkProfile_PrepareListBuffers
    jr .loop
.check_b
    bit 1, a
    jr z, .check_start
    ld a, $0c
    call $3844
    ld a, [$da4f]
    cp $00
    jp z, .loop
    call NetworkUI_DeletePreviousCharacter
    call NetworkProfile_PrepareListBuffers
    jp .loop
.check_start
    bit 3, a
    jr z, .finish_or_loop
    ld a, [$da4f]
    cp $00
    jr z, .empty_field
    jr .confirm_field
.empty_field
    ld a, $03
    call $3844
    jr .finish_or_loop
.confirm_field
    ld a, $02
    call $3844
    ld a, [$da4c]
    call $2f5f
    call NetworkUI_RunProfileFieldConfirmation
    ld a, [$daa7]
    cp $00
    jr z, .confirmed
    cp $01
    jp z, .confirmed
    farcall UIWindowStack_PopRestore
    ld a, [$da96]
    cp $00
    jr nz, .finish_or_loop
    farcall UIWindowStack_PopRestore
.finish_or_loop
    jp .loop
.confirmed
    ld a, [$daa7]
    cp $01
    jr nz, .return_result
    farcall UIWindowStack_PopRestore
    farcall UIWindowStack_PopRestore
.return_result
    push af
    call $07b4
    call $2e67
    pop af
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ret

NetworkUI_CancelCharacterEntryEditor::
    call $07b4
    farcall UIWindowStack_PopRestore
    farcall UIWindowStack_PopRestore
    ld a, $ff
    push af
    call $2e67
    pop af
    ld c, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ret

assert @ == $6c64

; Profile-review setup used by the following interactive Network UI controller.
; It prepares the shared Mobile Menu surface, draws its fixed labels/frames,
; creates the selection sprite, and refreshes the profile text workspace.
NetworkUI_SetupProfileReviewScreen::
    farcall $19, Bank19_Runtime_715E
    farcall $22, Bank22_Runtime_64B8
    ld a, [$dee2]
    cp $00
    jr z, .draw_common_labels
    ld a, $0a
    ld bc, $0111
    ld de, $0301
    ld h, $44
    farcall $15, Bank15_Runtime_67FD
    ld a, $08
    ld bc, $0411
    ld de, $0401
    ld h, $4c
    farcall $15, Bank15_Runtime_67FD
.draw_common_labels
    ld a, $0a
    ld bc, $0911
    ld de, $0101
    ld h, $47
    farcall $15, Bank15_Runtime_67FD
    ld a, $08
    ld bc, $0a11
    ld de, $0401
    ld h, $50
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
    ld bc, $0101
    ld de, $1203
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $0104
    ld de, $120d
    farcall $22, UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, NetworkUI_ProfileReviewText0
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText1
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText2
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText3
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText4
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText5
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText6
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText7
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText8
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText9
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText10
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText11
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewText12
    call CoordTextPut
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $03
    ld bc, $0205
    ld de, $1008
    farcall $15, Bank15_Runtime_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ldh a, [hVRAMBank]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call SpriteObject_Create
    ld [$dee1], a
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $01
    ld [$cbe5], a
    call NetworkUI_UpdateProfileReviewCursor
    ld hl, $cab3
    call NetworkText_GetZeroTerminatedLength
    cp $00
    jp z, .done
.done
    ret

NetworkUI_ProfileReviewText0::
    db $06, $02, $7a, $83, $7d, $6e, $7a, $82, $85, $62, $00
NetworkUI_ProfileReviewText1::
    db $02, $05, $fc, $bf, $b3, $ff, $19, $14, $00
NetworkUI_ProfileReviewText2::
    db $03, $06, $2b, $00
NetworkUI_ProfileReviewText3::
    db $11, $06, $2d, $00
NetworkUI_ProfileReviewText4::
    db $02, $08, $f0, $0d, $fa, $b1, $d8, $fb, $c8, $00
NetworkUI_ProfileReviewText5::
    db $03, $09, $2b, $00
NetworkUI_ProfileReviewText6::
    db $11, $09, $2d, $00
NetworkUI_ProfileReviewText7::
    db $02, $0e, $e0, $c8, $fd, $0d, $d8, $00
NetworkUI_ProfileReviewText8::
    db $03, $0f, $2b, $00
NetworkUI_ProfileReviewText9::
    db $11, $0f, $2d, $00
NetworkUI_ProfileReviewText10::
    db $02, $0b, $7a, $83, $7d, $6e, $74, $6c, $86, $af, $ad, $8f, $af, $73, $64, $00
NetworkUI_ProfileReviewText11::
    db $03, $0c, $2b, $00
NetworkUI_ProfileReviewText12::
    db $11, $0c, $2d, $00
    db $02, $08, $f1, $df, $b3, $fa, $b1, $cf, $e6, $ce, $6b, $00
    db $02, $09, $7a, $83, $7d, $6e, $74, $ab, $85, $62, $9d, $7a, $af, $00
    db $02, $0a, $11, $eb, $ce, $ff, $ae, $68, $76, $85, $6e, $7f, $74, $62, $00
NetworkUI_ProfileReviewPrompt0::
    db $02, $08, $f1, $df, $b3, $fa, $b1, $cf, $e6, $ce, $ae, $00
NetworkUI_ProfileReviewPrompt1::
    db $02, $09, $d0, $b6, $d2, $be, $76, $85, $62, $9d, $78, $00

NetworkUI_UpdateProfileReviewCursor::
    ld a, [$cbe5]
    ld b, $18
    call MultiplyAByB
    ld a, l
    add a, $70
    ld c, a
    ld b, $14
    ld a, [$dee1]
    call SpriteObject_SetPosition
    ret

; Carry set means the required saved/profile data is unavailable for the
; optional action exposed by the review controller.
NetworkUI_ProfileReviewActionIsUnavailable::
    ld a, [$d89a]
    or a
    jr z, .unavailable
    ld a, [$cab3]
    or a
    jr z, .unavailable
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$ba3b]
    cp $ff
    jr z, .disable_sram_unavailable
    farcall $31, Bank31_GetIndexed34ByteRecordAddress
    ld a, $00
    call $29bc
    ld a, [hl]
    cp $00
    jr z, .disable_sram_unavailable
    jr .disable_sram_available
.disable_sram_unavailable
    call SRAM_Disable
    jr .unavailable
.disable_sram_available
    call SRAM_Disable
    xor a
    ret
.unavailable
    xor a
    scf
    ret

NetworkUI_DrawProfileReviewValues::
    ld bc, $0c0b
    ld a, [$cab0]
    call $31ca
    ld bc, $0e0b
    ld a, [$cab2]
    call $31ca
    ld bc, $100b
    ld a, [$cab1]
    call $31ca
    ld hl, NetworkUI_ProfileReviewValueLabel
    call CoordTextPut
    ret

NetworkUI_ProfileReviewValueLabel::
    db $0e, $0b, $0d, $00, $57

assert @ == $6e79

; Interactive profile-review controller.  D selects the review mode.  The
; routine returns the same status byte used by the historical raw runtime.
NetworkUI_RunProfileReviewController::
    ldh a, [hWRAMBank]
    push af
    ld a, $07
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ld [$dee2], a
    call NetworkUI_SetupProfileReviewScreen
    call $081d
    farcall $32, Bank32_Runtime_4D25
    call $2a83
    ld a, [$cacb]
    cp $01
    jp z, .prepare_fields
    ld hl, $cab3
    ld bc, $0011
    ld a, $00
    call $3b79
    call $038b
    call $352e
    ld a, [$dee1]
    call SpriteObject_Hide
    ld bc, $0107
    ld de, $1204
    farcall $10, Bank10_Runtime_6901
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0208
    ld de, $1002
    farcall $15, Bank15_Runtime_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, NetworkUI_ProfileReviewPrompt0
    call CoordTextPut
    ld hl, NetworkUI_ProfileReviewPrompt1
    call CoordTextPut
    ld a, $01
    ld [$dee3], a
.confirm_loop
    farcall $22, MapMenuMessage_ServiceFrame
    call $4000
    cp $fe
    jr z, .confirm_yes
    cp $ff
    jr z, .confirm_no
    jr .confirm_loop
.confirm_no
    xor a
    ld [$cacb], a
    ld a, $01
    ld [$cbdd], a
    call FadeToWhite8
    farcall $32, Bank32_Runtime_403B
    jp .finish
.confirm_yes
    ld a, $01
    ld [$cacb], a
    farcall $27, Bank27_Runtime_69E4
    farcall $10, Bank10_Runtime_6908
    ld a, [$dee1]
    call SpriteObject_Show
assert @ == $6f1d
.prepare_fields
    ld de, $d89a
    ld hl, $daa8
    ld bc, $0021
    call $3b50
    ld a, [$daa8]
    cp $00
    jr z, .copy_secondary
    ld a, $00
    ld [$dab5], a
    ld hl, $daa8
    ld bc, $0406
    call $3353
.copy_secondary
    ld de, $d8cc
    ld hl, $daa8
    ld bc, $001f
    call $3b50
    ld a, [$daa8]
    cp $00
    jr z, .load_saved_fields
    ld a, $00
    ld [$dab5], a
    ld hl, $daa8
    ld bc, $0409
    call $3353
.load_saved_fields
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$ba3a]
    cp $00
    jr z, .load_optional_field
    jr .format_primary_field
.load_optional_field
    ld bc, $0168
    ld a, $00
    ld hl, $daa8
    call $3b79
    ld hl, $a0ba
    ld de, $daa8
    farcall $22, Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld de, $daa8
    ld hl, $cab3
    ld bc, $0011
    call $3b50
.format_primary_field
    ld bc, $0168
    ld a, $00
    ld hl, $daa8
    call $3b79
    ld hl, $cab3
    call NetworkText_GetZeroTerminatedLength
    cp $00
    jr z, .load_indexed_field
    ld c, a
    ld b, $00
    ld a, $0a
    ld hl, $daa8
    call $3b79
    ld a, $00
    ld [$dab5], a
    ld bc, $040f
    ld hl, $daa8
    call $3353
.load_indexed_field
    ld a, [$ba3b]
    cp $ff
    jr z, .finish_sram
    farcall $31, Bank31_GetIndexed34ByteRecordAddress
    ld a, $00
    call $29bc
    ld de, $daa8
    farcall $22, Bank22_ConvertShiftJISStreamAndClearTextBuffer
    ld a, [$daa8]
    cp $00
    jr z, .finish_sram
    ld a, $00
    ld [$dab5], a
    ld bc, $040c
    ld hl, $daa8
    call $3353
.finish_sram
    call SRAM_Disable
    call $352e
assert @ == $6ff1
.input_loop
    farcall $22, MapMenuMessage_ServiceFrame
    ldh a, [hJoyRepeat]
    bit 0, a
    jr z, .check_b
    ld a, [$cbe5]
    ld a, [$dee1]
    farcall $15, SpriteTransition_SlideRightOffscreen
    ld a, [$cbe5]
    jr .finish
.check_b
    bit 1, a
    jr z, .check_start
    ld a, $0c
    call $3844
    ld a, $ff
    jr .finish
.check_start
    bit 3, a
    jr z, .restart_input
    ld a, [$dee2]
    cp $00
    jr z, .restart_input
    call NetworkUI_ProfileReviewActionIsUnavailable
    jr c, .reject_action
    jr .open_action
.reject_action
    ld a, $03
    call $3844
    jr .restart_input
.open_action
    ld a, $02
    call $3844
    farcall $31, Bank31_SaveDataRuntime_5610
    cp $ff
    jr nz, .action_accepted
    jr .restart_input
.action_accepted
    ld a, $fe
    jr .finish
.restart_input
    jp .input_loop
assert @ == $7046
.finish
    push af
    call $039d
    call FadeToWhite8
    call $2e67
    pop af
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

assert @ == $7059

