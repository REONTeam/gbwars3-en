; Music track $26 (Bank $3F)
; Auto-promoted from the byte-exact channel streams using the documented music VM.

SECTION "MusicTrack_26_Ch2", ROMX[$73C7], BANK[$3F]
MusicTrack_26_Ch2::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_channel_preset $10
    music_alternate_output_level $30
    music_loop_point
    music_octave 4
    music_enable_alternate_output
    music_note MUSIC_NOTE_DS, 5
    music_rest 1
    music_note MUSIC_NOTE_DS, 5
    music_rest 9
    music_octave_down
    music_note MUSIC_NOTE_AS, 5
    music_rest 1
    music_note MUSIC_NOTE_AS, 4
    music_octave_up
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 13
    music_rest 1
    music_note MUSIC_NOTE_DS, 5
    music_rest 9
    music_note MUSIC_NOTE_DS, 5
    music_rest 1
    music_note MUSIC_NOTE_DS, 3
    music_tie
    music_note MUSIC_NOTE_DS, 1
    music_note MUSIC_NOTE_DS, 5
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_note MUSIC_NOTE_DS, 5
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_note MUSIC_NOTE_FS, 5
    music_rest 1
    music_note MUSIC_NOTE_FS, 5
    music_rest 9
    music_note MUSIC_NOTE_CS, 5
    music_rest 1
    music_note MUSIC_NOTE_CS, 4
    music_note MUSIC_NOTE_FS, 16
    music_tie
    music_note MUSIC_NOTE_FS, 16
    music_tie
    music_note MUSIC_NOTE_FS, 12
    music_rest 2
    music_note MUSIC_NOTE_FS, 2
    music_tie
    music_note MUSIC_NOTE_FS, 3
    music_rest 8
    music_note MUSIC_NOTE_FS, 5
    music_rest 2
    music_note MUSIC_NOTE_FS, 3
    music_note MUSIC_NOTE_FS, 5
    music_rest 2
    music_note MUSIC_NOTE_FS, 3
    music_note MUSIC_NOTE_FS, 5
    music_rest 2
    music_note MUSIC_NOTE_FS, 3
    music_note MUSIC_NOTE_F, 5
    music_rest 2
    music_note MUSIC_NOTE_F, 5
    music_rest 8
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 12
    music_tie
    music_note MUSIC_NOTE_F, 16
    music_tie
    music_note MUSIC_NOTE_F, 1
    music_rest 1
    music_note MUSIC_NOTE_F, 5
    music_rest 9
    music_note MUSIC_NOTE_F, 5
    music_rest 1
    music_note MUSIC_NOTE_F, 4
    music_note MUSIC_NOTE_F, 5
    music_rest 1
    music_note MUSIC_NOTE_F, 4
    music_note MUSIC_NOTE_F, 5
    music_rest 1
    music_note MUSIC_NOTE_F, 4
    music_note MUSIC_NOTE_GS, 5
    music_rest 1
    music_note MUSIC_NOTE_GS, 5
    music_rest 9
    music_note MUSIC_NOTE_DS, 5
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_note MUSIC_NOTE_GS, 7
    music_tie
    music_note MUSIC_NOTE_GS, 16
    music_tie
    music_note MUSIC_NOTE_GS, 16
    music_tie
    music_note MUSIC_NOTE_GS, 6
    music_rest 1
    music_note MUSIC_NOTE_GS, 5
    music_rest 9
    music_note MUSIC_NOTE_GS, 5
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_note MUSIC_NOTE_GS, 5
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_note MUSIC_NOTE_GS, 5
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_loop
    assert @ == $743F

SECTION "MusicTrack_26_Ch1", ROMX[$743F], BANK[$3F]
MusicTrack_26_Ch1::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_channel_preset $10
    music_loop_point
    music_octave 3
    music_enable_alternate_output
    music_note MUSIC_NOTE_AS, 5
    music_rest 1
    music_note MUSIC_NOTE_AS, 5
    music_rest 9
    music_note MUSIC_NOTE_F, 5
    music_rest 1
    music_note MUSIC_NOTE_F, 4
    music_note MUSIC_NOTE_AS, 16
    music_tie
    music_note MUSIC_NOTE_AS, 16
    music_tie
    music_note MUSIC_NOTE_AS, 13
    music_rest 1
    music_note MUSIC_NOTE_AS, 5
    music_rest 9
    music_note MUSIC_NOTE_AS, 5
    music_rest 1
    music_note MUSIC_NOTE_AS, 3
    music_tie
    music_note MUSIC_NOTE_AS, 1
    music_note MUSIC_NOTE_AS, 5
    music_rest 1
    music_note MUSIC_NOTE_AS, 4
    music_note MUSIC_NOTE_AS, 5
    music_rest 1
    music_note MUSIC_NOTE_AS, 4
    music_octave_up
    music_note MUSIC_NOTE_CS, 5
    music_rest 1
    music_note MUSIC_NOTE_CS, 5
    music_rest 9
    music_octave_down
    music_note MUSIC_NOTE_GS, 5
    music_rest 1
    music_note MUSIC_NOTE_GS, 4
    music_octave_up
    music_note MUSIC_NOTE_CS, 16
    music_tie
    music_note MUSIC_NOTE_CS, 16
    music_tie
    music_note MUSIC_NOTE_CS, 12
    music_rest 2
    music_note MUSIC_NOTE_CS, 2
    music_tie
    music_note MUSIC_NOTE_CS, 3
    music_rest 8
    music_note MUSIC_NOTE_CS, 5
    music_rest 2
    music_note MUSIC_NOTE_CS, 3
    music_note MUSIC_NOTE_CS, 5
    music_rest 2
    music_note MUSIC_NOTE_CS, 3
    music_note MUSIC_NOTE_CS, 5
    music_rest 2
    music_note MUSIC_NOTE_CS, 3
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 8
    music_octave_down
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 3
    music_octave_up
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 12
    music_tie
    music_note MUSIC_NOTE_C, 16
    music_tie
    music_note MUSIC_NOTE_C, 1
    music_rest 1
    music_note MUSIC_NOTE_C, 5
    music_rest 9
    music_note MUSIC_NOTE_C, 5
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 5
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 5
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_DS, 5
    music_rest 1
    music_note MUSIC_NOTE_DS, 5
    music_rest 9
    music_octave_down
    music_note MUSIC_NOTE_AS, 5
    music_rest 1
    music_note MUSIC_NOTE_AS, 4
    music_octave_up
    music_note MUSIC_NOTE_DS, 7
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 16
    music_tie
    music_note MUSIC_NOTE_DS, 6
    music_rest 1
    music_note MUSIC_NOTE_DS, 5
    music_rest 9
    music_note MUSIC_NOTE_DS, 5
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_note MUSIC_NOTE_DS, 5
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_note MUSIC_NOTE_DS, 5
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_loop
    assert @ == $74BA

SECTION "MusicTrack_26_Ch3", ROMX[$74BA], BANK[$3F]
MusicTrack_26_Ch3::
    music_duration_multiplier $01
    music_channel_routing $11
    music_primary_output_level $20
    music_wave_pattern $08
    music_modulation_selector $03
    music_modulation_period $14
    music_octave 1
    music_note MUSIC_NOTE_GS, 7
    music_rest 2
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_note MUSIC_NOTE_GS, 7
    music_rest 2
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_note MUSIC_NOTE_GS, 7
    music_rest 2
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_note MUSIC_NOTE_GS, 7
    music_rest 1
    music_note MUSIC_NOTE_GS, 1
    music_tie
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_note MUSIC_NOTE_GS, 7
    music_rest 1
    music_note MUSIC_NOTE_GS, 8
    music_rest 14
    music_note MUSIC_NOTE_GS, 7
    music_rest 1
    music_note MUSIC_NOTE_GS, 8
    music_rest 14
    music_note MUSIC_NOTE_GS, 7
    music_rest 1
    music_note MUSIC_NOTE_GS, 8
    music_rest 2
    music_rest 11
    music_note MUSIC_NOTE_GS, 8
    music_rest 1
    music_note MUSIC_NOTE_GS, 8
    music_rest 13
    music_note MUSIC_NOTE_GS, 8
    music_rest 1
    music_note MUSIC_NOTE_GS, 8
    music_rest 13
    music_note MUSIC_NOTE_GS, 8
    music_rest 1
    music_note MUSIC_NOTE_GS, 7
    music_rest 12
    music_rest 2
    music_note MUSIC_NOTE_GS, 8
    music_rest 1
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_note MUSIC_NOTE_GS, 8
    music_rest 1
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_note MUSIC_NOTE_GS, 8
    music_rest 1
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_note MUSIC_NOTE_GS, 7
    music_tie
    music_rest 2
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_note MUSIC_NOTE_GS, 7
    music_rest 2
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_note MUSIC_NOTE_GS, 7
    music_rest 2
    music_note MUSIC_NOTE_GS, 7
    music_rest 14
    music_loop
    assert @ == $750D

SECTION "MusicTrack_26_Ch4", ROMX[$750D], BANK[$3F]
MusicTrack_26_Ch4::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_octave 1
    music_loop_point
    music_note MUSIC_NOTE_E, 2
    music_rest 16
    music_rest 16
    music_rest 15
    music_note MUSIC_NOTE_D, 2
    music_rest 1
    music_note MUSIC_NOTE_D, 2
    music_rest 2
    music_note MUSIC_NOTE_E, 2
    music_rest 2
    music_note MUSIC_NOTE_E, 2
    music_rest 16
    music_rest 12
    music_note MUSIC_NOTE_E, 2
    music_rest 7
    music_rest 1
    music_note MUSIC_NOTE_D, 2
    music_rest 8
    music_note MUSIC_NOTE_D, 2
    music_rest 8
    music_note MUSIC_NOTE_E, 2
    music_rest 16
    music_rest 16
    music_rest 14
    music_note MUSIC_NOTE_D, 2
    music_rest 2
    music_note MUSIC_NOTE_D, 2
    music_rest 2
    music_note MUSIC_NOTE_E, 2
    music_rest 2
    music_note MUSIC_NOTE_E, 2
    music_rest 16
    music_rest 11
    music_note MUSIC_NOTE_E, 2
    music_rest 8
    music_note MUSIC_NOTE_D, 2
    music_rest 8
    music_note MUSIC_NOTE_D, 2
    music_rest 8
    music_note MUSIC_NOTE_E, 2
    music_rest 16
    music_rest 16
    music_rest 15
    music_note MUSIC_NOTE_D, 2
    music_rest 2
    music_note MUSIC_NOTE_D, 2
    music_rest 1
    music_note MUSIC_NOTE_E, 2
    music_tie
    music_rest 2
    music_note MUSIC_NOTE_E, 2
    music_rest 16
    music_rest 12
    music_note MUSIC_NOTE_E, 2
    music_rest 8
    music_note MUSIC_NOTE_D, 2
    music_rest 8
    music_note MUSIC_NOTE_D, 2
    music_rest 8
    music_note MUSIC_NOTE_E, 2
    music_rest 16
    music_rest 16
    music_rest 3
    music_rest 12
    music_note MUSIC_NOTE_D, 2
    music_rest 1
    music_note MUSIC_NOTE_D, 2
    music_rest 2
    music_note MUSIC_NOTE_E, 2
    music_rest 2
    music_note MUSIC_NOTE_E, 2
    music_rest 16
    music_rest 12
    music_note MUSIC_NOTE_E, 2
    music_rest 8
    music_note MUSIC_NOTE_D, 2
    music_rest 8
    music_note MUSIC_NOTE_D, 2
    music_rest 8
    music_loop
    assert @ == $7565

