; Fixed-placement graphics assets.
; Split from main.asm in ; asset bytes and ROM locations are unchanged.

section "Image_Charmap", romx[$4118], bank[$01]
Image_Charmap::
incbin "gfx/font/charmap.2bpp"


section "Image_Symbols", romx[$5120], bank[$01]
Image_Symbols::
incbin "gfx/font/symbols.2bpp"


section "Image_Unit_Map_Icons", romx[$5898], bank[$01]
Image_Unit_Map_Icons::
incbin "gfx/units/map_icons.2bpp"


section "Image_Days_Menu", romx[$76f1], bank[$0c]
incbin "gfx/ui/days_menu.2bpp"


section "Attrmap_Title_Screen", romx[$5080], bank[$10]
Attrmap_Title_Screen::
incbin "gfx/title/title_screen.attrmap"


section "Image_Title_Screen", romx[$51e8], bank[$10]
Image_Title_Screen::
incbin "gfx/title/title_screen.2bpp"


section "Pals_Title_Screen", romx[$6868], bank[$10]
Pals_Title_Screen::
incbin "gfx/title/title_screen.pal"


section "Image_Action_Menu", romx[$4e88], bank[$11]
Image_Action_Menu::
incbin "gfx/ui/action_menu.2bpp"


section "Image_System_Messages", romx[$5e10], bank[$11]
incbin "gfx/ui/system_messages.2bpp"


section "Image_Map_Menu", romx[$57cc], bank[$13]
incbin "gfx/ui/map_menu.2bpp"


section "Image_Name_Screen", romx[$5708], bank[$14]
incbin "gfx/ui/name_screen.2bpp"


section "Image_File_Select_Numbers", romx[$6341], bank[$14]
incbin "gfx/file_select/file_select_numbers.2bpp" ; Unused?


section "Image_File_Select_General1", romx[$6401], bank[$14]
incbin "gfx/file_select/file_select_general1.2bpp" ; Unused?


section "Image_File_Select_Modes", romx[$65b1], bank[$14]
incbin "gfx/file_select/file_select_modes.2bpp"


section "Image_File_Select_Medals", romx[$6b41], bank[$14]
incbin "gfx/file_select/file_select_medals.2bpp"


section "Image_File_Select_Ranks", romx[$73e1], bank[$14]
incbin "gfx/file_select/file_select_ranks.2bpp"


section "Image_Configuration", romx[$4513], bank[$15]
incbin "gfx/ui/config.2bpp"


section "Map Selection Blank Tile", romx[$76e2], bank[$15]
Image_MapSelection_BlankTile::
    ds 16, 0


section "Image_VS_Menu_Type", romx[$76f2], bank[$15]
Image_VS_Menu_Type::
incbin "gfx/ui/vs_menu_type.2bpp"


section "Map Selection Palettes", romx[$7942], bank[$15]
Pals_MapSelection::
    dw $0000, $6900, $7fff, $7240
    dw $7fff, $56b5, $2d6b, $0000
    dw $7fff, $036c, $0208, $0000
    dw $6900, $009f, $7fff, $0000
    dw $4210, $2d6b, $18c6, $0000
    dw $539f, $02df, $0174, $0000
    dw $63f0, $4ac0, $2560, $0000
    dw $7c1f, $7c1f, $0000, $7fff


section "Bank 15 Retail Padding Before Custom Text", romx[$7982], bank[$15]
    ds $7a00 - @, $ff


section "Image_Unit_Status", romx[$7ab8], bank[$18]
incbin "gfx/ui/unit_status.2bpp"


section "Image_Mobile_Menu", romx[$720c], bank[$19]
incbin "gfx/network/mobile_menu.2bpp"


section "Pals_Mobile_Menu", romx[$78ec], bank[$19]
Pals_Mobile_Menu::
incbin "gfx/network/mobile_menu.pal"


section "Image_Charmap_News", romx[$64d4], bank[$22]
incbin "gfx/font/charmap_news.2bpp"


section "Image_Results", romx[$65e3], bank[$27]
incbin "gfx/results/results.2bpp"


section "Image_File_Select_General2", romx[$7577], bank[$27]
Image_File_Select_General2::
incbin "gfx/file_select/file_select_general2.2bpp"


; exact pixel payloads selected by the Bank $16 battle-unit
; descriptor layer. Code/layout data at $4A00-$5560 is sourced separately.
section "Battle Unit Ground Tiles", romx[$5561], bank[$16]
Image_Battle_Unit_Ground_Tiles::
Image_Battle_Unit_SharedBlank_Ground::
incbin "gfx/units/battle/per_unit/shared_blank.2bpp"
Image_Battle_Unit_Infantry_Tiles::
incbin "gfx/units/battle/per_unit/01_infantry.2bpp"
Image_Battle_Unit_MissileInfantry_Tiles::
incbin "gfx/units/battle/per_unit/02_missile_infantry.2bpp"
Image_Battle_Unit_MercenaryInfantry_Tiles::
incbin "gfx/units/battle/per_unit/03_mercenary_infantry.2bpp"
Image_Battle_Unit_ConstructionTruck_Tiles::
incbin "gfx/units/battle/per_unit/04_construction_truck.2bpp"
Image_Battle_Unit_SupplyTruck_Tiles::
incbin "gfx/units/battle/per_unit/05_supply_truck.2bpp"
Image_Battle_Unit_SupplyTruckS_Tiles::
incbin "gfx/units/battle/per_unit/06_supply_truck_s.2bpp"
Image_Battle_Unit_TransportTruck_Tiles::
incbin "gfx/units/battle/per_unit/07_transport_truck.2bpp"
Image_Battle_Unit_TransportTruckS_Tiles::
incbin "gfx/units/battle/per_unit/08_transport_truck_s.2bpp"
Image_Battle_Unit_CombatBuggy_Tiles::
incbin "gfx/units/battle/per_unit/09_combat_buggy.2bpp"
Image_Battle_Unit_CombatBuggyS_Tiles::
incbin "gfx/units/battle/per_unit/10_combat_buggy_s.2bpp"
Image_Battle_Unit_CombatVehicle_Tiles::
incbin "gfx/units/battle/per_unit/11_combat_vehicle.2bpp"
Image_Battle_Unit_CombatVehicleS_Tiles::
incbin "gfx/units/battle/per_unit/12_combat_vehicle_s.2bpp"
Image_Battle_Unit_Apc_Tiles::
incbin "gfx/units/battle/per_unit/13_apc.2bpp"
Image_Battle_Unit_ApcS_Tiles::
incbin "gfx/units/battle/per_unit/14_apc_s.2bpp"
Image_Battle_Unit_RocketLauncher_Tiles::
incbin "gfx/units/battle/per_unit/15_rocket_launcher.2bpp"
Image_Battle_Unit_RocketLauncherS_Tiles::
incbin "gfx/units/battle/per_unit/16_rocket_launcher_s.2bpp"
Image_Battle_Unit_AntiAirTank_Tiles::
incbin "gfx/units/battle/per_unit/17_anti_air_tank.2bpp"
Image_Battle_Unit_MercenaryAntiAirMissiles_Tiles::
incbin "gfx/units/battle/per_unit/18_mercenary_anti_air_missiles.2bpp"
Image_Battle_Unit_AntiAirMissiles_Tiles::
incbin "gfx/units/battle/per_unit/19_anti_air_missiles.2bpp"
Image_Battle_Unit_AntiAirMissilesS_Tiles::
incbin "gfx/units/battle/per_unit/20_anti_air_missiles_s.2bpp"
Image_Battle_Unit_Artillery_Tiles::
incbin "gfx/units/battle/per_unit/21_artillery.2bpp"
Image_Battle_Unit_ArtilleryS_Tiles::
incbin "gfx/units/battle/per_unit/22_artillery_s.2bpp"
Image_Battle_Unit_Ifv_Tiles::
incbin "gfx/units/battle/per_unit/23_ifv.2bpp"
Image_Battle_Unit_IfvS_Tiles::
incbin "gfx/units/battle/per_unit/24_ifv_s.2bpp"
Image_Battle_Unit_TankDestroyer_Tiles::
incbin "gfx/units/battle/per_unit/25_tank_destroyer.2bpp"
Image_Battle_Unit_TankDestroyerS_Tiles::
incbin "gfx/units/battle/per_unit/26_tank_destroyer_s.2bpp"
Image_Battle_Unit_Tank_Tiles::
incbin "gfx/units/battle/per_unit/27_tank.2bpp"
Image_Battle_Unit_MercenaryTank_Tiles::
incbin "gfx/units/battle/per_unit/28_mercenary_tank.2bpp"
    assert @ == $5f81

section "Battle Unit Sea Tiles", romx[$5fc1], bank[$16]
Image_Battle_Unit_Sea_Tiles::
Image_Battle_Unit_SharedBlank_Sea::
incbin "gfx/units/battle/per_unit/shared_blank.2bpp"
Image_Battle_Unit_AegisWarship_Tiles::
incbin "gfx/units/battle/per_unit/44_aegis_warship.2bpp"
Image_Battle_Unit_MercenaryMissileFrigate_Tiles::
incbin "gfx/units/battle/per_unit/45_mercenary_missile_frigate.2bpp"
Image_Battle_Unit_LargeCarrier_Tiles::
incbin "gfx/units/battle/per_unit/46_large_carrier.2bpp"
Image_Battle_Unit_SmallCarrier_Tiles::
incbin "gfx/units/battle/per_unit/47_small_carrier.2bpp"
Image_Battle_Unit_TransportShip_Tiles::
incbin "gfx/units/battle/per_unit/48_transport_ship.2bpp"
Image_Battle_Unit_SupplyTanker_Tiles::
incbin "gfx/units/battle/per_unit/49_supply_tanker.2bpp"
Image_Battle_Unit_Submarine_Tiles::
incbin "gfx/units/battle/per_unit/50_submarine.2bpp"
Image_Battle_Unit_SubmarineS_Tiles::
incbin "gfx/units/battle/per_unit/51_submarine_s.2bpp"
    assert @ == $6e51

section "Battle Unit Air Tiles", romx[$6e91], bank[$16]
Image_Battle_Unit_Air_Tiles::
Image_Battle_Unit_SharedBlank_Air::
incbin "gfx/units/battle/per_unit/shared_blank.2bpp"
Image_Battle_Unit_FighterPlaneA_Tiles::
incbin "gfx/units/battle/per_unit/29_fighter_plane_a.2bpp"
Image_Battle_Unit_FighterPlaneB_Tiles::
incbin "gfx/units/battle/per_unit/30_fighter_plane_b.2bpp"
Image_Battle_Unit_FighterPlaneS_Tiles::
incbin "gfx/units/battle/per_unit/31_fighter_plane_s.2bpp"
Image_Battle_Unit_AttackPlaneA_Tiles::
incbin "gfx/units/battle/per_unit/32_attack_plane_a.2bpp"
Image_Battle_Unit_AttackPlaneB_Tiles::
incbin "gfx/units/battle/per_unit/33_attack_plane_b.2bpp"
Image_Battle_Unit_AttackPlaneS_Tiles::
incbin "gfx/units/battle/per_unit/34_attack_plane_s.2bpp"
Image_Battle_Unit_Bomber_Tiles::
incbin "gfx/units/battle/per_unit/35_bomber.2bpp"
Image_Battle_Unit_MercenaryBomber_Tiles::
incbin "gfx/units/battle/per_unit/36_mercenary_bomber.2bpp"
Image_Battle_Unit_TransportPlane_Tiles::
incbin "gfx/units/battle/per_unit/37_transport_plane.2bpp"
Image_Battle_Unit_RefuelingPlane_Tiles::
incbin "gfx/units/battle/per_unit/38_refueling_plane.2bpp"
Image_Battle_Unit_BattleHelicopter_Tiles::
incbin "gfx/units/battle/per_unit/39_battle_helicopter.2bpp"
Image_Battle_Unit_BattleHelicopterS_Tiles::
incbin "gfx/units/battle/per_unit/40_battle_helicopter_s.2bpp"
Image_Battle_Unit_AntiSubHelicopter_Tiles::
incbin "gfx/units/battle/per_unit/41_anti_sub_helicopter.2bpp"
Image_Battle_Unit_TransportHelicopter_Tiles::
incbin "gfx/units/battle/per_unit/42_transport_helicopter.2bpp"
Image_Battle_Unit_TransportHelicopterS_Tiles::
incbin "gfx/units/battle/per_unit/43_transport_helicopter_s.2bpp"
    assert @ == $7b21

section "Battle Unit Special Tiles", romx[$7b61], bank[$16]
Image_Battle_Unit_Special_Tiles::
Image_Battle_Unit_SpecialSharedBlank::
incbin "gfx/units/battle/per_unit/special_shared_blank.2bpp"
Image_Battle_Unit_Special0_Tiles::
incbin "gfx/units/battle/per_unit/52_special_0.2bpp"
Image_Battle_Unit_Special0_InterstitialFrame::
incbin "gfx/units/battle/per_unit/special_0_interstitial_frame.2bpp"
Image_Battle_Unit_Special1_Tiles::
incbin "gfx/units/battle/per_unit/53_special_1.2bpp"
Image_Battle_Unit_Special1_InterstitialFrame::
incbin "gfx/units/battle/per_unit/special_1_interstitial_frame.2bpp"
Image_Battle_Unit_Special2_Tiles::
incbin "gfx/units/battle/per_unit/54_special_2.2bpp"
Image_Battle_Unit_Special2_InterstitialFrame::
incbin "gfx/units/battle/per_unit/special_2_interstitial_frame.2bpp"
Image_Battle_Unit_Special3_Tiles::
incbin "gfx/units/battle/per_unit/55_special_3.2bpp"
Image_Battle_Unit_Special3_InterstitialFrame::
incbin "gfx/units/battle/per_unit/special_3_interstitial_frame.2bpp"
Image_Battle_Unit_Special4_Tiles::
incbin "gfx/units/battle/per_unit/56_special_4.2bpp"
    assert @ == $7d21



; fixed battle-scene pixel payloads loaded by Bank $18:$4948.
; These were previously inherited from the base-ROM overlay.
section "Battle Scene Common Place Tiles", romx[$7133], bank[$17]
Image_Battle_Scene_Common_Place_Tiles::
incbin "gfx/battle/common/battle_place_common.2bpp"
    assert @ == $72d3

section "Battle Scene Common Place Adjacent Data Record", romx[$72d3], bank[$17]
BattleScene_CommonPlaceAdjacentDataRecord::
    db $52, $4a, $00, $00, $50, $1d, $ff, $7f
    assert @ == $72db

; The battle loader copies $4B0 bytes from $43E5, but the final $90 bytes of
; that source window are dual-use retail bytes: they are executable main-mode
; dispatcher code at $4805-$4894. Emit only the independent graphics prefix
; here; the loader intentionally continues across the dispatcher bytes.
section "Battle Scene Common UI Tiles", romx[$43e5], bank[$14]
Image_Battle_Scene_Common_UI_Tiles::
incbin "gfx/battle/common/battle_ui_common.2bpp", 0, $0420
    assert @ == $4805
