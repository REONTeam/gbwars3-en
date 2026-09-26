# Map action effects and BOMB targeting

Bank `$0C` owns a shared map-action effect layer that connects direct-battle HP results, animated unit destruction, BOMB target selection, area-attack effects, and their sprite resources.

## Runtime ownership

`$4E27-$504E` is mnemonic source in `engine/map/map_action_effect_runtime_4e27.asm`.

- `Battle_CalculatePackedHPDamage` (`$4E27`) builds the two combat participant records and packs the first calculated HP losses into one byte: attacker in the high nibble, defender in the low nibble.
- `MapActionEffect_LoadGraphics` (`$4E53`) uploads the 37 shared effect tiles to VRAM bank 1 at `$8000`.
- `MapActionEffect_LoadPalettes` (`$4E66`) installs the two OBJ palettes used by map effects while temporarily suppressing terrain-animation updates.
- `Battle_ResolveDestroyedParticipants` (`$4E85`) checks the final attacker/defender HP values and routes zero-HP participants through the shared destruction path.
- `Unit_DestroyWithMapAnimation` (`$4ECB`) clears the unit's map presentation, stages the destruction effect, waits for its sprite animation to finish, and then deletes the unit and any carried children.
- `UnitAction_RunBombTargetSelection` (`$4F3A`) handles BOMB target confirmation. Most BOMB-capable units use immediate confirmation; Mercenary Missile Frigate and Submarine-S use the ranged selector and require hex distance 3 through 7 inclusive.

The runtime is 552 bytes and matches the Japanese retail instruction stream byte-for-byte. The custom-English build uses the same machine code in this range.

## Effect resources

`$52A6-$5625` is source-owned as one connected resource family:

- `$52A6-$5399`: OAM-frame definitions used by map effects.
- `$539A-$53AD`: unit-destruction animation stream.
- `$53AE-$53C1`: area-attack animation stream.
- `$53C2-$53C5`: two-entry animation pointer table.
- `$53C6-$5615`: 37 two-bit Game Boy tiles (592 bytes), authored as `gfx/effects/map_action_effects.png` and generated as `gfx/effects/map_action_effects.2bpp`.
- `$5616-$5625`: two four-color BGR555 OBJ palettes.

The editable indexed PNG regenerates the exact retail 2bpp payload with the project's legacy `rgbgfx`.

## Integration

The connected callers now use symbolic entries:

- selected-map setup loads `MapActionEffect_LoadGraphics`;
- the area-attack runtime calls `MapActionEffect_LoadPalettes`, uses `MapActionEffect_AreaAttackAnimation`, and routes destroyed units through `Unit_DestroyWithMapAnimation`;
- the Unit Action BOMB executor calls `UnitAction_RunBombTargetSelection`.

The HP-change presentation service beginning at Bank `$0C:$5D3E` remains a separate connected subsystem. Its callers and resources are sufficiently distinct that it is not folded into this module without its own producer/consumer analysis.
