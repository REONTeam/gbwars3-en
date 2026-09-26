# Battle scene side-record contract (the project)

The battle presentation keeps two mirrored six-byte participant records in WRAM bank 4:

| Side 0 | Side 1 | Meaning |
| --- | --- | --- |
| `$D377` | `$D37D` | UnitData type |
| `$D378` | `$D37E` | displayed / old HP |
| `$D379` | `$D37F` | target / new HP A |
| `$D37A` | `$D380` | raw terrain/map-tile ID |
| `$D37B` | `$D381` | used weapon ID; copied into the battle-place scene-row scratch |
| `$D37C` | `$D382` | Focus |

This is not inferred from the project debug presets. `Battle_ExecuteDirectUnitAttack` copies exactly six bytes from the already-typed 21-byte attacker/defender battle-stat records (`$DBCA-$DBDE` / `$DBDF-$DBF3`) into `$D377-$D382`. Their first six offsets are already established as Unit type, old HP, new HP A, terrain, used weapon and Focus.

Bank `$16` independently consumes those fields: the old/displayed HP values decrement until they match the target HP values; terrain indexes the Bank `$17` battle-place graphics record; used weapon is staged as the side-specific battle-place scene row; Focus is compared between the two sides to choose presentation order/state.

Bank `$0C:$4488-$4860` is now source-owned as the presentation/setup gap between `Battle_ExecuteDirectUnitAttack` and the previously owned Cover/combat runtime. `$464F` builds the mirrored 21-byte combat participant records; `$47A7+` selects participant weapons and completes combat-result staging.
