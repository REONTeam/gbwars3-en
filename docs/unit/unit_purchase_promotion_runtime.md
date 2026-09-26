# Unit purchase / promotion runtime

the project source-backs the complete Bank `$12:$43F4-$4509` purchase and
promotion runtime directly from the supplied Japanese retail ROM. The range is
**278 bytes**, SHA-1 `30c5948158903e9103bd937668a9964ff29284b2`.

## Purchase list construction

`UnitPurchase_BuildPropertyUnitList` rebuilds `wBuyableUnitList` for a property
class. The retail branches select contiguous UnitData type ranges and feed them
through `UnitPurchase_AppendAvailableTypeRange`; accepted types are appended to
the 15-entry `$CD0C-$CD1A` list and `wBuyableUnitCount` is updated.

`UnitPurchase_AppendMercenaryTypeRange` installs the fixed five-type special
list used by its caller. The five literal UnitData indices are retained as
retail data until their higher-level UI/property consumer justifies a more
specific semantic label.

## Purchase filters

`UnitPurchase_CheckBuyable` tests `UnitPurchase_BuyableTypeData`.
`UnitPurchase_CheckAllowedList` uses `wUnitPurchaseAllowedListSelector` and
`UnitPurchase_AllowedListPointers`; `UnitPurchase_GetAllowedListBit` performs
the word-table lookup and bitfield test. Both filters use the established
contract `UNIT_PURCHASE_FILTER_ALLOWED = 0` and
`UNIT_PURCHASE_FILTER_BLOCKED = 2`.

the project already source-backed the associated `$497F-$4A0E` buyable/allowed
data. The retail ROM proved 16 pointer slots at `$4986-$49A5` selecting 15
distinct seven-byte cumulative bitfields at `$49A6-$4A0E`; slots 0 and 1 share
the first bitfield.

## Promotion runtime

`UnitPromotion_GetEligibleEncodedType` proves promotion requires
`UNIT_RANK_S`. It reads the existing encoded type/side byte, looks up the
promoted UnitData type through the 52-byte `UnitPromotionTypeTable`, then
restores the original side bit in the encoded result.

`UnitPromotion_Apply` now proves the behavior that the earlier opaque source could only
document from references. When an eligible promotion exists it:

- records the promoted unit through `CampaignStats_MarkProcuredUnit`;
- replaces the live encoded type/side field;
- **resets experience** to zero;
- **refills fuel** from the promoted UnitData definition; and
- refills both live ammunition fields from the promoted definition's maximums.

The routine does not alter the live HP field in this tranche. All existing
English/customized UnitData names and bytes remain authoritative.

## Fixed data geometry

`UnitPromotionTypeTable` occupies `$12:$4A0F-$4A42`, exactly **52 mapping bytes**, one for UnitData indices 0-51. The trailing UnitData index 52 `DUMMY`
definition has no promotion-table entry.

The purchase-choice workspace remains `$CD0B` count plus exactly 15 unit-type
entries at `$CD0C-$CD1A`; `$CD1B-$CD27` remains deliberately unclaimed before
`wUnitNameBuffer` at `$CD28`.
