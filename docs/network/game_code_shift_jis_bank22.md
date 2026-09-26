# Bank $22 game-code / Shift-JIS conversion

Bank `$22:$626D-$6361` owns the game's reverse text-encoding path: conversion
from one-byte internal game text codes to Shift-JIS byte streams.

- `Text_GetShiftJISForGameCode` indexes a 256-entry two-byte table.
- `Text_FindGameCodeForShiftJIS` scans the same table in reverse and returns
  fallback code `$0A` with carry set when no entry matches.
- `Text_ConvertGameCodeToShiftJISStream` converts a zero-terminated internal
  string to a cleared destination workspace.
- `Text_AppendShiftJISCode` emits either one byte or two bytes in Shift-JIS
  stream order while maintaining the 16-bit output offset at `$DF02/$DF03`.

The authoritative conversion table is source-owned at `$22:$7514-$7713` as
`Text_GameCodeToShiftJISTable`. Each `dw` is the little-endian representation
of the output Shift-JIS word, so entries such as `$829F` assemble as `9F 82`
and are emitted to the stream as `82 9F`.

The adjacent `$6362+` Shift-JIS-to-game-code stream parser remains its own
already-source-backed family.
