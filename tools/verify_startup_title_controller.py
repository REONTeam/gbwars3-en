#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys

ROOT = Path(__file__).resolve().parents[1]
rom = Path(sys.argv[1] if len(sys.argv) > 1 else ROOT / 'baserom.gbc').read_bytes()

def require(cond, msg):
    if not cond:
        raise AssertionError(msg)

def off(bank, addr):
    return addr if bank == 0 else bank * 0x4000 + (addr - 0x4000)

def digest(bank, start, end):
    o = off(bank, start)
    return sha1(rom[o:o + end - start]).hexdigest()

ranges = [
    (0x11, 0x4000, 0x4067, '0657bb426144dd59522a1f72d3f1e63d552d7a91', 'MOBILE SYSTEM GB logo runtime'),
    (0x11, 0x4067, 0x41cf, 'f7c51824bb69327ba998f1171ae5f6f3eb38ad92', 'MOBILE SYSTEM GB tilemap'),
    (0x11, 0x41cf, 0x4337, 'fb77be53bf95f4af83f47b4c4a141963c985e7f0', 'MOBILE SYSTEM GB attrmap'),
    (0x11, 0x4337, 0x48a7, 'bbd690d651516cc69f367d07b7f0a2f4b584d8b9', 'MOBILE SYSTEM GB graphics'),
    (0x11, 0x48a7, 0x48af, '1cff52da7b6520096bdd9c7662db36d9a85c55e2', 'MOBILE SYSTEM GB palette'),
    (0x10, 0x4000, 0x4175, '6265c35a204d7acbce9cb0f26e331993925612ae', 'hardware startup/color-required presentation'),
    (0x10, 0x4175, 0x4915, '54cffb4774c87c7cb71db979f4da4579e7a3d8e1', 'HUDSON logo graphics'),
    (0x10, 0x4915, 0x4d15, 'bc91efd1c024b6a818578fe45c0c0c2ab4b91a58', 'HUDSON logo tilemap'),
    (0x00, 0x0291, 0x02b1, 'd07af79b9334c58a4504808c3dc281933bb2f9f8', 'cartridge boot/model capture'),
    (0x00, 0x0f02, 0x0f1c, '6a693ff1eed047449980be2f0a2570a565a4d8e2', 'dual-bank BG tilemap clear'),
    (0x00, 0x352e, 0x3537, '05bad204425a2da58949e2fabed6924e0ac161a5', 'VBlank FIFO wait'),
    (0x00, 0x3988, 0x39c7, 'd83e9a7f7c40ddaac23e7ea9c51277466c15df3a', 'SRAM absolute erase/reinitialize'),
    (0x10, 0x4dc0, 0x4df3, '1dfc5d1171150982faf3bd43a4271fe4fc50347c', 'title/attract controller'),
    (0x10, 0x4e8b, 0x4ed4, '7b96ac3cafa6304aad0a9c3c84cf2ff4a664f4d9', 'Anime Demo attract splash'),
    (0x10, 0x4ed4, 0x4efc, 'ac1e9f1f4cb1010cd449f844bb22414099ae91b9', 'standard-map attract demo'),
    (0x10, 0x4efc, 0x5080, 'bb1edc1428898ed77ecf37714e13b1e80db41ac8', 'absolute-erasure UI'),
]
for b,s,e,h,name in ranges:
    require(digest(b,s,e) == h, f'{name} retail range changed')

boot = (ROOT/'engine/home/home_boot_entry.asm').read_text()
for token in ('CartridgeBootEntry::','ld [wBootHardwareModel], a','call SRAM_CheckSignature',
              'call SRAM_EraseAllAndReinitialize','farcall $19, NetworkRegistration_ValidateOrInitializeSignature',
              'assert @ == $02b1'):
    require(token in boot, f'missing boot token: {token}')

home = (ROOT/'engine/home/home.asm').read_text()
for token in ('Vram_ClearBGTilemapBothBanks::','Vram_ClearBGTilemapCurrentBank::','assert @ == $0f1c'):
    require(token in home, f'missing BG-clear token: {token}')

system = (ROOT/'engine/home/home_system.asm').read_text()
require('VBlankFIFO_WaitEmpty::' in system, 'missing VBlank FIFO wait helper')

sram = (ROOT/'engine/map/map_sram.asm').read_text()
for token in ('SRAM_EraseAllAndReinitialize::','cp $10','call SRAM_WriteSignature','farcall $19, $7059','assert @ == $39c7'):
    require(token in sram, f'missing SRAM erase token: {token}')

startup = (ROOT/'engine/ui/startup_title_controller.asm').read_text()
for token in ('STARTUP_ERASE_CHORD EQU $65','Startup_TitleAttractLoop::','farcall $23, AttractIntro_Run',
              'Startup_RunStandardMapAttractDemo::','ld a, 60','farcall MapRecord_SelectStandard',
              'farcall MapRuntime_PrepareSelectedMapState','farcall MapControl_RunSelectedMapController',
              'Startup_ShowAnimeDemoSplash::','db "アニメデモ", 0','assert @ == $4ed4',
              'Startup_CheckAbsoluteEraseShortcut::','and STARTUP_ERASE_CHORD','call SRAM_EraseAllAndReinitialize',
              'StartupAbsoluteErase_SelectChoice::','StartupAbsoluteErase_UpdateChoiceAttributes::',
              'db "セーブデータを", 0','db "ほんとうに  ", 0','assert @ == $5080'):
    require(token in startup, f'missing startup token: {token}')


hw = (ROOT/'engine/ui/startup_hardware_presentation.asm').read_text()
for token in ('Startup_RunHardwarePresentation::','cp $11','Startup_ResetPresentationVRAMAndPalettes::',
              'Startup_ShowColorRequiredScreen::','Startup_LoadColorRequiredMessage::',
              'db "ゲームボーイウォーズ3"','db "ゲームボーイカラーせんようです。"',
              'assert @ == $4175'):
    require(token in hw, f'missing startup hardware token: {token}')

hud = (ROOT/'engine/ui/startup_hardware_presentation.asm').read_text()
for token in ('HudsonLogo_Graphics::','HudsonLogo_Tilemap::','INCBIN "gfx/startup/hudson_logo.2bpp"',
              'INCBIN "gfx/startup/hudson_logo.tilemap"','assert @ == $4d15'):
    require(token in hud, f'missing HUDSON asset token: {token}')
for rel, expected_size, expected_sha in (
    ('gfx/startup/hudson_logo.2bpp', 1952, '54cffb4774c87c7cb71db979f4da4579e7a3d8e1'),
    ('gfx/startup/hudson_logo.tilemap', 1024, 'bc91efd1c024b6a818578fe45c0c0c2ab4b91a58')):
    data=(ROOT/rel).read_bytes()
    require(len(data)==expected_size, f'{rel} size changed')
    require(sha1(data).hexdigest()==expected_sha, f'{rel} bytes changed')
vis=(ROOT/'gfx/startup/hudson_logo.tilemap').read_bytes()
visible=[vis[y*32+x] for y in range(18) for x in range(20)]
require(max(visible)==0x79, 'HUDSON visible tilemap no longer matches 122-tile resource bound')

logo = (ROOT/'engine/ui/mobile_system_gb_logo.asm').read_text()
for token in ('MobileSystemGB_ShowLogo::','MobileSystemGB_LoadAssets::','MobileSystemGB_Copy20x18::',
              'MobileSystemGB_Tilemap::','MobileSystemGB_Attrmap::','MobileSystemGB_Graphics::','MobileSystemGB_Palette::',
              'ld bc, $0600','assert @ == $48af'):
    require(token in logo, f'missing MOBILE SYSTEM GB token: {token}')

for rel, expected_size, expected_sha in (
    ('gfx/startup/mobile_system_gb.tilemap', 360, 'f7c51824bb69327ba998f1171ae5f6f3eb38ad92'),
    ('gfx/startup/mobile_system_gb.attrmap', 360, 'fb77be53bf95f4af83f47b4c4a141963c985e7f0'),
    ('gfx/startup/mobile_system_gb.2bpp', 1392, 'bbd690d651516cc69f367d07b7f0a2f4b584d8b9'),
    ('gfx/startup/mobile_system_gb.pal', 8, '1cff52da7b6520096bdd9c7662db36d9a85c55e2')):
    data=(ROOT/rel).read_bytes()
    require(len(data)==expected_size, f'{rel} size changed')
    require(sha1(data).hexdigest()==expected_sha, f'{rel} bytes changed')

require(max((ROOT/'gfx/startup/mobile_system_gb.tilemap').read_bytes()) == 0x56, 'logo tilemap references beyond 87 owned tiles')

symbols = (ROOT/'symbols.asm').read_text()
require('sym $00, $c010, wBootHardwareModel' in symbols, 'boot model symbol missing')

make = (ROOT/'Makefile').read_text()
for token in ('engine/home/home_boot_entry.o','engine/ui/startup_title_controller.o','engine/ui/startup_hardware_presentation.o','engine/ui/mobile_system_gb_logo.o'):
    require(token in make, f'Makefile missing {token}')

# No legacy raw calls remain for helpers now owned by source.
for path in ROOT.glob('engine/**/*.asm'):
    text = path.read_text()
    require('call $352e' not in text, f'raw FIFO-wait call remains in {path}')
    require('call $0f02' not in text, f'raw BG-clear call remains in {path}')

print('startup/title controller: boot model capture, attract loop, Standard-map demo, and hidden erase UI [ok]')
print('SRAM absolute erase: 16 banks cleared, signature/default block rebuilt, retail bytes locked [ok]')
