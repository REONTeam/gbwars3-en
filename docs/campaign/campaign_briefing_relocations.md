# Campaign briefing relocation directory

the project generalizes the Bank $34 relocation used by the expanded Campaign introduction.

## Runtime contract

The historical Bank $25 pointer tables remain authoritative for all Campaign groups. At the first byte of a Campaign message, `CampaignBriefing_ReadByte` checks the corresponding Bank $34 relocation entry:

- zero: keep the staged historical pointer and read the message from Bank $33;
- nonzero: replace the staged pointer with the Bank $34 address and read the entire message from Bank $34.

`wMapBriefingTextBankState` at briefing-lifetime scratch $C61C caches the decision (`0` unresolved, `1` Bank $34, `2` Bank $33). The previous introduction-specific aliases remain for compatibility only.

## Directory layout

The directory is fixed at the top of Bank $34 and mirrors the Bank $25 pointer families exactly:

- `$34:$7EF0-$7F49`: 45 Result-B relocation pointers;
- `$34:$7F4A-$7FA5`: 46 Pre-map relocation pointers;
- `$34:$7FA6-$7FFF`: 45 Result-A relocation pointers.

All 136 entries now point into Bank $34. Existing English replacements cover the opening maps; all remaining entries point to readable Japanese plaintext defined directly in `campaign_intro_extension.asm`; those sources re-encode byte-identically to the original Bank `$33` messages.

## Capacity

The supplied historical custom `GBWARS3.gbc` has both Banks $34 and $35 entirely filled with `$FF`. Bank $34 now contains the expanded opening English material plus Japanese relocation copies through `$779E`, while `$34:$7EF0-$7FFF` remains the 272-byte relocation directory. The current layout leaves 1,873 bytes at `$34:$779F-$7EEF` for message growth. Bank $35 remains a separate untouched 16 KiB expansion bank if Bank $34 is ever exhausted.

All relocation entries are populated. Future translations should edit or translate the corresponding Japanese plaintext in `campaign_intro_extension.asm` while keeping its label stable. Message data must remain below `$7EF0`.
