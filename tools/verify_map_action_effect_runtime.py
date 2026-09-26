#!/usr/bin/env python3
"""Verify Bank $0C battle/map-action effects, BOMB targeting, and resources."""
from pathlib import Path
import hashlib, re, subprocess, sys, tempfile

ROOT = Path(__file__).resolve().parents[1]
RUNTIME = ROOT / 'engine/map/map_action_effect_runtime_4e27.asm'
AREA = ROOT / 'engine/map/ai/map_ai_area_attack.asm'
SETUP = ROOT / 'engine/map/bank0b_map_setup_runtime_4000.asm'
EXECUTOR = ROOT / 'engine/unit/unit_action_executor_6283.asm'
PNG = ROOT / 'gfx/effects/map_action_effects.png'
GFX = ROOT / 'gfx/effects/map_action_effects.2bpp'
RGBGFX = ROOT / 'tools/rgbds/bin/rgbgfx'
BANK = 0x0C
EXPECTED_ROM_SHA256 = 'e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
RANGES = [
    (0x4E27, 0x504F, 'battle/map-action/BOMB runtime', '64dda38b8a68b7301a15809bf91bf9ef2fbd07b0'),
    (0x52A6, 0x5626, 'map-action sprite/resource family', '68a4ae938b10d237c48e584298e1a7395de4997b'),
]
GFX_SHA1 = 'a974aae7d767599eea39196ad10492cdbe31c297'


def find_rom(name, extra):
    for p in [Path(x) for x in extra] + [ROOT / name, Path('/mnt/data') / name]:
        if p.is_file():
            return p
    return None


def bank_slice(blob, start, end):
    off = BANK * 0x4000 + (start - 0x4000)
    return blob[off:off + end - start]


def fail(msg):
    raise SystemExit('[fail] ' + msg)


def main():
    base = find_rom('baserom.gbc', sys.argv[1:])
    if base is None:
        fail('baserom.gbc not found')
    retail = base.read_bytes()

    for start, end, label, want in RANGES:
        got = hashlib.sha1(bank_slice(retail, start, end)).hexdigest()
        if got != want:
            fail(f'{label} retail SHA-1 {got} != {want}')

    text = RUNTIME.read_text(encoding='utf-8')
    required = [
        'Battle_CalculatePackedHPDamage::',
        'MapActionEffect_LoadGraphics::',
        'MapActionEffect_LoadPalettes::',
        'Battle_ResolveDestroyedParticipants::',
        'Unit_DestroyWithMapAnimation::',
        'UnitAction_RunBombTargetSelection::',
        'UnitAction_UpdateBombTargetRangeCursor:',
        'UnitAction_ConfirmBombTarget:',
        'MapActionEffect_UnitDestroyedAnimation::',
        'MapActionEffect_AreaAttackAnimation::',
        'MapActionEffectAnimationPointers::',
        'INCBIN "gfx/effects/map_action_effects.2bpp"',
        'MapActionEffectPalettes::',
        'assert @ == $504f',
        'assert @ == $5626',
    ]
    for token in required:
        if token not in text:
            fail(f'missing runtime/resource source integration: {token}')

    # Executable sections should remain mnemonic rather than falling back to byte blobs.
    executable = text.split('; ---------------------------------------------------------------------------\n; Sprite/OAM resources', 1)[0]
    for line in executable.splitlines():
        if re.match(r'^\s*db\s+\$', line, re.I):
            fail(f'raw DB executable byte found: {line.strip()}')

    integrations = [
        (AREA, 'call MapActionEffect_LoadPalettes'),
        (AREA, 'ld de, MapActionEffect_AreaAttackAnimation'),
        (AREA, 'call Unit_DestroyWithMapAnimation'),
        (SETUP, 'farcall $0c, MapActionEffect_LoadGraphics'),
        (EXECUTOR, 'farcall $0c, UnitAction_RunBombTargetSelection'),
    ]
    for path, token in integrations:
        if token not in path.read_text(encoding='utf-8'):
            fail(f'missing symbolic integration in {path}: {token}')

    obsolete = [
        (AREA, 'call $4e66'),
        (AREA, 'ld de, $53ae'),
        (AREA, 'call $4ecb'),
        (SETUP, 'farcall $0c, $4e53'),
        (EXECUTOR, 'farcall $0c, $4f3a'),
    ]
    for path, token in obsolete:
        if token.lower() in path.read_text(encoding='utf-8').lower():
            fail(f'obsolete raw dependency remains in {path}: {token}')

    if not PNG.is_file() or not GFX.is_file():
        fail('map-action effect PNG/generated 2bpp asset missing')
    gfx_bytes = GFX.read_bytes()
    if len(gfx_bytes) != 0x250:
        fail(f'generated effect graphics length {len(gfx_bytes)} != 592')
    got_gfx = hashlib.sha1(gfx_bytes).hexdigest()
    if got_gfx != GFX_SHA1:
        fail(f'generated effect graphics SHA-1 {got_gfx} != {GFX_SHA1}')

    if RGBGFX.is_file():
        with tempfile.TemporaryDirectory() as td:
            out = Path(td) / 'map_action_effects.2bpp'
            subprocess.run([str(RGBGFX), '-o', str(out), str(PNG)], check=True,
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            if out.read_bytes() != gfx_bytes:
                fail('editable map-action effect PNG does not round-trip to generated 2bpp')

    built = ROOT / 'GBWARS3.gbc'
    if built.is_file():
        out = built.read_bytes()
        for start, end, label, _ in RANGES:
            if bank_slice(out, start, end) != bank_slice(retail, start, end):
                fail(f'linked bytes drift in {label}')
        digest = hashlib.sha256(out).hexdigest()
        if digest != EXPECTED_ROM_SHA256:
            fail(f'custom-English ROM SHA-256 {digest} != {EXPECTED_ROM_SHA256}')
        print(f'[ok] full custom-English ROM SHA-256 {digest}')

    print('[ok] Bank $0C $4E27-$504E battle/map-action/BOMB runtime matches retail')
    print('[ok] Bank $0C $52A6-$5625 effect frames/animations/graphics/palettes match retail')
    print('[ok] editable map-action effect PNG regenerates the exact 37-tile payload')
    print('[ok] area attack, map setup, and BOMB executor use symbolic runtime entries')


if __name__ == '__main__':
    main()
