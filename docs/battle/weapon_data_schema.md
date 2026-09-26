# WeaponData record schema

Bank `$12:$5256-$54A7` contains the 33-entry `WeaponData` pointer table and its 33 fixed 16-byte records. The active English/custom source remains authoritative.

Each record is:

| Offset | Size | Meaning |
| --- | ---: | --- |
| `$00` | 8 | Display name |
| `$08` | 1 | Minimum range |
| `$09` | 1 | Maximum range |
| `$0A` | 1 | Attack value vs armored target class |
| `$0B` | 1 | Attack value vs unarmored target class |
| `$0C` | 1 | Attack value vs air target class |
| `$0D` | 1 | Attack value vs sea target class |
| `$0E` | 1 | Attack value vs submarine target class |
| `$0F` | 1 | Cost per shot |

The five attack values use the same ordering as `UNIT_TARGET_CLASS_*` and the five `UNIT_DATA_DEF_*` fields. This relationship is structural and source-backed; the project does not claim the still-unsourced combat formula that combines attack, defense, rank, HP, and Focus.

`weapon_data` now emits each field explicitly rather than repeating an anonymous eight-byte tail. This is a source representation change only: all 528 record bytes and all customized English weapon names remain unchanged.
