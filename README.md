# Game Boy Wars 3 English Disassembly

A source-complete RGBDS disassembly of **Game Boy Wars 3** for Game Boy Color that preserves the project's custom English build.

The repository reconstructs the complete 1 MiB ROM from project source and assets without an RGBLINK base-ROM overlay. A verified Japanese retail ROM is still required as an explicit build prerequisite. Executable code is represented as RGBDS mnemonics where control-flow evidence is established; text, graphics, music streams, tables, and still-neutral structural data are owned explicitly as source or binary assets.

## Build identity

The canonical custom-English build is:

- Size: `0x100000` bytes (1 MiB)
- SHA-256: `e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059`
- Cartridge: MBC5 + RAM + battery
- SRAM geometry: 128 KiB

`make check-baseline` is the optional strict regression target that verifies the current canonical custom-English output hash in addition to the project's structural baseline checks. Normal development builds do not require that output hash to remain unchanged.

## Requirements

The project is pinned to **RGBDS 1.0.3** for `rgbasm`, `rgblink`, and `rgbfix`. Normal builds bootstrap those official prebuilt tools into `tools/rgbds/bin/`.

A verified **Japanese retail Game Boy Wars 3 ROM is required to build**. Place an unmodified ROM in the repository root as `baserom.gbc`. The build checks its exact identity before assembling/linking. The ROM is a prerequisite/reference only: RGBLINK does **not** overlay or inherit bytes from it.

Host-side requirements are:

- **Python 3** — used by the RGBDS bootstrap and verification tools.
- **GNU Make** (or a compatible `make`).
- A shell/build environment capable of running the Makefiles.
- Internet access for the first automatic RGBDS bootstrap, unless `RGBDS_ARCHIVE` or explicit RGBDS tool paths are supplied.

### Windows

For Windows, the recommended environment is an **MSYS2 UCRT64/MinGW64 shell** (or another POSIX-compatible GNU Make environment). This gives the project the shell utilities expected by the Makefiles and is also the easiest way to provide a C toolchain if graphics need to be regenerated.

An ordinary source build uses the canonical generated `.2bpp` graphics included in the repository. If those files remain present and their PNG sources are unchanged, the legacy graphics converter normally does not need to be rebuilt.

If you edit a PNG, delete generated `.2bpp` files, or intentionally regenerate graphics from scratch, `tools/rgbgfx-legacy` must be compiled. That compatibility converter requires:

- a C compiler;
- `pkg-config`;
- the libpng development libraries; and
- the POSIX shell utilities used by its Makefile.

The legacy converter is intentional: modern RGBDS `rgbgfx` does **not** reproduce this project's historical tile bytes exactly. RGBDS 1.0.3 is still used for the assembler, linker, and ROM fixer.

### Linux and macOS

Use a normal POSIX development environment with Python 3 and GNU Make. A C compiler, `pkg-config`, and libpng development files are only required when rebuilding the legacy graphics converter.

With the prerequisites in place, copy your Japanese retail ROM to the project root as `baserom.gbc`, then build:

```sh
make
```

The supported retail dump is checked against:

- SHA-1: `61e08f96261b5f85c65c70db5464b4298f9f2cf8`
- SHA-256: `ba5e14c23e20ea9003482239ceac6c77bec19b3fcae61fd2863e11c06b345e5e`

You can validate the ROM separately with:

```sh
make check-baserom
```

If automatic RGBDS download is unavailable, point the build at an official RGBDS 1.0.3 release archive (for example the Win64 ZIP):

```sh
make RGBDS_ARCHIVE=/path/to/rgbds-win64.zip
```

Or install RGBDS 1.0.3 yourself and override the three required tools explicitly:

```sh
make RGBASM=/path/to/rgbasm RGBLINK=/path/to/rgblink RGBFIX=/path/to/rgbfix
```

`baserom.gbc` is a normal build dependency and is also used by research/regression verifiers that compare recovered ranges with the retail release. It is never included in release archives.

## Verification

Normal mod development does **not** require the output ROM to match the current canonical custom-English hash. The only mandatory identity check in an ordinary build is the supplied Japanese retail `baserom.gbc`.

Build normally with:

```sh
make
```

For development-safe checks that remain valid after intentional ROM changes, use:

```sh
make check
```

`make check-release` is an alias of this development-safe gate. It verifies the retail ROM prerequisite, rebuilds the project, checks RGBDS syntax, and confirms the expected toolchain. It does **not** compare `GBWARS3.gbc` against the current baseline hash.

To verify that an **unmodified checkout** still reproduces the current known-good custom-English baseline exactly, run:

```sh
make check-baseline
```

`check-baseline` runs the strict historical regression suite, including the canonical output SHA-256 and byte/structure checks. It is optional and is expected to fail after deliberate game modifications that change ROM bytes.

Individual research/regression verifiers under `tools/verify_*.py` are also optional development aids. Some intentionally compare source ranges or the complete output against the established baseline and therefore may fail after legitimate modifications.

You can validate only the required retail ROM separately with:

```sh
make check-baserom
```

The normal link produces `GBWARS3.gbc`, `GBWARS3.map`, and `GBWARS3.sym`. Generated ROMs, object/dependency files, downloaded/compiled tool binaries, and map/symbol files are build products and are not part of release source archives.

## Repository layout

- `engine/` — executable game code grouped by subsystem.
- `data/` — text, maps, tables, configuration, and non-executable data.
- `audio/` — music/sound drivers, semantic music source, and sound resources.
- `gfx/` — editable PNG sources and generated Game Boy graphics.
- `constants/` — hardware, engine, and structure constants.
- `charmaps/` — game text encodings.
- `macros/` — shared RGBDS macros.
- `docs/` — architecture, subsystem, format, testing, and research notes.
- `tools/` — RGBDS bootstrap, the legacy-rgbgfx compatibility source, extraction helpers, and verification scripts.
- `symbols.asm` — shared ROM/RAM symbols.
- `ROADMAP.md` — post-completion refinement status.

## Source-quality conventions

- Prefer semantic labels once behavior is demonstrated by callers or data flow.
- Keep uncertain structures neutral instead of assigning speculative gameplay names.
- Preserve fixed ROM geometry with explicit sections and boundary assertions.
- Use symbolic farcalls and control-flow targets wherever a stable source label exists.
- Keep editable graphics and text authoritative; generated binary forms must rebuild byte-exactly.
- Treat binary assets as legitimate source when their internal format is not yet safely decomposed.

The Map Menu/Versus frontend has no remaining `...Provider_BankXX_YYYY` aliases. The complete active music catalog is now expressed as semantic RGBDS source: packed notes/rests use named pitches and durations, and VM control bytes use named macros for octave, loops, envelopes, modulation, presets, routing, and related state. Late Banks `$3E/$3F` contain 19 per-track ASM files covering 78 channel entries; no raw `.music` stream files remain. See `docs/audio/music_command_format.md` and `docs/audio/late_music_banks.md`.

The old `data/remaining/` staging folder has been eliminated entirely. Subsequent refinement also retired the temporary generic `.dat`, `.sound`, and `.gfx` layers: executable driver duplicates are assembled from source, proven graphics are format-specific assets, and unresolved structural bytes are owned directly by RGBDS source. See `docs/architecture/remaining_asset_migration.md`.

## English/custom features

The disassembly includes a custom English project, including an extended Campaign briefing system and custom map-name work. Campaign briefing relocation coverage is complete: all Campaign pre-map/result entries resolve through Bank `$34`; untranslated entries remain editable Japanese plaintext rather than opaque message blobs.

The main charmap explicitly maps the English full stop (`.`) to the game's `$2E` punctuation glyph, eliminating the previous unmapped-character build warnings while preserving the canonical ROM hash.


## Semantic polish status

The post-completion cleanup now also gives the common SFX request IDs semantic names,
exposes semantic aliases for their Bank `$08` streams, promotes already-proven ROM0
entry points out of the old address-only `RemainingCode_*` namespace, and represents
the ROM0 map-control phase dispatch table with typed banked-callback records.

`engine/remaining_rom.asm` has also been structurally cleaned: 604 branch/control-flow
targets are now RGBDS local labels, while 257 potential indirect/cross-scope entry
anchors remain global under the neutral `RuntimeEntry_BankXX_YYYY` namespace. No
`RemainingCode_*` labels remain, and none of the neutral `RuntimeEntry_*` anchors is
used as a cross-file public API. Semantic public routines continue to live under their
proven names. See `docs/architecture/runtime_label_cleanup.md`.

## Runtime QA

Automated verification is primarily byte/structure based. A release-oriented runtime checklist is maintained in `docs/testing/runtime_regression.md` for emulator/hardware smoke testing of boot, map loading, campaign, save/load, Map Menu, Unit List/Status, infrared, and Mobile Adapter-facing flows.


## Binary asset format cleanup

The repository no longer uses generic `.dat`, `.sound`, `.gfx`, or `.bin` assets. Proven graphics use format-specific `.2bpp`, `.tilemap`, `.attrmap`, and `.pal` files; music and duplicated audio-driver banks are RGBDS source; small neutral structural records are emitted directly as `db`/`ds` until their higher-level format is proven. Release verification enforces this convention.

## Completion definition

This project calls the disassembly complete because:

1. every ROM byte is explicitly included in source/data/padding;
2. the main link does not use `rgblink -O baserom.gbc`;
3. known reset/interrupt/direct/farcall-reachable code has been promoted from inherited space into mnemonic source;
4. an unmodified checkout can reproduce the documented canonical custom-English hash via the optional `make check-baseline` regression target;
5. remaining binary assets are explicit resources, not hidden base-ROM inheritance.

This does **not** mean every byte has a final gameplay-semantic name. Further work is refinement: identifying neutral data formats, improving names, and converting binary resources into higher-level editable forms when evidence supports it.

