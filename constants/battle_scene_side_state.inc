; the current source: mirrored six-byte battle-scene participant records.
; Battle_ExecuteDirectUnitAttack copies the first six bytes of the already-typed
; 21-byte battle participant records into these scene records. Bank $16 then
; consumes them for graphics, HP transition and battle-place presentation.
DEF wBattleSceneSide0UnitType       EQU $d377
DEF wBattleSceneSide0DisplayedHP    EQU $d378 ; participant old HP
DEF wBattleSceneSide0TargetHP       EQU $d379 ; participant new HP A
DEF wBattleSceneSide0Terrain        EQU $d37a ; raw map tile / battle-place record
DEF wBattleSceneSide0UsedWeapon     EQU $d37b ; battle used-weapon / scene row
DEF wBattleSceneSide0Focus          EQU $d37c
DEF wBattleSceneSide1UnitType       EQU $d37d
DEF wBattleSceneSide1DisplayedHP    EQU $d37e ; participant old HP
DEF wBattleSceneSide1TargetHP       EQU $d37f ; participant new HP A
DEF wBattleSceneSide1Terrain        EQU $d380 ; raw map tile / battle-place record
DEF wBattleSceneSide1UsedWeapon     EQU $d381 ; battle used-weapon / scene row
DEF wBattleSceneSide1Focus          EQU $d382
DEF BATTLE_SCENE_SIDE_RECORD_SIZE   EQU 6

; Compatibility aliases retained for the current source-era neutral names.
DEF wBattleSceneSide0Field3 EQU wBattleSceneSide0Terrain
DEF wBattleSceneSide0Field4 EQU wBattleSceneSide0UsedWeapon
DEF wBattleSceneSide0Field5 EQU wBattleSceneSide0Focus
DEF wBattleSceneSide1Field3 EQU wBattleSceneSide1Terrain
DEF wBattleSceneSide1Field4 EQU wBattleSceneSide1UsedWeapon
DEF wBattleSceneSide1Field5 EQU wBattleSceneSide1Focus

; the current source: older battle-place row names are compatibility aliases. The values
; are direct WeaponData IDs copied from the combat participant used-weapon field.
DEF wBattlePlaceRowSide0 EQU wBattleSceneSide0UsedWeapon
DEF wBattlePlaceRowSide1 EQU wBattleSceneSide1UsedWeapon
