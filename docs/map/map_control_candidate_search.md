# Map-control phase candidate searches

the regression suite resolve the two candidate searches and the caller that combines them. The resulting pair is specifically a **Transport Ship route probe**, while downstream tactical use remains conservatively named.

`MapControl_FindNearestPortRecordToCurrentHQ` at `$0D:$5AC2-$5B19` scans the 100 three-byte analysis records at WRAM-bank-1 `$DD81`. For each non-`$FF` record it reads the map tile at the record's X/Y coordinate, converts that raw tile through `TerrainNameIndexByMapTile`, and keeps only terrain-name class `MOVEMENT_TERRAIN_PORT`. It ranks those records by `HexGrid_GetDistance` from the current phase side's HQ and returns the nearest X/Y pair in `B/C`; equal-distance records replace earlier ones.

`MapControl_FindTransportRouteCandidates` stores that first result at `$DE9C/$DE9D` as `wMapControlTransportPortX/Y`, then loads encoded unit `$60`, which is exactly `UNIT_TYPE_TRANSPORT_SHIP << 1`, before calling `MapControl_BuildMovementCostField`. The selected Port is therefore the seed for a Transport Ship movement-cost field.

`MapControl_FindNearestOpposingHQRegionCell` at `$0D:$5B1A-$5B89` then reads the derived-region byte at the opposing HQ from SRAM bank `$0C`, scans the active map for cells in the same region, and requires a non-`$FF` entry in the parallel bank-$0D movement-analysis plane. The nearest such finite-cost cell to the opposing HQ is returned in `B/C` and stored at `$DE9E/$DE9F` as `wMapControlTransportApproachX/Y`.

Bit 2 of `$DEA0` is set only if both searches succeed, so `MAP_CONTROL_ANALYSIS_TRANSPORT_ROUTE_F` means that both ends of this Transport Ship route probe are available. Older `PortCandidate`, `OpposingHQRegionCandidate`, `PrimaryCandidate`, `SecondaryCandidate`, and `FindBestPhaseUnit` names remain compatibility aliases.
