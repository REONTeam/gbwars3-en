# Map surrender resolution prompt

Bank `$27:$7CB7-$7F16` is the complete late-map surrender confirmation and result-message path.

`MapSurrenderPrompt_Setup` at `$7CB7` rebuilds the modal screen, selects the Red Star or White Moon army prefix from `wMapSurrenderingSide` (`$DC6A`), prints the surrender/end-battle question, initializes the two-choice state at `$DC69`, and highlights the second choice by default.

`MapSurrenderPrompt_DrawOutcome` at `$7D5C` renders one of two outcome bodies. Choice `0` reports that the surrender was ignored and battle continues; a nonzero choice reports the surrender and resulting victory. The routine inserts side-specific Red Star/White Moon fragments into the common message body. The Japanese text resources from `$7D19-$7E5E` are represented directly through the main charmap rather than anonymous byte arrays.

`MapSurrenderPrompt_Run` at `$7E5F` is the connected controller formerly modeled as an opaque `db` block under the compatibility name `MapControl_PhaseResultDispatch`. It temporarily selects WRAM bank 4, records the surrendering side, fades into the prompt, services joypad/sprite/common UI animation each frame, updates the two-choice highlight, clears the choice marker from both VRAM banks, draws the selected outcome, waits for A, fades out, restores the caller WRAM bank, and returns the selected choice in A.

The complete `$7CB7-$7F16` path reproduces Japanese retail bytes exactly and does not change the custom-English ROM hash.
