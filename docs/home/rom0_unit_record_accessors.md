# ROM0 live-unit record accessors

the project source-backs ROM0 `$090B-$0984` as a compact fast-path API over the 100 x 16-byte live-unit pool in WRAM bank 3.

- `$090B` `UnitRecord_GetByteROM0`: A = unit index, C = byte offset, returns A.
- `$0927` `UnitRecord_GetWordROM0`: A = unit index, C = byte offset, returns little-endian DE.
- `$0942` `UnitRecord_SetByteROM0`: A = unit index, B = value, C = byte offset.
- `$095E` `UnitRecord_GetCoordinatesROM0`: A = unit index, returns B = X and C = Y.
- `$097A` `UnitRecord_GetAddressROM0`: L = unit index, returns `$D000 + index * 16` in HL while WRAM bank 3 is selected by the caller.

These are separate from the Bank $12 general UnitRecord API. The Bank $0D tactical AI calls the ROM0 family directly to avoid a farcall for common reads during large candidate scans.
