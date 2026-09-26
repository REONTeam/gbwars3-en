include "macros/macros.inc"

; Shared Bank-$1A background loader family. The descriptor format and the
; $42AF loader were previously proven by the Campaign-ending source. The two
; earlier entries at $405B/$4185 are exact duplicate variants that place the
; same descriptor rectangle at tilemap X=4 rather than X=0.

DEF wCampaignBackgroundPaletteVariant EQU $c4a4
DEF wCampaignBackgroundID             EQU $c4a5
DEF wCampaignBackgroundGraphicsPointer EQU $d2fe
DEF wCampaignBackgroundTilemapPointer  EQU $d300
DEF wCampaignBackgroundAttrmapPointer  EQU $d302
DEF wCampaignBackgroundPalette0Pointer EQU $d304
DEF wCampaignBackgroundPalette1Pointer EQU $d306
DEF wCampaignBackgroundPalette2Pointer EQU $d308
DEF wCampaignBackgroundGraphicsSize    EQU $d30a
DEF wCampaignBackgroundBank            EQU $d30c
DEF wCampaignBackgroundWidth           EQU $d30d
DEF wCampaignBackgroundHeight          EQU $d30e

DEF CAMPAIGN_BACKGROUND_DESCRIPTOR_COUNT EQU 28

MACRO campaign_background
    dw \1 ; graphics pointer
    SHIFT
    dw \1 ; tilemap pointer
    SHIFT
    dw \1 ; attribute-map pointer
    SHIFT
    dw \1 ; BG palette pointer, variant 0
    SHIFT
    dw \1 ; BG palette pointer, variant 1
    SHIFT
    dw \1 ; BG palette pointer, variant 2
    SHIFT
    dw \1 ; graphics byte count
    SHIFT
    db \1 ; source ROM bank
    SHIFT
    db \1 ; tilemap width
    SHIFT
    db \1 ; tilemap height
ENDM

MACRO campaign_background_loader_body
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    push af
    ld a, b
    ld [wCampaignBackgroundPaletteVariant], a
    pop af
    ld [wCampaignBackgroundID], a
    ld c, a
    call CampaignBackground_CopyDescriptor
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [wCampaignBackgroundGraphicsPointer]
    ld e, a
    ld a, [wCampaignBackgroundGraphicsPointer + 1]
    ld d, a
    ld a, [wCampaignBackgroundGraphicsSize]
    ld c, a
    ld a, [wCampaignBackgroundGraphicsSize + 1]
    ld b, a
    push de
    push bc
    ld de, $0800
    ld h, b
    ld l, c
    call Math_CompareHLToDE
    jr c, .split_graphics\@
    jr .copy_first_graphics_block\@
.split_graphics\@
    ld de, $0800
    ld a, [wCampaignBackgroundGraphicsSize]
    ld l, a
    ld a, [wCampaignBackgroundGraphicsSize + 1]
    ld h, a
    call Math_SubtractDEFromHL
    push hl
    ld hl, $0800
    ld a, [wCampaignBackgroundGraphicsPointer]
    ld c, a
    ld a, [wCampaignBackgroundGraphicsPointer + 1]
    ld b, a
    add hl, bc
    ld d, h
    ld e, l
    pop hl
    ld b, h
    ld c, l
    ld hl, $8800
    ld a, [wCampaignBackgroundBank]
    ld [wFarCopySourceBank], a
    call FarCopy_ToVRAM
    pop bc
    pop de
    ld bc, $0800
    ld hl, $9000
    ld a, [wCampaignBackgroundBank]
    ld [wFarCopySourceBank], a
    call FarCopy_ToVRAM
    jr .load_palette\@
.copy_first_graphics_block\@
    pop bc
    pop de
    ld hl, $9000
    ld a, [wCampaignBackgroundBank]
    ld [wFarCopySourceBank], a
    call FarCopy_ToVRAM
.load_palette\@
    ; Preserve the retail dead read before the real palette selector.
    ld a, [wSpritePaletteVariant]
    ld a, [wCampaignBackgroundPaletteVariant]
    cp $00
    jr z, .palette0\@
    cp $01
    jr z, .palette1\@
    cp $02
    jr z, .palette2\@
.palette0\@
    ld a, [wCampaignBackgroundPalette0Pointer + 1]
    ld h, a
    ld a, [wCampaignBackgroundPalette0Pointer]
    ld l, a
    jr .apply_palette\@
.palette1\@
    ld a, [wCampaignBackgroundPalette1Pointer + 1]
    ld h, a
    ld a, [wCampaignBackgroundPalette1Pointer]
    ld l, a
    jr .apply_palette\@
.palette2\@
    ld a, [wCampaignBackgroundPalette2Pointer + 1]
    ld h, a
    ld a, [wCampaignBackgroundPalette2Pointer]
    ld l, a
.apply_palette\@
    ld a, [wCampaignBackgroundBank]
    ld c, a
    ld a, $00
    ld b, $08
    call Vram_SetFarPals
    call Vram_ApplyPals
    ldh a, [hVRAMBank]
    push af
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [wCampaignBackgroundID]
    ld c, a
    ld b, $00
    ld hl, CampaignBackgroundDefaultAttributes
    add hl, bc
    ld a, [hl]
    ld bc, $0000
    ld de, $2020
    farcall $15, Gfx_TilemapFill
    pop af
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld [$cc52], a
    IF \1 == 4
        ld [$cc5c], a
        ld a, $04
        ld [$cc53], a
    ELSE
        ld [$cc53], a
        ld [$cc5c], a
    ENDC
    ld a, [wCampaignBackgroundWidth]
    ld [$cc56], a
    ld a, [wCampaignBackgroundHeight]
    ld [$cc57], a
    ld a, [wCampaignBackgroundTilemapPointer + 1]
    ld [$cc58], a
    ld a, [wCampaignBackgroundTilemapPointer]
    ld [$cc59], a
    ld a, [wCampaignBackgroundBank]
    ld [$cc61], a
    ld [$cc62], a
    ld a, [wCampaignBackgroundAttrmapPointer + 1]
    ld [$cc5a], a
    ld a, [wCampaignBackgroundAttrmapPointer]
    ld [$cc5b], a
    call $36c4
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
ENDM

section "Campaign Background Inset Loader A", romx[$405b], bank[$1a]
CampaignBackground_LoadInset4::
    campaign_background_loader_body 4
    assert @ == $4185

section "Campaign Background Inset Loader B", romx[$4185], bank[$1a]
CampaignBackground_LoadInset4Duplicate::
    campaign_background_loader_body 4
    assert @ == $42af

section "Campaign Background Loader", romx[$42af], bank[$1a]
CampaignBackground_Load::
    campaign_background_loader_body 0
    assert @ == $43d7

section "Campaign Background Descriptor Copy", romx[$44c6], bank[$1a]
CampaignBackground_CopyDescriptor::
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, d
    ld b, $11
    call MultiplyAByB
    ld bc, CampaignBackgroundDefinitions
    add hl, bc
    ld d, h
    ld e, l
    ld hl, wCampaignBackgroundGraphicsPointer
    ld bc, $0011
    call Memcpy
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
    assert @ == $44eb

section "Campaign Background Definitions", romx[$63e8], bank[$1a]
CampaignBackgroundDefinitions::
    campaign_background $4190, $4000, $40c8, $46f0, $4730, $4770, $0560, $1b, $14, $0a
    campaign_background $4940, $47b0, $4878, $4ef0, $4f30, $4f70, $05b0, $1b, $14, $0a
    campaign_background $5140, $4fb0, $5078, $5420, $5460, $54a0, $02e0, $1b, $14, $0a
    campaign_background $5670, $54e0, $55a8, $5c90, $5cd0, $5d10, $0620, $1b, $14, $0a
    campaign_background $5ee0, $5d50, $5e18, $6400, $6440, $6480, $0520, $1b, $14, $0a
    campaign_background $6650, $64c0, $6588, $6bf0, $6c30, $6c70, $05a0, $1b, $14, $0a
    campaign_background $74d0, $7340, $7408, $77e0, $77e0, $77e0, $0310, $1b, $14, $0a
    campaign_background $79b0, $7820, $78e8, $7b70, $7b70, $7b70, $01c0, $1b, $14, $0a
    campaign_background $6e40, $6cb0, $6d78, $7280, $72c0, $7300, $0440, $1b, $14, $0a
    campaign_background $4190, $4000, $40c8, $4490, $4490, $4490, $0300, $1c, $14, $0a
    campaign_background $4750, $44d0, $4610, $4930, $4930, $4930, $01e0, $1c, $20, $0a
    campaign_background $50f0, $4f60, $5028, $54f0, $5530, $54f0, $0400, $1c, $14, $0a
    campaign_background $5700, $5570, $5638, $5b30, $5b70, $5b30, $0430, $1c, $14, $0a
    campaign_background $5e30, $5bb0, $5cf0, $6770, $67b0, $6770, $0940, $1c, $20, $0a
    campaign_background $6980, $67f0, $68b8, $6ca0, $6ce0, $6ca0, $0320, $1c, $14, $0a
    campaign_background $6fa0, $6d20, $6e60, $73e0, $7420, $73e0, $0440, $1c, $20, $0a
    campaign_background $4bf0, $4970, $4ab0, $4f20, $4f20, $4f20, $0330, $1c, $20, $0a
    campaign_background $77cb, $763b, $7703, $7d8b, $7dcb, $7dcb, $05c0, $1c, $14, $0a
    campaign_background $7792, $7602, $76ca, $7d52, $7d92, $7d92, $05c0, $1f, $14, $0a
    campaign_background $6cab, $6a2b, $6b6b, $6f7b, $6f7b, $6f7b, $02d0, $1a, $20, $0a
    campaign_background $5e76, $59f6, $5c36, $6106, $6106, $6106, $0290, $21, $20, $12
    campaign_background $6416, $6146, $62ae, $66a6, $66a6, $66a6, $0290, $21, $14, $12
    campaign_background $69b6, $66e6, $684e, $6c16, $6c16, $6c16, $0260, $21, $14, $12
    campaign_background $70d6, $6c56, $6e96, $73e6, $73e6, $73e6, $0310, $21, $20, $12
    campaign_background $76f6, $7426, $758e, $7a06, $7a06, $7a06, $0310, $21, $14, $12
    campaign_background $4480, $4000, $4240, $4b30, $4b30, $4b30, $06b0, $22, $20, $12
    campaign_background $5070, $4b70, $4df0, $5ba0, $5ba0, $5ba0, $0b30, $22, $14, $20
    campaign_background $4735, $4465, $45cd, $5155, $5155, $5155, $0a20, $27, $14, $12
    assert @ == $65c4

CampaignBackgroundDefaultAttributes::
    db $86, $86, $86, $84, $86, $86, $83, $83
    db $86, $82, $82, $86, $86, $86, $81, $86
    db $83, $86, $86, $84
    assert @ == $65d8
