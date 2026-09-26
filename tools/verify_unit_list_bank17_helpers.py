#!/usr/bin/env python3
from pathlib import Path
import hashlib, re, sys
ROOT=Path(__file__).resolve().parents[1]
BANK=0x17; START=0x7346; END=0x73D4
EXPECTED='c4a0fe96e5f0f1ed1832a1c410504d48e4414593'
ROM_HASH='e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059'
SRC=ROOT/'engine/unit/unit_list_bank17_helpers.asm'
CALLERS=[ROOT/'engine/unit/unit_list_runtime_6c72.asm',ROOT/'engine/unit/unit_list_action_runtime_70d9.asm',ROOT/'engine/unit/unit_list_post_promotion_runtime_734d.asm',ROOT/'engine/unit/unit_list_tail_runtime_7e78.asm']

def main():
    base=ROOT/'baserom.gbc'; out=ROOT/'GBWARS3.gbc'
    if not base.is_file() or not out.is_file(): raise SystemExit('[fail] baserom.gbc and GBWARS3.gbc are required')
    rb=base.read_bytes(); ob=out.read_bytes(); off=BANK*0x4000+(START-0x4000)
    r=rb[off:off+END-START]; b=ob[off:off+END-START]
    if hashlib.sha1(r).hexdigest()!=EXPECTED: raise SystemExit('[fail] retail helper fingerprint mismatch')
    if b!=r: raise SystemExit('[fail] built Bank $17:$7346-$73D3 bytes differ from retail')
    if hashlib.sha256(ob).hexdigest()!=ROM_HASH: raise SystemExit('[fail] custom-English ROM hash drift')
    s=SRC.read_text()
    for token in ['UnitList_GetFilteredRecordPointer::','UnitList_GetStagingRecordPointer::','UnitList_ClearDisplayRow::','UnitList_UpdateScrollArrowVisibility::','assert @ == $73d4','section "Bank17 Tail Padding"','assert @ == $8000']:
        if token not in s: raise SystemExit(f'[fail] missing source token: {token}')
    allc='\n'.join(p.read_text() for p in CALLERS)
    for raw in ['$7346','$7352','$73a3']:
        if re.search(r'farcall\s+\$17\s*,\s*'+re.escape(raw), allc, re.I): raise SystemExit(f'[fail] raw Unit List helper call remains: {raw}')
    tail=rb[BANK*0x4000+(0x73D4-0x4000):(BANK+1)*0x4000]
    if not tail or any(x!=0xff for x in tail): raise SystemExit('[fail] Bank $17 tail after $73D3 is not all $FF')
    print('[ok] Bank $17:$7346-$73D3 Unit List helper family matches retail')
    print('[ok] 50x5-byte filtered/staging record pointers and row-clear helper are source-owned')
    print('[ok] Unit List scroll-arrow visibility callers are symbolic')
    print('[ok] Bank $17:$73D4-$7FFF is verified $FF padding')
    print('[ok] custom-English ROM SHA-256 unchanged')
if __name__=='__main__': main()
