include "include/macros.inc"
include "include/char_unit.inc"

setcharmap unit

section "unit.asm", romx[$4a43], bank[$12]

UnitData:
    dw .empty
    dw .infantry
    dw .missile_infantry
    dw .mercenary_infantry
    dw .construction_truck
    dw .supply_truck
    dw .supply_truck_s
    dw .transport_truck_s
    dw .transport_truck_s
    dw .combat_buggy
    dw .combat_buggy_s
    dw .combat_vehicle
    dw .combat_vehicle_s
    dw .apc
    dw .apc_s
    dw .rocket_launcher
    dw .rocket_launcher_s
    dw .anti_air_tank
    dw .mercenary_anti_air_missiles
    dw .anti_air_missiles
    dw .anti_air_missiles_s
    dw .artillery
    dw .artillery_s
    dw .ifv
    dw .ifv_s
    dw .tank_destroyer
    dw .tank_destroyer_s
    dw .tank
    dw .mercenary_tank
    dw .fighter_plane_a
    dw .fighter_plane_b
    dw .fighter_plane_s
    dw .attack_plane_a
    dw .attack_plane_b
    dw .attack_plane_s
    dw .bomber
    dw .mercenary_bomber
    dw .transport_plane
    dw .refueling_plane
    dw .battle_helicopter
    dw .battle_helicopter_s
    dw .anti_sub_helicopter
    dw .transport_helicopter
    dw .transport_helicopter_s
    dw .aegis_warship
    dw .mercenary_missile_frigate
    dw .large_carrier
    dw .small_carrier
    dw .transport_ship
    dw .supply_tanker
    dw .submarine
    dw .submarine_s
    dw .dummy

                                    ;  "Name      ",  HP, FUEL, Move, T, ?, Fuel,   Gold,    Mtl,  Wep 1,  Wep 2, Type, Move, Transport,            Defense, Focus, Loss, ?
    .empty:                         db "          ",  10,   99,    6, 0, 5,    0,  99, 0,  99, 0,  1, 10,  0,  0,    1,    1,   5, 0, 0,  0, 99, 99, 99, 99,    99,    0, 0 ; -
    .infantry:                      db "INFANTRY  ",  10,   99,    3, 0, 3,    0,   1, 0,  10, 0,  2,  9,  0,  0,    1,    0,   0, 1, 2,  4, 10, 10, 12, 10,     0,   10, 3 ; ホヘイ
    .missile_infantry:              db "MECH      ",  10,   70,    2, 0, 3,    0,   2, 0,  12, 0,  17, 1,  2,  6,    1,    0,   0, 1, 2,  4, 14, 12, 16, 14,     0,   13, 6 ; ミサイルホヘイ
    .mercenary_infantry:            db "MERCENARY ",  10,   85,    4, 0, 3,    0,   6, 0,  14, 0,  8,  2,  2,  8,    1,    1,   0, 1, 2,  4, 16, 16, 18, 16,     0,   16, 3 ; トクシュホヘイ
    .construction_truck:            db "BULLDOZER ",  10,   50,    5, 0, 1,    0,   8, 0,  20, 0,  31, 5,  2,  7,    1,    2,   0, 2, 4,  4, 14, 14, 14, 14,     0,   12, 2 ; コウサクシャ
    .supply_truck:                  db "S TRUCK   ",  10,   99,    6, 0, 1,    0,   6, 0,  22, 0,  30, 5,  0,  0,    1,    2,   0, 2, 4,  4, 14, 14, 12, 16,     0,   12, 2 ; ホキュウシャ
    .supply_truck_s:                db "S TRUCK-S ",  10,   99,    5, 0, 1,    0,   8, 0,  24, 0,  30, 8,  0,  0,    1,    2,   0, 2, 4,  4, 16, 16, 12, 16,     0,   15, 3 ; ホキュウシャS
    .transport_truck:               db "T TRUCK   ",  10,   50,    7, 1, 1,    0,   5, 0,  20, 0,  2,  7,  0,  0,    1,    3,   1, 2, 4,  4, 14, 14, 12, 14,     0,   14, 2 ; ユソウトラック
    .transport_truck_s:             db "T TRUCK-S ",  10,   60,    7, 1, 1,    0,   7, 0,  22, 0,  4,  5,  2,  9,    1,    3,   1, 2, 4,  4, 16, 16, 12, 16,     0,   15, 2 ; ユソウトラックS
    .combat_buggy:                  db "BUGGY     ",  10,   50,    7, 0, 5,    0,   5, 0,  16, 0,  8,  2,  2,  5,    1,    4,   0, 2, 4,  4, 12, 12, 13, 12,     0,   22, 3 ; コンバットバギ―
    .combat_buggy_s:                db "BUGGY-S   ",  10,   45,    7, 0, 6,    0,   7, 0,  18, 0,  16, 3,  3,  7,    1,    4,   0, 2, 4,  4, 15, 15, 16, 15,     0,   25, 3 ; コンバットバギ―S
    .combat_vehicle:                db "HUMVEE    ",  10,   50,    7, 0, 4,    0,   7, 0,  17, 0,  16, 2,  2,  9,    1,    5,   0, 2, 4,  4, 14, 14, 14, 14,     0,   21, 3 ; セントウシャリョウ
    .combat_vehicle_s:              db "HUMVEE-S  ",  10,   45,    6, 0, 5,    0,   8, 0,  19, 0,  16, 3,  4,  7,    1,    5,   0, 2, 4,  4, 17, 17, 16, 17,     0,   21, 3 ; セントウシャリョウS
    .apc:                           db "APC       ",  10,   60,    6, 1, 3,    0,  10, 0,  24, 0,  3,  9,  0,  0,    0,    6,   1, 4, 4,  4, 22, 22, 10, 22,     0,   13, 2 ; ソウコウユソウシャ
    .apc_s:                         db "APC-S     ",  10,   70,    6, 1, 3,    0,  12, 0,  26, 0,  16, 2,  3,  7,    0,    6,   1, 4, 4,  4, 24, 24, 12, 24,     0,   15, 2 ; ソウコウユソウシャS
    .rocket_launcher:               db "ROCKETS   ",  10,   50,    5, 0, 1,    0,  42, 0,  32, 0,  14, 5,  0,  0,    0,    6,   0, 4, 4,  4, 17, 17, 10, 17,     0,   12, 2 ; Rランチャ―
    .rocket_launcher_s:             db "ROCKETS-S ",  10,   50,    4, 0, 1,    0,  48, 0,  40, 0,  15, 3,  0,  0,    0,    6,   0, 4, 4,  4, 20, 20, 12, 20,     0,   12, 2 ; Rランチャ―S
    .anti_air_tank:                 db "ANTI―AIR  ",  10,   60,    5, 0, 2,    0,  22, 0,  30, 0,  21, 2,  5,  5,    0,    6,   0, 4, 4,  4, 18, 20, 20, 16,     0,   17, 3 ; タイクウセンシャ
    .mercenary_anti_air_missiles:   db "M MISSILES",  10,   60,    6, 0, 2,    0,  38, 0,  34, 0,  21, 3,  7,  4,    0,    6,   0, 4, 4,  4, 30, 26, 20, 30,     0,   19, 2 ; ヨウヘイタイクウM
    .anti_air_missiles:             db "MISSILES  ",  10,   50,    5, 0, 3,    0,  36, 0,  32, 0,  22, 5,  0,  0,    0,    6,   0, 4, 4,  4, 17, 17, 12, 17,     0,   12, 2 ; タイクウミサイル
    .anti_air_missiles_s:           db "MISSILES-S",  10,   50,    4, 0, 3,    0,  44, 0,  36, 0,  23, 4,  0,  0,    0,    6,   0, 4, 4,  4, 20, 20, 14, 20,     0,   12, 2 ; タイクウミサイルS
    .artillery:                     db "ARTILERY  ",  10,   50,    4, 0, 2,    0,  38, 0,  44, 0,  12, 5,  0,  0,    0,    6,   0, 4, 4,  4, 18, 18, 12, 18,     0,   10, 2 ; ジソウホウ
    .artillery_s:                   db "ARTILERY-S",  10,   50,    3, 0, 2,    0,  45, 0,  50, 0,  13, 4,  0,  0,    0,    6,   0, 4, 4,  4, 21, 21, 14, 21,     0,   11, 2 ; ジソウホウS
    .ifv:                           db "IFV       ",  10,   65,    6, 1, 1,    0,  18, 0,  38, 0,  16, 3,  3,  9,    0,    7,   1, 4, 4,  4, 30, 30, 14, 30,     0,   17, 2 ; ホヘイセントウシャ
    .ifv_s:                         db "IFV-S     ",  10,   70,    6, 1, 1,    0,  20, 0,  36, 0,  17, 3,  3,  9,    0,    7,   1, 4, 4,  4, 35, 35, 16, 35,     0,   19, 2 ; ホヘイセントウシャS
    .tank_destroyer:                db "BUSTER    ",  10,   45,    6, 0, 1,    0,  20, 0,  32, 0,   9, 8,  3,  9,    0,    7,   0, 4, 4,  4, 35, 35, 16, 40,     0,   24, 4 ; クチクセンシャ
    .tank_destroyer_s:              db "BUSTER-S  ",  10,   50,    6, 0, 1,    0,  28, 0,  42, 0,  17, 6,  3,  9,    0,    7,   0, 4, 4,  4, 40, 40, 18, 45,     0,   25, 4 ; クチクセンシャS
    .tank:                          db "TANK      ",  10,   70,    5, 0, 1,    0,  35, 0,  46, 0,  10, 9,  3,  9,    0,    7,   0, 4, 4,  4, 45, 45, 18, 50,     0,   19, 2 ; センシャ
    .mercenary_tank:                db "M TANK    ",  10,   60,    6, 0, 1,    0,  40, 0,  48, 0,  11, 9,  3,  9,    0,    7,   0, 4, 4,  4, 52, 52, 22, 56,     0,   22, 2 ; ヨウヘイセンシャ
    .fighter_plane_a:               db "FIGHTER-A ",  10,   80,   12, 0, 7,    6,  85, 0,  86, 0,  24, 5,  4,  7,    2,    8,   0, 3, 3,  3, 42, 48, 35, 44,     0,   32, 2 ; セントウキA
    .fighter_plane_b:               db "FIGHTER-B ",  10,   60,   11, 0, 6,    5,  65, 0,  72, 0,  24, 4,  4,  8,    2,    8,   0, 3, 3,  3, 36, 42, 30, 38,     0,   29, 2 ; セントウキB
    .fighter_plane_s:               db "FIGHTER-S ",  10,   70,   13, 0, 8,    6,  90, 0,  94, 0,  25, 6, 24,  3,    2,    8,   0, 3, 3,  3, 50, 56, 40, 52,     0,   36, 2 ; セントウキS
    .attack_plane_a:                db "ATTACKER-A",  10,   60,   11, 0, 6,    5,  85, 0,  84, 0,  24, 2, 18,  3,    2,    8,   0, 3, 3,  3, 38, 44, 28, 40,     0,   30, 2 ; コウゲキキA
    .attack_plane_b:                db "ATTACKER-B",  10,   50,    9, 0, 5,    4,  60, 0,  76, 0,   6, 9, 32,  4,    2,    9,   0, 3, 3,  3, 32, 38, 26, 34,     0,   27, 2 ; コウゲキキB
    .attack_plane_s:                db "ATTACKER-S",  10,   65,   10, 0, 7,    5, 120, 0,  96, 0,  18, 5,  0,  0,    2,    8,   0, 3, 3,  3, 55, 61, 45, 57,     0,   30, 2 ; コウゲキキS
    .bomber:                        db "BOMBER    ",  10,   99,   10, 0, 7,    5, 150, 0, 100, 0,  20, 3,  0,  0,    2,    8,   0, 0, 0,  0, 32, 32, 30, 34,     0,   26, 2 ; バクゲキキ
    .mercenary_bomber:              db "M BOMBER  ",  10,   99,   11, 0, 8,    5, 180, 0, 120, 0,  20, 4,  0,  0,    2,    8,   0, 0, 0,  0, 37, 37, 35, 39,     0,   28, 2 ; ヨウヘイバクゲキキ
    .transport_plane:               db "T PLANE   ",  10,   99,    8, 2, 5,    4,  55, 0, 100, 0,   0, 0,  0,  0,    2,    8,   2, 0, 0,  0, 18, 18, 18, 18,     0,   21, 2 ; ユソウキ
    .refueling_plane:               db "S PLANE   ",  10,   99,    9, 0, 5,    4,  60, 0, 100, 0,  30, 4,  0,  0,    2,    8,   0, 0, 0,  0, 18, 18, 18, 18,     0,   19, 2 ; キュウユキ
    .battle_helicopter:             db "B COPTER  ",  10,   60,    6, 0, 4,    3,  50, 0,  52, 0,  32, 5,  6,  7,    2,   10,   0, 3, 3,  3, 27, 27, 20, 28,     0,   24, 3 ; コウゲキヘリ
    .battle_helicopter_s:           db "B COPTER-S",  10,   70,    7, 0, 5,    3,  55, 0,  55, 0,  17, 2,  6,  9,    2,   10,   0, 3, 3,  3, 32, 32, 24, 35,     0,   29, 3 ; コウゲキヘリS
    .anti_sub_helicopter:           db "AS COPTER ",  10,   50,    6, 0, 4,    3,  38, 0,  60, 0,  28, 2,  3,  7,    2,   10,   0, 3, 3,  3, 22, 22, 20, 22,     0,   22, 3 ; タイセンヘリ
    .transport_helicopter:          db "T COPTER  ",  10,   70,    7, 1, 3,    3,  19, 0,  25, 0,   3, 7,  0,  0,    2,   10,   1, 3, 3,  3, 20, 20, 18, 20,     0,   22, 3 ; ユソウヘリ
    .transport_helicopter_s:        db "T COPTER-S",  10,   65,    6, 2, 4,    3,  35, 0,  48, 0,  32, 1,  3,  9,    2,   10,   1, 3, 3,  3, 23, 23, 20, 23,     0,   22, 2 ; ユソウヘリS
    .aegis_warship:                 db "WARSHIP   ",  10,   99,    6, 0, 8,    0, 220, 0, 180, 0,  27, 6, 21,  9,    3,   12,   0, 0, 0,  0, 75, 75, 75, 65,    52,   20, 2 ; イ―ジスカン
    .mercenary_missile_frigate:     db "ヨウヘイMフリゲ―ト", 10,   99,    7, 0, 9,    0,   4, 1, 200, 0,  19, 4, 23,  9,    3,   12,   0, 0, 0,  0, 80, 80, 80, 70,    60,   24, 2  ; ヨウヘイMフリゲ―ト
    .large_carrier:                 db "L CARRIER ",  10,   99,    5, 4, 7,    0,  94, 1, 220, 0,  23, 9,  7,  9,    3,   12,   3, 0, 0,  0, 70, 70, 65, 60,    48,   22, 2 ; オオガタクウボ
    .small_carrier:                 db "CARRIER   ",  10,   80,    6, 3, 6,    0,  24, 1, 150, 0,  22, 9,  5,  9,    3,   12,   3, 0, 0,  0, 65, 65, 58, 55,    42,   21, 2 ; コガタクウボ
    .transport_ship:                db "LANDER    ",  10,   70,    4, 3, 3,    0,  80, 0, 130, 0,   6, 9,  0,  0,    3,   11,   4, 0, 0,  0, 40, 40, 36, 35,    25,   17, 2 ; ユソウカン
    .supply_tanker:                 db "S SHIP    ",  10,   90,    4, 0, 3,    0, 110, 0, 140, 0,  30, 9,  0,  0,    3,   12,   0, 0, 0,  0, 30, 30, 24, 25,    22,   17, 2 ; ホキュウタンカ―
    .submarine:                     db "SUB       ",  10,   60,    4, 0, 5,    0, 200, 0, 160, 0,  29, 3,  0,  0,    4,   12,   0, 0, 0,  0,  0,  0, 70,  0,    57,   17, 2 ; センスイカン
    .submarine_s:                   db "SUB-S     ",  10,   99,    5, 0, 6,    0,  24, 1, 180, 0,  19, 2, 28,  4,    4,   12,   0, 0, 0,  0,  0,  0, 80,  0,    66,   23, 3 ; センスイカンS
    .dummy:                         db "DUMMY     ",  10,   99,    5, 0, 0,    0,   1, 0,   1, 0,   1, 9,  1,  9,    4,   14,   0, 0, 0,  0,  0,  0,  0,  0,     0,   99, 1 ; DUMMY

    section_end $5256

; Weapon Names
WeaponData:
    dw .empty
    dw .none
    dw .machine_gun_b
    dw .machine_gun_a
    dw .autocannon_b
    dw .autocannon_b4
    dw .autocannon_a
    dw .autocannon_s
    dw .grenade
    dw .tank_gun_b
    dw .tank_gun_a
    dw .tank_gun_s
    dw .cannon_b
    dw .cannon_a
    dw .rocket_b
    dw .rocket_a
    dw .anti_tank_missile_b
    dw .anti_tank_missile_a
    dw .bombs
    dw .anti_city_missile
    dw .anti_city_bomb
    dw .surface_air_missile_b
    dw .surface_air_missile_a
    dw .surface_air_missile_s
    dw .anti_air_missile_b
    dw .anti_air_missile_a
    dw .anti_air_missile_s
    dw .anti_ship_missile
    dw .proximity_torpedo
    dw .torpedo
    dw .supplies
    dw .material
    dw .rocket

                            ;  "Name----", Range,  A, UA, Sky, Sea, Sub, Cost
    .empty:                 db "        ",  0, 0,  0,  0,   0,   0,   0,    0 ; -
    .none:                  db "NONE    ",  0, 0,  0,  0,   0,   0,   0,    0 ; ナシ
    .machine_gun_b:         db "M GUN-B ",  1, 1,  2, 10,   2,   1,   0,    1 ; マシンガンB
    .machine_gun_a:         db "M GUN-A ",  1, 1,  3, 16,   4,   1,   0,    2 ; マシンガンA
    .autocannon_b:          db "VULCAN-B",  1, 1,  8, 20,  22,   1,   0,    3 ; キカンホウB
    .autocannon_b4:         db "VULCAN-4",  1, 1, 13, 34,  34,   1,   0,   12 ; キカンホウB-4
    .autocannon_a:          db "VULCAN-A",  1, 1, 20, 33,  30,   1,   0,    3 ; キカンホウA
    .autocannon_s:          db "VULCAN-S",  1, 1, 18, 43,  40,   1,   0,    4 ; キカンホウS
    .grenade:               db "GRENADE ",  1, 1, 10, 20,   0,   5,   0,    8 ; グレネ―ド
    .tank_gun_b:            db "TANK-B  ",  1, 1, 30, 13,   0,  12,   0,   10 ; センシャホウB
    .tank_gun_a:            db "TANK-A  ",  1, 1, 40, 15,   0,  15,   0,   12 ; センシャホウA
    .tank_gun_s:            db "TANK-S  ",  1, 1, 50, 19,   0,  18,   0,   13 ; センシャホウS
    .cannon_b:              db "CANNON-B",  2, 5, 30, 16,   0,  22,   0,   15 ; カノンホウB
    .cannon_a:              db "CANNON-A",  3, 6, 38, 24,   0,  28,   0,   18 ; カノンホウA
    .rocket_b:              db "ROCKET-B",  2, 3, 27, 24,   0,  18,   0,   20 ; ロケットB
    .rocket_a:              db "ROCKET-A",  3, 4, 31, 28,   0,  20,   0,   22 ; ロケットA
    .anti_tank_missile_b:   db "AT MSL-B",  1, 1, 36,  0,   0,   0,   0,   11 ; ATミサイルB
    .anti_tank_missile_a:   db "AT MSL-A",  1, 2, 32,  0,   0,   0,   0,   13 ; ATミサイルA
    .bombs:                 db "BOMBS   ",  1, 1, 26, 28,   0,  40,   0,   18 ; バクダン
    .anti_city_missile:     db "AC MSL",    3, 7,  0,  0,   0,   0,   0,  100 ; タイトシミサイル
    .anti_city_bomb:        db "AC BOMB",   0, 0,  0,  0,   0,   0,   0,  100 ; タイトシバクダン
    .surface_air_missile_b: db "SA MSL-B",  1, 1,  0,  0,  60,   0,   0,   40 ; チタイクウM-B
    .surface_air_missile_a: db "SA MSL-A",  2, 3,  0,  0,  55,   0,   0,   42 ; チタイクウM-A
    .surface_air_missile_s: db "SA MSL-S",  4, 6,  0,  0,  52,   0,   0,   44 ; チタイクウM-S
    .anti_air_missile_b:    db "AA MSL-B",  1, 1,  0,  0,  50,   0,   0,   40 ; タイクウM-B
    .anti_air_missile_a:    db "AA MSL-A",  3, 5,  0,  0,  47,   0,   0,   45 ; タイクウM-A
    .anti_air_missile_s:    db "AA MSL-S",  4, 7,  0,  0,  45,   0,   0,   50 ; タイクウM-S
    .anti_ship_missile:     db "AS MSL-S",  4, 7,  0,  0,   0,  99,   0,  100 ; タイカンミサイル
    .proximity_torpedo:     db "TORP-S",    1, 1,  0,  0,   0,  65,  85,   30 ; キンセツギョライ
    .torpedo:               db "TORPEDO",   2, 4,  0,  0,   0,  50,  70,   35 ; ギョライ
    .supplies:              db "SUPPLIES",  0, 0,  0,  0,   0,   0,   0,   50 ; ホキュウブッシ
    .material:              db "MATERIAL",  0, 0,  0,  0,   0,   0,   0,    5 ; シザイ
    .rocket:                db "ROCKET-S",  1, 1, 18, 25,   0,  16,   0,   20 ; ロケットダン

    section_end $54a8

MovementData:
    dw ._54c6
    dw ._54dd
    dw ._54f4
    dw ._550b
    dw ._5522
    dw ._5539
    dw ._5550
    dw ._5567
    dw ._557e
    dw ._5595
    dw ._55ac
    dw ._55c3
    dw ._55da
    dw ._55f1
    dw ._5608

._54c6: db 0, 16, 16, 32, 16, 32, 16, 32, 16, 16, 32, 16, 16, 16, 16, 16, 32, 16, 32, 32, 32,  0, 32
._54dd: db 0, 16, 16, 24, 16, 24, 16, 24, 16, 16, 24, 16, 16, 16, 16, 16, 32, 16, 24, 24, 32, 48, 32
._54f4: db 0, 16, 16, 48, 16, 48, 16, 48, 16, 16, 48, 16, 24, 16, 16, 16,  0, 48, 48, 48,  0,  0,  0
._550b: db 0, 16, 16, 32, 16, 32, 16, 32, 16, 16, 32, 16, 24, 16, 16, 16, 64, 24, 48, 32,  0,  0,  0
._5522: db 0, 16, 16, 32, 16, 32, 16, 32, 16, 16, 32, 16, 24, 16, 16, 16, 64, 24, 48, 32, 48,  0, 48
._5539: db 0, 16, 16, 64, 16, 64, 16, 64, 16, 16, 64, 16, 16, 16, 16, 16, 64, 32, 32, 32, 48,  0, 32
._5550: db 0, 16, 16, 48, 16, 48, 16, 48, 16, 16, 48, 16, 16, 16, 16, 16,  0, 32, 48, 48,  0,  0,  0
._5567: db 0, 16, 16, 48, 16, 48, 16, 48, 16, 16, 48, 16, 16, 16, 16, 16,  0, 24, 32, 32, 64,  0, 64
._557e: db 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
._5595: db 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
._55ac: db 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 24, 16, 16, 16, 16, 16, 16
._55c3: db 0,  0,  0,  0,  0,  0,  0,  0,  0, 16, 16,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 16, 16
._55da: db 0,  0,  0,  0,  0,  0,  0,  0,  0, 16, 16,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 16,  0
._55f1: db 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 24,  0,  0,  0,  0, 48, 48,  0,  0,  0,  0
._5608: db 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0, 24, 48, 48, 64,  0,  0

    section_end $8000  ; free real estate
