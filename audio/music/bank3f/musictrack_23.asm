; Music track $23 (Bank $3F)
; Auto-promoted from the byte-exact channel streams using the documented music VM.

SECTION "MusicTrack_23_Ch2", ROMX[$7017], BANK[$3F]
MusicTrack_23_Ch2::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_channel_preset $10
    music_alternate_output_level $30
    music_loop_point
    music_octave 3
    music_enable_alternate_output
    music_note MUSIC_NOTE_C, 3
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 4
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 1
    music_note MUSIC_NOTE_CS, 15
    music_rest 1
    music_note MUSIC_NOTE_CS, 3
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 5
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 2
    music_note MUSIC_NOTE_DS, 14
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_note MUSIC_NOTE_C, 3
    music_rest 3
    music_note MUSIC_NOTE_C, 3
    music_rest 5
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 1
    music_note MUSIC_NOTE_CS, 3
    music_tie
    music_note MUSIC_NOTE_CS, 11
    music_rest 2
    music_note MUSIC_NOTE_CS, 3
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 5
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 1
    music_note MUSIC_NOTE_DS, 15
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_note MUSIC_NOTE_E, 3
    music_rest 3
    music_note MUSIC_NOTE_E, 3
    music_rest 5
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 1
    music_note MUSIC_NOTE_DS, 14
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_note MUSIC_NOTE_FS, 4
    music_rest 2
    music_note MUSIC_NOTE_FS, 4
    music_rest 4
    music_note MUSIC_NOTE_FS, 4
    music_note MUSIC_NOTE_FS, 1
    music_note MUSIC_NOTE_DS, 15
    music_rest 1
    music_note MUSIC_NOTE_DS, 3
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 5
    music_note MUSIC_NOTE_E, 3
    music_note MUSIC_NOTE_E, 2
    music_note MUSIC_NOTE_DS, 14
    music_rest 1
    music_note MUSIC_NOTE_DS, 4
    music_note MUSIC_NOTE_FS, 3
    music_rest 3
    music_note MUSIC_NOTE_FS, 3
    music_rest 5
    music_note MUSIC_NOTE_FS, 4
    music_note MUSIC_NOTE_FS, 1
    music_note MUSIC_NOTE_DS, 9
    music_tie
    music_note MUSIC_NOTE_DS, 5
    music_rest 2
    music_note MUSIC_NOTE_DS, 3
    music_loop
    assert @ == $7071

SECTION "MusicTrack_23_Ch1", ROMX[$7071], BANK[$3F]
MusicTrack_23_Ch1::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_alternate_output_level $30
    music_channel_preset $10
    music_loop_point
    music_octave 2
    music_enable_alternate_output
    music_note MUSIC_NOTE_G, 4
    music_rest 2
    music_note MUSIC_NOTE_G, 4
    music_rest 4
    music_note MUSIC_NOTE_G, 4
    music_note MUSIC_NOTE_G, 1
    music_note MUSIC_NOTE_GS, 15
    music_rest 1
    music_note MUSIC_NOTE_GS, 3
    music_note MUSIC_NOTE_G, 4
    music_rest 2
    music_note MUSIC_NOTE_G, 4
    music_rest 5
    music_note MUSIC_NOTE_G, 3
    music_note MUSIC_NOTE_G, 2
    music_note MUSIC_NOTE_AS, 14
    music_rest 1
    music_note MUSIC_NOTE_AS, 4
    music_note MUSIC_NOTE_G, 3
    music_rest 3
    music_note MUSIC_NOTE_G, 3
    music_rest 5
    music_note MUSIC_NOTE_G, 4
    music_note MUSIC_NOTE_G, 1
    music_note MUSIC_NOTE_GS, 3
    music_tie
    music_note MUSIC_NOTE_GS, 11
    music_rest 2
    music_note MUSIC_NOTE_GS, 3
    music_note MUSIC_NOTE_G, 4
    music_rest 2
    music_note MUSIC_NOTE_G, 4
    music_rest 5
    music_note MUSIC_NOTE_G, 3
    music_note MUSIC_NOTE_G, 1
    music_note MUSIC_NOTE_AS, 15
    music_rest 1
    music_note MUSIC_NOTE_AS, 4
    music_octave_up
    music_note MUSIC_NOTE_C, 3
    music_rest 3
    music_note MUSIC_NOTE_C, 3
    music_rest 5
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 1
    music_octave_down
    music_note MUSIC_NOTE_AS, 14
    music_rest 1
    music_note MUSIC_NOTE_AS, 4
    music_octave_up
    music_note MUSIC_NOTE_CS, 4
    music_rest 2
    music_note MUSIC_NOTE_CS, 4
    music_rest 4
    music_note MUSIC_NOTE_CS, 4
    music_note MUSIC_NOTE_CS, 1
    music_octave_down
    music_note MUSIC_NOTE_AS, 15
    music_rest 1
    music_note MUSIC_NOTE_AS, 3
    music_octave_up
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 5
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 2
    music_octave_down
    music_note MUSIC_NOTE_AS, 14
    music_rest 1
    music_note MUSIC_NOTE_AS, 4
    music_octave_up
    music_note MUSIC_NOTE_CS, 3
    music_rest 3
    music_note MUSIC_NOTE_CS, 3
    music_rest 5
    music_note MUSIC_NOTE_CS, 4
    music_note MUSIC_NOTE_CS, 1
    music_octave_down
    music_note MUSIC_NOTE_AS, 9
    music_tie
    music_note MUSIC_NOTE_AS, 5
    music_rest 2
    music_note MUSIC_NOTE_AS, 3
    music_loop
    assert @ == $70D3

SECTION "MusicTrack_23_Ch3", ROMX[$70D3], BANK[$3F]
MusicTrack_23_Ch3::
    music_duration_multiplier $01
    music_channel_routing $11
    music_primary_output_level $20
    music_alternate_output_level $60
    music_wave_pattern $08
    music_modulation_selector $03
    music_modulation_period $14
    music_octave 2
    music_enable_alternate_output
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 4
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 1
    music_note MUSIC_NOTE_C, 15
    music_rest 1
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 5
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 2
    music_note MUSIC_NOTE_C, 14
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 3
    music_rest 3
    music_note MUSIC_NOTE_C, 3
    music_rest 5
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 1
    music_note MUSIC_NOTE_C, 3
    music_tie
    music_note MUSIC_NOTE_C, 11
    music_rest 2
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 5
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 1
    music_note MUSIC_NOTE_C, 15
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 3
    music_rest 3
    music_note MUSIC_NOTE_C, 3
    music_rest 5
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 1
    music_note MUSIC_NOTE_C, 14
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 4
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 1
    music_note MUSIC_NOTE_C, 15
    music_rest 1
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 5
    music_note MUSIC_NOTE_C, 3
    music_note MUSIC_NOTE_C, 2
    music_note MUSIC_NOTE_C, 14
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 3
    music_rest 3
    music_note MUSIC_NOTE_C, 3
    music_rest 5
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_C, 1
    music_note MUSIC_NOTE_C, 9
    music_tie
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 3
    music_loop
    assert @ == $7130

SECTION "MusicTrack_23_Ch4", ROMX[$7130], BANK[$3F]
MusicTrack_23_Ch4::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_octave 1
    music_loop_point
    music_enable_alternate_output
    music_note MUSIC_NOTE_E, 3
    music_rest 11
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_note MUSIC_NOTE_E, 3
    music_rest 12
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_note MUSIC_NOTE_E, 3
    music_rest 11
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_E, 3
    music_tie
    music_rest 16
    music_note MUSIC_NOTE_E, 3
    music_rest 12
    music_note MUSIC_NOTE_E, 3
    music_rest 1
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_rest 1
    music_note MUSIC_NOTE_E, 3
    music_rest 11
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_note MUSIC_NOTE_E, 3
    music_rest 3
    music_rest 8
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_note MUSIC_NOTE_E, 3
    music_rest 12
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_E, 3
    music_rest 16
    music_note MUSIC_NOTE_E, 3
    music_rest 11
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_E, 3
    music_rest 6
    music_rest 10
    music_loop
    assert @ == $716E

