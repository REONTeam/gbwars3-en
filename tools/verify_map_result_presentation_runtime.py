#!/usr/bin/env python3
"""Verify the source-backed selected-map result-presentation services."""
from pathlib import Path
import hashlib
import sys

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
BANK1A = ROOT / "engine/map/map_result_presentation_bank1a.asm"
BANK27 = ROOT / "engine/map/map_result_presentation_bank27.asm"
DISPATCH = ROOT / "engine/map/ai/map_control_result_transition_6e6e.asm"
FINALIZE = ROOT / "engine/map/ai/map_control_transition_finalize_6ed6.asm"

RANGES = [
    (0x1A, 0x6089, 0x60A4, "0b783f28457b34279532f922480fcd99c5eb1a7b", "HQ-loss presentation"),
    (0x1A, 0x60A4, 0x6263, "1c97925f850b99f35467e48305daecddff2687c9", "force-defeat presentation"),
    (0x1A, 0x6263, 0x6380, "92400dd2a6da21b91fcaf429a03c6e755c5a34f1", "Yield/turn-limit presentation"),
    (0x27, 0x5267, 0x5566, "37bd7fe34ce616e2d0399e18c3ab6ce26bd3c6b6", "two-side result presentation support"),
]


def fail(msg: str) -> None:
    print(f"FAIL: {msg}")
    raise SystemExit(1)


def rom_offset(bank: int, addr: int) -> int:
    if bank == 0:
        return addr
    return bank * 0x4000 + (addr - 0x4000)


if not BASE.exists():
    fail("baserom.gbc is required as external verification input")
if not BUILT.exists():
    fail("GBWARS3.gbc must be built before result-presentation verification")

base = BASE.read_bytes()
built = BUILT.read_bytes()
if len(base) != 0x100000 or len(built) != 0x100000:
    fail("expected 1 MiB retail and built ROM images")

for bank, start, end, expected_sha1, label in RANGES:
    a = rom_offset(bank, start)
    b = a + (end - start)
    retail = base[a:b]
    output = built[a:b]
    got = hashlib.sha1(retail).hexdigest()
    if got != expected_sha1:
        fail(f"{label}: retail SHA-1 {got} != {expected_sha1}")
    if output != retail:
        fail(f"{label}: built bytes differ from retail at Bank ${bank:02X}:${start:04X}-${end-1:04X}")
    print(f"PASS Bank ${bank:02X}:${start:04X}-${end-1:04X}: {len(retail)} bytes SHA-1 {got}")

b1 = BANK1A.read_text(encoding="utf-8")
b27 = BANK27.read_text(encoding="utf-8")
dispatch = DISPATCH.read_text(encoding="utf-8")
finalize = FINALIZE.read_text(encoding="utf-8")

for token in (
    'section "Map Result Presentation Services", romx[$6089], bank[$1a]',
    'MapResult_PresentHQLoss::',
    'MapResult_PresentForceDefeat::',
    'MapResult_PresentTurnLimitOrYield::',
    'assert @ == $6380',
):
    if token not in b1:
        fail(f"Bank $1A result source missing {token}")

for token in (
    'section "Map Result Side Presentation", romx[$5267], bank[$27]',
    'MapResult_WaitFramesOrCancel::',
    'MapResult_BuildRandomOrder::',
    'MapResult_AnimateEntries::',
    'MapResult_SetupPrimaryScreen::',
    'MapResult_SetupSecondaryScreen::',
    'MapResult_ConfigurePerspectiveLayout::',
    'MapResult_ConfigureSideLayout::',
    'MapResult_PresentSideOutcome::',
    'assert @ == $5566',
):
    if token not in b27:
        fail(f"Bank $27 result source missing {token}")

if b27.count('call SpriteObject_ResetAll') != 2:
    fail("Bank $27 screen setup must call SpriteObject_ResetAll exactly twice")
if 'call SpriteObject_DestroyAll' in b27:
    fail("Bank $27 result setup regressed to the wrong sprite-object reset service")

for token in (
    'farcall $1a, MapResult_PresentHQLoss',
    'farcall $1a, MapResult_PresentForceDefeat',
    'farcall $1a, MapResult_PresentTurnLimitOrYield',
):
    if token not in dispatch:
        fail(f"result transition dispatcher missing symbolic call: {token}")
for raw in ('$6089', '$60a4', '$6263'):
    if raw in dispatch.lower():
        fail(f"result transition dispatcher still contains raw Bank $1A target {raw}")

if 'farcall $27, MapResult_PresentSideOutcome' not in finalize:
    fail("transition finalizer is not integrated with MapResult_PresentSideOutcome")
if '$54e7' in finalize.lower():
    fail("transition finalizer still contains raw Bank $27 target $54E7")

print("PASS: selected-map result presentation services are source-backed and symbolically integrated")
