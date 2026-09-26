include "macros/macros.inc"

; Shared Bank $01 gameplay/UI VRAM graphics frontend. The four entries below
; form one contiguous retail family from $4000 through $4117.
section "Shared Gameplay Graphics Frontend", romx[$4000], bank[$01]

; Restore the main font/charmap to both BG tile regions. This lightweight path
; is used by menus, results, briefings, title/attract screens and battle UI.
SharedGraphics_LoadMainFontBG::
    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, Image_Charmap
    ld hl, $9000
    ld bc, $0800
    call Memcpy
    ld hl, $8800
    ld bc, $0800
    call Memcpy
    ret
    assert @ == $401c

; Main gameplay-map VRAM graphics loader. This is the retail path that proves
; the map terrain tile source at Bank $01:$5268 and the unit-map-icon source
; at Bank $01:$5898. Other small source ranges remain conservatively expressed
; as offsets inside the already source-backed Bank 1 graphics blocks.
MapGraphics_LoadGameplayAssets::
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ld hl, $8000
    ld de, Image_Charmap
    ld bc, $0010
    call MemcpyWaitLCD

    ld de, Image_Charmap + $b00
    ld hl, $8010
    ld bc, $0500
    call MemcpyWaitLCD

    ld de, Image_Charmap + $2d0
    ld hl, $8510
    ld bc, $0010
    call MemcpyWaitLCD

    ld hl, $8800
    ld de, Image_Charmap
    ld bc, $0010
    call MemcpyWaitLCD

    ld de, Image_Symbols
    ld hl, $8a50
    ld bc, $0130
    call MemcpyWaitLCD

    ld de, Image_Symbols + $130
    ld hl, $8520
    ld bc, $0010
    call MemcpyWaitLCD

    ld de, Image_Charmap + $110
    ld hl, $8540
    ld bc, $0020
    call MemcpyWaitLCD

    ld de, Image_Charmap + $2e0
    ld hl, $8570
    ld bc, $0010
    call MemcpyWaitLCD

    ld de, Image_Charmap + $3f0
    ld hl, $8560
    ld bc, $0010
    call MemcpyWaitLCD

    ld de, Image_Charmap + $300
    ld hl, $8810
    ld bc, $0100
    call MemcpyWaitLCD

    ld de, Image_Charmap + $410
    ld hl, $88b0
    ld bc, $01a0
    call MemcpyWaitLCD

    ld de, MapTerrainTiles
    ld hl, $9000
    ld bc, MAP_TERRAIN_GFX_TILE_COUNT * 16
    call MemcpyWaitLCD

    ld a, 1
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, Image_Unit_Map_Icons
    ld hl, $9000
    ld bc, $0800
    call MemcpyWaitLCD
    ld hl, $8800
    ld bc, $05a0
    call MemcpyWaitLCD
    ret
    assert @ == $40ce

; Full gameplay loader plus the additional BG-font mirrors used by the Unit
; Status/controller path. This entry is independently called from Bank $25.
MapGraphics_LoadGameplayAssetsAndFontBG::
    call MapGraphics_LoadGameplayAssets
    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld hl, $9000
    ld de, Image_Charmap
    ld bc, $0010
    call Memcpy
    ld de, Image_Charmap + $0b00
    ld hl, $9010
    ld bc, $0500
    call Memcpy
    ld de, Image_Charmap + $02d0
    ld hl, $9510
    ld bc, $0010
    call Memcpy
    ret
    assert @ == $40fc

; Load the compact font/menu tile blocks used by editor prompts, unit creation,
; retry dialogs and other lower-panel text UI.
SharedGraphics_LoadMenuFontTiles::
    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a
    ld de, Image_Charmap + $0600
    ld hl, $8600
    ld bc, $0200
    call MemcpyWaitLCD
    ld hl, $8d00
    ld bc, $0300
    call MemcpyWaitLCD
    ret
    assert @ == $4118

section "Map Terrain Graphics", romx[$5268], bank[$01]
MapTerrainTiles::
    incbin "gfx/environment/map/terrain_tiles.2bpp"
MapTerrainTiles_End::
    assert MapTerrainTiles_End - MapTerrainTiles == MAP_TERRAIN_GFX_TILE_COUNT * 16
    assert @ == $5868
