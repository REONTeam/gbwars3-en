# Campaign map 02 English briefing translation

the project continues the map-order Campaign translation using the fixed Bank $34 relocation directory.

## Historical source meaning

- Result B 02 (`$33:$4002`): the advance through the desert was difficult, but the counterattack at `タビマハナさばく` succeeded and the enemy withdrew. The next operation is to intercept the enemy force invading toward `レコアンかいがん`.
- Pre-map 02 (`$33:$502F`): the enemy is advancing from `タビマハナサバク`. Cross the desert, secure air superiority, and destroy the enemy. Failure to destroy them within 30 days counts as defeat.
- Result A 02 (`$33:$67F2`): the interception succeeded. Having lost air superiority, White Moon abandoned its base and withdrew to `ベィトンさばく`; pursuit is ordered.

The English text retains the existing **TABIMAHANA DESERT** spelling from the project and conservatively romanizes the newly encountered proper names as **RECOAN COAST** (`レコアンかいがん`) and **BEITON DESERT** (`ベィトンさばく`). These spellings remain revisable while the Japanese source forms are preserved here.

## Bank $34 layout

- `$43FB-$4498`: `CampaignBriefing_ResultB_02_English`
- `$4499-$4554`: `CampaignBriefing_PreMap_02_English`
- `$4555-$45E3`: `CampaignBriefing_ResultA_02_English`

All rendered rows are 18 characters or fewer. Historical Bank $33 streams remain unchanged and source-owned; the relocation directory alone selects the English replacements.
