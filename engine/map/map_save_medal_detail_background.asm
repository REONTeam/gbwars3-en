include "macros/macros.inc"

; Shared medal-detail background renderer used by the selected SAVE-slot view.
; BC is the BG tilemap coordinate. The renderer copies the 160-byte tile plane
; to VRAM bank 0 and the parallel attribute plane to VRAM bank 1.
section "Map Save Medal Detail Background Renderer", romx[$4c59], bank[$10]
MapSave_DrawMedalDetailBackground::
    push bc
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call Vram_TilemapCoord
    ld bc, $00a0
    ld de, MapSave_MedalDetailTilemap
    call Memcpy
    ld a, $01
    ldh [hVRAMBank], a
    ldh [rVBK], a
    pop bc
    call Vram_TilemapCoord
    ld bc, $00a0
    ld de, MapSave_MedalDetailAttrmap
    call Memcpy
    ret

    assert @ == $4c80

section "Map Save Medal Detail Tilemap", romx[$4c80], bank[$10]
MapSave_MedalDetailTilemap::
    INCBIN "gfx/file_select/medal_detail.tilemap"
    assert @ == $4d20

section "Map Save Medal Detail Attributes", romx[$4d20], bank[$10]
MapSave_MedalDetailAttrmap::
    INCBIN "gfx/file_select/medal_detail.attrmap"
    assert @ == $4dc0
