# Bank $14 text-input redraw runtime

`TextInput_RedrawCurrentValue` at `$14:$5245-$52B5` is the retail redraw path
for the non-map text-entry modes. It preserves and temporarily selects the
VBlank FIFO source bank, queues the cursor-decoration strips, and renders the
current `wTextInputBuffer` value.

Mode 2 is the Map Editor name path. At `$524A` it branches directly to the
custom `TextInput_MapNameRedrawHook` at `$52B6`, preserving the project's
nine-character map-name extension. The non-map path retains the retail jump to
the one-byte return stub now explicitly source-owned as
`TextInput_RedrawReturn` at `$531E`.

The four custom nine-character helpers in `engine/map/map_name_9char.asm` now
call `TextInput_RedrawCurrentValue` symbolically instead of using raw
`$14:$5245` farcalls.
