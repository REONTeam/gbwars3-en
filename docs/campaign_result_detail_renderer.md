# Campaign result detail renderer

Bank `$27:$7A63-$7C83` is now source-owned as the Campaign result statistics page used by `CampaignResult_ShowSummary`.

- `$7A63-$7AA7` draws the shared statistic band/header used by the two side blocks.
- `$7AA8-$7C5E` initializes the result page, loads the common screen/font resources, draws the phase/day display, and renders both sides' statistics.
- `$7C5F-$7C83` contains the five zero-terminated labels consumed by the renderer.

The renderer reads the already behavior-backed campaign/map counters rather than introducing duplicate aliases: `wUnitBuiltCountSide0/1`, `wUnitLostCountSide0/1`, `wMapSide0Gold/1Gold`, and `wMapSide0Materials/1Materials`. The phase display is derived from `wMapPhaseNumber` using the same retail half-phase conversion used by the selected-map STATUS page.

The two remaining numeric fixed-bank calls at `$31F5/$3251/$32A3` are retained structurally because their formatting contracts are shared with existing source but have not yet been promoted to stable public symbols. No speculative names were added.
