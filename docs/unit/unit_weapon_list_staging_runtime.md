# Bank $12 weapon / unit-list staging anchors

the project records the source boundary immediately after the sourced reserve-unit
routines without transcribing bytes that are still owned by the base-ROM
overlay. The addresses and broad behavior are corroborated by the project ROM
map; exact instruction bodies must be sourced only when `baserom.gbc` is
available again.

## Weapon staging: `$4837-$490A`

- `$4837` `UnitWeapon_CopyNameToBuffer` copies the selected weapon's display
  name into the shared `$CD28-$CD2F` name buffer. The caller supplies a unit
  type and selects one of the UnitData weapon slots.
- `$4855` `WeaponData_GetByte` reads one byte from a WeaponData definition.
- `$4862` `UnitWeapon_BuildSummary` stages both weapon slots for one live unit
  in `$CCED-$CD08`.
- `$48FC` `UnitWeapon_GetAttackValue` selects a WeaponData attack-family value
  for a unit/weapon combination.

The staged summary occupies exactly 28 bytes: two 14-byte records. The ROM-map
layout for each record is a 9-byte name/display field followed by weapon ID,
current ammo, minimum range, maximum range, and definition max ammo. the project
names that RAM as `wUnitWeaponSummaryBuffer` and records the geometry with
`UNIT_WEAPON_SUMMARY_*` constants. This is a structural staging contract, not
a claim about the still-unsourced instruction sequence.

## Temporary unit list: `$490B-$497E`

- `$490B` `UnitListScratch_Clear` clears `$D640-$D95F`.
- `$4926` `UnitListScratch_CopyUnit` copies one live unit into the temporary
  list.
- `$494A` `UnitListScratch_GetRecordPointer` returns a pointer within that
  list.
- `$4958` `UnitListScratch_CopySide` populates the list for one side/army.

`$D640-$D95F` is exactly 800 bytes, matching 50 records x the established
16-byte live-unit record size. It is therefore named `wUnitListScratch` and its
geometry is expressed using the existing `UNIT_RECORDS_PER_SIDE` and
`UNIT_RECORD_SIZE` constants rather than duplicating numeric dimensions.

## Allowed-unit / promotion data: `$497F-$4A42`

- `$497F` `UnitPurchase_BuyableTypeData` is the buyable-unit data immediately
  after the temporary-list helpers.
- `$4986` `UnitPurchase_AllowedListPointers` is the pointer layer for the
  separate allowed-unit lists.
- `$49A5` `UnitPurchase_AllowedLists` begins those lists.
- `$4A0F` `UnitPromotionTypeTable` remains the previously established promotion
  mapping immediately before `UnitData` at `$4A43`.

The ROM map describes the allowed-list progression, but the project intentionally
does not transcribe or reinterpret the table bytes without the verification
ROM. These labels are precise sourcing anchors for the next byte-authoritative
work.

## Relationship to the semantic data tables

This scaffold closes the conceptual gap between the already explicit
`UnitData`, `WeaponData`, and live-unit record schemas and the next overlay
region. Once the ROM is restored, `$4837-$490A` should be sourced first because
it directly consumes weapon names/ranges/attack values; `$490B-$4A42` can then
be sourced into the unit-list, purchase, allowed-list, and promotion layers.

## the project typed weapon-summary RAM contract

The 28-byte summary workspace is now exposed as two typed 14-byte records:
`wUnitWeaponSummary0` at `$CCED` and `wUnitWeaponSummary1` at `$CCFB`.
Each has named aliases for its 9-byte display-name area, weapon ID, current
ammo, minimum range, maximum range, and definition maximum ammo. The final
byte of slot 1 is therefore exactly `$CD08`; `$CD09+` is not part of this
workspace.

The source relationships are also explicit without asserting an instruction
sequence: slot weapon IDs come from UnitData weapon offsets `$14/$16`, current
ammo comes from live-record offsets `$08/$09`, maximum ammo comes from UnitData
`$15/$17`, and range comes from WeaponData `$08/$09`. This makes the staging
buffer a documented join of the three already-source-backed schemas. Attack
family values remain outside these 14-byte records and are obtained through
the separate `$48FC` accessor anchor.

## the project typed temporary-unit-list contract

The `$D640-$D95F` workspace is now typed explicitly as **50 records using the
same 16-byte geometry as the live-unit pool**. `UNIT_LIST_SCRATCH_*` field
aliases point back to the already-proven `UNIT_RECORD_*` offsets rather than
creating a second independent layout. Known copied fields therefore include
encoded type/side, X/Y, status, HP, carried-child count, carrier index, fuel,
both ammunition bytes, and experience.

The source deliberately does **not** invent meanings for bytes `$0C-$0F`.
Those four bytes remain the same runtime-only tail already documented for live
records, and the scratch contract preserves their position as a four-byte
region beginning at record offset `$0C`.

The exact bounds are now available symbolically: `wUnitListScratchFirst` is
`$D640`, `wUnitListScratchLast` is the 50th record at `$D950`, and
`wUnitListScratchEnd` is the exclusive end `$D960`. This proves that the final
record occupies `$D950-$D95F` and prevents later `$490B-$497E` sourcing from
silently overrunning into `$D960+`.

This remains a **RAM/layout contract only**. The instruction bodies at
`$12:$490B-$497E` are still overlay-owned until the Japanese verification ROM
is restored.
