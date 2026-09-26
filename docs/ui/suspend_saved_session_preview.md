# Suspend saved-session preview

Bank `$15:$5F63-$5FC2` is owned by `SuspendResume_DrawSavedSessionPreview`.

The routine renders the metadata preview for suspend/resume slot 3. It reads the
saved game-mode byte from SRAM, selects the BEGINNER/CAMPAIGN/STANDARD label,
loads the mode-aware slot summary and commander preview, renders the map number
and the custom nine-character cached map name, then converts the stored
alternating-side phase counter to the displayed one-based day number.

## Corrected ownership model

Older source revisions modeled `$5F80`, `$5F97`, and `$5FBB` as independent
coordinate resources. Retail control flow proves that these bytes are operands
of `ld bc` instructions beginning immediately before each old section. Likewise,
the custom Bank `$15:$5F9F-$5FB3` map-name hook is executable code embedded in
the same routine, not an independent presentation owner.

The complete `$5F63-$5FC2` range is therefore source-owned as one mnemonic
routine. The custom-English layout remains intentional:

- mode value at `(3, 7)`;
- commander value at `(2, 5)`;
- map number at the established custom location;
- nine-character map name through `MapName9_DrawCache`;
- day value at `(5, 5)`.

`make check-suspend-saved-session-preview` verifies that every non-custom byte
still matches Japanese retail and that the former overlay sections no longer
exist.
