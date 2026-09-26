# Bank $25 map briefing/message viewer

the project identifies Bank `$25:$48AD-$4BA8` as the controller used to display map briefing/message text. The controller is deliberately split around existing customized source: `$491F-$4962` remains the project's sidecar-aware 9-character map-name renderer, and `$4BA9+` remains the existing `Beginner_Strings` data.

## Shared-WRAM lifetime

While this viewer is active, the shared `$C61A-$C622` scratch window has another local lifetime:

- `$C61A` `wMapBriefingGroup`: selects one of four briefing pointer groups.
- `$C61B` `wMapBriefingInputState`: input/return-state mask used by the viewer loop.
- `$C61D` `wMapBriefingDisplayVariant`: selects the presentation resource path used by the two public entry variants.
- `$C622` `wMapBriefingMapIndex`: map/message index used within the selected group.

These aliases do not replace the infrared, Unit Status, or Campaign-map-selector meanings over the same physical WRAM.

## Briefing groups

Caller behavior proves group 0 is used for Campaign pre-map messages and group 1 for Beginner instructional briefings. Groups 2 and 3 are selected by the Campaign clear/result path and remain conservatively named result A/B until their outcome semantics are sourced more directly.

`MapBriefing_GroupPointerTable` has four words. Group 1 points directly at the existing local `Beginner_Strings` table at `$4BA9`. Groups 0, 2, and 3 point into the Bank `$33` Campaign text area and are consumed through the Bank `$33` text helper; the Beginner path instead uses the same-bank text helper.

## Ownership boundaries

- `$48AD-$491E`: entry/setup/availability layer.
- `$491F-$4962`: **not owned here**; existing custom `UnitStatus_DrawAlternateMapName` remains authoritative.
- `$4963-$4BA8`: screen setup, text selection, paging/input loop, and four-word group-pointer table.
- `$4BA9+`: **not owned here**; existing `Beginner_Strings` remains authoritative.

The Japanese ROM is used only to verify the retail executable ranges. Existing English/customized strings and map-name rendering are preserved.
