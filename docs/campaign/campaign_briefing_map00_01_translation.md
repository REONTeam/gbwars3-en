# Campaign maps 00-01 English briefing translation

the project begins the map-order Campaign translation after the project's generalized Bank $34 relocation directory.

## Historical source meaning

- Result A 00 (`$33:$676F`): congratulates the commander for a successful interception, states that the enemy has withdrawn to `クウェルかいがん`, and orders an advance there.
- Pre-map 01 (`$33:$4FBB`): surviving enemy forces have regrouped; break through the central forest and destroy them. The battle must be completed within 30 days or it counts as defeat.
- Result A 01 (`$33:$67BC`): the enemy has withdrawn toward `タビマハナさばく`; advance there and destroy them.
- Result B 00 and Result B 01 are one-byte terminators in the historical data and remain intentionally empty.

The English text uses conservative romanizations `KWELL COAST` and `TABIMAHANA DESERT`. The Japanese proper names are preserved above so those spellings can be revised later without losing source provenance.

## Bank $34 layout

- `$4227-$42C2`: `CampaignBriefing_ResultA_00_English`
- `$42C3-$43A1`: `CampaignBriefing_PreMap_01_English`
- `$43A2-$43FA`: `CampaignBriefing_ResultA_01_English`

Every rendered row is 18 characters or fewer. The historical Bank $33 streams remain present as byte-authoritative preservation source; only the relocation directory changes which stream is consumed at runtime.
