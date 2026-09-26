# Unit purchase filter / promotion return contracts

the project source-backs the Bank `$12:$4470-$44BF` purchase-filter and promotion
helper layer directly from the supplied retail ROM. The surrounding
`$43F4-$4509` runtime is now explicit source rather than symbol-only anchors.

## Shared purchase-filter result

- `UnitPurchase_CheckBuyable`: `A = 0` when the unit type is buyable; otherwise
  `A = 2`.
- `UnitPurchase_CheckAllowedList`: `A = 0` when the unit type passes the active
  allowed-unit list; otherwise `A = 2`.

These values are named `UNIT_PURCHASE_FILTER_ALLOWED = 0` and
`UNIT_PURCHASE_FILTER_BLOCKED = 2`.

`UnitPurchase_GetAllowedListBit` indexes the source-backed 16-word allowed-list
pointer table and tests the requested UnitData type in the selected seven-byte
bitfield. the project proved that the 16 pointer slots select 15 distinct bitfield
records and that slots 0 and 1 intentionally share the first record.

## Promotion encoded-type relationship

`UnitPromotion_GetEligibleEncodedType` is now source-backed. It requires
`UNIT_RANK_S`, reads the existing encoded live type/side byte, looks up the
promoted UnitData type, and restores the original side bit. The representation
therefore remains the established `(unit_type << 1) | side`, with
`UNIT_TYPE_SIDE_SHIFT = 1` and `UNIT_TYPE_SIDE_MASK = 1`.

`UnitPromotion_Apply` proves the non-eligible path returns without modifying the
record. Eligible promotion updates the type, resets experience to zero, and
refills fuel and both ammunition fields from the promoted UnitData definition.
