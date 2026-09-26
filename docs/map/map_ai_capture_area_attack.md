# Map AI capture and area-attack actions

the project behavior-resolves two more entries in the seven-way Bank `$0D` map-AI action dispatcher.

## Action 1: property capture

`MapAI_ActionCaptureProperty` dispatches to Bank `$0B:$648C-$6523`, now source-owned as `Unit_CapturePropertyAtCurrentPosition` (152 retail bytes). The executor consumes the active unit/current property state, runs the existing map-property transformation/presentation helpers, and finishes by calling `CampaignStats_IncrementCapturedProperties`. That independent Campaign-statistics side effect makes the action identity strong enough to promote from positional handler 1 to property capture while retaining `MapAI_ActionHandler1` as a compatibility alias.

The executor is now mnemonic through its full `$648C-$6523` range. Several lower-level Bank `$0B/$0C` property-transition/presentation helpers remain address-oriented, so the source keeps their contracts conservative while exposing the proven experience award, ownership rewrite, resolution refresh, income rebuild, Campaign statistic update, and final SFX path.

## Action 5: seven-hex area attack

`MapAI_ActionAreaAttack` calls Bank `$0C:$504F`, now `MapAI_ApplyAreaAttackAroundTarget`. It applies the effect once to the selected target hex and then to all six hex-grid neighbors using `HexGrid_GetNeighborCoord`. Per-cell HP removed is accumulated, returned in `A`, and the dispatcher awards the acting unit `10 + total HP removed` experience before refreshing its live-unit scratch record.

`MapAI_GetAreaAttackDamage` at `$5106` indexes one of two five-entry damage tables using the victim's established UnitData target class. If the acting unit is `UNIT_TYPE_BOMBER` or `UNIT_TYPE_MERCENARY_BOMBER`, the table is `1,2,3,0,1`; other callers use `2,3,0,1,0`. The presence of bomber-specific handling proves an area-bombardment role, but the project keeps the canonical action name at the broader **area attack** level until every producer that can select action ID 5 is sourced.

The per-cell executor at `$508B` is source-owned byte-for-byte but deliberately remains mostly `db` rows: its animation, kill/removal, and presentation helpers are still numeric dependencies. This preserves exact behavior without inventing unsupported names.
