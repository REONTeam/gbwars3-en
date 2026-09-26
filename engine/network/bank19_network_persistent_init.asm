include "macros/macros.inc"

; Structural dependencies whose exact higher-level identities remain unproven.
DEF Bank31_NetworkPersistentPostInit EQU $71e4
DEF Bank10_NetworkUIRuntime_6A09 EQU $6a09
DEF Bank15_NetworkUIRuntime_6AD3 EQU $6ad3
DEF Bank22_NetworkUIRuntime_64B8 EQU $64b8

section "Bank19 Network Persistent Init", romx[$7059], bank[$19]

; Reset the persistent Mobile/Network registration state in SRAM bank $0E,
; initialize its WRAM mirrors, then run the connected Bank $31 post-init hook.
NetworkPersistent_ResetAndInitialize::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable

    ld hl, $a01a
    ld bc, $011e
    xor a
    call Memset

    ld a, $ff
    ld [$a062], a
    ld [$a064], a
    xor a
    ld [$a106], a
    xor a
    ld [$ba79], a

    ld hl, $a138
    ld bc, $1900
    xor a
    call Memset

    xor a
    ld [$ba38], a
    ld [$ba39], a

    ld hl, $ba7a
    ld bc, $0010
    xor a
    call Memset
    ld hl, $ba8a
    ld bc, $00b4
    xor a
    call Memset

    ld a, $ff
    ld [$bb3f], a
    ld [$bb3e], a
    ld [$bb40], a
    ld [$bb41], a

    ld hl, $bb42
    ld bc, $0005
    xor a
    call Memset
    ld hl, $bb47
    ld bc, $0005
    xor a
    call Memset
    ld hl, $bb4c
    ld bc, $0005
    xor a
    call Memset
    ld hl, $bb51
    ld bc, $0005
    xor a
    call Memset
    ld hl, $bb56
    ld bc, $0005
    xor a
    call Memset

    ld a, $01
    ld [$ba3a], a
    ld [$bb5b], a
    xor a
    ld [$ba3b], a
    xor a
    ld [$bb5c], a
    ld [$bb5d], a
    ld [$bb5e], a
    ld [$bb5f], a
    ld [$ba3c], a
    ld [$ba3d], a
    ld [$ba40], a
    ld [$ba41], a
    ld [$ba3e], a
    ld [$ba3f], a
    ld [$ba42], a
    ld [$ba43], a

    ld hl, $ba44
    ld bc, $0020
    call Memset

    call SRAM_Disable
    farcall $31, Bank31_NetworkPersistentPostInit

    ldh a, [hWRAMBank]
    push af
    ld a, $07
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld [$cc25], a
    ld [$cc26], a
    ld hl, $cab3
    ld bc, $0011
    ld a, $00
    call Memset
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret

assert @ == $7142

section "Bank19 Network Bootstrap And Mobile Menu", romx[$7142], bank[$19]

; Copy the 0x140-byte bootstrap resource from Bank $15 into VRAM bank 1.
NetworkUI_CopyBootstrapResource::
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $5b50
    ld hl, $9150
    ld bc, $0140
    farcall $15, Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret

; Initialize the Mobile Menu background, common UI assets, tile payload and
; eight BG palettes. The copied tile span intentionally starts at the blank
; leading tile below and continues into the separately owned menu graphic.
NetworkUI_InitializeMobileMenu::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    farcall $10, UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call $0f02
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall $15, Gfx_LoadCommonScreenAssets

    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, Image_Mobile_Menu_LeadingTile
    ld hl, $9000
    ld bc, $06b0
    call Memcpy
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld a, $00
    ld b, $08
    ld hl, $78ec
    call Vram_SetPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals
    ret

; Draw the two fixed Mobile Menu panels and their interior presentation layer.
; Exact low-level provider identities are intentionally kept structural.
NetworkUI_DrawMobileMenuPanels::
    farcall $22, Bank22_NetworkUIRuntime_64B8
    ld bc, $0101
    ld de, $1204
    farcall $10, Bank10_NetworkUIRuntime_6A09

    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0202
    ld de, $1002
    farcall $15, Bank15_NetworkUIRuntime_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld bc, $0106
    ld de, $120b
    farcall $10, Bank10_NetworkUIRuntime_6A09

    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0207
    ld de, $1009
    farcall $15, Bank15_NetworkUIRuntime_6AD3
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ret

Image_Mobile_Menu_LeadingTile::
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00

assert @ == $720c
