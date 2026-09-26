; Music track $22 (Bank $3F)
; Auto-promoted from the byte-exact channel streams using the documented music VM.

SECTION "MusicTrack_22_Ch2", ROMX[$6EF3], BANK[$3F]
MusicTrack_22_Ch2::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_channel_preset $10
    music_alternate_output_level $30
    music_loop_point
    music_octave 3
    music_note MUSIC_NOTE_C, 6
    music_rest 1
    music_note MUSIC_NOTE_C, 3
    music_rest 1
    music_note MUSIC_NOTE_CS, 6
    music_rest 1
    music_note MUSIC_NOTE_CS, 3
    music_rest 1
    music_note MUSIC_NOTE_D, 6
    music_rest 1
    music_note MUSIC_NOTE_D, 3
    music_rest 2
    music_note MUSIC_NOTE_DS, 5
    music_rest 2
    music_note MUSIC_NOTE_DS, 2
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 3
    music_rest 1
    music_note MUSIC_NOTE_CS, 6
    music_rest 1
    music_note MUSIC_NOTE_CS, 3
    music_rest 1
    music_note MUSIC_NOTE_D, 6
    music_rest 1
    music_note MUSIC_NOTE_D, 3
    music_rest 1
    music_note MUSIC_NOTE_DS, 6
    music_rest 1
    music_note MUSIC_NOTE_DS, 3
    music_rest 2
    music_note MUSIC_NOTE_C, 5
    music_rest 2
    music_note MUSIC_NOTE_C, 2
    music_tie
    music_rest 2
    music_note MUSIC_NOTE_CS, 5
    music_rest 2
    music_note MUSIC_NOTE_CS, 3
    music_rest 1
    music_note MUSIC_NOTE_D, 6
    music_rest 1
    music_note MUSIC_NOTE_D, 3
    music_rest 1
    music_note MUSIC_NOTE_DS, 6
    music_rest 1
    music_note MUSIC_NOTE_DS, 3
    music_rest 1
    music_note MUSIC_NOTE_C, 6
    music_rest 1
    music_note MUSIC_NOTE_C, 3
    music_rest 2
    music_note MUSIC_NOTE_CS, 5
    music_rest 2
    music_note MUSIC_NOTE_CS, 2
    music_rest 2
    music_note MUSIC_NOTE_D, 5
    music_rest 2
    music_note MUSIC_NOTE_D, 3
    music_rest 1
    music_note MUSIC_NOTE_DS, 6
    music_rest 1
    music_note MUSIC_NOTE_DS, 3
    music_rest 1
    music_note MUSIC_NOTE_C, 6
    music_rest 1
    music_note MUSIC_NOTE_C, 3
    music_rest 1
    music_note MUSIC_NOTE_CS, 6
    music_rest 1
    music_note MUSIC_NOTE_CS, 1
    music_tie
    music_note MUSIC_NOTE_CS, 2
    music_rest 2
    music_note MUSIC_NOTE_D, 5
    music_rest 2
    music_note MUSIC_NOTE_D, 2
    music_rest 2
    music_note MUSIC_NOTE_DS, 5
    music_rest 2
    music_note MUSIC_NOTE_DS, 3
    music_rest 1
    music_note MUSIC_NOTE_C, 6
    music_rest 1
    music_note MUSIC_NOTE_C, 3
    music_rest 1
    music_note MUSIC_NOTE_CS, 6
    music_rest 1
    music_note MUSIC_NOTE_CS, 3
    music_rest 1
    music_note MUSIC_NOTE_D, 6
    music_rest 1
    music_note MUSIC_NOTE_D, 3
    music_rest 2
    music_note MUSIC_NOTE_DS, 5
    music_rest 2
    music_note MUSIC_NOTE_DS, 2
    music_rest 2
    music_loop
    assert @ == $6F63

SECTION "MusicTrack_22_Ch1", ROMX[$6F63], BANK[$3F]
MusicTrack_22_Ch1::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_alternate_output_level $30
    music_channel_preset $10
    music_loop_point
    music_octave 2
    music_rest 16
    music_loop
    assert @ == $6F71

SECTION "MusicTrack_22_Ch3", ROMX[$6F71], BANK[$3F]
MusicTrack_22_Ch3::
    music_duration_multiplier $01
    music_channel_routing $11
    music_primary_output_level $20
    music_alternate_output_level $60
    music_wave_pattern $08
    music_modulation_selector $03
    music_modulation_period $14
    music_octave 2
    music_note MUSIC_NOTE_G, 6
    music_rest 1
    music_note MUSIC_NOTE_G, 3
    music_rest 1
    music_note MUSIC_NOTE_GS, 6
    music_rest 1
    music_note MUSIC_NOTE_GS, 3
    music_rest 1
    music_note MUSIC_NOTE_A, 6
    music_rest 1
    music_note MUSIC_NOTE_A, 3
    music_rest 2
    music_note MUSIC_NOTE_AS, 5
    music_rest 2
    music_note MUSIC_NOTE_AS, 2
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 3
    music_rest 1
    music_note MUSIC_NOTE_GS, 6
    music_rest 1
    music_note MUSIC_NOTE_GS, 3
    music_rest 1
    music_note MUSIC_NOTE_A, 6
    music_rest 1
    music_note MUSIC_NOTE_A, 3
    music_rest 1
    music_note MUSIC_NOTE_AS, 6
    music_rest 1
    music_note MUSIC_NOTE_AS, 3
    music_rest 2
    music_note MUSIC_NOTE_G, 5
    music_rest 2
    music_note MUSIC_NOTE_G, 2
    music_tie
    music_rest 2
    music_note MUSIC_NOTE_GS, 5
    music_rest 2
    music_note MUSIC_NOTE_GS, 3
    music_rest 1
    music_note MUSIC_NOTE_A, 6
    music_rest 1
    music_note MUSIC_NOTE_A, 3
    music_rest 1
    music_note MUSIC_NOTE_AS, 6
    music_rest 1
    music_note MUSIC_NOTE_AS, 3
    music_rest 1
    music_note MUSIC_NOTE_G, 6
    music_rest 1
    music_note MUSIC_NOTE_G, 3
    music_rest 2
    music_note MUSIC_NOTE_GS, 5
    music_rest 2
    music_note MUSIC_NOTE_GS, 2
    music_rest 2
    music_note MUSIC_NOTE_A, 5
    music_rest 2
    music_note MUSIC_NOTE_A, 3
    music_rest 1
    music_note MUSIC_NOTE_AS, 6
    music_rest 1
    music_note MUSIC_NOTE_AS, 3
    music_rest 1
    music_note MUSIC_NOTE_G, 6
    music_rest 1
    music_note MUSIC_NOTE_G, 3
    music_rest 1
    music_note MUSIC_NOTE_GS, 6
    music_rest 1
    music_note MUSIC_NOTE_GS, 1
    music_tie
    music_note MUSIC_NOTE_GS, 2
    music_rest 2
    music_note MUSIC_NOTE_A, 5
    music_rest 2
    music_note MUSIC_NOTE_A, 2
    music_rest 2
    music_note MUSIC_NOTE_AS, 5
    music_rest 2
    music_note MUSIC_NOTE_AS, 3
    music_rest 1
    music_note MUSIC_NOTE_G, 6
    music_rest 1
    music_note MUSIC_NOTE_G, 3
    music_rest 1
    music_note MUSIC_NOTE_GS, 6
    music_rest 1
    music_note MUSIC_NOTE_GS, 3
    music_rest 1
    music_note MUSIC_NOTE_A, 6
    music_rest 1
    music_note MUSIC_NOTE_A, 3
    music_rest 2
    music_note MUSIC_NOTE_AS, 5
    music_rest 2
    music_note MUSIC_NOTE_AS, 2
    music_rest 2
    music_loop
    assert @ == $6FE4

SECTION "MusicTrack_22_Ch4", ROMX[$6FE4], BANK[$3F]
MusicTrack_22_Ch4::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_octave 1
    music_loop_point
    music_note MUSIC_NOTE_E, 6
    music_rest 5
    music_note MUSIC_NOTE_E, 6
    music_rest 16
    music_rest 1
    music_note MUSIC_NOTE_E, 5
    music_rest 6
    music_note MUSIC_NOTE_E, 5
    music_rest 6
    music_note MUSIC_NOTE_E, 6
    music_rest 16
    music_note MUSIC_NOTE_E, 6
    music_rest 6
    music_note MUSIC_NOTE_E, 5
    music_rest 4
    music_rest 2
    music_note MUSIC_NOTE_E, 5
    music_rest 16
    music_rest 1
    music_note MUSIC_NOTE_E, 6
    music_rest 5
    music_note MUSIC_NOTE_E, 6
    music_rest 6
    music_note MUSIC_NOTE_E, 5
    music_rest 16
    music_rest 1
    music_note MUSIC_NOTE_E, 6
    music_rest 5
    music_note MUSIC_NOTE_E, 6
    music_rest 5
    music_note MUSIC_NOTE_E, 6
    music_rest 2
    music_rest 15
    music_note MUSIC_NOTE_E, 5
    music_rest 6
    music_note MUSIC_NOTE_E, 6
    music_rest 5
    music_note MUSIC_NOTE_E, 6
    music_rest 16
    music_rest 1
    music_note MUSIC_NOTE_E, 5
    music_rest 6
    music_loop
    assert @ == $7017

