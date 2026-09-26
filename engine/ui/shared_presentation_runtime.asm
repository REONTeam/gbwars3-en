include "macros/macros.inc"

; Shared presentation helpers used by Campaign ending scenes and map-result
; presentations. These are intentionally scene-agnostic: the same wait/reset
; helpers are reused across multiple Bank $1A presentation sequences.

DEF wPresentationPalette0Pointer EQU $d304
DEF wPresentationPalette1Pointer EQU $d306
DEF wPresentationPalette2Pointer EQU $d308
DEF wPresentationSourceBank      EQU $d30c

section "Shared Presentation Palette Apply", romx[$4000], bank[$27]

; A selects one of the three staged background palette pointers (0/1/2).
; Applies eight BG palettes from the descriptor's source bank.
Presentation_ApplyBackgroundPalette::
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    cp $00
    jr z, .palette0
    cp $01
    jr z, .palette1
    cp $02
    jr z, .palette2
.palette0
    ld a, [wPresentationPalette0Pointer + 1]
    ld h, a
    ld a, [wPresentationPalette0Pointer]
    ld l, a
    jr .apply
.palette1
    ld a, [wPresentationPalette1Pointer + 1]
    ld h, a
    ld a, [wPresentationPalette1Pointer]
    ld l, a
    jr .apply
.palette2
    ld a, [wPresentationPalette2Pointer + 1]
    ld h, a
    ld a, [wPresentationPalette2Pointer]
    ld l, a
.apply
    ld a, [wPresentationSourceBank]
    ld c, a
    ld a, $00
    ld b, $08
    call Vram_SetFarPals
    call Vram_ApplyPals
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

    assert @ == $4047

section "Shared Presentation Wait With Cancel", romx[$4047], bank[$27]

; Wait DE frames while polling input, rebuilding sprites, updating spawn-first
; advanced sprites, and applying B/C to SCX/SCY. A/B/Start returns carry set;
; timeout returns carry clear.
Presentation_WaitFramesOrCancel::
    push hl
    ld hl, $0000
.loop
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    farcall $17, AdvancedSprite_UpdateSpawnFirst
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr nz, .check_input
    xor a
    jr .done
.check_input
    ldh a, [hJoyPressed]
    bit 0, a
    jr nz, .cancel
    bit 1, a
    jr nz, .cancel
    bit 3, a
    jr nz, .cancel
    jr .advance
.cancel
    xor a
    scf
    jr .done
.advance
    ldh a, [hSCX]
    add b
    ldh [hSCX], a
    ldh a, [hSCY]
    add c
    ldh [hSCY], a
    inc hl
    jr .loop
.done
    pop hl
    ret

    assert @ == $4086

section "Shared Presentation Wait", romx[$4086], bank[$27]

; Same frame/update loop as Presentation_WaitFramesOrCancel, without input
; cancellation.
Presentation_WaitFrames::
    push hl
    ld hl, $0000
.loop
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    farcall $17, AdvancedSprite_UpdateSpawnFirst
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr nz, .advance
    jr .done
.advance
    ldh a, [hSCX]
    add b
    ldh [hSCX], a
    ldh a, [hSCY]
    add c
    ldh [hSCY], a
    inc hl
    jr .loop
.done
    pop hl
    ret

    assert @ == $40b0

section "Shared Presentation Frame Services", romx[$40b0], bank[$27]

; Run the shared presentation frame services for DE frames. The middle service updates the two staged battle-place palette animations; the
; surrounding calls are the normal advanced-sprite updater and the proven
; screen-shake helper.
Presentation_RunFrameServices::
    ld hl, $0000
.loop
    push hl
    push de
    call Joypad_Update
    call Sprite_Update
    farcall $17, AdvancedSprite_Update
    farcall $17, BattlePlace_UpdatePaletteAnimations
    farcall $17, AdvancedSprite_ChooseScrollDelta
    pop de
    pop hl
    inc hl
    call Math_CompareHLToDE
    jr nz, .continue
    jr .done
.continue
    jr .loop
.done
    ret

    assert @ == $40d4

section "Shared Presentation Display Reset", romx[$40d4], bank[$27]

; Common presentation reset recovered from the earlier Campaign-ending source:
; disable LCD, clear the VBlank queue, reset all sprite/OAM state and scroll,
; then clear both BG tilemap banks.
Presentation_ResetDisplayState::
CampaignEnding_ResetDisplayState:: ; compatibility alias
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    call Vram_ClearBGTilemapBothBanks
    ret

    assert @ == $40e6
