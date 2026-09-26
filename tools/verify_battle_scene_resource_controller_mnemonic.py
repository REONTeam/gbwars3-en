#!/usr/bin/env python3
from pathlib import Path
import hashlib,re,sys
ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'engine/battle/battle_scene_resource_controller.asm'
BASE=ROOT/'baserom.gbc'; OUT=ROOT/'GBWARS3.gbc'
START=0x4000; END=0x41cf; BANK=0x14
EXPECTED_SHA1='fd74d0d2f2d716ea0e8d543a025764481d16b0db'
EXPECTED_CUSTOM='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'

def fail(s): raise SystemExit('[fail] '+s)
text=SRC.read_text(encoding='utf-8')
lead=text[text.index('section "Battle Scene Resource Controller Lead-In"'):text.index('section "Battle Scene Air-Matchup Variant Preparation"')]
if re.search(r'(?mi)^\s*db\b',lead): fail('raw db remains in Bank $14:$4000-$41CE controller')
if 'assert @ == $41cf' not in lead.lower(): fail('exclusive-end assertion missing')
if not BASE.is_file() or not OUT.is_file(): fail('baserom.gbc and GBWARS3.gbc are required')
r=BASE.read_bytes(); o=OUT.read_bytes(); off=BANK*0x4000+(START-0x4000); n=END-START
chunk=r[off:off+n]
if hashlib.sha1(chunk).hexdigest()!=EXPECTED_SHA1: fail('retail range SHA-1 mismatch')
if o[off:off+n]!=chunk: fail('rebuilt Bank $14:$4000-$41CE differs from retail')
if hashlib.sha256(o).hexdigest()!=EXPECTED_CUSTOM: fail('custom-English ROM hash drift')
print('[ok] Bank $14:$4000-$41CE is mnemonic and byte-exact')
print('[ok] custom-English SHA-256',EXPECTED_CUSTOM)
