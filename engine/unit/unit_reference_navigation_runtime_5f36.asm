include "macros/macros.inc"

; Shared navigation/screen infrastructure for the Bank $25 Unit Reference and
; Unit Status pages.  The three arrow constructors differ only in the Y
; position of the upper arrow; the lower arrow remains at the bottom of the
; list.  Later detail/submenu pages reuse these same providers.

DEF wUnitReferenceScrollOffset       EQU $d979
DEF wUnitReferenceCursorRow          EQU $d97a
DEF wUnitReferenceCursorSpriteID     EQU $d97b
DEF wUnitReferenceScrollUpSpriteID   EQU $d9bc
DEF wUnitReferenceScrollDownSpriteID EQU $d9bd
DEF wUnitReferenceDrawIndex          EQU $d9be

section "Unit Reference Shared Navigation", romx[$5f36], bank[$25]

UnitReference_CreateScrollArrowsTop2C::
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call SpriteObject_Create
    ld [wUnitReferenceScrollUpSpriteID], a
    ld bc, $582c
    call SpriteObject_SetPosition

    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [wUnitReferenceScrollDownSpriteID], a
    ld bc, $589c
    call SpriteObject_SetPosition
    ret

    assert @ == $5f61

UnitReference_CreateScrollArrowsTop34::
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call SpriteObject_Create
    ld [wUnitReferenceScrollUpSpriteID], a
    ld bc, $5834
    call SpriteObject_SetPosition

    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [wUnitReferenceScrollDownSpriteID], a
    ld bc, $589c
    call SpriteObject_SetPosition
    ret

    assert @ == $5f8c

UnitReference_CreateScrollArrowsTop3C::
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call SpriteObject_Create
    ld [wUnitReferenceScrollUpSpriteID], a
    ld bc, $583c
    call SpriteObject_SetPosition

    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [wUnitReferenceScrollDownSpriteID], a
    ld bc, $589c
    call SpriteObject_SetPosition
    ret

    assert @ == $5fb7

; Poll the joypad, advance the shared sprite engine, and return the repeat/
; held-button state used by the Unit Reference controllers.
UnitReference_PollInputAndUpdateSprites::
    call Joypad_Update
    call Sprite_Update
    ldh a, [hJoyRepeat]
    ret

    assert @ == $5fc0

; Full-screen 20x18 frame with its interior attribute bytes cleared.
UnitReference_DrawScreenFrame::
    ld bc, $0000
    ld de, $1412
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ret

    assert @ == $5fcb

; Draw the horizontal separator row used below the Unit Reference header.
; BC supplies the left cap coordinate.
UnitReference_DrawDividerRow::
    push bc
    ld a, $0a
    ld de, $0101
    ld h, $ee
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $aa
    pop bc
    push bc
    ld b, $13
    ld de, $0101
    ld h, $ee
    farcall Gfx_DrawSequentialTileRectWithAttributes

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    push bc
    inc b
    call Vram_TilemapCoord
    ld a, $ef
    ld bc, $0012
    call MemsetWaitLCD

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    inc b
    call Vram_TilemapCoord
    ld a, $0a
    ld bc, $0012
    call MemsetWaitLCD
    ret

    assert @ == $600e

; Prepare the common Unit Reference/Unit Status screen assets and frame.  This
; is shared by the type chooser and the later detail/submenu controllers.
UnitReference_SetupScreen::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets

    ldh a, [hVRAMBank]
    push af

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $7587
    ld hl, $8ee0
    ld bc, $0020
    farcall $27, Memcpy

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $5120
    ld hl, $9020
    ld bc, $0010
    farcall $01, Memcpy

    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $5140
    ld hl, $9030
    ld bc, $0010
    farcall $01, Memcpy

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $51c0
    ld hl, $8f10
    ld bc, $0020
    farcall $01, Memcpy

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $5200
    ld hl, $8f00
    ld bc, $0010
    farcall $01, Memcpy

    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $7de8
    ld hl, $8ec0
    ld bc, $0010
    farcall $18, Memcpy

    ld de, $5220
    ld hl, $8ed0
    ld bc, $0010
    farcall $01, Memcpy

    ld de, $51e0
    ld hl, $8eb0
    ld bc, $0010
    farcall $01, Memcpy

    ld de, $51f0
    ld hl, $8ea0
    ld bc, $0010
    farcall $01, Memcpy

    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    call UnitReference_DrawScreenFrame
    ld bc, $0003
    call UnitReference_DrawDividerRow
    ret

    assert @ == $60d8

section "Unit Reference Type Chooser", romx[$60f9], bank[$25]

; Synchronize the upper/lower scroll-arrow visibility with the current
; 13-row viewport over the unit-type list.
UnitReference_UpdateScrollArrowVisibility::
    ld a, [wUnitReferenceScrollOffset]
    cp $00
    jr nz, .show_up
    call UnitReference_HideScrollUpArrow
    jr .update_down
.show_up
    call UnitReference_ShowScrollUpArrow
.update_down
    ld a, [wUnitReferenceScrollOffset]
    inc a
    add a, $0c
    ld c, a
    ld a, $32
    cp c
    jr nc, .show_down
    call UnitReference_HideScrollDownArrow
    jr .done
.show_down
    call UnitReference_ShowScrollDownArrow
.done
    ret

UnitReference_ShowScrollUpArrow::
    ld a, [wUnitReferenceScrollUpSpriteID]
    call SpriteObject_Show
    ret
UnitReference_ShowScrollDownArrow::
    ld a, [wUnitReferenceScrollDownSpriteID]
    call SpriteObject_Show
    ret
UnitReference_HideScrollUpArrow::
    ld a, [wUnitReferenceScrollUpSpriteID]
    call SpriteObject_Hide
    ret
UnitReference_HideScrollDownArrow::
    ld a, [wUnitReferenceScrollDownSpriteID]
    call SpriteObject_Hide
    ret

    assert @ == $6139

; Draw the 13 unit names currently visible in the chooser viewport.
UnitReference_DrawVisibleTypeNames::
    xor a
    ld [wUnitReferenceDrawIndex], a
.loop
    ld a, [wUnitReferenceDrawIndex]
    cp $0d
    jr z, .done

    ld a, [wUnitReferenceScrollOffset]
    inc a
    ld c, a
    ld a, [wUnitReferenceDrawIndex]
    add a, c
    push af

    ld b, $02
    ld a, [wUnitReferenceDrawIndex]
    add a, $04
    ld c, a
    pop af
    call UnitReference_DrawUnitName

    ld a, [wUnitReferenceDrawIndex]
    inc a
    ld [wUnitReferenceDrawIndex], a
    jr .loop
.done
    ret

    assert @ == $6164

UnitReference_InitTypeChooser::
    call UnitReference_SetupScreen
    ld hl, UnitStatus_Header
    ld bc, $0101
    call TextPrint

    ldh a, [hVRAMBank]
    push af
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f98
    call SpriteObject_Create
    ld [wUnitReferenceCursorSpriteID], a
    call UnitReference_UpdateTypeChooserCursorPosition
    call UnitReference_CreateScrollArrowsTop2C
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    call UnitReference_DrawVisibleTypeNames
    call UnitReference_UpdateScrollArrowVisibility
    call VBlankFIFO_Process
    call Sprite_Update
    ret

    assert @ == $619a

UnitReference_UpdateTypeChooserCursorPosition::
    ld a, [wUnitReferenceCursorRow]
    ld b, $08
    call MultiplyAByB
    ld a, l
    add a, $34
    ld c, a
    ld b, $12
    ld a, [wUnitReferenceCursorSpriteID]
    call SpriteObject_SetPosition
    ret

    assert @ == $61af

; Convert the viewport origin + selected row to the one-based unit type used by
; UnitData.  Type 0 is not part of the chooser list.
UnitReference_GetSelectedType::
    ld a, [wUnitReferenceScrollOffset]
    ld c, a
    ld a, [wUnitReferenceCursorRow]
    add a, c
    inc a
    ret

    assert @ == $61b9

; Interactive Unit Reference type chooser.  Returns A = selected one-based
; unit type, or $FF when cancelled with B.
UnitReference_ChooseType::
    ldh a, [hWRAMBank]
    push af
    ld a, $03
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    call UnitReference_InitTypeChooser
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    call UnitReference_HandleUp
    jr .continue
.check_down
    bit 7, a
    jr z, .check_page_up
    call UnitReference_HandleDown
    jr .continue
.check_page_up
    bit 5, a
    jr z, .check_page_down
    call UnitReference_HandlePageUp
    jr .continue
.check_page_down
    bit 4, a
    jr z, .check_confirm
    call UnitReference_HandlePageDown
    jr .continue
.check_confirm
    bit 0, a
    jr z, .check_cancel
    ld a, $02
    call Audio_PlaySFX
    call UnitReference_GetSelectedType
    jr .finish
.check_cancel
    bit 1, a
    jr z, .continue
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .finish
.continue
    jr .loop
.finish
    push af
    call FadeToWhite8
    call SpriteObject_DestroyAll
    pop af
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ret

    assert @ == $621c

UnitReference_HandleUp::
    ld a, [wUnitReferenceCursorRow]
    dec a
    cp $ff
    jr nz, .moved
    call UnitReference_ScrollUpOne
    xor a
    jr .store
.moved
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
.store
    ld [wUnitReferenceCursorRow], a
    call UnitReference_UpdateTypeChooserCursorPosition
    ret

    assert @ == $6238

UnitReference_HandleDown::
    ld a, [wUnitReferenceCursorRow]
    inc a
    cp $0d
    jr nz, .moved
    call UnitReference_ScrollDownOne
    ld a, $0c
    jr .store
.moved
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
.store
    ld [wUnitReferenceCursorRow], a
    call UnitReference_UpdateTypeChooserCursorPosition
    ret

    assert @ == $6255

UnitReference_HandlePageUp::
    ld a, [wUnitReferenceScrollOffset]
    sub $0d
    jr nc, .moved
    xor a
    jr .store
.moved
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
.store
    ld [wUnitReferenceScrollOffset], a
    call UnitReference_DrawVisibleTypeNames
    call UnitReference_UpdateScrollArrowVisibility
    ret

    assert @ == $6270

UnitReference_HandlePageDown::
    ld a, [wUnitReferenceScrollOffset]
    add a, $0d
    ld c, a
    ld a, $26
    cp c
    jr nc, .moved
    ld a, $26
    jr .store
.moved
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [wUnitReferenceScrollOffset]
    add a, $0d
.store
    ld [wUnitReferenceScrollOffset], a
    call UnitReference_DrawVisibleTypeNames
    call UnitReference_UpdateScrollArrowVisibility
    ret

    assert @ == $6295

; Scroll one item upward when the cursor tries to move above the first visible
; row.  At the beginning of the list this becomes a no-op.
UnitReference_ScrollUpOne::
    ld a, [wUnitReferenceScrollOffset]
    dec a
    cp $ff
    jr nz, .moved
    xor a
    jr .store
.moved
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
.store
    ld [wUnitReferenceScrollOffset], a
    call UnitReference_DrawVisibleTypeNames
    call UnitReference_UpdateScrollArrowVisibility
    ret

    assert @ == $62b1

; Scroll one item downward while keeping the final 13-row viewport clamped at
; offset $26 (unit types $27-$33).
UnitReference_ScrollDownOne::
    ld a, [wUnitReferenceScrollOffset]
    inc a
    add a, $0c
    ld c, a
    ld a, $32
    cp c
    jr nc, .moved
    ld a, $26
    jr .store
.moved
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [wUnitReferenceScrollOffset]
    inc a
.store
    ld [wUnitReferenceScrollOffset], a
    call UnitReference_DrawVisibleTypeNames
    call UnitReference_UpdateScrollArrowVisibility
    ret

    assert @ == $62d6
