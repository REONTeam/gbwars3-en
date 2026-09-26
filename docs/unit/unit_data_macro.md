# UnitData semantic source macro

the project keeps the established 53 x 37-byte UnitData payload byte-identical while making each source row match the documented record schema.

The `unit_data` macro takes a 10-byte display name followed by 25 semantic attributes in record order:

| Offset | Size | Source argument |
|---|---:|---|
| `$00` | 10 | display name |
| `$0A` | 1 | max HP |
| `$0B` | 1 | max fuel |
| `$0C` | 1 | movement power |
| `$0D` | 1 | transport capacity |
| `$0E` | 1 | unresolved byte |
| `$0F` | 1 | fuel upkeep |
| `$10` | 2 | gold cost, units of 100G |
| `$12` | 2 | material cost |
| `$14` | 1 | weapon 1 ID |
| `$15` | 1 | weapon 1 ammo |
| `$16` | 1 | weapon 2 ID |
| `$17` | 1 | weapon 2 ammo |
| `$18` | 1 | target class |
| `$19` | 1 | movement profile |
| `$1A` | 1 | carrying type |
| `$1B-$1D` | 3 | accepted carried types |
| `$1E-$22` | 5 | DEF values: armored, unarmored, air, sea, submarine |
| `$23` | 1 | base Focus |
| `$24` | 1 | Focus loss |

The main structural change is that the two 16-bit cost values are now written as single macro arguments and emitted with `dw`. Previously every row exposed the low and high bytes separately. This removes an easy source-editing hazard without changing the ROM representation.

`tools/verify_unit_data_layout.py` independently expands the semantic arguments back into the complete 1,961-byte UnitData record payload and locks SHA-1 `9597555ea017d416307d001dc14c5fa24abe4f57`. `tools/verify_unit_crossrefs.py` independently reconstructs the 1,431 attribute bytes and locks SHA-1 `1236af033a558eb05004639f519dd5ac8c344e7c`.

Byte `$0E` remains deliberately unresolved. It is kept as its own explicit argument so later consumer tracing can name it without changing the macro geometry.
