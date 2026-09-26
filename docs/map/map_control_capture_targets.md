# Map-control capture-target classification

the project sources the Bank `$0B` predicate that the project had left as the raw farcall `$0B:$7D33`. Following its input producer changes the interpretation of the surrounding `$DD80/$DD81` workspace: each three-byte record is a raw map-tile ID followed by X/Y coordinates, not a live-unit record. The 13-byte bitfield at WRAM-bank-2 `$DD80` is therefore a 100-record **capture-target mask**.

`MapTile_GetPhaseOwnershipClass` at `$0B:$7CF7-$7D23` classifies a raw tile relative to `wMapPhaseNumber & 1`: `0` = active-side property, `1` = opposing-side property, `2` = neutral property, `3` = ordinary terrain. This is byte-proven from the property ID ranges `$01-$0B`, `$0C-$16`, `$17-$1F`, and terrain beginning at `$20`.

`MapControl_IsCaptureTargetRejected` at `$0B:$7D33-$7D53` uses that class plus four explicit neutral ruin IDs. Its retail return convention is inverted: `A = 0` only for an opposing property or an intact neutral property, and `A = 1` for active-side properties, ordinary terrain, and neutral City/Base/Airport/Port ruins (`$18/$1A/$1C/$1E`). `MapControl_RebuildCaptureTargetMask` inserts a record bit only when this predicate returns zero.

The neutral-property names are independently supported by the already-source-backed `TerrainNameIndexByMapTile` table: `$17-$1F` map to City, City Ruins, Base, Base Ruins, Airport, Airport Ruins, Port, Port Ruins, and Com Tower respectively. The older `MapControl_RebuildUnitEligibilityMask` symbol remains as a compatibility alias, but new source should use the capture-target name.
