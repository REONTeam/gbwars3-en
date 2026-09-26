include "macros/macros.inc"

; Two-side result-screen presentation support.
;
; $5267-$54E6 contains the wait/cancel, randomized-entry animation, layout,
; and screen-setup helpers used by the public $54E7 result presentation.
; The public service receives A as a perspective/result-side selector and B as
; a zero-based side index, stages both in WRAM bank 4, runs the side-specific
; presentation/SFX sequence, permits A/B/Start cancellation, then fades out.

section "Map Result Side Presentation", romx[$5267], bank[$27]

MapResult_WaitFramesOrCancel::
    push hl
    ld hl,$0000
.loc_526b:
    call Math_CompareHLToDE
    jr nz,.loc_5273
    xor a
    jr .loc_5293
.loc_5273:
    push hl
    push de
    push bc
    call Joypad_Update
    pop bc
    pop de
    pop hl
    ldh a,[hJoyPressed]
    bit 0,a
    jr nz,.loc_528c
    bit 1,a
    jr nz,.loc_528c
    bit 3,a
    jr nz,.loc_528c
    jr .loc_5290
.loc_528c:
    xor a
    scf
    jr .loc_5293
.loc_5290:
    inc hl
    jr .loc_526b
.loc_5293:
    pop hl
    ret
MapResult_BuildRandomOrder::
    ldh a,[hWRAMBank]
    push af
    ld a,$04
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    xor a
    ld [$dbb9],a
    ld hl,$db95
    ld a,[$dbba]
    inc a
    ld b,$00
    ld c,a
    ld a,$ff
    call Memset
.loc_52b1:
    ld a,[$dbba]
    ld d,a
    call Random_ZeroToDInclusive
    ld hl,$db95
    ld b,$00
    ld c,a
    add hl,bc
    ld a,[hl]
    cp $ff
    jr nz,.loc_52b1
    ld a,[$dbb9]
    ld [hl],a
    inc a
    ld [$dbb9],a
    ld a,[$dbba]
    inc a
    ld c,a
    ld a,[$dbb9]
    cp c
    jr z,.loc_52d9
    jr .loc_52b1
.loc_52d9:
    pop af
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    ret
MapResult_AnimateEntries::
    ldh a,[hWRAMBank]
    push af
    ld a,$04
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    xor a
    ld [$dbc3],a
.loc_52ec:
    ld de,$0001
    call MapResult_WaitFramesOrCancel
    jr c,.loc_5318
    ld a,[$dbc3]
    ld b,$00
    ld c,a
    ld hl,$db95
    add hl,bc
    ld a,[hl]
    call MapResult_DrawOrderedEntry
    ld a,[$dbc3]
    inc a
    ld [$dbc3],a
    ld c,a
    ld a,[$dbba]
    inc a
    cp c
    jr nz,.loc_52ec
    pop af
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    xor a
    ret
.loc_5318:
    pop af
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    scf
    ret
MapResult_FindRandomOrderIndex::
    ld c,a
    ldh a,[hWRAMBank]
    push af
    ld a,$04
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    xor a
    ld [$dbb9],a
.loc_532d:
    push bc
    ld hl,$db95
    ld a,[$dbb9]
    ld c,a
    ld b,$00
    add hl,bc
    ld a,[hl]
    pop bc
    cp c
    jr z,.loc_5346
    ld a,[$dbb9]
    inc a
    ld [$dbb9],a
    jr .loc_532d
.loc_5346:
    ld a,[$dbb9]
    ld c,a
    pop af
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    ld a,c
    ret
MapResult_DrawOrderedEntry::
    ld d,a
    ldh a,[hWRAMBank]
    push af
    ld a,$04
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    ld a,d
    ld [$dbc2],a
    ld a,[$dbbb]
    ld b,a
    ld a,[$dbc2]
    farcall $14, Math_DivideAByB
    push af
    ld a,[$dbbf]
    ld c,a
    pop af
    add a,c
    ld [$dbbd],a
    ld a,[$dbbb]
    ld b,a
    ld a,[$dbc2]
    farcall $14, Math_DivideAByB
    ld a,b
    push af
    ld a,[$dbc0]
    ld c,a
    pop af
    add a,c
    ld [$dbbe],a
    pop af
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    ld a,[$dbc2]
    push af
    ld a,[$dbc6]
    ld c,a
    pop af
    add a,c
    ld h,a
    ld a,[$dbbd]
    ld b,a
    ld a,[$dbbe]
    ld c,a
    ld de,$0101
    ld a,[$dbc7]
    farcall $15, Gfx_DrawSequentialTileRectWithAttributes
    ret
MapResult_SetupPrimaryScreen::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    xor a
    ldh [hSCX],a
    ldh [hSCY],a
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ldh a,[hVRAMBank]
    push af
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld de,$55c3
    ld hl,$9000
    ld bc,$0800
    call Memcpy
    ld de,$5dc3
    ld hl,$8800
    ld bc,$0110
    call Memcpy
    pop af
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$00
    ld b,$08
    ld hl,$5ed3
    call Vram_SetPals
    call Vram_ApplyPals
    ret
MapResult_SetupSecondaryScreen::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    xor a
    ldh [hSCX],a
    ldh [hSCY],a
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ldh a,[hVRAMBank]
    push af
    ld a,$00
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld de,$55c3
    ld hl,$9000
    ld bc,$0800
    call Memcpy
    ld de,$5dc3
    ld hl,$8800
    ld bc,$0110
    call Memcpy
    pop af
    ldh [hVRAMBank],a
    ldh [rVBK],a
    ld a,$00
    ld b,$08
    ld hl,$5ed3
    call Vram_SetPals
    call Vram_ApplyPals
    ret
MapResult_ConfigurePerspectiveLayout::
    ld a,[$dbc4]
    cp $00
    jr nz,.loc_547d
    ld a,$01
    ld [$dbc7],a
    ld a,$03
    ld [$dbbf],a
    ld a,$06
    ld [$dbc0],a
    ld a,$0e
    ld [$dbbb],a
    ld a,$02
    ld [$dbbc],a
    ld a,$1b
    ld [$dbba],a
    ld a,$21
    ld [$dbc6],a
    jr .loc_54a0
.loc_547d:
    ld a,$02
    ld [$dbc7],a
    ld a,$01
    ld [$dbbf],a
    ld a,$06
    ld [$dbc0],a
    ld a,$12
    ld [$dbbb],a
    ld a,$02
    ld [$dbbc],a
    ld a,$23
    ld [$dbba],a
    ld a,$3d
    ld [$dbc6],a
.loc_54a0:
    ret
MapResult_ConfigureSideLayout::
    ld a,[$dbc5]
    cp $00
    jr nz,.loc_54c8
    ld a,$04
    ld [$dbbf],a
    ld a,$0a
    ld [$dbc0],a
    ld a,$0c
    ld [$dbbb],a
    ld a,$02
    ld [$dbbc],a
    ld a,$17
    ld [$dbba],a
    ld a,$61
    ld [$dbc6],a
    jr .loc_54e6
.loc_54c8:
    ld a,$04
    ld [$dbbf],a
    ld a,$0a
    ld [$dbc0],a
    ld a,$0c
    ld [$dbbb],a
    ld a,$02
    ld [$dbbc],a
    ld a,$17
    ld [$dbba],a
    ld a,$79
    ld [$dbc6],a
.loc_54e6:
    ret
MapResult_PresentSideOutcome::
    ld d,a
    ldh a,[hWRAMBank]
    push af
    ld a,$04
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    ld a,d
    ld [$dbc4],a
    ld a,b
    ld [$dbc5],a
    call MapResult_SetupPrimaryScreen
    call Audio_StopMusic
    call FadeFromWhite8
    ld de,$001e
    call MapResult_WaitFramesOrCancel
    jr c,.loc_5557
    call MapResult_ConfigurePerspectiveLayout
    call MapResult_BuildRandomOrder
    ld a,[$dbc4]
    cp $00
    jr z,.loc_5519
    jr .loc_551d
.loc_5519:
    ld a,$64
    jr .loc_551f
.loc_551d:
    ld a,$65
.loc_551f:
    call Audio_PlaySFX
    call MapResult_AnimateEntries
    jr c,.loc_5557
    ld de,$003c
    call MapResult_WaitFramesOrCancel
    jr c,.loc_5557
    call MapResult_ConfigureSideLayout
    call MapResult_BuildRandomOrder
    ld a,[$dbc5]
    cp $00
    jr z,.loc_553e
    jr .loc_5542
.loc_553e:
    ld a,$85
    jr .loc_5544
.loc_5542:
    ld a,$86
.loc_5544:
    call Audio_PlaySFX
    call MapResult_AnimateEntries
    jr c,.loc_5557
    ld de,$003c
    ld bc,$0000
    call MapResult_WaitFramesOrCancel
    jr c,.loc_5557
.loc_5557:
    call Audio_StopSFX
    call Audio_StopMusic
    call FadeToWhite8
    pop af
    ldh [hWRAMBank],a
    ldh [rSVBK],a
    ret

    assert @ == $5566
