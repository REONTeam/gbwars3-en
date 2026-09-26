; Bank $24 Campaign map-selection presentation resources.
;
; Each of the five selector pages is an $810-byte package:
;   $7D0 bytes of 2bpp tiles followed by $40 bytes (8 CGB BG palettes).
; Page 0 starts at $5690 inside the separately owned attract scene-5 graphics
; window. This module begins at the first byte not already physically owned by
; that attract pool and continues through the end of the fifth palette block.

section "Campaign Map Select Bank24 Resource Tail", romx[$5e10], bank[$24]

; Final $50 bytes of page 0's $7D0-byte graphics window.
CampaignMapSelectPage0GraphicsTail::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page0_graphics_tail.2bpp"
CampaignMapSelectPage0Palettes::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page0_palettes.pal"

CampaignMapSelectPage1Graphics::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page1_graphics.2bpp"
CampaignMapSelectPage1Palettes::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page1_palettes.pal"

CampaignMapSelectPage2Graphics::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page2_graphics.2bpp"
CampaignMapSelectPage2Palettes::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page2_palettes.pal"

CampaignMapSelectPage3Graphics::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page3_graphics.2bpp"
CampaignMapSelectPage3Palettes::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page3_palettes.pal"

CampaignMapSelectPage4Graphics::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page4_graphics.2bpp"
CampaignMapSelectPage4Palettes::
    incbin "gfx/campaign/map_select/resources/campaign_map_select_page4_palettes.pal"

    assert @ == $7ee0

section "Bank24 End Padding", romx[$7ee0], bank[$24]
    ds $8000 - @, $ff
