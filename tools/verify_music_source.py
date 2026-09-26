#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
root=Path(__file__).resolve().parents[1]
errors=[]
# No opaque music channel blobs remain.
music_files=list(root.rglob('*.music'))
if music_files:
    errors.append('unexpected .music files: '+', '.join(str(p.relative_to(root)) for p in music_files[:10]))
# No legacy numeric stream vocabulary in active ASM/includes.
legacy=re.compile(r'\b(?:music_event|music_cmd_[0-9a-fA-F]{2}|music_end)\b')
for p in list(root.rglob('*.asm'))+list(root.rglob('*.inc')):
    try:s=p.read_text()
    except UnicodeDecodeError:continue
    if legacy.search(s): errors.append(f'legacy numeric music macro remains in {p.relative_to(root)}')
# Semantic vocabulary exists.
mac=(root/'macros/macros.inc').read_text()
for name in ['music_note','music_rest','music_duration_multiplier','music_octave','music_loop_point','music_loop','music_call','music_channel_preset']:
    if f'macro {name}' not in mac: errors.append(f'missing semantic macro {name}')
# Late source files.
late=list((root/'audio/music/bank3e').glob('musictrack_*.asm'))+list((root/'audio/music/bank3f').glob('musictrack_*.asm'))
if len(late)!=19: errors.append(f'expected 19 late track asm files, found {len(late)}')
# Complete active channel inventory.
labels=set()
pat=re.compile(r'^MusicTrack_([0-9A-F]{2})_Ch([1-4])::',re.M)
for p in (root/'audio').rglob('*.asm'):
    labels.update(pat.findall(p.read_text()))
tracks={t for t,c in labels}
if len(labels)!=165: errors.append(f'expected 165 unique channel labels, found {len(labels)}')
if len(tracks)!=42: errors.append(f'expected 42 active track IDs, found {len(tracks)}')
# Late binary include ban.
for p in (root/'audio').rglob('*.asm'):
    s=p.read_text()
    if re.search(r'INCBIN\s+"audio/music/.+musictrack_',s,re.I):
        errors.append(f'late track still INCBIN-backed in {p.relative_to(root)}')
# Built ROM identity when available.
rom=root/'GBWARS3.gbc'
if rom.exists():
    got=hashlib.sha256(rom.read_bytes()).hexdigest()
    exp='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
    if got!=exp: errors.append(f'ROM hash mismatch: {got}')
if errors:
    print('Music source verification FAILED')
    for e in errors: print(' -',e)
    sys.exit(1)
print('Music source verification PASS')
print(f'  active tracks: {len(tracks)}')
print(f'  channel entries: {len(labels)}')
print(f'  late track source files: {len(late)}')
print('  .music files: 0')
print('  legacy numeric stream macros: 0')
