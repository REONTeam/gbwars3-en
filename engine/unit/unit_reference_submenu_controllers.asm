include "macros/macros.inc"

; Interactive controller layer for the nine Unit Reference detail subpages.
; Each entry owns only the input/navigation loop; the page-specific renderers
; and data providers remain separate until their contracts are proven.

DEF wUnitReferenceCurrentType             EQU $d9ba
DEF wUnitReferenceWeaponSlot              EQU $d9bf
DEF wUnitReferencePromotedType            EQU $d9c8
DEF wUnitReferenceSubmenuScrollOffset     EQU $da40
DEF wUnitReferenceSubmenuItemCount        EQU $da42
DEF wUnitReferenceSubmenuVisibleRows      EQU $da43
DEF wUnitReferenceTerrainPage             EQU $d9cb
DEF wUnitReferenceTerrainColumn           EQU $d9cc
DEF wUnitReferenceTerrainRow              EQU $d9cd
DEF wUnitReferenceListItemCount           EQU $d9b3
DEF wUnitReferenceListScrollOffset        EQU $d9b6

section "Unit Reference Description Submenu Controller", romx[$6aec], bank[$25]

UnitReference_RunDescriptionSubmenu::
    call UnitReference_DrawSubmenuBaseAndCosts
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    call .scroll_up
    jr .continue
.check_down
    bit 7, a
    jr z, .check_back
    call .scroll_down
    jr .continue
.check_back
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
    ret
.scroll_up
    ld a, [wUnitReferenceSubmenuScrollOffset]
    dec a
    cp $ff
    jr nz, .store_up
    jr .up_done
.store_up
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [wUnitReferenceSubmenuScrollOffset], a
    ld a, [wUnitReferenceCurrentType]
    farcall $32, Description_DrawUnitText
    call UnitReference_UpdateSubmenuScrollArrows
.up_done
    ret
.scroll_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    cp c
    jr z, .down_done
    jr c, .down_done
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
    ld c, a
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld d, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub d
    cp c
    jr nc, .advance_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub c
    jr .store_down
.advance_down
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
.store_down
    ld [wUnitReferenceSubmenuScrollOffset], a
    ld a, [wUnitReferenceCurrentType]
    farcall $32, Description_DrawUnitText
    call UnitReference_UpdateSubmenuScrollArrows
.down_done
    ret

    assert @ == $6b7d

section "Unit Reference Movement Submenu Controller", romx[$6f83], bank[$25]

UnitReference_RunMovementSubmenu::
    call UnitReference_DrawMovementSubmenu
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    call .move_up
    jr .continue
.check_down
    bit 7, a
    jr z, .check_left
    call .move_down
    jr .continue
.check_left
    bit 5, a
    jr z, .check_right
    call .move_left
    jr .continue
.check_right
    bit 4, a
    jr z, .check_open_detail
    call .move_right
    jr .continue
.check_open_detail
    bit 0, a
    jr z, .check_back
    ld a, $02
    call Audio_PlaySFX
    call .open_detail
    jr .loop
.check_back
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
    ret
.open_detail
    call UnitReference_UpdateMovementTerrainSelection
    call UnitReference_UpdateMovementGridSelection
    call FadeToWhite8
    call UnitReference_OpenSelectedTerrainDetail
    call UnitReference_DrawMovementSubmenu
    call FadeFromWhite8
    ret
.move_up
    ld a, [wUnitReferenceTerrainRow]
    dec a
    cp $ff
    jr nz, .store_up
    ld a, [wUnitReferenceTerrainPage]
    cp $00
    ret z
    ld a, $00
    ld [wUnitReferenceTerrainPage], a
    call UnitReference_DrawMovementTerrainGrid
    call $352e
    call UnitReference_UpdateMovementPageArrows
    ret
.store_up
    ld [wUnitReferenceTerrainRow], a
    call UnitReference_UpdateMovementCursorPosition
    ld a, $01
    call Audio_PlaySFX
    ret
.move_down
    ld a, [wUnitReferenceTerrainRow]
    inc a
    cp $06
    jr nz, .store_down
    ld a, [wUnitReferenceTerrainPage]
    cp $03
    ret z
    ld a, $03
    ld [wUnitReferenceTerrainPage], a
    call UnitReference_DrawMovementTerrainGrid
    call $352e
    call UnitReference_UpdateMovementPageArrows
    ret
.store_down
    ld [wUnitReferenceTerrainRow], a
    call UnitReference_UpdateMovementCursorPosition
    ld a, $01
    call Audio_PlaySFX
    ret
.move_left
    ld a, [wUnitReferenceTerrainColumn]
    dec a
    cp $ff
    ret z
    ld [wUnitReferenceTerrainColumn], a
    call UnitReference_UpdateMovementCursorPosition
    ld a, $01
    call Audio_PlaySFX
    ret
.move_right
    ld a, [wUnitReferenceTerrainColumn]
    inc a
    cp $03
    ret z
    ld [wUnitReferenceTerrainColumn], a
    call UnitReference_UpdateMovementCursorPosition
    ld a, $01
    call Audio_PlaySFX
    ret

    assert @ == $7061

section "Unit Reference Upkeep Submenu Controller", romx[$733b], bank[$25]

UnitReference_RunUpkeepSubmenu::
    call UnitReference_DrawUpkeepSubmenu
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    call .scroll_up
    jr .continue
.check_down
    bit 7, a
    jr z, .check_back
    call .scroll_down
    jr .continue
.check_back
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
    ret
.scroll_up
    ld a, [wUnitReferenceSubmenuScrollOffset]
    dec a
    cp $ff
    jr nz, .store_up
    jr .up_done
.store_up
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [wUnitReferenceSubmenuScrollOffset], a
    farcall $32, Description_DrawGasExplanation
    call UnitReference_UpdateSubmenuScrollArrows
.up_done
    ret
.scroll_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    cp c
    jr z, .down_done
    jr c, .down_done
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
    ld c, a
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld d, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub d
    cp c
    jr nc, .advance_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub c
    jr .store_down
.advance_down
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
.store_down
    ld [wUnitReferenceSubmenuScrollOffset], a
    farcall $32, Description_DrawGasExplanation
    call UnitReference_UpdateSubmenuScrollArrows
.down_done
    ret

    assert @ == $73c6

section "Unit Reference Weapon Submenu Controller", romx[$7509], bank[$25]

; A = weapon slot (0 or 1).
UnitReference_RunWeaponSubmenu::
    ld [wUnitReferenceWeaponSlot], a
    call UnitReference_DrawWeaponSubmenu
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
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
    ret

    assert @ == $752d

section "Unit Reference Initiative Submenu Controller", romx[$759a], bank[$25]

UnitReference_RunInitiativeSubmenu::
    call UnitReference_DrawInitiativeSubmenu
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    call .scroll_up
    jr .continue
.check_down
    bit 7, a
    jr z, .check_back
    call .scroll_down
    jr .continue
.check_back
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
    ret
.scroll_up
    ld a, [wUnitReferenceSubmenuScrollOffset]
    dec a
    cp $ff
    jr nz, .store_up
    jr .up_done
.store_up
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [wUnitReferenceSubmenuScrollOffset], a
    farcall $32, Description_DrawInitiativeExplanation
    call UnitReference_UpdateSubmenuScrollArrows
.up_done
    ret
.scroll_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    cp c
    jr z, .down_done
    jr c, .down_done
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
    ld c, a
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld d, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub d
    cp c
    jr nc, .advance_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub c
    jr .store_down
.advance_down
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
.store_down
    ld [wUnitReferenceSubmenuScrollOffset], a
    farcall $32, Description_DrawInitiativeExplanation
    call UnitReference_UpdateSubmenuScrollArrows
.down_done
    ret

    assert @ == $7625

section "Unit Reference Load Submenu Controller", romx[$779e], bank[$25]

UnitReference_RunLoadSubmenu::
    call UnitReference_DrawLoadSubmenu
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    call .scroll_up
    jr .continue
.check_down
    bit 7, a
    jr z, .check_back
    call .scroll_down
    jr .continue
.check_back
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
    ret
.scroll_up
    ld a, [wUnitReferenceListScrollOffset]
    dec a
    cp $ff
    jr nz, .store_up
    xor a
    jr .redraw_up
.store_up
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
.redraw_up
    ld [wUnitReferenceListScrollOffset], a
    call UnitReference_LoadProvider_7670
    call UnitReference_LoadProvider_7702
    ret
.scroll_down
    ld a, [wUnitReferenceListItemCount]
    cp $06
    jr c, .down_done
    ld a, [wUnitReferenceListScrollOffset]
    inc a
    push af
    ld a, [wUnitReferenceListItemCount]
    ld c, a
    sub $06
    ld c, a
    pop af
    cp c
    jr c, .advance_down
    ld a, [wUnitReferenceListItemCount]
    sub $06
    jr .store_down
.advance_down
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
.store_down
    ld [wUnitReferenceListScrollOffset], a
    call UnitReference_LoadProvider_7670
    call UnitReference_LoadProvider_7702
.down_done
    ret

    assert @ == $781c

section "Unit Reference Promotion Submenu Controller", romx[$7879], bank[$25]

UnitReference_RunPromotionSubmenu::
    call UnitReference_DrawPromotionSubmenu
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    call .scroll_up
    jr .continue
.check_down
    bit 7, a
    jr z, .check_select
    call .scroll_down
    jr .continue
.check_select
    bit 0, a
    jr z, .check_back
    ld a, $02
    call Audio_PlaySFX
    ld a, [wUnitReferencePromotedType]
    ld [wUnitReferenceCurrentType], a
    ld a, $ff
    jr .finish
.check_back
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
    ret
.scroll_up
    ld a, [wUnitReferenceSubmenuScrollOffset]
    dec a
    cp $ff
    jr nz, .store_up
    jr .up_done
.store_up
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [wUnitReferenceSubmenuScrollOffset], a
    farcall $32, Description_DrawPromotionExplanation
    call UnitReference_UpdateSubmenuScrollArrows
.up_done
    ret
.scroll_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    cp c
    jr z, .down_done
    jr c, .down_done
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
    ld c, a
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld d, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub d
    cp c
    jr nc, .advance_down
    ld a, [wUnitReferenceSubmenuVisibleRows]
    ld c, a
    ld a, [wUnitReferenceSubmenuItemCount]
    sub c
    jr .store_down
.advance_down
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [wUnitReferenceSubmenuScrollOffset]
    inc a
.store_down
    ld [wUnitReferenceSubmenuScrollOffset], a
    farcall $32, Description_DrawPromotionExplanation
    call UnitReference_UpdateSubmenuScrollArrows
.down_done
    ret

    assert @ == $7917

section "Unit Reference Defense Submenu Controller", romx[$79f8], bank[$25]

UnitReference_RunDefenseSubmenu::
    call UnitReference_DrawDefenseSubmenu
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
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
    ret

    assert @ == $7a19

section "Unit Reference Resupply Repair Submenu Controller", romx[$7f7a], bank[$25]

UnitReference_RunResupplyRepairSubmenu::
    call UnitReference_DrawResupplyRepairSubmenu
    call FadeFromWhite8
.loop
    call UnitReference_PollInputAndUpdateSprites
    bit 6, a
    jr z, .check_down
    call .scroll_up
    jr .continue
.check_down
    bit 7, a
    jr z, .check_back
    call .scroll_down
    jr .continue
.check_back
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
    ret
.scroll_up
    ld a, [wUnitReferenceListScrollOffset]
    dec a
    cp $ff
    ret z
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [wUnitReferenceListScrollOffset], a
    call UnitReference_ResupplyRepairProvider_7C11
    call UnitReference_ResupplyRepairProvider_7DB4
    ret
.scroll_down
    ld a, [wUnitReferenceListItemCount]
    cp $06
    jr c, .done
    ld a, [wUnitReferenceListScrollOffset]
    inc a
    ld c, a
    push bc
    ld a, [wUnitReferenceListItemCount]
    sub $06
    pop bc
    cp c
    jr nc, .advance
    ret
.advance
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [wUnitReferenceListScrollOffset]
    inc a
    ld [wUnitReferenceListScrollOffset], a
    call UnitReference_ResupplyRepairProvider_7C11
    call UnitReference_ResupplyRepairProvider_7DB4
.done
    ret

    assert @ == $7ff1
