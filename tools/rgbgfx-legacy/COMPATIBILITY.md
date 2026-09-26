# Legacy rgbgfx compatibility copy

This directory contains the user-supplied legacy `rgbgfx` source, patched only so it can be built and used with the current disassembly Makefile on modern systems.

Compatibility changes:

- `png_set_gray_1_2_4_to_8` -> `png_set_expand_gray_1_2_4_to_8` for modern libpng.
- `png_set_dither` -> `png_set_quantize` for modern libpng.
- Removed direct access to libpng's now-opaque `png_info::num_text`; text metadata is read without mutating libpng internals.
- Build with `-fcommon` to preserve the source's original tentative-global behavior on modern GCC/Clang.
- Accept `--trim-end N` as an alias for this version's historical `-x N` option, matching the project's existing Makefile recipes.

Build with:

    make legacy-rgbgfx

Then build the project with:

    make RGBGFX=tools/rgbgfx-legacy/rgbgfx

The main project still requires compatible `rgbasm`, `rgblink`, and `rgbfix` executables plus `baserom.gbc` for a complete ROM build.
