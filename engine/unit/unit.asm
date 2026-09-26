include "macros/macros.inc"
include "charmaps/char_unit.inc"
include "constants/unit_constants.inc"
include "macros/unit_macros.inc"

setcharmap unit

section "unit.asm", romx[$4a43], bank[$12]

UnitData::
    dw UnitDataRecords.empty
    dw UnitDataRecords.infantry
    dw UnitDataRecords.missile_infantry
    dw UnitDataRecords.mercenary_infantry
    dw UnitDataRecords.construction_truck
    dw UnitDataRecords.supply_truck
    dw UnitDataRecords.supply_truck_s
    dw UnitDataRecords.transport_truck
    dw UnitDataRecords.transport_truck_s
    dw UnitDataRecords.combat_buggy
    dw UnitDataRecords.combat_buggy_s
    dw UnitDataRecords.combat_vehicle
    dw UnitDataRecords.combat_vehicle_s
    dw UnitDataRecords.apc
    dw UnitDataRecords.apc_s
    dw UnitDataRecords.rocket_launcher
    dw UnitDataRecords.rocket_launcher_s
    dw UnitDataRecords.anti_air_tank
    dw UnitDataRecords.mercenary_anti_air_missiles
    dw UnitDataRecords.anti_air_missiles
    dw UnitDataRecords.anti_air_missiles_s
    dw UnitDataRecords.artillery
    dw UnitDataRecords.artillery_s
    dw UnitDataRecords.ifv
    dw UnitDataRecords.ifv_s
    dw UnitDataRecords.tank_destroyer
    dw UnitDataRecords.tank_destroyer_s
    dw UnitDataRecords.tank
    dw UnitDataRecords.mercenary_tank
    dw UnitDataRecords.fighter_plane_a
    dw UnitDataRecords.fighter_plane_b
    dw UnitDataRecords.fighter_plane_s
    dw UnitDataRecords.attack_plane_a
    dw UnitDataRecords.attack_plane_b
    dw UnitDataRecords.attack_plane_s
    dw UnitDataRecords.bomber
    dw UnitDataRecords.mercenary_bomber
    dw UnitDataRecords.transport_plane
    dw UnitDataRecords.refueling_plane
    dw UnitDataRecords.battle_helicopter
    dw UnitDataRecords.battle_helicopter_s
    dw UnitDataRecords.anti_sub_helicopter
    dw UnitDataRecords.transport_helicopter
    dw UnitDataRecords.transport_helicopter_s
    dw UnitDataRecords.aegis_warship
    dw UnitDataRecords.mercenary_missile_frigate
    dw UnitDataRecords.large_carrier
    dw UnitDataRecords.small_carrier
    dw UnitDataRecords.transport_ship
    dw UnitDataRecords.supply_tanker
    dw UnitDataRecords.submarine
    dw UnitDataRecords.submarine_s
    dw UnitDataRecords.dummy

    assert @ - UnitData == UNIT_DATA_COUNT * 2
UnitDataRecords::
                                    ;  "Name      ",  HP, FUEL, Move, Cap, ?, Upkeep, Gold/100G, Materials, Wep1/Ammo, Wep2/Ammo, Target, MoveProfile, Carrying/Accepted, DEF by family, Focus, Loss
    .empty:                            unit_data "          ", 10, 99, 6, 0, 5, 0, 99, 99, WEAPON_NONE, 10, WEAPON_EMPTY, 0, 1, MOVEMENT_PROFILE_01, 5, 0, 0, 0, 99, 99, 99, 99, 99, 0, 0 ; -
    .infantry:                         unit_data "INFANTRY  ", 10, 99, 3, 0, 3, 0, 1, 10, WEAPON_MACHINE_GUN_B, 9, WEAPON_EMPTY, 0, 1, MOVEMENT_PROFILE_00, 0, 1, 2, 4, 10, 10, 12, 10, 0, 10, 3 ; ホヘイ
    .missile_infantry:                 unit_data "MECH      ", 10, 70, 2, 0, 3, 0, 2, 12, WEAPON_ANTI_TANK_MISSILE_A, 1, WEAPON_MACHINE_GUN_B, 6, 1, MOVEMENT_PROFILE_00, 0, 1, 2, 4, 14, 12, 16, 14, 0, 13, 6 ; ミサイルホヘイ
    .mercenary_infantry:               unit_data "MERCENARY ", 10, 85, 4, 0, 3, 0, 6, 14, WEAPON_GRENADE, 2, WEAPON_MACHINE_GUN_B, 8, 1, MOVEMENT_PROFILE_01, 0, 1, 2, 4, 16, 16, 18, 16, 0, 16, 3 ; トクシュホヘイ
    .construction_truck:               unit_data "BULLDOZER ", 10, 50, 5, 0, 1, 0, 8, 20, WEAPON_MATERIAL, 5, WEAPON_MACHINE_GUN_B, 7, 1, MOVEMENT_PROFILE_02, 0, 2, 4, 4, 14, 14, 14, 14, 0, 12, 2 ; コウサクシャ
    .supply_truck:                     unit_data "S TRUCK   ", 10, 99, 6, 0, 1, 0, 6, 22, WEAPON_SUPPLIES, 5, WEAPON_EMPTY, 0, 1, MOVEMENT_PROFILE_02, 0, 2, 4, 4, 14, 14, 12, 16, 0, 12, 2 ; ホキュウシャ
    .supply_truck_s:                   unit_data "S TRUCK-S ", 10, 99, 5, 0, 1, 0, 8, 24, WEAPON_SUPPLIES, 8, WEAPON_EMPTY, 0, 1, MOVEMENT_PROFILE_02, 0, 2, 4, 4, 16, 16, 12, 16, 0, 15, 3 ; ホキュウシャS
    .transport_truck:                  unit_data "T TRUCK   ", 10, 50, 7, 1, 1, 0, 5, 20, WEAPON_MACHINE_GUN_B, 7, WEAPON_EMPTY, 0, 1, MOVEMENT_PROFILE_03, 1, 2, 4, 4, 14, 14, 12, 14, 0, 14, 2 ; ユソウトラック
    .transport_truck_s:                unit_data "T TRUCK-S ", 10, 60, 7, 1, 1, 0, 7, 22, WEAPON_AUTOCANNON_B, 5, WEAPON_MACHINE_GUN_B, 9, 1, MOVEMENT_PROFILE_03, 1, 2, 4, 4, 16, 16, 12, 16, 0, 15, 2 ; ユソウトラックS
    .combat_buggy:                     unit_data "BUGGY     ", 10, 50, 7, 0, 5, 0, 5, 16, WEAPON_GRENADE, 2, WEAPON_MACHINE_GUN_B, 5, 1, MOVEMENT_PROFILE_04, 0, 2, 4, 4, 12, 12, 13, 12, 0, 22, 3 ; コンバットバギ―
    .combat_buggy_s:                   unit_data "BUGGY-S   ", 10, 45, 7, 0, 6, 0, 7, 18, WEAPON_ANTI_TANK_MISSILE_B, 3, WEAPON_MACHINE_GUN_A, 7, 1, MOVEMENT_PROFILE_04, 0, 2, 4, 4, 15, 15, 16, 15, 0, 25, 3 ; コンバットバギ―S
    .combat_vehicle:                   unit_data "HUMVEE    ", 10, 50, 7, 0, 4, 0, 7, 17, WEAPON_ANTI_TANK_MISSILE_B, 2, WEAPON_MACHINE_GUN_B, 9, 1, MOVEMENT_PROFILE_05, 0, 2, 4, 4, 14, 14, 14, 14, 0, 21, 3 ; セントウシャリョウ
    .combat_vehicle_s:                 unit_data "HUMVEE-S  ", 10, 45, 6, 0, 5, 0, 8, 19, WEAPON_ANTI_TANK_MISSILE_B, 3, WEAPON_AUTOCANNON_B, 7, 1, MOVEMENT_PROFILE_05, 0, 2, 4, 4, 17, 17, 16, 17, 0, 21, 3 ; セントウシャリョウS
    .apc:                              unit_data "APC       ", 10, 60, 6, 1, 3, 0, 10, 24, WEAPON_MACHINE_GUN_A, 9, WEAPON_EMPTY, 0, 0, MOVEMENT_PROFILE_06, 1, 4, 4, 4, 22, 22, 10, 22, 0, 13, 2 ; ソウコウユソウシャ
    .apc_s:                            unit_data "APC-S     ", 10, 70, 6, 1, 3, 0, 12, 26, WEAPON_ANTI_TANK_MISSILE_B, 2, WEAPON_MACHINE_GUN_A, 7, 0, MOVEMENT_PROFILE_06, 1, 4, 4, 4, 24, 24, 12, 24, 0, 15, 2 ; ソウコウユソウシャS
    .rocket_launcher:                  unit_data "ROCKETS   ", 10, 50, 5, 0, 1, 0, 42, 32, WEAPON_ROCKET_B, 5, WEAPON_EMPTY, 0, 0, MOVEMENT_PROFILE_06, 0, 4, 4, 4, 17, 17, 10, 17, 0, 12, 2 ; Rランチャ―
    .rocket_launcher_s:                unit_data "ROCKETS-S ", 10, 50, 4, 0, 1, 0, 48, 40, WEAPON_ROCKET_A, 3, WEAPON_EMPTY, 0, 0, MOVEMENT_PROFILE_06, 0, 4, 4, 4, 20, 20, 12, 20, 0, 12, 2 ; Rランチャ―S
    .anti_air_tank:                    unit_data "ANTI―AIR  ", 10, 60, 5, 0, 2, 0, 22, 30, WEAPON_SURFACE_AIR_MISSILE_B, 2, WEAPON_AUTOCANNON_B4, 5, 0, MOVEMENT_PROFILE_06, 0, 4, 4, 4, 18, 20, 20, 16, 0, 17, 3 ; タイクウセンシャ
    .mercenary_anti_air_missiles:      unit_data "M MISSILES", 10, 60, 6, 0, 2, 0, 38, 34, WEAPON_SURFACE_AIR_MISSILE_B, 3, WEAPON_AUTOCANNON_S, 4, 0, MOVEMENT_PROFILE_06, 0, 4, 4, 4, 30, 26, 20, 30, 0, 19, 2 ; ヨウヘイタイクウM
    .anti_air_missiles:                unit_data "MISSILES  ", 10, 50, 5, 0, 3, 0, 36, 32, WEAPON_SURFACE_AIR_MISSILE_A, 5, WEAPON_EMPTY, 0, 0, MOVEMENT_PROFILE_06, 0, 4, 4, 4, 17, 17, 12, 17, 0, 12, 2 ; タイクウミサイル
    .anti_air_missiles_s:              unit_data "MISSILES-S", 10, 50, 4, 0, 3, 0, 44, 36, WEAPON_SURFACE_AIR_MISSILE_S, 4, WEAPON_EMPTY, 0, 0, MOVEMENT_PROFILE_06, 0, 4, 4, 4, 20, 20, 14, 20, 0, 12, 2 ; タイクウミサイルS
    .artillery:                        unit_data "ARTILERY  ", 10, 50, 4, 0, 2, 0, 38, 44, WEAPON_CANNON_B, 5, WEAPON_EMPTY, 0, 0, MOVEMENT_PROFILE_06, 0, 4, 4, 4, 18, 18, 12, 18, 0, 10, 2 ; ジソウホウ
    .artillery_s:                      unit_data "ARTILERY-S", 10, 50, 3, 0, 2, 0, 45, 50, WEAPON_CANNON_A, 4, WEAPON_EMPTY, 0, 0, MOVEMENT_PROFILE_06, 0, 4, 4, 4, 21, 21, 14, 21, 0, 11, 2 ; ジソウホウS
    .ifv:                              unit_data "IFV       ", 10, 65, 6, 1, 1, 0, 18, 38, WEAPON_ANTI_TANK_MISSILE_B, 3, WEAPON_MACHINE_GUN_A, 9, 0, MOVEMENT_PROFILE_07, 1, 4, 4, 4, 30, 30, 14, 30, 0, 17, 2 ; ホヘイセントウシャ
    .ifv_s:                            unit_data "IFV-S     ", 10, 70, 6, 1, 1, 0, 20, 36, WEAPON_ANTI_TANK_MISSILE_A, 3, WEAPON_MACHINE_GUN_A, 9, 0, MOVEMENT_PROFILE_07, 1, 4, 4, 4, 35, 35, 16, 35, 0, 19, 2 ; ホヘイセントウシャS
    .tank_destroyer:                   unit_data "BUSTER    ", 10, 45, 6, 0, 1, 0, 20, 32, WEAPON_TANK_GUN_B, 8, WEAPON_MACHINE_GUN_A, 9, 0, MOVEMENT_PROFILE_07, 0, 4, 4, 4, 35, 35, 16, 40, 0, 24, 4 ; クチクセンシャ
    .tank_destroyer_s:                 unit_data "BUSTER-S  ", 10, 50, 6, 0, 1, 0, 28, 42, WEAPON_ANTI_TANK_MISSILE_A, 6, WEAPON_MACHINE_GUN_A, 9, 0, MOVEMENT_PROFILE_07, 0, 4, 4, 4, 40, 40, 18, 45, 0, 25, 4 ; クチクセンシャS
    .tank:                             unit_data "TANK      ", 10, 70, 5, 0, 1, 0, 35, 46, WEAPON_TANK_GUN_A, 9, WEAPON_MACHINE_GUN_A, 9, 0, MOVEMENT_PROFILE_07, 0, 4, 4, 4, 45, 45, 18, 50, 0, 19, 2 ; センシャ
    .mercenary_tank:                   unit_data "M TANK    ", 10, 60, 6, 0, 1, 0, 40, 48, WEAPON_TANK_GUN_S, 9, WEAPON_MACHINE_GUN_A, 9, 0, MOVEMENT_PROFILE_07, 0, 4, 4, 4, 52, 52, 22, 56, 0, 22, 2 ; ヨウヘイセンシャ
    .fighter_plane_a:                  unit_data "FIGHTER-A ", 10, 80, 12, 0, 7, 6, 85, 86, WEAPON_ANTI_AIR_MISSILE_B, 5, WEAPON_AUTOCANNON_B, 7, 2, MOVEMENT_PROFILE_08, 0, 3, 3, 3, 42, 48, 35, 44, 0, 32, 2 ; セントウキA
    .fighter_plane_b:                  unit_data "FIGHTER-B ", 10, 60, 11, 0, 6, 5, 65, 72, WEAPON_ANTI_AIR_MISSILE_B, 4, WEAPON_AUTOCANNON_B, 8, 2, MOVEMENT_PROFILE_08, 0, 3, 3, 3, 36, 42, 30, 38, 0, 29, 2 ; セントウキB
    .fighter_plane_s:                  unit_data "FIGHTER-S ", 10, 70, 13, 0, 8, 6, 90, 94, WEAPON_ANTI_AIR_MISSILE_A, 6, WEAPON_ANTI_AIR_MISSILE_B, 3, 2, MOVEMENT_PROFILE_08, 0, 3, 3, 3, 50, 56, 40, 52, 0, 36, 2 ; セントウキS
    .attack_plane_a:                   unit_data "ATTACKER-A", 10, 60, 11, 0, 6, 5, 85, 84, WEAPON_ANTI_AIR_MISSILE_B, 2, WEAPON_BOMBS, 3, 2, MOVEMENT_PROFILE_08, 0, 3, 3, 3, 38, 44, 28, 40, 0, 30, 2 ; コウゲキキA
    .attack_plane_b:                   unit_data "ATTACKER-B", 10, 50, 9, 0, 5, 4, 60, 76, WEAPON_AUTOCANNON_A, 9, WEAPON_ROCKET, 4, 2, MOVEMENT_PROFILE_09, 0, 3, 3, 3, 32, 38, 26, 34, 0, 27, 2 ; コウゲキキB
    .attack_plane_s:                   unit_data "ATTACKER-S", 10, 65, 10, 0, 7, 5, 120, 96, WEAPON_BOMBS, 5, WEAPON_EMPTY, 0, 2, MOVEMENT_PROFILE_08, 0, 3, 3, 3, 55, 61, 45, 57, 0, 30, 2 ; コウゲキキS
    .bomber:                           unit_data "BOMBER    ", 10, 99, 10, 0, 7, 5, 150, 100, WEAPON_ANTI_CITY_BOMB, 3, WEAPON_EMPTY, 0, 2, MOVEMENT_PROFILE_08, 0, 0, 0, 0, 32, 32, 30, 34, 0, 26, 2 ; バクゲキキ
    .mercenary_bomber:                 unit_data "M BOMBER  ", 10, 99, 11, 0, 8, 5, 180, 120, WEAPON_ANTI_CITY_BOMB, 4, WEAPON_EMPTY, 0, 2, MOVEMENT_PROFILE_08, 0, 0, 0, 0, 37, 37, 35, 39, 0, 28, 2 ; ヨウヘイバクゲキキ
    .transport_plane:                  unit_data "T PLANE   ", 10, 99, 8, 2, 5, 4, 55, 100, WEAPON_EMPTY, 0, WEAPON_EMPTY, 0, 2, MOVEMENT_PROFILE_08, 2, 0, 0, 0, 18, 18, 18, 18, 0, 21, 2 ; ユソウキ
    .refueling_plane:                  unit_data "S PLANE   ", 10, 99, 9, 0, 5, 4, 60, 100, WEAPON_SUPPLIES, 4, WEAPON_EMPTY, 0, 2, MOVEMENT_PROFILE_08, 0, 0, 0, 0, 18, 18, 18, 18, 0, 19, 2 ; キュウユキ
    .battle_helicopter:                unit_data "B COPTER  ", 10, 60, 6, 0, 4, 3, 50, 52, WEAPON_ROCKET, 5, WEAPON_AUTOCANNON_A, 7, 2, MOVEMENT_PROFILE_10, 0, 3, 3, 3, 27, 27, 20, 28, 0, 24, 3 ; コウゲキヘリ
    .battle_helicopter_s:              unit_data "B COPTER-S", 10, 70, 7, 0, 5, 3, 55, 55, WEAPON_ANTI_TANK_MISSILE_A, 2, WEAPON_AUTOCANNON_A, 9, 2, MOVEMENT_PROFILE_10, 0, 3, 3, 3, 32, 32, 24, 35, 0, 29, 3 ; コウゲキヘリS
    .anti_sub_helicopter:              unit_data "AS COPTER ", 10, 50, 6, 0, 4, 3, 38, 60, WEAPON_PROXIMITY_TORPEDO, 2, WEAPON_MACHINE_GUN_A, 7, 2, MOVEMENT_PROFILE_10, 0, 3, 3, 3, 22, 22, 20, 22, 0, 22, 3 ; タイセンヘリ
    .transport_helicopter:             unit_data "T COPTER  ", 10, 70, 7, 1, 3, 3, 19, 25, WEAPON_MACHINE_GUN_A, 7, WEAPON_EMPTY, 0, 2, MOVEMENT_PROFILE_10, 1, 3, 3, 3, 20, 20, 18, 20, 0, 22, 3 ; ユソウヘリ
    .transport_helicopter_s:           unit_data "T COPTER-S", 10, 65, 6, 2, 4, 3, 35, 48, WEAPON_ROCKET, 1, WEAPON_MACHINE_GUN_A, 9, 2, MOVEMENT_PROFILE_10, 1, 3, 3, 3, 23, 23, 20, 23, 0, 22, 2 ; ユソウヘリS
    .aegis_warship:                    unit_data "WARSHIP   ", 10, 99, 6, 0, 8, 0, 220, 180, WEAPON_ANTI_SHIP_MISSILE, 6, WEAPON_SURFACE_AIR_MISSILE_B, 9, 3, MOVEMENT_PROFILE_12, 0, 0, 0, 0, 75, 75, 75, 65, 52, 20, 2 ; イ―ジスカン
    .mercenary_missile_frigate:        unit_data "M FRIGATE ", 10, 99, 7, 0, 9, 0, 260, 200, WEAPON_ANTI_CITY_MISSILE, 4, WEAPON_SURFACE_AIR_MISSILE_S, 9, 3, MOVEMENT_PROFILE_12, 0, 0, 0, 0, 80, 80, 80, 70, 60, 24, 2 ; ヨウヘイMフリゲ―ト
    .large_carrier:                    unit_data "L CARRIER ", 10, 99, 5, 4, 7, 0, 350, 220, WEAPON_SURFACE_AIR_MISSILE_S, 9, WEAPON_AUTOCANNON_S, 9, 3, MOVEMENT_PROFILE_12, 3, 0, 0, 0, 70, 70, 65, 60, 48, 22, 2 ; オオガタクウボ
    .small_carrier:                    unit_data "CARRIER   ", 10, 80, 6, 3, 6, 0, 280, 150, WEAPON_SURFACE_AIR_MISSILE_A, 9, WEAPON_AUTOCANNON_B4, 9, 3, MOVEMENT_PROFILE_12, 3, 0, 0, 0, 65, 65, 58, 55, 42, 21, 2 ; コガタクウボ
    .transport_ship:                   unit_data "LANDER    ", 10, 70, 4, 3, 3, 0, 80, 130, WEAPON_AUTOCANNON_A, 9, WEAPON_EMPTY, 0, 3, MOVEMENT_PROFILE_11, 4, 0, 0, 0, 40, 40, 36, 35, 25, 17, 2 ; ユソウカン
    .supply_tanker:                    unit_data "S SHIP    ", 10, 90, 4, 0, 3, 0, 110, 140, WEAPON_SUPPLIES, 9, WEAPON_EMPTY, 0, 3, MOVEMENT_PROFILE_12, 0, 0, 0, 0, 30, 30, 24, 25, 22, 17, 2 ; ホキュウタンカ―
    .submarine:                        unit_data "SUB       ", 10, 60, 4, 0, 5, 0, 200, 160, WEAPON_TORPEDO, 3, WEAPON_EMPTY, 0, 4, MOVEMENT_PROFILE_12, 0, 0, 0, 0, 0, 0, 70, 0, 57, 17, 2 ; センスイカン
    .submarine_s:                      unit_data "SUB-S     ", 10, 99, 5, 0, 6, 0, 280, 180, WEAPON_ANTI_CITY_MISSILE, 2, WEAPON_PROXIMITY_TORPEDO, 4, 4, MOVEMENT_PROFILE_12, 0, 0, 0, 0, 0, 0, 80, 0, 66, 23, 3 ; センスイカンS
    .dummy:                            unit_data "DUMMY     ", 10, 99, 5, 0, 0, 0, 1, 1, WEAPON_NONE, 9, WEAPON_NONE, 9, 4, MOVEMENT_PROFILE_14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 1 ; DUMMY

    assert @ - UnitDataRecords == UNIT_DATA_COUNT * UNIT_DATA_RECORD_SIZE
    section_end $5256

; Weapon definitions
WeaponData::
    dw WeaponDataRecords.empty
    dw WeaponDataRecords.none
    dw WeaponDataRecords.machine_gun_b
    dw WeaponDataRecords.machine_gun_a
    dw WeaponDataRecords.autocannon_b
    dw WeaponDataRecords.autocannon_b4
    dw WeaponDataRecords.autocannon_a
    dw WeaponDataRecords.autocannon_s
    dw WeaponDataRecords.grenade
    dw WeaponDataRecords.tank_gun_b
    dw WeaponDataRecords.tank_gun_a
    dw WeaponDataRecords.tank_gun_s
    dw WeaponDataRecords.cannon_b
    dw WeaponDataRecords.cannon_a
    dw WeaponDataRecords.rocket_b
    dw WeaponDataRecords.rocket_a
    dw WeaponDataRecords.anti_tank_missile_b
    dw WeaponDataRecords.anti_tank_missile_a
    dw WeaponDataRecords.bombs
    dw WeaponDataRecords.anti_city_missile
    dw WeaponDataRecords.anti_city_bomb
    dw WeaponDataRecords.surface_air_missile_b
    dw WeaponDataRecords.surface_air_missile_a
    dw WeaponDataRecords.surface_air_missile_s
    dw WeaponDataRecords.anti_air_missile_b
    dw WeaponDataRecords.anti_air_missile_a
    dw WeaponDataRecords.anti_air_missile_s
    dw WeaponDataRecords.anti_ship_missile
    dw WeaponDataRecords.proximity_torpedo
    dw WeaponDataRecords.torpedo
    dw WeaponDataRecords.supplies
    dw WeaponDataRecords.material
    dw WeaponDataRecords.rocket

    assert @ - WeaponData == WEAPON_DATA_COUNT * 2
WeaponDataRecords::
                            ;  "Name----", Min, Max, Arm, Unarm, Air, Sea, Sub, Cost
    .empty:                 weapon_data "        ",  0, 0,  0,  0,   0,   0,   0,    0 ; -
    .none:                  weapon_data "NONE    ",  0, 0,  0,  0,   0,   0,   0,    0 ; ナシ
    .machine_gun_b:         weapon_data "M GUN-B ",  1, 1,  2, 10,   2,   1,   0,    1 ; マシンガンB
    .machine_gun_a:         weapon_data "M GUN-A ",  1, 1,  3, 16,   4,   1,   0,    2 ; マシンガンA
    .autocannon_b:          weapon_data "VULCAN-B",  1, 1,  8, 20,  22,   1,   0,    3 ; キカンホウB
    .autocannon_b4:         weapon_data "VULCAN-4",  1, 1, 13, 34,  34,   1,   0,   12 ; キカンホウB-4
    .autocannon_a:          weapon_data "VULCAN-A",  1, 1, 20, 33,  30,   1,   0,    3 ; キカンホウA
    .autocannon_s:          weapon_data "VULCAN-S",  1, 1, 18, 43,  40,   1,   0,    4 ; キカンホウS
    .grenade:               weapon_data "GRENADE ",  1, 1, 10, 20,   0,   5,   0,    8 ; グレネ―ド
    .tank_gun_b:            weapon_data "TANK-B  ",  1, 1, 30, 13,   0,  12,   0,   10 ; センシャホウB
    .tank_gun_a:            weapon_data "TANK-A  ",  1, 1, 40, 15,   0,  15,   0,   12 ; センシャホウA
    .tank_gun_s:            weapon_data "TANK-S  ",  1, 1, 50, 19,   0,  18,   0,   13 ; センシャホウS
    .cannon_b:              weapon_data "CANNON-B",  2, 5, 30, 16,   0,  22,   0,   15 ; カノンホウB
    .cannon_a:              weapon_data "CANNON-A",  3, 6, 38, 24,   0,  28,   0,   18 ; カノンホウA
    .rocket_b:              weapon_data "ROCKET-B",  2, 3, 27, 24,   0,  18,   0,   20 ; ロケットB
    .rocket_a:              weapon_data "ROCKET-A",  3, 4, 31, 28,   0,  20,   0,   22 ; ロケットA
    .anti_tank_missile_b:   weapon_data "AT MSL-B",  1, 1, 36,  0,   0,   0,   0,   11 ; ATミサイルB
    .anti_tank_missile_a:   weapon_data "AT MSL-A",  1, 2, 32,  0,   0,   0,   0,   13 ; ATミサイルA
    .bombs:                 weapon_data "BOMBS   ",  1, 1, 26, 28,   0,  40,   0,   18 ; バクダン
    .anti_city_missile:     weapon_data "AC MSL  ",  3, 7,  0,  0,   0,   0,   0,  100 ; タイトシミサイル (Review)
    .anti_city_bomb:        weapon_data "AC BOMB ",  0, 0,  0,  0,   0,   0,   0,  100 ; タイトシバクダン (Review)
    .surface_air_missile_b: weapon_data "SA MSL-B",  1, 1,  0,  0,  60,   0,   0,   40 ; チタイクウM-B (Review)
    .surface_air_missile_a: weapon_data "SA MSL-A",  2, 3,  0,  0,  55,   0,   0,   42 ; チタイクウM-A (Review)
    .surface_air_missile_s: weapon_data "SA MSL-S",  4, 6,  0,  0,  52,   0,   0,   44 ; チタイクウM-S (Review)
    .anti_air_missile_b:    weapon_data "AA MSL-B",  1, 1,  0,  0,  50,   0,   0,   40 ; タイクウM-B
    .anti_air_missile_a:    weapon_data "AA MSL-A",  3, 5,  0,  0,  47,   0,   0,   45 ; タイクウM-A
    .anti_air_missile_s:    weapon_data "AA MSL-S",  4, 7,  0,  0,  45,   0,   0,   50 ; タイクウM-S
    .anti_ship_missile:     weapon_data "AS MSL-S",  4, 7,  0,  0,   0,  99,   0,  100 ; タイカンミサイル (Review)
    .proximity_torpedo:     weapon_data "TORP    ",  1, 1,  0,  0,   0,  65,  85,   30 ; キンセツギョライ (Review)
    .torpedo:               weapon_data "TORPEDO ",  2, 4,  0,  0,   0,  50,  70,   35 ; ギョライ (Review)
    .supplies:              weapon_data "SUPPLIES",  0, 0,  0,  0,   0,   0,   0,   50 ; ホキュウブッシ
    .material:              weapon_data "MATERIAL",  0, 0,  0,  0,   0,   0,   0,    5 ; シザイ
    .rocket:                weapon_data "ROCKET  ",  1, 1, 18, 25,   0,  16,   0,   20 ; ロケットダン (Review)

    assert @ - WeaponDataRecords == WEAPON_DATA_COUNT * WEAPON_DATA_RECORD_SIZE
    section_end $54a8

MovementData::
    dw MovementDataProfiles.Profile00
    dw MovementDataProfiles.Profile01
    dw MovementDataProfiles.Profile02
    dw MovementDataProfiles.Profile03
    dw MovementDataProfiles.Profile04
    dw MovementDataProfiles.Profile05
    dw MovementDataProfiles.Profile06
    dw MovementDataProfiles.Profile07
    dw MovementDataProfiles.Profile08
    dw MovementDataProfiles.Profile09
    dw MovementDataProfiles.Profile10
    dw MovementDataProfiles.Profile11
    dw MovementDataProfiles.Profile12
    dw MovementDataProfiles.Profile13
    dw MovementDataProfiles.Profile14

    assert @ - MovementData == MOVEMENT_DATA_PROFILE_COUNT * 2
MovementDataProfiles::
.Profile00: movement_profile 0, 16, 16, 32, 16, 32, 16, 32, 16, 16, 32, 16, 16, 16, 16, 16, 32, 16, 32, 32, 32,  0, 32
.Profile01: movement_profile 0, 16, 16, 24, 16, 24, 16, 24, 16, 16, 24, 16, 16, 16, 16, 16, 32, 16, 24, 24, 32, 48, 32
.Profile02: movement_profile 0, 16, 16, 48, 16, 48, 16, 48, 16, 16, 48, 16, 24, 16, 16, 16,  0, 48, 48, 48,  0,  0,  0
.Profile03: movement_profile 0, 16, 16, 32, 16, 32, 16, 32, 16, 16, 32, 16, 24, 16, 16, 16, 64, 24, 48, 32,  0,  0,  0
.Profile04: movement_profile 0, 16, 16, 32, 16, 32, 16, 32, 16, 16, 32, 16, 24, 16, 16, 16, 64, 24, 48, 32, 48,  0, 48
.Profile05: movement_profile 0, 16, 16, 64, 16, 64, 16, 64, 16, 16, 64, 16, 16, 16, 16, 16, 64, 32, 32, 32, 48,  0, 32
.Profile06: movement_profile 0, 16, 16, 48, 16, 48, 16, 48, 16, 16, 48, 16, 16, 16, 16, 16,  0, 32, 48, 48,  0,  0,  0
.Profile07: movement_profile 0, 16, 16, 48, 16, 48, 16, 48, 16, 16, 48, 16, 16, 16, 16, 16,  0, 24, 32, 32, 64,  0, 64
.Profile08: movement_profile 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
.Profile09: movement_profile 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
.Profile10: movement_profile 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 24, 16, 16, 16, 16, 16, 16
.Profile11: movement_profile 0,  0,  0,  0,  0,  0,  0,  0,  0, 16, 16,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 16, 16
.Profile12: movement_profile 0,  0,  0,  0,  0,  0,  0,  0,  0, 16, 16,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 16,  0
.Profile13: movement_profile 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 24,  0,  0,  0,  0, 48, 48,  0,  0,  0,  0
.Profile14: movement_profile 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0, 24, 48, 48, 64,  0,  0

    assert @ - MovementDataProfiles == MOVEMENT_DATA_PROFILE_COUNT * MOVEMENT_DATA_PROFILE_SIZE
    section_end $8000  ; free real estate

; vim:nowrap
