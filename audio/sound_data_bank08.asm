include "macros/macros.inc"

section "Sound Effect Streams", romx[$47d3], bank[$08]

; Command streams remain numerically named until callers or gameplay context
; establish stable semantic effect names. Each stream terminates with sfx_end.
SoundEffectStream_Unindexed_Bank08_Ch1:: ; $47D3
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

SoundEffectStream_01_Ch1:: ; $47E7
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $83
    sfx_envelope $c4
    sfx_frequency $7, $ac
    sfx_envelope $84
    sfx_frequency $7, $83
    sfx_envelope $44
    sfx_frequency $7, $ac
    sfx_end

SoundEffectStream_02_Ch1:: ; $47FB
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $83
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $a2
    sfx_wait $01
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_envelope $c4
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $a2
    sfx_wait $01
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $a2
    sfx_wait $01
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $a2
    sfx_wait $01
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_end

SoundEffect_Error_Ch1::
SoundEffectStream_03_Ch1:: ; $4849
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $0
    sfx_loop_start $02
    sfx_frequency $7, $db
    sfx_frequency $7, $b6
    sfx_loop_repeat
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $03
    sfx_pitch_delta $ff
    sfx_envelope $f4
    sfx_frequency $7, $db
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_end

SoundEffectStream_04_Ch1:: ; $4866
    sfx_envelope $64
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $6b
    sfx_envelope $44
    sfx_frequency $7, $6b
    sfx_envelope $24
    sfx_frequency $7, $6b
    sfx_end

SoundEffect_UnitDelete_Ch1::
SoundEffectStream_05_Ch1:: ; $4876
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

SoundEffectStream_05_Ch2:: ; $492C
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

SoundEffect_UnitListDelete_Ch1::
SoundEffectStream_06_Ch1:: ; $49CE
    sfx_envelope $44
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $0, $2c
    sfx_envelope $64
    sfx_frequency $1, $c9
    sfx_envelope $84
    sfx_frequency $2, $22
    sfx_envelope $c4
    sfx_duty $4
    sfx_frequency $2, $c6
    sfx_frequency $3, $58
    sfx_envelope $f4
    sfx_duty $0
    sfx_frequency $4, $16
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_envelope $44
    sfx_frequency $5, $ac
    sfx_frequency $6, $0b
    sfx_envelope $24
    sfx_frequency $6, $42
    sfx_end

SoundEffect_MedalDetail_Ch1::
SoundEffectStream_07_Ch1:: ; $49FA
    sfx_envelope $b4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $39
    sfx_envelope $44
    sfx_frequency $7, $39
    sfx_envelope $b4
    sfx_frequency $7, $6b
    sfx_envelope $44
    sfx_frequency $7, $39
    sfx_envelope $b4
    sfx_frequency $7, $7b
    sfx_envelope $44
    sfx_frequency $7, $6b
    sfx_envelope $b4
    sfx_frequency $7, $9d
    sfx_envelope $44
    sfx_frequency $7, $7b
    sfx_envelope $b4
    sfx_frequency $7, $b6
    sfx_envelope $44
    sfx_frequency $7, $9d
    sfx_envelope $b4
    sfx_frequency $7, $be
    sfx_envelope $44
    sfx_frequency $7, $9d
    sfx_frequency $7, $be
    sfx_envelope $34
    sfx_frequency $7, $be
    sfx_end

SoundEffect_UnitCreate_Ch1::
SoundEffectStream_08_Ch1:: ; $4A34
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $4
    sfx_frequency $6, $0b
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_frequency $6, $89
    sfx_envelope $e4
    sfx_frequency $6, $0b
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_frequency $6, $89
    sfx_envelope $d4
    sfx_frequency $6, $0b
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_frequency $6, $89
    sfx_envelope $c4
    sfx_frequency $6, $42
    sfx_frequency $6, $72
    sfx_frequency $6, $89
    sfx_frequency $6, $b2
    sfx_envelope $b4
    sfx_frequency $6, $72
    sfx_frequency $6, $89
    sfx_frequency $6, $b2
    sfx_frequency $6, $d6
    sfx_envelope $84
    sfx_frequency $6, $89
    sfx_frequency $6, $b2
    sfx_frequency $6, $d6
    sfx_frequency $6, $f6
    sfx_envelope $44
    sfx_frequency $6, $b2
    sfx_frequency $6, $d6
    sfx_frequency $6, $f6
    sfx_frequency $7, $05
    sfx_envelope $24
    sfx_frequency $6, $d6
    sfx_frequency $6, $f6
    sfx_frequency $7, $05
    sfx_frequency $7, $21
    sfx_end

SoundEffect_CursorMove_Ch1::
SoundEffectStream_09_Ch1:: ; $4A88
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $39
    sfx_envelope $84
    sfx_frequency $7, $6b
    sfx_envelope $64
    sfx_frequency $7, $39
    sfx_envelope $44
    sfx_frequency $7, $6b
    sfx_end

SoundEffect_Confirm_Ch1::
SoundEffectStream_0A_Ch1:: ; $4A9C
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $39
    sfx_frequency $7, $6b
    sfx_frequency $7, $39
    sfx_frequency $7, $6b
    sfx_frequency $7, $7b
    sfx_frequency $7, $6b
    sfx_frequency $7, $7b
    sfx_frequency $7, $9d
    sfx_frequency $7, $7b
    sfx_envelope $84
    sfx_frequency $7, $39
    sfx_frequency $7, $6b
    sfx_frequency $7, $39
    sfx_frequency $7, $6b
    sfx_frequency $7, $7b
    sfx_envelope $64
    sfx_frequency $7, $6b
    sfx_frequency $7, $7b
    sfx_frequency $7, $9d
    sfx_frequency $7, $7b
    sfx_envelope $44
    sfx_frequency $7, $39
    sfx_frequency $7, $6b
    sfx_frequency $7, $39
    sfx_frequency $7, $6b
    sfx_frequency $7, $7b
    sfx_envelope $24
    sfx_frequency $7, $6b
    sfx_frequency $7, $7b
    sfx_frequency $7, $9d
    sfx_frequency $7, $7b
    sfx_end

SoundEffectStream_0B_Ch1:: ; $4AE0
    sfx_envelope $84
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $2, $c6
    sfx_frequency $3, $12
    sfx_envelope $c4
    sfx_frequency $3, $58
    sfx_frequency $3, $9b
    sfx_envelope $f4
    sfx_frequency $4, $16
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_frequency $5, $11
    sfx_frequency $5, $3c
    sfx_envelope $c4
    sfx_frequency $5, $63
    sfx_frequency $5, $89
    sfx_envelope $84
    sfx_frequency $5, $ac
    sfx_frequency $5, $cd
    sfx_envelope $44
    sfx_frequency $6, $0b
    sfx_end

SoundEffect_Cancel_Ch1::
SoundEffectStream_0C_Ch1:: ; $4B0C
    sfx_envelope $84
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $6, $0b
    sfx_frequency $5, $cd
    sfx_envelope $c4
    sfx_frequency $5, $ac
    sfx_frequency $5, $89
    sfx_envelope $f4
    sfx_frequency $5, $63
    sfx_frequency $5, $3c
    sfx_frequency $5, $11
    sfx_envelope $f4
    sfx_frequency $4, $e5
    sfx_frequency $4, $83
    sfx_envelope $c4
    sfx_frequency $4, $16
    sfx_frequency $3, $9b
    sfx_envelope $84
    sfx_frequency $3, $58
    sfx_frequency $3, $12
    sfx_envelope $44
    sfx_frequency $2, $c6
    sfx_end

SoundEffect_EndTurn_Ch1::
SoundEffectStream_0D_Ch1:: ; $4B3A
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $4
    sfx_frequency $7, $7b
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_frequency $7, $9d
    sfx_wait $02
    sfx_frequency $7, $be
    sfx_wait $02
    sfx_frequency $7, $ce
    sfx_wait $02
    sfx_frequency $7, $df
    sfx_wait $02
    sfx_envelope $84
    sfx_frequency $7, $7b
    sfx_wait $02
    sfx_frequency $7, $9d
    sfx_wait $02
    sfx_frequency $7, $be
    sfx_wait $02
    sfx_frequency $7, $ce
    sfx_wait $02
    sfx_frequency $7, $df
    sfx_wait $02
    sfx_envelope $64
    sfx_frequency $7, $7b
    sfx_wait $02
    sfx_frequency $7, $9d
    sfx_wait $02
    sfx_frequency $7, $be
    sfx_wait $02
    sfx_frequency $7, $ce
    sfx_wait $02
    sfx_frequency $7, $df
    sfx_wait $02
    sfx_envelope $44
    sfx_frequency $7, $7b
    sfx_wait $02
    sfx_frequency $7, $9d
    sfx_wait $02
    sfx_frequency $7, $be
    sfx_wait $02
    sfx_frequency $7, $ce
    sfx_wait $02
    sfx_frequency $7, $df
    sfx_wait $02
    sfx_envelope $24
    sfx_frequency $7, $7b
    sfx_wait $02
    sfx_frequency $7, $9d
    sfx_wait $02
    sfx_frequency $7, $be
    sfx_wait $02
    sfx_frequency $7, $ce
    sfx_wait $02
    sfx_frequency $7, $df
    sfx_wait $02
    sfx_envelope $14
    sfx_frequency $7, $7b
    sfx_wait $02
    sfx_frequency $7, $9d
    sfx_wait $02
    sfx_frequency $7, $be
    sfx_wait $02
    sfx_frequency $7, $ce
    sfx_wait $02
    sfx_frequency $7, $df
    sfx_wait $02
    sfx_end

SoundEffectStream_0E_Ch1:: ; $4BC4
    sfx_envelope $94
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_envelope $64
    sfx_frequency $7, $ce
    sfx_envelope $34
    sfx_frequency $7, $d6
    sfx_end

SoundEffectStream_0F_Ch1:: ; $4BD6
    sfx_envelope $c4
    sfx_routing $11
    sfx_duty $4
    sfx_frequency $7, $b1
    sfx_frequency $7, $b6
    sfx_frequency $7, $ba
    sfx_frequency $7, $be
    sfx_frequency $7, $c1
    sfx_frequency $7, $c5
    sfx_frequency $7, $c8
    sfx_frequency $7, $cb
    sfx_frequency $7, $ce
    sfx_frequency $7, $d1
    sfx_frequency $7, $d4
    sfx_frequency $7, $d6
    sfx_envelope $84
    sfx_frequency $7, $b1
    sfx_frequency $7, $b6
    sfx_frequency $7, $ba
    sfx_frequency $7, $be
    sfx_frequency $7, $c1
    sfx_frequency $7, $c5
    sfx_frequency $7, $c8
    sfx_frequency $7, $cb
    sfx_frequency $7, $ce
    sfx_frequency $7, $d1
    sfx_frequency $7, $d4
    sfx_frequency $7, $d6
    sfx_envelope $64
    sfx_frequency $7, $b1
    sfx_frequency $7, $b6
    sfx_frequency $7, $ba
    sfx_frequency $7, $be
    sfx_frequency $7, $c1
    sfx_frequency $7, $c5
    sfx_frequency $7, $c8
    sfx_frequency $7, $cb
    sfx_frequency $7, $ce
    sfx_frequency $7, $d1
    sfx_frequency $7, $d4
    sfx_frequency $7, $d6
    sfx_envelope $44
    sfx_frequency $7, $b1
    sfx_frequency $7, $b6
    sfx_frequency $7, $ba
    sfx_frequency $7, $be
    sfx_frequency $7, $c1
    sfx_frequency $7, $c5
    sfx_frequency $7, $c8
    sfx_frequency $7, $cb
    sfx_frequency $7, $ce
    sfx_frequency $7, $d1
    sfx_frequency $7, $d4
    sfx_frequency $7, $d6
    sfx_end

SoundEffectStream_10_Ch1:: ; $4C42
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
    sfx_envelope $24
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

SoundEffectStream_10_Ch4:: ; $4CE4
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $5c
    sfx_frequency $0, $6c
    sfx_frequency $0, $5c
    sfx_frequency $0, $6c
    sfx_frequency $0, $5c
    sfx_frequency $0, $6c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $04
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
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
    sfx_envelope $80
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
    sfx_envelope $40
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
    sfx_envelope $20
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
    sfx_end

SoundEffect_PropertyCapture_Ch1::
SoundEffectStream_11_Ch1:: ; $4D73
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $4f
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_end

SoundEffect_WaitAction_Ch1::
SoundEffectStream_12_Ch1:: ; $4DBB
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $4f
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_end

SoundEffect_DevelopProperty_Ch1::
SoundEffectStream_13_Ch1:: ; $4E03
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $4f
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_end

SoundEffect_ActionExecute_Ch1::
SoundEffectStream_14_Ch1:: ; $4E4B
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $4f
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_end

SoundEffect_TransportLoad_Ch1::
SoundEffectStream_15_Ch1:: ; $4E93
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $4f
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_end

SoundEffectStream_16_Ch1:: ; $4EDB
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffect_Supply_Ch1::
SoundEffectStream_17_Ch1:: ; $4EEB
    sfx_envelope $e4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $4f
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_end

SoundEffectStream_18_Ch1:: ; $4F33
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $7, $ce
    sfx_frequency $7, $cb
    sfx_frequency $7, $c8
    sfx_frequency $7, $c5
    sfx_frequency $7, $c1
    sfx_frequency $7, $be
    sfx_frequency $7, $ba
    sfx_frequency $7, $b6
    sfx_frequency $7, $b1
    sfx_frequency $7, $ac
    sfx_frequency $7, $a7
    sfx_frequency $7, $a2
    sfx_envelope $84
    sfx_duty $4
    sfx_frequency $7, $9d
    sfx_frequency $7, $97
    sfx_frequency $7, $90
    sfx_frequency $7, $8a
    sfx_frequency $7, $83
    sfx_frequency $7, $7b
    sfx_frequency $7, $73
    sfx_envelope $64
    sfx_frequency $7, $6b
    sfx_frequency $7, $62
    sfx_frequency $7, $59
    sfx_frequency $7, $4f
    sfx_frequency $7, $44
    sfx_envelope $44
    sfx_duty $8
    sfx_frequency $7, $39
    sfx_frequency $7, $2d
    sfx_frequency $7, $21
    sfx_frequency $7, $14
    sfx_frequency $7, $05
    sfx_frequency $6, $f6
    sfx_frequency $6, $e7
    sfx_envelope $24
    sfx_frequency $6, $d6
    sfx_frequency $6, $c4
    sfx_frequency $6, $b2
    sfx_frequency $6, $9e
    sfx_frequency $6, $89
    sfx_end

SoundEffectStream_18_Ch4:: ; $4F8B
    sfx_routing $11
    sfx_envelope $20
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_envelope $40
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_frequency $0, $34
    sfx_envelope $60
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_envelope $80
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_envelope $f0
    sfx_frequency $0, $14
    sfx_frequency $0, $14
    sfx_frequency $0, $14
    sfx_frequency $0, $14
    sfx_envelope $80
    sfx_frequency $0, $68
    sfx_frequency $0, $68
    sfx_frequency $0, $69
    sfx_frequency $0, $69
    sfx_envelope $60
    sfx_frequency $0, $6a
    sfx_frequency $0, $6a
    sfx_frequency $0, $6b
    sfx_frequency $0, $6b
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6d
    sfx_envelope $20
    sfx_frequency $0, $6e
    sfx_frequency $0, $6e
    sfx_frequency $0, $6f
    sfx_frequency $0, $6f
    sfx_end

; SFX command streams, IDs $19-$1C ().

SoundEffectStream_19_Ch1:: ; $4FEA
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $6, $0b
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_frequency $6, $d6
    sfx_frequency $7, $05
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_frequency $7, $6b
    sfx_frequency $7, $83
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $b6
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_envelope $84
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_envelope $84
    sfx_frequency $6, $0b
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_frequency $6, $d6
    sfx_frequency $7, $05
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_frequency $7, $6b
    sfx_frequency $7, $83
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $b6
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_envelope $64
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_envelope $64
    sfx_frequency $6, $0b
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_frequency $6, $d6
    sfx_frequency $7, $05
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_frequency $7, $6b
    sfx_frequency $7, $83
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $b6
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_envelope $44
    sfx_frequency $6, $0b
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_frequency $6, $d6
    sfx_frequency $7, $05
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_frequency $7, $6b
    sfx_frequency $7, $83
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $b6
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_envelope $24
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_envelope $24
    sfx_frequency $6, $0b
    sfx_frequency $6, $72
    sfx_frequency $6, $b2
    sfx_frequency $6, $d6
    sfx_frequency $7, $05
    sfx_frequency $7, $39
    sfx_frequency $7, $59
    sfx_frequency $7, $6b
    sfx_frequency $7, $83
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $b6
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_envelope $14
    sfx_frequency $7, $c1
    sfx_frequency $7, $ce
    sfx_frequency $7, $d6
    sfx_frequency $7, $db
    sfx_end

SoundEffectStream_1A_Ch1:: ; $50CA
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $b6
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $a4
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $14
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_end

SoundEffectStream_1B_Ch1:: ; $531C
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $b6
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $a4
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_envelope $14
    sfx_frequency $7, $b6
    sfx_wait $01
    sfx_frequency $7, $b1
    sfx_wait $01
    sfx_frequency $7, $ac
    sfx_wait $01
    sfx_frequency $7, $9d
    sfx_wait $01
    sfx_frequency $7, $90
    sfx_wait $01
    sfx_frequency $7, $83
    sfx_wait $01
    sfx_frequency $7, $6b
    sfx_wait $01
    sfx_frequency $7, $62
    sfx_wait $01
    sfx_frequency $7, $59
    sfx_wait $01
    sfx_frequency $7, $39
    sfx_wait $01
    sfx_frequency $7, $21
    sfx_wait $01
    sfx_frequency $7, $05
    sfx_wait $01
    sfx_frequency $6, $d6
    sfx_wait $01
    sfx_frequency $6, $c4
    sfx_wait $01
    sfx_frequency $6, $b2
    sfx_wait $01
    sfx_frequency $6, $72
    sfx_wait $01
    sfx_frequency $6, $42
    sfx_wait $01
    sfx_frequency $6, $0b
    sfx_wait $01
    sfx_frequency $5, $ac
    sfx_wait $01
    sfx_frequency $5, $89
    sfx_wait $01
    sfx_frequency $5, $63
    sfx_wait $01
    sfx_frequency $4, $e5
    sfx_wait $01
    sfx_frequency $4, $83
    sfx_wait $01
    sfx_frequency $4, $16
    sfx_wait $01
    sfx_end

SoundEffect_TitleStart_Ch1::
SoundEffectStream_1C_Ch1:: ; $556E
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $6, $9e
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_frequency $6, $f6
    sfx_wait $01
    sfx_frequency $7, $4f
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $c4
    sfx_frequency $6, $9e
    sfx_wait $01
    sfx_frequency $6, $f6
    sfx_wait $01
    sfx_frequency $7, $4f
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $a4
    sfx_frequency $6, $9e
    sfx_wait $01
    sfx_frequency $6, $f6
    sfx_wait $01
    sfx_frequency $7, $4f
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $84
    sfx_frequency $6, $9e
    sfx_wait $01
    sfx_frequency $6, $f6
    sfx_wait $01
    sfx_frequency $7, $4f
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $64
    sfx_frequency $6, $9e
    sfx_wait $01
    sfx_frequency $6, $f6
    sfx_wait $01
    sfx_frequency $7, $4f
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $44
    sfx_frequency $6, $9e
    sfx_wait $01
    sfx_frequency $6, $f6
    sfx_wait $01
    sfx_frequency $7, $4f
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_envelope $24
    sfx_frequency $6, $9e
    sfx_wait $01
    sfx_frequency $6, $f6
    sfx_wait $01
    sfx_frequency $7, $4f
    sfx_wait $01
    sfx_frequency $7, $7b
    sfx_wait $01
    sfx_frequency $7, $a7
    sfx_wait $01
    sfx_frequency $7, $be
    sfx_wait $01
    sfx_frequency $7, $d4
    sfx_wait $01
    sfx_frequency $7, $df
    sfx_wait $01
    sfx_end

SoundEffectStream_1D_Ch1:: ; $5662
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $0
    sfx_frequency $0, $2c
    sfx_frequency $1, $06
    sfx_frequency $1, $c9
    sfx_frequency $2, $c6
    sfx_envelope $54
    sfx_frequency $0, $2c
    sfx_frequency $1, $06
    sfx_frequency $1, $c9
    sfx_frequency $2, $c6
    sfx_envelope $f4
    sfx_frequency $1, $06
    sfx_frequency $1, $c9
    sfx_frequency $2, $c6
    sfx_frequency $4, $16
    sfx_envelope $54
    sfx_frequency $0, $2c
    sfx_frequency $1, $06
    sfx_frequency $1, $c9
    sfx_frequency $2, $c6
    sfx_envelope $f4
    sfx_frequency $1, $c9
    sfx_frequency $2, $c6
    sfx_frequency $4, $16
    sfx_frequency $4, $83
    sfx_envelope $54
    sfx_frequency $1, $06
    sfx_frequency $1, $c9
    sfx_frequency $2, $c6
    sfx_frequency $4, $16
    sfx_envelope $f4
    sfx_frequency $2, $c6
    sfx_frequency $4, $16
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_envelope $54
    sfx_frequency $1, $06
    sfx_frequency $1, $c9
    sfx_frequency $2, $c6
    sfx_frequency $4, $16
    sfx_envelope $f4
    sfx_frequency $4, $16
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_envelope $54
    sfx_frequency $2, $c6
    sfx_frequency $4, $16
    sfx_frequency $4, $83
    sfx_frequency $4, $e5
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
    sfx_frequency $4, $e5
    sfx_frequency $5, $63
    sfx_frequency $6, $0b
    sfx_frequency $6, $42
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
    sfx_envelope $f4
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_envelope $54
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
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
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_envelope $24
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_envelope $44
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_envelope $24
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_envelope $24
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_frequency $7, $c1
    sfx_envelope $14
    sfx_frequency $7, $83
    sfx_frequency $7, $90
    sfx_frequency $7, $9d
    sfx_frequency $7, $ac
    sfx_end

SoundEffectStream_1D_Ch4:: ; $581E
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
    sfx_envelope $10
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

SoundEffectStream_1E_Ch4:: ; $5967
    sfx_routing $11
    sfx_envelope $90
    sfx_frequency $0, $41
    sfx_frequency $0, $11
    sfx_frequency $0, $41
    sfx_frequency $0, $11
    sfx_envelope $20
    sfx_frequency $0, $41
    sfx_frequency $0, $41
    sfx_end

SoundEffectStream_1F_Ch1:: ; $597A
    sfx_envelope $83
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $7b
    sfx_frequency $7, $6b
    sfx_frequency $7, $59
    sfx_frequency $7, $44
    sfx_frequency $7, $39
    sfx_frequency $7, $21
    sfx_frequency $7, $05
    sfx_envelope $63
    sfx_frequency $6, $f6
    sfx_frequency $6, $d6
    sfx_envelope $43
    sfx_frequency $6, $b2
    sfx_frequency $6, $89
    sfx_envelope $23
    sfx_frequency $6, $72
    sfx_frequency $6, $42
    sfx_envelope $13
    sfx_frequency $6, $0b
    sfx_end

SoundEffectStream_1F_Ch4:: ; $59A4
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_envelope $80
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_envelope $40
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_envelope $20
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_end

SoundEffectStream_20_Ch1:: ; $59DD
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

SoundEffectStream_20_Ch4:: ; $59FD
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

SoundEffect_SpriteExit_Ch1::
SoundEffectStream_21_Ch1:: ; $5A62
    sfx_envelope $d3
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $5, $ed
    sfx_frequency $6, $0b
    sfx_frequency $6, $28
    sfx_frequency $6, $42
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $d3
    sfx_sweep $1f
    sfx_frequency $5, $ed
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_envelope $c3
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $6, $f6
    sfx_frequency $7, $05
    sfx_frequency $7, $14
    sfx_frequency $7, $21
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $00
    sfx_envelope $c3
    sfx_sweep $1f
    sfx_frequency $6, $f6
    sfx_wait $27
    sfx_end

SoundEffectStream_21_Ch4:: ; $5A9F
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
    sfx_frequency $0, $11
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
    sfx_envelope $80
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $60
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $20
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_end

SoundEffectStream_22_Ch1:: ; $5AF0
    sfx_envelope $74
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $7, $be
    sfx_pitch_delta $00
    sfx_wait $18
    sfx_end

SoundEffectStream_22_Ch4:: ; $5AFE
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
    sfx_envelope $80
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_envelope $60
    sfx_frequency $0, $02
    sfx_envelope $40
    sfx_frequency $0, $02
    sfx_envelope $20
    sfx_frequency $0, $02
    sfx_end

SoundEffectStream_23_Ch1:: ; $5B33
    sfx_envelope $80
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
    sfx_envelope $60
    sfx_frequency $7, $be
    sfx_frequency $7, $ba
    sfx_frequency $7, $be
    sfx_frequency $7, $ba
    sfx_frequency $7, $b6
    sfx_frequency $7, $ba
    sfx_frequency $7, $b6
    sfx_frequency $7, $b1
    sfx_frequency $7, $b6
    sfx_frequency $7, $b1
    sfx_frequency $7, $ac
    sfx_frequency $7, $b1
    sfx_frequency $7, $ac
    sfx_frequency $7, $a7
    sfx_frequency $7, $ac
    sfx_frequency $7, $a7
    sfx_frequency $7, $a2
    sfx_frequency $7, $a7
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
    sfx_envelope $40
    sfx_frequency $7, $7b
    sfx_frequency $7, $73
    sfx_frequency $7, $7b
    sfx_frequency $7, $73
    sfx_frequency $7, $6b
    sfx_frequency $7, $73
    sfx_frequency $7, $6b
    sfx_frequency $7, $62
    sfx_frequency $7, $6b
    sfx_frequency $7, $62
    sfx_frequency $7, $59
    sfx_frequency $7, $62
    sfx_frequency $7, $59
    sfx_frequency $7, $4f
    sfx_frequency $7, $59
    sfx_frequency $7, $4f
    sfx_frequency $7, $44
    sfx_frequency $7, $4f
    sfx_frequency $7, $44
    sfx_frequency $7, $39
    sfx_frequency $7, $44
    sfx_frequency $7, $39
    sfx_frequency $7, $2d
    sfx_frequency $7, $39
    sfx_frequency $7, $2d
    sfx_frequency $7, $21
    sfx_frequency $7, $2d
    sfx_frequency $7, $21
    sfx_frequency $7, $14
    sfx_frequency $7, $21
    sfx_frequency $7, $14
    sfx_frequency $7, $05
    sfx_frequency $7, $14
    sfx_frequency $7, $05
    sfx_frequency $6, $f6
    sfx_frequency $7, $05
    sfx_envelope $20
    sfx_frequency $6, $f6
    sfx_frequency $6, $e7
    sfx_frequency $6, $f6
    sfx_frequency $6, $e7
    sfx_frequency $6, $d6
    sfx_frequency $6, $e7
    sfx_frequency $6, $d6
    sfx_frequency $6, $c4
    sfx_frequency $6, $d6
    sfx_frequency $6, $c4
    sfx_frequency $6, $b2
    sfx_frequency $6, $c4
    sfx_frequency $6, $b2
    sfx_frequency $6, $9e
    sfx_frequency $6, $b2
    sfx_frequency $6, $9e
    sfx_frequency $6, $89
    sfx_frequency $6, $9e
    sfx_frequency $6, $89
    sfx_frequency $6, $72
    sfx_frequency $6, $89
    sfx_frequency $6, $72
    sfx_frequency $6, $5b
    sfx_frequency $6, $72
    sfx_frequency $6, $5b
    sfx_frequency $6, $42
    sfx_frequency $6, $5b
    sfx_frequency $6, $42
    sfx_frequency $6, $28
    sfx_frequency $6, $42
    sfx_frequency $6, $28
    sfx_frequency $6, $0b
    sfx_frequency $6, $28
    sfx_frequency $6, $0b
    sfx_frequency $5, $ed
    sfx_frequency $6, $0b
    sfx_envelope $10
    sfx_frequency $5, $ed
    sfx_frequency $5, $cd
    sfx_frequency $5, $ed
    sfx_frequency $5, $cd
    sfx_frequency $5, $ac
    sfx_frequency $5, $cd
    sfx_frequency $5, $ac
    sfx_frequency $5, $89
    sfx_frequency $5, $ac
    sfx_frequency $5, $89
    sfx_frequency $5, $63
    sfx_frequency $5, $89
    sfx_frequency $5, $63
    sfx_frequency $5, $3c
    sfx_frequency $5, $63
    sfx_frequency $5, $3c
    sfx_frequency $5, $11
    sfx_frequency $5, $3c
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $5, $11
    sfx_frequency $4, $e5
    sfx_frequency $4, $b5
    sfx_frequency $4, $e5
    sfx_frequency $4, $b5
    sfx_frequency $4, $83
    sfx_frequency $4, $b5
    sfx_frequency $4, $83
    sfx_frequency $4, $4e
    sfx_frequency $4, $83
    sfx_frequency $4, $4e
    sfx_frequency $4, $16
    sfx_frequency $4, $4e
    sfx_frequency $4, $16
    sfx_frequency $3, $da
    sfx_frequency $4, $16
    sfx_end

SoundEffectStream_24_Ch1:: ; $5CA9
    sfx_envelope $a4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $4, $16
    sfx_frequency $4, $4e
    sfx_frequency $4, $83
    sfx_frequency $4, $b5
    sfx_frequency $4, $83
    sfx_frequency $4, $4e
    sfx_frequency $4, $16
    sfx_envelope $84
    sfx_frequency $3, $da
    sfx_frequency $3, $9b
    sfx_frequency $3, $58
    sfx_envelope $44
    sfx_frequency $3, $12
    sfx_frequency $2, $c6
    sfx_frequency $2, $78
    sfx_envelope $24
    sfx_frequency $2, $22
    sfx_frequency $1, $c9
    sfx_frequency $1, $6b
    sfx_frequency $1, $06
    sfx_envelope $14
    sfx_frequency $0, $9c
    sfx_frequency $0, $2c
    sfx_end

SoundEffectStream_24_Ch4:: ; $5CDD
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_envelope $80
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_envelope $60
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_envelope $40
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_envelope $20
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_frequency $0, $7a
    sfx_end

SoundEffectStream_25_Ch4:: ; $5D22
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $24
    sfx_frequency $0, $24
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $14
    sfx_frequency $0, $11
    sfx_envelope $80
    sfx_frequency $0, $34
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $34
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_end

SoundEffectStream_26_Ch1:: ; $5D4B
    sfx_envelope $87
    sfx_routing $11
    sfx_duty $4
    sfx_frequency $7, $a7
    sfx_frequency $7, $b6
    sfx_frequency $7, $a7
    sfx_envelope $67
    sfx_frequency $7, $a7
    sfx_frequency $7, $b6
    sfx_frequency $7, $a7
    sfx_envelope $37
    sfx_frequency $7, $a7
    sfx_frequency $7, $b6
    sfx_frequency $7, $a7
    sfx_end

SoundEffectStream_26_Ch4:: ; $5D67
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $2d
    sfx_frequency $0, $2d
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $34
    sfx_frequency $0, $15
    sfx_frequency $0, $34
    sfx_frequency $0, $15
    sfx_frequency $0, $34
    sfx_frequency $0, $15
    sfx_envelope $80
    sfx_frequency $0, $34
    sfx_frequency $0, $24
    sfx_frequency $0, $34
    sfx_frequency $0, $24
    sfx_frequency $0, $34
    sfx_envelope $60
    sfx_frequency $0, $31
    sfx_frequency $0, $21
    sfx_frequency $0, $31
    sfx_frequency $0, $21
    sfx_frequency $0, $31
    sfx_envelope $40
    sfx_frequency $0, $34
    sfx_frequency $0, $44
    sfx_frequency $0, $34
    sfx_frequency $0, $44
    sfx_envelope $20
    sfx_frequency $0, $31
    sfx_frequency $0, $41
    sfx_frequency $0, $31
    sfx_end

SoundEffectStream_27_Ch1:: ; $5DB2
    sfx_envelope $d7
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $7, $7b
    sfx_pitch_delta $00
    sfx_wait $3b
    sfx_end

SoundEffectStream_27_Ch4:: ; $5DC0
    sfx_routing $11
    sfx_envelope $f0
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
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
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
    sfx_end

SoundEffectStream_28_Ch4:: ; $5E37
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

SoundEffectStream_29_Ch1:: ; $5E90
    sfx_loop_start $05
    sfx_envelope $87
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $7, $df
    sfx_pitch_delta $00
    sfx_wait $0b
    sfx_loop_repeat
    sfx_envelope $d7
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $7, $7b
    sfx_wait $1d
    sfx_end

SoundEffectStream_29_Ch4:: ; $5EAC
    sfx_routing $11
    sfx_loop_start $05
    sfx_envelope $f0
    sfx_frequency $0, $43
    sfx_frequency $0, $41
    sfx_frequency $0, $43
    sfx_frequency $0, $41
    sfx_frequency $0, $43
    sfx_frequency $0, $41
    sfx_frequency $0, $52
    sfx_frequency $0, $52
    sfx_frequency $0, $52
    sfx_frequency $0, $52
    sfx_frequency $0, $52
    sfx_frequency $0, $52
    sfx_loop_repeat
    sfx_frequency $0, $61
    sfx_frequency $0, $61
    sfx_frequency $0, $61
    sfx_frequency $0, $61
    sfx_frequency $0, $61
    sfx_frequency $0, $61
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
    sfx_envelope $80
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
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
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
    sfx_end

SoundEffectStream_2A_Ch1:: ; $5F26
    sfx_envelope $d7
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $7, $7b
    sfx_pitch_delta $00
    sfx_wait $3b
    sfx_end

SoundEffectStream_2A_Ch4:: ; $5F34
    sfx_routing $11
    sfx_envelope $f0
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
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
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
    sfx_end

SoundEffectStream_2B_Ch1:: ; $5FAB
    sfx_envelope $d7
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $7, $7b
    sfx_pitch_delta $00
    sfx_wait $0e
    sfx_end

SoundEffectStream_2B_Ch4:: ; $5FB9
    sfx_routing $11
    sfx_envelope $f0
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
    sfx_envelope $60
    sfx_frequency $0, $61
    sfx_frequency $0, $6c
    sfx_envelope $40
    sfx_frequency $0, $61
    sfx_envelope $20
    sfx_frequency $0, $6c
    sfx_end

SoundEffectStream_2C_Ch1:: ; $6010
    sfx_envelope $d7
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $7, $7b
    sfx_pitch_delta $00
    sfx_wait $3b
    sfx_end

SoundEffectStream_2C_Ch4:: ; $601E
    sfx_routing $11
    sfx_envelope $f0
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
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
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
    sfx_end

SoundEffectStream_2D_Ch1:: ; $6095
    sfx_envelope $f7
    sfx_routing $11
    sfx_duty $8
    sfx_sweep $1f
    sfx_frequency $3, $da
    sfx_pitch_delta $00
    sfx_wait $27
    sfx_end

SoundEffectStream_2D_Ch4:: ; $60A3
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $7d
    sfx_frequency $0, $7c
    sfx_frequency $0, $7d
    sfx_frequency $0, $7c
    sfx_frequency $0, $7d
    sfx_frequency $0, $7c
    sfx_frequency $0, $7d
    sfx_frequency $0, $7c
    sfx_frequency $0, $7d
    sfx_frequency $0, $7c
    sfx_frequency $0, $7d
    sfx_frequency $0, $7c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6c
    sfx_frequency $0, $6d
    sfx_frequency $0, $6c
    sfx_envelope $80
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
    sfx_envelope $40
    sfx_frequency $0, $6c
    sfx_frequency $0, $61
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
    sfx_end

SoundEffectStream_2E_Ch4:: ; $611A
    sfx_routing $11
    sfx_envelope $f0
    sfx_frequency $0, $13
    sfx_frequency $0, $13
    sfx_frequency $0, $13
    sfx_frequency $0, $13
    sfx_frequency $0, $00
    sfx_frequency $0, $00
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $f0
    sfx_envelope $f0
    sfx_frequency $0, $43
    sfx_frequency $0, $46
    sfx_frequency $0, $42
    sfx_frequency $0, $46
    sfx_frequency $0, $12
    sfx_frequency $0, $46
    sfx_envelope $80
    sfx_frequency $0, $12
    sfx_frequency $0, $46
    sfx_frequency $0, $12
    sfx_frequency $0, $46
    sfx_frequency $0, $12
    sfx_frequency $0, $12
    sfx_frequency $0, $46
    sfx_frequency $0, $12
    sfx_frequency $0, $46
    sfx_frequency $0, $12
    sfx_envelope $60
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $46
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_envelope $40
    sfx_frequency $0, $46
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $46
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $46
    sfx_frequency $0, $02
    sfx_frequency $0, $46
    sfx_frequency $0, $02
    sfx_envelope $20
    sfx_frequency $0, $02
    sfx_frequency $0, $46
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $46
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_frequency $0, $46
    sfx_frequency $0, $02
    sfx_frequency $0, $02
    sfx_end

SoundEffectStream_2F_Ch1:: ; $6191
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffectStream_30_Ch1:: ; $61A1
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffectStream_31_Ch1:: ; $61B1
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffectStream_32_Ch1:: ; $61C1
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffectStream_33_Ch1:: ; $61D1
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffectStream_34_Ch1:: ; $61E1
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffectStream_35_Ch1:: ; $61F1
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffectStream_36_Ch1:: ; $6201
    sfx_envelope $f4
    sfx_routing $11
    sfx_duty $8
    sfx_frequency $7, $ce
    sfx_envelope $64
    sfx_frequency $7, $db
    sfx_envelope $34
    sfx_frequency $7, $df
    sfx_end

SoundEffectStream_37_Ch1:: ; $6211
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
    sfx_loop_start $5a
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_38_Ch1:: ; $62A2
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
    sfx_loop_start $5a
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_38_Ch4:: ; $6333
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
    sfx_loop_start $18
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

SoundEffectStream_39_Ch4:: ; $6363
    sfx_routing $11
    sfx_envelope $e0
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $04
    sfx_pitch_delta $ff
    sfx_envelope $e0
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_frequency $0, $6c
    sfx_envelope $80
    sfx_frequency $0, $4c
    sfx_frequency $0, $4c
    sfx_envelope $40
    sfx_frequency $0, $4c
    sfx_frequency $0, $4c
    sfx_envelope $20
    sfx_frequency $0, $4c
    sfx_frequency $0, $4c
    sfx_end

SoundEffectStream_3A_Ch4:: ; $6394
    sfx_routing $11
    sfx_loop_start $08
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

SoundEffectStream_3B_Ch4:: ; $63AC
    sfx_routing $11
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $14
    sfx_pitch_delta $ff
    sfx_envelope $01
    sfx_loop_start $06
    sfx_envelope $a0
    sfx_frequency $0, $24
    sfx_frequency $0, $44
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $a0
    sfx_frequency $0, $22
    sfx_frequency $0, $11
    sfx_frequency $0, $22
    sfx_frequency $0, $11
    sfx_envelope $60
    sfx_frequency $0, $22
    sfx_frequency $0, $11
    sfx_frequency $0, $22
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $22
    sfx_frequency $0, $11
    sfx_envelope $20
    sfx_frequency $0, $22
    sfx_frequency $0, $11
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $19
    sfx_pitch_delta $ff
    sfx_envelope $20
    sfx_loop_repeat
    sfx_end

SoundEffectStream_3C_Ch4:: ; $63F4
    sfx_routing $11
    sfx_loop_start $04
    sfx_envelope $90
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $90
    sfx_loop_repeat
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $05
    sfx_pitch_delta $ff
    sfx_envelope $90
    sfx_loop_start $03
    sfx_envelope $90
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $90
    sfx_loop_repeat
    sfx_envelope $90
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_envelope $80
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_envelope $60
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_envelope $40
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_envelope $20
    sfx_frequency $0, $52
    sfx_frequency $0, $22
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $05
    sfx_pitch_delta $ff
    sfx_envelope $20
    sfx_loop_start $05
    sfx_envelope $90
    sfx_frequency $0, $51
    sfx_frequency $0, $21
    sfx_frequency $0, $51
    sfx_frequency $0, $21
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $90
    sfx_loop_repeat
    sfx_loop_start $05
    sfx_envelope $90
    sfx_frequency $0, $41
    sfx_frequency $0, $21
    sfx_frequency $0, $41
    sfx_frequency $0, $21
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $90
    sfx_loop_repeat
    sfx_loop_start $07
    sfx_envelope $90
    sfx_frequency $0, $41
    sfx_frequency $0, $21
    sfx_frequency $0, $41
    sfx_frequency $0, $21
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $90
    sfx_loop_repeat
    sfx_envelope $80
    sfx_frequency $0, $41
    sfx_frequency $0, $21
    sfx_envelope $60
    sfx_frequency $0, $41
    sfx_frequency $0, $21
    sfx_envelope $40
    sfx_frequency $0, $41
    sfx_frequency $0, $21
    sfx_envelope $20
    sfx_frequency $0, $41
    sfx_frequency $0, $21
    sfx_end

SoundEffectStream_3D_Ch4:: ; $64B8
    sfx_routing $11
    sfx_loop_start $16
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

SoundEffectStream_3E_Ch1:: ; $64D0
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
    sfx_loop_start $5a
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_3F_Ch1:: ; $6561
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
    sfx_loop_start $5a
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_3F_Ch4:: ; $65F2
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
    sfx_loop_start $18
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

SoundEffectStream_40_Ch4:: ; $6622
    sfx_routing $11
    sfx_loop_start $0a
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

SoundEffectStream_41_Ch1:: ; $663A
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
    sfx_loop_start $5a
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $e4
    sfx_loop_repeat
    sfx_end

SoundEffectStream_42_Ch1:: ; $66CB
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
    sfx_loop_start $5a
    sfx_frequency $4, $16
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $01
    sfx_pitch_delta $ff
    sfx_envelope $84
    sfx_loop_repeat
    sfx_end

SoundEffectStream_42_Ch4:: ; $675C
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
    sfx_frequency $0, $1d
    sfx_loop_start $18
    sfx_envelope $60
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_frequency $0, $2d
    sfx_frequency $0, $1d
    sfx_envelope $40
    sfx_frequency $0, $1d
    sfx_frequency $0, $1d
    sfx_loop_repeat
    sfx_end

SoundEffectStream_43_Ch4:: ; $678C
    sfx_routing $11
    sfx_loop_start $0a
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

SoundEffectStream_44_Ch4:: ; $67A4
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
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_envelope $60
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_envelope $40
    sfx_frequency $0, $18
    sfx_frequency $0, $11
    sfx_end

SoundEffectStream_45_Ch1:: ; $67DC
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
    sfx_envelope $a4
    sfx_frequency $5, $cd
    sfx_frequency $5, $ed
    sfx_envelope $00
    sfx_pitch_delta $00
    sfx_wait $02
    sfx_pitch_delta $ff
    sfx_envelope $a4
    sfx_loop_repeat
    sfx_end

