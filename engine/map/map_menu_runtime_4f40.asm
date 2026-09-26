include "macros/macros.inc"

; MapMenu Runtime 4F40
; Executable bytes are expressed as LR35902 mnemonics and retain exact retail geometry.

section "MapMenu Runtime 4F40", romx[$4f40], bank[$13]
MapMenu_PrepareSlotSummary::
    push af
    ld d, a
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    push af
    ld hl, $dc10
    ld bc, $02d0
    xor a
    call $3b79
    ld hl, $daa8
    ld bc, $0168
    xor a
    call $3b79
    pop af
    add a, a
    ld hl, $391c
    call $29bc
    ld a, [hli]
    ld a, a
    call $058d
    call $0593
    ld a, [hl]
    ld h, a
    ld l, $00
    ld bc, $0008
    add hl, bc
    ld d, h
    ld e, l
    ld hl, $daa8
    ld bc, $0008
    call $3b50
    call $059b
    farcall $26, NetworkPersistent_LoadSavedField16
    ld de, $cbcd
    ld hl, $dc10
    ld bc, $0008
    call $3b50
    ld hl, $daa8
    farcall $19, NetworkText_SkipLeadingASCIIZeroes
    ld de, $dc10
    farcall $0a, String_CompareZeroTerminated
    jr nc, $4fa9
    jr $4fb3
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop af
    call $4ef4
    ret
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    pop af
    ret
    xor a
    ld [$ca69], a
MapMenu_RunSlotSelectionController::
    call $05a2
    call $3056
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 6, a
    jr z, $4fe7
    ld a, $01
    call $3844
    ld a, [$dc2b]
    sub $05
    jr c, $4fe5
    ld [$dc2b], a
    call $44a0
    call $4717
    jr $4fbe
    bit 7, a
    jr z, $5004
    ld a, $01
    call $3844
    ld a, [$dc2b]
    add a, $05
    cp $0a
    jr nc, $5002
    ld [$dc2b], a
    call $44a0
    call $4717
    jr $4fbe
    bit 5, a
    jr z, $5022
    ld a, $01
    call $3844
    ld a, [$dc2b]
    dec a
    cp $ff
    jr nz, $5017
    ld a, $09
    ld [$dc2b], a
    call $44a0
    call $4717
    jr $4fbe
    bit 4, a
    jr z, $5040
    ld a, $01
    call $3844
    ld a, [$dc2b]
    inc a
    cp $0a
    jr nz, $5034
    xor a
    ld [$dc2b], a
    call $44a0
    call $4717
    jp $4fbe
    bit 0, a
    jp z, $5126
    ld a, [$dc4d]
    cp $00
    jp z, $5189
    cp $01
    jp z, $50e8
    cp $02
    jr z, $5065
    cp $03
    jp z, $50b6
    cp $04
    jp z, $507f
    cp $05
    jp z, $514a
MapMenu_HandleCopyAction::
    ld a, [$dc2b]
    call $51bd
    jp z, $5135
    ld a, $02
    call $3844
    call $4d26
    call $51ac
    call $4717
    jp $51a8
MapMenu_HandleSendAction::
    ld a, [$dc2b]
    call $51bd
    jp z, $5135
    ld a, [$dc2b]
    call $4046
    call $40d0
    jp c, $513d
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    ld a, [$dc2b]
    call $07b4
    ld a, [$dc2b]
    farcall $0c, MapInfrared_SendSelectedMap
    call $49f1
    ld a, $02
    call $3816
    call $081d
    jp $51ab
MapMenu_HandleDeleteAction::
    ld a, [$dc2b]
    call $51bd
    jr z, $5135
    ld a, $02
    call $3844
    call $4581
    xor a
    call $5301
    cp $00
    jr nz, $50dc
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    ld a, [$dc2b]
    farcall $13, MapSRAM_ClearSlotPresent
    call $44a0
    call $51ac
    call $4717
    jp $51a8
MapMenu_HandlePlayAction::
    ld a, [$dc2b]
    call $51bd
    jp z, $5135
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    call $07b4
    call $2e67
    ld a, [$dc2b]
    farcall $0f, MapEditor_TestSelectedRecord
    cp $ff
    jr z, $511a
    call $49f1
    call $4e60
    call $3537
    ld a, $01
    ld [$ca69], a
    jp $51ab
    call $49f1
    call $4e60
    call $081d
    jp $51a8
MapMenu_HandleSelectionCancel::
    bit 1, a
    jp z, $51a8
    ld a, $0c
    call $3844
    ld a, $ff
    jp $51ab
MapMenu_HandleUnavailableSlot::
    ld a, $03
    call $3844
    jp $51a8
MapMenu_HandleRestrictedSlot::
    ld a, $03
    call $3844
    ld a, $01
    call $4749
    jp $51a8
MapMenu_HandleReceiveAction::
    ld a, $02
    call $3844
    ld a, [$dc2b]
    call $51bd
    jr z, $5165
    ld a, $01
    call $5301
    cp $01
    jr nz, $5165
    call $44a0
    jr $51a8
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    call $07b4
    ld a, [$dc2b]
    farcall $0c, MapInfrared_ReceiveSelectedMap
    ld a, [$dc2b]
    call $4f40
    call $49f1
    ld a, $02
    call $3816
    call $081d
    jr $51ab
MapMenu_HandleEditAction::
    ld a, [$dc2c]
    farcall $15, SpriteTransition_SlideDownOffscreen
    call $07b4
    call $2e67
    ld a, [$dc2b]
    farcall $0f, MapEditor_OpenSelectedRecord
    call $49f1
    call $4e60
    call $081d
    jr $51a8
MapMenu_SlotSelectionReturnToInput::
    jp $4fbe
MapMenu_SlotSelectionReturn::
    ret
MapMenu_DrawSlotPairRows::
    ld bc, $0306
    ld d, $00
    call $4729
    ld bc, $0309
    ld d, $05
    call $4729
    ret
MapMenu_TestSelectedSlot::
    farcall $28, MapRuntime_LoadCurrentModeRecord
    ld a, $01
    ld hl, $ca1d
    call $3ac7
    ret
    ld a, [$dc2b]
    ld [$dc30], a
    ld bc, $0101
    ld de, $1203
    farcall $10, UIWindowStack_PushAndDraw
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0202
    ld de, $1001
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a

    assert @ == $51f3, "MapMenu Runtime 4F40 boundary moved"
