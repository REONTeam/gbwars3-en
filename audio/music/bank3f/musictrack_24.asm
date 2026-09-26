; Music track $24 (Bank $3F)
; Auto-promoted from the byte-exact channel streams using the documented music VM.

SECTION "MusicTrack_24_Ch2", ROMX[$716E], BANK[$3F]
MusicTrack_24_Ch2::
    music_duration_multiplier $01
    music_channel_routing $11
    music_alternate_output_level $30
    music_channel_preset $19
    music_loop_point
    music_octave 4
    music_enable_alternate_output
    music_note MUSIC_NOTE_GS, 16
    music_tie
    music_note MUSIC_NOTE_GS, 16
    music_tie
    music_note MUSIC_NOTE_GS, 13
    music_rest 1
    music_note MUSIC_NOTE_GS, 3
    music_rest 7
    music_note MUSIC_NOTE_GS, 4
    music_rest 1
    music_note MUSIC_NOTE_GS, 3
    music_rest 3
    music_note MUSIC_NOTE_GS, 4
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_rest 2
    music_note MUSIC_NOTE_GS, 4
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_rest 3
    music_note MUSIC_NOTE_A, 3
    music_rest 1
    music_note MUSIC_NOTE_A, 4
    music_rest 1
    music_rest 2
    music_note MUSIC_NOTE_GS, 4
    music_note MUSIC_NOTE_GS, 4
    music_rest 14
    music_note MUSIC_NOTE_FS, 16
    music_tie
    music_note MUSIC_NOTE_FS, 16
    music_tie
    music_note MUSIC_NOTE_FS, 13
    music_rest 1
    music_note MUSIC_NOTE_FS, 4
    music_rest 6
    music_note MUSIC_NOTE_GS, 16
    music_tie
    music_note MUSIC_NOTE_GS, 3
    music_tie
    music_note MUSIC_NOTE_GS, 16
    music_tie
    music_note MUSIC_NOTE_GS, 10
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_rest 6
    music_note MUSIC_NOTE_GS, 4
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_rest 2
    music_note MUSIC_NOTE_GS, 4
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_rest 3
    music_note MUSIC_NOTE_B, 3
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_A, 4
    music_note MUSIC_NOTE_A, 4
    music_rest 3
    music_note MUSIC_NOTE_GS, 4
    music_rest 1
    music_note MUSIC_NOTE_GS, 3
    music_rest 9
    music_rest 5
    music_note MUSIC_NOTE_FS, 16
    music_tie
    music_note MUSIC_NOTE_FS, 16
    music_tie
    music_note MUSIC_NOTE_FS, 13
    music_rest 1
    music_note MUSIC_NOTE_FS, 4
    music_rest 6
    music_disable_alternate_output
    music_loop
    assert @ == $71C5

SECTION "MusicTrack_24_Ch1", ROMX[$71C5], BANK[$3F]
MusicTrack_24_Ch1::
    music_duration_multiplier $01
    music_channel_routing $11
    music_alternate_output_level $30
    music_channel_preset $19
    music_loop_point
    music_octave 4
    music_enable_alternate_output
    music_note MUSIC_NOTE_E, 16
    music_tie
    music_note MUSIC_NOTE_E, 16
    music_tie
    music_note MUSIC_NOTE_E, 13
    music_rest 1
    music_note MUSIC_NOTE_E, 3
    music_rest 7
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 3
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_FS, 3
    music_rest 1
    music_note MUSIC_NOTE_FS, 4
    music_rest 1
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 4
    music_rest 14
    music_note MUSIC_NOTE_D, 16
    music_tie
    music_note MUSIC_NOTE_D, 16
    music_tie
    music_note MUSIC_NOTE_D, 13
    music_rest 1
    music_note MUSIC_NOTE_D, 4
    music_rest 6
    music_note MUSIC_NOTE_E, 16
    music_tie
    music_note MUSIC_NOTE_E, 3
    music_tie
    music_note MUSIC_NOTE_E, 16
    music_tie
    music_note MUSIC_NOTE_E, 10
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 6
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_GS, 3
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_rest 3
    music_note MUSIC_NOTE_FS, 4
    music_note MUSIC_NOTE_FS, 4
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 3
    music_rest 9
    music_rest 5
    music_note MUSIC_NOTE_D, 16
    music_tie
    music_note MUSIC_NOTE_D, 16
    music_tie
    music_note MUSIC_NOTE_D, 13
    music_rest 1
    music_note MUSIC_NOTE_D, 4
    music_rest 6
    music_loop
    assert @ == $721B

SECTION "MusicTrack_24_Ch3", ROMX[$721B], BANK[$3F]
MusicTrack_24_Ch3::
    music_duration_multiplier $01
    music_channel_routing $11
    music_primary_output_level $20
    music_alternate_output_level $60
    music_wave_pattern $08
    music_modulation_selector $03
    music_modulation_period $14
    music_octave 1
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 3
    music_rest 3
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_B, 3
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 3
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_E, 3
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_rest 2
    music_note MUSIC_NOTE_B, 4
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 3
    music_rest 3
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_B, 3
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 3
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 3
    music_tie
    music_note MUSIC_NOTE_B, 1
    music_rest 3
    music_note MUSIC_NOTE_E, 3
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_B, 4
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 3
    music_rest 3
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_B, 3
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 3
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 1
    music_tie
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_E, 3
    music_rest 1
    music_note MUSIC_NOTE_E, 4
    music_rest 3
    music_note MUSIC_NOTE_B, 4
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_note MUSIC_NOTE_E, 3
    music_rest 3
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 2
    music_loop
    assert @ == $72AA

SECTION "MusicTrack_24_Ch4", ROMX[$72AA], BANK[$3F]
MusicTrack_24_Ch4::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_octave 1
    music_loop_point
    music_note MUSIC_NOTE_C, 4
    music_rest 16
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 16
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 16
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 16
    music_rest 3
    music_note MUSIC_NOTE_C, 3
    music_rest 6
    music_rest 13
    music_note MUSIC_NOTE_E, 4
    music_rest 16
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 8
    music_note MUSIC_NOTE_C, 3
    music_rest 8
    music_note MUSIC_NOTE_E, 4
    music_rest 16
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 15
    music_rest 4
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 16
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 16
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 16
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_rest 16
    music_rest 1
    music_note MUSIC_NOTE_C, 3
    music_rest 8
    music_note MUSIC_NOTE_C, 4
    music_rest 7
    music_note MUSIC_NOTE_E, 4
    music_rest 16
    music_rest 2
    music_loop
    assert @ == $72E6

