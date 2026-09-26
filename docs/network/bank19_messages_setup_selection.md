# Bank $19 Messages setup and selection runtime

The late Bank $19 Messages area begins immediately after the custom-English `MESSAGES` header at `$792C-$7937`. This checkpoint converts two behavior-backed contracts from raw executable bytes to mnemonic RGBDS source without changing emitted ROM data.

## `$7938-$7A31` — setup / presentation

`NetworkMessages_SetupScreen` initializes the Messages presentation through existing Bank $31 and Bank $22 providers, draws six fixed rows and eight small UI fields, creates three sprite objects from fixed Bank $15 descriptors, positions the two selection sprites, and then runs the existing Messages presentation helpers. If the current entry count/state at `$BA38` is zero, the third staged sprite is hidden before returning.

The `$CCxx`, `$BA38`, and `$DFxx` state bytes remain conservatively structural where their complete persistent meaning has not yet been proven by the downstream controller.

## `$7A32-$7AB1` — selection display / controller preparation

`NetworkMessages_UpdateSelectionDisplay` controls visibility of the primary and secondary selection sprites according to the current entry count/state and `$CC26` selection/page state. The four small show/hide helpers retain their previous public aliases for compatibility while gaining behavior-backed cursor names.

`NetworkMessages_PrepareInteractiveController` selects and enables SRAM bank `$0E`, runs the connected Bank $31 provider, clears one controller state byte, stages `$CC27 = $CC25 + $CC26`, runs the existing Bank $22 presentation/data providers, services the VBlank FIFO, and finishes with the established fade-from-white transition.

## Exactness

- `$7938-$7A31`: 250 bytes, retail SHA-1 `0af893e213abb7ccfcd913d36f94a22c5b713885`.
- `$7A32-$7AB1`: 128 bytes, retail SHA-1 `64d5bd6b1d83b5d524879bbea82774eed12626ba`.
- Combined newly mnemonic ownership: 378 bytes.
- The custom-English ROM remains byte-identical to the previous baseline.

## Next boundary

The next raw owner begins at `$7AB2`. The next double-contract checkpoint should treat `$7AB2-$7BB2` as the common state/input controller and `$7BB3-$7C38` as its special-path/indexed-entry helper group. The remaining `$7C39-$7E8C` tail can then be split at the already-established `$7D22` interactive-controller entry.
