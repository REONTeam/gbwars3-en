# Map AI transport route planning

the project owns Bank `$0D:$5DB5-$6182`, the previously missing transport-planning span between the phase-side helper and the bridge/direct-attack planners.

## Proven transport identities

`MapAI_RunAirTransportRouting` walks the active side's 50-unit pool and decodes the live type/side byte before accepting only UnitData types `$25/$2A/$2B`: Transport Plane, Transport Helicopter, and Transport Helicopter S. `MapAI_RunTransportShipRouting` performs the parallel scan for type `$30`, Transport Ship.

Both families use status bits 4-5 as a four-value route-state field. The exact player-facing names of all four states remain deliberately unnamed, but the transition behavior is byte-backed: the low state can advance when the unit is within six hexes of its source-side endpoint and passes the domain/terrain test; state `$10` advances to `$20` once the live carried-child count equals UnitData transport capacity; states `$20/$30` can reset to zero after the carried-child count reaches zero. The state writer preserves every status bit outside mask `$30`.

## Air versus sea endpoints

The air-transport path uses the current-side and opposing-side HQ coordinate helpers as its two route endpoints. The Transport Ship path instead consumes the project strategic route workspace directly: `$DE9C/$DE9D` is the nearest Port to the current HQ and `$DE9E/$DE9F` is the reachable approach cell in the opposing HQ's derived region.

`MapAI_FindNearestCompatibleTransportUnit` scans the active side pool for a nearest candidate that is occupied, not carried/ended, in route state `$10`, compatible under `UnitData_CheckLoadingCompatibility`, and not already at its UnitData transport-capacity limit. Distance is compared against the acting transport's coordinates and the best live-unit index is returned, or `$FF` when no candidate qualifies.

## Boundary correction

the project had split the bridge planner one byte late. Retail `$6183-$6184` is `F0 82` (`ldh a,[$82]`): `$6183` is the opcode and `$6184` is its operand. The bridge/direct-attack planner section now begins at `$6183`, making `$5DB5-$6182` the exact preceding transport-planning range.

The corrected bridge/direct-attack planner range is `$6183-$6324` (418 bytes, SHA-1 `44b3b5a151a5f74d884d623ae3d7a0ddf16f17e9`). The new transport-planning range is 974 bytes, SHA-1 `a37db795d68edb333278eb70f6fa3a6af9c590c8`.
