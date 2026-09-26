# Map-tile runtime contract

the project source-backs the complete Bank $0B:$4714-$4821 map-cell accessor/status layer directly from the Japanese retail ROM. The range is 270 bytes (SHA-1 `6384fc290afd30f9a13daa4fa0df6939c2b615a7`).

## Map planes

The runtime map grid is addressed through the already-sourced `MapGridCoord` helper. These routines temporarily select WRAM bank 1 or 2, then restore the caller's previous WRAM bank.

- WRAM bank 1 stores the six-bit base/raw map-tile ID in bits 0-5 plus two status bits in bits 6-7.
- WRAM bank 2 stores the overlay byte; `MapTile_GetOverlayIdAtCoordinates` masks its high bit and returns bits 0-6.

The sourced accessors are `MapTile_ReadBank1AtCoordinates`, `MapTile_ReadBank2AtCoordinates`, `MapTile_WriteBank1AtCoordinates`, and `MapTile_WriteBank2AtCoordinates`.

## Base and overlay IDs

`MapTile_GetBaseIdAtCoordinates` at $4770 returns `bank1_value & $3F`. `MapTile_SetBaseIdAtCoordinates` replaces only those low six bits and preserves bank-1 bits 6-7.

This remains a **base/raw tile ID**, not the 23-class terrain-name index. The separate source-backed `Terrain_GetNameIndex` performs that higher-level conversion.

`MapTile_GetOverlayIdAtCoordinates` at $4792 returns `bank2_value & $7F`; `MapTile_SetOverlayByteAtCoordinates` writes the complete bank-2 byte supplied by the caller.

## Status selectors

The retail instructions now prove the selector mapping used by `MapTile_SetFlagAtCoordinates` and `MapTile_ClearFlagsAtCoordinates`:

- selector 0 -> WRAM bank 2 bit 7
- selector 1 -> WRAM bank 1 bit 6
- selector 2 -> WRAM bank 1 bit 7

For selectors 1/2 the game derives the bank-1 mask with two rotate-right operations. The existing `Unit_ClearEndTurnFlagsForSide` caller uses selector 2, therefore clearing bank-1 bit 7 exactly as observed before the project.

`MapTile_ClearAllFlagsAtCoordinates` clears both high bits in bank 1 and then clears bank-2 bit 7, preserving only the six-bit base terrain ID in bank 1.

## Source ownership

The former symbol-only `$4770/$47BF` anchors have been removed from `symbols.asm`; both calls now resolve to emitted labels in `data/terrain.asm`. No English/customized assets or map payloads are changed.
