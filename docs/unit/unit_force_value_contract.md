# Unit force-value runtime

the project corrects the older reference-map attribution for these helpers. The executable routines are in **physical Bank `$0D`**, not Bank `$14`: direct same-bank callers at `$0D:$66B5/$66C1` call `$670E`, and `$0D:$6715` calls `$671F`. Physical Bank `$14` at the same addresses is non-code data and must not be sourced as this runtime.

## Source-backed entry points

- `UnitForceValue_CalcSideTotal` — `$0D:$670E-$671E`: loops over 50 live-unit records beginning at the caller-supplied first index and sums each contribution into `HL`.
- `UnitForceValue_CalcUnitContribution` — `$0D:$671F-$6757`: computes one record's contribution and returns it in `DE`.

The helper returns zero for nonexistent records and for units with the established Reserve status flag. For active units it reads the UnitData Gold Cost word at offset `$10` and live HP at record offset `$04`, multiplies them, then divides by 10.

UnitData stores Gold Cost in units of 100G, so the instruction-level expression is:

`HP * stored_cost / 10`

which is equivalent to the ROM-map/game-value expression:

`HP * Gold Cost / 1000`

The project resolves the previously uncertain arithmetic/truncation path: the 16-bit product is formed by `Math_SignedMultiplyHLByDE`, moved to `DE`, and divided by `BC = 10` through `Math_DivideDEByBC`.

## Dependency exposed by the runtime

Bank `$12:$4043-$404E` is now source-backed as `UnitData_GetWord`, a small helper that reads two consecutive UnitData bytes into little-endian `DE`. This is the exact helper reached by the force-value farcall.
