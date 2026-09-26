# Unit List tail mnemonic conversion

Bank `$18` is already physically owned through `$7FFF`; this cleanup converts the remaining executable Unit List tail from raw bytes into readable LR35902 source without absorbing adjacent text or graphics.

The ownership split is preserved exactly:

- `$7A74-$7AB7`: 68-byte `UnitList_Filter` text owner;
- `$7AB8-$7E77`: 960-byte `Image_Unit_Status` graphics owner;
- `$7E78-$7EB7`: 64-byte `UnitList_FilterLookupTable` data;
- `$7EB8-$7F5B`: mnemonic Unit List tail helpers;
- `$7F5C-$7F61`: preserved `UnitList_Count` text owner;
- `$7F62-$7FFB`: mnemonic filtered-count/update helpers;
- `$7FFC-$7FFF`: verified retail `$FF` padding.

The two source-owned tail ranges retain their established retail fingerprints: `$7E78-$7F5B` is 228 bytes with SHA-1 `83fca09295808c69e8ade2676ab5d92fa2c4f798`, and `$7F62-$7FFF` is 158 bytes with SHA-1 `80a4175542b0178d4c2dbe0c023c7355c65450a9`.

The executable portions contain 178 LR35902 instructions. They encode display values, rebuild the filtered display buffer, append selected record fields, update filtered rows/counts, process side-relative entries, retrieve a selected record value, and locate the matching filtered entry. Lower-level Bank `$12/$17` services remain numeric where this range alone does not prove stronger semantic names.

`tools/verify_unit_list_tail_mnemonic.py` performs a real RGBDS 1.0.3 assemble/link overlay against the retail ROM; the linked ROM must remain completely byte-identical.
