# Battle combat-math runtime anchors

The combat pipeline is physically in Bank `$0C`. the regression suite progressively replace the former reference-only contracts with byte-authoritative source from the restored Japanese ROM.

## Cover lookup layer (the project)

the project source-backs `$0C:$4861-$486C` as the Cover-value lookup and `$486D-$4883` as the exact 23-byte Cover table, matching the already-source-backed 23-class `Terrain_Name_Strings` / `MovementData` namespace.

- `$4861` `Battle_GetCoverValue`
- `$486D` `Battle_CoverValueTable` — 23 byte-authoritative values: `0, 70, 30, 20, 30, 20, 10, 20, 10, 20, 20, 20, 10, 0, 0, 20, 50, 40, 30, 20, 0, 0, 10`

Reference naming lines up one-for-one with the project terrain classes from index 2 onward: city/ruins, base/factory/ruins, airport/ruins, runway, port/ruins, COM tower, plain, road, both bridge classes, mountain, wood, wasteland, desert, river, sea and shoal. The first two slots remain intentionally `BATTLE_COVER_CLASS_00/01`: the external notes describe them as **Null / HQ**, while the source-backed movement namespace has two HQ variants. The sourced `$4861` helper passes the `Terrain_GetNameIndex` result directly into this table. The first-two-class naming ambiguity is therefore a terrain-namespace naming question rather than an unresolved lookup transformation, so the conservative positional aliases remain appropriate.

This makes `wBattleAttackerCover` / `wBattleDefenderCover` part of a concrete 23-class terrain lookup contract while preserving the unresolved first-two-class semantics.

## Flank and Support setup (the project)

Bank `$0C:$4884-$4990` is now byte-authoritative source. These helpers populate the positional inputs consumed by the already-sourced attack/defense multiplier builders. Both are gated by `wBattleDistance == 1`; the byte at `$DBF6` is therefore named `wBattleDistance` for this setup lifetime while retaining `wBattleAttackOrderState` as the later aftermath alias proven in the project.

- `$4884` `Battle_CalcFlankValue` scans the six neighboring hexes around the acting unit. Enemy occupied/ZOC cells set the current direction plus the two adjacent-direction bits from `Battle_FlankAdjacentDirectionPairs`. The number of covered directions indexes the exact seven-byte table `0, 0, 0, 0, 25, 35, 50`. Thus fewer than four covered directions produce no Flank value; four/five/six produce 25/35/50.
- `$4919` `Battle_CalcSupportValue` scans the six coordinates around the opponent, rejects empty coordinates, the acting unit itself, and opposite-side units, then builds each qualifying ally's two-weapon summary. `Battle_SelectUsableWeaponAttack` is called at range 1 and the returned usable attack is divided by eight (`>> 3`); those one-eighth contributions are accumulated as Support.
- `$C941` is the target unit ID during Support calculation, `$C943` is the acting/context unit ID, and `$C944` is deliberately lifetime-shared between the Flank direction mask and Support accumulator. `$C942` is named conservatively as `wBattleWeaponRangeScratch` for the adjacent weapon-selection helper; that helper is still symbol-only and is a natural next sourcing target.

the project sources the complete paired weapon-selector family at `$0C:$40C1-$418E`. `Battle_SelectUsableWeaponAttack` requires live ammo in addition to range and non-zero target-family attack. `Battle_SelectWeaponAttackIgnoringAmmo` performs the same range/target comparison without reading live ammo. Both prefer slot 0 on equal attack values and return the selected weapon ID in `A`, slot in `D`, and attack value in `E`. `UnitRecord_FindPrimaryAtCoordinates` at `$12:$414E` remains a separate symbol-only dependency.

## Rank and multiplier layer

The live unit experience field is already proven to yield ranks D/C/B/A/S as values 0-4. the project source-backs `$0C:$4991-$499C` as the rank/level-value lookup and `$499D-$49A1` as five rank values. The table matches the five-rank model exactly: one byte per `UNIT_RANK_D` through `UNIT_RANK_S`.

- `$4991` `Battle_GetRankMultiplier`
- `$499D` `Battle_RankMultiplierTable` — exact values `0, 10, 20, 30, 40`
- `$49A2` `Battle_CalcAttackMultiplier` — combines Support, rank, and Flank inputs
- `$49CC` `Battle_CalcDefenseMultiplier` — combines Cover, rank, and Flank inputs

the project source-backs both multiplier builders. The attack path computes from `(Support, rank/level, Flank)` as `100 + Support + rank - Flank`; the defense path first halves Cover, rank and Flank and computes `100 + (Cover >> 1) + (rank >> 1) - (Flank >> 1)`. These map directly onto the typed battle-stat workspace fields `wBattle*Support`, `wBattle*RankValue`, `wBattle*Flank`, and `wBattle*Cover`.

The emitted code returns a two-byte split multiplier in `HL`: it divides the integer context by 100, then converts the remainder through a second divide after shifting it into the high byte. `Battle_CalcStatHPScaled` consumes those two bytes explicitly. This preserves the retail fixed-point-like representation without inventing a higher-level numeric type.

## Stat/HP scaling and damage result

- `$49FC` `Battle_CalcStatHPScaled` — reference-described `Stat * HP * Multiplier` path
- `$4A21` `Battle_CalcDoubleStatHPScaled` — doubled variant used by defense-side arithmetic
- `$4A26` `Battle_CalcAttackerNewHP`
- `$4A98` `Battle_CalcDefenderNewHP`
- `$4B0A` `Battle_CalcNewHPByAttackOrder`

the regression suite now source-back the arithmetic helpers and HP-result/Focus-order range that this earlier contract described. The effective damage form uses a **100-point boost base** and a **200-point normalization denominator**; the new-HP helpers are equivalently described around `(Total DEF - Total ATK) / (2 * DEF)`, with negative results becoming zero, positive fractional results rounded up, and results above old HP clamped back to old HP. The high-level equation remains useful documentation; exact instruction order is now preserved by the emitted source/raw byte-authoritative HP bodies.

The source-backed attack-order helper at `$4B0A-$4B66` compares the **10s digit of Focus** (equivalently integer division by 10). Its three documented branches are attacker higher (`$4B18-$4B34`), defender higher (`$4B35-$4B51`), and tied (`$4B52-$4B65`). The tied branch uses old HP for both participants. `BATTLE_FOCUS_ORDER_DIVISOR = 10` and the three positional branch constants record only that externally described control contract; they do not assert the final attack-order enum returned by the source-backed Focus-order code.

This connects `WeaponData` attack-family values, UnitData defense-family values, live HP, rank, Focus, Cover, Support and Flank state to a byte-authoritative arithmetic pipeline.

## Battle aftermath

- `$4B67` `Battle_ApplyAmmoAndParticipationExperience`
- `$4BC0` `Battle_ApplyAttackerAmmoAndParticipationExperience`
- `$4BD5` `Battle_ApplyDefenderAmmoAndParticipationExperience`
- `$4BEA` `Battle_ApplyAmmoUse`
- `$4BFC` `Battle_ApplyParticipationExperience`
- `$4C27` `Battle_ApplyDamageExperience`

the project source-backs the complete `$4B67-$4C6F` aftermath layer. The combined dispatcher contains attacker-specific `$4BC0-$4BD4` and defender-specific `$4BD5-$4BE9` helpers before the shared ammo-use helper, participation-EXP helper, and damage-EXP helper.

the project formalizes the externally documented EXP coefficients as non-emitting constants: attacking/counterattacking participation = **2 EXP**, defending participation = **1 EXP**, kill bonus = **1** (otherwise 0), and underdog multiplier = **2** when the victorious unit defeats a higher-ATK opponent (otherwise 1). The reference-described damage expression is therefore `(Damage Done + Kill Coefficient) * Underdog Coefficient`. These constants are now corroborated by the source-backed `$4BFC-$4C6F` implementation. Higher-level gameplay interpretation should still follow the actual callers rather than extrapolating beyond the emitted code.

## Battle-info presentation and attack-order text (the project)

the project source-backs `$0C:$4C70-$4D9E` as the Battle Info/status presentation runtime. `BattleInfo_ShowScreen` owns the UI setup and participant rendering; `BattleInfo_DrawAttackOrder` compares the two Focus bytes directly; `BattleInfo_DrawOrderLabel` indexes the four-state order-string pointer table; and `BattleInfo_DrawParticipantStats` renders Attack, Defense, Cover, rank, Flank, Total Attack and Total Defense from the typed battle-stat records. The helper deliberately skips the Support byte between Flank and Total Attack, confirming Support is represented through Total Attack rather than by a dedicated displayed line.

The customized source in `engine/battle/battle_info.asm` begins immediately at `$4D9F`. Its `BattleInfo_Strings` table and strings therefore remain project-owned English content rather than retail-Japanese transcription. The attack-order table at `$4E0A` is likewise already emitted source as `BattleInfo_Order_Strings`, with pointer order **invalid, simultaneous, first, second** and customized strings `1ST`, `2ND`, `SAME`, and the invalid marker. The obsolete symbol-only `$4E0A/$4E12` anchors are retired.

## Next byte-authoritative sequence

The combat/source layer now owns the paired `$40C1-$418E` weapon selectors and the contiguous `$4861-$4D9E` Cover/positional/rank/multiplier/HP/aftermath/presentation runtime, while customized battle-info text remains independently source-owned from `$4D9F`. The next primary target returns to Bank `$18:$53D7+` battle-scene consumers, with Bank `$12:$414E` coordinate-to-unit lookup as the next combat dependency tranche.

## the project RAM-side contract

`docs/battle/battle_runtime_ram_layout.md` now types the reference-described `$DBC8-$DBF5` battle workspace used by this pipeline: two unit IDs, mirrored 21-byte attacker/defender records, and the trailing coordinate pair. The corresponding Bank `$0C` combat code is now substantially source-backed; the RAM names are intended to make the eventual source transcription and reader/writer correlation precise.

## Mathematical combat formula contract (the project)

the project records the reference-described **mathematical contract** around the already-anchored `$49A2-$4B09` pipeline without importing any Bank `$0C` bytes. This is deliberately separate from the unknown implementation representation: the multiplier helpers still return a 16-bit `HL` value with a fractional low byte, but the exact fixed-point scale used internally remains unresolved.

The D/C/B/A/S rank contribution is byte-confirmed as **0, 10, 20, 30, 40** and emitted by `Battle_RankMultiplierTable` at `$499D-$49A1`.

At the formula level:

- attack context = `100 + support + rank - flank`;
- defense multiplier context = `100 + (cover >> 1) + (rank >> 1) - (flank >> 1)`;
- `Total ATK` is based on `Used ATK * HP * attack context / 100`;
- `Total DEF` is based on `Used DEF * HP * defense context / 100`;
- a participant's candidate new HP is based on `(Total DEF - Total ATK) / (2 * Used DEF)`;
- the `$4A26-$4B09` helpers clamp the result to the range **0 .. old HP** and round the surviving positive quotient upward.

These equations began as the project caller-visible contract. the regression suite now preserve the actual retail multiplier/scaling and HP-result bytes, so future cleanup should translate the remaining raw HP bodies to mnemonics without changing their established addresses or behavior.
