include "macros/macros.inc"

; Versus setup/army-selection runtime. Executable portions are mnemonic
; and byte-exact against the Japanese retail ROM. Provider names remain
; conservative where higher-level behavior is not independently proven.
DEF VersusSetup_UIProvider_6A09 EQU $6a09
DEF VersusSetup_UIProvider_6AD3 EQU $6ad3
DEF VersusSetup_UIProvider_67FD EQU $67fd
DEF VersusSetup_UnitProvider_4066 EQU $4066
DEF VersusSetup_UnitProvider_4498 EQU $4498
DEF VersusSetup_UnitListProvider_735E EQU $735e

section "Versus Setup Selection Runtime", romx[$65e0], bank[$18]
Versus_ResetSetupSelectionState::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc58], a
    ld [$dc59], a
    ld [$dc5a], a
    ld [$dc5b], a
    ld [$dc5c], a
    ld [$dc5d], a
    ld [$dc5e], a
    ld [$dc5f], a
    ld [$dc60], a
    ld [$dc61], a
    ld [$dc62], a
    ld [$dc63], a
    ld [$dc64], a
    ld [$dc7a], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
Versus_LoadActiveSideSetupState::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [$c633]
    and $01
    jr z, $662c
    jr $6646
    ld a, [$dc5c]
    ld [$dc58], a
    ld a, [$dc5d]
    ld [$dc59], a
    ld a, [$dc5e]
    ld [$dc5a], a
    ld a, [$dc5f]
    ld [$dc5b], a
    jr $665e
    ld a, [$dc60]
    ld [$dc58], a
    ld a, [$dc61]
    ld [$dc59], a
    ld a, [$dc62]
    ld [$dc5a], a
    ld a, [$dc63]
    ld [$dc5b], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
Versus_SaveActiveSideSetupState::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [$c633]
    and $01
    jr z, $6676
    jr $6690
    ld a, [$dc58]
    ld [$dc5c], a
    ld a, [$dc59]
    ld [$dc5d], a
    ld a, [$dc5a]
    ld [$dc5e], a
    ld a, [$dc5b]
    ld [$dc5f], a
    jr $66a8
    ld a, [$dc58]
    ld [$dc60], a
    ld a, [$dc59]
    ld [$dc61], a
    ld a, [$dc5a]
    ld [$dc62], a
    ld a, [$dc5b]
    ld [$dc63], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
Versus_DrawSetupSelectionScreen::
    call $04f3
    call $34ce
    call $2d7c
    call Versus_SetupRuntime_6794
    ld a, [$c633]
    and $01
    jr z, $66c3
    jr $66c8
    ld a, [$cd09]
    jr $66cb
    ld a, [$cd0a]
    ld [$dc66], a
    farcall $17, UnitList_GetFilteredRecordPointer
    farcall $10, UIWindowStack_Init
    farcall $01, SharedGraphics_LoadMainFontBG
    call $0618
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ld [$dc80], a
    ld [$dc81], a
    ld [$dc82], a
    ld [$dc83], a
    ld [$dc84], a
    call $0f02
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall $15, Gfx_LoadCommonScreenAssets
    ld a, $00
    ld b, $08
    ld hl, $7e78
    call $06bc
    call $06af
    ld a, $01
    ld b, $01
    ld hl, $6cc2
    ld c, $15
    call $06d9
    call $06f2
    ld a, $05
    farcall $0b, MapPresentation_LoadThreeTileBlock
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $7ab8
    ld hl, $9000
    ld bc, $03c0
    call $3b50
    ld hl, $9000
    ld bc, $0010
    xor a
    call $3b84
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call Versus_DrawSetupSelectionDetails
    ldh a, [hVRAMBank]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call $2de8
    ld [$dc53], a
    call $7446
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call $2de8
    ld [$dc54], a
    ld bc, $582c
    call $2eae
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call $2de8
    ld [$dc55], a
    ld bc, $5894
    call $2eae
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0101
    call Versus_DrawSelectedUnitName
    ret
Versus_SetupRuntime_6794::
    call $7f02
    ret
Versus_DrawSetupSelectionDetails::
    ld bc, $0000
    ld de, $0d03
    farcall $10, VersusSetup_UIProvider_6A09
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0101
    ld de, $0b01
    farcall $15, VersusSetup_UIProvider_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0d00
    ld de, $0703
    farcall $10, VersusSetup_UIProvider_6A09
    call $6c72
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0e01
    ld de, $0501
    farcall $15, VersusSetup_UIProvider_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $0103
    ld de, $120e
    farcall $10, VersusSetup_UIProvider_6A09
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0204
    ld de, $100c
    farcall $15, VersusSetup_UIProvider_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $0a
    ld bc, $0211
    ld de, $0301
    ld h, $04
    farcall $15, VersusSetup_UIProvider_67FD
    ld a, $08
    ld bc, $0511
    ld de, $0501
    ld h, $07
    farcall $15, VersusSetup_UIProvider_67FD
    ld a, $0a
    ld bc, $0e11
    ld de, $0101
    ld h, $0c
    farcall $15, VersusSetup_UIProvider_67FD
    ld a, $08
    ld bc, $0f11
    ld de, $0301
    ld h, $0d
    farcall $15, VersusSetup_UIProvider_67FD
    ld bc, $0405
    farcall $17, VersusSetup_DrawDividerRow
    ld bc, $0407
    farcall $17, VersusSetup_DrawDividerRow
    ld bc, $0409
    farcall $17, VersusSetup_DrawDividerRow
    ld bc, $040b
    farcall $17, VersusSetup_DrawDividerRow
    ld bc, $040d
    farcall $17, VersusSetup_DrawDividerRow
    ld bc, $040f
    farcall $17, VersusSetup_DrawDividerRow
    call Versus_DrawSetupSelectionRows
    call Versus_AdjustSetupSelectionWindow
    call Versus_DrawSetupUnitEntries
    call $3537
    ret
Versus_DrawSetupSelectionRows::
    xor a
    ld [$dc65], a
Versus_DrawSetupSelectionRows_Loop::
    ld a, [$dc65]
    cp $06
    jr z, $68d7
    push af
    ld a, [$dc66]
    ld c, a
    pop af
    cp c
    jr z, $68d7
    ld h, $00
    ld l, $0f
    ld bc, $0504
    ld a, [$dc65]
    add a, a
    add a, c
    ld c, a
    ld d, $02
    ld a, $0b
    ld de, $0101
    ld h, $01
    farcall $15, VersusSetup_UIProvider_67FD
    ld bc, $0a04
    ld a, [$dc65]
    add a, a
    add a, c
    ld c, a
    ld d, $02
    ld a, $0b
    ld de, $0101
    ld h, $02
    farcall $15, VersusSetup_UIProvider_67FD
    ld bc, $0f04
    ld a, [$dc65]
    add a, a
    add a, c
    ld c, a
    ld d, $02
    ld a, $0b
    ld de, $0101
    ld h, $03
    farcall $15, VersusSetup_UIProvider_67FD
    ld a, [$dc65]
    inc a
    ld [$dc65], a
    jp Versus_DrawSetupSelectionRows_Loop
    ret
Versus_GetSetupSelectionRelativeIndex::
    ld a, [$dc5b]
    ld c, a
    ld a, [$dc58]
    add a, c
    push af
    ld a, [$dc66]
    ld c, a
    pop af
    cp c
    jr c, $68ea
    sub c
    ret
Versus_SetupRuntime_68EB::
    push hl
    push bc
    ld a, [$dc6d]
    inc a
    ld c, a
    ld b, $03
    ld a, [$ffcb]
    push af
    push bc
    xor a
    ld [$ffcb], a
    ld a, $2f
    call $34ed
    pop bc
    ld a, $01
    ld [$ffcb], a
    ld a, $0b
    call $34ed
    pop af
    ld [$ffcb], a
    pop bc
    pop hl
    ret
Versus_SetupRuntime_6914::
    push hl
    push bc
    ld a, [$dc6d]
    inc a
    ld c, a
    ld b, $03
    ld a, [$ffcb]
    push af
    push bc
    xor a
    ld [$ffcb], a
    ld a, $30
    call $34ed
    pop bc
    ld a, $01
    ld [$ffcb], a
    ld a, $0b
    call $34ed
    pop af
    ld [$ffcb], a
    pop bc
    pop hl
    ret
Versus_SetupRuntime_693D::
    push hl
    push bc
    ld a, [$dc6d]
    inc a
    ld c, a
    ld b, $03
    ld a, [$ffcb]
    push af
    push bc
    xor a
    ld [$ffcb], a
    ld a, $31
    call $34ed
    pop bc
    ld a, $01
    ld [$ffcb], a
    ld a, $0b
    call $34ed
    pop af
    ld [$ffcb], a
    pop bc
    pop hl
    ret
Versus_SetupRuntime_6966::
    push hl
    push bc
    ld a, [$dc6d]
    inc a
    ld c, a
    ld b, $03
    ld a, [$ffcb]
    push af
    push bc
    xor a
    ld [$ffcb], a
    ld a, $32
    call $34ed
    pop bc
    ld a, $01
    ld [$ffcb], a
    ld a, $0b
    call $34ed
    pop af
    ld [$ffcb], a
    pop bc
    pop hl
    ret
Versus_ReadSelectedUnitRecordField::
    ld l, a
    ld h, $00
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $d000
    add hl, de
    ld bc, $0005
    add hl, bc
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [hl]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret
Versus_UpdateSelectedUnitPresentation::
    push hl
    push bc
    ld a, [$dc6c]
    ld c, $03
    farcall $12, VersusSetup_UnitProvider_4066
    ld [$dc7c], a
    ld a, [$dc6c]
    call Versus_ReadSelectedUnitRecordField
    cp $00
    jr z, $69e2
    ld a, [$dc6c]
    ld c, $03
    farcall $12, VersusSetup_UnitProvider_4066
    ld [$dc7c], a
    bit 7, a
    jr z, $69e2
    pop bc
    pop hl
    push hl
    push bc
    call Versus_SetupRuntime_6966
    pop bc
    pop hl
    ret
    ld a, [$dc7c]
    bit 7, a
    jr z, $69f3
    pop bc
    pop hl
    push hl
    push bc
    call Versus_SetupRuntime_693D
    pop bc
    pop hl
    ret
    ld a, [$dc7c]
    bit 1, a
    jr z, $6a04
    pop bc
    pop hl
    push hl
    push bc
    call Versus_SetupRuntime_68EB
    pop bc
    pop hl
    ret
    ld a, [$dc6c]
    call Versus_ReadSelectedUnitRecordField
    cp $00
    jr z, $6a18
    pop bc
    pop hl
    push hl
    push bc
    call Versus_SetupRuntime_6914
    pop bc
    pop hl
    ret
    pop bc
    pop hl
    ret
Versus_AdjustSetupSelectionWindow::
    ld a, [$dc66]
    ld c, a
    ld a, [$dc64]
    cp c
    jr c, $6a2c
    ld a, [$dc66]
    dec a
    ld [$dc64], a
    ld a, [$dc66]
    dec a
    cp $05
    jr c, $6a42
    ld a, [$dc64]
    add a, $06
    ld c, a
    ld a, [$dc66]
    cp c
    jr c, $6a69
    jr $6a5b
    xor a
    ld [$dc5b], a
    ld a, [$dc66]
    ld c, a
    ld a, [$dc58]
    cp c
    jr c, $6a5a
    ld a, [$dc66]
    dec a
    ld [$dc58], a
    call $7446
    ret
    ld a, [$dc64]
    ld [$dc5b], a
    xor a
    ld [$dc58], a
    call $7446
    ret
    ld a, [$dc64]
    add a, $06
    push af
    ld a, [$dc66]
    ld c, a
    pop af
    sub c
    ld [$dc58], a
    call $7446
    ld a, [$dc66]
    sub $06
    ld [$dc5b], a
    ret
Versus_DrawSetupUnitEntries::
    ld a, [$dc5b]
    ld [$dc67], a
    xor a
    ld [$dc65], a
    ld a, [$dc66]
    ld c, a
    ld a, [$dc65]
    cp $06
    jp z, Versus_DrawSetupUnitEntries_Done
    cp c
    jp z, Versus_DrawSetupUnitEntries_Next
    inc a
    ld [$dc65], a
    ld a, [$dc67]
    farcall $17, UnitList_GetFilteredRecordPointer
    ld a, [hli]
    ld [$dc68], a
    ld a, [hli]
    ld [$dc69], a
    ld a, [hli]
    ld [$dc6a], a
    ld a, [hli]
    ld [$dc6b], a
    ld a, [hl]
    ld [$dc6c], a
    ld a, [$dc65]
    dec a
    ld b, $40
    call $2995
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld bc, $8800
    add hl, bc
    ld a, [$dc6c]
    farcall $0b, UnitGraphic_LoadFromRecordIndex
    ld bc, $0204
    ld a, [$dc65]
    dec a
    add a, a
    add a, c
    ld c, a
    ld [$dc6d], a
    ld b, $02
    call $0ed4
    ld b, $01
    ld a, [$dc68]
    ld d, a
    ld c, $05
    push bc
    push de
    push hl
    ld a, [$dc65]
    dec a
    ld b, $04
    call $2995
    ld a, l
    add a, $80
    pop hl
    pop de
    pop bc
    push hl
    farcall $0b, UnitGraphic_DrawMetatile
    pop hl
    call Versus_UpdateSelectedUnitPresentation
    ld a, [$dc6d]
    ld c, a
    ld b, $07
    push bc
    ld d, $02
    ld a, [$dc69]
    call $31f5
    ld a, [$dc69]
    cp $04
    jr c, $6b24
    jr $6b3e
    pop bc
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $03
    ld de, $0201
    farcall $15, VersusSetup_UIProvider_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    jr $6b56
    pop bc
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    ld de, $0201
    farcall $15, VersusSetup_UIProvider_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$dc6d]
    ld c, a
    ld b, $0c
    ld d, $02
    push bc
    ld a, [$dc6a]
    call $31f5
    ld a, [$dc6a]
    cp $15
    jr c, $6b6e
    jr $6b88
    pop bc
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $03
    ld de, $0201
    farcall $15, VersusSetup_UIProvider_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    jr $6ba0
    pop bc
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    ld de, $0201
    farcall $15, VersusSetup_UIProvider_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$dc6d]
    ld c, a
    ld b, $11
    ld d, $02
    ld a, [$dc6b]
    push bc
    push af
    ld a, [$dc67]
    farcall $17, UnitList_GetFilteredRecordPointer
    ld bc, $0004
    add hl, bc
    ld a, [hl]
    farcall $12, VersusSetup_UnitProvider_4498
    cp $00
    jr z, $6bd6
    jr $6bc3
    ld a, [$dc6d]
    ld c, a
    ld b, $10
    ld de, $0101
    ld h, $33
    ld a, $08
    farcall $15, VersusSetup_UIProvider_67FD
    jr $6be7
    ld a, [$dc6d]
    ld c, a
    ld b, $10
    ld de, $0101
    ld h, $00
    ld a, $00
    farcall $15, VersusSetup_UIProvider_67FD
    pop af
    ld b, $02
    call $2995
    ld bc, $7aae
    add hl, bc
    pop bc
    call $3353
    ld a, [$dc66]
    ld c, a
    ld a, [$dc67]
    inc a
    cp c
    jr z, $6c02
    jr $6c03
    xor a
    ld [$dc67], a
    jp $6a8e
Versus_DrawSetupUnitEntries_Next::
    ld a, [$dc65]
    farcall $17, VersusSetup_UnitListProvider_735E
    ld a, [$dc65]
    inc a
    cp $06
    jr z, Versus_DrawSetupUnitEntries_Done
    ld [$dc65], a
    jr Versus_DrawSetupUnitEntries_Next
Versus_DrawSetupUnitEntries_Done::
    ret
Versus_DrawSelectedUnitName::
    push bc
    call Versus_GetSetupSelectionRelativeIndex
    farcall $17, UnitList_GetFilteredRecordPointer
    ld a, [hl]
    farcall $12, UnitData_CopyNameToBuffer
    ld hl, $cd28
    call $7eb8
    pop bc
    ld hl, $cd28
    call $3353
    ret
Versus_DrawSetupText_6C39::
    push bc
    farcall $12, UnitData_CopyNameToBuffer
    ld hl, $cd28
    call $7eb8
    pop bc
    ld hl, $cd28
    call $3353
    ret
Versus_DrawSetupFooter::
    ld bc, $0e01
    ld hl, $6c6c
    call $3353
    ld a, $0e
    call $058d
    call $0593
    ld a, [$a106]
    ld bc, $1001
    ld d, $02
    call $31f5
    call $059b
    ret

    assert @ == $6c6c, "Versus setup executable boundary moved"

; Four spaces consumed as the fixed footer text record by the retail screen.
Versus_SetupFooterPadding::
    db $20, $20, $20, $20
    assert @ == $6c70, "Versus setup runtime boundary moved"
