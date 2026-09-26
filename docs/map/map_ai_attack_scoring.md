# Map AI attack scoring

the project splits the former opaque Bank $0D:$4749-$4A42 tactical scorer into natural callable routines while preserving the exact retail byte stream.

The strongest behavior-backed contracts are:

- `$47D1` builds a 50-bit mask over the opposing live-unit pool. A candidate is marked only when the acting unit has a weapon capable of damaging that target's five-way UnitData target class and the target is not filtered by the relevant live status bits.
- `$481F` builds weapon-capability scratch for both UnitData weapon slots. `$489E` combines a five-class nonzero-damage mask with range flags, and `$48C6` constructs the five-class mask directly from WeaponData attack values at offsets `$0A-$0E`.
- `$497B` uses the shared hex-grid distance primitive and accepts a coordinate pair only when distance lies inside the packed min/max range byte selected for the ranged weapon.
- `$48E5/$492E` scan the bounded movement/search rectangle and accumulate which opposing units are attackable from at least one usable candidate firing cell.
- `$499D` chooses a candidate firing coordinate by score. `$4A07` proves two score components: non-air units receive the normal Battle Cover value for the base tile, and any unit that can repair on that tile receives an additional `+100` bonus.
- `$4749` separately evaluates the six adjacent units around the staged action coordinate and retains the best packed tactical result. The exact meaning of the packed high/low-nibble comparison at `$47B0` remains conservative.

The 52-entry target-priority table-A contract from the project remains unchanged. `$4A35` returns the ordered priority list for an acting unit type; `$4A3C` remains a structurally valid profile-B lookup without a proven direct caller.

The source intentionally does not invent higher-level strategy names for the remaining packed score fields. The next semantic target is the Bank $0D:$6325-$6617 continuation, after which the project should pivot away from Bank $0D toward the larger Mobile, briefing/text-pointer, and graphics gaps.
