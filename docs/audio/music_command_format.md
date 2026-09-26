# Music command format

Game Boy Wars 3 uses a compact four-channel music VM interpreted by `MusicDriver_ProcessCommand` in `audio/music_driver.asm`.

All active track streams are represented as RGBDS source. There are no raw `.music` channel assets and no numeric `music_cmd_xx` / `music_event` source macros remaining.

## Packed note events

Bytes below `$D0` are note/rest events:

- high nibble `0`: rest
- high nibble `1-$C`: chromatic `C` through `B`
- low nibble `0-$F`: duration unit `1-16`

The effective event duration is the packed duration multiplied by the current duration multiplier set by `$D0`.

The source macros are:

```asm
music_note MUSIC_NOTE_C, 4
music_note MUSIC_NOTE_FS, 8
music_rest 2
music_duration_multiplier $03
```

The pitch table order is `C, C#, D, D#, E, F, F#, G, G#, A, A#, B`; the driver's octave-frequency table advances by 12 entries per octave.

## Commands

| Opcode | Source macro | Operand | Behavior |
|---|---|---|---|
| `$D0` | `music_duration_multiplier` | byte | Multiplies packed event duration. |
| `$D1-$D6` | `music_octave 1-6` | none | Selects octave. |
| `$D7` | `music_octave_up` | none | Increments octave. |
| `$D8` | `music_octave_down` | none | Decrements octave. |
| `$D9` | `music_tie` | none | Next event reuses the active note without normal retrigger/envelope reset. |
| `$DA-$DB` | `music_end_channel` | none | Stops the current music channel. |
| `$DC` | `music_channel_routing` | byte | Updates the channel's NR51 routing bits. |
| `$DD` | `music_loop_point` | none | Saves the current stream position. |
| `$DE` | `music_loop` | none | Restores the saved stream position, forming the common indefinite loop. |
| `$DF` | `music_counted_loop_start` | byte | Pushes a counted-loop frame. |
| `$E0` | `music_counted_loop_repeat` | none | Repeats/pops the counted-loop frame. |
| `$E1` | `music_jump` | pointer | Jumps to another stream address. |
| `$E2` | `music_call` | pointer | Calls a stream phrase using the VM loop stack. |
| `$E3` | `music_return` | none | Returns from a stream phrase. |
| `$E4` | `music_frequency_offset` | byte | Sets signed frequency offset state. |
| `$E5` | `music_duty` | byte | Sets pulse duty bits. |
| `$E6` | `music_primary_output_level` | byte | Sets the primary tone output/envelope level source. |
| `$E7` | `music_wave_pattern` | byte | Selects the wave-channel waveform and requests reload. |
| `$E8` | `music_gate_length` | byte | Sets note gate scaling. |
| `$E9` | `music_output_level` | byte | Sets channel output level. |
| `$EA` | `music_modulation_selector` | byte | Sets current and initial modulation selector. |
| `$EB` | `music_modulation_period` | byte | Sets modulation period. |
| `$EC` | `music_pitch_transpose` | byte | Sets pitch transpose. |
| `$ED` | `music_add_pitch_transpose` | byte | Adds to pitch transpose. |
| `$EE` | `music_sweep` | byte | Sets sweep state. |
| `$EF` | `music_channel_effect` | byte | Pulse channels adjust output/envelope levels; noise adjusts clock-shift offset. |
| `$F0` | `music_channel_preset` | byte | Applies one of the driver's channel presets. |
| `$F1` | `music_alternate_output_level` | byte | Sets alternate output level and enables alternate-output state. |
| `$F2` | `music_enable_alternate_output` | none | Enables alternate-output state. |
| `$F3` | `music_disable_alternate_output` | none | Disables alternate-output state. |
| `$F4` | `music_request_snapshot` | none | Requests the driver's snapshot behavior. |
| `$F5` | `music_primary_envelope` | 3 bytes | Sets primary output, envelope, and envelope delay. |
| `$F6` | `music_alternate_envelope` | 3 bytes | Sets alternate output, envelope, and delay and enables alternate output. |
| `$F7-$FF` | `music_end_channel` | none | Stops the current channel. |

## Source organization

Tracks whose data lives in Banks `$03-$07` are in `audio/music_data_bank03.asm` through `audio/music_data_bank07.asm`.

Late tracks in Banks `$3E/$3F` are split into one source file per track under:

- `audio/music/bank3e/`
- `audio/music/bank3f/`

Duplicated `$4000-$580x` music-driver images are assembled from mnemonic source under `audio/driver_copies/`; no raw prefix/driver blobs remain.

## Verification

`make check-music-source` enforces:

- zero `.music` files;
- zero legacy numeric `music_event`, `music_cmd_xx`, or `music_end` source uses;
- semantic music macros present;
- all 19 late-track ASM files present;
- all 42 active track IDs / 165 channel entry labels represented in source;
- canonical ROM SHA-256 when a build is present.
