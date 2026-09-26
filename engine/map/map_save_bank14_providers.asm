include "macros/macros.inc"

; Shared Bank $14 providers used by the map-save file-select presentation.

section "MapSave_OpenSelectedSlotView", romx[$5a5b], bank[$14]
MapSave_OpenSelectedSlotView::
    call MapSave_OpenMedalDetailView
    call $081d
MapSave14_Loc_5A61:
    call $05a2
    call $3056
    ld a, $40
    farcall $15, Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff91]
    bit 1, a
    jr z, MapSave14_Loc_5A7B
    ld a, $0c
    call $3844
    jp MapSave14_Loc_5B09
MapSave14_Loc_5A7B:
    ldh a, [$ff92]
    bit 7, a
    jr z, MapSave14_Loc_5A99
    ld a, [$cc7a]
    add $06
    cp $18
    jr nc, MapSave14_Loc_5A97
    push af
    ld a, $01
    call $3844
    pop af
    ld [$cc7a], a
    call MapSave_DrawSelectedMedalDetails
MapSave14_Loc_5A97:
    jr MapSave14_Loc_5AEB
MapSave14_Loc_5A99:
    ldh a, [$ff92]
    bit 6, a
    jr z, MapSave14_Loc_5AB5
    ld a, [$cc7a]
    sub $06
    jr c, MapSave14_Loc_5AB3
    push af
    ld a, $01
    call $3844
    pop af
    ld [$cc7a], a
    call MapSave_DrawSelectedMedalDetails
MapSave14_Loc_5AB3:
    jr MapSave14_Loc_5AEB
MapSave14_Loc_5AB5:
    ldh a, [$ff92]
    bit 5, a
    jr z, MapSave14_Loc_5AD0
    ld a, [$cc7a]
    dec a
    cp $ff
    jr z, MapSave14_Loc_5AD0
    push af
    ld a, $01
    call $3844
    pop af
    ld [$cc7a], a
    call MapSave_DrawSelectedMedalDetails
MapSave14_Loc_5AD0:
    ldh a, [$ff92]
    bit 4, a
    jr z, MapSave14_Loc_5AEB
    ld a, [$cc7a]
    inc a
    cp $18
    jr nc, MapSave14_Loc_5A97
    push af
    ld a, $01
    call $3844
    pop af
    ld [$cc7a], a
    call MapSave_DrawSelectedMedalDetails
MapSave14_Loc_5AEB:
    ld a, [$cc7a]
    cp $0c
    jr nc, MapSave14_Loc_5AFB
    ld a, [$cc7a]
    cp $0c
    jr c, MapSave14_Loc_5B00
    jr MapSave14_Loc_5B03
MapSave14_Loc_5AFB:
    call MapSave_ShowLowerMedalGridPage
    jr MapSave14_Loc_5B03
MapSave14_Loc_5B00:
    call MapSave_ShowUpperMedalGridPage
MapSave14_Loc_5B03:
    call MapSave_PositionMedalCursor
    jp MapSave14_Loc_5A61
MapSave14_Loc_5B09:
    call $07b4
    xor a
    ldh [$ff96], a
    call $2e67
    ret
section "MapSave_PrepareFileSelectDisplay", romx[$5b6d], bank[$14]
MapSave_PrepareFileSelectDisplay::
    di
    call $055b
    call $0344
    call $051f
    ei
    ret
section "MapSave_LoadPreviewGraphics", romx[$5d30], bank[$14]
MapSave_LoadPreviewGraphics::
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [rVBK], a
    ld de, $6dd1
    ld hl, $8800
    ld bc, $0480
    call $3b50
    ld de, $73e1
    ld hl, $8d00
    ld bc, $0390
    call $3b50
    pop af
    ldh [$ff83], a
    ldh [rVBK], a
    ld a, $00
    ld b, $08
    ld hl, $7251
    call $06bc
    call $06af
    call $06f2
    ld a, $00
    ldh [$ff83], a
    ldh [rVBK], a
    ret
section "MapSave_SetPreviewRendererSourceA", romx[$5d6d], bank[$14]
MapSave_SetPreviewRendererSourceA::
    ld a, $41
    ld [$cc59], a
    ld a, $6d
    ld [$cc58], a
    ld a, $89
    ld [$cc5b], a
    ld a, $6d
    ld [$cc5a], a
    ld a, $80
    ld [$cc5c], a
    ld a, $14
    ld [$cc61], a
    ret
section "MapSave_SetPreviewRendererSourceB", romx[$5d8c], bank[$14]
MapSave_SetPreviewRendererSourceB::
    ld a, $91
    ld [$cc59], a
    ld a, $72
    ld [$cc58], a
    ld a, $39
    ld [$cc5b], a
    ld a, $73
    ld [$cc5a], a
    ld a, $d0
    ld [$cc5c], a
    ld a, $14
    ld [$cc61], a
    ret
section "MapSave_DrawPreviewRect6", romx[$5dab], bank[$14]
MapSave_DrawPreviewRect6::
    ld [$cc50], a
    ld a, b
    ld [$cc52], a
    ld a, c
    ld [$cc53], a
    xor a
    ld [$cc54], a
    ld [$cc55], a
    ld a, d
    ld [$cc56], a
    ld a, e
    ld [$cc57], a
    ld a, [$cc50]
    cp $00
    jr z, MapSave14_Loc_5DD0
    dec a
    ld [$cc50], a
MapSave14_Loc_5DD0:
    ld a, [$cc50]
    ld b, $06
    call $2995
    ld a, l
    ld [$cc50], a
    call Vram_DrawBGRectIndexed
    ret
section "MapSave_DrawPreviewRect12", romx[$5e15], bank[$14]
MapSave_DrawPreviewRect12::
    ld [$cc50], a
    ld a, b
    ld [$cc52], a
    ld a, c
    ld [$cc53], a
    xor a
    ld [$cc54], a
    ld [$cc55], a
    ld a, d
    ld [$cc56], a
    ld a, e
    ld [$cc57], a
    ld a, [$cc50]
    ld b, $0c
    call $2995
    ld a, l
    ld [$cc50], a
    call Vram_DrawBGRectIndexed
    ret
