#!/usr/bin/env python3
from pathlib import Path
import hashlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
rom_path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "baserom.gbc"
rom = rom_path.read_bytes()
assert len(rom) >= 0x30000, f"unexpected ROM size: {len(rom)}"

BANK = 0x0B

def bank_slice(start, end):
    off = BANK * 0x4000 + (start - 0x4000)
    return rom[off:off + (end - start)]

ranges = {
    (0x7B01, 0x7B6F): "f6b050dcc68e808df1c538098622ad2113237f2c",
    (0x7B6F, 0x7CF7): "99c4fea4a9abb1fd121daca69fd20b26a82745fb",
    (0x7D24, 0x7D33): "7846b803988b53b771edc2532dfdd054ed53d730",
}
for (start, end), expected in ranges.items():
    got = hashlib.sha1(bank_slice(start, end)).hexdigest()
    assert got == expected, f"Bank $0B ${start:04X}-${end-1:04X} SHA-1 {got} != {expected}"

padding = bank_slice(0x7D83, 0x8000)
assert padding == b"\xFF" * len(padding), "Bank $0B tail after $7D82 is not pure $FF padding"

required = {
    "engine/map/map_pan_to_coordinates_7b01.asm": [
        'romx[$7b01], bank[$0b]',
        'MapControl_PanToCoordinates::',
        'MapControl_IsActionTargetAtCoordinates::',
        'MapControl_CompletePanStep::',
        'assert @ == $7b6f',
    ],
    "engine/map/map_economy_runtime_7b6f.asm": [
        'romx[$7b6f], bank[$0b]',
        'MapEconomy_AddCurrentSideGold::',
        'MapEconomy_TrySubtractCurrentSideGold::',
        'MapEconomy_CheckCurrentSideGoldAtLeastDE::',
        'MapEconomy_GetCurrentSideGoldPointer::',
        'MapEconomy_GetCurrentSideMaterials::',
        'MapEconomy_AddCurrentSideMaterials::',
        'MapEconomy_SubtractCurrentSideMaterials::',
        'MapEconomy_RecalculateIncome::',
        'MapEconomy_SumAnalysisRecordsForTileSet::',
        'MapEconomy_AccumulateRecordForTileSet::',
        'assert @ == $7cf7',
    ],
    "engine/unit/unit_current_phase_side_7d24.asm": [
        'romx[$7d24], bank[$0b]',
        'UnitTypeSide_IsEmptyOrCurrentPhaseSide::',
        'assert @ == $7d33',
    ],
}
for rel, needles in required.items():
    text = (ROOT / rel).read_text()
    for needle in needles:
        assert needle in text, f"missing {needle!r} in {rel}"

# All already-source-backed consumers should now use the named public entries.
raw_call_patterns = [
    r'\bcall\s+\$7b01\b', r'\bfarcall\s+\$0b\s*,\s*\$7b01\b',
    r'\bcall\s+\$7b98\b', r'\bcall\s+\$7bb0\b', r'\bcall\s+\$7bdc\b',
    r'\bcall\s+\$7c13\b', r'\bcall\s+\$7c2f\b', r'\bcall\s+\$7d24\b',
]
hits = []
for base in (ROOT / "engine", ROOT / "data"):
    for path in base.rglob("*.asm"):
        # Raw retail-byte db blocks may naturally contain these opcodes; only
        # reject textual CALL/FARCALL forms that should now be symbolic.
        text = path.read_text()
        for pat in raw_call_patterns:
            if re.search(pat, text, re.I):
                hits.append(f"{path.relative_to(ROOT)}: {pat}")
assert not hits, "raw Bank $0B tail calls remain:\n" + "\n".join(hits)

# The four count-prefixed property sets are byte-authoritative at $7C8A-$7C97.
assert bank_slice(0x7C8A, 0x7C98) == bytes([
    4, 0x01, 0x02, 0x06, 0x09,
    4, 0x0C, 0x0D, 0x11, 0x14,
    1, 0x04,
    1, 0x0F,
]), "property-income tile tables differ from retail"

print("[ok] Bank $0B tail runtime: $7B01-$7CF6 and $7D24-$7D32 source-backed; $7D83-$7FFF is FF padding")
