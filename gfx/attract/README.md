# Attract-mode scene graphics

The six attract scenes use 20x10 tilemaps with matching CGB attribute maps and a 256-tile (`$1000`-byte) signed-tile graphics window. The renderer selects VRAM bank 1 and offsets stored palette indices by +3, so the five descriptor palettes occupy BG palette slots 3-7.

Retail deliberately aliases several physical resource windows:

- Scene 0 is a logical view into already-owned Bank `$31` presentation resources.
- Scenes 1, 3, and 4 share Bank `$23`; their physical ownership is represented by format-specific `.tilemap`, `.attrmap`, `.2bpp`, and `.pal` assets under `resources_bank23/`.
- Scenes 2 and 5 share Bank `$24` in the same way under `resources_bank24/`.
- Campaign map-selection page 0 begins inside the scene-5 graphics window, matching the retail alias exactly.

`scene_N.*` files are logical views for inspection. The build-critical ownership is defined by `engine/ui/attract_scene_resources_bank23.asm` and `engine/ui/attract_scene_resources_bank24.asm`.
