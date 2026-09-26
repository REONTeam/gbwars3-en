; the current source: shared battle-helicopter HP-overlay scratch aliases.
; These names describe the lifetime proven by the Bank $16 producer, ROM0
; VBlank consumer, and Bank $02 per-unit coordinate-table lookup.
DEF wBattleHelicopterHPSideIndex          EQU $c4ae
DEF wBattleUnitTypeSide0                  EQU $c4b7
DEF wBattleUnitTypeSide1                  EQU $c4b8
DEF wBattleHelicopterHPEntryIndex         EQU $d33e
DEF wBattleHelicopterAuxLoadedSide0       EQU $d340
DEF wBattleHelicopterAuxLoadedSide1       EQU $d341
DEF wBattleHelicopterHPUpdatePhase        EQU $d343
DEF wBattleHelicopterHPActiveSlotsSide0   EQU $d384 ; 10 bytes
DEF wBattleHelicopterHPActiveSlotsSide1   EQU $d38e ; 10 bytes
DEF wBattleHelicopterHPTileStateSide0     EQU $d398 ; 10 bytes
DEF wBattleHelicopterHPTileStateSide1     EQU $d3a2 ; 10 bytes
DEF BATTLE_HELICOPTER_HP_SLOT_COUNT        EQU 10
DEF BATTLE_HELICOPTER_HP_PHASE_COUNT       EQU 5
DEF BATTLE_UNIT_HP_LAYOUT_SIDE_SIZE        EQU $18
DEF BATTLE_UNIT_HP_LAYOUT_RECORD_SIZE      EQU $30
