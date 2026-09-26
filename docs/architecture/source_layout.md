# Repository layout

The project now uses a subsystem-oriented layout similar in spirit to pret disassemblies. The goal is to make ownership obvious from the path without changing ROM semantics.

## Top-level structure

- `engine/` — executable game/runtime logic, grouped by subsystem.
  - `engine/home/` — ROM0/shared fixed-bank runtime.
  - `engine/map/` — map runtime, editor, menus, and Bank $0B map/action helpers.
  - `engine/map/ai/` — map-control and AI runtime.
  - `engine/unit/` — unit actions, lists, status, transport, and setup.
  - `engine/battle/` — battle presentation/combat runtime.
  - `engine/campaign/` — Campaign controllers/statistics runtime.
  - `engine/mobile/` — Mobile Adapter protocol/driver runtime.
  - `engine/network/` — Network profile/persistent/Shift-JIS bridge runtime.
  - `engine/versus/` — Versus setup and selection runtime.
  - `engine/ui/` — shared/front-end UI controllers.
- `data/` — symbolic data/text/resource declarations.
  - `data/maps/` — map record banks and pointer tables.
  - `data/campaign/` — Campaign briefing pointer/text/relocation data.
  - `data/gfx/` — assembly declarations for graphics assets.
- `audio/` — music and SFX driver/data assembly.
- `gfx/` — graphics binaries, PNG sources/previews, palettes, tilemaps, and related assets.
- `constants/` — hardware and game constants.
- `macros/` — shared RGBDS macros.
- `charmaps/` — game text encodings.
- `docs/<subsystem>/` — subsystem documentation.
- `tools/` — verification/conversion tooling and vendored build dependencies.
- `symbols.asm` — project-wide address symbols/RAM contracts retained as a root build unit.

## Layout rules

The former flat `source/` tree was moved by semantic ownership while preserving each filename. The former flat `include/` tree was split into `constants/`, `macros/`, and `charmaps/`. Makefile object order is preserved; only object paths changed.

No gameplay routine/data body was deliberately rewritten. Assembly changes required by the move are limited to `INCLUDE` path updates. A few source comments that named old file paths were updated to their new locations.

`tools/verify_layout_cleanup_segment361.py` guards the new layout by checking:

- every Makefile object maps to exactly one assembly module;
- every assembly `INCLUDE` resolves;
- removed flat `source/` and `include/` trees do not reappear;
- active tooling does not depend on old paths;
- temporary investigation outputs remain outside the maintained repository tree;
- documentation remains grouped by subsystem; and
- `README.md` and `ROADMAP.md` describe only the maintained project state.
