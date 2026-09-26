# Map Menu saved-data continuation prompt

the project separates Bank `$13:$54C0-$5540` from the adjacent `$5400` presentation routine and the translated string block at `$5541`.

## Proven contract

- Bank `$0F:$409F` is the sole whole-ROM farcall to `$13:$54C0`.
- `$54C0` temporarily selects WRAM bank 4, calls the existing `$5400` presentation routine, and enters a joypad-driven two-choice loop.
- The routine returns a small status value in `A`; the Bank `$0F` caller immediately compares it with `1` and takes its accepted path only for that value.
- The screen drawn at `$5400` uses the existing `suspend_continue_1/2` strings: the player is asked whether to continue from the previous save data, with a warning that choosing NO deletes that data.

The routine is therefore named `MapMenu_RunContinueFromSavePrompt`. This does **not** provide evidence that the earlier `$4F40` slot-selection branches have the same semantics; the project explicitly keeps those families separate.

## Ownership

`$13:$54C0-$5540` is 129 retail bytes, SHA-1 `3d26d480249144092ed60202fe448efe98d5c9c5`. It ends exactly before the existing translated `MapMenu_Strings` owner at `$5541`.
