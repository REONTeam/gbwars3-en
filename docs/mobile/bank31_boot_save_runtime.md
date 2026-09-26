# Bank $31 boot/save runtime (`$5453-$5674`)

the project corrects the subsystem boundary immediately after the project Bank `$31` presentation resource. `$5453` is not another battle-scene renderer entry: ROM0 startup farcalls it at `$1597` during the boot sequence.

The `$5453` path switches to SRAM bank `$0E`, enables SRAM access, derives a value through the already-owned `$542F` helper and compares it with the stored byte at `$BA65`. The adjacent path clears/initializes persistent SRAM state and continues through later Bank `$31` setup. This establishes the range as boot/save validation and initialization infrastructure without assigning unsupported player-facing menu names.

The next externally proven entries inside the range are `$5502`, `$554F`, and `$5610`; these remain contract-oriented because their callers and encoded string/resource operands still need separate semantic closure. `$5675` is independently farcalled from Bank `$13` and is the next clean Bank `$31` subsystem boundary.

The complete current source range is `$31:$5453-$5674`, 546 bytes, SHA-1 `8ac94ad3542e79487976dd4317cc6d4e5d501856`.
