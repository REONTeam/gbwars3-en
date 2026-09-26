# Map control / phase / economy runtime contract

the project records the reference-backed RAM geometry for the core map-side control and economy workspace at `$C631-$C649`. This is a **non-emitting contract**: it names runtime state and future sourcing entry points, but it does not reconstruct any overlay-owned Bank `$12` or Bank `$14` instruction bytes.

## RAM layout

| Range | Symbol | Contract |
| --- | --- | --- |
| `$C631` | `wMapSide0Control` | side 0 control: `0 = human`, `1 = CPU` |
| `$C632` | `wMapSide1Control` | side 1 control: `0 = human`, `1 = CPU` |
| `$C633` | `wMapPhaseNumber` | zero-based phase counter; `phase / 2 + 1` gives the day and `phase & 1` selects the active side |
| `$C634-$C636` | `wMapSide0Gold` | side 0 current Gold, 3 bytes |
| `$C637-$C639` | `wMapSide1Gold` | side 1 current Gold, 3 bytes |
| `$C63A-$C63B` | `wMapSide0Materials` | side 0 current Materials, 2 bytes |
| `$C63C-$C63D` | `wMapSide1Materials` | side 1 current Materials, 2 bytes |
| `$C63E-$C63F` | `wMapSide0GoldIncomeDiv10` | side 0 Gold income divided by 10, 2 bytes |
| `$C640-$C641` | `wMapSide1GoldIncomeDiv10` | side 1 Gold income divided by 10, 2 bytes |
| `$C642-$C643` | `wMapSide0MaterialsIncome` | side 0 Materials income, 2 bytes |
| `$C644-$C645` | `wMapSide1MaterialsIncome` | side 1 Materials income, 2 bytes |
| `$C646-$C647` | `wMapSide0HQCoordinates` | side 0 HQ coordinate pair |
| `$C648-$C649` | `wMapSide1HQCoordinates` | side 1 HQ coordinate pair |

The workspace is therefore exactly **25 bytes** from `$C631` through `$C649`. `$C62F` remains the already-established `wActiveGameMode`; the source does not assign `$C630` or `$C64A+` to the economy workspace.

## Source status and corrected map-control bank

the project corrects one old reference-map bank attribution. `MapControl_InitializePlayers` is **physical Bank `$0D:$6618-$664F`**, not Bank `$14`. Direct same-bank code at `$0D:$6614` calls `$6618`; the bytes in physical Bank `$14` at `$6618` are non-code data. The routine is now emitted source in `engine/map/ai/map_control_force.asm`.

Its behavior is byte-proven:

- both control bytes start as human (`0`);
- Attraction mode sets both sides to CPU (`1`);
- VS leaves both sides human;
- Beginner, Campaign and Map Editor make side 1 CPU;
- Standard chooses which side is CPU from the scenario index at `$C883`, switching at `$1E`.

The Bank `$12:$411B-$4177` starting-resource helpers remain separate economy targets: they establish starting Gold/Materials and perform the reference-described `x1000` / `x10` conversions.

## Naming discipline

The project continues to use neutral `side 0` / `side 1` symbols instead of hard-coding faction names into shared engine state. The reference RAM map calls these Red Star and White Moon, but broader engine code already represents the two participants numerically and can use the same workspace in multiple modes.
## the project source integration

The project names are now used by every already-sourced direct consumer in the `$C631-$C649` range. In particular, the SRAM serializer/deserializer names the phase, both Gold values and both Materials values directly; the day-display paths name the phase counter; and the Standard-map runtime names the side-1 HQ coordinate pair. `check-map-economy-source-integration` rejects future raw literals from this RAM range inside `source/`.

The Bank `$0D` control initializer is now source-backed. The Bank `$12` starting-resource helpers remain separate overlay targets until sourced byte-authoritatively.

