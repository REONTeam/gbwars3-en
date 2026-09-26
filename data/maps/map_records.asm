include "macros/macros.inc"
include "constants/unit_constants.inc"
include "charmaps/char_main.inc"

; Source-backed map records

section "Map Record - Demo 02", romx[$4000], bank[$29]
MapRecord_Demo02::
    map_record_header .body, MapRecord_Demo02_End, $11
.body:
MapName_Demo02:
    ; Retail: db "デモ02[ED][ED]"
    db "DEMO02  "
    ; Four positional map parameters; semantics remain unassigned.
    map_record_parameters $00, $00, $00, $00
    db 20, 20 ; width, height

.terrain:
    db $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29
    db $29, $29, $29, $29, $2a, $2a, $29, $2a, $24, $24, $24, $24, $2a, $2a, $29, $29, $29, $29, $29, $29
    db $29, $29, $29, $26, $20, $26, $2a, $2a, $24, $24, $24, $24, $25, $25, $2a, $29, $29, $29, $29, $29
    db $29, $29, $29, $26, $20, $25, $25, $24, $24, $24, $24, $24, $19, $25, $2a, $29, $29, $29, $29, $29
    db $29, $29, $27, $26, $25, $20, $25, $25, $24, $24, $24, $24, $21, $24, $2a, $2a, $2a, $29, $29, $29
    db $29, $27, $27, $27, $20, $02, $21, $04, $25, $24, $25, $21, $24, $28, $28, $25, $25, $29, $29, $29
    db $29, $27, $27, $25, $20, $25, $20, $21, $25, $25, $25, $21, $20, $28, $28, $25, $25, $25, $29, $29
    db $29, $2a, $27, $25, $06, $21, $01, $20, $06, $21, $21, $20, $17, $28, $20, $25, $25, $25, $29, $29
    db $29, $29, $2a, $2a, $20, $20, $20, $21, $20, $25, $25, $21, $22, $22, $21, $25, $25, $25, $2a, $29
    db $29, $29, $29, $2a, $20, $02, $20, $04, $25, $24, $24, $20, $28, $20, $21, $20, $25, $2a, $29, $29
    db $29, $29, $29, $2a, $24, $25, $25, $25, $25, $24, $24, $25, $28, $20, $11, $20, $11, $20, $2a, $29
    db $29, $29, $29, $2a, $24, $20, $20, $20, $24, $24, $24, $24, $24, $24, $25, $21, $20, $20, $29, $29
    db $29, $29, $29, $2a, $24, $24, $25, $20, $20, $20, $24, $24, $24, $0d, $25, $0c, $20, $0d, $2a, $29
    db $29, $29, $29, $2a, $2a, $24, $25, $20, $20, $20, $20, $24, $24, $25, $25, $21, $20, $26, $29, $29
    db $29, $29, $29, $29, $29, $2a, $2a, $20, $17, $20, $20, $20, $20, $25, $0f, $21, $0f, $26, $29, $29
    db $29, $29, $29, $29, $29, $29, $2a, $25, $20, $20, $20, $20, $20, $20, $20, $20, $26, $29, $29, $29
    db $29, $29, $29, $29, $29, $29, $29, $29, $2a, $20, $25, $20, $25, $20, $25, $2a, $2a, $29, $29, $29
    db $29, $29, $29, $29, $29, $29, $29, $29, $2a, $2a, $2a, $2a, $2a, $2a, $29, $29, $29, $29, $29, $29
    db $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29
    db $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29

    ; 17 three-byte initial-unit placements: X, Y, encoded unit/side.
.initial_units:
    map_initial_unit $01, $03, UNIT_TYPE_LARGE_CARRIER, UNIT_SIDE_1
    map_initial_unit $0c, $03, UNIT_TYPE_INFANTRY, UNIT_SIDE_1
    map_initial_unit $07, $04, UNIT_TYPE_BATTLE_HELICOPTER, UNIT_SIDE_0
    map_initial_unit $0c, $04, UNIT_TYPE_MISSILE_INFANTRY, UNIT_SIDE_1
    map_initial_unit $05, $05, UNIT_TYPE_ANTI_AIR_MISSILES, UNIT_SIDE_0
    map_initial_unit $04, $06, UNIT_TYPE_BOMBER, UNIT_SIDE_0
    map_initial_unit $04, $07, UNIT_TYPE_TRANSPORT_PLANE, UNIT_SIDE_0
    map_initial_unit $0e, $0a, UNIT_TYPE_ATTACK_PLANE_A, UNIT_SIDE_1
    map_initial_unit $10, $0a, UNIT_TYPE_FIGHTER_PLANE_A, UNIT_SIDE_1
    map_initial_unit $07, $0b, UNIT_TYPE_ARTILLERY, UNIT_SIDE_0
    map_initial_unit $07, $0c, UNIT_TYPE_APC, UNIT_SIDE_0
    map_initial_unit $08, $0d, UNIT_TYPE_COMBAT_VEHICLE, UNIT_SIDE_0
    map_initial_unit $0d, $0e, UNIT_TYPE_ANTI_AIR_TANK, UNIT_SIDE_1
    map_initial_unit $08, $0f, UNIT_TYPE_TANK, UNIT_SIDE_0
    map_initial_unit $0b, $0f, UNIT_TYPE_IFV, UNIT_SIDE_1
    map_initial_unit $0d, $0f, UNIT_TYPE_ROCKET_LAUNCHER, UNIT_SIDE_1
    map_initial_unit $12, $11, UNIT_TYPE_SUBMARINE_S, UNIT_SIDE_0
    db $ff
MapRecord_Demo02_End::
    assert @ == $41f2
