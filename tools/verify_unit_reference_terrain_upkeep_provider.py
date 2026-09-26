from pathlib import Path
import hashlib
import re

BANK = 0x25
EXPECTED_CUSTOM_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"

retail = Path("baserom.gbc").read_bytes()
built = Path("GBWARS3.gbc").read_bytes()
src_path = Path("engine/unit/unit_reference_terrain_upkeep_provider.asm")
src = src_path.read_text()

# The terrain-defense and upkeep English strings are intentionally owned by
# unit_status.asm and sit between these exact retail-code/data spans.
ranges = [
    (0x7061, 0x7139, "selected terrain detail renderer"),
    (0x7142, 0x716F, "terrain detail descriptor loader"),
    (0x716F, 0x71F9, "46-entry terrain detail descriptor table"),
    (0x71F9, 0x728A, "selected terrain detail controller"),
    (0x728A, 0x731D, "upkeep renderer"),
]

def rom_slice(rom, start, end):
    off = BANK * 0x4000 + (start - 0x4000)
    return rom[off:off + (end - start)]

for start, end, name in ranges:
    expected = rom_slice(retail, start, end)
    actual = rom_slice(built, start, end)
    assert actual == expected, f"{name} mismatch at ${start:04X}-${end-1:04X}"

# Resource holes remain separate source owners.
assert 'romx[$7139]' not in src.lower()
assert 'romx[$731d]' not in src.lower()

# The only db payload in this provider source is the proven 46 x 3-byte
# terrain descriptor table. Executable portions must remain mnemonic.
assert src.count("    db ") == 46, "unexpected raw db count in terrain/upkeep provider"
table = src.split("UnitReference_TerrainDetailDescriptors::", 1)[1].split("assert @ == $71f9", 1)[0]
assert table.count("    db ") == 46
assert all(line.strip().startswith("db ") or not line.strip() or line.lstrip().startswith(';')
           for line in table.splitlines()), "non-table content mixed into descriptor table"
outside_table = src.replace(table, "")
assert "    db " not in outside_table, "raw db remains in executable terrain/upkeep source"

# Controller integrations should now be symbolic.
ctl = Path("engine/unit/unit_reference_submenu_controllers.asm").read_text()
assert "call UnitReference_OpenSelectedTerrainDetail" in ctl
assert "call UnitReference_DrawUpkeepSubmenu" in ctl
assert "call $71f9" not in ctl.lower() and "call $728a" not in ctl.lower()

# The map-editor terrain-name copier is now exported for this shared consumer.
map_editor = Path("engine/map/map_editor_submenu_arrange_4d65.asm").read_text()
assert "MapEditor_Arrange_CopyTerrainNameToBuffer::" in map_editor

# Public address lock from the linker symbols.
sym = Path("GBWARS3.sym").read_text().lower()
expected_symbols = {
    "UnitReference_DrawSelectedTerrainDetail": 0x7061,
    "UnitReference_OpenTerrainDetailByDescriptorIndex": 0x7142,
    "UnitReference_LoadTerrainDetailDescriptor": 0x7159,
    "UnitReference_TerrainDetailDescriptors": 0x716F,
    "UnitReference_OpenSelectedTerrainDetail": 0x71F9,
    "UnitReference_DrawUpkeepSubmenu": 0x728A,
}
for name, addr in expected_symbols.items():
    needle = f"25:{addr:04x} {name.lower()}"
    assert needle in sym, f"missing/moved symbol {name} (${addr:04X})"

# Descriptor geometry: exactly 46 records x 3 bytes = 138 bytes.
assert 0x71F9 - 0x716F == 46 * 3

custom_hash = hashlib.sha256(built).hexdigest()
assert custom_hash == EXPECTED_CUSTOM_SHA256, custom_hash

print("PASS unit reference terrain/upkeep provider")
print("  exact retail spans: 697 bytes total")
print("  typed terrain descriptors: 46 x 3 bytes")
print("  custom-English SHA-256:", custom_hash)
