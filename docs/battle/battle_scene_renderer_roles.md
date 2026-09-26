# Battle-scene resource renderer caller roles

the project resolves the caller-visible roles of the four Bank `$18:$51E3/$5265/$52E7/$535F` resource renderers without inventing an effect/weapon identity that the current bytes do not prove.

The setup/state-machine code stores a continuation as three bytes at `$C4D5-$C4D7` (address high, address low, bank). Those writes are now expressed with `HIGH()`, `LOW()`, and `BANK()` against renderer labels rather than raw constants.

The proven caller split is:

- `BattleScene_RenderResourceSide0Facing` (`$51E3`): selected four times — family 0 side 0, family 1 side 0, phase 1 side 1, and phase 2 side 0. The renderer applies `+8` to the horizontal position.
- `BattleScene_RenderResourceSide1Facing` (`$5265`): selected three times — family 0 side 1, family 1 side 1, and phase 2 side 1. The renderer applies `-8` to the horizontal position.
- `BattleScene_RenderResourceFamily2Centered` (`$52E7`): selected twice — family 2 side 0 and family 2 side 1. It applies no horizontal adjustment.
- `BattleScene_RenderResourcePhase1Side0` (`$535F`): selected once — phase 1 side 0. It applies no horizontal adjustment.

The resource-animation labels in Bank `$14:$43A1-$43DA` now mirror these caller roles. The older `Variant0`-`Variant3` labels remain as compatibility aliases so older notes/verifiers do not break abruptly.

These names describe only source-proven geometry and caller ownership. They do **not** claim that the corresponding animations are a particular weapon, muzzle flash, explosion, projectile, or terrain effect. The common battle graphics visibly contain small projectile/effect-like tiles, but visual inspection alone is not sufficient to assign gameplay identities.

## `$18:$53D7+` boundary

the project established that `$18:$53D7` is not a fifth resource renderer. the project confirms the distinction further from the retail bytes: the following code manipulates `$C614-$C618`, uses repeated compare/copy/check helpers, and contains the literal eight-byte signature `GBoyWARS3` at `$54E4`. This strongly points to a data-validation/transfer or save-style subsystem, not battle rendering. The exact feature and routine boundaries remain deliberately unnamed until its callers and RAM ownership are traced.


## Coordinate lookup integration

The combat Support path's Bank `$12:$414E` dependency was already emitted inside `engine/unit/unit_setup.asm` as `Unit_FindAtCoordinates`. the project adds the canonical exported alias `UnitRecord_FindPrimaryAtCoordinates` at the same entry point and removes the stale symbol-only anchor. The routine scans the 100 live-unit records, matches X/Y, excludes carried units, and returns the first primary unit ID or `$FF`.
