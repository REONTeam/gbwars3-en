# Campaign briefing pointer-table contract

the project corrected the physical-bank interpretation of the three pointer-table addresses used by the source-backed Bank `$25` map briefing viewer, and the project promotes those tables from non-emitting anchors into complete symbolic source:

- `$25:$405A` — `CampaignBriefing_PreMapPointerTable` (viewer group 0).
- `$25:$40B6` — `CampaignBriefing_ResultAPointerTable` (viewer group 2).
- `$25:$4000` — `CampaignBriefing_ResultBPointerTable` (viewer group 3).

Group 1 remains the same-bank `Beginner_Strings` table at `$25:$4BA9`.

## Why Bank `$25`, not `$33`

`MapBriefing_SetupScreen` executes in Bank `$25`. It loads one of `$405A`, `$40B6`, `$4000`, or `$4BA9` from `MapBriefing_GroupPointerTable`, indexes that address by `map_index * 2`, and immediately dereferences the resulting `HL` without switching ROM banks. Therefore the pointer-table bytes are physically in Bank `$25`. The 16-bit values read from those tables are addresses of Campaign text streams, which the Campaign text reader normally reads from Bank `$33`.

For the custom build `GBWARS3.gbc` (SHA-1 `2fd5074878763dbd00e6514f3856a6a466b999e9`), pre-map entry 0 is:

`$25:$405A -> $33:$4F3A`

the project/339 redirects only that first pre-map message to the expanded English Bank `$34:$4000` source. The legacy `$33:$4F3A` stream remains source-owned for preservation and table fidelity.

## the project table shape

The complete symbolic pointer families are **45 / 46 / 45** entries for Result B / Pre-map / Result A. The pre-map table has one extra pointer at its end, `$33:$6715`, labeled `CampaignBriefing_PreMap_Extra45`; it is not assigned a gameplay meaning until a caller proves why the extra entry exists.

All 136 targets are now defined in `data/campaign/campaign_briefing_text_bank33.asm`, and together they cover `$33:$4000-$7460` without gaps. The pointer tables themselves occupy `$25:$4000-$410F` exactly.
