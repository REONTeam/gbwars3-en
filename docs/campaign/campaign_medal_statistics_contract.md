# Campaign medal / statistics contract

the project corrects the old current source bank attribution: these routines are in physical Bank `$11`, not Bank `$18`. The error came from treating a DataCrystal block number as a physical ROM bank. Five high-confidence routine ranges are now byte-authoritative source; intervening Bank `$11` code remains overlay-owned.

## Statistics RAM

- `$C770-$C771`: destroyed Lite Land count (16-bit)
- `$C772-$C773`: destroyed Armor count (16-bit)
- `$C774-$C775`: destroyed Air count (16-bit)
- `$C776-$C777`: destroyed Ship count (16-bit)
- `$C778-$C779`: captured properties count (16-bit)
- `$C77A-$C77B`: developed properties count (16-bit)
- `$C77C`: declined Yields count
- `$C77D-$C783`: seven-byte procured-unit bitfield
- `$C784-$C7B0`: 45 one-byte Campaign-map clear counters

This tightens the earlier reserve-buffer boundary: the source-backed reserve list ends at `$C76F`, and `$C770+` is campaign statistics rather than reserve storage.

## Physical Bank $11 sourced routines

- `$4A12-$4A43`: Master Wars Medal / Super Prize checks. The reference notes tie these to campaign-clear flags and the 45 clear-count bytes; the Super Prize is not awarded when the total clear count is 55 or more.
- `$4A59-$4B27`: category medal checks over destroyed-unit, capture/development, yield-decline statistics.
- `$4B28-$4B40`: All Unit Medal check using the seven-byte procured-unit flags.
- `$4BD3-$4BD9`: stores the just-obtained medal flag at `$C62B`.
- `$4D3F-$4D59`: marks a procured unit in the seven-byte bitfield under the reference-described mode/side condition.

Exact threshold semantics and medal-ID naming still need deeper caller analysis, but the five listed implementation ranges are now ROM-locked source. Do not reassign them to Bank `$18`: that bank is already occupied by the battle-scene runtime at the same addresses.
