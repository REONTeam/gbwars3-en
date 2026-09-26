# Post-completion refinement roadmap

## Status

**Core disassembly: 100% complete.** The repository owns and reconstructs all `1,048,576` ROM bytes without a base-ROM overlay. Builds intentionally require a verified Japanese retail ROM as a prerequisite/reference. The canonical custom-English build SHA-256 is:

`e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059`

The remaining work is optional source-quality refinement rather than missing ROM ownership.

## Completed refinement work

- Retired the historical `RemainingCode_*` namespace in `engine/remaining_rom.asm`: 604 intra-routine/section control-flow targets are local labels and 257 potential entry anchors use neutral `RuntimeEntry_BankXX_YYYY` names, with zero cross-file consumers.
- Added a proven SFX vocabulary for common UI/action feedback and action-specific effects; 152 request sites now use symbolic IDs, and the corresponding Bank `$08` streams expose semantic aliases without inventing unverified acoustic descriptions.
- Promoted already-established ROM0 entry points (`TextPrint`, number drawing, VBlank FIFO processing, farcall vectors/dispatcher, banked read/call helpers, and map-control phase controller) out of address-only `RemainingCode_*` names.
- Replaced the raw ROM0 map-control handler byte block with a typed `banked_callback` table using semantic Map AI targets where exact public labels exist.
- Added `make check-semantic-polish` and folded it into `make check-release`.
- Retired generic `.bin`, `.dat`, `.sound`, and `.gfx` asset layers. Proven graphics use `.2bpp`/`.tilemap`/`.attrmap`/`.pal`; music and duplicated audio drivers are RGBDS source; unresolved structural bytes are emitted directly in source until a real binary format is proven.
- Replaced Map Menu/Versus `...Provider_BankXX_YYYY` aliases with behavior-backed semantic labels; no such provider aliases remain in active engine source.
- Named the zero-terminated string comparison helper and the 16-byte persistent Network-field loader exposed by Map Menu callers.
- Named the Bank `$19:$518F` Mobile Menu controller from its sole high-level caller and presentation behavior.
- Fully disassembled the music VM stream format and promoted the complete active music catalog to semantic RGBDS source. Banks `$03-$07` use named note/command macros; Banks `$3E/$3F` now contain 19 per-track ASM files covering 78 late channel entries. No `.music` blobs or numeric `music_cmd_xx`/`music_event` macros remain.
- Added an explicit ASCII `.` mapping to the main charmap, removing Campaign-extension unmapped-character warnings without changing ROM bytes.
- Simplified assembly/linking around pinned official RGBDS 1.0.3 prebuilt tools while retaining the small legacy `rgbgfx` compatibility source required for byte-identical graphics generation.
- Added post-completion release/refinement verification and runtime-regression documentation.
- Verified a true clean build from regenerated graphics: zero warnings and the canonical SHA-256. The legacy-compatible `rgbgfx` source is retained because modern `rgbgfx` changes historical tile bytes.
- Re-ran the SRAM/save/startup/suspend/map-name regression family against the retail reference ROM; all checks pass after updating two stale verifier assumptions to the completed ownership model.
- Consolidated active documentation around the completed project state and subsystem-specific technical references.

## Remaining optional research

### 1. Structural binary formats

The former `data/remaining/` staging area is removed. The active tree has no generic `.dat`, `.sound`, `.gfx`, or `.bin` assets: small neutral structures are emitted directly in RGBDS source, while proven external resources use format-specific extensions. Future research should replace neutral `db` blocks with typed records/macros only when a consumer or parser proves the format.

See `docs/architecture/remaining_asset_catalog.md`.

### 2. Rare presentation-only SFX IDs

The common UI/action SFX vocabulary is now semantic and documented in `docs/audio/sfx_semantics.md`. A small set of specialized presentation-sequence IDs remains numeric because current evidence proves only the choreography that invokes them, not a durable standalone effect identity. Rename those only after unique caller semantics or runtime listening establishes a stable name.

See `docs/audio/music_command_format.md` for the completed music VM and `docs/audio/sfx_semantics.md` for the proven SFX layer.

### 3. Neutral internal runtime labels

The old `RemainingCode_*` namespace has been retired. In `engine/remaining_rom.asm`, 604 purely internal control-flow targets are RGBDS local labels and 257 potential indirect/cross-scope entry anchors remain as neutral `RuntimeEntry_BankXX_YYYY` symbols. None is consumed outside that file. Further renaming should happen only when inputs/outputs/callers prove a durable semantic contract; neutral address-derived entry anchors are preferable to speculative gameplay terminology.

### 4. Data structure macros

Where repeated resource records are already proven, replace raw `db`/binary slices with typed macros and named fields. Maintain byte-exact assertions and avoid widening records merely for readability.

### 5. Runtime smoke testing

Run the checklist in `docs/testing/runtime_regression.md` on a CGB-accurate emulator and, when practical, hardware. Particularly valuable cases are late-game save loading, Campaign transitions, Map Menu send/receive flows, map editor save/load, Unit List promotion/delete, and Mobile/infrared error paths.

## Release gates

A refined release should satisfy all of the following:

- `baserom.gbc` is present and passes the exact Japanese retail ROM identity check.
- `make` succeeds with RGBDS 1.0.3.
- Build emits no assembler warnings from project source.
- `make check-toolchain` confirms the expected RGBDS/graphics toolchain.
- `make check-release` passes as the aggregate release gate.
- The component checks `check-rgbds-1-syntax`, `check-completion`, `check-refinement`, and `check-music-source` remain individually green.
- Output SHA-256 remains `e5331609ded95b354e95af9f453e90531cbfc446f5c51117ba2ed985a80cb059` unless a deliberate custom-English change is being made.
- Release archive contains no ROM, save, object/dependency, linker map/symbol, or downloaded tool binaries.

## Structural-asset migration milestone

The staging model is now retired. `data/remaining/` went from 136 backing binaries (~232 KiB), to 90 files / 64,088 bytes after the first classification sweep, and finally to **zero files**. The final 90 backings contained only 45,207 referenced bytes; those bytes are now represented by 101 exactly-sized subsystem assets totaling 44,483 bytes plus 724 bytes of inline `db`/`ds` source. No stale backing bytes remain. See `docs/architecture/remaining_asset_migration.md`.
