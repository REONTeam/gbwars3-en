# Bank $17 battle-place animation runtime (the project)

the project sources Bank `$17:$4000-$4486`, the complete shared animation-state runtime immediately before the established battle-place graphics-window loader at `$4487`.

The public `$4063` entry is now `BattlePlaceAnimation_InstallState`. Bank `$14` and Bank `$18` battle-scene setup both call it after staging the shared `$C4CC-$C4DB` animation state, and many other presentation callers in Banks `$1A/$26` use the same entry. The runtime copies/stores the staged state into its WRAM-bank-4 animation records and contains the update/store/address helpers through `$4486`.

The project two-byte UnitData/side/slot layout entry remains deliberately structural. `BattleScene_PrepareUsedWeaponResource` restores the pair into `HL` immediately before the Bank `$18` used-weapon selector, but that selector preserves `HL`; the following Bank `$14:$4193` path also does not read `HL`. `$4193` instead resets/stages the shared animation runtime and installs the default `BattlePlaceAnim_70C8` state through `$17:$4063`. Therefore the current scheduling path does **not** prove that the two bytes are coordinates, despite their coordinate-like numeric ranges.

the project confirms Bank `$16:$49A8` is the only direct farcall to the UnitData layout lookup and that this scheduling path still does not read the returned pair. The following Bank `$31:$4A4A+` bytes are now independently classified from their own resource geometry rather than inferred from the layout pair.
