# Battle runtime RAM layout

the project formalizes the reference-backed battle-stat workspace at `$DBC8-$DBF5` so the Bank `$13` combat-math anchors from the project have a typed RAM contract to target when their instruction bytes are eventually sourced.

This is **RAM naming/geometry only**. It does not source, reconstruct, or claim ownership of any Bank `$13` code bytes.

## Top-level geometry

- `$DBC8`: attacker live-unit ID.
- `$DBC9`: defender live-unit ID.
- `$DBCA-$DBDE`: attacker battle-stat record, 21 bytes.
- `$DBDF-$DBF3`: defender battle-stat record, 21 bytes.
- `$DBF4-$DBF5`: an additional coordinate pair identified by the reference map.
- `$DBF6`: first byte after the documented workspace.

The complete documented span is therefore **46 bytes**.

## Participant record

The attacker and defender use the same 21-byte geometry:

| Offset | Size | Field |
| ---: | ---: | --- |
| `$00` | 1 | Unit type |
| `$01` | 1 | Old HP |
| `$02` | 1 | New HP A |
| `$03` | 1 | Terrain |
| `$04` | 1 | Used weapon |
| `$05` | 1 | Focus |
| `$06` | 1 | X coordinate |
| `$07` | 1 | Y coordinate |
| `$08` | 1 | Unit family / target class |
| `$09` | 1 | New HP B |
| `$0A` | 1 | ATK |
| `$0B` | 1 | DEF |
| `$0C` | 1 | Cover value |
| `$0D` | 1 | Rank/level value |
| `$0E` | 1 | Flank value |
| `$0F` | 1 | Support value |
| `$10` | 2 | Total ATK |
| `$12` | 2 | Total DEF |
| `$14` | 1 | Weapon choice |

The source reference describes both offsets `$02` and `$09` as "New HP". the project deliberately preserves that ambiguity as `NewHPA` / `NewHPB`; their distinct runtime roles should be resolved from Bank `$13` readers/writers once `baserom.gbc` is available.

## Cross-schema relationships

This layout provides the RAM-side join for source-backed definitions already present in the project:

- `Unit type` indexes the 53-entry UnitData table.
- `Unit family` uses the same five-way armored / unarmored / air / sea / submarine family space tied to UnitData and WeaponData.
- `Focus` corresponds to UnitData base Focus / Focus-loss semantics, though the exact runtime derivation remains in overlay code.
- `Rank/level value` is the consumer-facing byte associated with the D/C/B/A/S rank multiplier layer anchored at Bank `$13:$4991-$49A1`.
- `ATK` and `DEF` feed the the project attack/defense multiplier and HP-result pipeline.
- `Total ATK` and `Total DEF` are explicitly 16-bit workspace fields.
- `Used weapon` / `Weapon choice` connect the battle workspace to the two source-backed WeaponData slots, but their exact distinction remains unresolved until the producers are sourced.

## Next byte-authoritative step

With the RAM side now typed, source Bank `$13:$4991-$4CF6` against `baserom.gbc` and replace raw `$DBxx` accesses with these names as each reader/writer confirms the field roles. In particular, use those accesses to resolve the duplicate `New HP` fields and the `Used weapon` versus `Weapon choice` distinction before assigning narrower names.
