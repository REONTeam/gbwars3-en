# Battle unit graphics

Normal battle sprites are descriptor-defined complete sprites. `per_unit/*.png` is the primary editable/reference form for unit types 1-51; each unit uses one neutral four-shade indexed PNG because side coloration comes from CGB palettes.

The six exact side palettes live under `palettes/` (`ground`, `air`, and `sea`, each for Red Star and White Moon). `ground.png`, `air.png`, `sea.png`, and `special.png` are neutral human-facing atlases, while `source_tiles/` preserves physical ROM ordering where needed for exact reconstruction.

The per-unit extraction follows `BattleUnitSpriteDescriptors` exactly. Normal-unit descriptor slices are contiguous after one shared blank tile. The special family is split into one shared blank tile, five descriptor-defined three-tile slices, and four neutral three-tile interstitial slices whose higher-level animation/effect roles are intentionally left conservative. See `per_unit/special_frame_manifest.csv` and `per_unit/SPECIAL_FRAMES.md`.
