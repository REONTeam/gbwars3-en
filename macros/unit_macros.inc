; Fixed-width UnitData definition record.
;
; Arguments after the 10-byte display name follow the semantic UnitData layout:
; HP, fuel, movement power, transport capacity, unknown $0E, fuel upkeep,
; gold cost (16-bit, units of 100G), material cost (16-bit), weapon 1, ammo 1,
; weapon 2, ammo 2, target class, movement profile, carrying type, three carried
; types, five defense-family values, base Focus, and Focus loss.
;
; $0E deliberately remains unresolved. The two cost arguments are emitted as
; little-endian words so callers no longer have to spell their low/high bytes.
macro unit_data
    assert STRLEN(\1) == UNIT_DATA_NAME_LENGTH
    db \1 ; display name
    shift
    db \1 ; max HP
    shift
    db \1 ; max fuel
    shift
    db \1 ; movement power
    shift
    db \1 ; transport capacity
    shift
    db \1 ; unresolved $0E
    shift
    db \1 ; fuel upkeep
    shift
    dw \1 ; gold cost / 100G
    shift
    dw \1 ; material cost
    shift
    db \1 ; weapon 1
    shift
    db \1 ; weapon 1 ammo
    shift
    db \1 ; weapon 2
    shift
    db \1 ; weapon 2 ammo
    shift
    db \1 ; target class
    shift
    db \1 ; movement profile
    shift
    db \1 ; carrying type
    shift
    db \1 ; carried type 1
    shift
    db \1 ; carried type 2
    shift
    db \1 ; carried type 3
    shift
    db \1 ; DEF: armored
    shift
    db \1 ; DEF: unarmored
    shift
    db \1 ; DEF: air
    shift
    db \1 ; DEF: sea
    shift
    db \1 ; DEF: submarine
    shift
    db \1 ; base Focus
    shift
    db \1 ; Focus loss
endm


; Fixed-width WeaponData definition record.
;
; Arguments after the 8-byte display name follow the proven WeaponData layout:
; minimum range, maximum range, attack versus armored, unarmored, air, sea,
; submarine, then per-shot cost. The five attack fields intentionally mirror
; UNIT_DATA_DEF_* and UNIT_TARGET_CLASS_* ordering.
macro weapon_data
    assert STRLEN(\1) == WEAPON_DATA_NAME_LENGTH
    db \1 ; display name
    shift
    db \1 ; minimum range
    shift
    db \1 ; maximum range
    shift
    db \1 ; attack: armored
    shift
    db \1 ; attack: unarmored
    shift
    db \1 ; attack: air
    shift
    db \1 ; attack: sea
    shift
    db \1 ; attack: submarine
    shift
    db \1 ; cost per shot
endm

; One fixed-width MovementData profile.
;
; Arguments follow the exact terrain-name class order proven by
; MovementData_GetCost / Terrain_GetNameIndex: two HQ variants, city/ruins,
; base/ruins, airport/ruins, runway, port/ruins, COM tower, then the eleven
; natural terrain classes. Keeping every column explicit makes the source
; layout mirror MOVEMENT_TERRAIN_* instead of hiding the schema in a rept.
macro movement_profile
    db \1 ; HQ variant 0
    shift
    db \1 ; HQ variant 1
    shift
    db \1 ; city
    shift
    db \1 ; city ruins
    shift
    db \1 ; base / factory
    shift
    db \1 ; base / factory ruins
    shift
    db \1 ; airport
    shift
    db \1 ; airport ruins
    shift
    db \1 ; runway / temporary airport
    shift
    db \1 ; port
    shift
    db \1 ; port ruins
    shift
    db \1 ; COM tower
    shift
    db \1 ; plain
    shift
    db \1 ; road
    shift
    db \1 ; bridge 1
    shift
    db \1 ; bridge 2
    shift
    db \1 ; mountain
    shift
    db \1 ; wood
    shift
    db \1 ; wasteland
    shift
    db \1 ; desert
    shift
    db \1 ; river
    shift
    db \1 ; sea
    shift
    db \1 ; shoal
    shift
endm
