# Runtime regression checklist

The automated suite proves byte identity and many data-flow contracts, but a final release should also receive a short CGB runtime smoke test. This checklist is intentionally behavior-focused so it can be used in an emulator or on hardware without special instrumentation.

## Boot and persistent data

- Cold boot reaches the title/main menu without graphical corruption.
- Boot with a valid late-game 128 KiB save and confirm the file/campaign state is recognized.
- Enter and leave configuration/name screens; confirm settings persist after reset.
- Exercise save, overwrite, cancel, and reload paths from a normal map.
- Verify suspend/resume and the saved-session preview.

## Map and battle

- Start one standard map and one Campaign map.
- Move, attack, capture, supply, load/unload, and end a turn.
- Open Unit Status and Unit List from multiple unit types.
- Exercise Unit List delete and promotion flows where available.
- Confirm battle presentation, HP changes, result transition, and map return.
- Verify the nine-character map-name path by loading/editing a map whose ninth-character sidecar is nonzero.

## Map Menu and editor

- Browse all ten map slots with D-pad wrapping and paging.
- Open/edit a valid saved map and return cleanly.
- Delete/copy a slot and confirm slot-present metadata updates.
- Enter Map Editor ARRANGE terrain/unit modes and verify cursor/highlight rendering.
- Save an edited map, reload it, and confirm terrain/unit placement is unchanged.

## Infrared / transfer UI

- Enter send and receive map flows far enough to exercise setup/cancel paths.
- Confirm transfer menus return safely when no peer is present.
- Confirm local/infrared Versus style selection redraws correctly after cancellation.

## Mobile / Network UI

- Open the Mobile Menu and traverse available profile/message/menu screens.
- Exercise cancellation/error paths with no Mobile Adapter connection.
- Confirm the session timer and Mobile-specific interrupt presentation do not disturb ordinary audio/display operation after returning.

## Campaign

- Start Campaign map 00 and advance through the expanded English briefing.
- Confirm map 01 and map 02 relocated English pre/result messages display without truncation.
- Open at least one later Campaign briefing retained as Japanese plaintext and confirm the relocated Bank `$34` message renders/advances normally.
- Complete or load into a late Campaign state and inspect result/medal/statistics screens.

## Release evidence

Record emulator/core/version, save used, and any deviations. A clean smoke run supplements—but does not replace—the byte-exact standalone build and automated source verifiers.
