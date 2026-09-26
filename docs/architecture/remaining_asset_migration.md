# Structural asset migration

The former `data/remaining/` staging model has been retired completely.

All formerly staged bytes are now either:

- RGBDS instructions/data directly in source (`db`, `dw`, `ds`, or mnemonics), or
- format-specific assets such as `.2bpp`, `.tilemap`, `.attrmap`, `.pal`, `.sfx`, and other proven formats.

Generic `.dat`, `.sound`, `.gfx`, and `.bin` assets are not used by the active tree. Duplicate music/SFX driver images are generated from mnemonic assembly under `audio/driver_copies/` rather than stored as executable binary blobs.

The empty `structural_asset_manifest.tsv` is retained only as a compatibility breadcrumb for older documentation links; there are no active generic structural assets to enumerate.
