#!/usr/bin/env python3
from pathlib import Path
from hashlib import sha1
import sys

ROOT=Path(__file__).resolve().parents[1]
rom=Path(sys.argv[1] if len(sys.argv)>1 else ROOT/'baserom.gbc').read_bytes()

def require(c,m):
    if not c: raise AssertionError(m)
def off(b,a): return a if b==0 else b*0x4000+(a-0x4000)
def digest(b,s,e): return sha1(rom[off(b,s):off(b,s)+(e-s)]).hexdigest()

require(digest(0,0x04d2,0x058d)=='7757d85123b37068b4258aacb232a198f6d817bc','LCD/interrupt helper block changed')
require(digest(0,0x07b4,0x0850)=='6d97bd31bdf6e18edb413b8057f64acc1bc40780','fade wrappers changed')
require(digest(0,0x3815,0x3878)=='a03821abea0c8971440fb87aa33f52161880d59e','audio frontend changed')
require(digest(0x10,0x4b55,0x4c59)=='565950ca8f05327e9538e12449d84236b759d606','fade engine changed')

home=(ROOT/'engine/home/home.asm').read_text()
for token in ('LCD_Enable::','LCD_Disable::','LCD_EnableWindow::','LCD_DisableWindow::',
              'Interrupt_EnableVBlank::','Interrupt_DisableVBlank::','Interrupt_EnableLCDStatMode0::',
              'Interrupt_DisableLCDStatMode0::','Interrupt_EnableLCDStat::','Interrupt_DisableLCDStat::',
              'assert @ == $0565'):
    require(token in home,f'missing LCD helper token: {token}')

fade=(ROOT/'engine/home/home_fade_audio.asm').read_text()
for token in ('FadeToWhite8::','FadeBGToWhite8::','FadeFromWhite8::','Fade_PrepareFromWhite::',
              'Fade_CacheOBJPaletteColor0s::','Fade_StepAllPals::','Fade_StepBGPals::',
              'Fade_InterpolateColor:','Fade_MoveComponentToward:','assert @ == $4c59'):
    require(token in fade,f'missing fade source token: {token}')

sysrc=(ROOT/'engine/home/home_system.asm').read_text()
for token in ('Audio_StopMusic::','Audio_PlayMusic::','Audio_StopSFX::','Audio_PlaySFX::',
              'Audio_IsMusicPlaying::','call MusicDriver_RequestTrack','call MusicDriver_RequestSFX',
              'call MusicDriver_IsTrackActive'):
    require(token in sysrc,f'missing audio frontend token: {token}')

syms=(ROOT/'symbols.asm').read_text()
for token in ('wInterruptEnableBackup','wFadeOBJPaletteColor0Cache','wFadeActive','wFadeStepsRemaining',
              'wFadeComponentScratch','wFadeComponentCarryScratch','wFadeTargetPals'):
    require(token in syms,f'missing display/fade state symbol: {token}')

for p in ROOT.rglob('*.asm'):
    if 'tools/rgbds-' in p.as_posix(): continue
    t=p.read_text(errors='ignore').lower()
    for raw in ('call $04f3','call $07b4','call $081d','call $3844'):
        require(raw not in t,f'raw sourced helper call {raw} remains in {p.relative_to(ROOT)}')

print('shared display runtime: LCD/IRQ $04D2-$058C, fades $07B4-$084F/$10:$4B55-$4C58, audio $3815-$3877 [ok]')
