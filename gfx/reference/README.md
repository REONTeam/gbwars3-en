# Graphics reference material

This tree contains graphics material retained for comparison, provenance, and visual verification, but not used directly as ROM build input.

The directory structure mirrors the active `gfx/` subsystem layout where practical. Historical `.orig.*` snapshots live here instead of beside active assets. Generated ROM-extraction output from `tools/gfx/convert.sh` is written to `gfx/reference/extracted/`.

Do not point new `INCBIN` statements at this directory unless a reference asset is deliberately promoted into an authoritative build asset first.
