include "macros/macros.inc"

; Bank $25 map briefing/message viewer. This controller is shared by Beginner
; instructional briefings and Campaign pre/post-map messages. The $C61A-$C622
; aliases are valid only while this viewer is active.

section "Map Briefing Runtime A", romx[$48ad], bank[$25]
MapBriefing_OpenInGame::
    ld [wMapBriefingMapIndex], a
    ld a, b
    ld [wMapBriefingGroup], a
    call MapBriefing_CheckAvailable
    ret nc
    ld a, $ff
    jr $48c8
MapBriefing_OpenModal::
    ld [wMapBriefingMapIndex], a
    ld a, b
    ld [wMapBriefingGroup], a
    call MapBriefing_CheckAvailable
    ret nc
    xor a
    ld [wMapBriefingDisplayVariant], a
    call LCD_Disable
    call $34ce
    call $2d7c
    call MapBriefing_SetupScreen
    call UnitStatus_DrawAlternateMapName
    call FadeFromWhite8
    call $05a2
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    call MapBriefing_Update
    and a
    jr nz, $48dd
    call FadeToWhite8
    call SpriteObject_DestroyAll
    ld a, [wMapBriefingInputState]
    ret
MapBriefing_CheckAvailable::
    ld a, $08
    ld [wMapBriefingInputState], a
    ld a, [wMapBriefingGroup]
    cp $02
    jr z, $4914
    cp $03
    jr z, $4910
    ld a, $0a
    ld [wMapBriefingInputState], a
    scf
    ret
    ld b, $00
    jr $4916
    ld b, $01
    ld a, [wMapBriefingMapIndex]
    call UnitStatus_GetLayoutValue
    cp $80
    ret
    assert @ == $491f

section "Map Briefing Runtime B", romx[$4963], bank[$25]
MapBriefing_SetupScreen::
    farcall SharedGraphics_LoadMainFontBG
    xor a
    ldh [hSCX], a
    ldh [hSCY], a
    farcall UIWindowStack_Init
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    call $06f2
    ld a, [wMapBriefingDisplayVariant]
    and a
    jr z, $49ab
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $5c25
    ld hl, $9010
    ld bc, $0140
    farcall $25, Memcpy
    ld a, $0a
    ld bc, $0500
    ld de, $0a02
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    jr $49fa
    ld a, [wMapBriefingGroup]
    cp $02
    jr z, $49d9
    cp $03
    jr z, $49d9
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $720c
    ld hl, $9010
    ld bc, $0140
    farcall $19, Memcpy
    ld a, $0a
    ld bc, $0500
    ld de, $0a02
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    jr $49fa
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, $65e3
    ld hl, $9010
    ld bc, $0180
    farcall $27, Memcpy
    ld a, $0a
    ld bc, $0400
    ld de, $0c02
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0103
    ld de, $1203
    farcall UIWindow_DrawFrame
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0204
    ld de, $1001
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0204
    ld de, $1001
    farcall Gfx_TilemapFill
    ld bc, $0107
    ld de, $120a
    farcall UIWindow_DrawFrame
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0208
    ld de, $1008
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0208
    ld de, $1008
    farcall Gfx_TilemapFill
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld c, $15
    ld a, $08
    ld b, $04
    ld hl, $7104
    call $06d9
    call $06f2
    ld de, $7024
    ld hl, $8000
    ld bc, $00b0
    farcall $15, Memcpy
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [$c028], a
    ld bc, $5894
    call SpriteObject_SetPosition
    ld a, [$c028]
    call SpriteObject_Hide
    xor a
    ld hl, $c022
    ld [hli], a
    ld [hli], a
    ld [hl], a
    ld [wMapBriefingTextBankState], a
    ld a, [wMapBriefingMapIndex]
    sla a
    ld c, a
    ld b, $00
    ld a, [wMapBriefingGroup]
    sla a
    ld e, a
    ld d, $00
    ld hl, MapBriefing_GroupPointerTable
    add hl, de
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld h, a
    ld a, e
    ld l, a
    add hl, bc
    ld a, [hli]
    ld [$c025], a
    ld a, [hl]
    ld [$c026], a
    ld a, $01
    ld [$c027], a
    ret
MapBriefing_Update::
    ld a, [wMapBriefingInputState]
    ld b, a
    ldh a, [hJoyPressed]
    and b
    jp nz, $4b60
    ldh a, [hJoyHeld]
    and $01
    jr nz, $4adc
    ld a, [$c027]
    dec a
    ld [$c027], a
    jp nz, $4b5a
    ld a, $08
    ld [$c027], a
    ld a, [wMapBriefingGroup]
    cp $01
    jr z, $4aee
    call CampaignBriefing_ReadByte
    nop
    jr $4af1
    call BankedText_ReadByteAndAdvance
    cp $00
    jr z, $4b5d
    cp $01
    jr z, $4b21
    ld [$c021], a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld a, [$c023]
    inc a
    ld [$c023], a
    inc a
    ld b, a
    ld a, [$c024]
    add a, $08
    ld c, a
    call $0ed4
    ld de, $c021
    call Vram_DrawZeroTerminatedRow
    ld a, $04
    call Audio_RequestSFX
    jr $4b5a
    xor a
    ld [$c023], a
    ld a, [$c024]
    inc a
    ld [$c024], a
    cp $08
    jr c, $4b5a
    ld a, [$c028]
    call SpriteObject_Show
    call MapBriefing_WaitForInput
    ld a, [wMapBriefingInputState]
    ld b, a
    ldh a, [hJoyPressed]
    and b
    jr nz, $4b60
    xor a
    ld [$c024], a
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    xor a
    ld bc, $0208
    ld de, $1008
    farcall Gfx_TilemapFill
    ld a, $02
    ret
    ld a, $01
    ret
    call MapBriefing_WaitForInput
    ld a, [wMapBriefingInputState]
    ld b, a
    ldh a, [hJoyPressed]
    and $02
    and b
    jr nz, $4b77
    ld a, $02
    call Audio_RequestSFX
    ld a, $00
    ld [wMapBriefingInputState], a
    xor a
    ret
    ld a, SFX_CANCEL
    call Audio_RequestSFX
    ld a, $ff
    ld [wMapBriefingInputState], a
    xor a
    ret
MapBriefing_WaitForInput::
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    call $05a2
    call Sprite_Update
    ld a, [wMapBriefingInputState]
    or $01
    ld b, a
    ldh a, [hJoyPressed]
    and b
    jr z, $4b83
    ld a, [$c028]
    call SpriteObject_Hide
    ret
    assert @ == $4ba1

section "Map Briefing Pointer Groups", romx[$4ba1], bank[$25]
MapBriefing_GroupPointerTable::
    ; Group 0/2/3 point to fully source-backed Campaign pointer tables in Bank $25;
    ; their symbolic entries address the per-message Campaign streams in Bank $33.
    ; Group 1 is the local Beginner instructional pointer table at $4BA9.
    dw CampaignBriefing_PreMapPointerTable
    dw Beginner_Strings
    dw CampaignBriefing_ResultAPointerTable
    dw CampaignBriefing_ResultBPointerTable
    assert @ == $4ba9
