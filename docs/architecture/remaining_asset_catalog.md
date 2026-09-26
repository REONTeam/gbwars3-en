# Remaining asset catalog

There is no generic remaining-asset catalog anymore.

The project has no `data/remaining/` directory and no active `.dat`, `.sound`, `.gfx`, or generic `.bin` assets. Known graphics use format-specific representations (`.2bpp`, `.tilemap`, `.attrmap`, `.pal`), music/SFX streams are source where their bytecode is understood, and unresolved small structural records are emitted directly from RGBDS source.

Future format research should promote those inline structural records to typed macros or dedicated format-specific assets only when the consumer establishes a stable format.
