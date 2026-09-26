# Bank $15 save-prompt runtime

Bank `$15:$5D6F-$5EDD` is split around the two existing localized Main Menu
save strings rather than modeled as one anonymous block.

## Owned code/data

- `$5D6F-$5DB6` — `MapSave_SetupPromptScreen`: resets the display/sprite state,
  loads the shared menu graphics, opens the framed question window, draws
  `MainMenu_SavePrompt`, initializes the two-choice state, and highlights the
  second choice.
- `$5DC2-$5E37` — `MainMenu_RunSavePrompt`: blocking A/B/Left/Right controller
  using WRAM bank 4 for the shared choice byte at `$DC69`.
- `$5E38-$5EB9` — `MapSave_ShowSavedConfirmation`: clears the central prompt
  rectangle in both VRAM banks, draws `MainMenu_SaveConfirmation`, services
  animation/sprites, and waits for A or B.
- `$5EBA-$5EBE` — the five zero bytes queued by that confirmation helper through
  `VBlankFIFO_Queue` for both VRAM banks.
- `$5ECA-$5EDD` — `MapSave_WriteModeSlot`: selects SRAM slot 4 when
  `wActiveGameMode == 3`, otherwise slot 5, then uses the existing map-SRAM
  serialize/checksum path.

The localized text islands remain independent owners at `$5DB7-$5DC1` and
`$5EBF-$5EC9` in `engine/ui/main_menu.asm`.

## Integration

`MapSave_RunEditorPresentation` now calls the setup, writer, and confirmation
helpers symbolically. `MapSRAM_Internal_5BAD` retains a compatibility alias, but
its public role is exported as `MapSRAM_SaveActiveMapToSlot`.

## Verification

`tools/verify_map_save_prompt_runtime_bank15.py` checks 345 retail-identical
bytes across the three new source spans and confirms that the Map Editor SAVE
flow no longer contains raw calls to `$5D6F`, `$5E38`, or `$5ECA`.
