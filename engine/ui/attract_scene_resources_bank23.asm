; Bank $23 attract-scene resources are deliberately aliased in the retail ROM.
; Scene 1's $1000 graphics copy runs through the later scene-3 layout, and
; scene 3's graphics copy runs through the scene-4 layout.  Keep one physical
; resource pool here and expose labels at each interpretation boundary instead
; of creating overlapping RGBDS sections.

section "Attract Bank23 Shared Resource Pool", romx[$4fc7], bank[$23]

AttractScene1Tilemap::
    incbin "gfx/attract/resources_bank23/scene1.tilemap"
AttractScene1Attributes::
    incbin "gfx/attract/resources_bank23/scene1.attrmap"
AttractScene1GraphicsWindow::
    incbin "gfx/attract/resources_bank23/scene1.2bpp"
AttractScene1Palettes::
    incbin "gfx/attract/resources_bank23/scene1_pal_0.pal"
    incbin "gfx/attract/resources_bank23/scene1_pal_1.pal"

; These bytes are still inside AttractScene1GraphicsWindow as consumed by the
; retail loader, but are also scene 3's standalone layout resources.
AttractScene3Tilemap::
    incbin "gfx/attract/resources_bank23/scene3.tilemap"
AttractScene3Attributes::
    incbin "gfx/attract/resources_bank23/scene3.attrmap"
AttractScene3GraphicsWindow::
    incbin "gfx/attract/resources_bank23/scene3.2bpp"
AttractScene3Palettes::
    incbin "gfx/attract/resources_bank23/scene3_pal_0.pal"
    incbin "gfx/attract/resources_bank23/scene3_pal_1.pal"

; Likewise, scene 4's layout begins inside scene 3's $1000 graphics window.
AttractScene4Tilemap::
    incbin "gfx/attract/resources_bank23/scene4.tilemap"
AttractScene4Attributes::
    incbin "gfx/attract/resources_bank23/scene4.attrmap"
AttractScene4GraphicsWindow::
    incbin "gfx/attract/resources_bank23/scene4.2bpp"
AttractScene4Palettes::
    incbin "gfx/attract/resources_bank23/scene4_pal_0.pal"
    incbin "gfx/attract/resources_bank23/scene4_pal_1.pal"
AttractScene4TailTiles::
    incbin "gfx/attract/resources_bank23/scene4_tail_tiles.2bpp"
    ds $1f0, $ff

    assert @ == $7d97

; The retail bank is completely empty after the scene-4 over-copy window.
section "Bank23 End Padding", romx[$7d97], bank[$23]
    ds $8000 - @, $ff
