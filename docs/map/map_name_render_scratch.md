# Map-name render scratch contract

the project promotes the temporary buffers used by the custom nine-character map-name renderer from raw WRAM addresses to shared symbols. This is source integration for the existing English/custom implementation; it does not change the physical eight-byte retail name field, the header-sidecar ninth character, or any emitted instruction/address bytes.

All three render layouts have the same logical shape: eight copied retail name bytes, one ninth character, then one borrowed byte used as a temporary zero terminator. The renderer must preserve that final live byte around `TextPut`/alternate rendering calls.

| Consumer | Scratch base | Character 9 | Borrowed terminator | WRAM bank |
| --- | --- | --- | --- | --- |
| Editor status | `$CC65` | `$CC6D` | `$CC6E` | 0 |
| Map Menu loaded name | `$DC3B` | `$DC43` | `$DC44` (`wMapMenuDownloadMapNumber`) | current mapped bank/context |
| Unit Status loaded name | `$DB5A` | `$DB62` | `$DB63` | 4 |

The common geometry is `MAP_RECORD_NAME_SIZE` (8) + one sidecar character + one borrowed terminator = `MAP_NAME_RENDER_SCRATCH_SIZE` (10). The terminator bytes are not newly allocated storage: each is saved before rendering and restored immediately afterward. In particular, `$DC44` is now proven by `MapMenu_DisplayMapDataStatus` to hold the displayed download-map number. Its primary symbol is therefore `wMapMenuDownloadMapNumber`; `wMapMenuMapNameScratchBorrowedTerminator` is retained as an alias describing how the nine-character renderer temporarily borrows the same live byte. The renderer must save and restore it around text drawing.
