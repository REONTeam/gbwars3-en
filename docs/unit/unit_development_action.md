# Construction / terrain development action

the project behavior-proves map-AI action ID 2 as the Construction Truck terrain-development action.

Bank `$0B:$489C-$4940` is source-owned as `Unit_DevelopTerrainAtCurrentPosition`. The executor reads the active unit's current map cell, consumes the first live weapon-ammo/material field at unit-record offset `$08`, mutates the terrain through the existing map-tile helpers, and commits the result. Neutral City/Base/Airport/Port ruins are recognized separately and require the two-charge path; the ordinary developable natural classes are Plain, Wood, and Wasteland.

The Campaign side effect is now symbolic: `$11:$4D67` is `CampaignStats_IncrementDevelopedProperties`, incrementing the already-typed 16-bit `$C77A/$C77B` developed-property statistic under the established Campaign/side gate. The immediately preceding `$4D5A` mirror increments `$C778/$C779` and is therefore `CampaignStats_IncrementCapturedProperties`.

The seven-way dispatcher at `$0D:$4407` now names handler 2 `MapAI_ActionDevelopTerrain` while retaining `MapAI_ActionHandler2` as a compatibility alias. Existing English/customized data is unaffected.
