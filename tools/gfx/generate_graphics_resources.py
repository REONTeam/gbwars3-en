#!/usr/bin/env python3
"""Generate neutral human-facing graphics layouts and ROM-authentic palette files.

Policy:
- if one graphic is used with multiple palettes, keep ONE neutral 4-shade PNG;
- keep the runtime .pal files separately;
- do not generate preview-only PNG variants.
"""
from pathlib import Path
from PIL import Image, ImageOps
import csv, argparse, re

ROOT = Path(__file__).resolve().parents[2]
NEUTRAL = [(255,255,255), (170,170,170), (85,85,85), (0,0,0)]

def off(bank, addr):
    return bank * 0x4000 + (addr - 0x4000 if bank else addr)

def write_pal(path, rom, bank, addr, count=1):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(rom[off(bank,addr):off(bank,addr)+count*8])

def neutralize_indexed(path):
    im = Image.open(path)
    if im.mode != 'P':
        g = im.convert('L')
        vals = sorted(set(g.getdata()), reverse=True)
        if len(vals) <= 4:
            mapping = {v:i for i,v in enumerate(vals)}
            data = [mapping[v] for v in g.getdata()]
        else:
            levels = [255,170,85,0]
            data = [min(range(4), key=lambda i: abs(v-levels[i])) for v in g.getdata()]
        im = Image.new('P', g.size)
        im.putdata(data)
    pal = []
    for c in NEUTRAL:
        pal.extend(c)
    pal += [0,0,0] * (256-4)
    im.putpalette(pal[:768])
    im.save(path, optimize=True, bits=2)

def decode_2bpp(blob):
    tiles=[]
    for o in range(0,len(blob),16):
        p=[]
        for y in range(8):
            lo,hi=blob[o+2*y:o+2*y+2]
            for x in range(8):
                bit=7-x
                p.append(((hi>>bit)&1)*2+((lo>>bit)&1))
        tiles.append(p)
    return tiles

def render_tile(tile, xf=False, yf=False):
    im=Image.new('RGB',(8,8)); px=im.load()
    for y in range(8):
        sy=7-y if yf else y
        for x in range(8):
            sx=7-x if xf else x
            px[x,y]=NEUTRAL[tile[sy*8+sx]]
    return im

def render_metatile(tiles, rec):
    out=Image.new('RGB',(16,16),NEUTRAL[0])
    for q in range(4):
        tid,attr=rec[q*2:q*2+2]
        out.paste(render_tile(tiles[tid],bool(attr&0x20),bool(attr&0x40)),((q&1)*8,(q>>1)*8))
    return out

def map_resources(rom):
    root=ROOT/'gfx/environment/map'
    write_pal(root/'map_screen.pal',rom,1,0x5868,8)
    tiles=decode_2bpp((root/'terrain_tiles.2bpp').read_bytes())
    table=rom[0x1C6C:0x1C6C+0x34*8]
    files=sorted((root/'metatiles').rglob('*.png'))
    byidx={int(p.name[:2],16):p for p in files if len(p.name)>=2}
    atlas=Image.new('RGB',(160,140),(255,255,255))
    for i in range(0x34):
        im=render_metatile(tiles,table[i*8:(i+1)*8])
        if i in byidx:
            im.save(byidx[i])
        atlas.paste(im,((i%8)*20+2,(i//8)*20+2))
    atlas.save(root/'terrain_tiles.png')

def map_icon_resources(rom):
    root=ROOT/'gfx/units'
    tiles=decode_2bpp((root/'map_icons.2bpp').read_bytes())
    text=(ROOT/'engine/unit/unit.asm').read_text()
    block=text.split('UnitData:',1)[1].split('assert @ - UnitData',1)[0]
    labels=re.findall(r'^\s*dw \.([A-Za-z0-9_]+)\s*$',block,re.M)
    table=rom[0x1E0C:0x1E0C+107*8]
    atlas=Image.new('RGB',(160,140),(255,255,255))
    outroot=root/'map_icons/composed'
    for i,name in enumerate(labels):
        # Side 0 is the canonical neutral orientation. Both side records remain
        # source-backed in runtime_metatiles.csv / ROM source.
        rec=table[(i*2)*8:(i*2+1)*8]
        im=render_metatile(tiles,rec)
        category='special' if i in (0,52) else 'ground' if i<=28 else 'air' if i<=43 else 'sea'
        d=outroot/category/f'{i:02d}_{name}'
        d.mkdir(parents=True,exist_ok=True)
        for old in [d/'side0.png',d/'side1.png']:
            if old.exists(): old.unlink()
        im.save(d/'icon.png')
        atlas.paste(im,((i%8)*20+2,(i//8)*20+2))
    atlas.save(root/'map_icons.png')

def battle_resources(rom):
    root=ROOT/'gfx/units/battle'; paldir=root/'palettes'; paldir.mkdir(exist_ok=True)
    families={
        'ground':(0x5F81,0x5F89,range(1,29)),
        'sea':(0x6E51,0x6E59,range(44,52)),
        'air':(0x7B21,0x7B29,range(29,44)),
    }
    rows=list(csv.DictReader((root/'per_unit/manifest.csv').open()))
    rowby={int(r['unit_type']):r for r in rows if r['unit_type']}
    # Build PNGs are one neutral image even though two side palettes exist.
    for r in rows:
        if r.get('png') and (root/'per_unit'/r['png']).exists():
            neutralize_indexed(root/'per_unit'/r['png'])
    for fam,(a0,a1,ids) in families.items():
        write_pal(paldir/f'{fam}_red_star.pal',rom,0x16,a0)
        write_pal(paldir/f'{fam}_white_moon.pal',rom,0x16,a1)
        ims=[]
        for uid in ids:
            r=rowby[uid]
            ims.append(Image.open(root/'per_unit'/r['png']).convert('RGB'))
        cellw=max(im.width for im in ims)+8; cellh=max(im.height for im in ims)+8
        cols=7; rowsn=(len(ims)+cols-1)//cols
        atlas=Image.new('RGB',(cols*cellw,rowsn*cellh),(255,255,255))
        for k,im in enumerate(ims):
            atlas.paste(im,((k%cols)*cellw+4,(k//cols)*cellh+4))
        atlas.save(root/f'{fam}.png')
    if (root/'special.png').exists():
        # Keep special-family artwork neutral as well.
        try: neutralize_indexed(root/'special.png')
        except Exception: pass


def attract_scene_resources(rom):
    root=ROOT/'gfx/attract'; root.mkdir(parents=True,exist_ok=True)
    b23=root/'resources_bank23'; b23.mkdir(parents=True,exist_ok=True)
    b24=root/'resources_bank24'; b24.mkdir(parents=True,exist_ok=True)
    def chunk(bank,start,end): return rom[off(bank,start):off(bank,end)]
    # Physical Bank $23 slices.
    specs23=[
      ('scene1.tilemap',0x4fc7,0x508f),('scene1.attrmap',0x508f,0x5157),('scene1.2bpp',0x5157,0x5dd7),
      ('scene1_pal_0.pal',0x5dd7,0x5dff),('scene1_pal_1.pal',0x5dff,0x5e17),
      ('scene3.tilemap',0x5e17,0x5edf),('scene3.attrmap',0x5edf,0x5fa7),('scene3.2bpp',0x5fa7,0x6bc7),
      ('scene3_pal_0.pal',0x6bc7,0x6bef),('scene3_pal_1.pal',0x6bef,0x6c07),
      ('scene4.tilemap',0x6c07,0x6ccf),('scene4.attrmap',0x6ccf,0x6d97),('scene4.2bpp',0x6d97,0x7a07),
      ('scene4_pal_0.pal',0x7a07,0x7a2f),('scene4_pal_1.pal',0x7a2f,0x7a47),('scene4_tail_tiles.2bpp',0x7a47,0x7ba7),
    ]
    for name,a,b in specs23:(b23/name).write_bytes(chunk(0x23,a,b))
    specs24=[
      ('scene2.tilemap',0x4000,0x40c8),('scene2.attrmap',0x40c8,0x4190),('scene2.2bpp',0x4190,0x4c40),
      ('scene2_pal_0.pal',0x4c40,0x4c68),('scene2_pal_1.pal',0x4c68,0x4c80),
      ('scene5.tilemap',0x4c80,0x4d48),('scene5.attrmap',0x4d48,0x4e10),('scene5.2bpp',0x4e10,0x5640),
      ('scene5_pal_0.pal',0x5640,0x5668),('scene5_pal_1.pal',0x5668,0x5690),('campaign_map_select_page0.2bpp',0x5690,0x5e10),
    ]
    for name,a,b in specs24:(b24/name).write_bytes(chunk(0x24,a,b))
    # Keep complete logical scene views/previews for tooling.
    specs={0:(0x31,0x4A4A,0x4B12,0x4BDA,0x50BA),1:(0x23,0x4FC7,0x508F,0x5157,0x5DD7),2:(0x24,0x4000,0x40C8,0x4190,0x4C40),3:(0x23,0x5E17,0x5EDF,0x5FA7,0x6BC7),4:(0x23,0x6C07,0x6CCF,0x6D97,0x7A07),5:(0x24,0x4C80,0x4D48,0x4E10,0x5640)}
    for n,(bank,tm,am,gfx,pal) in specs.items():
        tilemap=chunk(bank,tm,tm+0xC8); attrs=chunk(bank,am,am+0xC8); graphics=chunk(bank,gfx,gfx+0x1000); palettes=chunk(bank,pal,pal+0x28)
        (root/f'scene_{n}.tilemap').write_bytes(tilemap); (root/f'scene_{n}.attrmap').write_bytes(attrs); (root/f'scene_{n}.2bpp').write_bytes(graphics); (root/f'scene_{n}.pal').write_bytes(palettes)
        tiles=decode_2bpp(graphics); out=Image.new('RGB',(20*8,10*8),NEUTRAL[0])
        for y in range(10):
            for x in range(20):
                i=y*20+x; attr=attrs[i]; tid=tilemap[i]; out.paste(render_tile(tiles[tid],bool(attr&0x20),bool(attr&0x40)),(x*8,y*8))
        out.save(root/f'scene_{n}.png')

def campaign_map_select_resources(rom):
    root=ROOT/'gfx/campaign/map_select'; root.mkdir(parents=True,exist_ok=True); phys=root/'resources'; phys.mkdir(parents=True,exist_ok=True)
    def chunk(bank,start,end): return rom[off(bank,start):off(bank,end)]
    # Physical source ownership from $5E10 onward; page 0 prefix lives in the attract pool.
    slices=[('campaign_map_select_page0_graphics_tail.2bpp',0x5e10,0x5e60),('campaign_map_select_page0_palettes.pal',0x5e60,0x5ea0)]
    for n,start in enumerate([0x5ea0,0x66b0,0x6ec0,0x76d0],1):
        slices += [(f'campaign_map_select_page{n}_graphics.2bpp',start,start+0x7d0),(f'campaign_map_select_page{n}_palettes.pal',start+0x7d0,start+0x810)]
    for name,a,b in slices:(phys/name).write_bytes(chunk(0x24,a,b))
    page_starts=[0x5690,0x5EA0,0x66B0,0x6EC0,0x76D0]
    for n,start in enumerate(page_starts):
        graphics=chunk(0x24,start,start+0x7D0); palettes=chunk(0x24,start+0x7D0,start+0x810)
        (root/f'page_{n}.2bpp').write_bytes(graphics); (root/f'page_{n}.pal').write_bytes(palettes)
        tiles=decode_2bpp(graphics); out=Image.new('RGB',(25*8,5*8),NEUTRAL[0])
        for i,tile in enumerate(tiles): out.paste(render_tile(tile),((i%25)*8,(i//25)*8))
        out.save(root/f'page_{n}.png')

def palette_resources(rom):
    specs=[
      (ROOT/'gfx/ui/map_menu.pal',0x13,0x585C,1),
      (ROOT/'gfx/ui/name_screen.pal',0x14,0x5968,1),
      (ROOT/'gfx/ui/config.pal',0x15,0x4893,1),
      (ROOT/'gfx/ui/vs_menu_type.pal',0x15,0x7942,1),
      (ROOT/'gfx/ui/unit_status.pal',0x18,0x7E78,8),
      (ROOT/'gfx/results/results.pal',0x27,0x67F3,1),
      (ROOT/'gfx/file_select/file_select_general2.pal',0x27,0x7957,1),
    ]
    for path,bank,addr,count in specs:
        write_pal(path,rom,bank,addr,count)

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('rom',type=Path); a=ap.parse_args()
    rom=a.rom.read_bytes()
    if len(rom)<0x100000: raise SystemExit('expected 1 MiB ROM')
    map_resources(rom); map_icon_resources(rom); battle_resources(rom); palette_resources(rom); attract_scene_resources(rom); campaign_map_select_resources(rom)
    print('[ok] generated neutral composed graphics and ROM-authentic palette resources')
if __name__=='__main__': main()
