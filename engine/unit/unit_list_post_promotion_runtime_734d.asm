include "macros/macros.inc"

; Bank $18 Unit List post-promotion/runtime continuation.
; Executable bytes are expressed as LR35902 mnemonics. The range ends
; exactly before the preserved custom-English UnitList_Filter text owner.
; Address-oriented helper names are retained where behavior is not uniquely proven.

section "Unit List Post Promotion Runtime", romx[$734d], bank[$18]

UnitList_PostPromotionRuntime::
    nop
UnitList_PostPromotionEntry::
    call UnitList_RunDeleteAction
    xor a
    ld [$dc7b], a
.loc_7355:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 6, a
    jr z, .loc_7380
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc5a]
    dec a
    cp $ff
    jr nz, .loc_7378
    ld a, [$dc7e]
    dec a
.loc_7378:
    ld [$dc5a], a
    call UnitList_Runtime_7470
    jr .loc_7355
.loc_7380:
    bit 7, a
    jr z, .loc_739f
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc5a]
    inc a
    push af
    ld a, [$dc7e]
    ld c, a
    pop af
    cp c
    jr nz, .loc_7397
    xor a
.loc_7397:
    ld [$dc5a], a
    call UnitList_Runtime_7470
    jr .loc_7355
.loc_739f:
    bit 0, a
    jr z, .loc_73b1
    call UnitList_RunSelectedRecordAction
    jr c, .loc_73d3
    ld a, [$dc7a]
    cp $00
    jr z, .loc_7355
    jr .loc_73d3
.loc_73b1:
    bit 1, a
    jr z, .loc_7355
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, [$dc57]
    call SpriteObject_Destroy
    call Sprite_Update
    farcall UIWindowStack_PopRestore
    call UnitList_GetSelectionDisplayValue
    ld a, [$dc7b]
    and a
    jr z, .loc_73d3
    call UnitList_RedrawSelectionScreen
.loc_73d3:
    ld a, [$dc7a]
    cp $01
    jr z, .loc_73de
    farcall UIWindowStack_PopRestore
.loc_73de:
    ret
UnitList_Runtime_73DF::
    ld a, SFX_UNIT_LIST_DELETE
    call Audio_PlaySFX
    ld bc, $0204
    ld de, $1008
    farcall UIWindowStack_PushAndDrawAnimated
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0305
    ld de, $0e06
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $7a74
    call CoordTextPut
    ld hl, $7a80
    call CoordTextPut
    ld hl, $7a86
    call CoordTextPut
    ld hl, $7a8e
    call CoordTextPut
    ld hl, $7a97
    call CoordTextPut
    ld hl, $7aa2
    call CoordTextPut
    ldh a, [hVRAMBank]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call SpriteObject_ClearStruct
    ld [$dc56], a
    call UnitList_Runtime_745B
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret
UnitList_Runtime_7446::
    ld a, [$dc58]
    ld b, $10
    call $2995
    ld a, l
    add a, $38
    ld c, a
    ld b, $14
    ld a, [$dc53]
    call $2eae
    ret
UnitList_Runtime_745B::
    ld a, [$dc59]
    ld b, $08
    call $2995
    ld a, l
    add a, $3c
    ld c, a
    ld b, $20
    ld a, [$dc56]
    call $2eae
    ret
UnitList_Runtime_7470::
    ld a, [$dc5a]
    cp $02
    jr z, .loc_747c
    call UnitList_GetSelectionDisplayValue
    jr .loc_747f
.loc_747c:
    call Versus_DrawSetupFooter
.loc_747f:
    ld a, [$dc5a]
    ld b, $10
    call $2995
    ld a, l
    add a, $48
    ld c, a
    ld b, $30
    ld a, [$dc57]
    call $2eae
    ret
UnitList_Runtime_7494::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc70], a
    ld bc, $0005
    ld hl, $dc4e
    xor a
    call $3b84
.loc_74ab:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld hl, $dc4e
    ld bc, $0005
    call $3b59
    ld a, [$dc4e]
    srl a
    farcall $18, BattleScene_ClassifyMapTile3Way
    cp $00
    jr z, .loc_74cc
    jr .loc_74e9
.loc_74cc:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld a, [$dc71]
    farcall UnitList_GetStagingRecordPointer
    ld bc, $0005
    call $3b59
    ld a, [$dc71]
    inc a
    ld [$dc71], a
.loc_74e9:
    ld a, [$dc70]
    inc a
    ld [$dc70], a
    ld c, a
    ld a, [$dc66]
    cp c
    jr nz, .loc_74ab
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_74FD::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc70], a
    ld bc, $0005
    ld hl, $dc4e
    xor a
    call $3b84
.loc_7514:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld hl, $dc4e
    ld bc, $0005
    call $3b59
    ld a, [$dc4e]
    srl a
    farcall $18, BattleScene_ClassifyMapTile3Way
    cp $01
    jr z, .loc_7535
    jr .loc_7552
.loc_7535:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld a, [$dc71]
    farcall UnitList_GetStagingRecordPointer
    ld bc, $0005
    call $3b59
    ld a, [$dc71]
    inc a
    ld [$dc71], a
.loc_7552:
    ld a, [$dc70]
    inc a
    ld [$dc70], a
    ld c, a
    ld a, [$dc66]
    cp c
    jr nz, .loc_7514
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_7566::
    call UnitList_Runtime_757C
    ret
UnitList_Runtime_756A::
    call UnitList_Runtime_782D
    call UnitList_Runtime_77BB
    ret
UnitList_Runtime_7571::
    call UnitList_Runtime_789D
    call UnitList_Runtime_790F
    ret
UnitList_Runtime_7578::
    call UnitList_Runtime_7593
    ret
UnitList_Runtime_757C::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, $00
    ld [$dc73], a
    call UnitList_Runtime_7662
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_7593::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, $03
    ld [$dc73], a
    call UnitList_Runtime_76DA
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_75AA::
    call UnitList_Runtime_75AE
    ret
UnitList_Runtime_75AE::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, $02
    ld [$dc73], a
    call UnitList_Runtime_7662
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_75C5::
    call UnitList_Runtime_75C9
    ret
UnitList_Runtime_75C9::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, $01
    ld [$dc73], a
    call UnitList_Runtime_7662
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_75E0::
    ld c, a
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, c
    ld [$dc74], a
    ld a, b
    ld [$dc75], a
    ld a, [$dc74]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld hl, $dc4e
    ld bc, $0005
    call $3b59
    ld a, [$dc75]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld a, [$dc74]
    farcall UnitList_GetFilteredRecordPointer
    ld bc, $0005
    call $3b59
    ld de, $dc4e
    ld a, [$dc75]
    farcall UnitList_GetFilteredRecordPointer
    ld bc, $0005
    call $3b59
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_7630::
    push bc
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld hl, $dc4e
    ld bc, $0005
    call $3b59
    pop bc
    ld a, b
    cp $00
    jr z, .loc_7652
    cp $01
    jr z, .loc_7656
    cp $02
    jr z, .loc_765a
    cp $03
    jr z, .loc_765e
.loc_7652:
    ld a, [$dc4e]
    ret
.loc_7656:
    ld a, [$dc4f]
    ret
.loc_765a:
    ld a, [$dc50]
    ret
.loc_765e:
    ld a, [$dc51]
    ret
UnitList_Runtime_7662::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc79], a
    ld a, [$dc66]
    dec a
    ld [$dc77], a
    xor a
    ld [$dc78], a
    jr .loc_768b
.loc_767c:
    xor a
    ld [$dc78], a
    ld a, [$dc77]
    cp $00
    jr z, .loc_76d4
    dec a
    ld [$dc77], a
.loc_768b:
    ld a, [$dc78]
    ld c, a
    ld a, [$dc77]
    cp c
    jr z, .loc_76cd
    ld a, [$dc79]
    inc a
    ld [$dc79], a
    ld a, [$dc73]
    ld b, a
    ld a, [$dc78]
    call UnitList_Runtime_7630
    ld c, a
    push bc
    ld a, [$dc73]
    ld b, a
    ld a, [$dc78]
    inc a
    call UnitList_Runtime_7630
    pop bc
    cp c
    jr c, .loc_76b9
    jr .loc_76c4
.loc_76b9:
    ld a, [$dc78]
    inc a
    ld b, a
    ld a, [$dc78]
    call UnitList_Runtime_75E0
.loc_76c4:
    ld a, [$dc78]
    inc a
    ld [$dc78], a
    jr .loc_768b
.loc_76cd:
    ld a, $01
    ld [$dc78], a
    jr .loc_767c
.loc_76d4:
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_76DA::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc79], a
    ld a, [$dc66]
    dec a
    ld [$dc77], a
    xor a
    ld [$dc78], a
    jr .loc_7703
.loc_76f4:
    xor a
    ld [$dc78], a
    ld a, [$dc77]
    cp $00
    jr z, .loc_774c
    dec a
    ld [$dc77], a
.loc_7703:
    ld a, [$dc78]
    ld c, a
    ld a, [$dc77]
    cp c
    jr z, .loc_7745
    ld a, [$dc79]
    inc a
    ld [$dc79], a
    ld a, [$dc73]
    ld b, a
    ld a, [$dc78]
    inc a
    call UnitList_Runtime_7630
    ld c, a
    push bc
    ld a, [$dc73]
    ld b, a
    ld a, [$dc78]
    call UnitList_Runtime_7630
    pop bc
    cp c
    jr c, .loc_7731
    jr .loc_773c
.loc_7731:
    ld a, [$dc78]
    inc a
    ld b, a
    ld a, [$dc78]
    call UnitList_Runtime_75E0
.loc_773c:
    ld a, [$dc78]
    inc a
    ld [$dc78], a
    jr .loc_7703
.loc_7745:
    ld a, $01
    ld [$dc78], a
    jr .loc_76f4
.loc_774c:
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc70], a
    ld bc, $0005
    ld hl, $dc4e
    xor a
    call $3b84
.loc_7769:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld hl, $dc4e
    ld bc, $0005
    call $3b59
    ld a, [$dc4e]
    srl a
    farcall $18, BattleScene_ClassifyMapTile3Way
    cp $02
    jr z, .loc_778a
    jr .loc_77a7
.loc_778a:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld a, [$dc71]
    farcall UnitList_GetStagingRecordPointer
    ld bc, $0005
    call $3b59
    ld a, [$dc71]
    inc a
    ld [$dc71], a
.loc_77a7:
    ld a, [$dc70]
    inc a
    ld [$dc70], a
    ld c, a
    ld a, [$dc66]
    cp c
    jr nz, .loc_7769
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_77BB::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc70], a
    ld bc, $0005
    ld hl, $dc4e
    xor a
    call $3b84
.loc_77d2:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld hl, $dc4e
    ld bc, $0005
    call $3b59
    ld a, [$dc52]
    ld c, $03
    farcall $12, UnitRecord_GetByte
    ld [$dc7c], a
    ld a, $01
    ld hl, $dc7c
    call Bitfield_Test
    jr z, .loc_77fc
    jr .loc_7819
.loc_77fc:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld a, [$dc71]
    farcall UnitList_GetStagingRecordPointer
    ld bc, $0005
    call $3b59
    ld a, [$dc71]
    inc a
    ld [$dc71], a
.loc_7819:
    ld a, [$dc70]
    inc a
    ld [$dc70], a
    ld c, a
    ld a, [$dc66]
    cp c
    jr nz, .loc_77d2
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_782D::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc70], a
    ld bc, $0005
    ld hl, $dc4e
    xor a
    call $3b84
.loc_7844:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld hl, $dc4e
    ld bc, $0005
    call $3b59
    ld a, [$dc52]
    ld c, $03
    farcall $12, UnitRecord_GetByte
    ld [$dc7c], a
    ld a, $01
    ld hl, $dc7c
    call Bitfield_Test
    jr z, .loc_7889
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld a, [$dc71]
    farcall UnitList_GetStagingRecordPointer
    ld bc, $0005
    call $3b59
    ld a, [$dc71]
    inc a
    ld [$dc71], a
.loc_7889:
    ld a, [$dc70]
    inc a
    ld [$dc70], a
    ld c, a
    ld a, [$dc66]
    cp c
    jr nz, .loc_7844
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_789D::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc70], a
    ld bc, $0005
    ld hl, $dc4e
    xor a
    call $3b84
.loc_78b4:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld hl, $dc4e
    ld bc, $0005
    call $3b59
    ld a, [$dc52]
    ld c, $03
    farcall $12, UnitRecord_GetByte
    ld [$dc7c], a
    ld a, $07
    ld hl, $dc7c
    call Bitfield_Test
    jr z, .loc_78de
    jr .loc_78fb
.loc_78de:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld a, [$dc71]
    farcall UnitList_GetStagingRecordPointer
    ld bc, $0005
    call $3b59
    ld a, [$dc71]
    inc a
    ld [$dc71], a
.loc_78fb:
    ld a, [$dc70]
UnitList_Runtime_78FE::
    inc a
    ld [$dc70], a
    ld c, a
    ld a, [$dc66]
    cp c
    jr nz, UnitList_Runtime_789D.loc_78b4
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_790F::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc70], a
    ld bc, $0005
    ld hl, $dc4e
    xor a
    call $3b84
.loc_7926:
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld hl, $dc4e
    ld bc, $0005
    call $3b59
    ld a, [$dc52]
    ld c, $03
    farcall $12, UnitRecord_GetByte
    ld [$dc7c], a
    ld a, $07
    ld hl, $dc7c
    call Bitfield_Test
    jr z, .loc_796b
    ld a, [$dc70]
    farcall UnitList_GetFilteredRecordPointer
    ld d, h
    ld e, l
    ld a, [$dc71]
    farcall UnitList_GetStagingRecordPointer
    ld bc, $0005
    call $3b59
    ld a, [$dc71]
    inc a
    ld [$dc71], a
.loc_796b:
    ld a, [$dc70]
    inc a
    ld [$dc70], a
    ld c, a
    ld a, [$dc66]
    cp c
    jr nz, .loc_7926
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_797F::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$dc71], a
    ld bc, $00fa
    ld hl, $db54
    xor a
    call $3b84
    ld a, [$dc59]
    cp $00
    jr z, .loc_79b1
    cp $01
    jr z, .loc_79bb
    cp $02
    jr z, .loc_79c0
    cp $03
    jr z, .loc_79c5
    cp $04
    jr z, .loc_79b6
    cp $05
    jr z, .loc_79ca
.loc_79b1:
    call UnitList_Runtime_7566
    jr .loc_79db
.loc_79b6:
    call UnitList_Runtime_756A
    jr .loc_79cf
.loc_79bb:
    call UnitList_Runtime_7578
    jr .loc_79db
.loc_79c0:
    call UnitList_Runtime_75AA
    jr .loc_79db
.loc_79c5:
    call UnitList_Runtime_75C5
    jr .loc_79db
.loc_79ca:
    call UnitList_Runtime_7571
    jr .loc_79cf
.loc_79cf:
    ld de, $db54
    ld hl, $da5a
    ld bc, $00fa
    call $3b59
.loc_79db:
    ld bc, $0101
    call Versus_DrawSelectedUnitName
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
UnitList_Runtime_79E7::
    call UnitList_Runtime_73DF
.loc_79ea:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [hJoyRepeat]
    bit 6, a
    jr z, .loc_7a13
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc59]
    dec a
    cp $ff
    jr nz, .loc_7a0b
    ld a, $05
.loc_7a0b:
    ld [$dc59], a
    call UnitList_Runtime_745B
    jr .loc_79ea
.loc_7a13:
    bit 7, a
    jr z, .loc_7a2d
    ld a, $01
    call Audio_PlaySFX
    ld a, [$dc59]
    inc a
    cp $06
    jr nz, .loc_7a25
    xor a
.loc_7a25:
    ld [$dc59], a
    call UnitList_Runtime_745B
    jr .loc_79ea
.loc_7a2d:
    bit 0, a
    jr z, .loc_7a5b
    ld a, [$dc56]
    farcall SpriteTransition_SlideRightOffscreen
    call UnitList_Runtime_797F
    ld a, [$dc56]
    call SpriteObject_Destroy
    call Sprite_Update
    farcall UIWindowStack_PopRestore
    call Versus_DrawSetupUnitEntries
    farcall UnitList_UpdateScrollArrowVisibility
    call UnitList_Runtime_7446
    call $7f62
    call $7f02
    ret
    jr .loc_79ea
.loc_7a5b:
    bit 1, a
    jr nz, .loc_7a61
    jr .loc_79ea
.loc_7a61:
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, [$dc56]
    call SpriteObject_Destroy
    call Sprite_Update
    farcall UIWindowStack_PopRestore
    ret

    assert @ == $7a74, "Unit List post-promotion runtime boundary moved"
