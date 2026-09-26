# Unit purchase allowed-list data

the project sources Bank `$12:$497F-$4A42` byte-authoritatively from the Japanese retail ROM.

`$497F-$4985` is a seven-byte purchase-category payload. `$4986-$49A5` is exactly **16 little-endian pointers (32 bytes)**, correcting the earlier current source interpretation of 15 pointers plus an unresolved byte. The pointer values are `$49A6,$49A6,$49AD,...,$4A08`: slots 0 and 1 intentionally share the first record.

`$49A6-$4A0E` contains **15 distinct seven-byte cumulative allowed-unit bitfields** (105 bytes total). Their individual bits correspond to the established UnitData type namespace, but higher-level tier naming remains positional until the `$447D/$448D` consumer is sourced.

`$4A0F-$4A42` is the 52-byte promotion-result table, one byte for each non-`DUMMY` UnitData type. The bytes are now emitted source; semantic promotion names should still follow caller behavior rather than table inspection alone.
