# Unit HP transfer runtime

the project establishes the Unit Status pair-adjustment screen as a unit-to-unit HP redistribution action rather than a generic comparison screen.

## Lifetime-scoped WRAM

The action reuses the same physical `$C941-$C944` bytes that the battle system uses for short-lived combat scratch. While this Bank `$0B/$25` action is active they mean:

- `$C941` `wUnitTransferTargetUnitID` — live-unit index selected as the second/target unit.
- `$C942` `wUnitTransferSourceHP` — current HP of the source/left unit. It is seeded from the source unit scratch record at `$CCDD + 4`.
- `$C943` `wUnitTransferTargetHP` — current HP of the selected target/right unit, read from live-record offset `$04`.
- `$C944` `wUnitTransferMaxHP` — UnitData maximum HP (`UNIT_DATA_MAX_HP_OFFSET`) used as the cap for both panes.

These aliases do not replace the battle-lifetime names for the same physical WRAM.

## Screen behavior

Bank `$25:$4110-$42BD` transfers one HP point per left/right input. One direction decrements the source and increments the target; the opposite direction does the reverse. The transfer is rejected if the donor is already zero or the receiver is already at maximum HP. Therefore the combined HP total is preserved while both unit values remain in `[0, max_hp]`.

The A-button guard compares the project HP against the snapshot saved in `wUnitStatusInitialLeftValue`; confirming an unchanged distribution is rejected.

## Producer / commit path

Bank `$0B:$4DF2-$4F81` is source-backed as the surrounding HP-transfer action. It selects the target unit, loads target HP, seeds source HP and maximum HP, invokes the Bank `$25` screen, then commits the edited values. If either resulting HP reaches zero, the corresponding live unit is deleted through the existing unit-deletion path.

The newly owned Bank `$25:$43B3-$43BC` rank-tile table and `$448C-$44F2` layout lookup complete the previously open data/helper gaps inside the Unit Status presentation layer.
