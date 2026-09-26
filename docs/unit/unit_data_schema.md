# UnitData schema

the project expands the semantic description of the fixed 37-byte `UnitData`
records in Bank $12. The project already owned all 53 records byte-for-byte;
this source changes names/documentation only.

Each definition is:

| Offset | Size | Meaning |
|---|---:|---|
| $00-$09 | 10 | display name |
| $0A | 1 | maximum HP |
| $0B | 1 | maximum fuel |
| $0C | 1 | movement power |
| $0D | 1 | transport capacity |
| $0E | 1 | unresolved |
| $0F | 1 | fuel upkeep |
| $10-$11 | 2 | gold cost, little-endian, in units of 100G |
| $12-$13 | 2 | materials cost, little-endian |
| $14 | 1 | primary weapon ID |
| $15 | 1 | primary weapon maximum ammo |
| $16 | 1 | secondary weapon ID |
| $17 | 1 | secondary weapon maximum ammo |
| $18 | 1 | unit family / WeaponData target class |
| $19 | 1 | movement profile |
| $1A | 1 | carrying/load class |
| $1B-$1D | 3 | accepted carried/load classes |
| $1E | 1 | DEF versus armored |
| $1F | 1 | DEF versus unarmored/light land |
| $20 | 1 | DEF versus air |
| $21 | 1 | DEF versus sea |
| $22 | 1 | DEF versus submarine |
| $23 | 1 | base Focus |
| $24 | 1 | Focus loss |

The five defense columns deliberately use the same class ordering as the five
WeaponData attack columns at offsets $0A-$0E. Bank $12:$4329+ already proves
that UnitData byte $18 indexes this same five-way family/class namespace.

## Evidence discipline

The offset layout is corroborated by the DataCrystal ROM map and by the fixed
record geometry already protected by `verify_unit_data_layout.py`. Existing
runtime source independently proves max HP/fuel/ammo, movement profile,
weapon IDs, family/target class, and carrying compatibility. The reference map
also leaves byte $0E unknown, so this project intentionally does the same.

No `unit_data` payload bytes or English names are changed by this semantic cleanup.
