#!/usr/bin/env python3
"""Verify the Bank $0F Map Editor main-menu handler family."""
from __future__ import annotations
import hashlib
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / "baserom.gbc"
BUILT = ROOT / "GBWARS3.gbc"
SOURCE = ROOT / "engine/map/map_editor_menu_handlers_460f.asm"
INTERACTION = ROOT / "engine/map/map_editor_interaction_runtime_4170.asm"
EDITOR = ROOT / "engine/map/map_editor.asm"
BANK = 0x0F
EXPECTED_ROM_SHA256 = "e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059"
RANGES = [
    (0x460F, 0x4661, "e11304adeb04ed7ac62c3470464e9b412a02a8d5"),
    (0x4661, 0x46FF, "dc0123d8e78cb098c87e5fa84dc98e80ce95f6c6"),
    (0x46FF, 0x4744, "a3f8feda760e01a02d3d67a07e7a38118088bafa"),
    (0x4744, 0x4789, "dee7b47b5dd3f8d32e36fec3c4e0de3105aa5dd1"),
    (0x478C, 0x47B3, "b23f4ffe24d36d5d7624015d98f7198292538f58"),
    (0x47B3, 0x4837, "123a03559f21b0c492e302abde21eadb13c21bcc"),
    (0x4866, 0x4954, "f0608188aa92fc0866381ce7369c51a66330ceb9"),
    (0x4986, 0x49ED, "b02cca391536fd3ab30fb3b51802b04e6276fefb"),
    (0x4A07, 0x4B08, "b2a69e77b839a6359461d15de712cc9db92577fb"),
    (0x4B39, 0x4C3A, "78982bfe59b89479744e6bb38627f8225f90a35c"),
]
EXPECTED_CONCAT_SHA1 = "933a9e447a4f8d5c695f03c075ce7dd39d354e49"
EXPECTED_TOTAL = 1404
EXPECTED_INSTRUCTIONS = 580


def fail(msg: str) -> None:
    raise SystemExit(f"[fail] {msg}")


def rom_slice(blob: bytes, start: int, end: int) -> bytes:
    off = BANK * 0x4000 + (start - 0x4000)
    return blob[off:off + (end - start)]

if not ROM.is_file():
    fail("baserom.gbc is required")
if not BUILT.is_file():
    fail("GBWARS3.gbc is required; run make first")

src = SOURCE.read_text(encoding="utf-8")
interaction = INTERACTION.read_text(encoding="utf-8")
editor = EDITOR.read_text(encoding="utf-8")
retail = ROM.read_bytes()
built = BUILT.read_bytes()

if re.search(r"(?mi)^\s*db\b", src):
    fail("raw db executable bytes remain in map-editor menu handler source")

required_entries = [
    "MapEditor_HandleArrangeMenu::",
    "MapEditor_HandleMapSizeMenu::",
    "MapEditor_HandleFundsMenu::",
    "MapEditor_HandleMaterialsMenu::",
    "MapEditor_HandleSaveMenu::",
    "MapEditor_HandleEndMenu::",
    "MapEditor_HandleFillMenu::",
    "MapEditor_RunFillRectangleSelection::",
    "MapEditor_RunTwoValueSubmenuInput::",
    "MapEditor_RunYesNoConfirmation::",
    "MapEditor_CommitSaveIfHQCountsValid::",
]
for name in required_entries:
    if name not in src:
        fail(f"missing source entry {name}")

pointer_contract = """dw MapEditor_HandleArrangeMenu, MapEditor_HandleMapSizeMenu
    dw MapEditor_HandleFundsMenu, MapEditor_HandleMaterialsMenu
    dw MapEditor_EditName, MapEditor_HandleFillMenu
    dw MapEditor_HandleSaveMenu, MapEditor_HandleEndMenu"""
if pointer_contract not in interaction:
    fail("main editor handler pointer table is not fully symbolic")

for resource in (
    "EditorSubmenu_Message_HQ::",
    "EditorSubmenu_Save::",
    "EditorSubmenu_Message_Limit::",
    "EditorSubmenu_Message_Fill::",
    "EditorSubmenu::",
):
    if resource not in editor:
        fail(f"resource/controller export missing: {resource}")

op_re = re.compile(r"^\s*(?:adc|add|and|bit|call|ccf|cp|cpl|daa|dec|di|ei|farcall|halt|inc|jp|jr|ld|ldh|nop|or|pop|push|res|ret|reti|rl|rla|rlc|rlca|rr|rra|rrc|rrca|rst|sbc|scf|set|sla|sra|srl|stop|sub|swap|xor)\b", re.I)
instructions = sum(bool(op_re.match(line.split(";", 1)[0])) for line in src.splitlines())
if instructions != EXPECTED_INSTRUCTIONS:
    fail(f"instruction count {instructions}, expected {EXPECTED_INSTRUCTIONS}")

concat = bytearray()
total = 0
for start, end, expected_sha1 in RANGES:
    rb = rom_slice(retail, start, end)
    bb = rom_slice(built, start, end)
    if len(rb) != end - start or len(bb) != end - start:
        fail(f"short ROM slice ${start:04X}-${end-1:04X}")
    digest = hashlib.sha1(rb).hexdigest()
    if digest != expected_sha1:
        fail(f"retail SHA-1 ${start:04X}-${end-1:04X}: {digest} != {expected_sha1}")
    if bb != rb:
        for i, (a, b) in enumerate(zip(rb, bb)):
            if a != b:
                fail(f"built byte drift at Bank $0F:${start+i:04X}: retail ${a:02X}, built ${b:02X}")
        fail(f"built range mismatch ${start:04X}-${end-1:04X}")
    concat.extend(rb)
    total += end - start

if total != EXPECTED_TOTAL:
    fail(f"owned byte count {total}, expected {EXPECTED_TOTAL}")
if hashlib.sha1(concat).hexdigest() != EXPECTED_CONCAT_SHA1:
    fail("concatenated retail fingerprint changed")

full_sha = hashlib.sha256(built).hexdigest()
if full_sha != EXPECTED_ROM_SHA256:
    fail(f"custom-English ROM SHA-256 {full_sha} != {EXPECTED_ROM_SHA256}")

print(f"[ok] {len(RANGES)} Bank $0F executable spans / {total:,} bytes match retail")
print(f"[ok] concatenated retail SHA-1 {EXPECTED_CONCAT_SHA1}")
print(f"[ok] mnemonic handler source contains {instructions} instructions")
print("[ok] eight-entry main editor pointer table is fully symbolic")
print("[ok] interleaved HQ/save/fill text remains separately source-owned")
print(f"[ok] custom-English ROM SHA-256 {full_sha}")
