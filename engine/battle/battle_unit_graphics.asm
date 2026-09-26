include "macros/macros.inc"
include "constants/unit_constants.inc"

; Bank $16 battle-unit pointer/layout layer. The runtime indexes this
; table by UnitData type 0-51. UNIT_TYPE_DUMMY (52) has no battle entry.
section "Battle Unit Layout Lookup", romx[$4a1c], bank[$16]

BattleUnit_GetLayoutPointer::
    push af
    ld a, b
    ld [wBattleUnitSide], a
    pop af
    sla a
    ld h, 0
    ld l, a
    ld bc, BattleUnitLayoutPointers
    add hl, bc
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld h, d
    ld l, e
    ret

BattleUnit_GetLayoutPointerAlt::
    push af
    ld a, b
    ld [wBattleUnitSideAlt], a
    pop af
    sla a
    ld h, 0
    ld l, a
    ld bc, BattleUnitLayoutPointers
    add hl, bc
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld h, d
    ld l, e
    ret

    assert @ == $4a48

BattleUnitLayoutPointers:
    dw BattleUnitLayout_00 ; empty
    dw BattleUnitLayout_01 ; infantry
    dw BattleUnitLayout_02 ; missile_infantry
    dw BattleUnitLayout_03 ; mercenary_infantry
    dw BattleUnitLayout_04 ; construction_truck
    dw BattleUnitLayout_05 ; supply_truck
    dw BattleUnitLayout_06 ; supply_truck_s
    dw BattleUnitLayout_07 ; transport_truck
    dw BattleUnitLayout_08 ; transport_truck_s
    dw BattleUnitLayout_09 ; combat_buggy
    dw BattleUnitLayout_10 ; combat_buggy_s
    dw BattleUnitLayout_11 ; combat_vehicle
    dw BattleUnitLayout_12 ; combat_vehicle_s
    dw BattleUnitLayout_13 ; apc
    dw BattleUnitLayout_14 ; apc_s
    dw BattleUnitLayout_15 ; rocket_launcher
    dw BattleUnitLayout_16 ; rocket_launcher_s
    dw BattleUnitLayout_17 ; anti_air_tank
    dw BattleUnitLayout_18 ; mercenary_anti_air_missiles
    dw BattleUnitLayout_19 ; anti_air_missiles
    dw BattleUnitLayout_20 ; anti_air_missiles_s
    dw BattleUnitLayout_21 ; artillery
    dw BattleUnitLayout_22 ; artillery_s
    dw BattleUnitLayout_23 ; ifv
    dw BattleUnitLayout_24 ; ifv_s
    dw BattleUnitLayout_25 ; tank_destroyer
    dw BattleUnitLayout_26 ; tank_destroyer_s
    dw BattleUnitLayout_27 ; tank
    dw BattleUnitLayout_28 ; mercenary_tank
    dw BattleUnitLayout_29 ; fighter_plane_a
    dw BattleUnitLayout_30 ; fighter_plane_b
    dw BattleUnitLayout_31 ; fighter_plane_s
    dw BattleUnitLayout_32 ; attack_plane_a
    dw BattleUnitLayout_33 ; attack_plane_b
    dw BattleUnitLayout_34 ; attack_plane_s
    dw BattleUnitLayout_35 ; bomber
    dw BattleUnitLayout_36 ; mercenary_bomber
    dw BattleUnitLayout_37 ; transport_plane
    dw BattleUnitLayout_38 ; refueling_plane
    dw BattleUnitLayout_39 ; battle_helicopter
    dw BattleUnitLayout_40 ; battle_helicopter_s
    dw BattleUnitLayout_41 ; anti_sub_helicopter
    dw BattleUnitLayout_42 ; transport_helicopter
    dw BattleUnitLayout_43 ; transport_helicopter_s
    dw BattleUnitLayout_44 ; aegis_warship
    dw BattleUnitLayout_45 ; mercenary_missile_frigate
    dw BattleUnitLayout_46 ; large_carrier
    dw BattleUnitLayout_47 ; small_carrier
    dw BattleUnitLayout_48 ; transport_ship
    dw BattleUnitLayout_49 ; supply_tanker
    dw BattleUnitLayout_50 ; submarine
    dw BattleUnitLayout_51 ; submarine_s
    assert @ == $4ab0

BattleUnitLayout_00: ; empty
    db $ff, $ff, $ff, $ff

BattleUnitLayout_01: ; infantry
    db $02, $07, $05, $07, $01, $09, $04, $09, $02, $0b, $05, $0b, $01, $0d, $04, $0d
    db $02, $0f, $05, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_02: ; missile_infantry
    db $02, $07, $05, $07, $01, $09, $04, $09, $02, $0b, $05, $0b, $01, $0d, $04, $0d
    db $02, $0f, $05, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_03: ; mercenary_infantry
    db $01, $08, $04, $08, $00, $0a, $03, $0a, $01, $0c, $04, $0c, $00, $0e, $03, $0e
    db $01, $10, $04, $10, $ff, $ff, $ff, $ff, $10, $08, $0d, $08, $11, $0a, $0e, $0a
    db $10, $0c, $0d, $0c, $11, $0e, $0e, $0e, $10, $10, $0d, $10, $ff, $ff, $ff, $ff

BattleUnitLayout_04: ; construction_truck
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_05: ; supply_truck
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_06: ; supply_truck_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_07: ; transport_truck
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_08: ; transport_truck_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_09: ; combat_buggy
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_10: ; combat_buggy_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_11: ; combat_vehicle
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_12: ; combat_vehicle_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_13: ; apc
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_14: ; apc_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_15: ; rocket_launcher
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_16: ; rocket_launcher_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_17: ; anti_air_tank
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_18: ; mercenary_anti_air_missiles
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_19: ; anti_air_missiles
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_20: ; anti_air_missiles_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_21: ; artillery
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_22: ; artillery_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_23: ; ifv
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_24: ; ifv_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_25: ; tank_destroyer
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_26: ; tank_destroyer_s
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_27: ; tank
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_28: ; mercenary_tank
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff

BattleUnitLayout_29: ; fighter_plane_a
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_30: ; fighter_plane_b
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_31: ; fighter_plane_s
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_32: ; attack_plane_a
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_33: ; attack_plane_b
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_34: ; attack_plane_s
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_35: ; bomber
    db $00, $04, $01, $04, $02, $04, $03, $04, $04, $04, $00, $08, $01, $08, $02, $08
    db $03, $08, $04, $08, $ff, $ff, $ff, $ff, $0c, $04, $0d, $04, $0e, $04, $0f, $04
    db $10, $04, $0c, $08, $0d, $08, $0e, $08, $0f, $08, $10, $08, $ff, $ff, $ff, $ff

BattleUnitLayout_36: ; mercenary_bomber
    db $01, $04, $02, $04, $03, $04, $04, $04, $05, $04, $01, $08, $02, $08, $03, $08
    db $04, $08, $05, $08, $ff, $ff, $ff, $ff, $0c, $04, $0d, $04, $0e, $04, $0f, $04
    db $10, $04, $0c, $08, $0d, $08, $0e, $08, $0f, $08, $10, $08, $ff, $ff, $ff, $ff

BattleUnitLayout_37: ; transport_plane
    db $00, $04, $01, $04, $02, $04, $03, $04, $04, $04, $00, $08, $01, $08, $02, $08
    db $03, $08, $04, $08, $ff, $ff, $ff, $ff, $0c, $04, $0d, $04, $0e, $04, $0f, $04
    db $10, $04, $0c, $08, $0d, $08, $0e, $08, $0f, $08, $10, $08, $ff, $ff, $ff, $ff

BattleUnitLayout_38: ; refueling_plane
    db $00, $04, $01, $04, $02, $04, $03, $04, $04, $04, $00, $08, $01, $08, $02, $08
    db $03, $08, $04, $08, $ff, $ff, $ff, $ff, $0c, $04, $0d, $04, $0e, $04, $0f, $04
    db $10, $04, $0c, $08, $0d, $08, $0e, $08, $0f, $08, $10, $08, $ff, $ff, $ff, $ff

BattleUnitLayout_39: ; battle_helicopter
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_40: ; battle_helicopter_s
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_41: ; anti_sub_helicopter
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_42: ; transport_helicopter
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_43: ; transport_helicopter_s
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_44: ; aegis_warship
    db $00, $0a, $01, $0b, $00, $0a, $01, $0b, $00, $0a, $01, $0c, $00, $0d, $01, $0c
    db $00, $0d, $01, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_45: ; mercenary_missile_frigate
    db $00, $0a, $01, $0b, $00, $0a, $01, $0b, $00, $0a, $01, $0c, $00, $0d, $01, $0c
    db $00, $0d, $01, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_46: ; large_carrier
    db $00, $0a, $01, $0b, $00, $0a, $01, $0b, $00, $0a, $01, $0c, $00, $0d, $01, $0c
    db $00, $0d, $01, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_47: ; small_carrier
    db $01, $0a, $02, $0b, $01, $0a, $02, $0b, $01, $0a, $02, $0c, $01, $0d, $02, $0c
    db $01, $0d, $02, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_48: ; transport_ship
    db $01, $0a, $02, $0c, $01, $0b, $02, $0c, $01, $0b, $02, $0d, $01, $0e, $02, $0d
    db $01, $0e, $02, $0d, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0c, $0c, $0b, $0d, $0c
    db $0c, $0b, $0d, $0d, $0c, $0e, $0d, $0d, $0c, $0e, $0d, $0d, $ff, $ff, $ff, $ff

BattleUnitLayout_49: ; supply_tanker
    db $00, $0a, $01, $0b, $00, $0a, $01, $0b, $00, $0a, $01, $0c, $00, $0d, $01, $0c
    db $00, $0d, $01, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff

BattleUnitLayout_50: ; submarine
    db $00, $0b, $01, $0c, $00, $0b, $01, $0c, $00, $0b, $01, $0d, $00, $0e, $01, $0d
    db $00, $0e, $01, $0d, $ff, $ff, $ff, $ff, $0c, $0b, $0d, $0c, $0c, $0b, $0d, $0c
    db $0c, $0b, $0d, $0d, $0c, $0e, $0d, $0d, $0c, $0e, $0d, $0d, $ff, $ff, $ff, $ff

BattleUnitLayout_51: ; submarine_s
    db $00, $0b, $01, $0c, $00, $0b, $01, $0c, $00, $0b, $01, $0d, $00, $0e, $01, $0d
    db $00, $0e, $01, $0d, $ff, $ff, $ff, $ff, $0c, $0b, $0d, $0c, $0c, $0b, $0d, $0c
    db $0c, $0b, $0d, $0d, $0c, $0e, $0d, $0d, $0c, $0e, $0d, $0d, $ff, $ff, $ff, $ff

    assert @ == $5444

; 52 UnitData-indexed sprite descriptors, followed by five special descriptors.
BattleUnitSpriteDescriptors:
    dw $5561 ; empty
    db $01, 2, 2
    dw $5561 ; infantry
    db $01, 2, 2
    dw $5561 ; missile_infantry
    db $05, 2, 2
    dw $5561 ; mercenary_infantry
    db $09, 3, 1
    dw $5561 ; construction_truck
    db $0c, 3, 2
    dw $5561 ; supply_truck
    db $12, 3, 2
    dw $5561 ; supply_truck_s
    db $18, 3, 2
    dw $5561 ; transport_truck
    db $1e, 3, 2
    dw $5561 ; transport_truck_s
    db $24, 3, 2
    dw $5561 ; combat_buggy
    db $2a, 3, 2
    dw $5561 ; combat_buggy_s
    db $30, 3, 2
    dw $5561 ; combat_vehicle
    db $36, 3, 2
    dw $5561 ; combat_vehicle_s
    db $3c, 3, 2
    dw $5561 ; apc
    db $42, 3, 2
    dw $5561 ; apc_s
    db $48, 3, 2
    dw $5561 ; rocket_launcher
    db $4e, 3, 2
    dw $5561 ; rocket_launcher_s
    db $54, 3, 2
    dw $5561 ; anti_air_tank
    db $5a, 3, 2
    dw $5561 ; mercenary_anti_air_missiles
    db $60, 3, 2
    dw $5561 ; anti_air_missiles
    db $66, 3, 2
    dw $5561 ; anti_air_missiles_s
    db $6c, 3, 2
    dw $5561 ; artillery
    db $72, 3, 2
    dw $5561 ; artillery_s
    db $78, 3, 2
    dw $5561 ; ifv
    db $7e, 3, 2
    dw $5561 ; ifv_s
    db $84, 3, 2
    dw $5561 ; tank_destroyer
    db $8a, 3, 2
    dw $5561 ; tank_destroyer_s
    db $90, 3, 2
    dw $5561 ; tank
    db $96, 3, 2
    dw $5561 ; mercenary_tank
    db $9c, 3, 2
    dw $6e91 ; fighter_plane_a
    db $01, 3, 2
    dw $6e91 ; fighter_plane_b
    db $07, 3, 2
    dw $6e91 ; fighter_plane_s
    db $0d, 3, 2
    dw $6e91 ; attack_plane_a
    db $13, 3, 2
    dw $6e91 ; attack_plane_b
    db $19, 3, 2
    dw $6e91 ; attack_plane_s
    db $1f, 3, 2
    dw $6e91 ; bomber
    db $25, 8, 4
    dw $6e91 ; mercenary_bomber
    db $45, 7, 6
    dw $6e91 ; transport_plane
    db $6f, 7, 4
    dw $6e91 ; refueling_plane
    db $8b, 8, 4
    dw $6e91 ; battle_helicopter
    db $ab, 3, 2
    dw $6e91 ; battle_helicopter_s
    db $b1, 3, 2
    dw $6e91 ; anti_sub_helicopter
    db $b7, 3, 2
    dw $6e91 ; transport_helicopter
    db $bd, 3, 2
    dw $6e91 ; transport_helicopter_s
    db $c3, 3, 2
    dw $5fc1 ; aegis_warship
    db $01, 8, 4
    dw $5fc1 ; mercenary_missile_frigate
    db $21, 8, 4
    dw $5fc1 ; large_carrier
    db $41, 8, 4
    dw $5fc1 ; small_carrier
    db $61, 7, 4
    dw $5fc1 ; transport_ship
    db $7d, 7, 4
    dw $5fc1 ; supply_tanker
    db $99, 8, 4
    dw $5fc1 ; submarine
    db $b9, 8, 3
    dw $5fc1 ; submarine_s
    db $d1, 8, 3

; auxiliary one-row graphics selected only for helicopter-family
; UnitData types 39-43 by BattleUnit_GetHelicopterAuxiliaryGraphics.
BattleUnitHelicopterAuxiliaryDescriptors::
    dw $7b61 ; battle_helicopter auxiliary
    db $01, 3, 1
    dw $7b61 ; battle_helicopter_s auxiliary
    db $07, 3, 1
    dw $7b61 ; anti_sub_helicopter auxiliary
    db $0d, 3, 1
    dw $7b61 ; transport_helicopter auxiliary
    db $13, 3, 1
    dw $7b61 ; transport_helicopter_s auxiliary
    db $19, 3, 1
    assert @ == $5561

