#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys

ROOT = Path(__file__).resolve().parents[1]
ROM = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "baserom.gbc"
rom = ROM.read_bytes()


def off(bank: int, addr: int) -> int:
    return addr if bank == 0 else bank * 0x4000 + (addr - 0x4000)


def require(cond, msg):
    if not cond:
        raise AssertionError(msg)


def fingerprint(bank, start, end, expected, name):
    data = rom[off(bank, start):off(bank, end)]
    require(len(data) == end - start, f"{name}: wrong retail range length")
    require(sha1(data).hexdigest() == expected, f"{name}: retail fingerprint changed")


fingerprint(0x0B, 0x4F82, 0x51B5, "553a39b176156a4586850de40b78cfccb1a722bb", "Action Menu runtime")
fingerprint(0x00, 0x0EE4, 0x0F02, "0af14bffefedcf6db7a286aad96e4945d1aa126c", "VRAM tilemap step helpers")

# Natural internal boundaries, useful when a future edit accidentally absorbs or
# shifts one member of the family while preserving the total range size.
for start, end, digest, name in (
    (0x4F82, 0x4FA6, "cbfda7efa13df72801d413272d6ce38df8c8dc49", "reset/clear"),
    (0x4FA6, 0x4FC0, "b61e055cad65967dccb0505e831915511a58bb6c", "append"),
    (0x4FC0, 0x5052, "14625f1bb8e9b55414a779333a345cf7ce6399af", "selector"),
    (0x5052, 0x5086, "19f98bd267e5b6e9fe4a9ff14dbafce4ce161258", "entry layout"),
    (0x508A, 0x50B4, "f2cc18d1b86c1a13fe6a7900530a7de2279cfc9c", "4x2 row renderer"),
    (0x50B4, 0x5108, "24d40368fff8bdfbbbd08c59697c13d896ccdc83", "selection blink"),
    (0x5108, 0x5164, "92e47ebe2998bb85bb9230b800df2babdbd45849", "day counter window"),
    (0x5164, 0x51B5, "eb63beb8af4da4af8e423e66ed555366b6743113", "entry graphics upload"),
):
    fingerprint(0x0B, start, end, digest, name)

src_path = ROOT / "engine/map/unit_action_menu_runtime_4f82.asm"
src = src_path.read_text()
home = (ROOT / "engine/home/home.asm").read_text()

for token in (
    'section "Bank $0B Unit Action Menu Runtime", romx[$4f82], bank[$0b]',
    'UnitActionMenu_Reset::',
    'UnitActionMenu_ClearEntries::',
    'UnitActionMenu_AddEntry::',
    'UnitActionMenu_RunSelection::',
    'UnitActionMenu_DrawEntries::',
    'UnitActionMenu_RestoreMapPresentation::',
    'UnitActionMenu_DrawRowBlock::',
    'UnitActionMenu_AdvanceAnimationState::',
    'UnitActionMenu_DrawSelectionMarker::',
    'UnitActionMenu_ClearSelectionMarker::',
    'MapControl_DrawDayCounterWindow::',
    'MapControl_CloseDayCounterWindow::',
    'UnitActionMenu_LoadEntryGraphics::',
    'UnitActionMenu_GetGraphicPointer::',
    'UnitActionMenu_GetVRAMDestination::',
    'assert @ == $51b5',
):
    require(token in src, f"missing Action Menu source token: {token}")

require('    db ' not in src, "Action Menu runtime still contains raw db instruction blocks")
require('call $0eea' not in src.lower(), "raw $0EEA tilemap-step call remains")
require('call $0ef7' not in src.lower(), "raw $0EF7 tilemap-step call remains")
require('farcall $10, $68fa' not in src.lower(), "raw day-window push call remains")
require('farcall $10, $6908' not in src.lower(), "raw day-window pop call remains")

for token in (
    'Vram_TilemapCoordAdd32ToY::',
    'Vram_TilemapAdvanceColumnWrapped::',
    'Vram_TilemapAdvanceRowWrapped::',
    'assert @ == $0f02',
):
    require(token in home, f"missing ROM0 tilemap helper source token: {token}")

# The raw retail block decodes to exactly 292 instructions/macros after each
# RST-$28 banked call is treated as one farcall. Keeping this count alongside
# the fixed final assert catches accidental statement loss/duplication when an
# assembler is not available in the verification environment.
lines = []
for raw in src.splitlines():
    line = raw.split(';', 1)[0].strip()
    if not line or line.startswith(('include ', 'DEF ', 'EXPORT ', 'section ', 'assert ')):
        continue
    if line.endswith(':') or (line.startswith('.') and ' ' not in line and '\t' not in line):
        continue
    lines.append(line)
require(len(lines) == 292, f"Action Menu instruction/macro count changed: {len(lines)} != 292")

# Key behavior contracts proven directly by the decoded retail flow.
for token in (
    'cp UNIT_ACTION_MENU_MAX_ENTRIES',
    'bit 6, a',
    'bit 7, a',
    'bit 0, a',
    'bit 1, a',
    'ld [wUnitActionMenuSelection], a',
    'farcall UIWindowStack_PushAndDraw',
    'farcall UIWindowStack_PopRestore',
    'ld a, [wMapPhaseNumber]',
    'call Number_ByteToPackedBCD',
    'call Vram_TilemapAdvanceColumnWrapped',
    'call Vram_TilemapAdvanceRowWrapped',
    'ld de, Image_Action_Menu',
    'farcall $11, MemcpyWaitLCD',
):
    require(token in src, f"missing Action Menu behavior contract: {token}")

# Source-backed consumers should use the public names rather than reintroducing
# raw same-bank addresses for the central list/selector APIs.
for path in (ROOT / 'engine').rglob('*.asm'):
    if path == src_path:
        continue
    text = path.read_text(errors='ignore').lower()
    for raw in ('call $4f82', 'call $4fa6', 'call $4fc0'):
        require(raw not in text, f"{path.relative_to(ROOT)}: stale raw Action Menu call {raw}")

print("Bank $0B Action Menu $4F82-$51B4 retail fingerprint: [ok]")
print("ROM0 tilemap step helpers $0EE4-$0F01 retail fingerprint: [ok]")
print("Action Menu mnemonic source / 292-instruction geometry: [ok]")
print("Shared callers use symbolic Action Menu APIs: [ok]")
