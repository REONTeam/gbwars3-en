include "macros/macros.inc"
include "constants/unit_constants.inc"
include "constants/battle_helicopter_hp_constants.inc"

; Bank $02 per-unit battle HP overlay coordinate geometry.
; A selects UnitData type 0-51; B selects battle side 0/1. The helper stores
; the side selector and returns HL pointing at the selected unit layout record.
; Each non-empty unit record is $30 bytes: two $18-byte side halves.

section "Battle Unit HP Layout Lookup", romx[$4000], bank[$02]
BattleUnitHPLayout_GetPointer::
    push af
    ld a, b
    ld [$c4ae], a
    pop af
    sla a
    ld h, $00
    ld l, a
    ld bc, $4016
    add hl, bc
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld h, d
    ld l, e
    ret
BattleUnitHPLayoutPointerTable::
    db $7e, $40, $82, $40, $b2, $40, $e2, $40, $12, $41, $42, $41, $72, $41, $a2, $41
    db $d2, $41, $02, $42, $32, $42, $62, $42, $92, $42, $c2, $42, $f2, $42, $22, $43
    db $52, $43, $82, $43, $b2, $43, $e2, $43, $12, $44, $42, $44, $72, $44, $a2, $44
    db $d2, $44, $02, $45, $32, $45, $62, $45, $92, $45, $c2, $45, $f2, $45, $22, $46
    db $52, $46, $82, $46, $b2, $46, $e2, $46, $12, $47, $42, $47, $72, $47, $a2, $47
    db $d2, $47, $02, $48, $32, $48, $62, $48, $92, $48, $c2, $48, $f2, $48, $22, $49
    db $52, $49, $82, $49, $b2, $49, $e2, $49
BattleUnitHPLayout_EMPTY::
    db $ff, $ff, $ff, $ff
BattleUnitHPLayout_SIDE_MASK::
    db $02, $07, $05, $07, $01, $09, $04, $09, $02, $0b, $05, $0b, $01, $0d, $04, $0d
    db $02, $0f, $05, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_MISSILE_INFANTRY::
    db $02, $07, $05, $07, $01, $09, $04, $09, $02, $0b, $05, $0b, $01, $0d, $04, $0d
    db $02, $0f, $05, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_MERCENARY_INFANTRY::
    db $01, $08, $04, $08, $00, $0a, $03, $0a, $01, $0c, $04, $0c, $00, $0e, $03, $0e
    db $01, $10, $04, $10, $ff, $ff, $ff, $ff, $10, $08, $0d, $08, $11, $0a, $0e, $0a
    db $10, $0c, $0d, $0c, $11, $0e, $0e, $0e, $10, $10, $0d, $10, $ff, $ff, $ff, $ff
BattleUnitHPLayout_CONSTRUCTION_TRUCK::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_SUPPLY_TRUCK::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_SUPPLY_TRUCK_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_TRANSPORT_TRUCK::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_TRANSPORT_TRUCK_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_COMBAT_BUGGY::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_COMBAT_BUGGY_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_COMBAT_VEHICLE::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_COMBAT_VEHICLE_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_APC::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_APC_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ROCKET_LAUNCHER::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ROCKET_LAUNCHER_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ANTI_AIR_TANK::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_MERCENARY_ANTI_AIR_MISSILES::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ANTI_AIR_MISSILES::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ANTI_AIR_MISSILES_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ARTILLERY::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ARTILLERY_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_IFV::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_IFV_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_TANK_DESTROYER::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_TANK_DESTROYER_S::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_TANK::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_MERCENARY_TANK::
    db $01, $07, $04, $07, $00, $09, $03, $09, $01, $0b, $04, $0b, $00, $0d, $03, $0d
    db $01, $0f, $04, $0f, $ff, $ff, $ff, $ff, $10, $07, $0d, $07, $11, $09, $0e, $09
    db $10, $0b, $0d, $0b, $11, $0d, $0e, $0d, $10, $0f, $0d, $0f, $ff, $ff, $ff, $ff
BattleUnitHPLayout_FIGHTER_PLANE_A::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_FIGHTER_PLANE_B::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_FIGHTER_PLANE_S::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ATTACK_PLANE_A::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ATTACK_PLANE_B::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ATTACK_PLANE_S::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_BOMBER::
    db $00, $04, $01, $04, $02, $04, $03, $04, $04, $04, $00, $08, $01, $08, $02, $08
    db $03, $08, $04, $08, $ff, $ff, $ff, $ff, $0c, $04, $0d, $04, $0e, $04, $0f, $04
    db $10, $04, $0c, $08, $0d, $08, $0e, $08, $0f, $08, $10, $08, $ff, $ff, $ff, $ff
BattleUnitHPLayout_MERCENARY_BOMBER::
    db $01, $04, $02, $04, $03, $04, $04, $04, $05, $04, $01, $08, $02, $08, $03, $08
    db $04, $08, $05, $08, $ff, $ff, $ff, $ff, $0c, $04, $0d, $04, $0e, $04, $0f, $04
    db $10, $04, $0c, $08, $0d, $08, $0e, $08, $0f, $08, $10, $08, $ff, $ff, $ff, $ff
BattleUnitHPLayout_TRANSPORT_PLANE::
    db $00, $04, $01, $04, $02, $04, $03, $04, $04, $04, $00, $08, $01, $08, $02, $08
    db $03, $08, $04, $08, $ff, $ff, $ff, $ff, $0c, $04, $0d, $04, $0e, $04, $0f, $04
    db $10, $04, $0c, $08, $0d, $08, $0e, $08, $0f, $08, $10, $08, $ff, $ff, $ff, $ff
BattleUnitHPLayout_REFUELING_PLANE::
    db $00, $04, $01, $04, $02, $04, $03, $04, $04, $04, $00, $08, $01, $08, $02, $08
    db $03, $08, $04, $08, $ff, $ff, $ff, $ff, $0c, $04, $0d, $04, $0e, $04, $0f, $04
    db $10, $04, $0c, $08, $0d, $08, $0e, $08, $0f, $08, $10, $08, $ff, $ff, $ff, $ff
BattleUnitHPLayout_BATTLE_HELICOPTER::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_BATTLE_HELICOPTER_S::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_ANTI_SUB_HELICOPTER::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_TRANSPORT_HELICOPTER::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_TRANSPORT_HELICOPTER_S::
    db $01, $04, $04, $04, $00, $06, $03, $06, $01, $08, $04, $08, $00, $0a, $03, $0a
    db $01, $0c, $04, $0c, $ff, $ff, $ff, $ff, $10, $04, $0d, $04, $11, $06, $0e, $06
    db $10, $08, $0d, $08, $11, $0a, $0e, $0a, $10, $0c, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_AEGIS_WARSHIP::
    db $00, $0a, $01, $0b, $00, $0a, $01, $0b, $00, $0a, $01, $0c, $00, $0d, $01, $0c
    db $00, $0d, $01, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_MERCENARY_MISSILE_FRIGATE::
    db $00, $0a, $01, $0b, $00, $0a, $01, $0b, $00, $0a, $01, $0c, $00, $0d, $01, $0c
    db $00, $0d, $01, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_LARGE_CARRIER::
    db $00, $0a, $01, $0b, $00, $0a, $01, $0b, $00, $0a, $01, $0c, $00, $0d, $01, $0c
    db $00, $0d, $01, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_SMALL_CARRIER::
    db $01, $0a, $02, $0b, $01, $0a, $02, $0b, $01, $0a, $02, $0c, $01, $0d, $02, $0c
    db $01, $0d, $02, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_TRANSPORT_SHIP::
    db $01, $0a, $02, $0c, $01, $0b, $02, $0c, $01, $0b, $02, $0d, $01, $0e, $02, $0d
    db $01, $0e, $02, $0d, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0c, $0c, $0b, $0d, $0c
    db $0c, $0b, $0d, $0d, $0c, $0e, $0d, $0d, $0c, $0e, $0d, $0d, $ff, $ff, $ff, $ff
BattleUnitHPLayout_SUPPLY_TANKER::
    db $00, $0a, $01, $0b, $00, $0a, $01, $0b, $00, $0a, $01, $0c, $00, $0d, $01, $0c
    db $00, $0d, $01, $0c, $ff, $ff, $ff, $ff, $0c, $0a, $0d, $0b, $0c, $0a, $0d, $0b
    db $0c, $0a, $0d, $0c, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $ff, $ff, $ff, $ff
BattleUnitHPLayout_SUBMARINE::
    db $00, $0b, $01, $0c, $00, $0b, $01, $0c, $00, $0b, $01, $0d, $00, $0e, $01, $0d
    db $00, $0e, $01, $0d, $ff, $ff, $ff, $ff, $0c, $0b, $0d, $0c, $0c, $0b, $0d, $0c
    db $0c, $0b, $0d, $0d, $0c, $0e, $0d, $0d, $0c, $0e, $0d, $0d, $ff, $ff, $ff, $ff
BattleUnitHPLayout_SUBMARINE_S::
    db $00, $0b, $01, $0c, $00, $0b, $01, $0c, $00, $0b, $01, $0d, $00, $0e, $01, $0d
    db $00, $0e, $01, $0d, $ff, $ff, $ff, $ff, $0c, $0b, $0d, $0c, $0c, $0b, $0d, $0c
    db $0c, $0b, $0d, $0d, $0c, $0e, $0d, $0d, $0c, $0e, $0d, $0d, $ff, $ff, $ff, $ff
    assert @ == $4a12
