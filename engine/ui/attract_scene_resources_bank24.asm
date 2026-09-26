; Bank $24 contains the physical resource pool for attract scenes 2 and 5.
; Their logical assets overlap exactly as in retail: scene 2's $1000 graphics
; copy runs through scene 5's tilemap/attribute data and into scene 5 graphics.

section "Attract Bank24 Shared Resource Pool", romx[$4000], bank[$24]

AttractScene2Tilemap::
    incbin "gfx/attract/resources_bank24/scene2.tilemap"
AttractScene2Attributes::
    incbin "gfx/attract/resources_bank24/scene2.attrmap"
AttractScene2GraphicsWindow::
    incbin "gfx/attract/resources_bank24/scene2.2bpp"
AttractScene2Palettes::
    incbin "gfx/attract/resources_bank24/scene2_pal_0.pal"
    incbin "gfx/attract/resources_bank24/scene2_pal_1.pal"

AttractScene5Tilemap::
    incbin "gfx/attract/resources_bank24/scene5.tilemap"
AttractScene5Attributes::
    incbin "gfx/attract/resources_bank24/scene5.attrmap"
AttractScene5GraphicsWindow::
    incbin "gfx/attract/resources_bank24/scene5.2bpp"
AttractScene5Palettes::
    incbin "gfx/attract/resources_bank24/scene5_pal_0.pal"
    incbin "gfx/attract/resources_bank24/scene5_pal_1.pal"

; Campaign map-selection page 0 begins inside the attract scene-5 graphics
; window. This is a genuine retail alias: the same physical bytes are used by
; both presentation systems.
CampaignMapSelectPage0Graphics::
    incbin "gfx/attract/resources_bank24/campaign_map_select_page0.2bpp"

    assert @ == $5e10
