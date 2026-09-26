# Reserve-unit storage semantics

the project resolves the conservative compact-list layer introduced in the project as reserve-unit storage.

## Evidence

Bank `$12:$47CE-$4836` is already source-backed and byte-locked by the the project verifier. The first routine serializes occupied live-unit slots 0-49 into fixed four-byte entries beginning at `$C6A8`; the second recreates those entries at off-map coordinates `$FF,$FF` and writes status value `$02` to each recreated record.

The DataCrystal RAM map independently identifies `$C6A8+` as reserve-unit stats and describes live-record status byte `$03` bit 1 as `Reserve`. These two observations match the existing sourced behavior exactly: `$02 == 1 << 1`.

## Source names

- `wReserveUnitList = $C6A8`
- `ReserveUnits_SaveSide0` at Bank `$12:$47CE`
- `ReserveUnits_RestoreSide0` in the same source-backed range
- `UNIT_RECORD_STATUS_RESERVE_F = 1`

The names retain `Side0` because both routines iterate only live slots 0-49; no assumption is made that another equivalent list exists for side 1.

## Entry format

Each of the 50 slots occupies four bytes:

1. encoded unit type/side byte; zero means unused entry
2. live-record word `$0A` low byte
3. live-record word `$0A` high byte
4. `$FF`

The experience word at `$0A-$0B` remains semantically unnamed. the project proved only that it is capped at 400 and has a quotient-by-100 helper; reserve-unit identification does not justify promoting that field further.

## Remaining caller work

Known overlay-owned callers remain Bank `$11:$49A9` for the save path and Bank `$0B:$40E9` for the conditional restore path (`$C62F == 1`). Those caller bodies should be sourced from the retail ROM before assigning a narrower gameplay mode/feature name to the reserve mechanism.
