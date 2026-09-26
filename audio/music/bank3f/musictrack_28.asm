; Music track $28 (Bank $3F)
; Auto-promoted from the byte-exact channel streams using the documented music VM.

SECTION "MusicTrack_28_Ch2", ROMX[$76D6], BANK[$3F]
MusicTrack_28_Ch2::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_channel_preset $10
    music_alternate_output_level $30
    music_loop_point
    music_octave 3
    music_enable_alternate_output
    music_note MUSIC_NOTE_E, 14
    music_rest 2
    music_note MUSIC_NOTE_E, 5
    music_rest 7
    music_note MUSIC_NOTE_F, 14
    music_rest 1
    music_note MUSIC_NOTE_F, 5
    music_rest 7
    music_note MUSIC_NOTE_G, 14
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 7
    music_note MUSIC_NOTE_A, 14
    music_rest 2
    music_note MUSIC_NOTE_A, 5
    music_rest 7
    music_note MUSIC_NOTE_AS, 14
    music_rest 1
    music_note MUSIC_NOTE_AS, 5
    music_rest 7
    music_octave_up
    music_note MUSIC_NOTE_C, 14
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 7
    music_note MUSIC_NOTE_D, 14
    music_rest 2
    music_note MUSIC_NOTE_D, 5
    music_rest 7
    music_note MUSIC_NOTE_E, 4
    music_tie
    music_note MUSIC_NOTE_E, 10
    music_rest 1
    music_note MUSIC_NOTE_E, 6
    music_rest 6
    music_loop
    assert @ == $7707

SECTION "MusicTrack_28_Ch1", ROMX[$7707], BANK[$3F]
MusicTrack_28_Ch1::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_alternate_output_level $30
    music_channel_preset $10
    music_loop_point
    music_octave 3
    music_note MUSIC_NOTE_C, 14
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 7
    music_note MUSIC_NOTE_D, 14
    music_rest 1
    music_note MUSIC_NOTE_D, 5
    music_rest 7
    music_note MUSIC_NOTE_E, 14
    music_rest 2
    music_note MUSIC_NOTE_E, 5
    music_rest 7
    music_note MUSIC_NOTE_F, 14
    music_rest 2
    music_note MUSIC_NOTE_F, 5
    music_rest 7
    music_note MUSIC_NOTE_G, 14
    music_rest 1
    music_note MUSIC_NOTE_G, 5
    music_rest 7
    music_note MUSIC_NOTE_A, 14
    music_rest 2
    music_note MUSIC_NOTE_A, 5
    music_rest 7
    music_note MUSIC_NOTE_AS, 14
    music_rest 2
    music_note MUSIC_NOTE_AS, 5
    music_rest 7
    music_octave_up
    music_note MUSIC_NOTE_C, 4
    music_tie
    music_note MUSIC_NOTE_C, 10
    music_rest 1
    music_note MUSIC_NOTE_C, 6
    music_rest 6
    music_loop
    assert @ == $7737

SECTION "MusicTrack_28_Ch3", ROMX[$7737], BANK[$3F]
MusicTrack_28_Ch3::
    music_duration_multiplier $01
    music_channel_routing $11
    music_primary_output_level $20
    music_alternate_output_level $60
    music_wave_pattern $08
    music_modulation_selector $03
    music_modulation_period $14
    music_octave 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 2
    music_tie
    music_note MUSIC_NOTE_G, 2
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_tie
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_rest 2
    music_loop
    assert @ == $778A

SECTION "MusicTrack_28_Ch4", ROMX[$778A], BANK[$3F]
MusicTrack_28_Ch4::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_octave 1
    music_loop_point
    music_rest 14
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_rest 9
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_rest 8
    music_note MUSIC_NOTE_E, 4
    music_rest 16
    music_rest 8
    music_note MUSIC_NOTE_E, 2
    music_tie
    music_note MUSIC_NOTE_E, 1
    music_rest 16
    music_rest 9
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_rest 8
    music_note MUSIC_NOTE_E, 4
    music_rest 16
    music_rest 8
    music_note MUSIC_NOTE_E, 3
    music_rest 15
    music_rest 10
    music_note MUSIC_NOTE_E, 3
    music_rest 10
    music_loop
    assert @ == $77AD

