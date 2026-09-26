include "macros/macros.inc"

section "Sound Effect Streams Bank 9", romx[$47d3], bank[$09]

SoundEffectStream_Unindexed_Bank09_Ch1:: ; $47D3
    sfx_envelope $c4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_envelope $64
    sfx_duty $0
    sfx_frequency $7, $c1
    sfx_envelope $34
    sfx_duty $0
    sfx_frequency $7, $c1
    sfx_end

SoundEffectStream_46_Ch4:: ; $47E7
    sfx_routing $11
    sfx_envelope $40
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_loop_start $02
    sfx_envelope $50
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_loop_start $03
    sfx_envelope $60
    sfx_frequency $0, $38
    sfx_frequency $0, $21
    sfx_frequency $0, $38
    sfx_frequency $0, $21
    sfx_frequency $0, $38
    sfx_frequency $0, $21
    sfx_loop_repeat
    sfx_loop_start $04
    sfx_envelope $70
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_loop_repeat
    sfx_loop_start $05
    sfx_envelope $80
    sfx_frequency $0, $28
    sfx_frequency $0, $11
    sfx_frequency $0, $28
    sfx_frequency $0, $11
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_loop_repeat
    sfx_loop_start $0f
    sfx_envelope $a0
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_loop_repeat
    sfx_envelope $70
    sfx_frequency $0, $08
    sfx_frequency $0, $11
    sfx_envelope $60
    sfx_frequency $0, $08
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $08
    sfx_frequency $0, $11
    sfx_end

SoundEffectStream_47_Ch4:: ; $4857
    sfx_routing $11
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_loop_start $10
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_end

SoundEffectStream_48_Ch4:: ; $4965
    sfx_routing $11
    sfx_loop_start $1a
    sfx_envelope $40
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $09
    sfx_pitch_delta $ff
    sfx_envelope $40
    sfx_loop_repeat
    sfx_end

SoundEffectStream_49_Ch1:: ; $497D
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $da
    sfx_loop_start $96
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_4A_Ch1:: ; $4A0E
    sfx_envelope $84
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $da
    sfx_loop_start $96
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_loop_repeat
    sfx_end

SoundEffectStream_4A_Ch4:: ; $4A9F
    sfx_routing $11
    sfx_envelope $10
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $20
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $30
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_loop_start $28
    sfx_envelope $60
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_envelope $40
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_loop_repeat
    sfx_end

SoundEffectStream_4B_Ch4:: ; $4ACF
    sfx_routing $11
    sfx_loop_start $10
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_end

SoundEffectStream_4C_Ch4:: ; $4BDD
    sfx_routing $11
    sfx_loop_start $1a
    sfx_envelope $40
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $08
    sfx_pitch_delta $ff
    sfx_envelope $40
    sfx_loop_repeat
    sfx_end

SoundEffectStream_4D_Ch1:: ; $4BF7
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $da
    sfx_loop_start $96
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_4E_Ch1:: ; $4C88
    sfx_envelope $84
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $da
    sfx_loop_start $96
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_loop_repeat
    sfx_end

SoundEffectStream_4E_Ch4:: ; $4D19
    sfx_routing $11
    sfx_envelope $10
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $20
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $30
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_loop_start $28
    sfx_envelope $60
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $40
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_loop_repeat
    sfx_end

SoundEffectStream_4F_Ch1:: ; $4D49
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_loop_start $14
    sfx_envelope $f4
    sfx_frequency $4, $e5
    sfx_frequency $5, $11
    sfx_envelope $c4
    sfx_frequency $5, $89
    sfx_frequency $5, $ac
    sfx_envelope $84
    sfx_frequency $5, $cd
    sfx_frequency $5, $ed
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_loop_repeat
    sfx_end

SoundEffectStream_50_Ch4:: ; $4D6E
    sfx_routing $11
    sfx_loop_start $1a
    sfx_envelope $40
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $08
    sfx_pitch_delta $ff
    sfx_envelope $40
    sfx_loop_repeat
    sfx_end

SoundEffectStream_51_Ch1:: ; $4D88
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $da
    sfx_loop_start $96
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_52_Ch1:: ; $4E19
    sfx_envelope $84
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $da
    sfx_loop_start $96
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_loop_repeat
    sfx_end

SoundEffectStream_52_Ch4:: ; $4EAA
    sfx_routing $11
    sfx_envelope $10
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $20
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $30
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_loop_start $28
    sfx_envelope $60
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $40
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_loop_repeat
    sfx_end

SoundEffectStream_53_Ch4:: ; $4EDA
    sfx_routing $11
    sfx_envelope $40
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_loop_start $02
    sfx_envelope $50
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_loop_start $03
    sfx_envelope $60
    sfx_frequency $0, $38
    sfx_frequency $0, $21
    sfx_frequency $0, $38
    sfx_frequency $0, $21
    sfx_frequency $0, $38
    sfx_frequency $0, $21
    sfx_loop_repeat
    sfx_loop_start $04
    sfx_envelope $70
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_loop_repeat
    sfx_loop_start $05
    sfx_envelope $80
    sfx_frequency $0, $28
    sfx_frequency $0, $11
    sfx_frequency $0, $28
    sfx_frequency $0, $11
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_loop_repeat
    sfx_loop_start $0f
    sfx_envelope $a0
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_loop_repeat
    sfx_envelope $70
    sfx_frequency $0, $08
    sfx_frequency $0, $11
    sfx_envelope $60
    sfx_frequency $0, $08
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $08
    sfx_frequency $0, $11
    sfx_end

SoundEffectStream_54_Ch4:: ; $4F4A
    sfx_routing $11
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_loop_start $10
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_end

SoundEffectStream_55_Ch4:: ; $5058
    sfx_routing $11
    sfx_loop_start $1a
    sfx_envelope $40
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $08
    sfx_pitch_delta $ff
    sfx_envelope $40
    sfx_loop_repeat
    sfx_end

SoundEffectStream_56_Ch1:: ; $5072
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $da
    sfx_loop_start $96
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_57_Ch1:: ; $5103
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_frequency $3, $da
    sfx_loop_start $96
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_57_Ch4:: ; $5194
    sfx_routing $11
    sfx_envelope $10
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_envelope $20
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_envelope $30
    sfx_frequency $0, $1d
    sfx_frequency $0, $1d
    sfx_loop_start $28
    sfx_envelope $40
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_envelope $40
    sfx_frequency $0, $1d
    sfx_frequency $0, $1d
    sfx_loop_repeat
    sfx_end

SoundEffectStream_58_Ch4:: ; $51C4
    sfx_routing $11
    sfx_envelope $40
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_envelope $60
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_envelope $70
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_loop_start $1e
    sfx_envelope $a0
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_loop_repeat
    sfx_envelope $70
    sfx_frequency $0, $08
    sfx_frequency $0, $11
    sfx_envelope $60
    sfx_frequency $0, $08
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $08
    sfx_frequency $0, $11
    sfx_end

SoundEffectStream_59_Ch4:: ; $51FC
    sfx_routing $11
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_loop_start $10
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_end

SoundEffectStream_5A_Ch1:: ; $530A
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $59
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $c1
    sfx_wait $01
    sfx_frequency $7, $d6
    sfx_wait $01
    sfx_envelope $c4
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $c1
    sfx_wait $01
    sfx_frequency $7, $d6
    sfx_wait $01
    sfx_envelope $84
    sfx_duty $4
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $c1
    sfx_wait $01
    sfx_frequency $7, $d6
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $c1
    sfx_wait $01
    sfx_frequency $7, $d6
    sfx_wait $01
    sfx_envelope $44
    sfx_duty $8
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $c1
    sfx_wait $01
    sfx_frequency $7, $d6
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $c1
    sfx_wait $01
    sfx_frequency $7, $d6
    sfx_wait $01
    sfx_envelope $14
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $c1
    sfx_wait $01
    sfx_frequency $7, $d6
    sfx_wait $01
    sfx_end

SoundEffectStream_5B_Ch1:: ; $53E4
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $7b
    sfx_frequency $7, $44
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $72
    sfx_frequency $6, $0b
    sfx_frequency $5, $63
    sfx_frequency $4, $83
    sfx_envelope $e4
    sfx_frequency $7, $7b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $0b
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_envelope $d4
    sfx_frequency $7, $7b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $0b
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_envelope $c4
    sfx_frequency $7, $7b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $0b
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_envelope $b4
    sfx_frequency $7, $7b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $0b
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_envelope $a4
    sfx_frequency $7, $7b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $0b
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_envelope $84
    sfx_frequency $7, $7b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $0b
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_envelope $44
    sfx_frequency $7, $7b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $0b
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_envelope $24
    sfx_frequency $7, $7b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $0b
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_end

SoundEffectStream_5B_Ch2:: ; $549A
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $6, $f6
    sfx_frequency $6, $89
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $4, $e5
    sfx_frequency $4, $16
    sfx_frequency $2, $c6
    sfx_frequency $1, $06
    sfx_envelope $e4
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $4, $16
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_envelope $d4
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $4, $16
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_envelope $c4
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $4, $16
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_envelope $b4
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $4, $16
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_envelope $a4
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $4, $16
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_envelope $84
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $4, $16
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_envelope $44
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $4, $16
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_end

SoundEffectStream_5C_Ch1:: ; $553C
    sfx_envelope $b4
    sfx_routing $11
    sfx_duty $8
    sfx_loop_start $02
    sfx_frequency $7, $6b
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $05
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $05
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $05
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $b4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_5C_Ch4:: ; $567B
    sfx_routing $11
    sfx_loop_start $07
    sfx_envelope $20
    sfx_frequency $0, $38
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $38
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_loop_start $07
    sfx_envelope $20
    sfx_frequency $0, $39
    sfx_envelope $40
    sfx_frequency $0, $30
    sfx_envelope $60
    sfx_frequency $0, $39
    sfx_frequency $0, $30
    sfx_frequency $0, $39
    sfx_frequency $0, $30
    sfx_envelope $60
    sfx_frequency $0, $39
    sfx_envelope $40
    sfx_frequency $0, $30
    sfx_loop_repeat
    sfx_loop_start $07
    sfx_envelope $20
    sfx_frequency $0, $39
    sfx_envelope $40
    sfx_frequency $0, $32
    sfx_envelope $60
    sfx_frequency $0, $39
    sfx_frequency $0, $32
    sfx_frequency $0, $39
    sfx_frequency $0, $32
    sfx_envelope $60
    sfx_frequency $0, $39
    sfx_envelope $40
    sfx_frequency $0, $32
    sfx_loop_repeat
    sfx_loop_start $07
    sfx_envelope $20
    sfx_frequency $0, $38
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $38
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_end

SoundEffectStream_5D_Ch4:: ; $56F2
    sfx_routing $11
    sfx_loop_start $2d
    sfx_envelope $40
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $05
    sfx_pitch_delta $ff
    sfx_envelope $40
    sfx_loop_repeat
    sfx_end

SoundEffectStream_5E_Ch1:: ; $570A
    sfx_envelope $84
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_frequency $3, $da
    sfx_loop_start $aa
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_loop_repeat
    sfx_end

SoundEffectStream_5E_Ch4:: ; $579B
    sfx_routing $11
    sfx_envelope $10
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $20
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $30
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_loop_start $2d
    sfx_envelope $60
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $40
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_loop_repeat
    sfx_end

SoundEffectStream_5F_Ch4:: ; $57CB
    sfx_routing $11
    sfx_envelope $20
    sfx_frequency $0, $28
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $28
    sfx_frequency $0, $11
    sfx_envelope $60
    sfx_frequency $0, $28
    sfx_frequency $0, $11
    sfx_loop_start $0c
    sfx_envelope $a0
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_loop_repeat
    sfx_loop_start $0c
    sfx_envelope $90
    sfx_frequency $0, $28
    sfx_frequency $0, $11
    sfx_frequency $0, $28
    sfx_frequency $0, $11
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_loop_repeat
    sfx_loop_start $0c
    sfx_envelope $80
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_frequency $0, $28
    sfx_frequency $0, $21
    sfx_loop_repeat
    sfx_loop_start $0c
    sfx_envelope $70
    sfx_frequency $0, $38
    sfx_frequency $0, $21
    sfx_frequency $0, $38
    sfx_frequency $0, $21
    sfx_frequency $0, $38
    sfx_frequency $0, $21
    sfx_frequency $0, $00
    sfx_loop_repeat
    sfx_loop_start $0c
    sfx_envelope $60
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_loop_repeat
    sfx_envelope $50
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_envelope $10
    sfx_frequency $0, $38
    sfx_frequency $0, $31
    sfx_end

SoundEffectStream_60_Ch1:: ; $584D
    sfx_envelope $b4
    sfx_routing $11
    sfx_duty $0
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $0c
    sfx_pitch_delta $ff
    sfx_envelope $b4
    sfx_frequency $7, $df
    sfx_pitch_delta $00
    sfx_wait $0b
    sfx_envelope $84
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_envelope $64
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_envelope $44
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_envelope $24
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_envelope $14
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_end

SoundEffectStream_60_Ch4:: ; $5881
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $80
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $10
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_end

SoundEffectStream_61_Ch1:: ; $5902
    sfx_envelope $f7
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $5, $ed
    sfx_pitch_delta $00
    sfx_wait $04
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $00
    sfx_envelope $f7
    sfx_envelope $f7
    sfx_sweep $1f
    sfx_frequency $5, $ed
    sfx_wait $27
    sfx_end

SoundEffectStream_61_Ch4:: ; $5922
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $80
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $20
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_end

SoundEffectStream_62_Ch1:: ; $598B
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $6b
    sfx_frequency $6, $d6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $4, $83
    sfx_envelope $a4
    sfx_frequency $7, $6b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $89
    sfx_frequency $6, $42
    sfx_frequency $5, $ed
    sfx_frequency $5, $ac
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_frequency $3, $da
    sfx_envelope $84
    sfx_frequency $7, $6b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $89
    sfx_frequency $6, $42
    sfx_envelope $74
    sfx_frequency $5, $ed
    sfx_frequency $5, $ac
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_frequency $3, $da
    sfx_envelope $64
    sfx_frequency $7, $6b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $89
    sfx_frequency $6, $42
    sfx_frequency $5, $ed
    sfx_envelope $44
    sfx_frequency $5, $ac
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_frequency $3, $da
    sfx_envelope $34
    sfx_frequency $7, $6b
    sfx_frequency $7, $21
    sfx_frequency $6, $d6
    sfx_frequency $6, $89
    sfx_frequency $6, $42
    sfx_frequency $5, $ed
    sfx_frequency $5, $ac
    sfx_envelope $24
    sfx_frequency $5, $63
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_frequency $3, $da
    sfx_end

SoundEffectStream_62_Ch2:: ; $5A11
    sfx_envelope $a4
    sfx_routing $11
    sfx_duty $8
    sfx_pitch_delta $81
    sfx_frequency $6, $d6
    sfx_frequency $5, $ac
    sfx_frequency $4, $83
    sfx_frequency $3, $58
    sfx_frequency $1, $06
    sfx_envelope $74
    sfx_frequency $6, $d6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $5, $11
    sfx_frequency $4, $83
    sfx_frequency $3, $da
    sfx_frequency $3, $58
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $6, $d6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $5, $11
    sfx_frequency $4, $83
    sfx_envelope $54
    sfx_frequency $3, $da
    sfx_frequency $3, $58
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $6, $d6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $5, $11
    sfx_frequency $4, $83
    sfx_frequency $3, $da
    sfx_envelope $34
    sfx_frequency $3, $58
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $6, $d6
    sfx_frequency $6, $42
    sfx_frequency $5, $ac
    sfx_frequency $5, $11
    sfx_frequency $4, $83
    sfx_frequency $3, $da
    sfx_frequency $3, $58
    sfx_envelope $14
    sfx_frequency $2, $c6
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $06
    sfx_frequency $0, $2c
    sfx_end

SoundEffectStream_63_Ch1:: ; $5A99
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffectStream_64_Ch1:: ; $5AA9
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $4, $16
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_envelope $54
    sfx_frequency $4, $16
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_envelope $f4
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_frequency $6, $0b
    sfx_envelope $54
    sfx_frequency $4, $16
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_envelope $f4
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_frequency $6, $0b
    sfx_frequency $6, $42
    sfx_envelope $54
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_frequency $6, $0b
    sfx_envelope $f4
    sfx_frequency $5, $63
    sfx_frequency $6, $0b
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_envelope $54
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_frequency $6, $0b
    sfx_envelope $f4
    sfx_frequency $6, $0b
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_envelope $54
    sfx_frequency $5, $63
    sfx_frequency $6, $0b
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_envelope $f4
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_frequency $7, $05
    sfx_envelope $54
    sfx_frequency $6, $0b
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_envelope $f4
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_frequency $7, $05
    sfx_frequency $7, $21
    sfx_envelope $54
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_frequency $7, $05
    sfx_envelope $f4
    sfx_frequency $6, $b2
    sfx_frequency $7, $05
    sfx_frequency $7, $21
    sfx_frequency $7, $39
    sfx_envelope $54
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_frequency $7, $05
    sfx_frequency $7, $21
    sfx_envelope $f4
    sfx_frequency $7, $05
    sfx_frequency $7, $21
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_envelope $54
    sfx_frequency $6, $b2
    sfx_frequency $7, $05
    sfx_frequency $7, $21
    sfx_frequency $7, $39
    sfx_envelope $f4
    sfx_frequency $7, $21
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_frequency $7, $83
    sfx_envelope $54
    sfx_frequency $7, $05
    sfx_frequency $7, $21
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_envelope $f4
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_envelope $54
    sfx_frequency $7, $21
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_frequency $7, $83
    sfx_envelope $f4
    sfx_frequency $7, $59
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_envelope $54
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_envelope $f4
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_envelope $54
    sfx_frequency $7, $59
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_envelope $84
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_envelope $44
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_envelope $64
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_frequency $7, $c8
    sfx_envelope $34
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_envelope $44
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_frequency $7, $c8
    sfx_frequency $7, $ce
    sfx_envelope $24
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_frequency $7, $c8
    sfx_end

SoundEffectStream_64_Ch4:: ; $5BED
    sfx_routing $11
    sfx_envelope $20
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $80
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $f0
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $80
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $60
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $20
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_end

SoundEffectStream_65_Ch1:: ; $5D0E
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $0
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $0c
    sfx_pitch_delta $ff
    sfx_envelope $f4
    sfx_envelope $e4
    sfx_frequency $7, $df
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $d4
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $c4
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $b4
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $a4
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $94
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $74
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $54
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_envelope $14
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_frequency $7, $db
    sfx_wait $01
    sfx_frequency $7, $ce
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_end

SoundEffectStream_65_Ch4:: ; $5E1C
    sfx_routing $11
    sfx_envelope $20
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $80
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $f0
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $80
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $60
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $20
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_end

SoundEffectStream_66_Ch4:: ; $5F3D
    sfx_routing $11
    sfx_loop_start $0a
    sfx_envelope $d0
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_loop_repeat
    sfx_envelope $80
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_envelope $20
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_frequency $0, $6c
    sfx_frequency $0, $7c
    sfx_end

SoundEffectStream_67_Ch4:: ; $5F7F
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_envelope $80
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_envelope $60
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_envelope $30
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $30
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_envelope $20
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $10
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_frequency $0, $01
    sfx_end

SoundEffectStream_79_Ch4:: ; $600E
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $44
    sfx_frequency $0, $26
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $44
    sfx_frequency $0, $61
    sfx_frequency $0, $44
    sfx_frequency $0, $61
    sfx_envelope $80
    sfx_frequency $0, $44
    sfx_frequency $0, $61
    sfx_frequency $0, $44
    sfx_envelope $60
    sfx_frequency $0, $61
    sfx_frequency $0, $44
    sfx_envelope $40
    sfx_frequency $0, $44
    sfx_frequency $0, $61
    sfx_envelope $20
    sfx_frequency $0, $61
    sfx_frequency $0, $44
    sfx_end

SoundEffectStream_7A_Ch1:: ; $6045
    sfx_envelope $a4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $0, $2c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $0, $9c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $1, $06
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $1, $6b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $1, $c9
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $2, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $2, $78
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $2, $c6
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $3, $12
    sfx_frequency $3, $58
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $3, $9b
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_frequency $3, $da
    sfx_loop_start $64
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_7A_Ch4:: ; $60D6
    sfx_routing $11
    sfx_envelope $10
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $20
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $30
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_loop_start $1c
    sfx_envelope $60
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $30
    sfx_frequency $0, $1d
    sfx_frequency $0, $1d
    sfx_loop_repeat
    sfx_end

SoundEffectStream_7B_Ch1:: ; $6106
    sfx_envelope $f3
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $3, $da
    sfx_frequency $4, $16
    sfx_frequency $4, $4e
    sfx_frequency $4, $83
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $f3
    sfx_sweep $1f
    sfx_frequency $3, $da
    sfx_pitch_delta $00
    sfx_wait $1d
    sfx_end

SoundEffectStream_7B_Ch4:: ; $6126
    sfx_routing $11
    sfx_envelope $b0
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $54
    sfx_frequency $0, $65
    sfx_frequency $0, $54
    sfx_frequency $0, $65
    sfx_frequency $0, $54
    sfx_frequency $0, $65
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $03
    sfx_pitch_delta $ff
    sfx_envelope $b0
    sfx_envelope $b0
    sfx_frequency $0, $4c
    sfx_frequency $0, $5b
    sfx_frequency $0, $4c
    sfx_frequency $0, $5b
    sfx_frequency $0, $4c
    sfx_frequency $0, $5b
    sfx_envelope $80
    sfx_frequency $0, $5c
    sfx_frequency $0, $6b
    sfx_frequency $0, $5c
    sfx_frequency $0, $6b
    sfx_frequency $0, $5c
    sfx_frequency $0, $6b
    sfx_envelope $60
    sfx_frequency $0, $6c
    sfx_frequency $0, $7b
    sfx_frequency $0, $6c
    sfx_frequency $0, $7b
    sfx_frequency $0, $6c
    sfx_frequency $0, $7b
    sfx_envelope $40
    sfx_frequency $0, $7c
    sfx_frequency $0, $7b
    sfx_frequency $0, $7c
    sfx_frequency $0, $7b
    sfx_frequency $0, $7c
    sfx_frequency $0, $7b
    sfx_envelope $20
    sfx_frequency $0, $7c
    sfx_frequency $0, $7b
    sfx_frequency $0, $7c
    sfx_frequency $0, $7b
    sfx_frequency $0, $7c
    sfx_frequency $0, $7b
    sfx_end

SoundEffectStream_7C_Ch4:: ; $618B
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $33
    sfx_frequency $0, $33
    sfx_frequency $0, $33
    sfx_frequency $0, $33
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $43
    sfx_frequency $0, $42
    sfx_frequency $0, $42
    sfx_frequency $0, $12
    sfx_frequency $0, $12
    sfx_frequency $0, $12
    sfx_envelope $80
    sfx_frequency $0, $12
    sfx_frequency $0, $12
    sfx_frequency $0, $12
    sfx_frequency $0, $12
    sfx_frequency $0, $12
    sfx_envelope $60
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_envelope $40
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_envelope $20
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_end

SoundEffectStream_7D_Ch1:: ; $61E4
    sfx_envelope $f3
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $be
    sfx_frequency $7, $c1
    sfx_frequency $7, $c5
    sfx_frequency $7, $c8
    sfx_envelope $63
    sfx_frequency $7, $cb
    sfx_frequency $7, $ce
    sfx_frequency $7, $d1
    sfx_frequency $7, $d4
    sfx_frequency $7, $d6
    sfx_envelope $33
    sfx_frequency $7, $d9
    sfx_frequency $7, $db
    sfx_frequency $7, $dd
    sfx_end

SoundEffectStream_7E_Ch1:: ; $6206
    sfx_envelope $f3
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $5, $63
    sfx_frequency $5, $89
    sfx_frequency $5, $ac
    sfx_frequency $5, $cd
    sfx_frequency $5, $ed
    sfx_envelope $83
    sfx_frequency $6, $0b
    sfx_frequency $6, $28
    sfx_envelope $43
    sfx_frequency $6, $42
    sfx_frequency $6, $5b
    sfx_envelope $f4
    sfx_frequency $6, $72
    sfx_frequency $6, $42
    sfx_frequency $6, $0b
    sfx_frequency $5, $ed
    sfx_frequency $5, $ac
    sfx_frequency $5, $63
    sfx_envelope $83
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_frequency $4, $16
    sfx_envelope $43
    sfx_frequency $3, $da
    sfx_frequency $3, $58
    sfx_frequency $2, $c6
    sfx_end

SoundEffectStream_7F_Ch4:: ; $6242
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $21
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $80
    sfx_frequency $0, $32
    sfx_frequency $0, $32
    sfx_frequency $0, $32
    sfx_frequency $0, $32
    sfx_frequency $0, $32
    sfx_frequency $0, $32
    sfx_frequency $0, $33
    sfx_frequency $0, $33
    sfx_frequency $0, $33
    sfx_frequency $0, $33
    sfx_frequency $0, $33
    sfx_frequency $0, $33
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_envelope $60
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $36
    sfx_frequency $0, $36
    sfx_frequency $0, $36
    sfx_frequency $0, $36
    sfx_frequency $0, $36
    sfx_frequency $0, $36
    sfx_frequency $0, $36
    sfx_frequency $0, $36
    sfx_envelope $40
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_envelope $20
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_frequency $0, $35
    sfx_end

SoundEffectStream_80_Ch4:: ; $62FF
    sfx_routing $11
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $70
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_loop_start $14
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $70
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_loop_start $02
    sfx_envelope $10
    sfx_frequency $0, $33
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_envelope $30
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_envelope $10
    sfx_frequency $0, $31
    sfx_loop_repeat
    sfx_envelope $10
    sfx_frequency $0, $33
    sfx_envelope $10
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $30
    sfx_frequency $0, $33
    sfx_frequency $0, $31
    sfx_envelope $10
    sfx_frequency $0, $33
    sfx_envelope $10
    sfx_frequency $0, $31
    sfx_end

SoundEffectStream_81_Ch1:: ; $6448
    sfx_envelope $74
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $7, $be
    sfx_pitch_delta $00
    sfx_wait $18
    sfx_end

SoundEffectStream_81_Ch4:: ; $6456
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $5c
    sfx_frequency $0, $5c
    sfx_frequency $0, $5c
    sfx_frequency $0, $5c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $5c
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_envelope $80
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_envelope $60
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_envelope $40
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_envelope $20
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_end

SoundEffectStream_82_Ch1:: ; $64D7
    sfx_envelope $d7
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $7, $7b
    sfx_pitch_delta $00
    sfx_wait $3b
    sfx_end

SoundEffectStream_82_Ch4:: ; $64E5
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $43
    sfx_frequency $0, $42
    sfx_frequency $0, $43
    sfx_frequency $0, $42
    sfx_frequency $0, $43
    sfx_frequency $0, $42
    sfx_frequency $0, $43
    sfx_frequency $0, $42
    sfx_frequency $0, $43
    sfx_frequency $0, $42
    sfx_frequency $0, $43
    sfx_frequency $0, $42
    sfx_frequency $0, $52
    sfx_frequency $0, $51
    sfx_frequency $0, $52
    sfx_frequency $0, $51
    sfx_frequency $0, $52
    sfx_frequency $0, $51
    sfx_frequency $0, $62
    sfx_frequency $0, $61
    sfx_frequency $0, $62
    sfx_frequency $0, $61
    sfx_frequency $0, $62
    sfx_frequency $0, $61
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_envelope $80
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_envelope $60
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_envelope $20
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_end

SoundEffectStream_83_Ch4:: ; $65C8
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $61
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $64
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_envelope $84
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_envelope $64
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_envelope $34
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_frequency $0, $63
    sfx_end

SoundEffectStream_84_Ch1:: ; $6619
    sfx_envelope $60
    sfx_routing $11
    sfx_duty $4
    sfx_frequency $7, $df
    sfx_frequency $7, $dd
    sfx_frequency $7, $df
    sfx_frequency $7, $dd
    sfx_frequency $7, $db
    sfx_frequency $7, $dd
    sfx_frequency $7, $db
    sfx_frequency $7, $d9
    sfx_frequency $7, $db
    sfx_frequency $7, $d9
    sfx_frequency $7, $d6
    sfx_frequency $7, $d9
    sfx_frequency $7, $d6
    sfx_frequency $7, $d4
    sfx_frequency $7, $d6
    sfx_frequency $7, $d4
    sfx_frequency $7, $d1
    sfx_frequency $7, $d4
    sfx_frequency $7, $d1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d1
    sfx_frequency $7, $ce
    sfx_frequency $7, $cb
    sfx_frequency $7, $ce
    sfx_frequency $7, $cb
    sfx_frequency $7, $c8
    sfx_frequency $7, $cb
    sfx_frequency $7, $c8
    sfx_frequency $7, $c5
    sfx_frequency $7, $c8
    sfx_frequency $7, $c5
    sfx_frequency $7, $c1
    sfx_frequency $7, $c5
    sfx_frequency $7, $c1
    sfx_frequency $7, $be
    sfx_frequency $7, $c1
    sfx_envelope $40
    sfx_frequency $7, $be
    sfx_frequency $7, $ba
    sfx_frequency $7, $be
    sfx_frequency $7, $ba
    sfx_frequency $7, $b6
    sfx_frequency $7, $ba
    sfx_frequency $7, $b6
    sfx_frequency $7, $b1
    sfx_frequency $7, $b6
    sfx_envelope $20
    sfx_frequency $7, $b1
    sfx_frequency $7, $ac
    sfx_frequency $7, $b1
    sfx_frequency $7, $ac
    sfx_frequency $7, $a7
    sfx_frequency $7, $ac
    sfx_frequency $7, $a7
    sfx_frequency $7, $a2
    sfx_frequency $7, $a7
    sfx_envelope $10
    sfx_frequency $7, $a2
    sfx_frequency $7, $9d
    sfx_frequency $7, $a2
    sfx_frequency $7, $9d
    sfx_frequency $7, $97
    sfx_frequency $7, $9d
    sfx_frequency $7, $97
    sfx_frequency $7, $90
    sfx_frequency $7, $97
    sfx_frequency $7, $90
    sfx_frequency $7, $8a
    sfx_frequency $7, $90
    sfx_frequency $7, $8a
    sfx_frequency $7, $83
    sfx_frequency $7, $8a
    sfx_frequency $7, $83
    sfx_frequency $7, $7b
    sfx_frequency $7, $83
    sfx_end

SoundEffectStream_84_Ch4:: ; $66B5
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $61
    sfx_frequency $0, $62
    sfx_frequency $0, $61
    sfx_frequency $0, $62
    sfx_frequency $0, $61
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $70
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $84
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $64
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_envelope $34
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_end

SoundEffectStream_85_Ch1:: ; $6712
    sfx_envelope $b4
    sfx_routing $11
    sfx_duty $0
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $0c
    sfx_pitch_delta $ff
    sfx_envelope $b4
    sfx_frequency $7, $df
    sfx_pitch_delta $00
    sfx_wait $0b
    sfx_envelope $84
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_envelope $64
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_envelope $44
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_envelope $24
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_envelope $14
    sfx_frequency $7, $df
    sfx_wait $0b
    sfx_end

SoundEffectStream_85_Ch4:: ; $6746
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $80
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_envelope $10
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_frequency $0, $31
    sfx_end

SoundEffectStream_86_Ch1:: ; $67C7
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $6, $9e
    sfx_frequency $5, $ed
    sfx_envelope $e4
    sfx_frequency $5, $3c
    sfx_frequency $4, $83
    sfx_frequency $3, $da
    sfx_envelope $d4
    sfx_frequency $4, $83
    sfx_frequency $2, $78
    sfx_frequency $1, $06
    sfx_envelope $f4
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $6, $9e
    sfx_frequency $5, $ed
    sfx_envelope $a4
    sfx_frequency $5, $3c
    sfx_frequency $4, $83
    sfx_frequency $3, $da
    sfx_envelope $84
    sfx_frequency $4, $83
    sfx_frequency $2, $78
    sfx_frequency $1, $06
    sfx_envelope $a4
    sfx_frequency $6, $f6
    sfx_frequency $6, $42
    sfx_frequency $6, $9e
    sfx_frequency $5, $ed
    sfx_envelope $84
    sfx_frequency $5, $3c
    sfx_frequency $4, $83
    sfx_frequency $3, $da
    sfx_envelope $44
    sfx_frequency $4, $83
    sfx_frequency $2, $78
    sfx_frequency $1, $06
    sfx_end

SoundEffectStream_86_Ch4:: ; $6819
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $f0
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $80
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_end
