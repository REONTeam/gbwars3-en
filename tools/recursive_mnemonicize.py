#!/usr/bin/env python3
from pathlib import Path
import re, sys

ROOT=Path(__file__).resolve().parents[1]
ROM=Path('/mnt/data/GBWARS3_expected_e533.gbc').read_bytes()
SYM=ROOT/'GBWARS3.sym'
syms={}
if SYM.exists():
    for line in SYM.read_text(errors='ignore').splitlines():
        m=re.match(r'([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(.+)$',line)
        if m: syms[m.group(3).strip()] = (int(m.group(1),16),int(m.group(2),16))

R8=['b','c','d','e','h','l','[hl]','a']
RP=['bc','de','hl','sp']; RP2=['bc','de','hl','af']
CC=['nz','z','nc','c']
ALU=['add a, {}','adc a, {}','sub {}','sbc a, {}','and {}','xor {}','or {}','cp {}']
ROT=['rlc','rrc','rl','rr','sla','sra','swap','srl']

def s8(x): return x-256 if x>=128 else x

def dec_cb(pc,b):
    x=b>>6; y=(b>>3)&7; z=b&7
    if x==0: return f'{ROT[y]} {R8[z]}'
    if x==1: return f'bit {y}, {R8[z]}'
    if x==2: return f'res {y}, {R8[z]}'
    return f'set {y}, {R8[z]}'

def decode(bank,pc,data,farcall=True):
    i=pc-0x4000 if bank else pc
    b=data[i]
    def u8(n=1): return data[i+n]
    def u16(n=1): return data[i+n] | (data[i+n+1]<<8)
    # Project-specific inline farcall: rst $28 + bank + little-endian address
    if farcall and b==0xEF:
        return (4, f'farcall ${u8():02x}, ${u16(2):04x}', 'fall', None)
    if b==0xCB:
        return (2, dec_cb(pc,u8()), 'fall', None)
    if 0x40<=b<=0x7f:
        if b==0x76: return (1,'halt','stop',None)
        return (1,f'ld {R8[(b>>3)&7]}, {R8[b&7]}','fall',None)
    if 0x80<=b<=0xbf:
        return (1,ALU[(b>>3)&7].format(R8[b&7]),'fall',None)
    fixed={
      0x00:(1,'nop','fall'),0x07:(1,'rlca','fall'),0x0f:(1,'rrca','fall'),0x17:(1,'rla','fall'),0x1f:(1,'rra','fall'),
      0x27:(1,'daa','fall'),0x2f:(1,'cpl','fall'),0x37:(1,'scf','fall'),0x3f:(1,'ccf','fall'),
      0x02:(1,'ld [bc], a','fall'),0x12:(1,'ld [de], a','fall'),0x22:(1,'ld [hli], a','fall'),0x32:(1,'ld [hld], a','fall'),
      0x0a:(1,'ld a, [bc]','fall'),0x1a:(1,'ld a, [de]','fall'),0x2a:(1,'ld a, [hli]','fall'),0x3a:(1,'ld a, [hld]','fall'),
      0xc9:(1,'ret','ret'),0xd9:(1,'reti','ret'),0xe9:(1,'jp hl','stop'),0xf9:(1,'ld sp, hl','fall'),
      0xf3:(1,'di','fall'),0xfb:(1,'ei','fall'),
      0xe2:(1,'ldh [c], a','fall'),0xf2:(1,'ldh a, [c]','fall'),
    }
    if b in fixed:
        L,T,F=fixed[b]; return (L,T,F,None)
    # 16-bit loads/inc/dec/add
    if b in (0x01,0x11,0x21,0x31):
        r=RP[(b>>4)&3]; return (3,f'ld {r}, ${u16():04x}','fall',None)
    if b in (0x03,0x13,0x23,0x33): return (1,f'inc {RP[(b>>4)&3]}','fall',None)
    if b in (0x0b,0x1b,0x2b,0x3b): return (1,f'dec {RP[(b>>4)&3]}','fall',None)
    if b in (0x09,0x19,0x29,0x39): return (1,f'add hl, {RP[(b>>4)&3]}','fall',None)
    # 8-bit inc/dec/immediate
    if b<0x40 and (b&7) in (4,5,6):
        r=R8[(b>>3)&7]
        if (b&7)==4: return (1,f'inc {r}','fall',None)
        if (b&7)==5: return (1,f'dec {r}','fall',None)
        return (2,f'ld {r}, ${u8():02x}','fall',None)
    # jr family
    if b==0x18:
        t=(pc+2+s8(u8()))&0xffff; return (2,f'jr ${t:04x}','jump',t)
    if b in (0x20,0x28,0x30,0x38):
        c=CC[(b-0x20)//8]; t=(pc+2+s8(u8()))&0xffff; return (2,f'jr {c}, ${t:04x}','branch',t)
    # misc low
    if b==0x08: return (3,f'ld [${u16():04x}], sp','fall',None)
    if b==0x10:
        if u8()!=0: raise ValueError(f'noncanonical STOP at {bank:02x}:{pc:04x}')
        return (2,'stop','stop',None)
    # returns conditional
    if b in (0xc0,0xc8,0xd0,0xd8): return (1,f'ret {CC[(b-0xc0)//8]}','branchret',None)
    # pop/push
    if b in (0xc1,0xd1,0xe1,0xf1): return (1,f'pop {RP2[(b-0xc1)//0x10]}','fall',None)
    if b in (0xc5,0xd5,0xe5,0xf5): return (1,f'push {RP2[(b-0xc5)//0x10]}','fall',None)
    # jp cc / jp
    if b in (0xc2,0xca,0xd2,0xda):
        c=CC[(b-0xc2)//8]; t=u16(); return (3,f'jp {c}, ${t:04x}','branch',t)
    if b==0xc3:
        t=u16(); return (3,f'jp ${t:04x}','jump',t)
    # call cc / call
    if b in (0xc4,0xcc,0xd4,0xdc):
        c=CC[(b-0xc4)//8]; t=u16(); return (3,f'call {c}, ${t:04x}','call',t)
    if b==0xcd:
        t=u16(); return (3,f'call ${t:04x}','call',t)
    # immediate ALU
    imm={0xc6:'add a,',0xce:'adc a,',0xd6:'sub',0xde:'sbc a,',0xe6:'and',0xee:'xor',0xf6:'or',0xfe:'cp'}
    if b in imm: return (2,f'{imm[b]} ${u8():02x}','fall',None)
    # rst
    if b in (0xc7,0xcf,0xd7,0xdf,0xe7,0xef,0xf7,0xff): return (1,f'rst ${b&0x38:02x}','call',b&0x38)
    # high mem/absolute loads
    if b==0xe0: return (2,f'ldh [${0xff00+u8():04x}], a','fall',None)
    if b==0xf0: return (2,f'ldh a, [${0xff00+u8():04x}]','fall',None)
    if b==0xea: return (3,f'ld [${u16():04x}], a','fall',None)
    if b==0xfa: return (3,f'ld a, [${u16():04x}]','fall',None)
    if b==0xe8: return (2,f'add sp, {s8(u8())}','fall',None)
    if b==0xf8:
        v=s8(u8()); sign='+' if v>=0 else '-'; return (2,f'ld hl, sp {sign} {abs(v)}','fall',None)
    raise ValueError(f'illegal/unknown opcode ${b:02x} at {bank:02x}:{pc:04x}')

def parse_sections(path):
    txt=path.read_text(errors='ignore')
    lines=txt.splitlines()
    sections=[]
    cur=None
    for idx,l in enumerate(lines):
        m=re.match(r'\s*section\s+"([^"]+)"\s*,\s*(?:romx|rom0)\[\$([0-9a-f]+)\](?:\s*,\s*bank\[\$([0-9a-f]+)\])?',l,re.I)
        if m:
            new_start=int(m.group(2),16)
            if cur:
                if cur['end'] is None: cur['end']=new_start
                sections.append(cur)
            cur={'name':m.group(1),'start':new_start,'bank':int(m.group(3),16) if m.group(3) else 0,'line':idx,'directive':l,'end':None}
        if cur:
            a=re.match(r'\s*assert\s+@\s*==\s*\$([0-9a-f]+)',l,re.I)
            if a: cur['end']=int(a.group(1),16)
    if cur: sections.append(cur)
    return lines,sections

def is_data_label(name):
    low=name.lower()
    keys=('table','message_','messages','data_','padding','constants','schedule','pointerorder','initialstate','signature','template','records','parameterdata','lookupdata','protocolidlebyte','prefix','coordinates','pointers','placeholder','resulttext','statuspreparing','statuswaiting','statuscommunicating','statusconnectionfailed','statuscommunicationerror','promptready','promptwaitorcancel','promptrestart','matrix','headerstrings')
    if low.startswith('battlescenelayout_') or low.startswith('battlesceneunitlayout'):
        return True
    if low.startswith('battleunithplayout_') and 'getpointer' not in low:
        return True
    return any(k in low for k in keys)

def mnemonicize(path):
    path=ROOT/path
    lines,secs=parse_sections(path)
    all_labels=[]
    for l in lines:
        m=re.match(r'([A-Za-z_][A-Za-z0-9_.]*)(::|:)$',l.strip())
        if m and m.group(1) in syms: all_labels.append(m.group(1))
    header=[]
    for l in lines:
        if re.match(r'\s*section\s+',l,re.I): break
        header.append(l)
    out=header[:]
    converted=0
    for sec in secs:
        if sec['end'] is None: raise RuntimeError(f'no end assert for {path}:{sec["name"]}')
        b=sec['bank']; st=sec['start']; en=sec['end']
        off=(b*0x4000+(st-0x4000)) if b else st
        data=ROM[(b*0x4000 if b else 0):((b+1)*0x4000 if b else 0x4000)] if b else ROM[:0x4000]
        labels={}
        for name in all_labels:
            sb,sa=syms[name]
            if sb==b and st<=sa<en: labels.setdefault(sa,[]).append(name)
        # Seed section start and non-data labels.
        start_names=labels.get(st,[])
        seeds=set()
        data_section=any(k in sec['name'].lower() for k in (' graphics',' palette',' palettes',' frames',' descriptors',' script',' pointers',' resources',' layout resource',' data table',' oam frames',' animation streams','metasprite'))
        if not data_section:
            if not start_names or any(not is_data_label(n) for n in start_names): seeds.add(st)
            for a,names in labels.items():
                if any(not is_data_label(n) for n in names): seeds.add(a)
            # Cross-bank farcall sites provide reliable additional public entry seeds.
            if b:
                for j in range(len(ROM)-3):
                    if ROM[j]==0xef and ROM[j+1]==b:
                        ta=ROM[j+2] | (ROM[j+3]<<8)
                        if st <= ta < en: seeds.add(ta)
        code={}; q=list(sorted(seeds)); seen=set()
        while q:
            pc=q.pop()
            if pc in seen or not(st<=pc<en): continue
            while st<=pc<en and pc not in seen:
                seen.add(pc)
                try: L,T,F,target=decode(b,pc,data)
                except (ValueError,IndexError): break
                if pc+L>en: break
                code[pc]=(L,T)
                converted += L
                if F in ('branch','call') and target is not None and st<=target<en: q.append(target)
                if F=='jump':
                    if target is not None and st<=target<en: q.append(target)
                    break
                if F in ('ret','stop'): break
                # branchret and call continue fallthrough
                pc += L
        out.append(sec['directive'])
        pc=st
        while pc<en:
            if pc in labels:
                for n in labels[pc]: out.append(n+'::' if any(re.match(rf'{re.escape(n)}::',x.strip()) for x in lines) else n+':')
            if pc in code:
                L,T=code[pc]; out.append('    '+T); pc+=L; continue
            # data run to next label or code, max 16 bytes
            stop=min(en,pc+16)
            for a in sorted(set(labels)|set(code)):
                if pc<a<stop: stop=a; break
            vals=[]
            while pc<stop and pc not in code:
                vals.append(data[pc-0x4000 if b else pc]); pc+=1
            if not vals:
                vals=[data[pc-0x4000 if b else pc]]; pc+=1
            out.append('    db '+', '.join(f'${v:02x}' for v in vals))
        out.append(f'    assert @ == ${en:04x}')
        out.append('')
    path.write_text('\n'.join(out).rstrip()+'\n')
    return converted

if __name__=='__main__':
    total=0
    for arg in sys.argv[1:]:
        n=mnemonicize(arg); print(f'{arg}: marked {n} reachable code bytes'); total+=n
    print('total marked',total)
