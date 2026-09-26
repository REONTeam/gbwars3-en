# Battle used-weapon -> scene animation/resource mapping (the project)

the project proved that the fifth byte of each six-byte battle-scene side record is the combat participant's **used WeaponData ID**. the project follows that byte through the Bank $17 animation matrix and the Bank $18 compact resource selector.

## Bank $17 animation rows are WeaponData IDs

`BattlePlace_GetWeaponAnimationPointer` indexes `BattlePlaceWeaponAnimationPointerMatrix` as `weapon_id * 24 + side * 12 + variant * 4 + slot_offset`. The matrix is exactly 33 rows, matching the complete WeaponData namespace `WEAPON_EMPTY ($00)` through `WEAPON_ROCKET ($20)`. The former positional `row $00..$20` comments are therefore replaced by the corresponding `WEAPON_*` names.

The six pointers per side remain organized as three four-byte subvariants with two pointer slots each. the project does not rename those subvariants or slots beyond their proven geometry.

## Bank $18 compact resource selector covers $00-$1F only

`BattleScene_SelectResourceIndex` uses the same used-weapon byte as an index into a 32-byte compact table. the project renames this table to `BattleSceneWeaponResourceIndexTable` while retaining the older label as a compatibility alias. Its entries correspond one-for-one to WeaponData IDs $00-$1F (`WEAPON_EMPTY` through `WEAPON_MATERIAL`). `WEAPON_ROCKET ($20)` has a valid Bank $17 animation-matrix row but is deliberately outside this older 32-byte Bank $18 table.

No bounds behavior is inferred for `$20`; the caller path must be traced before claiming why this selector excludes the final WeaponData ID.

## Bank $14 caller / Bank $17 subvariant helper

Bank $14:$4000-$4244 is now source-owned. The policy-heavy $4000-$4200 lead-in remains byte-exact; the $4201-$4244 tail is mnemonic source as `BattleScene_PrepareUsedWeaponResource`. It calls the newly source-owned Bank $17:$4768 helper, copies caller-produced DE into one of two side-specific WRAM pairs, stages side/subvariant state, then farcalls `BattleScene_SelectResourceIndex`.

Bank $17:$4768-$477C is `BattlePlace_LoadAnimationSubvariantFromSceneState`. It indexes the byte array at $C4BD by $C4B5, stages the selected value at $C4D2, clears $C4D1, and falls through to the existing shared return at $477D. Higher-level names for those C4xx fields remain intentionally neutral pending their producers.
