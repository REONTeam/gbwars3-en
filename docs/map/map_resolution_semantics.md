# Map resolution state

The end-of-map controller stages two shared bytes before result presentation and finalization:

- `wMapControlWinningSide` (`$CA94`) is one-based: `1` means side 0 won and `2` means side 1 won.
- `wMapControlResolutionType` (`$CA95`) selects the resolution path.

The source-backed writers establish four resolution types:

- `MAP_RESOLUTION_TYPE_HQ_LOSS` (`1`) — one side's HQ tile count reaches zero.
- `MAP_RESOLUTION_TYPE_FORCE_DEFEAT` (`2`) — a previously fielded side has no live units; Beginner completion also reuses this result presentation class.
- `MAP_RESOLUTION_TYPE_YIELD` (`3`) — Yield or Interrupt is confirmed, so the opposing side is staged as the winner.
- `MAP_RESOLUTION_TYPE_TURN_LIMIT` (`4`) — the map-specific or common day limit is reached.

`MapControl_PresentTransitionResult` consumes the resolution type, while `MapControl_FinalizeTransitionResult` converts the one-based winner to the side parameter required by the downstream presentation/finalization service.

## HQ detection

The shared map/editor setup scan rebuilds a 52-byte raw-tile histogram at `wMapTileCountsById` (`$C64A`) and records both HQ coordinates. This gives two direct aliases used by the resolution controller:

- `wMapSide0HQTileCount` = `$C64B` (raw tile `$01`)
- `wMapSide1HQTileCount` = `$C656` (raw tile `$0C`)

Capture and terrain-development writers now call `MapGrid_DecrementTileCount` / `MapGrid_IncrementTileCount` symbolically, keeping the histogram synchronized when terrain ownership/type changes.

## Day-limit providers

The Bank `$28` map runtime already owned the two lookup services used by the turn-limit controller. They are now exposed by their proven role:

- `MapRuntime_GetCampaignDayLimit` at `$28:$4157`
- `MapRuntime_GetBeginnerDayLimit` at `$28:$41C4`

The second Campaign table byte remains structurally named because its independent meaning is not yet closed.
## Infrared battle mode

`wMapControlInfraredBattleMode` (`$C630`) is distinct from the winner/resolution pair. `Versus_RunStyleCountryController` writes `0` for ordinary local battle and `1` for the infrared/remote style. The selected-map command builder/controller reads it to expose Interrupt instead of Yield and to change which suspend/end commands are available; the map menu uses it for IR-battle presentation; the result finalizer uses it to decide whether the opponent-cancel prompt is required.

`wSelectedMapCommandModeState` remains only as a compatibility alias to the canonical infrared-mode name.

