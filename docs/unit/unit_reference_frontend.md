# Unit Reference frontend

Bank `$25:$5DA5-$5E48` is the shared frontend for the detailed unit-information/reference screen. Readable gameplay callers use it from FIRE targeting, the Unit List, carried-unit/movement selection, and both unit-creation selectors.

## Public entry

`UnitReference_Open` at `$5DA5` accepts:

- `A` = unit type, or `$FF` to enter the internal type chooser first;
- `B` = side/palette selector.

Direct-type callers enter the details controller immediately. Chooser mode returns from the details controller to the type chooser when the user backs out, while direct-type callers leave the frontend.

## Local helpers

`UnitReference_ResetWorkState` at `$5DD9` temporarily selects WRAM bank 3 and clears the navigation/detail scratch used by this UI before restoring the caller's WRAM bank.

`UnitReference_DrawUnitName` at `$5E08` copies the selected UnitData name to the shared text buffer, applies the existing Unit List display encoding, and prints it.

`UnitReference_DrawUnitClassName` at `$5E1E` reads UnitData field `$18`, stores the resulting five-way class index, and dispatches through `UnitReference_ClassStringPointers` at `$5E3F`. The pointer order is:

1. `ARMORED`
2. `UNARMORED`
3. `AIR`
4. `SEA`
5. `SUB`

Those strings remain owned by `UnitStatus_Types`, beginning exactly at `$5E49`; the frontend therefore has a hard exclusive-end assertion at that address.

The frontend now enters `UnitReference_ChooseType` at `$61B9` and `UnitReference_RunDetailController` at `$6831` symbolically. Their shared navigation/setup and main detail-value renderer are source-owned, and the `$68A1` dispatcher now reaches all nine submenu controllers by name. The movement page beneath `$6F83` is source-owned through its terrain-grid renderer and selection helpers while the interleaved custom-English resources retain separate ownership. See `docs/unit/unit_reference_navigation_detail.md` and `docs/unit/unit_reference_submenus.md`.
