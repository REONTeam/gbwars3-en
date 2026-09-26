; the current source: battle-scene resource scheduling and air-matchup variants.
DEF wBattleSceneLayoutUnitType            EQU $c4b0
DEF wBattleSceneResourceClass             EQU wBattleSceneLayoutUnitType ; compatibility alias
DEF wBattleSceneResourceSide              EQU $c4ad
DEF wBattleSceneActiveSlotOrdinal         EQU $c4b5
DEF wBattleSceneSlotScanIndex             EQU $c4b6
DEF wBattleSceneRandomDelayTable          EQU $c4bd ; 10 bytes
DEF wBattleSceneAirVariantSide0           EQU $c4dc
DEF wBattleSceneAirVariantSide1           EQU $c4dd

DEF BATTLE_SCENE_AIR_VARIANT_SAME_DOMAIN  EQU 0 ; both air or both non-air
DEF BATTLE_SCENE_AIR_VARIANT_OPPONENT_AIR EQU 1 ; current non-air, opponent air
DEF BATTLE_SCENE_AIR_VARIANT_CURRENT_AIR  EQU 2 ; current air, opponent non-air
