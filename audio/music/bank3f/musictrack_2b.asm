; Music track $2B (Bank $3F)
; Auto-promoted from the byte-exact channel streams using the documented music VM.

SECTION "MusicTrack_2B_Ch2", ROMX[$7BEE], BANK[$3F]
MusicTrack_2B_Ch2::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_channel_preset $1f
    music_alternate_output_level $30
    music_loop_point
    music_enable_alternate_output
    music_octave 3
    music_note MUSIC_NOTE_C, 15
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_G, 15
    music_rest 1
    music_note MUSIC_NOTE_G, 4
    music_rest 3
    music_note MUSIC_NOTE_F, 15
    music_rest 3
    music_note MUSIC_NOTE_F, 4
    music_note MUSIC_NOTE_AS, 15
    music_rest 3
    music_note MUSIC_NOTE_AS, 4
    music_rest 1
    music_note MUSIC_NOTE_G, 15
    music_rest 3
    music_note MUSIC_NOTE_G, 4
    music_octave_up
    music_note MUSIC_NOTE_D, 15
    music_rest 1
    music_rest 2
    music_note MUSIC_NOTE_D, 4
    music_note MUSIC_NOTE_C, 15
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_octave_down
    music_note MUSIC_NOTE_F, 15
    music_rest 3
    music_note MUSIC_NOTE_F, 4
    music_note MUSIC_NOTE_AS, 4
    music_rest 3
    music_note MUSIC_NOTE_AS, 4
    music_rest 2
    music_rest 4
    music_note MUSIC_NOTE_AS, 4
    music_rest 1
    music_note MUSIC_NOTE_AS, 1
    music_note MUSIC_NOTE_G, 16
    music_tie
    music_note MUSIC_NOTE_G, 16
    music_tie
    music_note MUSIC_NOTE_G, 16
    music_rest 4
    music_note MUSIC_NOTE_G, 4
    music_rest 11
    music_note MUSIC_NOTE_AS, 4
    music_rest 4
    music_note MUSIC_NOTE_AS, 4
    music_rest 5
    music_note MUSIC_NOTE_AS, 3
    music_rest 1
    music_note MUSIC_NOTE_AS, 1
    music_note MUSIC_NOTE_G, 16
    music_tie
    music_note MUSIC_NOTE_G, 13
    music_tie
    music_note MUSIC_NOTE_G, 16
    music_tie
    music_note MUSIC_NOTE_G, 4
    music_rest 4
    music_note MUSIC_NOTE_G, 4
    music_rest 10
    music_loop
    assert @ == $7C3C

SECTION "MusicTrack_2B_Ch1", ROMX[$7C3C], BANK[$3F]
MusicTrack_2B_Ch1::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_loop_point
    music_duration_multiplier $01
    music_channel_preset $19
    music_alternate_output_level $40
    music_loop_point
    music_octave 2
    music_counted_loop_start $02
    music_enable_alternate_output
    music_note MUSIC_NOTE_G, 15
    music_rest 1
    music_note MUSIC_NOTE_G, 4
    music_rest 2
    music_octave_up
    music_note MUSIC_NOTE_C, 15
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 3
    music_octave_down
    music_note MUSIC_NOTE_AS, 15
    music_rest 3
    music_note MUSIC_NOTE_AS, 4
    music_octave_up
    music_note MUSIC_NOTE_F, 15
    music_rest 3
    music_note MUSIC_NOTE_F, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 15
    music_rest 3
    music_note MUSIC_NOTE_C, 4
    music_note MUSIC_NOTE_G, 15
    music_rest 1
    music_rest 2
    music_note MUSIC_NOTE_G, 4
    music_note MUSIC_NOTE_F, 15
    music_rest 3
    music_note MUSIC_NOTE_F, 4
    music_rest 1
    music_octave_down
    music_note MUSIC_NOTE_AS, 15
    music_rest 3
    music_note MUSIC_NOTE_AS, 4
    music_octave_up
    music_note MUSIC_NOTE_F, 4
    music_rest 3
    music_note MUSIC_NOTE_F, 4
    music_rest 2
    music_rest 4
    music_note MUSIC_NOTE_F, 4
    music_rest 1
    music_note MUSIC_NOTE_F, 1
    music_note MUSIC_NOTE_E, 16
    music_tie
    music_note MUSIC_NOTE_E, 16
    music_tie
    music_note MUSIC_NOTE_E, 16
    music_rest 4
    music_note MUSIC_NOTE_E, 4
    music_rest 11
    music_note MUSIC_NOTE_D, 4
    music_rest 4
    music_note MUSIC_NOTE_D, 4
    music_rest 5
    music_note MUSIC_NOTE_DS, 3
    music_rest 1
    music_note MUSIC_NOTE_DS, 1
    music_note MUSIC_NOTE_E, 16
    music_tie
    music_note MUSIC_NOTE_E, 13
    music_tie
    music_note MUSIC_NOTE_E, 16
    music_tie
    music_note MUSIC_NOTE_E, 4
    music_rest 4
    music_note MUSIC_NOTE_E, 4
    music_rest 10
    music_counted_loop_repeat
    music_loop
    assert @ == $7C93

SECTION "MusicTrack_2B_Ch3", ROMX[$7C93], BANK[$3F]
MusicTrack_2B_Ch3::
    music_duration_multiplier $01
    music_channel_routing $11
    music_primary_output_level $20
    music_wave_pattern $09
    music_modulation_selector $06
    music_modulation_period $0c
    music_octave 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_note MUSIC_NOTE_C, 4
    music_rest 2
    music_note MUSIC_NOTE_C, 4
    music_rest 1
    music_loop
    assert @ == $7D22

SECTION "MusicTrack_2B_Ch4", ROMX[$7D22], BANK[$3F]
MusicTrack_2B_Ch4::
    music_duration_multiplier $01
    music_channel_routing $11
    music_duration_multiplier $01
    music_octave 1
    music_loop_point
    music_note MUSIC_NOTE_E, 6
    music_rest 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_rest 6
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 3
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 5
    music_rest 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_rest 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 3
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_E, 6
    music_rest 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 6
    music_rest 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 3
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 5
    music_rest 6
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 5
    music_rest 1
    music_rest 5
    music_note MUSIC_NOTE_E, 5
    music_note MUSIC_NOTE_E, 6
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 3
    music_note MUSIC_NOTE_E, 4
    music_note MUSIC_NOTE_E, 4
    music_rest 2
    music_note MUSIC_NOTE_E, 4
    music_rest 1
    music_loop
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    music_rest 1
    assert @ == $8000

