# Purchase-choice RAM layout

the project tightens the purchase-choice RAM contract using the established Bank $12 purchase helpers and the external RAM-map description.

- `$CD09-$CD0A` is the two-byte live-unit headcount array: side 0 at `$CD09`, side 1 at `$CD0A`.
- `$CD0B` is the number of buyable unit types currently staged for the selected property/context.
- `$CD0C-$CD1A` contains exactly **15 unit-type entries**.
- `$CD1B-$CD27` remains deliberately unclaimed. It is not folded into the purchase list merely because the next already-named object, `wUnitNameBuffer`, begins at `$CD28`.

This corrects the earlier current source safety-only bound that treated `$CD0C-$CD27` as the maximum possible contiguous purchase staging area. That bound was useful for avoiding overlap but was not the actual list size.

The still-overlay-owned Bank `$12:$43F4-$446F` builders remain responsible for populating this count/list pair. Their instruction bytes are not reconstructed here because `baserom.gbc` is unavailable.
