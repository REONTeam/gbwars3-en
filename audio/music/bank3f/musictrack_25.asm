; Music track $25 (Bank $3F)
; Auto-promoted from the byte-exact channel streams using the documented music VM.

SECTION "MusicTrack_25_Ch2", ROMX[$72E6], BANK[$3F]
MusicTrack_25_Ch2::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_channel_preset $0e
    music_alternate_output_level $30
    music_loop_point
    music_octave 4
    music_enable_alternate_output
    music_note MUSIC_NOTE_F, 4
    music_rest 1
    music_note MUSIC_NOTE_F, 3
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_rest 1
    music_note MUSIC_NOTE_G, 4
    music_rest 2
    music_octave_up
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 3
    music_octave_down
    music_note MUSIC_NOTE_B, 3
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_A, 4
    music_note MUSIC_NOTE_A, 4
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_rest 1
    music_note MUSIC_NOTE_G, 3
    music_rest 3
    music_note MUSIC_NOTE_F, 4
    music_rest 1
    music_note MUSIC_NOTE_F, 4
    music_rest 2
    music_note MUSIC_NOTE_G, 4
    music_rest 1
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_octave_up
    music_note MUSIC_NOTE_C, 3
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_rest 2
    music_octave_down
    music_note MUSIC_NOTE_B, 4
    music_note MUSIC_NOTE_B, 4
    music_rest 3
    music_note MUSIC_NOTE_A, 4
    music_rest 1
    music_note MUSIC_NOTE_A, 3
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_rest 1
    music_note MUSIC_NOTE_G, 4
    music_rest 2
    music_note MUSIC_NOTE_F, 4
    music_rest 1
    music_note MUSIC_NOTE_F, 4
    music_rest 3
    music_note MUSIC_NOTE_G, 3
    music_rest 1
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_octave_up
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 4
    music_rest 3
    music_octave_down
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 3
    music_rest 3
    music_note MUSIC_NOTE_A, 4
    music_rest 1
    music_note MUSIC_NOTE_A, 4
    music_rest 2
    music_note MUSIC_NOTE_G, 4
    music_rest 1
    music_note MUSIC_NOTE_G, 3
    music_tie
    music_note MUSIC_NOTE_G, 1
    music_rest 3
    music_note MUSIC_NOTE_F, 3
    music_rest 1
    music_note MUSIC_NOTE_F, 4
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_octave_up
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 3
    music_rest 3
    music_octave_down
    music_note MUSIC_NOTE_B, 4
    music_rest 1
    music_note MUSIC_NOTE_B, 4
    music_rest 2
    music_note MUSIC_NOTE_A, 4
    music_rest 1
    music_note MUSIC_NOTE_A, 4
    music_rest 3
    music_note MUSIC_NOTE_G, 3
    music_rest 1
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_loop
    assert @ == $735B

SECTION "MusicTrack_25_Ch1", ROMX[$735B], BANK[$3F]
MusicTrack_25_Ch1::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_channel_preset $0e
    music_loop_point
    music_octave 3
    music_disable_alternate_output
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 3
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 7
    music_loop
    assert @ == $738B

SECTION "MusicTrack_25_Ch3", ROMX[$738B], BANK[$3F]
MusicTrack_25_Ch3::
    music_duration_multiplier $01
    music_channel_routing $11
    music_primary_output_level $20
    music_wave_pattern $11
    music_modulation_selector $03
    music_modulation_period $14
    music_octave 2
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 3
    music_tie
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 3
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 7
    music_loop
    assert @ == $73BD

SECTION "MusicTrack_25_Ch4", ROMX[$73BD], BANK[$3F]
MusicTrack_25_Ch4::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_octave 1
    music_loop_point
    music_rest 16
    music_loop
    assert @ == $73C7

