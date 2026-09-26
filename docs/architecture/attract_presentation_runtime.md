# Attract presentation runtime

The title timeout enters the Bank `$23` attract-presentation subsystem through
`AttractIntro_Run` at `$48AC`. The subsystem is now split by real ownership
boundaries rather than by physical adjacency.

## Six-scene presentation controller

`AttractScene_Run` at `$23:$4000` accepts scene IDs 0-5. Each scene selects a
10-byte descriptor containing a resource bank, graphics pointer, palette
pointer, four presentation parameters, and a music ID. The descriptor loader
copies the two graphics halves into VRAM, installs the palette block, stages the
presentation parameters, and starts the selected music.

The shared scene text layer uses six bounded script streams. Their control format
is proven (`$01` line break, final `$00` terminator), but their glyph mapping is
kept byte-oriented until a separate producer/consumer trace proves the exact
character encoding.

Scene 4 has a dedicated transition at `$4773-$48AB`; it ultimately hands off to
the shared post-scene text runtime with the “LET'S PLAY NEXT / 15 AREA...”
sequence.

## Shared introduction/staff text runtime

`AttractIntro_Run` sets sequence 6 and enters `AttractText_RunCurrentSequence`.
The same renderer is reused by other sequence IDs. It owns the title-timeout game
introduction, “TO BE CONTINUED...”, the area prompt, and the full staff credits.
These streams use the proven `news` glyph encoding, with the retail apostrophe
byte retained explicitly where that charmap has no apostrophe mapping.

The runtime advances characters with a per-character delay, supports A-held fast
text, honors sequence-specific skip bits from `$C6A6`, displays a cursor sprite,
and clears pages after 16 text rows.

## Source-owned presentation resources

Bank `$23` is now physically closed:

- `$4000-$42BD`: scene controller, descriptors, text-layer setup/update.
- `$42BE-$4315`: skip/confirm control helpers.
- `$4316-$4772`: six bounded scene streams.
- `$4773-$48AB`: scene-4 transition / area-prompt handoff.
- `$48AC-$4FC6`: shared introduction/staff runtime and plaintext script data.
- `$4FC7-$7D96`: one shared attract resource pool for scenes 1, 3, and 4.
- `$7D97-$7FFF`: verified retail `$FF` padding.

The resource pool is intentionally single-owned because the retail copies overlap:
scene 1's `$1000` graphics window runs through scene 3's 20x10 layout, and scene
3's graphics window runs through scene 4's layout. Each logical scene view is also
exported under `gfx/attract/` as a tilemap, attrmap, `$1000` 2bpp window, five
palettes, and a neutral 160x80 PNG composition.

Bank `$24:$4000-$5E0F` is the equivalent shared pool for scenes 2 and 5. Scene 0
is more heavily aliased: its logical Bank `$31` graphics copy runs across bytes
already owned by the battle/presentation resource and adjacent runtime, so only
zero-byte semantic aliases and logical `gfx/attract/scene_0.*` views are added.
No Bank `$31` byte receives duplicate physical ownership.

ROM0 `$35FE-$36C3` is source-backed as `AttractScene_RenderLayout`. It writes
tile bytes to VRAM bank 0, forces attribute bit 3 so scene tiles come from VRAM
bank 1, and shifts the stored palette number by +3 to the descriptor-loaded BG
palette slots 3-7.
