# Unit List post-promotion runtime

Bank `$18:$734D-$7A73` is readable LR35902 source. The range begins immediately after the separately owned `UnitList_Promoted` text and ends exactly before `UnitList_Filter` at `$7A74`.

The retail range is 1,831 bytes with SHA-1 `5fb312e0f6c7cd0b61d883012bf54084a9a74d4a`. It decodes to 815 instructions. Existing callers establish stable public entries at `$734E`, `$7446`, `$7470`, `$78FE`, and `$79E7`; the dense internal `$75xx-$79xx` helpers remain address-oriented where their exact player-facing sort/filter semantics are not uniquely proven.

The runtime owns the post-action Unit List interaction loop, filter/sort presentation, WRAM-bank-3 list-buffer construction and record swapping, category/status filtering, filtered-buffer rebuild, and restoration of the main Unit List presentation. The raw byte pattern at ROM0 `$0700` that resembles a farcall to `$7809` is unaligned (`CB EF / 18 09 / 78`) and is not a real entry.

`tools/verify_unit_list_post_promotion_runtime.py` performs a real RGBDS assemble/link overlay of this section against the retail ROM. The linked result must be byte-for-byte identical to the retail input, in addition to matching the established range fingerprint and instruction count.

The custom English Unit List text owners are not modified by this conversion.
