include "macros/macros.inc"

; Top-level five-row main-menu presentation. The localized description pointer
; table remains in engine/ui/main_menu.asm immediately after this runtime.
section "Main Menu Runtime", romx[$54bb], bank[$15]
MainMenu_Runtime::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    ld a, $02
    ld [$c62a], a
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    farcall Gfx_LoadCommonScreenAssets

    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $5640
    ld hl, $9000
    ld bc, $0650
    call Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld a, $00
    ld b, $08
    ld hl, $5c90
    call Vram_SetPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals

    ld a, $0a
    ld bc, $0501
    ld de, $0a02
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0503
    ld de, $0a02
    ld h, $15
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0505
    ld de, $0a02
    ld h, $29
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0507
    ld de, $0a02
    ld h, $3d
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0509
    ld de, $0a02
    ld h, $51
    farcall Gfx_DrawSequentialTileRectWithAttributes

    ld bc, $010c
    ld de, $1205
    farcall UIWindow_DrawFrameAndClearInteriorAttributes

    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f6e
    call SpriteObject_Create
    ld [$cc9c], a
    call MainMenu_UpdateCursor
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld a, $02
    call Audio_PlayMusic
    ret

MainMenu_UpdateCursor::
    ld a, [$c62a]
    ld b, $10
    call MultiplyAByB
    ld a, l
    add $20
    ld c, a
    ld b, $30
    ld a, [$cc9c]
    call SpriteObject_SetPosition
    call MainMenu_DrawDescription
    ret

MainMenu_DestroyCursorSprites::
    call SpriteObject_DestroyAll
    ret

MainMenu_DrawDescription::
    ldh a, [hVRAMBank]
    push af
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $020d
    ld de, $1003
    farcall Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld a, [$c62a]
    add a
    ld hl, MainMenu_Desc
    call AddAtoHL
    ld a, [hl+]
    ld b, a
    ld a, [hl]
    ld c, a
    ld h, c
    ld l, b
    ld bc, $020d
    call TextPrint
    ret

    assert @ == $55d2
