; Banked sprite animation streams and OAM frame layouts.
;
; Byte-authoritative to the Japanese retail ROM and referenced by SpriteAnimationPointers.
; Animation entries are 3 bytes (frame pointer + duration). The loop marker is
; intentionally only `dw 0`: Sprite_LoadAnimationFrame reads one byte beyond
; that marker, discards it, resets the animation index, and reloads entry 0.
;
; A frame begins with an OAM-piece count followed by four bytes per piece:
;   y offset, x offset, tile offset, attributes/flags.
; Offsets and attributes remain raw until individual effects/units prove more
; specific semantics. Keeping the raw bytes also makes ROM comparison direct.

macro sprite_anim_entry
    dw \1
    db \2
endm

macro sprite_anim_end
    dw 0
endm

macro sprite_oam_piece
    db \1, \2, \3, \4
endm

section "Sprite Animation Data 1C:7460", romx[$7460], bank[$1c]

SpriteFrame_1C_7460::
    db 2
    sprite_oam_piece $f8, $f8, $00, $40
    sprite_oam_piece $00, $f8, $00, $00

SpriteFrame_1C_7469::
    db 2
    sprite_oam_piece $f4, $f5, $01, $40
    sprite_oam_piece $04, $f5, $01, $00

SpriteFrame_1C_7472::
    db 4
    sprite_oam_piece $fb, $f4, $02, $40
    sprite_oam_piece $f3, $f4, $03, $40
    sprite_oam_piece $fd, $f4, $02, $00
    sprite_oam_piece $05, $f4, $03, $00

SpriteFrame_1C_7483::
    db 8
    sprite_oam_piece $f1, $f2, $07, $40
    sprite_oam_piece $f1, $ea, $06, $40
    sprite_oam_piece $f9, $f2, $05, $40
    sprite_oam_piece $f9, $ea, $04, $40
    sprite_oam_piece $07, $f2, $07, $00
    sprite_oam_piece $07, $ea, $06, $00
    sprite_oam_piece $ff, $f2, $05, $00
    sprite_oam_piece $ff, $ea, $04, $00

SpriteFrame_1C_74A4::
    db 12
    sprite_oam_piece $e9, $f2, $0d, $40
    sprite_oam_piece $e9, $ea, $0c, $40
    sprite_oam_piece $e9, $e2, $0b, $40
    sprite_oam_piece $f1, $f2, $0a, $40
    sprite_oam_piece $f1, $ea, $09, $40
    sprite_oam_piece $f1, $e2, $08, $40
    sprite_oam_piece $0f, $f2, $0d, $00
    sprite_oam_piece $0f, $ea, $0c, $00
    sprite_oam_piece $0f, $e2, $0b, $00
    sprite_oam_piece $07, $f2, $0a, $00
    sprite_oam_piece $07, $ea, $09, $00
    sprite_oam_piece $07, $e2, $08, $00

SpriteFrame_1C_74D5::
    db 4
    sprite_oam_piece $ee, $e7, $01, $40
    sprite_oam_piece $e6, $df, $01, $40
    sprite_oam_piece $0a, $e7, $01, $00
    sprite_oam_piece $12, $df, $01, $00

SpriteFrame_1C_74E6::
    db 2
    sprite_oam_piece $e4, $dd, $01, $40
    sprite_oam_piece $14, $dd, $01, $00

SpriteAnimation_CommunicationTowerElectricity::
SpriteAnimation_159:: ; $1C:$74EF
    sprite_anim_entry SpriteFrame_1C_7460, $04
    sprite_anim_entry SpriteFrame_1C_7469, $04
    sprite_anim_entry SpriteFrame_1C_7472, $04
    sprite_anim_entry SpriteFrame_1C_7483, $04
    sprite_anim_entry SpriteFrame_1C_74A4, $04
    sprite_anim_entry SpriteFrame_1C_74D5, $04
    sprite_anim_entry SpriteFrame_1C_74E6, $04
    sprite_anim_entry SpriteFrame_1C_7460, $04
    sprite_anim_entry SpriteFrame_1C_7469, $04
    sprite_anim_entry SpriteFrame_1C_7472, $04
    sprite_anim_entry SpriteFrame_1C_7483, $04
    sprite_anim_entry SpriteFrame_1C_74A4, $04
    sprite_anim_entry SpriteFrame_1C_74D5, $04
    sprite_anim_entry SpriteFrame_1C_74E6, $04
    sprite_anim_end

assert @ == $751b

section "Sprite Animation Data 1D:4000", romx[$4000], bank[$1d]

SpriteFrame_1D_4000::
    db 25
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_1D_4065::
    db 26
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_1D_40CE::
    db 25
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_1D_4133::
    db 25
    sprite_oam_piece $00, $0c, $42, $02
    sprite_oam_piece $00, $04, $41, $02
    sprite_oam_piece $00, $fc, $40, $02
    sprite_oam_piece $00, $f4, $3f, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $3e, $05
    sprite_oam_piece $f8, $04, $3d, $05
    sprite_oam_piece $f8, $fc, $3c, $05
    sprite_oam_piece $f8, $f4, $3b, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $3a, $04
    sprite_oam_piece $f0, $0c, $39, $02
    sprite_oam_piece $f0, $04, $38, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $f0, $fc, $37, $02
    sprite_oam_piece $f0, $f4, $36, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $35, $02
    sprite_oam_piece $e8, $04, $34, $02
    sprite_oam_piece $e8, $fc, $33, $02
    sprite_oam_piece $e8, $f4, $32, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_1D_4198::
    db 26
    sprite_oam_piece $00, $0c, $42, $02
    sprite_oam_piece $00, $04, $41, $02
    sprite_oam_piece $00, $fc, $40, $02
    sprite_oam_piece $00, $f4, $3f, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $3e, $05
    sprite_oam_piece $f8, $04, $3d, $05
    sprite_oam_piece $f8, $fc, $3c, $05
    sprite_oam_piece $f8, $f4, $3b, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $3a, $04
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $49, $02
    sprite_oam_piece $f0, $04, $48, $02
    sprite_oam_piece $f0, $fc, $37, $02
    sprite_oam_piece $f0, $f4, $47, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $46, $02
    sprite_oam_piece $e8, $04, $45, $02
    sprite_oam_piece $e8, $fc, $44, $02
    sprite_oam_piece $e8, $f4, $43, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_1D_4201::
    db 25
    sprite_oam_piece $00, $0c, $42, $02
    sprite_oam_piece $00, $04, $41, $02
    sprite_oam_piece $00, $fc, $40, $02
    sprite_oam_piece $00, $f4, $3f, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $3e, $05
    sprite_oam_piece $f8, $04, $3d, $05
    sprite_oam_piece $f8, $fc, $3c, $05
    sprite_oam_piece $f8, $f4, $3b, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $3a, $04
    sprite_oam_piece $f0, $04, $48, $02
    sprite_oam_piece $f0, $0c, $4f, $02
    sprite_oam_piece $f0, $fc, $4e, $02
    sprite_oam_piece $f0, $f4, $4d, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $4c, $02
    sprite_oam_piece $e8, $04, $4b, $02
    sprite_oam_piece $e8, $fc, $4a, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_1D_4266::
    db 25
    sprite_oam_piece $00, $ec, $42, $22
    sprite_oam_piece $00, $f4, $41, $22
    sprite_oam_piece $00, $fc, $40, $22
    sprite_oam_piece $00, $04, $3f, $22
    sprite_oam_piece $00, $0c, $14, $25
    sprite_oam_piece $00, $14, $13, $25
    sprite_oam_piece $f8, $ec, $3e, $25
    sprite_oam_piece $f8, $f4, $3d, $25
    sprite_oam_piece $f8, $fc, $3c, $25
    sprite_oam_piece $f8, $04, $3b, $22
    sprite_oam_piece $f8, $0c, $0e, $25
    sprite_oam_piece $f8, $14, $3a, $24
    sprite_oam_piece $f0, $ec, $39, $22
    sprite_oam_piece $f0, $f4, $38, $22
    sprite_oam_piece $f0, $0c, $08, $22
    sprite_oam_piece $f0, $14, $07, $22
    sprite_oam_piece $f0, $fc, $37, $22
    sprite_oam_piece $f0, $04, $36, $22
    sprite_oam_piece $e8, $e4, $06, $22
    sprite_oam_piece $e8, $ec, $35, $22
    sprite_oam_piece $e8, $f4, $34, $22
    sprite_oam_piece $e8, $fc, $33, $22
    sprite_oam_piece $e8, $04, $32, $22
    sprite_oam_piece $e8, $0c, $01, $22
    sprite_oam_piece $e8, $14, $00, $22

SpriteFrame_1D_42CB::
    db 26
    sprite_oam_piece $00, $ec, $42, $22
    sprite_oam_piece $00, $f4, $41, $22
    sprite_oam_piece $00, $fc, $40, $22
    sprite_oam_piece $00, $04, $3f, $22
    sprite_oam_piece $00, $0c, $14, $25
    sprite_oam_piece $00, $14, $13, $25
    sprite_oam_piece $f8, $ec, $3e, $25
    sprite_oam_piece $f8, $f4, $3d, $25
    sprite_oam_piece $f8, $fc, $3c, $25
    sprite_oam_piece $f8, $04, $3b, $22
    sprite_oam_piece $f8, $0c, $0e, $25
    sprite_oam_piece $f8, $14, $3a, $24
    sprite_oam_piece $f0, $e4, $25, $22
    sprite_oam_piece $f0, $ec, $49, $22
    sprite_oam_piece $f0, $f4, $48, $22
    sprite_oam_piece $f0, $fc, $37, $22
    sprite_oam_piece $f0, $04, $47, $22
    sprite_oam_piece $f0, $0c, $21, $22
    sprite_oam_piece $f0, $14, $20, $22
    sprite_oam_piece $e8, $e4, $1f, $22
    sprite_oam_piece $e8, $ec, $46, $22
    sprite_oam_piece $e8, $f4, $45, $22
    sprite_oam_piece $e8, $fc, $44, $22
    sprite_oam_piece $e8, $04, $43, $22
    sprite_oam_piece $e8, $0c, $1a, $22
    sprite_oam_piece $e8, $14, $19, $22

SpriteFrame_1D_4334::
    db 25
    sprite_oam_piece $00, $ec, $42, $22
    sprite_oam_piece $00, $f4, $41, $22
    sprite_oam_piece $00, $fc, $40, $22
    sprite_oam_piece $00, $04, $3f, $22
    sprite_oam_piece $00, $0c, $14, $25
    sprite_oam_piece $00, $14, $13, $25
    sprite_oam_piece $f8, $ec, $3e, $25
    sprite_oam_piece $f8, $f4, $3d, $25
    sprite_oam_piece $f8, $fc, $3c, $25
    sprite_oam_piece $f8, $04, $3b, $22
    sprite_oam_piece $f8, $0c, $0e, $25
    sprite_oam_piece $f8, $14, $3a, $24
    sprite_oam_piece $f0, $f4, $48, $22
    sprite_oam_piece $f0, $ec, $4f, $22
    sprite_oam_piece $f0, $fc, $4e, $22
    sprite_oam_piece $f0, $04, $4d, $22
    sprite_oam_piece $f0, $0c, $2e, $22
    sprite_oam_piece $f0, $14, $2d, $22
    sprite_oam_piece $e8, $e4, $2c, $22
    sprite_oam_piece $e8, $ec, $4c, $22
    sprite_oam_piece $e8, $f4, $4b, $22
    sprite_oam_piece $e8, $fc, $4a, $22
    sprite_oam_piece $e8, $04, $28, $22
    sprite_oam_piece $e8, $0c, $27, $22
    sprite_oam_piece $e8, $14, $26, $22

SpriteAnimation_003:: ; $1D:$4399
    sprite_anim_entry SpriteFrame_1D_4000, $01
    sprite_anim_end

SpriteAnimation_007:: ; $1D:$439E
    sprite_anim_entry SpriteFrame_1D_4133, $01
    sprite_anim_end

SpriteAnimation_001:: ; $1D:$43A3
    sprite_anim_entry SpriteFrame_1D_4000, $02
    sprite_anim_entry SpriteFrame_1D_4065, $02
    sprite_anim_entry SpriteFrame_1D_40CE, $02
    sprite_anim_end

SpriteAnimation_005:: ; $1D:$43AE
    sprite_anim_entry SpriteFrame_1D_4133, $02
    sprite_anim_entry SpriteFrame_1D_4198, $02
    sprite_anim_entry SpriteFrame_1D_4201, $02
    sprite_anim_end

SpriteAnimation_000:: ; $1D:$43B9
    sprite_anim_entry SpriteFrame_1D_4000, $0c
    sprite_anim_entry SpriteFrame_1D_4065, $0c
    sprite_anim_entry SpriteFrame_1D_40CE, $0b
    sprite_anim_entry SpriteFrame_1D_4000, $0b
    sprite_anim_entry SpriteFrame_1D_4065, $0a
    sprite_anim_entry SpriteFrame_1D_40CE, $0a
    sprite_anim_entry SpriteFrame_1D_4000, $09
    sprite_anim_entry SpriteFrame_1D_4065, $09
    sprite_anim_entry SpriteFrame_1D_40CE, $08
    sprite_anim_entry SpriteFrame_1D_4000, $08
    sprite_anim_entry SpriteFrame_1D_4065, $07
    sprite_anim_entry SpriteFrame_1D_40CE, $07
    sprite_anim_entry SpriteFrame_1D_4000, $06
    sprite_anim_entry SpriteFrame_1D_4065, $06
    sprite_anim_entry SpriteFrame_1D_40CE, $05
    sprite_anim_entry SpriteFrame_1D_4000, $05
    sprite_anim_entry SpriteFrame_1D_4065, $04
    sprite_anim_entry SpriteFrame_1D_40CE, $04
    sprite_anim_entry SpriteFrame_1D_4000, $03
    sprite_anim_entry SpriteFrame_1D_4065, $03
    sprite_anim_entry SpriteFrame_1D_40CE, $02
    sprite_anim_end

SpriteAnimation_004:: ; $1D:$43FA
    sprite_anim_entry SpriteFrame_1D_4133, $0c
    sprite_anim_entry SpriteFrame_1D_4198, $0c
    sprite_anim_entry SpriteFrame_1D_4201, $0b
    sprite_anim_entry SpriteFrame_1D_4133, $0b
    sprite_anim_entry SpriteFrame_1D_4198, $0a
    sprite_anim_entry SpriteFrame_1D_4201, $0a
    sprite_anim_entry SpriteFrame_1D_4133, $09
    sprite_anim_entry SpriteFrame_1D_4198, $09
    sprite_anim_entry SpriteFrame_1D_4201, $08
    sprite_anim_entry SpriteFrame_1D_4133, $08
    sprite_anim_entry SpriteFrame_1D_4198, $07
    sprite_anim_entry SpriteFrame_1D_4201, $07
    sprite_anim_entry SpriteFrame_1D_4133, $06
    sprite_anim_entry SpriteFrame_1D_4198, $06
    sprite_anim_entry SpriteFrame_1D_4201, $05
    sprite_anim_entry SpriteFrame_1D_4133, $05
    sprite_anim_entry SpriteFrame_1D_4198, $04
    sprite_anim_entry SpriteFrame_1D_4201, $04
    sprite_anim_entry SpriteFrame_1D_4133, $03
    sprite_anim_entry SpriteFrame_1D_4198, $03
    sprite_anim_entry SpriteFrame_1D_4201, $02
    sprite_anim_end

SpriteAnimation_002:: ; $1D:$443B
    sprite_anim_entry SpriteFrame_1D_4000, $02
    sprite_anim_entry SpriteFrame_1D_4065, $03
    sprite_anim_entry SpriteFrame_1D_40CE, $03
    sprite_anim_entry SpriteFrame_1D_4000, $04
    sprite_anim_entry SpriteFrame_1D_4065, $04
    sprite_anim_entry SpriteFrame_1D_40CE, $05
    sprite_anim_entry SpriteFrame_1D_4000, $05
    sprite_anim_entry SpriteFrame_1D_4065, $06
    sprite_anim_entry SpriteFrame_1D_40CE, $06
    sprite_anim_entry SpriteFrame_1D_4000, $07
    sprite_anim_entry SpriteFrame_1D_4065, $07
    sprite_anim_entry SpriteFrame_1D_40CE, $08
    sprite_anim_entry SpriteFrame_1D_4000, $08
    sprite_anim_entry SpriteFrame_1D_4065, $09
    sprite_anim_entry SpriteFrame_1D_40CE, $09
    sprite_anim_entry SpriteFrame_1D_4000, $0a
    sprite_anim_entry SpriteFrame_1D_4065, $0a
    sprite_anim_entry SpriteFrame_1D_40CE, $0b
    sprite_anim_entry SpriteFrame_1D_4000, $0b
    sprite_anim_entry SpriteFrame_1D_4065, $0c
    sprite_anim_entry SpriteFrame_1D_40CE, $0c
    sprite_anim_end

SpriteAnimation_006:: ; $1D:$447C
    sprite_anim_entry SpriteFrame_1D_4133, $02
    sprite_anim_entry SpriteFrame_1D_4198, $03
    sprite_anim_entry SpriteFrame_1D_4201, $03
    sprite_anim_entry SpriteFrame_1D_4133, $04
    sprite_anim_entry SpriteFrame_1D_4198, $04
    sprite_anim_entry SpriteFrame_1D_4201, $05
    sprite_anim_entry SpriteFrame_1D_4133, $05
    sprite_anim_entry SpriteFrame_1D_4198, $06
    sprite_anim_entry SpriteFrame_1D_4201, $06
    sprite_anim_entry SpriteFrame_1D_4133, $07
    sprite_anim_entry SpriteFrame_1D_4198, $07
    sprite_anim_entry SpriteFrame_1D_4201, $08
    sprite_anim_entry SpriteFrame_1D_4133, $08
    sprite_anim_entry SpriteFrame_1D_4198, $09
    sprite_anim_entry SpriteFrame_1D_4201, $09
    sprite_anim_entry SpriteFrame_1D_4133, $0a
    sprite_anim_entry SpriteFrame_1D_4198, $0a
    sprite_anim_entry SpriteFrame_1D_4201, $0b
    sprite_anim_entry SpriteFrame_1D_4133, $0b
    sprite_anim_entry SpriteFrame_1D_4198, $0c
    sprite_anim_entry SpriteFrame_1D_4201, $0c
    sprite_anim_end

SpriteAnimation_008:: ; $1D:$44BD
    sprite_anim_entry SpriteFrame_1D_4266, $02
    sprite_anim_entry SpriteFrame_1D_42CB, $02
    sprite_anim_entry SpriteFrame_1D_4334, $02
    sprite_anim_end

assert @ == $44c8

section "Sprite Animation Data 1D:4A1A", romx[$4a1a], bank[$1d]

SpriteFrame_1D_4A1A::
    db 25
    sprite_oam_piece $02, $fc, $18, $02
    sprite_oam_piece $02, $f4, $17, $02
    sprite_oam_piece $02, $ec, $16, $02
    sprite_oam_piece $02, $e4, $15, $02
    sprite_oam_piece $fa, $14, $14, $02
    sprite_oam_piece $fa, $0c, $13, $02
    sprite_oam_piece $fa, $04, $12, $02
    sprite_oam_piece $fa, $fc, $11, $02
    sprite_oam_piece $fa, $f4, $10, $02
    sprite_oam_piece $fa, $ec, $0f, $05
    sprite_oam_piece $fa, $e4, $0e, $02
    sprite_oam_piece $f2, $14, $0d, $02
    sprite_oam_piece $f2, $0c, $0c, $02
    sprite_oam_piece $f2, $04, $0b, $02
    sprite_oam_piece $f2, $fc, $0a, $02
    sprite_oam_piece $f2, $f4, $09, $02
    sprite_oam_piece $f2, $ec, $08, $04
    sprite_oam_piece $f2, $e4, $07, $02
    sprite_oam_piece $ea, $14, $06, $02
    sprite_oam_piece $ea, $0c, $05, $02
    sprite_oam_piece $ea, $04, $04, $02
    sprite_oam_piece $ea, $fc, $03, $02
    sprite_oam_piece $ea, $f4, $02, $02
    sprite_oam_piece $ea, $ec, $01, $02
    sprite_oam_piece $ea, $e4, $00, $02

SpriteFrame_1D_4A7F::
    db 24
    sprite_oam_piece $02, $fc, $18, $02
    sprite_oam_piece $02, $f4, $17, $02
    sprite_oam_piece $02, $ec, $16, $02
    sprite_oam_piece $02, $e4, $15, $02
    sprite_oam_piece $fa, $14, $14, $02
    sprite_oam_piece $fa, $0c, $13, $02
    sprite_oam_piece $fa, $04, $12, $02
    sprite_oam_piece $fa, $fc, $11, $02
    sprite_oam_piece $fa, $f4, $27, $02
    sprite_oam_piece $fa, $ec, $26, $05
    sprite_oam_piece $fa, $e4, $0e, $02
    sprite_oam_piece $f2, $14, $25, $02
    sprite_oam_piece $f2, $0c, $24, $02
    sprite_oam_piece $f2, $04, $23, $02
    sprite_oam_piece $f2, $fc, $22, $02
    sprite_oam_piece $f2, $f4, $21, $02
    sprite_oam_piece $f2, $ec, $20, $04
    sprite_oam_piece $f2, $e4, $1f, $02
    sprite_oam_piece $ea, $14, $1e, $02
    sprite_oam_piece $ea, $0c, $1d, $02
    sprite_oam_piece $ea, $fc, $1c, $02
    sprite_oam_piece $ea, $f4, $1b, $02
    sprite_oam_piece $ea, $ec, $1a, $02
    sprite_oam_piece $ea, $e4, $19, $02

SpriteFrame_1D_4AE0::
    db 24
    sprite_oam_piece $02, $fc, $18, $02
    sprite_oam_piece $02, $f4, $17, $02
    sprite_oam_piece $02, $ec, $16, $02
    sprite_oam_piece $02, $e4, $15, $02
    sprite_oam_piece $fa, $14, $14, $02
    sprite_oam_piece $fa, $0c, $13, $02
    sprite_oam_piece $fa, $04, $12, $02
    sprite_oam_piece $fa, $fc, $35, $02
    sprite_oam_piece $fa, $f4, $27, $02
    sprite_oam_piece $fa, $ec, $26, $05
    sprite_oam_piece $fa, $e4, $0e, $02
    sprite_oam_piece $f2, $14, $34, $02
    sprite_oam_piece $f2, $0c, $33, $02
    sprite_oam_piece $f2, $04, $32, $02
    sprite_oam_piece $f2, $fc, $31, $02
    sprite_oam_piece $f2, $f4, $30, $02
    sprite_oam_piece $f2, $ec, $2f, $04
    sprite_oam_piece $f2, $e4, $2e, $02
    sprite_oam_piece $ea, $14, $2d, $02
    sprite_oam_piece $ea, $0c, $2c, $02
    sprite_oam_piece $ea, $04, $2b, $02
    sprite_oam_piece $ea, $fc, $2a, $02
    sprite_oam_piece $ea, $f4, $29, $02
    sprite_oam_piece $ea, $ec, $28, $02

SpriteFrame_1D_4B41::
    db 26
    sprite_oam_piece $01, $14, $4f, $02
    sprite_oam_piece $01, $0c, $4e, $02
    sprite_oam_piece $01, $fc, $4d, $02
    sprite_oam_piece $01, $f4, $4c, $02
    sprite_oam_piece $01, $ec, $4b, $02
    sprite_oam_piece $01, $e4, $4a, $02
    sprite_oam_piece $f9, $14, $49, $02
    sprite_oam_piece $f9, $0c, $48, $02
    sprite_oam_piece $f9, $04, $47, $02
    sprite_oam_piece $f9, $fc, $46, $02
    sprite_oam_piece $f9, $f4, $45, $02
    sprite_oam_piece $f9, $ec, $44, $05
    sprite_oam_piece $f9, $e4, $43, $02
    sprite_oam_piece $f1, $14, $42, $02
    sprite_oam_piece $f1, $0c, $41, $02
    sprite_oam_piece $f1, $04, $40, $02
    sprite_oam_piece $f1, $fc, $3f, $02
    sprite_oam_piece $f1, $f4, $3e, $02
    sprite_oam_piece $f1, $ec, $3d, $04
    sprite_oam_piece $f1, $e4, $3c, $02
    sprite_oam_piece $e9, $14, $3b, $02
    sprite_oam_piece $e9, $04, $3a, $02
    sprite_oam_piece $e9, $fc, $39, $02
    sprite_oam_piece $e9, $f4, $38, $02
    sprite_oam_piece $e9, $ec, $37, $02
    sprite_oam_piece $e9, $e4, $36, $02

SpriteFrame_1D_4BAA::
    db 26
    sprite_oam_piece $01, $14, $4f, $02
    sprite_oam_piece $01, $0c, $4e, $02
    sprite_oam_piece $01, $fc, $4d, $02
    sprite_oam_piece $01, $f4, $4c, $02
    sprite_oam_piece $01, $ec, $4b, $02
    sprite_oam_piece $01, $e4, $4a, $02
    sprite_oam_piece $f9, $14, $5c, $02
    sprite_oam_piece $f9, $0c, $5b, $02
    sprite_oam_piece $f9, $04, $47, $02
    sprite_oam_piece $f9, $fc, $5a, $02
    sprite_oam_piece $f9, $f4, $45, $02
    sprite_oam_piece $f9, $ec, $44, $05
    sprite_oam_piece $f9, $e4, $43, $02
    sprite_oam_piece $f1, $14, $42, $02
    sprite_oam_piece $f1, $0c, $41, $02
    sprite_oam_piece $f1, $04, $59, $02
    sprite_oam_piece $f1, $fc, $58, $02
    sprite_oam_piece $f1, $f4, $57, $02
    sprite_oam_piece $f1, $ec, $56, $04
    sprite_oam_piece $f1, $e4, $55, $02
    sprite_oam_piece $e9, $14, $3b, $02
    sprite_oam_piece $e9, $04, $54, $02
    sprite_oam_piece $e9, $fc, $53, $02
    sprite_oam_piece $e9, $f4, $52, $02
    sprite_oam_piece $e9, $ec, $51, $02
    sprite_oam_piece $e9, $e4, $50, $02

SpriteFrame_1D_4C13::
    db 24
    sprite_oam_piece $01, $14, $4f, $02
    sprite_oam_piece $01, $0c, $4e, $02
    sprite_oam_piece $01, $fc, $4d, $02
    sprite_oam_piece $01, $f4, $4c, $02
    sprite_oam_piece $01, $ec, $4b, $02
    sprite_oam_piece $01, $e4, $4a, $02
    sprite_oam_piece $f9, $14, $67, $02
    sprite_oam_piece $f9, $0c, $66, $02
    sprite_oam_piece $f9, $04, $47, $02
    sprite_oam_piece $f9, $fc, $46, $02
    sprite_oam_piece $f9, $f4, $65, $02
    sprite_oam_piece $f9, $ec, $44, $05
    sprite_oam_piece $f9, $e4, $43, $02
    sprite_oam_piece $f1, $14, $42, $02
    sprite_oam_piece $f1, $0c, $41, $02
    sprite_oam_piece $f1, $04, $64, $02
    sprite_oam_piece $f1, $fc, $63, $02
    sprite_oam_piece $f1, $f4, $62, $02
    sprite_oam_piece $f1, $ec, $61, $04
    sprite_oam_piece $f1, $e4, $60, $02
    sprite_oam_piece $e9, $14, $3b, $02
    sprite_oam_piece $e9, $fc, $5f, $02
    sprite_oam_piece $e9, $f4, $5e, $02
    sprite_oam_piece $e9, $ec, $5d, $02

SpriteFrame_1D_4C74::
    db 26
    sprite_oam_piece $01, $e4, $4f, $22
    sprite_oam_piece $01, $ec, $4e, $22
    sprite_oam_piece $01, $fc, $4d, $22
    sprite_oam_piece $01, $04, $4c, $22
    sprite_oam_piece $01, $0c, $4b, $22
    sprite_oam_piece $01, $14, $4a, $22
    sprite_oam_piece $f9, $e4, $49, $22
    sprite_oam_piece $f9, $ec, $48, $22
    sprite_oam_piece $f9, $f4, $47, $22
    sprite_oam_piece $f9, $fc, $46, $22
    sprite_oam_piece $f9, $04, $45, $22
    sprite_oam_piece $f9, $0c, $44, $25
    sprite_oam_piece $f9, $14, $43, $22
    sprite_oam_piece $f1, $e4, $42, $22
    sprite_oam_piece $f1, $ec, $41, $22
    sprite_oam_piece $f1, $f4, $40, $22
    sprite_oam_piece $f1, $fc, $3f, $22
    sprite_oam_piece $f1, $04, $3e, $22
    sprite_oam_piece $f1, $0c, $3d, $24
    sprite_oam_piece $f1, $14, $3c, $22
    sprite_oam_piece $e9, $e4, $3b, $22
    sprite_oam_piece $e9, $f4, $3a, $22
    sprite_oam_piece $e9, $fc, $39, $22
    sprite_oam_piece $e9, $04, $38, $22
    sprite_oam_piece $e9, $0c, $37, $22
    sprite_oam_piece $e9, $14, $36, $22

SpriteFrame_1D_4CDD::
    db 26
    sprite_oam_piece $01, $e4, $4f, $22
    sprite_oam_piece $01, $ec, $4e, $22
    sprite_oam_piece $01, $fc, $4d, $22
    sprite_oam_piece $01, $04, $4c, $22
    sprite_oam_piece $01, $0c, $4b, $22
    sprite_oam_piece $01, $14, $4a, $22
    sprite_oam_piece $f9, $e4, $5c, $22
    sprite_oam_piece $f9, $ec, $5b, $22
    sprite_oam_piece $f9, $f4, $47, $22
    sprite_oam_piece $f9, $fc, $5a, $22
    sprite_oam_piece $f9, $04, $45, $22
    sprite_oam_piece $f9, $0c, $44, $25
    sprite_oam_piece $f9, $14, $43, $22
    sprite_oam_piece $f1, $e4, $42, $22
    sprite_oam_piece $f1, $ec, $41, $22
    sprite_oam_piece $f1, $f4, $59, $22
    sprite_oam_piece $f1, $fc, $58, $22
    sprite_oam_piece $f1, $04, $57, $22
    sprite_oam_piece $f1, $0c, $56, $24
    sprite_oam_piece $f1, $14, $55, $22
    sprite_oam_piece $e9, $e4, $3b, $22
    sprite_oam_piece $e9, $f4, $54, $22
    sprite_oam_piece $e9, $fc, $53, $22
    sprite_oam_piece $e9, $04, $52, $22
    sprite_oam_piece $e9, $0c, $51, $22
    sprite_oam_piece $e9, $14, $50, $22

SpriteFrame_1D_4D46::
    db 24
    sprite_oam_piece $01, $e4, $4f, $22
    sprite_oam_piece $01, $ec, $4e, $22
    sprite_oam_piece $01, $fc, $4d, $22
    sprite_oam_piece $01, $04, $4c, $22
    sprite_oam_piece $01, $0c, $4b, $22
    sprite_oam_piece $01, $14, $4a, $22
    sprite_oam_piece $f9, $e4, $67, $22
    sprite_oam_piece $f9, $ec, $66, $22
    sprite_oam_piece $f9, $f4, $47, $22
    sprite_oam_piece $f9, $fc, $46, $22
    sprite_oam_piece $f9, $04, $65, $22
    sprite_oam_piece $f9, $0c, $44, $25
    sprite_oam_piece $f9, $14, $43, $22
    sprite_oam_piece $f1, $e4, $42, $22
    sprite_oam_piece $f1, $ec, $41, $22
    sprite_oam_piece $f1, $f4, $64, $22
    sprite_oam_piece $f1, $fc, $63, $22
    sprite_oam_piece $f1, $04, $62, $22
    sprite_oam_piece $f1, $0c, $61, $24
    sprite_oam_piece $f1, $14, $60, $22
    sprite_oam_piece $e9, $e4, $3b, $22
    sprite_oam_piece $e9, $fc, $5f, $22
    sprite_oam_piece $e9, $04, $5e, $22
    sprite_oam_piece $e9, $0c, $5d, $22

SpriteAnimation_012:: ; $1D:$4DA7
    sprite_anim_entry SpriteFrame_1D_4A1A, $01
    sprite_anim_end

SpriteAnimation_016:: ; $1D:$4DAC
    sprite_anim_entry SpriteFrame_1D_4B41, $01
    sprite_anim_end

SpriteAnimation_010:: ; $1D:$4DB1
    sprite_anim_entry SpriteFrame_1D_4A1A, $02
    sprite_anim_entry SpriteFrame_1D_4A7F, $02
    sprite_anim_entry SpriteFrame_1D_4AE0, $02
    sprite_anim_end

SpriteAnimation_014:: ; $1D:$4DBC
    sprite_anim_entry SpriteFrame_1D_4B41, $02
    sprite_anim_entry SpriteFrame_1D_4BAA, $02
    sprite_anim_entry SpriteFrame_1D_4C13, $02
    sprite_anim_end

SpriteAnimation_009:: ; $1D:$4DC7
    sprite_anim_entry SpriteFrame_1D_4A1A, $0c
    sprite_anim_entry SpriteFrame_1D_4A7F, $0c
    sprite_anim_entry SpriteFrame_1D_4AE0, $0b
    sprite_anim_entry SpriteFrame_1D_4A1A, $0b
    sprite_anim_entry SpriteFrame_1D_4A7F, $0a
    sprite_anim_entry SpriteFrame_1D_4AE0, $0a
    sprite_anim_entry SpriteFrame_1D_4A1A, $09
    sprite_anim_entry SpriteFrame_1D_4A7F, $09
    sprite_anim_entry SpriteFrame_1D_4AE0, $08
    sprite_anim_entry SpriteFrame_1D_4A1A, $08
    sprite_anim_entry SpriteFrame_1D_4A7F, $07
    sprite_anim_entry SpriteFrame_1D_4AE0, $07
    sprite_anim_entry SpriteFrame_1D_4A1A, $06
    sprite_anim_entry SpriteFrame_1D_4A7F, $06
    sprite_anim_entry SpriteFrame_1D_4AE0, $05
    sprite_anim_entry SpriteFrame_1D_4A1A, $05
    sprite_anim_entry SpriteFrame_1D_4A7F, $04
    sprite_anim_entry SpriteFrame_1D_4AE0, $04
    sprite_anim_entry SpriteFrame_1D_4A1A, $03
    sprite_anim_entry SpriteFrame_1D_4A7F, $03
    sprite_anim_entry SpriteFrame_1D_4AE0, $02
    sprite_anim_end

SpriteAnimation_013:: ; $1D:$4E08
    sprite_anim_entry SpriteFrame_1D_4B41, $0c
    sprite_anim_entry SpriteFrame_1D_4BAA, $0c
    sprite_anim_entry SpriteFrame_1D_4C13, $0b
    sprite_anim_entry SpriteFrame_1D_4B41, $0b
    sprite_anim_entry SpriteFrame_1D_4BAA, $0a
    sprite_anim_entry SpriteFrame_1D_4C13, $0a
    sprite_anim_entry SpriteFrame_1D_4B41, $09
    sprite_anim_entry SpriteFrame_1D_4BAA, $09
    sprite_anim_entry SpriteFrame_1D_4C13, $08
    sprite_anim_entry SpriteFrame_1D_4B41, $08
    sprite_anim_entry SpriteFrame_1D_4BAA, $07
    sprite_anim_entry SpriteFrame_1D_4C13, $07
    sprite_anim_entry SpriteFrame_1D_4B41, $06
    sprite_anim_entry SpriteFrame_1D_4BAA, $06
    sprite_anim_entry SpriteFrame_1D_4C13, $05
    sprite_anim_entry SpriteFrame_1D_4B41, $05
    sprite_anim_entry SpriteFrame_1D_4BAA, $04
    sprite_anim_entry SpriteFrame_1D_4C13, $04
    sprite_anim_entry SpriteFrame_1D_4B41, $03
    sprite_anim_entry SpriteFrame_1D_4BAA, $03
    sprite_anim_entry SpriteFrame_1D_4C13, $02
    sprite_anim_end

SpriteAnimation_011:: ; $1D:$4E49
    sprite_anim_entry SpriteFrame_1D_4A1A, $02
    sprite_anim_entry SpriteFrame_1D_4A7F, $03
    sprite_anim_entry SpriteFrame_1D_4AE0, $03
    sprite_anim_entry SpriteFrame_1D_4A1A, $04
    sprite_anim_entry SpriteFrame_1D_4A7F, $04
    sprite_anim_entry SpriteFrame_1D_4AE0, $05
    sprite_anim_entry SpriteFrame_1D_4A1A, $05
    sprite_anim_entry SpriteFrame_1D_4A7F, $06
    sprite_anim_entry SpriteFrame_1D_4AE0, $06
    sprite_anim_entry SpriteFrame_1D_4A1A, $07
    sprite_anim_entry SpriteFrame_1D_4A7F, $07
    sprite_anim_entry SpriteFrame_1D_4AE0, $08
    sprite_anim_entry SpriteFrame_1D_4A1A, $08
    sprite_anim_entry SpriteFrame_1D_4A7F, $09
    sprite_anim_entry SpriteFrame_1D_4AE0, $09
    sprite_anim_entry SpriteFrame_1D_4A1A, $0a
    sprite_anim_entry SpriteFrame_1D_4A7F, $0a
    sprite_anim_entry SpriteFrame_1D_4AE0, $0b
    sprite_anim_entry SpriteFrame_1D_4A1A, $0b
    sprite_anim_entry SpriteFrame_1D_4A7F, $0c
    sprite_anim_entry SpriteFrame_1D_4AE0, $0c
    sprite_anim_end

SpriteAnimation_015:: ; $1D:$4E8A
    sprite_anim_entry SpriteFrame_1D_4B41, $02
    sprite_anim_entry SpriteFrame_1D_4BAA, $03
    sprite_anim_entry SpriteFrame_1D_4C13, $03
    sprite_anim_entry SpriteFrame_1D_4B41, $04
    sprite_anim_entry SpriteFrame_1D_4BAA, $04
    sprite_anim_entry SpriteFrame_1D_4C13, $05
    sprite_anim_entry SpriteFrame_1D_4B41, $05
    sprite_anim_entry SpriteFrame_1D_4BAA, $06
    sprite_anim_entry SpriteFrame_1D_4C13, $06
    sprite_anim_entry SpriteFrame_1D_4B41, $07
    sprite_anim_entry SpriteFrame_1D_4BAA, $07
    sprite_anim_entry SpriteFrame_1D_4C13, $08
    sprite_anim_entry SpriteFrame_1D_4B41, $08
    sprite_anim_entry SpriteFrame_1D_4BAA, $09
    sprite_anim_entry SpriteFrame_1D_4C13, $09
    sprite_anim_entry SpriteFrame_1D_4B41, $0a
    sprite_anim_entry SpriteFrame_1D_4BAA, $0a
    sprite_anim_entry SpriteFrame_1D_4C13, $0b
    sprite_anim_entry SpriteFrame_1D_4B41, $0b
    sprite_anim_entry SpriteFrame_1D_4BAA, $0c
    sprite_anim_entry SpriteFrame_1D_4C13, $0c
    sprite_anim_end

SpriteAnimation_017:: ; $1D:$4ECB
    sprite_anim_entry SpriteFrame_1D_4C74, $02
    sprite_anim_entry SpriteFrame_1D_4CDD, $02
    sprite_anim_entry SpriteFrame_1D_4D46, $02
    sprite_anim_end

assert @ == $4ed6

section "Sprite Animation Data 1D:55A8", romx[$55a8], bank[$1d]

SpriteFrame_1D_55A8::
    db 26
    sprite_oam_piece $00, $14, $19, $02
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $02, $04, $17, $02
    sprite_oam_piece $02, $fc, $16, $02
    sprite_oam_piece $02, $f4, $15, $02
    sprite_oam_piece $02, $ec, $14, $02
    sprite_oam_piece $02, $e4, $13, $05
    sprite_oam_piece $f8, $14, $12, $02
    sprite_oam_piece $f8, $0c, $11, $02
    sprite_oam_piece $fa, $04, $10, $02
    sprite_oam_piece $fa, $fc, $0f, $02
    sprite_oam_piece $fa, $f4, $0e, $02
    sprite_oam_piece $fa, $ec, $0d, $02
    sprite_oam_piece $fa, $e4, $0c, $05
    sprite_oam_piece $f0, $14, $0b, $02
    sprite_oam_piece $f0, $0c, $0a, $02
    sprite_oam_piece $f2, $04, $09, $02
    sprite_oam_piece $f2, $fc, $08, $02
    sprite_oam_piece $f2, $f4, $07, $02
    sprite_oam_piece $f2, $ec, $06, $02
    sprite_oam_piece $f2, $e4, $05, $05
    sprite_oam_piece $ea, $04, $04, $02
    sprite_oam_piece $ea, $fc, $03, $02
    sprite_oam_piece $ea, $f4, $02, $02
    sprite_oam_piece $ea, $ec, $01, $02
    sprite_oam_piece $ea, $e4, $00, $02

SpriteFrame_1D_5611::
    db 26
    sprite_oam_piece $00, $14, $19, $02
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $02, $04, $17, $02
    sprite_oam_piece $02, $fc, $16, $02
    sprite_oam_piece $02, $f4, $15, $02
    sprite_oam_piece $02, $ec, $14, $02
    sprite_oam_piece $02, $e4, $13, $05
    sprite_oam_piece $f8, $14, $29, $02
    sprite_oam_piece $f8, $0c, $28, $02
    sprite_oam_piece $fa, $04, $10, $02
    sprite_oam_piece $fa, $fc, $0f, $02
    sprite_oam_piece $fa, $f4, $27, $02
    sprite_oam_piece $fa, $ec, $26, $02
    sprite_oam_piece $fa, $e4, $0c, $05
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f2, $04, $23, $02
    sprite_oam_piece $f2, $fc, $22, $02
    sprite_oam_piece $f2, $f4, $21, $02
    sprite_oam_piece $f2, $ec, $20, $02
    sprite_oam_piece $f2, $e4, $1f, $04
    sprite_oam_piece $ea, $04, $1e, $02
    sprite_oam_piece $ea, $fc, $1d, $02
    sprite_oam_piece $ea, $f4, $1c, $02
    sprite_oam_piece $ea, $ec, $1b, $02
    sprite_oam_piece $ea, $e4, $1a, $02

SpriteFrame_1D_567A::
    db 25
    sprite_oam_piece $00, $14, $19, $02
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $02, $04, $17, $02
    sprite_oam_piece $02, $fc, $16, $02
    sprite_oam_piece $02, $f4, $15, $02
    sprite_oam_piece $02, $ec, $14, $02
    sprite_oam_piece $02, $e4, $13, $05
    sprite_oam_piece $f8, $14, $36, $02
    sprite_oam_piece $f8, $0c, $35, $02
    sprite_oam_piece $fa, $04, $10, $02
    sprite_oam_piece $fa, $fc, $0f, $02
    sprite_oam_piece $fa, $f4, $27, $02
    sprite_oam_piece $fa, $ec, $26, $02
    sprite_oam_piece $fa, $e4, $0c, $05
    sprite_oam_piece $f0, $14, $34, $02
    sprite_oam_piece $f0, $0c, $33, $02
    sprite_oam_piece $f2, $04, $32, $02
    sprite_oam_piece $f2, $fc, $31, $02
    sprite_oam_piece $f2, $f4, $30, $02
    sprite_oam_piece $f2, $ec, $2f, $02
    sprite_oam_piece $f2, $e4, $2e, $04
    sprite_oam_piece $ea, $fc, $2d, $02
    sprite_oam_piece $ea, $f4, $2c, $02
    sprite_oam_piece $ea, $ec, $2b, $02
    sprite_oam_piece $ea, $e4, $2a, $02

SpriteFrame_1D_56DF::
    db 17
    sprite_oam_piece $05, $08, $47, $02
    sprite_oam_piece $05, $00, $46, $02
    sprite_oam_piece $05, $f8, $45, $02
    sprite_oam_piece $fd, $10, $44, $02
    sprite_oam_piece $fd, $08, $43, $02
    sprite_oam_piece $fd, $00, $42, $02
    sprite_oam_piece $fd, $f8, $41, $02
    sprite_oam_piece $fd, $f0, $40, $02
    sprite_oam_piece $fd, $e8, $3f, $02
    sprite_oam_piece $f5, $10, $3e, $02
    sprite_oam_piece $f5, $08, $3d, $02
    sprite_oam_piece $f5, $00, $3c, $02
    sprite_oam_piece $f5, $f8, $3b, $02
    sprite_oam_piece $f5, $f0, $3a, $04
    sprite_oam_piece $f5, $e8, $39, $04
    sprite_oam_piece $ed, $10, $38, $02
    sprite_oam_piece $ed, $00, $37, $02

SpriteFrame_1D_5724::
    db 19
    sprite_oam_piece $05, $08, $47, $02
    sprite_oam_piece $05, $00, $46, $02
    sprite_oam_piece $05, $f8, $45, $02
    sprite_oam_piece $fd, $10, $44, $02
    sprite_oam_piece $fd, $08, $43, $02
    sprite_oam_piece $fd, $00, $42, $02
    sprite_oam_piece $fd, $f8, $41, $02
    sprite_oam_piece $fd, $f0, $40, $02
    sprite_oam_piece $fd, $e8, $3f, $02
    sprite_oam_piece $f5, $10, $3e, $02
    sprite_oam_piece $f5, $08, $3d, $02
    sprite_oam_piece $f5, $00, $3c, $02
    sprite_oam_piece $f5, $f8, $3b, $02
    sprite_oam_piece $f5, $f0, $3a, $04
    sprite_oam_piece $f5, $e8, $39, $04
    sprite_oam_piece $ed, $10, $38, $02
    sprite_oam_piece $ed, $00, $37, $02
    sprite_oam_piece $08, $09, $49, $07
    sprite_oam_piece $00, $09, $48, $07

SpriteFrame_1D_5771::
    db 19
    sprite_oam_piece $05, $08, $47, $02
    sprite_oam_piece $05, $00, $46, $02
    sprite_oam_piece $05, $f8, $45, $02
    sprite_oam_piece $fd, $10, $44, $02
    sprite_oam_piece $fd, $08, $43, $02
    sprite_oam_piece $fd, $00, $42, $02
    sprite_oam_piece $fd, $f8, $41, $02
    sprite_oam_piece $fd, $f0, $40, $02
    sprite_oam_piece $fd, $e8, $3f, $02
    sprite_oam_piece $f5, $10, $3e, $02
    sprite_oam_piece $f5, $08, $3d, $02
    sprite_oam_piece $f5, $00, $3c, $02
    sprite_oam_piece $f5, $f8, $3b, $02
    sprite_oam_piece $f5, $f0, $3a, $04
    sprite_oam_piece $f5, $e8, $39, $04
    sprite_oam_piece $ed, $10, $38, $02
    sprite_oam_piece $ed, $00, $37, $02
    sprite_oam_piece $08, $09, $4b, $07
    sprite_oam_piece $00, $09, $4a, $07

SpriteAnimation_021:: ; $1D:$57BE
    sprite_anim_entry SpriteFrame_1D_55A8, $01
    sprite_anim_end

SpriteAnimation_022:: ; $1D:$57C3
    sprite_anim_entry SpriteFrame_1D_56DF, $01
    sprite_anim_end

SpriteAnimation_019:: ; $1D:$57C8
    sprite_anim_entry SpriteFrame_1D_55A8, $02
    sprite_anim_entry SpriteFrame_1D_5611, $02
    sprite_anim_entry SpriteFrame_1D_567A, $02
    sprite_anim_end

SpriteAnimation_023:: ; $1D:$57D3
    sprite_anim_entry SpriteFrame_1D_5724, $02
    sprite_anim_entry SpriteFrame_1D_56DF, $02
    sprite_anim_entry SpriteFrame_1D_5771, $02
    sprite_anim_entry SpriteFrame_1D_56DF, $02
    sprite_anim_end

SpriteAnimation_018:: ; $1D:$57E1
    sprite_anim_entry SpriteFrame_1D_55A8, $0c
    sprite_anim_entry SpriteFrame_1D_5611, $0c
    sprite_anim_entry SpriteFrame_1D_567A, $0b
    sprite_anim_entry SpriteFrame_1D_55A8, $0b
    sprite_anim_entry SpriteFrame_1D_5611, $0a
    sprite_anim_entry SpriteFrame_1D_567A, $0a
    sprite_anim_entry SpriteFrame_1D_55A8, $09
    sprite_anim_entry SpriteFrame_1D_5611, $09
    sprite_anim_entry SpriteFrame_1D_567A, $08
    sprite_anim_entry SpriteFrame_1D_55A8, $08
    sprite_anim_entry SpriteFrame_1D_5611, $07
    sprite_anim_entry SpriteFrame_1D_567A, $07
    sprite_anim_entry SpriteFrame_1D_55A8, $06
    sprite_anim_entry SpriteFrame_1D_5611, $06
    sprite_anim_entry SpriteFrame_1D_567A, $05
    sprite_anim_entry SpriteFrame_1D_55A8, $05
    sprite_anim_entry SpriteFrame_1D_5611, $04
    sprite_anim_entry SpriteFrame_1D_567A, $04
    sprite_anim_entry SpriteFrame_1D_55A8, $03
    sprite_anim_entry SpriteFrame_1D_5611, $03
    sprite_anim_entry SpriteFrame_1D_567A, $02
    sprite_anim_end

SpriteAnimation_020:: ; $1D:$5822
    sprite_anim_entry SpriteFrame_1D_55A8, $02
    sprite_anim_entry SpriteFrame_1D_5611, $03
    sprite_anim_entry SpriteFrame_1D_567A, $03
    sprite_anim_entry SpriteFrame_1D_55A8, $04
    sprite_anim_entry SpriteFrame_1D_5611, $04
    sprite_anim_entry SpriteFrame_1D_567A, $05
    sprite_anim_entry SpriteFrame_1D_55A8, $05
    sprite_anim_entry SpriteFrame_1D_5611, $06
    sprite_anim_entry SpriteFrame_1D_567A, $06
    sprite_anim_entry SpriteFrame_1D_55A8, $07
    sprite_anim_entry SpriteFrame_1D_5611, $07
    sprite_anim_entry SpriteFrame_1D_567A, $08
    sprite_anim_entry SpriteFrame_1D_55A8, $08
    sprite_anim_entry SpriteFrame_1D_5611, $09
    sprite_anim_entry SpriteFrame_1D_567A, $09
    sprite_anim_entry SpriteFrame_1D_55A8, $0a
    sprite_anim_entry SpriteFrame_1D_5611, $0a
    sprite_anim_entry SpriteFrame_1D_567A, $0b
    sprite_anim_entry SpriteFrame_1D_55A8, $0b
    sprite_anim_entry SpriteFrame_1D_5611, $0c
    sprite_anim_entry SpriteFrame_1D_567A, $0c
    sprite_anim_end

assert @ == $5863

section "Sprite Animation Data 1D:5D6F", romx[$5d6f], bank[$1d]

SpriteFrame_1D_5D6F::
    db 14
    sprite_oam_piece $00, $0c, $0c, $02
    sprite_oam_piece $00, $04, $0b, $02
    sprite_oam_piece $00, $fc, $0b, $02
    sprite_oam_piece $00, $f4, $0a, $02
    sprite_oam_piece $00, $ec, $09, $02
    sprite_oam_piece $f8, $0c, $08, $02
    sprite_oam_piece $f8, $04, $07, $02
    sprite_oam_piece $f8, $fc, $06, $02
    sprite_oam_piece $f8, $f4, $05, $02
    sprite_oam_piece $f8, $ec, $04, $02
    sprite_oam_piece $f0, $0c, $03, $02
    sprite_oam_piece $f0, $04, $02, $02
    sprite_oam_piece $f0, $fc, $01, $02
    sprite_oam_piece $f0, $f4, $00, $02

SpriteFrame_1D_5DA8::
    db 14
    sprite_oam_piece $01, $0c, $10, $02
    sprite_oam_piece $01, $04, $0f, $02
    sprite_oam_piece $01, $fc, $0f, $02
    sprite_oam_piece $01, $f4, $0e, $02
    sprite_oam_piece $01, $ec, $0d, $02
    sprite_oam_piece $f9, $0c, $08, $02
    sprite_oam_piece $f9, $04, $07, $02
    sprite_oam_piece $f9, $fc, $06, $02
    sprite_oam_piece $f9, $f4, $05, $02
    sprite_oam_piece $f9, $ec, $04, $02
    sprite_oam_piece $f1, $0c, $03, $02
    sprite_oam_piece $f1, $04, $02, $02
    sprite_oam_piece $f1, $fc, $01, $02
    sprite_oam_piece $f1, $f4, $00, $02

SpriteFrame_1D_5DE1::
    db 14
    sprite_oam_piece $02, $0c, $14, $02
    sprite_oam_piece $02, $04, $13, $02
    sprite_oam_piece $02, $fc, $13, $02
    sprite_oam_piece $02, $f4, $12, $02
    sprite_oam_piece $02, $ec, $11, $02
    sprite_oam_piece $fa, $0c, $08, $02
    sprite_oam_piece $fa, $04, $07, $02
    sprite_oam_piece $fa, $fc, $06, $02
    sprite_oam_piece $fa, $f4, $05, $02
    sprite_oam_piece $fa, $ec, $04, $02
    sprite_oam_piece $f2, $0c, $03, $02
    sprite_oam_piece $f2, $04, $02, $02
    sprite_oam_piece $f2, $fc, $01, $02
    sprite_oam_piece $f2, $f4, $00, $02

SpriteFrame_1D_5E1A::
    db 11
    sprite_oam_piece $00, $09, $1e, $02
    sprite_oam_piece $00, $01, $1d, $02
    sprite_oam_piece $00, $f9, $1d, $02
    sprite_oam_piece $00, $f1, $1c, $02
    sprite_oam_piece $f8, $0c, $1b, $02
    sprite_oam_piece $f8, $04, $1a, $02
    sprite_oam_piece $f8, $fc, $19, $02
    sprite_oam_piece $f8, $f4, $18, $02
    sprite_oam_piece $f8, $ec, $17, $02
    sprite_oam_piece $f0, $0c, $16, $02
    sprite_oam_piece $f0, $04, $15, $02

SpriteFrame_1D_5E47::
    db 11
    sprite_oam_piece $01, $09, $21, $02
    sprite_oam_piece $01, $01, $20, $02
    sprite_oam_piece $01, $f9, $20, $02
    sprite_oam_piece $01, $f1, $1f, $02
    sprite_oam_piece $f9, $0c, $1b, $02
    sprite_oam_piece $f9, $04, $1a, $02
    sprite_oam_piece $f9, $fc, $19, $02
    sprite_oam_piece $f9, $f4, $18, $02
    sprite_oam_piece $f9, $ec, $17, $02
    sprite_oam_piece $f1, $0c, $16, $02
    sprite_oam_piece $f1, $04, $15, $02

SpriteFrame_1D_5E74::
    db 11
    sprite_oam_piece $02, $09, $24, $02
    sprite_oam_piece $02, $01, $23, $02
    sprite_oam_piece $02, $f9, $23, $02
    sprite_oam_piece $02, $f1, $22, $02
    sprite_oam_piece $fa, $0c, $1b, $02
    sprite_oam_piece $fa, $04, $1a, $02
    sprite_oam_piece $fa, $fc, $19, $02
    sprite_oam_piece $fa, $f4, $18, $02
    sprite_oam_piece $fa, $ec, $17, $02
    sprite_oam_piece $f2, $0c, $16, $02
    sprite_oam_piece $f2, $04, $15, $02

SpriteFrame_1D_5EA1::
    db 12
    sprite_oam_piece $fd, $0c, $30, $02
    sprite_oam_piece $fd, $04, $2f, $02
    sprite_oam_piece $fd, $fc, $2e, $02
    sprite_oam_piece $fd, $f4, $2d, $02
    sprite_oam_piece $fd, $ec, $2c, $02
    sprite_oam_piece $f5, $0c, $2b, $02
    sprite_oam_piece $f5, $04, $2a, $02
    sprite_oam_piece $f5, $fc, $29, $02
    sprite_oam_piece $f5, $f4, $28, $02
    sprite_oam_piece $f5, $ec, $27, $02
    sprite_oam_piece $ed, $04, $26, $02
    sprite_oam_piece $ed, $fc, $25, $02

SpriteFrame_1D_5ED2::
    db 12
    sprite_oam_piece $fe, $0c, $35, $02
    sprite_oam_piece $fe, $04, $34, $02
    sprite_oam_piece $fe, $fc, $33, $02
    sprite_oam_piece $fe, $f4, $32, $02
    sprite_oam_piece $fe, $ec, $31, $02
    sprite_oam_piece $f6, $0c, $2b, $02
    sprite_oam_piece $f6, $04, $2a, $02
    sprite_oam_piece $f6, $fc, $29, $02
    sprite_oam_piece $f6, $f4, $28, $02
    sprite_oam_piece $f6, $ec, $27, $02
    sprite_oam_piece $ee, $04, $26, $02
    sprite_oam_piece $ee, $fc, $25, $02

SpriteFrame_1D_5F03::
    db 12
    sprite_oam_piece $ff, $0c, $3a, $02
    sprite_oam_piece $ff, $04, $39, $02
    sprite_oam_piece $ff, $fc, $38, $02
    sprite_oam_piece $ff, $f4, $37, $02
    sprite_oam_piece $ff, $ec, $36, $02
    sprite_oam_piece $f7, $0c, $2b, $02
    sprite_oam_piece $f7, $04, $2a, $02
    sprite_oam_piece $f7, $fc, $29, $02
    sprite_oam_piece $f7, $f4, $28, $02
    sprite_oam_piece $f7, $ec, $27, $02
    sprite_oam_piece $ef, $04, $26, $02
    sprite_oam_piece $ef, $fc, $25, $02

SpriteFrame_1D_5F34::
    db 12
    sprite_oam_piece $ff, $0c, $46, $02
    sprite_oam_piece $ff, $04, $45, $02
    sprite_oam_piece $ff, $fc, $44, $02
    sprite_oam_piece $ff, $f4, $43, $02
    sprite_oam_piece $ff, $ec, $42, $02
    sprite_oam_piece $f7, $0c, $41, $02
    sprite_oam_piece $f7, $04, $40, $02
    sprite_oam_piece $f7, $fc, $3f, $02
    sprite_oam_piece $f7, $f4, $3e, $02
    sprite_oam_piece $f7, $ec, $3d, $02
    sprite_oam_piece $ef, $04, $3c, $02
    sprite_oam_piece $ef, $fc, $3b, $02

SpriteFrame_1D_5F65::
    db 12
    sprite_oam_piece $00, $0c, $4b, $02
    sprite_oam_piece $00, $04, $4a, $02
    sprite_oam_piece $00, $fc, $49, $02
    sprite_oam_piece $00, $f4, $48, $02
    sprite_oam_piece $00, $ec, $47, $02
    sprite_oam_piece $f8, $0c, $41, $02
    sprite_oam_piece $f8, $04, $40, $02
    sprite_oam_piece $f8, $fc, $3f, $02
    sprite_oam_piece $f8, $f4, $3e, $02
    sprite_oam_piece $f8, $ec, $3d, $02
    sprite_oam_piece $f0, $04, $3c, $02
    sprite_oam_piece $f0, $fc, $3b, $02

SpriteFrame_1D_5F96::
    db 12
    sprite_oam_piece $01, $0c, $50, $02
    sprite_oam_piece $01, $04, $4f, $02
    sprite_oam_piece $01, $fc, $4e, $02
    sprite_oam_piece $01, $f4, $4d, $02
    sprite_oam_piece $01, $ec, $4c, $02
    sprite_oam_piece $f9, $0c, $41, $02
    sprite_oam_piece $f9, $04, $40, $02
    sprite_oam_piece $f9, $fc, $3f, $02
    sprite_oam_piece $f9, $f4, $3e, $02
    sprite_oam_piece $f9, $ec, $3d, $02
    sprite_oam_piece $f1, $04, $3c, $02
    sprite_oam_piece $f1, $fc, $3b, $02

SpriteFrame_1D_5FC7::
    db 12
    sprite_oam_piece $fe, $0a, $5c, $02
    sprite_oam_piece $fe, $02, $5b, $02
    sprite_oam_piece $fe, $fa, $5a, $02
    sprite_oam_piece $fe, $f2, $59, $02
    sprite_oam_piece $fe, $ea, $58, $02
    sprite_oam_piece $f6, $0a, $57, $02
    sprite_oam_piece $f6, $02, $56, $02
    sprite_oam_piece $f6, $fa, $55, $02
    sprite_oam_piece $f6, $f2, $54, $02
    sprite_oam_piece $f6, $ea, $53, $02
    sprite_oam_piece $ee, $02, $52, $02
    sprite_oam_piece $ee, $fa, $51, $02

SpriteFrame_1D_5FF8::
    db 12
    sprite_oam_piece $ff, $0a, $61, $02
    sprite_oam_piece $ff, $02, $60, $02
    sprite_oam_piece $ff, $fa, $5f, $02
    sprite_oam_piece $ff, $f2, $5e, $02
    sprite_oam_piece $ff, $ea, $5d, $02
    sprite_oam_piece $f7, $0a, $57, $02
    sprite_oam_piece $f7, $02, $56, $02
    sprite_oam_piece $f7, $fa, $55, $02
    sprite_oam_piece $f7, $f2, $54, $02
    sprite_oam_piece $f7, $ea, $53, $02
    sprite_oam_piece $ef, $02, $52, $02
    sprite_oam_piece $ef, $fa, $51, $02

SpriteFrame_1D_6029::
    db 12
    sprite_oam_piece $00, $0a, $66, $02
    sprite_oam_piece $00, $02, $65, $02
    sprite_oam_piece $00, $fa, $64, $02
    sprite_oam_piece $00, $f2, $63, $02
    sprite_oam_piece $00, $ea, $62, $02
    sprite_oam_piece $f8, $0a, $57, $02
    sprite_oam_piece $f8, $02, $56, $02
    sprite_oam_piece $f8, $fa, $55, $02
    sprite_oam_piece $f8, $f2, $54, $02
    sprite_oam_piece $f8, $ea, $53, $02
    sprite_oam_piece $f0, $02, $52, $02
    sprite_oam_piece $f0, $fa, $51, $02

SpriteFrame_1D_605A::
    db 12
    sprite_oam_piece $fe, $0b, $72, $02
    sprite_oam_piece $fe, $03, $71, $02
    sprite_oam_piece $fe, $fb, $70, $02
    sprite_oam_piece $fe, $f3, $6f, $02
    sprite_oam_piece $fe, $eb, $6e, $02
    sprite_oam_piece $f6, $0b, $6d, $02
    sprite_oam_piece $f6, $03, $6c, $02
    sprite_oam_piece $f6, $fb, $6b, $02
    sprite_oam_piece $f6, $f3, $6a, $02
    sprite_oam_piece $f6, $eb, $69, $02
    sprite_oam_piece $ee, $03, $68, $02
    sprite_oam_piece $ee, $fb, $67, $02

SpriteFrame_1D_608B::
    db 12
    sprite_oam_piece $ff, $0b, $77, $02
    sprite_oam_piece $ff, $03, $76, $02
    sprite_oam_piece $ff, $fb, $75, $02
    sprite_oam_piece $ff, $f3, $74, $02
    sprite_oam_piece $ff, $eb, $73, $02
    sprite_oam_piece $f7, $0b, $6d, $02
    sprite_oam_piece $f7, $03, $6c, $02
    sprite_oam_piece $f7, $fb, $6b, $02
    sprite_oam_piece $f7, $f3, $6a, $02
    sprite_oam_piece $f7, $eb, $69, $02
    sprite_oam_piece $ef, $03, $68, $02
    sprite_oam_piece $ef, $fb, $67, $02

SpriteFrame_1D_60BC::
    db 12
    sprite_oam_piece $00, $0b, $7c, $02
    sprite_oam_piece $00, $03, $7b, $02
    sprite_oam_piece $00, $fb, $7a, $02
    sprite_oam_piece $00, $f3, $79, $02
    sprite_oam_piece $00, $eb, $78, $02
    sprite_oam_piece $f8, $0b, $6d, $02
    sprite_oam_piece $f8, $03, $6c, $02
    sprite_oam_piece $f8, $fb, $6b, $02
    sprite_oam_piece $f8, $f3, $6a, $02
    sprite_oam_piece $f8, $eb, $69, $02
    sprite_oam_piece $f0, $03, $68, $02
    sprite_oam_piece $f0, $fb, $67, $02

SpriteAnimation_024:: ; $1D:$60ED
    sprite_anim_entry SpriteFrame_1D_5DE1, $1e
    sprite_anim_entry SpriteFrame_1D_5DA8, $0f
    sprite_anim_entry SpriteFrame_1D_5D6F, $1e
    sprite_anim_entry SpriteFrame_1D_5DA8, $0f
    sprite_anim_end

SpriteAnimation_025:: ; $1D:$60FB
    sprite_anim_entry SpriteFrame_1D_5E1A, $1e
    sprite_anim_entry SpriteFrame_1D_5E47, $0f
    sprite_anim_entry SpriteFrame_1D_5E74, $1e
    sprite_anim_entry SpriteFrame_1D_5E47, $0f
    sprite_anim_end

SpriteAnimation_026:: ; $1D:$6109
    sprite_anim_entry SpriteFrame_1D_5EA1, $1e
    sprite_anim_entry SpriteFrame_1D_5ED2, $0f
    sprite_anim_entry SpriteFrame_1D_5F03, $1e
    sprite_anim_entry SpriteFrame_1D_5ED2, $0f
    sprite_anim_end

SpriteAnimation_027:: ; $1D:$6117
    sprite_anim_entry SpriteFrame_1D_5F34, $1e
    sprite_anim_entry SpriteFrame_1D_5F65, $0f
    sprite_anim_entry SpriteFrame_1D_5F96, $1e
    sprite_anim_entry SpriteFrame_1D_5F65, $0f
    sprite_anim_end

SpriteAnimation_028:: ; $1D:$6125
    sprite_anim_entry SpriteFrame_1D_5FC7, $1e
    sprite_anim_entry SpriteFrame_1D_5FF8, $0f
    sprite_anim_entry SpriteFrame_1D_6029, $1e
    sprite_anim_entry SpriteFrame_1D_5FF8, $0f
    sprite_anim_end

SpriteAnimation_029:: ; $1D:$6133
    sprite_anim_entry SpriteFrame_1D_605A, $1e
    sprite_anim_entry SpriteFrame_1D_608B, $0f
    sprite_anim_entry SpriteFrame_1D_60BC, $1e
    sprite_anim_entry SpriteFrame_1D_608B, $0f
    sprite_anim_end

assert @ == $6141

section "Sprite Animation Data 1D:695D", romx[$695d], bank[$1d]

SpriteFrame_1D_695D::
    db 22
    sprite_oam_piece $f0, $fc, $38, $02
    sprite_oam_piece $08, $f4, $39, $02
    sprite_oam_piece $08, $0c, $13, $02
    sprite_oam_piece $08, $04, $12, $02
    sprite_oam_piece $08, $fc, $11, $02
    sprite_oam_piece $00, $14, $10, $02
    sprite_oam_piece $00, $0c, $0f, $02
    sprite_oam_piece $00, $04, $0e, $02
    sprite_oam_piece $00, $fc, $0d, $02
    sprite_oam_piece $00, $f4, $0c, $02
    sprite_oam_piece $00, $ec, $0b, $02
    sprite_oam_piece $00, $e4, $0a, $02
    sprite_oam_piece $f0, $14, $02, $02
    sprite_oam_piece $f0, $0c, $01, $02
    sprite_oam_piece $f0, $04, $00, $02
    sprite_oam_piece $f8, $14, $09, $02
    sprite_oam_piece $f8, $0c, $08, $02
    sprite_oam_piece $f8, $04, $07, $02
    sprite_oam_piece $f8, $fc, $06, $02
    sprite_oam_piece $f8, $f4, $05, $02
    sprite_oam_piece $f8, $ec, $04, $02
    sprite_oam_piece $f8, $e4, $03, $02

SpriteFrame_1D_69B6::
    db 6
    sprite_oam_piece $00, $04, $19, $02
    sprite_oam_piece $00, $fc, $18, $02
    sprite_oam_piece $00, $f4, $17, $02
    sprite_oam_piece $f8, $04, $16, $02
    sprite_oam_piece $f8, $fc, $15, $02
    sprite_oam_piece $f8, $f4, $14, $02

SpriteFrame_1D_69CF::
    db 7
    sprite_oam_piece $00, $04, $19, $02
    sprite_oam_piece $00, $fc, $18, $02
    sprite_oam_piece $00, $f4, $17, $02
    sprite_oam_piece $f8, $04, $16, $02
    sprite_oam_piece $f8, $fc, $15, $02
    sprite_oam_piece $f8, $f4, $14, $02
    sprite_oam_piece $fc, $0b, $32, $07

SpriteFrame_1D_69EC::
    db 7
    sprite_oam_piece $00, $04, $19, $02
    sprite_oam_piece $00, $fc, $18, $02
    sprite_oam_piece $00, $f4, $17, $02
    sprite_oam_piece $f8, $04, $16, $02
    sprite_oam_piece $f8, $fc, $15, $02
    sprite_oam_piece $f8, $f4, $14, $02
    sprite_oam_piece $fc, $0b, $33, $07

SpriteFrame_1D_6A09::
    db 8
    sprite_oam_piece $00, $04, $19, $02
    sprite_oam_piece $00, $fc, $18, $02
    sprite_oam_piece $00, $f4, $17, $02
    sprite_oam_piece $f8, $04, $16, $02
    sprite_oam_piece $f8, $fc, $15, $02
    sprite_oam_piece $f8, $f4, $14, $02
    sprite_oam_piece $fc, $13, $35, $07
    sprite_oam_piece $fc, $0b, $34, $07

SpriteFrame_1D_6A2A::
    db 8
    sprite_oam_piece $00, $04, $19, $02
    sprite_oam_piece $00, $fc, $18, $02
    sprite_oam_piece $00, $f4, $17, $02
    sprite_oam_piece $f8, $04, $16, $02
    sprite_oam_piece $f8, $fc, $15, $02
    sprite_oam_piece $f8, $f4, $14, $02
    sprite_oam_piece $fc, $13, $37, $07
    sprite_oam_piece $fc, $0b, $36, $07

SpriteFrame_1D_6A4B::
    db 6
    sprite_oam_piece $00, $04, $1f, $02
    sprite_oam_piece $00, $fc, $1e, $02
    sprite_oam_piece $00, $f4, $1d, $02
    sprite_oam_piece $f8, $04, $1c, $02
    sprite_oam_piece $f8, $fc, $1b, $02
    sprite_oam_piece $f8, $f4, $1a, $02

SpriteFrame_1D_6A64::
    db 7
    sprite_oam_piece $00, $04, $1f, $02
    sprite_oam_piece $00, $fc, $1e, $02
    sprite_oam_piece $00, $f4, $1d, $02
    sprite_oam_piece $f8, $04, $1c, $02
    sprite_oam_piece $f8, $fc, $1b, $02
    sprite_oam_piece $f8, $f4, $1a, $02
    sprite_oam_piece $fc, $09, $32, $07

SpriteFrame_1D_6A81::
    db 7
    sprite_oam_piece $00, $04, $1f, $02
    sprite_oam_piece $00, $fc, $1e, $02
    sprite_oam_piece $00, $f4, $1d, $02
    sprite_oam_piece $f8, $04, $1c, $02
    sprite_oam_piece $f8, $fc, $1b, $02
    sprite_oam_piece $f8, $f4, $1a, $02
    sprite_oam_piece $fc, $09, $33, $07

SpriteFrame_1D_6A9E::
    db 8
    sprite_oam_piece $00, $04, $1f, $02
    sprite_oam_piece $00, $fc, $1e, $02
    sprite_oam_piece $00, $f4, $1d, $02
    sprite_oam_piece $f8, $04, $1c, $02
    sprite_oam_piece $f8, $fc, $1b, $02
    sprite_oam_piece $f8, $f4, $1a, $02
    sprite_oam_piece $fc, $11, $35, $07
    sprite_oam_piece $fc, $09, $34, $07

SpriteFrame_1D_6ABF::
    db 8
    sprite_oam_piece $00, $04, $1f, $02
    sprite_oam_piece $00, $fc, $1e, $02
    sprite_oam_piece $00, $f4, $1d, $02
    sprite_oam_piece $f8, $04, $1c, $02
    sprite_oam_piece $f8, $fc, $1b, $02
    sprite_oam_piece $f8, $f4, $1a, $02
    sprite_oam_piece $fc, $11, $37, $07
    sprite_oam_piece $fc, $09, $36, $07

SpriteFrame_1D_6AE0::
    db 6
    sprite_oam_piece $00, $04, $25, $02
    sprite_oam_piece $00, $fc, $24, $02
    sprite_oam_piece $00, $f4, $23, $02
    sprite_oam_piece $f8, $04, $22, $02
    sprite_oam_piece $f8, $fc, $21, $02
    sprite_oam_piece $f8, $f4, $20, $02

SpriteFrame_1D_6AF9::
    db 7
    sprite_oam_piece $00, $04, $25, $02
    sprite_oam_piece $00, $fc, $24, $02
    sprite_oam_piece $00, $f4, $23, $02
    sprite_oam_piece $f8, $04, $22, $02
    sprite_oam_piece $f8, $fc, $21, $02
    sprite_oam_piece $f8, $f4, $20, $02
    sprite_oam_piece $fb, $0a, $32, $07

SpriteFrame_1D_6B16::
    db 7
    sprite_oam_piece $00, $04, $25, $02
    sprite_oam_piece $00, $fc, $24, $02
    sprite_oam_piece $00, $f4, $23, $02
    sprite_oam_piece $f8, $04, $22, $02
    sprite_oam_piece $f8, $fc, $21, $02
    sprite_oam_piece $f8, $f4, $20, $02
    sprite_oam_piece $fb, $0a, $33, $07

SpriteFrame_1D_6B33::
    db 8
    sprite_oam_piece $00, $04, $25, $02
    sprite_oam_piece $00, $fc, $24, $02
    sprite_oam_piece $00, $f4, $23, $02
    sprite_oam_piece $f8, $04, $22, $02
    sprite_oam_piece $f8, $fc, $21, $02
    sprite_oam_piece $f8, $f4, $20, $02
    sprite_oam_piece $fb, $11, $35, $07
    sprite_oam_piece $fb, $09, $34, $07

SpriteFrame_1D_6B54::
    db 8
    sprite_oam_piece $00, $04, $25, $02
    sprite_oam_piece $00, $fc, $24, $02
    sprite_oam_piece $00, $f4, $23, $02
    sprite_oam_piece $f8, $04, $22, $02
    sprite_oam_piece $f8, $fc, $21, $02
    sprite_oam_piece $f8, $f4, $20, $02
    sprite_oam_piece $fb, $11, $37, $07
    sprite_oam_piece $fb, $09, $36, $07

SpriteFrame_1D_6B75::
    db 6
    sprite_oam_piece $00, $04, $2b, $02
    sprite_oam_piece $00, $fc, $2a, $02
    sprite_oam_piece $00, $f4, $29, $02
    sprite_oam_piece $f8, $04, $28, $02
    sprite_oam_piece $f8, $fc, $27, $02
    sprite_oam_piece $f8, $f4, $26, $02

SpriteFrame_1D_6B8E::
    db 7
    sprite_oam_piece $00, $04, $2b, $02
    sprite_oam_piece $00, $fc, $2a, $02
    sprite_oam_piece $00, $f4, $29, $02
    sprite_oam_piece $f8, $04, $28, $02
    sprite_oam_piece $f8, $fc, $27, $02
    sprite_oam_piece $f8, $f4, $26, $02
    sprite_oam_piece $fc, $0a, $32, $07

SpriteFrame_1D_6BAB::
    db 7
    sprite_oam_piece $00, $04, $2b, $02
    sprite_oam_piece $00, $fc, $2a, $02
    sprite_oam_piece $00, $f4, $29, $02
    sprite_oam_piece $f8, $04, $28, $02
    sprite_oam_piece $f8, $fc, $27, $02
    sprite_oam_piece $f8, $f4, $26, $02
    sprite_oam_piece $fc, $0a, $33, $07

SpriteFrame_1D_6BC8::
    db 8
    sprite_oam_piece $00, $04, $2b, $02
    sprite_oam_piece $00, $fc, $2a, $02
    sprite_oam_piece $00, $f4, $29, $02
    sprite_oam_piece $f8, $04, $28, $02
    sprite_oam_piece $f8, $fc, $27, $02
    sprite_oam_piece $f8, $f4, $26, $02
    sprite_oam_piece $fc, $12, $35, $07
    sprite_oam_piece $fc, $0a, $34, $07

SpriteFrame_1D_6BE9::
    db 8
    sprite_oam_piece $00, $04, $2b, $02
    sprite_oam_piece $00, $fc, $2a, $02
    sprite_oam_piece $00, $f4, $29, $02
    sprite_oam_piece $f8, $04, $28, $02
    sprite_oam_piece $f8, $fc, $27, $02
    sprite_oam_piece $f8, $f4, $26, $02
    sprite_oam_piece $fc, $12, $37, $07
    sprite_oam_piece $fc, $0a, $36, $07

SpriteFrame_1D_6C0A::
    db 6
    sprite_oam_piece $00, $04, $31, $02
    sprite_oam_piece $00, $fc, $30, $02
    sprite_oam_piece $00, $f4, $2f, $02
    sprite_oam_piece $f8, $04, $2e, $02
    sprite_oam_piece $f8, $fc, $2d, $02
    sprite_oam_piece $f8, $f4, $2c, $02

SpriteFrame_1D_6C23::
    db 7
    sprite_oam_piece $00, $04, $31, $02
    sprite_oam_piece $00, $fc, $30, $02
    sprite_oam_piece $00, $f4, $2f, $02
    sprite_oam_piece $f8, $04, $2e, $02
    sprite_oam_piece $f8, $fc, $2d, $02
    sprite_oam_piece $f8, $f4, $2c, $02
    sprite_oam_piece $fc, $0a, $32, $07

SpriteFrame_1D_6C40::
    db 7
    sprite_oam_piece $00, $04, $31, $02
    sprite_oam_piece $00, $fc, $30, $02
    sprite_oam_piece $00, $f4, $2f, $02
    sprite_oam_piece $f8, $04, $2e, $02
    sprite_oam_piece $f8, $fc, $2d, $02
    sprite_oam_piece $f8, $f4, $2c, $02
    sprite_oam_piece $fc, $0a, $33, $07

SpriteFrame_1D_6C5D::
    db 8
    sprite_oam_piece $00, $04, $31, $02
    sprite_oam_piece $00, $fc, $30, $02
    sprite_oam_piece $00, $f4, $2f, $02
    sprite_oam_piece $f8, $04, $2e, $02
    sprite_oam_piece $f8, $fc, $2d, $02
    sprite_oam_piece $f8, $f4, $2c, $02
    sprite_oam_piece $fc, $12, $35, $07
    sprite_oam_piece $fc, $0a, $34, $07

SpriteFrame_1D_6C7E::
    db 8
    sprite_oam_piece $00, $04, $31, $02
    sprite_oam_piece $00, $fc, $30, $02
    sprite_oam_piece $00, $f4, $2f, $02
    sprite_oam_piece $f8, $04, $2e, $02
    sprite_oam_piece $f8, $fc, $2d, $02
    sprite_oam_piece $f8, $f4, $2c, $02
    sprite_oam_piece $fc, $12, $37, $07
    sprite_oam_piece $fc, $0a, $36, $07

SpriteAnimation_030:: ; $1D:$6C9F
    sprite_anim_entry SpriteFrame_1D_695D, $01
    sprite_anim_end

SpriteAnimation_031:: ; $1D:$6CA4
    sprite_anim_entry SpriteFrame_1D_69B6, $01
    sprite_anim_end

SpriteAnimation_034:: ; $1D:$6CA9
    sprite_anim_entry SpriteFrame_1D_6A4B, $01
    sprite_anim_end

SpriteAnimation_037:: ; $1D:$6CAE
    sprite_anim_entry SpriteFrame_1D_6AE0, $01
    sprite_anim_end

SpriteAnimation_040:: ; $1D:$6CB3
    sprite_anim_entry SpriteFrame_1D_6B75, $01
    sprite_anim_end

SpriteAnimation_043:: ; $1D:$6CB8
    sprite_anim_entry SpriteFrame_1D_6C0A, $01
    sprite_anim_end

SpriteAnimation_032:: ; $1D:$6CBD
    sprite_anim_entry SpriteFrame_1D_69B6, $02
    sprite_anim_entry SpriteFrame_1D_69CF, $02
    sprite_anim_entry SpriteFrame_1D_69EC, $02
    sprite_anim_end

SpriteAnimation_035:: ; $1D:$6CC8
    sprite_anim_entry SpriteFrame_1D_6A4B, $02
    sprite_anim_entry SpriteFrame_1D_6A64, $02
    sprite_anim_entry SpriteFrame_1D_6A81, $02
    sprite_anim_end

SpriteAnimation_038:: ; $1D:$6CD3
    sprite_anim_entry SpriteFrame_1D_6AE0, $02
    sprite_anim_entry SpriteFrame_1D_6AF9, $02
    sprite_anim_entry SpriteFrame_1D_6B16, $02
    sprite_anim_end

SpriteAnimation_041:: ; $1D:$6CDE
    sprite_anim_entry SpriteFrame_1D_6B75, $02
    sprite_anim_entry SpriteFrame_1D_6B8E, $02
    sprite_anim_entry SpriteFrame_1D_6BAB, $02
    sprite_anim_end

SpriteAnimation_044:: ; $1D:$6CE9
    sprite_anim_entry SpriteFrame_1D_6C0A, $02
    sprite_anim_entry SpriteFrame_1D_6C23, $02
    sprite_anim_entry SpriteFrame_1D_6C40, $02
    sprite_anim_end

SpriteAnimation_033:: ; $1D:$6CF4
    sprite_anim_entry SpriteFrame_1D_69B6, $02
    sprite_anim_entry SpriteFrame_1D_6A09, $02
    sprite_anim_entry SpriteFrame_1D_6A2A, $02
    sprite_anim_end

SpriteAnimation_036:: ; $1D:$6CFF
    sprite_anim_entry SpriteFrame_1D_6A4B, $02
    sprite_anim_entry SpriteFrame_1D_6A9E, $02
    sprite_anim_entry SpriteFrame_1D_6ABF, $02
    sprite_anim_end

SpriteAnimation_039:: ; $1D:$6D0A
    sprite_anim_entry SpriteFrame_1D_6AE0, $02
    sprite_anim_entry SpriteFrame_1D_6B33, $02
    sprite_anim_entry SpriteFrame_1D_6B54, $02
    sprite_anim_end

SpriteAnimation_042:: ; $1D:$6D15
    sprite_anim_entry SpriteFrame_1D_6B75, $02
    sprite_anim_entry SpriteFrame_1D_6BC8, $02
    sprite_anim_entry SpriteFrame_1D_6BE9, $02
    sprite_anim_end

SpriteAnimation_045:: ; $1D:$6D20
    sprite_anim_entry SpriteFrame_1D_6C0A, $02
    sprite_anim_entry SpriteFrame_1D_6C5D, $02
    sprite_anim_entry SpriteFrame_1D_6C7E, $02
    sprite_anim_end

assert @ == $6d2b

section "Sprite Animation Data 1D:712B", romx[$712b], bank[$1d]

SpriteFrame_1D_712B::
    db 17
    sprite_oam_piece $09, $0c, $11, $02
    sprite_oam_piece $09, $04, $10, $02
    sprite_oam_piece $09, $fc, $0f, $02
    sprite_oam_piece $09, $f4, $0e, $02
    sprite_oam_piece $07, $ec, $0d, $02
    sprite_oam_piece $01, $0c, $0c, $02
    sprite_oam_piece $01, $04, $0b, $02
    sprite_oam_piece $01, $fc, $0a, $02
    sprite_oam_piece $01, $f4, $09, $02
    sprite_oam_piece $ff, $ec, $08, $02
    sprite_oam_piece $f9, $0c, $07, $02
    sprite_oam_piece $f9, $04, $06, $05
    sprite_oam_piece $f9, $fc, $05, $02
    sprite_oam_piece $f9, $f4, $04, $02
    sprite_oam_piece $f1, $0d, $03, $02
    sprite_oam_piece $f1, $05, $02, $02
    sprite_oam_piece $f1, $fd, $01, $02

SpriteFrame_1D_7170::
    db 17
    sprite_oam_piece $08, $0c, $1b, $02
    sprite_oam_piece $08, $04, $1a, $02
    sprite_oam_piece $08, $fc, $19, $02
    sprite_oam_piece $08, $f4, $18, $02
    sprite_oam_piece $00, $0c, $17, $02
    sprite_oam_piece $00, $04, $16, $02
    sprite_oam_piece $00, $fc, $15, $02
    sprite_oam_piece $00, $f4, $14, $02
    sprite_oam_piece $f8, $0c, $13, $02
    sprite_oam_piece $f8, $f4, $12, $02
    sprite_oam_piece $07, $ec, $0d, $02
    sprite_oam_piece $ff, $ec, $08, $02
    sprite_oam_piece $f8, $04, $06, $05
    sprite_oam_piece $f8, $fc, $05, $02
    sprite_oam_piece $f0, $0d, $03, $02
    sprite_oam_piece $f0, $05, $02, $02
    sprite_oam_piece $f0, $fd, $01, $02

SpriteFrame_1D_71B5::
    db 17
    sprite_oam_piece $07, $0c, $25, $02
    sprite_oam_piece $07, $04, $24, $02
    sprite_oam_piece $07, $fc, $23, $02
    sprite_oam_piece $07, $f4, $22, $02
    sprite_oam_piece $ff, $0c, $21, $02
    sprite_oam_piece $ff, $04, $20, $02
    sprite_oam_piece $ff, $fc, $1f, $02
    sprite_oam_piece $ff, $f4, $1e, $02
    sprite_oam_piece $f7, $0c, $1d, $02
    sprite_oam_piece $f7, $f4, $1c, $02
    sprite_oam_piece $07, $ec, $0d, $02
    sprite_oam_piece $ff, $ec, $08, $02
    sprite_oam_piece $f7, $04, $06, $05
    sprite_oam_piece $f7, $fc, $05, $02
    sprite_oam_piece $ef, $0d, $03, $02
    sprite_oam_piece $ef, $05, $02, $02
    sprite_oam_piece $ef, $fd, $01, $02

SpriteFrame_1D_71FA::
    db 17
    sprite_oam_piece $09, $ed, $11, $22
    sprite_oam_piece $09, $f5, $10, $22
    sprite_oam_piece $09, $fd, $0f, $22
    sprite_oam_piece $09, $05, $0e, $22
    sprite_oam_piece $07, $0d, $0d, $22
    sprite_oam_piece $01, $ed, $0c, $22
    sprite_oam_piece $01, $f5, $0b, $22
    sprite_oam_piece $01, $fd, $0a, $22
    sprite_oam_piece $01, $05, $09, $22
    sprite_oam_piece $ff, $0d, $08, $22
    sprite_oam_piece $f9, $ed, $07, $22
    sprite_oam_piece $f9, $f5, $06, $25
    sprite_oam_piece $f9, $fd, $05, $22
    sprite_oam_piece $f9, $05, $04, $22
    sprite_oam_piece $f1, $ec, $03, $22
    sprite_oam_piece $f1, $f4, $02, $22
    sprite_oam_piece $f1, $fc, $01, $22

SpriteFrame_1D_723F::
    db 17
    sprite_oam_piece $08, $ed, $1b, $22
    sprite_oam_piece $08, $f5, $1a, $22
    sprite_oam_piece $08, $fd, $19, $22
    sprite_oam_piece $08, $05, $18, $22
    sprite_oam_piece $00, $ed, $17, $22
    sprite_oam_piece $00, $f5, $16, $22
    sprite_oam_piece $00, $fd, $15, $22
    sprite_oam_piece $00, $05, $14, $22
    sprite_oam_piece $f8, $ed, $13, $22
    sprite_oam_piece $f8, $05, $12, $22
    sprite_oam_piece $07, $0d, $0d, $22
    sprite_oam_piece $ff, $0d, $08, $22
    sprite_oam_piece $f8, $f5, $06, $25
    sprite_oam_piece $f8, $fd, $05, $22
    sprite_oam_piece $f0, $ec, $03, $22
    sprite_oam_piece $f0, $f4, $02, $22
    sprite_oam_piece $f0, $fc, $01, $22

SpriteFrame_1D_7284::
    db 17
    sprite_oam_piece $07, $ed, $25, $22
    sprite_oam_piece $07, $f5, $24, $22
    sprite_oam_piece $07, $fd, $23, $22
    sprite_oam_piece $07, $05, $22, $22
    sprite_oam_piece $ff, $ed, $21, $22
    sprite_oam_piece $ff, $f5, $20, $22
    sprite_oam_piece $ff, $fd, $1f, $22
    sprite_oam_piece $ff, $05, $1e, $22
    sprite_oam_piece $f7, $ed, $1d, $22
    sprite_oam_piece $f7, $05, $1c, $22
    sprite_oam_piece $07, $0d, $0d, $22
    sprite_oam_piece $ff, $0d, $08, $22
    sprite_oam_piece $f7, $f5, $06, $25
    sprite_oam_piece $f7, $fd, $05, $22
    sprite_oam_piece $ef, $ec, $03, $22
    sprite_oam_piece $ef, $f4, $02, $22
    sprite_oam_piece $ef, $fc, $01, $22

SpriteFrame_1D_72C9::
    db 16
    sprite_oam_piece $0d, $0a, $35, $02
    sprite_oam_piece $05, $0c, $34, $02
    sprite_oam_piece $05, $04, $33, $02
    sprite_oam_piece $05, $fc, $32, $02
    sprite_oam_piece $06, $f4, $31, $02
    sprite_oam_piece $06, $ec, $30, $02
    sprite_oam_piece $fd, $0c, $2f, $06
    sprite_oam_piece $fd, $04, $2e, $06
    sprite_oam_piece $fd, $fc, $2d, $06
    sprite_oam_piece $fe, $f4, $2c, $05
    sprite_oam_piece $fe, $ec, $2b, $02
    sprite_oam_piece $f5, $0c, $2a, $06
    sprite_oam_piece $f5, $04, $29, $06
    sprite_oam_piece $f5, $fc, $28, $06
    sprite_oam_piece $f6, $f4, $27, $02
    sprite_oam_piece $f6, $ec, $26, $02

SpriteFrame_1D_730A::
    db 17
    sprite_oam_piece $0c, $0a, $3a, $02
    sprite_oam_piece $04, $0c, $39, $02
    sprite_oam_piece $04, $04, $38, $02
    sprite_oam_piece $0d, $f3, $35, $02
    sprite_oam_piece $05, $f4, $37, $02
    sprite_oam_piece $05, $ec, $36, $02
    sprite_oam_piece $04, $fc, $32, $02
    sprite_oam_piece $fc, $0c, $2f, $06
    sprite_oam_piece $fc, $04, $2e, $06
    sprite_oam_piece $fc, $fc, $2d, $06
    sprite_oam_piece $fd, $f4, $2c, $05
    sprite_oam_piece $fd, $ec, $2b, $02
    sprite_oam_piece $f4, $0c, $2a, $06
    sprite_oam_piece $f4, $04, $29, $06
    sprite_oam_piece $f4, $fc, $28, $06
    sprite_oam_piece $f5, $f4, $27, $02
    sprite_oam_piece $f5, $ec, $26, $02

SpriteFrame_1D_734F::
    db 18
    sprite_oam_piece $0b, $0c, $41, $02
    sprite_oam_piece $0b, $04, $40, $02
    sprite_oam_piece $0c, $f3, $3f, $02
    sprite_oam_piece $03, $0c, $3e, $02
    sprite_oam_piece $03, $04, $3d, $02
    sprite_oam_piece $04, $f4, $3c, $02
    sprite_oam_piece $04, $ec, $3b, $02
    sprite_oam_piece $03, $fc, $32, $02
    sprite_oam_piece $fb, $0c, $2f, $06
    sprite_oam_piece $fb, $04, $2e, $06
    sprite_oam_piece $fb, $fc, $2d, $06
    sprite_oam_piece $fc, $f4, $2c, $05
    sprite_oam_piece $fc, $ec, $2b, $02
    sprite_oam_piece $f3, $0c, $2a, $06
    sprite_oam_piece $f3, $04, $29, $06
    sprite_oam_piece $f3, $fc, $28, $06
    sprite_oam_piece $f4, $f4, $27, $02
    sprite_oam_piece $f4, $ec, $26, $02

SpriteFrame_1D_7398::
    db 16
    sprite_oam_piece $0d, $ee, $35, $22
    sprite_oam_piece $05, $ec, $34, $22
    sprite_oam_piece $05, $f4, $33, $22
    sprite_oam_piece $05, $fc, $32, $22
    sprite_oam_piece $06, $04, $31, $22
    sprite_oam_piece $06, $0c, $30, $22
    sprite_oam_piece $fd, $ec, $2f, $26
    sprite_oam_piece $fd, $f4, $2e, $26
    sprite_oam_piece $fd, $fc, $2d, $26
    sprite_oam_piece $fe, $04, $2c, $25
    sprite_oam_piece $fe, $0c, $2b, $22
    sprite_oam_piece $f5, $ec, $2a, $26
    sprite_oam_piece $f5, $f4, $29, $26
    sprite_oam_piece $f5, $fc, $28, $26
    sprite_oam_piece $f6, $04, $27, $22
    sprite_oam_piece $f6, $0c, $26, $22

SpriteFrame_1D_73D9::
    db 17
    sprite_oam_piece $0c, $ee, $3a, $22
    sprite_oam_piece $04, $ec, $39, $22
    sprite_oam_piece $04, $f4, $38, $22
    sprite_oam_piece $0d, $05, $35, $22
    sprite_oam_piece $05, $04, $37, $22
    sprite_oam_piece $05, $0c, $36, $22
    sprite_oam_piece $04, $fc, $32, $22
    sprite_oam_piece $fc, $ec, $2f, $26
    sprite_oam_piece $fc, $f4, $2e, $26
    sprite_oam_piece $fc, $fc, $2d, $26
    sprite_oam_piece $fd, $04, $2c, $25
    sprite_oam_piece $fd, $0c, $2b, $22
    sprite_oam_piece $f4, $ec, $2a, $26
    sprite_oam_piece $f4, $f4, $29, $26
    sprite_oam_piece $f4, $fc, $28, $26
    sprite_oam_piece $f5, $04, $27, $22
    sprite_oam_piece $f5, $0c, $26, $22

SpriteFrame_1D_741E::
    db 18
    sprite_oam_piece $0b, $ec, $41, $22
    sprite_oam_piece $0b, $f4, $40, $22
    sprite_oam_piece $0c, $05, $3f, $22
    sprite_oam_piece $03, $ec, $3e, $22
    sprite_oam_piece $03, $f4, $3d, $22
    sprite_oam_piece $04, $04, $3c, $22
    sprite_oam_piece $04, $0c, $3b, $22
    sprite_oam_piece $03, $fc, $32, $22
    sprite_oam_piece $fb, $ec, $2f, $26
    sprite_oam_piece $fb, $f4, $2e, $26
    sprite_oam_piece $fb, $fc, $2d, $26
    sprite_oam_piece $fc, $04, $2c, $25
    sprite_oam_piece $fc, $0c, $2b, $22
    sprite_oam_piece $f3, $ec, $2a, $26
    sprite_oam_piece $f3, $f4, $29, $26
    sprite_oam_piece $f3, $fc, $28, $26
    sprite_oam_piece $f4, $04, $27, $22
    sprite_oam_piece $f4, $0c, $26, $22

SpriteFrame_1D_7467::
    db 24
    sprite_oam_piece $0b, $10, $59, $02
    sprite_oam_piece $0b, $08, $58, $02
    sprite_oam_piece $0b, $00, $57, $02
    sprite_oam_piece $0b, $f8, $56, $02
    sprite_oam_piece $0b, $f0, $55, $02
    sprite_oam_piece $0b, $e8, $54, $02
    sprite_oam_piece $03, $10, $53, $02
    sprite_oam_piece $03, $08, $52, $02
    sprite_oam_piece $03, $00, $51, $02
    sprite_oam_piece $03, $f8, $50, $02
    sprite_oam_piece $03, $f0, $4f, $02
    sprite_oam_piece $03, $e8, $4e, $05
    sprite_oam_piece $fb, $10, $4d, $06
    sprite_oam_piece $fb, $08, $4c, $06
    sprite_oam_piece $fb, $00, $4b, $06
    sprite_oam_piece $fb, $f8, $4a, $06
    sprite_oam_piece $fb, $f0, $49, $02
    sprite_oam_piece $fb, $e8, $48, $02
    sprite_oam_piece $f3, $10, $47, $06
    sprite_oam_piece $f3, $08, $46, $06
    sprite_oam_piece $f3, $00, $45, $06
    sprite_oam_piece $f3, $f8, $44, $06
    sprite_oam_piece $f3, $f0, $43, $02
    sprite_oam_piece $f3, $e8, $42, $02

SpriteFrame_1D_74C8::
    db 24
    sprite_oam_piece $0a, $10, $61, $02
    sprite_oam_piece $0a, $08, $60, $02
    sprite_oam_piece $0a, $00, $5f, $02
    sprite_oam_piece $0a, $f8, $5e, $02
    sprite_oam_piece $0a, $f0, $5d, $02
    sprite_oam_piece $02, $10, $5c, $02
    sprite_oam_piece $02, $08, $5b, $02
    sprite_oam_piece $02, $f0, $5a, $02
    sprite_oam_piece $0a, $e8, $54, $02
    sprite_oam_piece $02, $00, $51, $02
    sprite_oam_piece $02, $f8, $50, $02
    sprite_oam_piece $02, $e8, $4e, $05
    sprite_oam_piece $fa, $10, $4d, $06
    sprite_oam_piece $fa, $08, $4c, $06
    sprite_oam_piece $fa, $00, $4b, $06
    sprite_oam_piece $fa, $f8, $4a, $06
    sprite_oam_piece $fa, $f0, $49, $02
    sprite_oam_piece $fa, $e8, $48, $02
    sprite_oam_piece $f2, $10, $47, $06
    sprite_oam_piece $f2, $08, $46, $06
    sprite_oam_piece $f2, $00, $45, $06
    sprite_oam_piece $f2, $f8, $44, $06
    sprite_oam_piece $f2, $f0, $43, $02
    sprite_oam_piece $f2, $e8, $42, $02

SpriteFrame_1D_7529::
    db 24
    sprite_oam_piece $09, $10, $69, $02
    sprite_oam_piece $09, $08, $68, $02
    sprite_oam_piece $09, $00, $67, $02
    sprite_oam_piece $09, $f8, $66, $02
    sprite_oam_piece $09, $f0, $65, $02
    sprite_oam_piece $01, $10, $64, $02
    sprite_oam_piece $01, $08, $63, $02
    sprite_oam_piece $01, $f0, $62, $02
    sprite_oam_piece $09, $e8, $54, $02
    sprite_oam_piece $01, $00, $51, $02
    sprite_oam_piece $01, $f8, $50, $02
    sprite_oam_piece $01, $e8, $4e, $05
    sprite_oam_piece $f9, $10, $4d, $06
    sprite_oam_piece $f9, $08, $4c, $06
    sprite_oam_piece $f9, $00, $4b, $06
    sprite_oam_piece $f9, $f8, $4a, $06
    sprite_oam_piece $f9, $f0, $49, $02
    sprite_oam_piece $f9, $e8, $48, $02
    sprite_oam_piece $f1, $10, $47, $06
    sprite_oam_piece $f1, $08, $46, $06
    sprite_oam_piece $f1, $00, $45, $06
    sprite_oam_piece $f1, $f8, $44, $06
    sprite_oam_piece $f1, $f0, $43, $02
    sprite_oam_piece $f1, $e8, $42, $02

SpriteFrame_1D_758A::
    db 24
    sprite_oam_piece $0b, $e8, $59, $22
    sprite_oam_piece $0b, $f0, $58, $22
    sprite_oam_piece $0b, $f8, $57, $22
    sprite_oam_piece $0b, $00, $56, $22
    sprite_oam_piece $0b, $08, $55, $22
    sprite_oam_piece $0b, $10, $54, $22
    sprite_oam_piece $03, $e8, $53, $22
    sprite_oam_piece $03, $f0, $52, $22
    sprite_oam_piece $03, $f8, $51, $22
    sprite_oam_piece $03, $00, $50, $22
    sprite_oam_piece $03, $08, $4f, $22
    sprite_oam_piece $03, $10, $4e, $25
    sprite_oam_piece $fb, $e8, $4d, $26
    sprite_oam_piece $fb, $f0, $4c, $26
    sprite_oam_piece $fb, $f8, $4b, $26
    sprite_oam_piece $fb, $00, $4a, $26
    sprite_oam_piece $fb, $08, $49, $22
    sprite_oam_piece $fb, $10, $48, $22
    sprite_oam_piece $f3, $e8, $47, $26
    sprite_oam_piece $f3, $f0, $46, $26
    sprite_oam_piece $f3, $f8, $45, $26
    sprite_oam_piece $f3, $00, $44, $26
    sprite_oam_piece $f3, $08, $43, $22
    sprite_oam_piece $f3, $10, $42, $22

SpriteFrame_1D_75EB::
    db 24
    sprite_oam_piece $0a, $e8, $61, $22
    sprite_oam_piece $0a, $f0, $60, $22
    sprite_oam_piece $0a, $f8, $5f, $22
    sprite_oam_piece $0a, $00, $5e, $22
    sprite_oam_piece $0a, $08, $5d, $22
    sprite_oam_piece $02, $e8, $5c, $22
    sprite_oam_piece $02, $f0, $5b, $22
    sprite_oam_piece $02, $08, $5a, $22
    sprite_oam_piece $0a, $10, $54, $22
    sprite_oam_piece $02, $f8, $51, $22
    sprite_oam_piece $02, $00, $50, $22
    sprite_oam_piece $02, $10, $4e, $25
    sprite_oam_piece $fa, $e8, $4d, $26
    sprite_oam_piece $fa, $f0, $4c, $26
    sprite_oam_piece $fa, $f8, $4b, $26
    sprite_oam_piece $fa, $00, $4a, $26
    sprite_oam_piece $fa, $08, $49, $22
    sprite_oam_piece $fa, $10, $48, $22
    sprite_oam_piece $f2, $e8, $47, $26
    sprite_oam_piece $f2, $f0, $46, $26
    sprite_oam_piece $f2, $f8, $45, $26
    sprite_oam_piece $f2, $00, $44, $26
    sprite_oam_piece $f2, $08, $43, $22
    sprite_oam_piece $f2, $10, $42, $22

SpriteFrame_1D_764C::
    db 24
    sprite_oam_piece $09, $e8, $69, $22
    sprite_oam_piece $09, $f0, $68, $22
    sprite_oam_piece $09, $f8, $67, $22
    sprite_oam_piece $09, $00, $66, $22
    sprite_oam_piece $09, $08, $65, $22
    sprite_oam_piece $01, $e8, $64, $22
    sprite_oam_piece $01, $f0, $63, $22
    sprite_oam_piece $01, $08, $62, $22
    sprite_oam_piece $09, $10, $54, $22
    sprite_oam_piece $01, $f8, $51, $22
    sprite_oam_piece $01, $00, $50, $22
    sprite_oam_piece $01, $10, $4e, $25
    sprite_oam_piece $f9, $e8, $4d, $26
    sprite_oam_piece $f9, $f0, $4c, $26
    sprite_oam_piece $f9, $f8, $4b, $26
    sprite_oam_piece $f9, $00, $4a, $26
    sprite_oam_piece $f9, $08, $49, $22
    sprite_oam_piece $f9, $10, $48, $22
    sprite_oam_piece $f1, $e8, $47, $26
    sprite_oam_piece $f1, $f0, $46, $26
    sprite_oam_piece $f1, $f8, $45, $26
    sprite_oam_piece $f1, $00, $44, $26
    sprite_oam_piece $f1, $08, $43, $22
    sprite_oam_piece $f1, $10, $42, $22

SpriteAnimation_WorkCarMoveLeft::
SpriteAnimation_046:: ; $1D:$76AD
    sprite_anim_entry SpriteFrame_1D_712B, $0a
    sprite_anim_entry SpriteFrame_1D_7170, $0a
    sprite_anim_entry SpriteFrame_1D_71B5, $0a
    sprite_anim_entry SpriteFrame_1D_7170, $0a
    sprite_anim_end

SpriteAnimation_048:: ; $1D:$76BB
    sprite_anim_entry SpriteFrame_1D_71FA, $0a
    sprite_anim_entry SpriteFrame_1D_723F, $0a
    sprite_anim_entry SpriteFrame_1D_7284, $0a
    sprite_anim_entry SpriteFrame_1D_723F, $0a
    sprite_anim_end

SpriteAnimation_050:: ; $1D:$76C9
    sprite_anim_entry SpriteFrame_1D_72C9, $0a
    sprite_anim_entry SpriteFrame_1D_730A, $0a
    sprite_anim_entry SpriteFrame_1D_734F, $0a
    sprite_anim_entry SpriteFrame_1D_730A, $0a
    sprite_anim_end

SpriteAnimation_052:: ; $1D:$76D7
    sprite_anim_entry SpriteFrame_1D_7398, $0a
    sprite_anim_entry SpriteFrame_1D_73D9, $0a
    sprite_anim_entry SpriteFrame_1D_741E, $0a
    sprite_anim_entry SpriteFrame_1D_73D9, $0a
    sprite_anim_end

SpriteAnimation_054:: ; $1D:$76E5
    sprite_anim_entry SpriteFrame_1D_7467, $0a
    sprite_anim_entry SpriteFrame_1D_74C8, $0a
    sprite_anim_entry SpriteFrame_1D_7529, $0a
    sprite_anim_entry SpriteFrame_1D_74C8, $0a
    sprite_anim_end

SpriteAnimation_056:: ; $1D:$76F3
    sprite_anim_entry SpriteFrame_1D_758A, $0a
    sprite_anim_entry SpriteFrame_1D_75EB, $0a
    sprite_anim_entry SpriteFrame_1D_764C, $0a
    sprite_anim_entry SpriteFrame_1D_75EB, $0a
    sprite_anim_end

SpriteAnimation_047:: ; $1D:$7701
    sprite_anim_entry SpriteFrame_1D_7170, $ff
    sprite_anim_end

SpriteAnimation_049:: ; $1D:$7706
    sprite_anim_entry SpriteFrame_1D_723F, $ff
    sprite_anim_end

SpriteAnimation_051:: ; $1D:$770B
    sprite_anim_entry SpriteFrame_1D_73D9, $ff
    sprite_anim_end

SpriteAnimation_053:: ; $1D:$7710
    sprite_anim_entry SpriteFrame_1D_74C8, $ff
    sprite_anim_end

SpriteAnimation_055:: ; $1D:$7715
    sprite_anim_entry SpriteFrame_1D_75EB, $ff
    sprite_anim_end

SpriteAnimation_057:: ; $1D:$771A
    sprite_anim_entry SpriteFrame_1D_730A, $ff
    sprite_anim_end

assert @ == $771f

section "Sprite Animation Data 1E:4000", romx[$4000], bank[$1e]

SpriteFrame_1E_4000::
    db 18
    sprite_oam_piece $08, $0c, $12, $02
    sprite_oam_piece $08, $04, $11, $02
    sprite_oam_piece $08, $fc, $10, $02
    sprite_oam_piece $08, $f4, $0f, $02
    sprite_oam_piece $08, $ec, $0e, $02
    sprite_oam_piece $00, $0c, $0d, $02
    sprite_oam_piece $00, $04, $0c, $02
    sprite_oam_piece $00, $fc, $0b, $02
    sprite_oam_piece $00, $f4, $0a, $05
    sprite_oam_piece $00, $ec, $09, $02
    sprite_oam_piece $f8, $0c, $08, $02
    sprite_oam_piece $f8, $04, $07, $02
    sprite_oam_piece $f8, $fc, $06, $02
    sprite_oam_piece $f8, $f4, $05, $05
    sprite_oam_piece $f8, $ec, $04, $02
    sprite_oam_piece $f0, $0c, $03, $02
    sprite_oam_piece $f0, $04, $02, $02
    sprite_oam_piece $f0, $fc, $01, $02

SpriteFrame_1E_4049::
    db 18
    sprite_oam_piece $07, $f4, $14, $02
    sprite_oam_piece $07, $ec, $13, $02
    sprite_oam_piece $07, $0c, $16, $02
    sprite_oam_piece $07, $04, $15, $02
    sprite_oam_piece $07, $fc, $10, $02
    sprite_oam_piece $ff, $0c, $0d, $02
    sprite_oam_piece $ff, $04, $0c, $02
    sprite_oam_piece $ff, $fc, $0b, $02
    sprite_oam_piece $ff, $f4, $0a, $05
    sprite_oam_piece $ff, $ec, $09, $02
    sprite_oam_piece $f7, $0c, $08, $02
    sprite_oam_piece $f7, $04, $07, $02
    sprite_oam_piece $f7, $fc, $06, $02
    sprite_oam_piece $f7, $f4, $05, $05
    sprite_oam_piece $f7, $ec, $04, $02
    sprite_oam_piece $ef, $0c, $03, $02
    sprite_oam_piece $ef, $04, $02, $02
    sprite_oam_piece $ef, $fc, $01, $02

SpriteFrame_1E_4092::
    db 18
    sprite_oam_piece $06, $0c, $1a, $02
    sprite_oam_piece $06, $04, $19, $02
    sprite_oam_piece $06, $f4, $18, $02
    sprite_oam_piece $06, $ec, $17, $02
    sprite_oam_piece $06, $fc, $10, $02
    sprite_oam_piece $fe, $0c, $0d, $02
    sprite_oam_piece $fe, $04, $0c, $02
    sprite_oam_piece $fe, $fc, $0b, $02
    sprite_oam_piece $fe, $f4, $0a, $05
    sprite_oam_piece $fe, $ec, $09, $02
    sprite_oam_piece $f6, $0c, $08, $02
    sprite_oam_piece $f6, $04, $07, $02
    sprite_oam_piece $f6, $fc, $06, $02
    sprite_oam_piece $f6, $f4, $05, $05
    sprite_oam_piece $f6, $ec, $04, $02
    sprite_oam_piece $ee, $0c, $03, $02
    sprite_oam_piece $ee, $04, $02, $02
    sprite_oam_piece $ee, $fc, $01, $02

SpriteFrame_1E_40DB::
    db 18
    sprite_oam_piece $08, $ec, $12, $22
    sprite_oam_piece $08, $f4, $11, $22
    sprite_oam_piece $08, $fc, $10, $22
    sprite_oam_piece $08, $04, $0f, $22
    sprite_oam_piece $08, $0c, $0e, $22
    sprite_oam_piece $00, $ec, $0d, $22
    sprite_oam_piece $00, $f4, $0c, $22
    sprite_oam_piece $00, $fc, $0b, $22
    sprite_oam_piece $00, $04, $0a, $25
    sprite_oam_piece $00, $0c, $09, $22
    sprite_oam_piece $f8, $ec, $08, $22
    sprite_oam_piece $f8, $f4, $07, $22
    sprite_oam_piece $f8, $fc, $06, $22
    sprite_oam_piece $f8, $04, $05, $25
    sprite_oam_piece $f8, $0c, $04, $22
    sprite_oam_piece $f0, $ec, $03, $22
    sprite_oam_piece $f0, $f4, $02, $22
    sprite_oam_piece $f0, $fc, $01, $22

SpriteFrame_1E_4124::
    db 18
    sprite_oam_piece $07, $04, $14, $22
    sprite_oam_piece $07, $0c, $13, $22
    sprite_oam_piece $07, $ec, $16, $22
    sprite_oam_piece $07, $f4, $15, $22
    sprite_oam_piece $07, $fc, $10, $22
    sprite_oam_piece $ff, $ec, $0d, $22
    sprite_oam_piece $ff, $f4, $0c, $22
    sprite_oam_piece $ff, $fc, $0b, $22
    sprite_oam_piece $ff, $04, $0a, $25
    sprite_oam_piece $ff, $0c, $09, $22
    sprite_oam_piece $f7, $ec, $08, $22
    sprite_oam_piece $f7, $f4, $07, $22
    sprite_oam_piece $f7, $fc, $06, $22
    sprite_oam_piece $f7, $04, $05, $25
    sprite_oam_piece $f7, $0c, $04, $22
    sprite_oam_piece $ef, $ec, $03, $22
    sprite_oam_piece $ef, $f4, $02, $22
    sprite_oam_piece $ef, $fc, $01, $22

SpriteFrame_1E_416D::
    db 18
    sprite_oam_piece $06, $ec, $1a, $22
    sprite_oam_piece $06, $f4, $19, $22
    sprite_oam_piece $06, $04, $18, $22
    sprite_oam_piece $06, $0c, $17, $22
    sprite_oam_piece $06, $fc, $10, $22
    sprite_oam_piece $fe, $ec, $0d, $22
    sprite_oam_piece $fe, $f4, $0c, $22
    sprite_oam_piece $fe, $fc, $0b, $22
    sprite_oam_piece $fe, $04, $0a, $25
    sprite_oam_piece $fe, $0c, $09, $22
    sprite_oam_piece $f6, $ec, $08, $22
    sprite_oam_piece $f6, $f4, $07, $22
    sprite_oam_piece $f6, $fc, $06, $22
    sprite_oam_piece $f6, $04, $05, $25
    sprite_oam_piece $f6, $0c, $04, $22
    sprite_oam_piece $ee, $ec, $03, $22
    sprite_oam_piece $ee, $f4, $02, $22
    sprite_oam_piece $ee, $fc, $01, $22

SpriteFrame_1E_41B6::
    db 18
    sprite_oam_piece $08, $0c, $2c, $02
    sprite_oam_piece $08, $04, $2b, $02
    sprite_oam_piece $08, $fc, $2a, $02
    sprite_oam_piece $08, $f4, $29, $02
    sprite_oam_piece $08, $ec, $28, $02
    sprite_oam_piece $00, $0c, $27, $02
    sprite_oam_piece $00, $04, $26, $02
    sprite_oam_piece $00, $fc, $25, $02
    sprite_oam_piece $00, $f4, $24, $05
    sprite_oam_piece $00, $ec, $23, $02
    sprite_oam_piece $f8, $0c, $22, $02
    sprite_oam_piece $f8, $04, $21, $02
    sprite_oam_piece $f8, $fc, $20, $02
    sprite_oam_piece $f8, $f4, $1f, $05
    sprite_oam_piece $f8, $ec, $1e, $02
    sprite_oam_piece $f0, $0c, $1d, $02
    sprite_oam_piece $f0, $04, $1c, $02
    sprite_oam_piece $f0, $fc, $1b, $02

SpriteFrame_1E_41FF::
    db 18
    sprite_oam_piece $07, $0c, $30, $02
    sprite_oam_piece $07, $04, $2f, $02
    sprite_oam_piece $07, $f4, $2e, $02
    sprite_oam_piece $07, $ec, $2d, $02
    sprite_oam_piece $07, $fc, $2a, $02
    sprite_oam_piece $ff, $0c, $27, $02
    sprite_oam_piece $ff, $04, $26, $02
    sprite_oam_piece $ff, $fc, $25, $02
    sprite_oam_piece $ff, $f4, $24, $05
    sprite_oam_piece $ff, $ec, $23, $02
    sprite_oam_piece $f7, $0c, $22, $02
    sprite_oam_piece $f7, $04, $21, $02
    sprite_oam_piece $f7, $fc, $20, $02
    sprite_oam_piece $f7, $f4, $1f, $05
    sprite_oam_piece $f7, $ec, $1e, $02
    sprite_oam_piece $ef, $0c, $1d, $02
    sprite_oam_piece $ef, $04, $1c, $02
    sprite_oam_piece $ef, $fc, $1b, $02

SpriteFrame_1E_4248::
    db 18
    sprite_oam_piece $06, $0c, $34, $02
    sprite_oam_piece $06, $04, $33, $02
    sprite_oam_piece $06, $f4, $32, $02
    sprite_oam_piece $06, $ec, $31, $02
    sprite_oam_piece $06, $fc, $2a, $02
    sprite_oam_piece $fe, $0c, $27, $02
    sprite_oam_piece $fe, $04, $26, $02
    sprite_oam_piece $fe, $fc, $25, $02
    sprite_oam_piece $fe, $f4, $24, $05
    sprite_oam_piece $fe, $ec, $23, $02
    sprite_oam_piece $f6, $0c, $22, $02
    sprite_oam_piece $f6, $04, $21, $02
    sprite_oam_piece $f6, $fc, $20, $02
    sprite_oam_piece $f6, $f4, $1f, $05
    sprite_oam_piece $f6, $ec, $1e, $02
    sprite_oam_piece $ee, $0c, $1d, $02
    sprite_oam_piece $ee, $04, $1c, $02
    sprite_oam_piece $ee, $fc, $1b, $02

SpriteFrame_1E_4291::
    db 18
    sprite_oam_piece $08, $ec, $2c, $22
    sprite_oam_piece $08, $f4, $2b, $22
    sprite_oam_piece $08, $fc, $2a, $22
    sprite_oam_piece $08, $04, $29, $22
    sprite_oam_piece $08, $0c, $28, $22
    sprite_oam_piece $00, $ec, $27, $22
    sprite_oam_piece $00, $f4, $26, $22
    sprite_oam_piece $00, $fc, $25, $22
    sprite_oam_piece $00, $04, $24, $25
    sprite_oam_piece $00, $0c, $23, $22
    sprite_oam_piece $f8, $ec, $22, $22
    sprite_oam_piece $f8, $f4, $21, $22
    sprite_oam_piece $f8, $fc, $20, $22
    sprite_oam_piece $f8, $04, $1f, $25
    sprite_oam_piece $f8, $0c, $1e, $22
    sprite_oam_piece $f0, $ec, $1d, $22
    sprite_oam_piece $f0, $f4, $1c, $22
    sprite_oam_piece $f0, $fc, $1b, $22

SpriteFrame_1E_42DA::
    db 18
    sprite_oam_piece $07, $ec, $30, $22
    sprite_oam_piece $07, $f4, $2f, $22
    sprite_oam_piece $07, $04, $2e, $22
    sprite_oam_piece $07, $0c, $2d, $22
    sprite_oam_piece $07, $fc, $2a, $22
    sprite_oam_piece $ff, $ec, $27, $22
    sprite_oam_piece $ff, $f4, $26, $22
    sprite_oam_piece $ff, $fc, $25, $22
    sprite_oam_piece $ff, $04, $24, $25
    sprite_oam_piece $ff, $0c, $23, $22
    sprite_oam_piece $f7, $ec, $22, $22
    sprite_oam_piece $f7, $f4, $21, $22
    sprite_oam_piece $f7, $fc, $20, $22
    sprite_oam_piece $f7, $04, $1f, $25
    sprite_oam_piece $f7, $0c, $1e, $22
    sprite_oam_piece $ef, $ec, $1d, $22
    sprite_oam_piece $ef, $f4, $1c, $22
    sprite_oam_piece $ef, $fc, $1b, $22

SpriteFrame_1E_4323::
    db 18
    sprite_oam_piece $06, $ec, $34, $22
    sprite_oam_piece $06, $f4, $33, $22
    sprite_oam_piece $06, $04, $32, $22
    sprite_oam_piece $06, $0c, $31, $22
    sprite_oam_piece $06, $fc, $2a, $22
    sprite_oam_piece $fe, $ec, $27, $22
    sprite_oam_piece $fe, $f4, $26, $22
    sprite_oam_piece $fe, $fc, $25, $22
    sprite_oam_piece $fe, $04, $24, $25
    sprite_oam_piece $fe, $0c, $23, $22
    sprite_oam_piece $f6, $ec, $22, $22
    sprite_oam_piece $f6, $f4, $21, $22
    sprite_oam_piece $f6, $fc, $20, $22
    sprite_oam_piece $f6, $04, $1f, $25
    sprite_oam_piece $f6, $0c, $1e, $22
    sprite_oam_piece $ee, $ec, $1d, $22
    sprite_oam_piece $ee, $f4, $1c, $22
    sprite_oam_piece $ee, $fc, $1b, $22

SpriteFrame_1E_436C::
    db 18
    sprite_oam_piece $08, $0c, $46, $02
    sprite_oam_piece $08, $04, $45, $02
    sprite_oam_piece $08, $fc, $44, $02
    sprite_oam_piece $08, $f4, $43, $02
    sprite_oam_piece $08, $ec, $42, $02
    sprite_oam_piece $00, $0c, $41, $02
    sprite_oam_piece $00, $04, $40, $02
    sprite_oam_piece $00, $fc, $3f, $02
    sprite_oam_piece $00, $f4, $3e, $02
    sprite_oam_piece $00, $ec, $3d, $02
    sprite_oam_piece $f8, $0c, $3c, $02
    sprite_oam_piece $f8, $04, $3b, $02
    sprite_oam_piece $f8, $fc, $3a, $02
    sprite_oam_piece $f8, $f4, $39, $02
    sprite_oam_piece $f8, $ec, $38, $02
    sprite_oam_piece $f0, $04, $37, $02
    sprite_oam_piece $f0, $fc, $36, $02
    sprite_oam_piece $f0, $f4, $35, $02

SpriteFrame_1E_43B5::
    db 18
    sprite_oam_piece $07, $0c, $4b, $02
    sprite_oam_piece $07, $04, $4a, $02
    sprite_oam_piece $07, $f4, $49, $02
    sprite_oam_piece $07, $ec, $48, $02
    sprite_oam_piece $ff, $0c, $47, $02
    sprite_oam_piece $07, $fc, $44, $02
    sprite_oam_piece $ff, $04, $40, $02
    sprite_oam_piece $ff, $fc, $3f, $02
    sprite_oam_piece $ff, $f4, $3e, $02
    sprite_oam_piece $ff, $ec, $3d, $02
    sprite_oam_piece $f7, $0c, $3c, $02
    sprite_oam_piece $f7, $04, $3b, $02
    sprite_oam_piece $f7, $fc, $3a, $02
    sprite_oam_piece $f7, $f4, $39, $02
    sprite_oam_piece $f7, $ec, $38, $02
    sprite_oam_piece $ef, $04, $37, $02
    sprite_oam_piece $ef, $fc, $36, $02
    sprite_oam_piece $ef, $f4, $35, $02

SpriteFrame_1E_43FE::
    db 18
    sprite_oam_piece $06, $0c, $50, $02
    sprite_oam_piece $06, $04, $4f, $02
    sprite_oam_piece $06, $f4, $4e, $02
    sprite_oam_piece $06, $ec, $4d, $02
    sprite_oam_piece $fe, $0c, $4c, $02
    sprite_oam_piece $06, $fc, $44, $02
    sprite_oam_piece $fe, $04, $40, $02
    sprite_oam_piece $fe, $fc, $3f, $02
    sprite_oam_piece $fe, $f4, $3e, $02
    sprite_oam_piece $fe, $ec, $3d, $02
    sprite_oam_piece $f6, $0c, $3c, $02
    sprite_oam_piece $f6, $04, $3b, $02
    sprite_oam_piece $f6, $fc, $3a, $02
    sprite_oam_piece $f6, $f4, $39, $02
    sprite_oam_piece $f6, $ec, $38, $02
    sprite_oam_piece $ee, $04, $37, $02
    sprite_oam_piece $ee, $fc, $36, $02
    sprite_oam_piece $ee, $f4, $35, $02

SpriteFrame_1E_4447::
    db 18
    sprite_oam_piece $08, $ec, $46, $22
    sprite_oam_piece $08, $f4, $45, $22
    sprite_oam_piece $08, $fc, $44, $22
    sprite_oam_piece $08, $04, $43, $22
    sprite_oam_piece $08, $0c, $42, $22
    sprite_oam_piece $00, $ec, $41, $22
    sprite_oam_piece $00, $f4, $40, $22
    sprite_oam_piece $00, $fc, $3f, $22
    sprite_oam_piece $00, $04, $3e, $22
    sprite_oam_piece $00, $0c, $3d, $22
    sprite_oam_piece $f8, $ec, $3c, $22
    sprite_oam_piece $f8, $f4, $3b, $22
    sprite_oam_piece $f8, $fc, $3a, $22
    sprite_oam_piece $f8, $04, $39, $22
    sprite_oam_piece $f8, $0c, $38, $22
    sprite_oam_piece $f0, $f4, $37, $22
    sprite_oam_piece $f0, $fc, $36, $22
    sprite_oam_piece $f0, $04, $35, $22

SpriteFrame_1E_4490::
    db 18
    sprite_oam_piece $07, $ec, $4b, $22
    sprite_oam_piece $07, $f4, $4a, $22
    sprite_oam_piece $07, $04, $49, $22
    sprite_oam_piece $07, $0c, $48, $22
    sprite_oam_piece $ff, $ec, $47, $22
    sprite_oam_piece $07, $fc, $44, $22
    sprite_oam_piece $ff, $f4, $40, $22
    sprite_oam_piece $ff, $fc, $3f, $22
    sprite_oam_piece $ff, $04, $3e, $22
    sprite_oam_piece $ff, $0c, $3d, $22
    sprite_oam_piece $f7, $ec, $3c, $22
    sprite_oam_piece $f7, $f4, $3b, $22
    sprite_oam_piece $f7, $fc, $3a, $22
    sprite_oam_piece $f7, $04, $39, $22
    sprite_oam_piece $f7, $0c, $38, $22
    sprite_oam_piece $ef, $f4, $37, $22
    sprite_oam_piece $ef, $fc, $36, $22
    sprite_oam_piece $ef, $04, $35, $22

SpriteFrame_1E_44D9::
    db 18
    sprite_oam_piece $06, $ec, $50, $22
    sprite_oam_piece $06, $f4, $4f, $22
    sprite_oam_piece $06, $04, $4e, $22
    sprite_oam_piece $06, $0c, $4d, $22
    sprite_oam_piece $fe, $ec, $4c, $22
    sprite_oam_piece $06, $fc, $44, $22
    sprite_oam_piece $fe, $f4, $40, $22
    sprite_oam_piece $fe, $fc, $3f, $22
    sprite_oam_piece $fe, $04, $3e, $22
    sprite_oam_piece $fe, $0c, $3d, $22
    sprite_oam_piece $f6, $ec, $3c, $22
    sprite_oam_piece $f6, $f4, $3b, $22
    sprite_oam_piece $f6, $fc, $3a, $22
    sprite_oam_piece $f6, $04, $39, $22
    sprite_oam_piece $f6, $0c, $38, $22
    sprite_oam_piece $ee, $f4, $37, $22
    sprite_oam_piece $ee, $fc, $36, $22
    sprite_oam_piece $ee, $04, $35, $22

SpriteAnimation_062:: ; $1E:$4522
    sprite_anim_entry SpriteFrame_1E_41B6, $0a
    sprite_anim_entry SpriteFrame_1E_41FF, $0a
    sprite_anim_entry SpriteFrame_1E_4248, $0a
    sprite_anim_entry SpriteFrame_1E_41FF, $0a
    sprite_anim_end

SpriteAnimation_060:: ; $1E:$4530
    sprite_anim_entry SpriteFrame_1E_40DB, $0a
    sprite_anim_entry SpriteFrame_1E_4124, $0a
    sprite_anim_entry SpriteFrame_1E_416D, $0a
    sprite_anim_entry SpriteFrame_1E_4124, $0a
    sprite_anim_end

SpriteAnimation_058:: ; $1E:$453E
    sprite_anim_entry SpriteFrame_1E_4000, $0a
    sprite_anim_entry SpriteFrame_1E_4049, $0a
    sprite_anim_entry SpriteFrame_1E_4092, $0a
    sprite_anim_entry SpriteFrame_1E_4049, $0a
    sprite_anim_end

SpriteAnimation_064:: ; $1E:$454C
    sprite_anim_entry SpriteFrame_1E_4291, $0a
    sprite_anim_entry SpriteFrame_1E_42DA, $0a
    sprite_anim_entry SpriteFrame_1E_4323, $0a
    sprite_anim_entry SpriteFrame_1E_42DA, $0a
    sprite_anim_end

SpriteAnimation_066:: ; $1E:$455A
    sprite_anim_entry SpriteFrame_1E_436C, $0a
    sprite_anim_entry SpriteFrame_1E_43B5, $0a
    sprite_anim_entry SpriteFrame_1E_43FE, $0a
    sprite_anim_entry SpriteFrame_1E_43B5, $0a
    sprite_anim_end

SpriteAnimation_068:: ; $1E:$4568
    sprite_anim_entry SpriteFrame_1E_4447, $0a
    sprite_anim_entry SpriteFrame_1E_4490, $0a
    sprite_anim_entry SpriteFrame_1E_44D9, $0a
    sprite_anim_entry SpriteFrame_1E_4490, $0a
    sprite_anim_end

SpriteAnimation_061:: ; $1E:$4576
    sprite_anim_entry SpriteFrame_1E_4124, $ff
    sprite_anim_end

SpriteAnimation_059:: ; $1E:$457B
    sprite_anim_entry SpriteFrame_1E_4049, $ff
    sprite_anim_end

SpriteAnimation_063:: ; $1E:$4580
    sprite_anim_entry SpriteFrame_1E_41FF, $ff
    sprite_anim_end

SpriteAnimation_065:: ; $1E:$4585
    sprite_anim_entry SpriteFrame_1E_42DA, $ff
    sprite_anim_end

SpriteAnimation_067:: ; $1E:$458A
    sprite_anim_entry SpriteFrame_1E_43B5, $ff
    sprite_anim_end

SpriteAnimation_069:: ; $1E:$458F
    sprite_anim_entry SpriteFrame_1E_4490, $ff
    sprite_anim_end

assert @ == $4594

section "Sprite Animation Data 1E:4AFC", romx[$4afc], bank[$1e]

SpriteFrame_1E_4AFC::
    db 19
    sprite_oam_piece $08, $0c, $13, $02
    sprite_oam_piece $08, $04, $12, $02
    sprite_oam_piece $08, $fc, $11, $02
    sprite_oam_piece $08, $f4, $10, $02
    sprite_oam_piece $08, $ec, $0f, $02
    sprite_oam_piece $00, $0c, $0e, $02
    sprite_oam_piece $00, $04, $0d, $02
    sprite_oam_piece $00, $fc, $0c, $02
    sprite_oam_piece $00, $f4, $0b, $02
    sprite_oam_piece $00, $ec, $0a, $02
    sprite_oam_piece $f8, $0c, $09, $02
    sprite_oam_piece $f8, $04, $08, $02
    sprite_oam_piece $f8, $fc, $07, $02
    sprite_oam_piece $f8, $f4, $06, $02
    sprite_oam_piece $f8, $ec, $05, $02
    sprite_oam_piece $f0, $0c, $04, $02
    sprite_oam_piece $f0, $04, $03, $02
    sprite_oam_piece $f0, $fc, $02, $02
    sprite_oam_piece $f0, $f4, $01, $02

SpriteFrame_1E_4B49::
    db 19
    sprite_oam_piece $ff, $ec, $0a, $02
    sprite_oam_piece $ff, $0c, $14, $02
    sprite_oam_piece $ff, $04, $0d, $02
    sprite_oam_piece $ff, $f4, $0b, $02
    sprite_oam_piece $07, $0c, $18, $02
    sprite_oam_piece $07, $04, $17, $02
    sprite_oam_piece $07, $fc, $11, $02
    sprite_oam_piece $07, $f4, $16, $02
    sprite_oam_piece $07, $ec, $15, $02
    sprite_oam_piece $ff, $fc, $0c, $02
    sprite_oam_piece $f7, $0c, $09, $02
    sprite_oam_piece $f7, $04, $08, $02
    sprite_oam_piece $f7, $fc, $07, $02
    sprite_oam_piece $f7, $f4, $06, $02
    sprite_oam_piece $f7, $ec, $05, $02
    sprite_oam_piece $ef, $0c, $04, $02
    sprite_oam_piece $ef, $04, $03, $02
    sprite_oam_piece $ef, $fc, $02, $02
    sprite_oam_piece $ef, $f4, $01, $02

SpriteFrame_1E_4B96::
    db 19
    sprite_oam_piece $fe, $ec, $0a, $02
    sprite_oam_piece $fe, $f4, $0b, $02
    sprite_oam_piece $06, $0c, $1d, $02
    sprite_oam_piece $06, $04, $1c, $02
    sprite_oam_piece $06, $fc, $11, $02
    sprite_oam_piece $06, $f4, $1b, $02
    sprite_oam_piece $06, $ec, $1a, $02
    sprite_oam_piece $fe, $0c, $19, $02
    sprite_oam_piece $fe, $04, $0d, $02
    sprite_oam_piece $fe, $fc, $0c, $02
    sprite_oam_piece $f6, $0c, $09, $02
    sprite_oam_piece $f6, $04, $08, $02
    sprite_oam_piece $f6, $fc, $07, $02
    sprite_oam_piece $f6, $f4, $06, $02
    sprite_oam_piece $f6, $ec, $05, $02
    sprite_oam_piece $ee, $0c, $04, $02
    sprite_oam_piece $ee, $04, $03, $02
    sprite_oam_piece $ee, $fc, $02, $02
    sprite_oam_piece $ee, $f4, $01, $02

SpriteFrame_1E_4BE3::
    db 19
    sprite_oam_piece $08, $ec, $13, $22
    sprite_oam_piece $08, $f4, $12, $22
    sprite_oam_piece $08, $fc, $11, $22
    sprite_oam_piece $08, $04, $10, $22
    sprite_oam_piece $08, $0c, $0f, $22
    sprite_oam_piece $00, $ec, $0e, $22
    sprite_oam_piece $00, $f4, $0d, $22
    sprite_oam_piece $00, $fc, $0c, $22
    sprite_oam_piece $00, $04, $0b, $22
    sprite_oam_piece $00, $0c, $0a, $22
    sprite_oam_piece $f8, $ec, $09, $22
    sprite_oam_piece $f8, $f4, $08, $22
    sprite_oam_piece $f8, $fc, $07, $22
    sprite_oam_piece $f8, $04, $06, $22
    sprite_oam_piece $f8, $0c, $05, $22
    sprite_oam_piece $f0, $ec, $04, $22
    sprite_oam_piece $f0, $f4, $03, $22
    sprite_oam_piece $f0, $fc, $02, $22
    sprite_oam_piece $f0, $04, $01, $22

SpriteFrame_1E_4C30::
    db 19
    sprite_oam_piece $ff, $0c, $0a, $22
    sprite_oam_piece $ff, $ec, $14, $22
    sprite_oam_piece $ff, $f4, $0d, $22
    sprite_oam_piece $ff, $04, $0b, $22
    sprite_oam_piece $07, $ec, $18, $22
    sprite_oam_piece $07, $f4, $17, $22
    sprite_oam_piece $07, $fc, $11, $22
    sprite_oam_piece $07, $04, $16, $22
    sprite_oam_piece $07, $0c, $15, $22
    sprite_oam_piece $ff, $fc, $0c, $22
    sprite_oam_piece $f7, $ec, $09, $22
    sprite_oam_piece $f7, $f4, $08, $22
    sprite_oam_piece $f7, $fc, $07, $22
    sprite_oam_piece $f7, $04, $06, $22
    sprite_oam_piece $f7, $0c, $05, $22
    sprite_oam_piece $ef, $ec, $04, $22
    sprite_oam_piece $ef, $f4, $03, $22
    sprite_oam_piece $ef, $fc, $02, $22
    sprite_oam_piece $ef, $04, $01, $22

SpriteFrame_1E_4C7D::
    db 19
    sprite_oam_piece $fe, $0c, $0a, $22
    sprite_oam_piece $fe, $04, $0b, $22
    sprite_oam_piece $06, $ec, $1d, $22
    sprite_oam_piece $06, $f4, $1c, $22
    sprite_oam_piece $06, $fc, $11, $22
    sprite_oam_piece $06, $04, $1b, $22
    sprite_oam_piece $06, $0c, $1a, $22
    sprite_oam_piece $fe, $ec, $19, $22
    sprite_oam_piece $fe, $f4, $0d, $22
    sprite_oam_piece $fe, $fc, $0c, $22
    sprite_oam_piece $f6, $ec, $09, $22
    sprite_oam_piece $f6, $f4, $08, $22
    sprite_oam_piece $f6, $fc, $07, $22
    sprite_oam_piece $f6, $04, $06, $22
    sprite_oam_piece $f6, $0c, $05, $22
    sprite_oam_piece $ee, $ec, $04, $22
    sprite_oam_piece $ee, $f4, $03, $22
    sprite_oam_piece $ee, $fc, $02, $22
    sprite_oam_piece $ee, $04, $01, $22

SpriteFrame_1E_4CCA::
    db 18
    sprite_oam_piece $08, $0c, $2f, $02
    sprite_oam_piece $08, $04, $2e, $02
    sprite_oam_piece $08, $fc, $2d, $02
    sprite_oam_piece $08, $f4, $2c, $02
    sprite_oam_piece $08, $ec, $2b, $02
    sprite_oam_piece $00, $0c, $2a, $02
    sprite_oam_piece $00, $04, $29, $02
    sprite_oam_piece $00, $fc, $28, $05
    sprite_oam_piece $00, $f4, $27, $02
    sprite_oam_piece $00, $ec, $26, $02
    sprite_oam_piece $f8, $0c, $25, $02
    sprite_oam_piece $f8, $04, $24, $02
    sprite_oam_piece $f8, $fc, $23, $02
    sprite_oam_piece $f8, $f4, $22, $02
    sprite_oam_piece $f8, $ec, $21, $02
    sprite_oam_piece $f0, $04, $20, $02
    sprite_oam_piece $f0, $fc, $1f, $02
    sprite_oam_piece $f0, $f4, $1e, $02

SpriteFrame_1E_4D13::
    db 18
    sprite_oam_piece $07, $0c, $33, $02
    sprite_oam_piece $07, $04, $32, $02
    sprite_oam_piece $07, $f4, $31, $02
    sprite_oam_piece $07, $ec, $30, $02
    sprite_oam_piece $07, $fc, $2d, $02
    sprite_oam_piece $ff, $0c, $2a, $02
    sprite_oam_piece $ff, $04, $29, $02
    sprite_oam_piece $ff, $fc, $28, $05
    sprite_oam_piece $ff, $f4, $27, $02
    sprite_oam_piece $ff, $ec, $26, $02
    sprite_oam_piece $f7, $0c, $25, $02
    sprite_oam_piece $f7, $04, $24, $02
    sprite_oam_piece $f7, $fc, $23, $02
    sprite_oam_piece $f7, $f4, $22, $02
    sprite_oam_piece $f7, $ec, $21, $02
    sprite_oam_piece $ef, $04, $20, $02
    sprite_oam_piece $ef, $fc, $1f, $02
    sprite_oam_piece $ef, $f4, $1e, $02

SpriteFrame_1E_4D5C::
    db 18
    sprite_oam_piece $06, $0c, $37, $02
    sprite_oam_piece $06, $04, $36, $02
    sprite_oam_piece $06, $f4, $35, $02
    sprite_oam_piece $06, $ec, $34, $02
    sprite_oam_piece $06, $fc, $2d, $02
    sprite_oam_piece $fe, $0c, $2a, $02
    sprite_oam_piece $fe, $04, $29, $02
    sprite_oam_piece $fe, $fc, $28, $05
    sprite_oam_piece $fe, $f4, $27, $02
    sprite_oam_piece $fe, $ec, $26, $02
    sprite_oam_piece $f6, $0c, $25, $02
    sprite_oam_piece $f6, $04, $24, $02
    sprite_oam_piece $f6, $fc, $23, $02
    sprite_oam_piece $f6, $f4, $22, $02
    sprite_oam_piece $f6, $ec, $21, $02
    sprite_oam_piece $ee, $04, $20, $02
    sprite_oam_piece $ee, $fc, $1f, $02
    sprite_oam_piece $ee, $f4, $1e, $02

SpriteFrame_1E_4DA5::
    db 18
    sprite_oam_piece $08, $ec, $2f, $22
    sprite_oam_piece $08, $f4, $2e, $22
    sprite_oam_piece $08, $fc, $2d, $22
    sprite_oam_piece $08, $04, $2c, $22
    sprite_oam_piece $08, $0c, $2b, $22
    sprite_oam_piece $00, $ec, $2a, $22
    sprite_oam_piece $00, $f4, $29, $22
    sprite_oam_piece $00, $fc, $28, $25
    sprite_oam_piece $00, $04, $27, $22
    sprite_oam_piece $00, $0c, $26, $22
    sprite_oam_piece $f8, $ec, $25, $22
    sprite_oam_piece $f8, $f4, $24, $22
    sprite_oam_piece $f8, $fc, $23, $22
    sprite_oam_piece $f8, $04, $22, $22
    sprite_oam_piece $f8, $0c, $21, $22
    sprite_oam_piece $f0, $f4, $20, $22
    sprite_oam_piece $f0, $fc, $1f, $22
    sprite_oam_piece $f0, $04, $1e, $22

SpriteFrame_1E_4DEE::
    db 18
    sprite_oam_piece $07, $ec, $33, $22
    sprite_oam_piece $07, $f4, $32, $22
    sprite_oam_piece $07, $04, $31, $22
    sprite_oam_piece $07, $0c, $30, $22
    sprite_oam_piece $07, $fc, $2d, $22
    sprite_oam_piece $ff, $ec, $2a, $22
    sprite_oam_piece $ff, $f4, $29, $22
    sprite_oam_piece $ff, $fc, $28, $25
    sprite_oam_piece $ff, $04, $27, $22
    sprite_oam_piece $ff, $0c, $26, $22
    sprite_oam_piece $f7, $ec, $25, $22
    sprite_oam_piece $f7, $f4, $24, $22
    sprite_oam_piece $f7, $fc, $23, $22
    sprite_oam_piece $f7, $04, $22, $22
    sprite_oam_piece $f7, $0c, $21, $22
    sprite_oam_piece $ef, $f4, $20, $22
    sprite_oam_piece $ef, $fc, $1f, $22
    sprite_oam_piece $ef, $04, $1e, $22

SpriteFrame_1E_4E37::
    db 18
    sprite_oam_piece $06, $ec, $37, $22
    sprite_oam_piece $06, $f4, $36, $22
    sprite_oam_piece $06, $04, $35, $22
    sprite_oam_piece $06, $0c, $34, $22
    sprite_oam_piece $06, $fc, $2d, $22
    sprite_oam_piece $fe, $ec, $2a, $22
    sprite_oam_piece $fe, $f4, $29, $22
    sprite_oam_piece $fe, $fc, $28, $25
    sprite_oam_piece $fe, $04, $27, $22
    sprite_oam_piece $fe, $0c, $26, $22
    sprite_oam_piece $f6, $ec, $25, $22
    sprite_oam_piece $f6, $f4, $24, $22
    sprite_oam_piece $f6, $fc, $23, $22
    sprite_oam_piece $f6, $04, $22, $22
    sprite_oam_piece $f6, $0c, $21, $22
    sprite_oam_piece $ee, $f4, $20, $22
    sprite_oam_piece $ee, $fc, $1f, $22
    sprite_oam_piece $ee, $04, $1e, $22

SpriteFrame_1E_4E80::
    db 18
    sprite_oam_piece $08, $0c, $49, $02
    sprite_oam_piece $08, $04, $48, $02
    sprite_oam_piece $08, $fc, $47, $02
    sprite_oam_piece $08, $f4, $46, $02
    sprite_oam_piece $08, $ec, $45, $02
    sprite_oam_piece $00, $0c, $44, $02
    sprite_oam_piece $00, $04, $43, $02
    sprite_oam_piece $00, $fc, $42, $05
    sprite_oam_piece $00, $f4, $41, $02
    sprite_oam_piece $00, $ec, $40, $02
    sprite_oam_piece $f8, $0c, $3f, $02
    sprite_oam_piece $f8, $04, $3e, $02
    sprite_oam_piece $f8, $fc, $3d, $02
    sprite_oam_piece $f8, $f4, $3c, $02
    sprite_oam_piece $f8, $ec, $3b, $02
    sprite_oam_piece $f0, $04, $3a, $02
    sprite_oam_piece $f0, $fc, $39, $02
    sprite_oam_piece $f0, $f4, $38, $02

SpriteFrame_1E_4EC9::
    db 18
    sprite_oam_piece $07, $fc, $47, $02
    sprite_oam_piece $07, $0c, $4d, $02
    sprite_oam_piece $07, $04, $4c, $02
    sprite_oam_piece $07, $f4, $4b, $02
    sprite_oam_piece $07, $ec, $4a, $02
    sprite_oam_piece $ff, $0c, $44, $02
    sprite_oam_piece $ff, $04, $43, $02
    sprite_oam_piece $ff, $fc, $42, $05
    sprite_oam_piece $ff, $f4, $41, $02
    sprite_oam_piece $ff, $ec, $40, $02
    sprite_oam_piece $f7, $0c, $3f, $02
    sprite_oam_piece $f7, $04, $3e, $02
    sprite_oam_piece $f7, $fc, $3d, $02
    sprite_oam_piece $f7, $f4, $3c, $02
    sprite_oam_piece $f7, $ec, $3b, $02
    sprite_oam_piece $ef, $04, $3a, $02
    sprite_oam_piece $ef, $fc, $39, $02
    sprite_oam_piece $ef, $f4, $38, $02

SpriteFrame_1E_4F12::
    db 18
    sprite_oam_piece $06, $fc, $47, $02
    sprite_oam_piece $06, $0c, $51, $02
    sprite_oam_piece $06, $04, $50, $02
    sprite_oam_piece $06, $f4, $4f, $02
    sprite_oam_piece $06, $ec, $4e, $02
    sprite_oam_piece $fe, $0c, $44, $02
    sprite_oam_piece $fe, $04, $43, $02
    sprite_oam_piece $fe, $fc, $42, $05
    sprite_oam_piece $fe, $f4, $41, $02
    sprite_oam_piece $fe, $ec, $40, $02
    sprite_oam_piece $f6, $0c, $3f, $02
    sprite_oam_piece $f6, $04, $3e, $02
    sprite_oam_piece $f6, $fc, $3d, $02
    sprite_oam_piece $f6, $f4, $3c, $02
    sprite_oam_piece $f6, $ec, $3b, $02
    sprite_oam_piece $ee, $04, $3a, $02
    sprite_oam_piece $ee, $fc, $39, $02
    sprite_oam_piece $ee, $f4, $38, $02

SpriteFrame_1E_4F5B::
    db 18
    sprite_oam_piece $08, $ec, $49, $22
    sprite_oam_piece $08, $f4, $48, $22
    sprite_oam_piece $08, $fc, $47, $22
    sprite_oam_piece $08, $04, $46, $22
    sprite_oam_piece $08, $0c, $45, $22
    sprite_oam_piece $00, $ec, $44, $22
    sprite_oam_piece $00, $f4, $43, $22
    sprite_oam_piece $00, $fc, $42, $25
    sprite_oam_piece $00, $04, $41, $22
    sprite_oam_piece $00, $0c, $40, $22
    sprite_oam_piece $f8, $ec, $3f, $22
    sprite_oam_piece $f8, $f4, $3e, $22
    sprite_oam_piece $f8, $fc, $3d, $22
    sprite_oam_piece $f8, $04, $3c, $22
    sprite_oam_piece $f8, $0c, $3b, $22
    sprite_oam_piece $f0, $f4, $3a, $22
    sprite_oam_piece $f0, $fc, $39, $22
    sprite_oam_piece $f0, $04, $38, $22

SpriteFrame_1E_4FA4::
    db 18
    sprite_oam_piece $07, $fc, $47, $22
    sprite_oam_piece $07, $ec, $4d, $22
    sprite_oam_piece $07, $f4, $4c, $22
    sprite_oam_piece $07, $04, $4b, $22
    sprite_oam_piece $07, $0c, $4a, $22
    sprite_oam_piece $ff, $ec, $44, $22
    sprite_oam_piece $ff, $f4, $43, $22
    sprite_oam_piece $ff, $fc, $42, $25
    sprite_oam_piece $ff, $04, $41, $22
    sprite_oam_piece $ff, $0c, $40, $22
    sprite_oam_piece $f7, $ec, $3f, $22
    sprite_oam_piece $f7, $f4, $3e, $22
    sprite_oam_piece $f7, $fc, $3d, $22
    sprite_oam_piece $f7, $04, $3c, $22
    sprite_oam_piece $f7, $0c, $3b, $22
    sprite_oam_piece $ef, $f4, $3a, $22
    sprite_oam_piece $ef, $fc, $39, $22
    sprite_oam_piece $ef, $04, $38, $22

SpriteFrame_1E_4FED::
    db 18
    sprite_oam_piece $06, $fc, $47, $22
    sprite_oam_piece $06, $ec, $51, $22
    sprite_oam_piece $06, $f4, $50, $22
    sprite_oam_piece $06, $04, $4f, $22
    sprite_oam_piece $06, $0c, $4e, $22
    sprite_oam_piece $fe, $ec, $44, $22
    sprite_oam_piece $fe, $f4, $43, $22
    sprite_oam_piece $fe, $fc, $42, $25
    sprite_oam_piece $fe, $04, $41, $22
    sprite_oam_piece $fe, $0c, $40, $22
    sprite_oam_piece $f6, $ec, $3f, $22
    sprite_oam_piece $f6, $f4, $3e, $22
    sprite_oam_piece $f6, $fc, $3d, $22
    sprite_oam_piece $f6, $04, $3c, $22
    sprite_oam_piece $f6, $0c, $3b, $22
    sprite_oam_piece $ee, $f4, $3a, $22
    sprite_oam_piece $ee, $fc, $39, $22
    sprite_oam_piece $ee, $04, $38, $22

SpriteAnimation_070:: ; $1E:$5036
    sprite_anim_entry SpriteFrame_1E_4AFC, $0a
    sprite_anim_entry SpriteFrame_1E_4B49, $0a
    sprite_anim_entry SpriteFrame_1E_4B96, $0a
    sprite_anim_entry SpriteFrame_1E_4B49, $0a
    sprite_anim_end

SpriteAnimation_074:: ; $1E:$5044
    sprite_anim_entry SpriteFrame_1E_4CCA, $0a
    sprite_anim_entry SpriteFrame_1E_4D13, $0a
    sprite_anim_entry SpriteFrame_1E_4D5C, $0a
    sprite_anim_entry SpriteFrame_1E_4D13, $0a
    sprite_anim_end

SpriteAnimation_072:: ; $1E:$5052
    sprite_anim_entry SpriteFrame_1E_4BE3, $0a
    sprite_anim_entry SpriteFrame_1E_4C30, $0a
    sprite_anim_entry SpriteFrame_1E_4C7D, $0a
    sprite_anim_entry SpriteFrame_1E_4C30, $0a
    sprite_anim_end

SpriteAnimation_076:: ; $1E:$5060
    sprite_anim_entry SpriteFrame_1E_4DA5, $0a
    sprite_anim_entry SpriteFrame_1E_4DEE, $0a
    sprite_anim_entry SpriteFrame_1E_4E37, $0a
    sprite_anim_entry SpriteFrame_1E_4DEE, $0a
    sprite_anim_end

SpriteAnimation_078:: ; $1E:$506E
    sprite_anim_entry SpriteFrame_1E_4E80, $0a
    sprite_anim_entry SpriteFrame_1E_4EC9, $0a
    sprite_anim_entry SpriteFrame_1E_4F12, $0a
    sprite_anim_entry SpriteFrame_1E_4EC9, $0a
    sprite_anim_end

SpriteAnimation_080:: ; $1E:$507C
    sprite_anim_entry SpriteFrame_1E_4F5B, $0a
    sprite_anim_entry SpriteFrame_1E_4FA4, $0a
    sprite_anim_entry SpriteFrame_1E_4FED, $0a
    sprite_anim_entry SpriteFrame_1E_4FA4, $0a
    sprite_anim_end

SpriteAnimation_071:: ; $1E:$508A
    sprite_anim_entry SpriteFrame_1E_4B49, $ff
    sprite_anim_end

SpriteAnimation_073:: ; $1E:$508F
    sprite_anim_entry SpriteFrame_1E_4C30, $ff
    sprite_anim_end

SpriteAnimation_075:: ; $1E:$5094
    sprite_anim_entry SpriteFrame_1E_4D13, $ff
    sprite_anim_end

SpriteAnimation_077:: ; $1E:$5099
    sprite_anim_entry SpriteFrame_1E_4DEE, $ff
    sprite_anim_end

SpriteAnimation_079:: ; $1E:$509E
    sprite_anim_entry SpriteFrame_1E_4EC9, $ff
    sprite_anim_end

SpriteAnimation_081:: ; $1E:$50A3
    sprite_anim_entry SpriteFrame_1E_4FA4, $ff
    sprite_anim_end

assert @ == $50a8

section "Sprite Animation Data 1E:5620", romx[$5620], bank[$1e]

SpriteFrame_1E_5620::
    db 18
    sprite_oam_piece $f0, $f4, $01, $02
    sprite_oam_piece $08, $0c, $12, $02
    sprite_oam_piece $08, $04, $11, $02
    sprite_oam_piece $08, $fc, $10, $02
    sprite_oam_piece $08, $f4, $0f, $02
    sprite_oam_piece $08, $ec, $0e, $02
    sprite_oam_piece $00, $0c, $0d, $02
    sprite_oam_piece $00, $04, $0c, $02
    sprite_oam_piece $00, $fc, $0b, $02
    sprite_oam_piece $00, $f4, $0a, $02
    sprite_oam_piece $00, $ec, $09, $02
    sprite_oam_piece $f8, $0c, $08, $02
    sprite_oam_piece $f8, $04, $07, $02
    sprite_oam_piece $f8, $fc, $06, $02
    sprite_oam_piece $f8, $f4, $05, $02
    sprite_oam_piece $f8, $ec, $04, $02
    sprite_oam_piece $f0, $04, $03, $02
    sprite_oam_piece $f0, $fc, $02, $02

SpriteFrame_1E_5669::
    db 18
    sprite_oam_piece $ef, $f4, $01, $02
    sprite_oam_piece $07, $0c, $16, $02
    sprite_oam_piece $07, $04, $15, $02
    sprite_oam_piece $07, $f4, $14, $02
    sprite_oam_piece $07, $ec, $13, $02
    sprite_oam_piece $07, $fc, $10, $02
    sprite_oam_piece $ff, $0c, $0d, $02
    sprite_oam_piece $ff, $04, $0c, $02
    sprite_oam_piece $ff, $fc, $0b, $02
    sprite_oam_piece $ff, $f4, $0a, $02
    sprite_oam_piece $ff, $ec, $09, $02
    sprite_oam_piece $f7, $0c, $08, $02
    sprite_oam_piece $f7, $04, $07, $02
    sprite_oam_piece $f7, $fc, $06, $02
    sprite_oam_piece $f7, $f4, $05, $02
    sprite_oam_piece $f7, $ec, $04, $02
    sprite_oam_piece $ef, $04, $03, $02
    sprite_oam_piece $ef, $fc, $02, $02

SpriteFrame_1E_56B2::
    db 18
    sprite_oam_piece $ee, $f4, $01, $02
    sprite_oam_piece $06, $0c, $1a, $02
    sprite_oam_piece $06, $04, $19, $02
    sprite_oam_piece $06, $f4, $18, $02
    sprite_oam_piece $06, $ec, $17, $02
    sprite_oam_piece $06, $fc, $10, $02
    sprite_oam_piece $fe, $0c, $0d, $02
    sprite_oam_piece $fe, $04, $0c, $02
    sprite_oam_piece $fe, $fc, $0b, $02
    sprite_oam_piece $fe, $f4, $0a, $02
    sprite_oam_piece $fe, $ec, $09, $02
    sprite_oam_piece $f6, $0c, $08, $02
    sprite_oam_piece $f6, $04, $07, $02
    sprite_oam_piece $f6, $fc, $06, $02
    sprite_oam_piece $f6, $f4, $05, $02
    sprite_oam_piece $f6, $ec, $04, $02
    sprite_oam_piece $ee, $04, $03, $02
    sprite_oam_piece $ee, $fc, $02, $02

SpriteFrame_1E_56FB::
    db 18
    sprite_oam_piece $f0, $04, $01, $22
    sprite_oam_piece $08, $ec, $12, $22
    sprite_oam_piece $08, $f4, $11, $22
    sprite_oam_piece $08, $fc, $10, $22
    sprite_oam_piece $08, $04, $0f, $22
    sprite_oam_piece $08, $0c, $0e, $22
    sprite_oam_piece $00, $ec, $0d, $22
    sprite_oam_piece $00, $f4, $0c, $22
    sprite_oam_piece $00, $fc, $0b, $22
    sprite_oam_piece $00, $04, $0a, $22
    sprite_oam_piece $00, $0c, $09, $22
    sprite_oam_piece $f8, $ec, $08, $22
    sprite_oam_piece $f8, $f4, $07, $22
    sprite_oam_piece $f8, $fc, $06, $22
    sprite_oam_piece $f8, $04, $05, $22
    sprite_oam_piece $f8, $0c, $04, $22
    sprite_oam_piece $f0, $f4, $03, $22
    sprite_oam_piece $f0, $fc, $02, $22

SpriteFrame_1E_5744::
    db 18
    sprite_oam_piece $ef, $04, $01, $22
    sprite_oam_piece $07, $ec, $16, $22
    sprite_oam_piece $07, $f4, $15, $22
    sprite_oam_piece $07, $04, $14, $22
    sprite_oam_piece $07, $0c, $13, $22
    sprite_oam_piece $07, $fc, $10, $22
    sprite_oam_piece $ff, $ec, $0d, $22
    sprite_oam_piece $ff, $f4, $0c, $22
    sprite_oam_piece $ff, $fc, $0b, $22
    sprite_oam_piece $ff, $04, $0a, $22
    sprite_oam_piece $ff, $0c, $09, $22
    sprite_oam_piece $f7, $ec, $08, $22
    sprite_oam_piece $f7, $f4, $07, $22
    sprite_oam_piece $f7, $fc, $06, $22
    sprite_oam_piece $f7, $04, $05, $22
    sprite_oam_piece $f7, $0c, $04, $22
    sprite_oam_piece $ef, $f4, $03, $22
    sprite_oam_piece $ef, $fc, $02, $22

SpriteFrame_1E_578D::
    db 18
    sprite_oam_piece $ee, $04, $01, $22
    sprite_oam_piece $06, $ec, $1a, $22
    sprite_oam_piece $06, $f4, $19, $22
    sprite_oam_piece $06, $04, $18, $22
    sprite_oam_piece $06, $0c, $17, $22
    sprite_oam_piece $06, $fc, $10, $22
    sprite_oam_piece $fe, $ec, $0d, $22
    sprite_oam_piece $fe, $f4, $0c, $22
    sprite_oam_piece $fe, $fc, $0b, $22
    sprite_oam_piece $fe, $04, $0a, $22
    sprite_oam_piece $fe, $0c, $09, $22
    sprite_oam_piece $f6, $ec, $08, $22
    sprite_oam_piece $f6, $f4, $07, $22
    sprite_oam_piece $f6, $fc, $06, $22
    sprite_oam_piece $f6, $04, $05, $22
    sprite_oam_piece $f6, $0c, $04, $22
    sprite_oam_piece $ee, $f4, $03, $22
    sprite_oam_piece $ee, $fc, $02, $22

SpriteFrame_1E_57D6::
    db 17
    sprite_oam_piece $08, $0c, $2b, $02
    sprite_oam_piece $08, $04, $2a, $02
    sprite_oam_piece $08, $fc, $29, $02
    sprite_oam_piece $08, $f4, $28, $02
    sprite_oam_piece $08, $ec, $27, $02
    sprite_oam_piece $00, $0c, $26, $02
    sprite_oam_piece $00, $04, $25, $02
    sprite_oam_piece $00, $fc, $24, $02
    sprite_oam_piece $00, $f4, $23, $02
    sprite_oam_piece $00, $ec, $22, $02
    sprite_oam_piece $f8, $0c, $21, $02
    sprite_oam_piece $f8, $04, $20, $02
    sprite_oam_piece $f8, $fc, $1f, $02
    sprite_oam_piece $f8, $f4, $1e, $02
    sprite_oam_piece $f8, $ec, $1d, $02
    sprite_oam_piece $f0, $07, $1c, $02
    sprite_oam_piece $f0, $ff, $1b, $02

SpriteFrame_1E_581B::
    db 17
    sprite_oam_piece $07, $0c, $30, $02
    sprite_oam_piece $07, $04, $2f, $02
    sprite_oam_piece $07, $fc, $2e, $02
    sprite_oam_piece $07, $f4, $2d, $02
    sprite_oam_piece $07, $ec, $2c, $02
    sprite_oam_piece $ff, $0c, $26, $02
    sprite_oam_piece $ff, $04, $25, $02
    sprite_oam_piece $ff, $fc, $24, $02
    sprite_oam_piece $ff, $f4, $23, $02
    sprite_oam_piece $ff, $ec, $22, $02
    sprite_oam_piece $f7, $0c, $21, $02
    sprite_oam_piece $f7, $04, $20, $02
    sprite_oam_piece $f7, $fc, $1f, $02
    sprite_oam_piece $f7, $f4, $1e, $02
    sprite_oam_piece $f7, $ec, $1d, $02
    sprite_oam_piece $ef, $07, $1c, $02
    sprite_oam_piece $ef, $ff, $1b, $02

SpriteFrame_1E_5860::
    db 17
    sprite_oam_piece $06, $0c, $35, $02
    sprite_oam_piece $06, $04, $34, $02
    sprite_oam_piece $06, $fc, $33, $02
    sprite_oam_piece $06, $f4, $32, $02
    sprite_oam_piece $06, $ec, $31, $02
    sprite_oam_piece $fe, $0c, $26, $02
    sprite_oam_piece $fe, $04, $25, $02
    sprite_oam_piece $fe, $fc, $24, $02
    sprite_oam_piece $fe, $f4, $23, $02
    sprite_oam_piece $fe, $ec, $22, $02
    sprite_oam_piece $f6, $0c, $21, $02
    sprite_oam_piece $f6, $04, $20, $02
    sprite_oam_piece $f6, $fc, $1f, $02
    sprite_oam_piece $f6, $f4, $1e, $02
    sprite_oam_piece $f6, $ec, $1d, $02
    sprite_oam_piece $ee, $07, $1c, $02
    sprite_oam_piece $ee, $ff, $1b, $02

SpriteFrame_1E_58A5::
    db 17
    sprite_oam_piece $08, $ec, $2b, $22
    sprite_oam_piece $08, $f4, $2a, $22
    sprite_oam_piece $08, $fc, $29, $22
    sprite_oam_piece $08, $04, $28, $22
    sprite_oam_piece $08, $0c, $27, $22
    sprite_oam_piece $00, $ec, $26, $22
    sprite_oam_piece $00, $f4, $25, $22
    sprite_oam_piece $00, $fc, $24, $22
    sprite_oam_piece $00, $04, $23, $22
    sprite_oam_piece $00, $0c, $22, $22
    sprite_oam_piece $f8, $ec, $21, $22
    sprite_oam_piece $f8, $f4, $20, $22
    sprite_oam_piece $f8, $fc, $1f, $22
    sprite_oam_piece $f8, $04, $1e, $22
    sprite_oam_piece $f8, $0c, $1d, $22
    sprite_oam_piece $f0, $f1, $1c, $22
    sprite_oam_piece $f0, $f9, $1b, $22

SpriteFrame_1E_58EA::
    db 17
    sprite_oam_piece $07, $ec, $30, $22
    sprite_oam_piece $07, $f4, $2f, $22
    sprite_oam_piece $07, $fc, $2e, $22
    sprite_oam_piece $07, $04, $2d, $22
    sprite_oam_piece $07, $0c, $2c, $22
    sprite_oam_piece $ff, $ec, $26, $22
    sprite_oam_piece $ff, $f4, $25, $22
    sprite_oam_piece $ff, $fc, $24, $22
    sprite_oam_piece $ff, $04, $23, $22
    sprite_oam_piece $ff, $0c, $22, $22
    sprite_oam_piece $f7, $ec, $21, $22
    sprite_oam_piece $f7, $f4, $20, $22
    sprite_oam_piece $f7, $fc, $1f, $22
    sprite_oam_piece $f7, $04, $1e, $22
    sprite_oam_piece $f7, $0c, $1d, $22
    sprite_oam_piece $ef, $f1, $1c, $22
    sprite_oam_piece $ef, $f9, $1b, $22

SpriteFrame_1E_592F::
    db 17
    sprite_oam_piece $06, $ec, $35, $22
    sprite_oam_piece $06, $f4, $34, $22
    sprite_oam_piece $06, $fc, $33, $22
    sprite_oam_piece $06, $04, $32, $22
    sprite_oam_piece $06, $0c, $31, $22
    sprite_oam_piece $fe, $ec, $26, $22
    sprite_oam_piece $fe, $f4, $25, $22
    sprite_oam_piece $fe, $fc, $24, $22
    sprite_oam_piece $fe, $04, $23, $22
    sprite_oam_piece $fe, $0c, $22, $22
    sprite_oam_piece $f6, $ec, $21, $22
    sprite_oam_piece $f6, $f4, $20, $22
    sprite_oam_piece $f6, $fc, $1f, $22
    sprite_oam_piece $f6, $04, $1e, $22
    sprite_oam_piece $f6, $0c, $1d, $22
    sprite_oam_piece $ee, $f1, $1c, $22
    sprite_oam_piece $ee, $f9, $1b, $22

SpriteFrame_1E_5974::
    db 15
    sprite_oam_piece $08, $08, $44, $02
    sprite_oam_piece $08, $00, $43, $02
    sprite_oam_piece $08, $f8, $42, $02
    sprite_oam_piece $08, $f0, $41, $02
    sprite_oam_piece $00, $08, $40, $02
    sprite_oam_piece $00, $00, $3f, $02
    sprite_oam_piece $00, $f8, $3e, $02
    sprite_oam_piece $00, $f0, $3d, $02
    sprite_oam_piece $f8, $08, $3c, $02
    sprite_oam_piece $f8, $00, $3b, $02
    sprite_oam_piece $f8, $f8, $3a, $02
    sprite_oam_piece $f8, $f0, $39, $02
    sprite_oam_piece $f0, $08, $38, $02
    sprite_oam_piece $f0, $00, $37, $02
    sprite_oam_piece $f0, $f8, $36, $02

SpriteFrame_1E_59B1::
    db 15
    sprite_oam_piece $ff, $08, $40, $02
    sprite_oam_piece $ff, $00, $3f, $02
    sprite_oam_piece $ff, $f8, $3e, $02
    sprite_oam_piece $ff, $f0, $3d, $02
    sprite_oam_piece $07, $08, $48, $02
    sprite_oam_piece $07, $00, $47, $02
    sprite_oam_piece $07, $f8, $46, $02
    sprite_oam_piece $07, $f0, $45, $02
    sprite_oam_piece $f7, $08, $3c, $02
    sprite_oam_piece $f7, $00, $3b, $02
    sprite_oam_piece $f7, $f8, $3a, $02
    sprite_oam_piece $f7, $f0, $39, $02
    sprite_oam_piece $ef, $08, $38, $02
    sprite_oam_piece $ef, $00, $37, $02
    sprite_oam_piece $ef, $f8, $36, $02

SpriteFrame_1E_59EE::
    db 15
    sprite_oam_piece $fe, $00, $3f, $02
    sprite_oam_piece $fe, $f8, $3e, $02
    sprite_oam_piece $fe, $f0, $3d, $02
    sprite_oam_piece $fe, $08, $40, $02
    sprite_oam_piece $06, $08, $4c, $02
    sprite_oam_piece $06, $00, $4b, $02
    sprite_oam_piece $06, $f8, $4a, $02
    sprite_oam_piece $06, $f0, $49, $02
    sprite_oam_piece $f6, $08, $3c, $02
    sprite_oam_piece $f6, $00, $3b, $02
    sprite_oam_piece $f6, $f8, $3a, $02
    sprite_oam_piece $f6, $f0, $39, $02
    sprite_oam_piece $ee, $08, $38, $02
    sprite_oam_piece $ee, $00, $37, $02
    sprite_oam_piece $ee, $f8, $36, $02

SpriteFrame_1E_5A2B::
    db 15
    sprite_oam_piece $08, $f0, $44, $22
    sprite_oam_piece $08, $f8, $43, $22
    sprite_oam_piece $08, $00, $42, $22
    sprite_oam_piece $08, $08, $41, $22
    sprite_oam_piece $00, $f0, $40, $22
    sprite_oam_piece $00, $f8, $3f, $22
    sprite_oam_piece $00, $00, $3e, $22
    sprite_oam_piece $00, $08, $3d, $22
    sprite_oam_piece $f8, $f0, $3c, $22
    sprite_oam_piece $f8, $f8, $3b, $22
    sprite_oam_piece $f8, $00, $3a, $22
    sprite_oam_piece $f8, $08, $39, $22
    sprite_oam_piece $f0, $f0, $38, $22
    sprite_oam_piece $f0, $f8, $37, $22
    sprite_oam_piece $f0, $00, $36, $22

SpriteFrame_1E_5A68::
    db 15
    sprite_oam_piece $ff, $f0, $40, $22
    sprite_oam_piece $ff, $f8, $3f, $22
    sprite_oam_piece $ff, $00, $3e, $22
    sprite_oam_piece $ff, $08, $3d, $22
    sprite_oam_piece $07, $f0, $48, $22
    sprite_oam_piece $07, $f8, $47, $22
    sprite_oam_piece $07, $00, $46, $22
    sprite_oam_piece $07, $08, $45, $22
    sprite_oam_piece $f7, $f0, $3c, $22
    sprite_oam_piece $f7, $f8, $3b, $22
    sprite_oam_piece $f7, $00, $3a, $22
    sprite_oam_piece $f7, $08, $39, $22
    sprite_oam_piece $ef, $f0, $38, $22
    sprite_oam_piece $ef, $f8, $37, $22
    sprite_oam_piece $ef, $00, $36, $22

SpriteFrame_1E_5AA5::
    db 15
    sprite_oam_piece $fe, $f8, $3f, $22
    sprite_oam_piece $fe, $00, $3e, $22
    sprite_oam_piece $fe, $08, $3d, $22
    sprite_oam_piece $fe, $f0, $40, $22
    sprite_oam_piece $06, $f0, $4c, $22
    sprite_oam_piece $06, $f8, $4b, $22
    sprite_oam_piece $06, $00, $4a, $22
    sprite_oam_piece $06, $08, $49, $22
    sprite_oam_piece $f6, $f0, $3c, $22
    sprite_oam_piece $f6, $f8, $3b, $22
    sprite_oam_piece $f6, $00, $3a, $22
    sprite_oam_piece $f6, $08, $39, $22
    sprite_oam_piece $ee, $f0, $38, $22
    sprite_oam_piece $ee, $f8, $37, $22
    sprite_oam_piece $ee, $00, $36, $22

SpriteAnimation_082:: ; $1E:$5AE2
    sprite_anim_entry SpriteFrame_1E_5620, $0a
    sprite_anim_entry SpriteFrame_1E_5669, $0a
    sprite_anim_entry SpriteFrame_1E_56B2, $0a
    sprite_anim_entry SpriteFrame_1E_5669, $0a
    sprite_anim_end

SpriteAnimation_084:: ; $1E:$5AF0
    sprite_anim_entry SpriteFrame_1E_56FB, $0a
    sprite_anim_entry SpriteFrame_1E_5744, $0a
    sprite_anim_entry SpriteFrame_1E_578D, $0a
    sprite_anim_entry SpriteFrame_1E_5744, $0a
    sprite_anim_end

SpriteAnimation_086:: ; $1E:$5AFE
    sprite_anim_entry SpriteFrame_1E_57D6, $0a
    sprite_anim_entry SpriteFrame_1E_581B, $0a
    sprite_anim_entry SpriteFrame_1E_5860, $0a
    sprite_anim_entry SpriteFrame_1E_581B, $0a
    sprite_anim_end

SpriteAnimation_088:: ; $1E:$5B0C
    sprite_anim_entry SpriteFrame_1E_58A5, $0a
    sprite_anim_entry SpriteFrame_1E_58EA, $0a
    sprite_anim_entry SpriteFrame_1E_592F, $0a
    sprite_anim_entry SpriteFrame_1E_58EA, $0a
    sprite_anim_end

SpriteAnimation_090:: ; $1E:$5B1A
    sprite_anim_entry SpriteFrame_1E_5974, $0a
    sprite_anim_entry SpriteFrame_1E_59B1, $0a
    sprite_anim_entry SpriteFrame_1E_59EE, $0a
    sprite_anim_entry SpriteFrame_1E_59B1, $0a
    sprite_anim_end

SpriteAnimation_092:: ; $1E:$5B28
    sprite_anim_entry SpriteFrame_1E_5A2B, $0a
    sprite_anim_entry SpriteFrame_1E_5A68, $0a
    sprite_anim_entry SpriteFrame_1E_5AA5, $0a
    sprite_anim_entry SpriteFrame_1E_5A68, $0a
    sprite_anim_end

SpriteAnimation_083:: ; $1E:$5B36
    sprite_anim_entry SpriteFrame_1E_5669, $ff
    sprite_anim_end

SpriteAnimation_085:: ; $1E:$5B3B
    sprite_anim_entry SpriteFrame_1E_5744, $ff
    sprite_anim_end

SpriteAnimation_087:: ; $1E:$5B40
    sprite_anim_entry SpriteFrame_1E_581B, $ff
    sprite_anim_end

SpriteAnimation_089:: ; $1E:$5B45
    sprite_anim_entry SpriteFrame_1E_58EA, $ff
    sprite_anim_end

SpriteAnimation_091:: ; $1E:$5B4A
    sprite_anim_entry SpriteFrame_1E_59B1, $ff
    sprite_anim_end

SpriteAnimation_093:: ; $1E:$5B4F
    sprite_anim_entry SpriteFrame_1E_5A68, $ff
    sprite_anim_end

assert @ == $5b54

section "Sprite Animation Data 1E:607C", romx[$607c], bank[$1e]

SpriteFrame_1E_607C::
    db 23
    sprite_oam_piece $08, $10, $12, $02
    sprite_oam_piece $08, $08, $17, $02
    sprite_oam_piece $08, $00, $16, $02
    sprite_oam_piece $08, $f8, $15, $02
    sprite_oam_piece $08, $f0, $14, $02
    sprite_oam_piece $08, $e8, $13, $02
    sprite_oam_piece $00, $10, $11, $02
    sprite_oam_piece $00, $08, $10, $02
    sprite_oam_piece $00, $00, $0f, $02
    sprite_oam_piece $00, $f8, $0e, $02
    sprite_oam_piece $00, $f0, $0d, $02
    sprite_oam_piece $00, $e8, $0c, $02
    sprite_oam_piece $f8, $10, $0b, $02
    sprite_oam_piece $f8, $08, $0a, $02
    sprite_oam_piece $f8, $00, $09, $02
    sprite_oam_piece $f8, $f8, $08, $02
    sprite_oam_piece $f8, $f0, $07, $02
    sprite_oam_piece $f8, $e8, $06, $02
    sprite_oam_piece $f0, $10, $05, $02
    sprite_oam_piece $f0, $08, $04, $02
    sprite_oam_piece $f0, $00, $03, $02
    sprite_oam_piece $f0, $f8, $02, $02
    sprite_oam_piece $f0, $f0, $01, $02

SpriteFrame_1E_60D9::
    db 23
    sprite_oam_piece $07, $08, $1c, $02
    sprite_oam_piece $07, $00, $1b, $02
    sprite_oam_piece $07, $f8, $1a, $02
    sprite_oam_piece $07, $f0, $19, $02
    sprite_oam_piece $07, $e8, $18, $02
    sprite_oam_piece $07, $10, $12, $02
    sprite_oam_piece $ff, $10, $11, $02
    sprite_oam_piece $ff, $08, $10, $02
    sprite_oam_piece $ff, $00, $0f, $02
    sprite_oam_piece $ff, $f8, $0e, $02
    sprite_oam_piece $ff, $f0, $0d, $02
    sprite_oam_piece $ff, $e8, $0c, $02
    sprite_oam_piece $f7, $10, $0b, $02
    sprite_oam_piece $f7, $08, $0a, $02
    sprite_oam_piece $f7, $00, $09, $02
    sprite_oam_piece $f7, $f8, $08, $02
    sprite_oam_piece $f7, $f0, $07, $02
    sprite_oam_piece $f7, $e8, $06, $02
    sprite_oam_piece $ef, $10, $05, $02
    sprite_oam_piece $ef, $08, $04, $02
    sprite_oam_piece $ef, $00, $03, $02
    sprite_oam_piece $ef, $f8, $02, $02
    sprite_oam_piece $ef, $f0, $01, $02

SpriteFrame_1E_6136::
    db 23
    sprite_oam_piece $06, $08, $21, $02
    sprite_oam_piece $06, $00, $20, $02
    sprite_oam_piece $06, $f8, $1f, $02
    sprite_oam_piece $06, $f0, $1e, $02
    sprite_oam_piece $06, $e8, $1d, $02
    sprite_oam_piece $06, $10, $12, $02
    sprite_oam_piece $fe, $10, $11, $02
    sprite_oam_piece $fe, $08, $10, $02
    sprite_oam_piece $fe, $00, $0f, $02
    sprite_oam_piece $fe, $f8, $0e, $02
    sprite_oam_piece $fe, $f0, $0d, $02
    sprite_oam_piece $fe, $e8, $0c, $02
    sprite_oam_piece $f6, $10, $0b, $02
    sprite_oam_piece $f6, $08, $0a, $02
    sprite_oam_piece $f6, $00, $09, $02
    sprite_oam_piece $f6, $f8, $08, $02
    sprite_oam_piece $f6, $f0, $07, $02
    sprite_oam_piece $f6, $e8, $06, $02
    sprite_oam_piece $ee, $10, $05, $02
    sprite_oam_piece $ee, $08, $04, $02
    sprite_oam_piece $ee, $00, $03, $02
    sprite_oam_piece $ee, $f8, $02, $02
    sprite_oam_piece $ee, $f0, $01, $02

SpriteFrame_1E_6193::
    db 23
    sprite_oam_piece $08, $e8, $12, $22
    sprite_oam_piece $08, $f0, $17, $22
    sprite_oam_piece $08, $f8, $16, $22
    sprite_oam_piece $08, $00, $15, $22
    sprite_oam_piece $08, $08, $14, $22
    sprite_oam_piece $08, $10, $13, $22
    sprite_oam_piece $00, $e8, $11, $22
    sprite_oam_piece $00, $f0, $10, $22
    sprite_oam_piece $00, $f8, $0f, $22
    sprite_oam_piece $00, $00, $0e, $22
    sprite_oam_piece $00, $08, $0d, $22
    sprite_oam_piece $00, $10, $0c, $22
    sprite_oam_piece $f8, $e8, $0b, $22
    sprite_oam_piece $f8, $f0, $0a, $22
    sprite_oam_piece $f8, $f8, $09, $22
    sprite_oam_piece $f8, $00, $08, $22
    sprite_oam_piece $f8, $08, $07, $22
    sprite_oam_piece $f8, $10, $06, $22
    sprite_oam_piece $f0, $e8, $05, $22
    sprite_oam_piece $f0, $f0, $04, $22
    sprite_oam_piece $f0, $f8, $03, $22
    sprite_oam_piece $f0, $00, $02, $22
    sprite_oam_piece $f0, $08, $01, $22

SpriteFrame_1E_61F0::
    db 23
    sprite_oam_piece $07, $f0, $1c, $22
    sprite_oam_piece $07, $f8, $1b, $22
    sprite_oam_piece $07, $00, $1a, $22
    sprite_oam_piece $07, $08, $19, $22
    sprite_oam_piece $07, $10, $18, $22
    sprite_oam_piece $07, $e8, $12, $22
    sprite_oam_piece $ff, $e8, $11, $22
    sprite_oam_piece $ff, $f0, $10, $22
    sprite_oam_piece $ff, $f8, $0f, $22
    sprite_oam_piece $ff, $00, $0e, $22
    sprite_oam_piece $ff, $08, $0d, $22
    sprite_oam_piece $ff, $10, $0c, $22
    sprite_oam_piece $f7, $e8, $0b, $22
    sprite_oam_piece $f7, $f0, $0a, $22
    sprite_oam_piece $f7, $f8, $09, $22
    sprite_oam_piece $f7, $00, $08, $22
    sprite_oam_piece $f7, $08, $07, $22
    sprite_oam_piece $f7, $10, $06, $22
    sprite_oam_piece $ef, $e8, $05, $22
    sprite_oam_piece $ef, $f0, $04, $22
    sprite_oam_piece $ef, $f8, $03, $22
    sprite_oam_piece $ef, $00, $02, $22
    sprite_oam_piece $ef, $08, $01, $22

SpriteFrame_1E_624D::
    db 23
    sprite_oam_piece $06, $f0, $21, $22
    sprite_oam_piece $06, $f8, $20, $22
    sprite_oam_piece $06, $00, $1f, $22
    sprite_oam_piece $06, $08, $1e, $22
    sprite_oam_piece $06, $10, $1d, $22
    sprite_oam_piece $06, $e8, $12, $22
    sprite_oam_piece $fe, $e8, $11, $22
    sprite_oam_piece $fe, $f0, $10, $22
    sprite_oam_piece $fe, $f8, $0f, $22
    sprite_oam_piece $fe, $00, $0e, $22
    sprite_oam_piece $fe, $08, $0d, $22
    sprite_oam_piece $fe, $10, $0c, $22
    sprite_oam_piece $f6, $e8, $0b, $22
    sprite_oam_piece $f6, $f0, $0a, $22
    sprite_oam_piece $f6, $f8, $09, $22
    sprite_oam_piece $f6, $00, $08, $22
    sprite_oam_piece $f6, $08, $07, $22
    sprite_oam_piece $f6, $10, $06, $22
    sprite_oam_piece $ee, $e8, $05, $22
    sprite_oam_piece $ee, $f0, $04, $22
    sprite_oam_piece $ee, $f8, $03, $22
    sprite_oam_piece $ee, $00, $02, $22
    sprite_oam_piece $ee, $08, $01, $22

SpriteFrame_1E_62AA::
    db 18
    sprite_oam_piece $08, $0c, $33, $02
    sprite_oam_piece $08, $04, $32, $02
    sprite_oam_piece $08, $fc, $31, $02
    sprite_oam_piece $08, $f4, $30, $02
    sprite_oam_piece $08, $ec, $2f, $02
    sprite_oam_piece $00, $0c, $2e, $02
    sprite_oam_piece $00, $04, $2d, $02
    sprite_oam_piece $00, $fc, $2c, $02
    sprite_oam_piece $00, $f4, $2b, $02
    sprite_oam_piece $00, $ec, $2a, $02
    sprite_oam_piece $f8, $0c, $29, $02
    sprite_oam_piece $f8, $04, $28, $02
    sprite_oam_piece $f8, $fc, $27, $02
    sprite_oam_piece $f8, $f4, $26, $02
    sprite_oam_piece $f8, $ec, $25, $02
    sprite_oam_piece $f0, $04, $24, $02
    sprite_oam_piece $f0, $fc, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02

SpriteFrame_1E_62F3::
    db 18
    sprite_oam_piece $07, $0c, $38, $02
    sprite_oam_piece $07, $04, $37, $02
    sprite_oam_piece $07, $fc, $36, $02
    sprite_oam_piece $07, $f4, $35, $02
    sprite_oam_piece $07, $ec, $34, $02
    sprite_oam_piece $ff, $0c, $2e, $02
    sprite_oam_piece $ff, $04, $2d, $02
    sprite_oam_piece $ff, $fc, $2c, $02
    sprite_oam_piece $ff, $f4, $2b, $02
    sprite_oam_piece $ff, $ec, $2a, $02
    sprite_oam_piece $f7, $0c, $29, $02
    sprite_oam_piece $f7, $04, $28, $02
    sprite_oam_piece $f7, $fc, $27, $02
    sprite_oam_piece $f7, $f4, $26, $02
    sprite_oam_piece $f7, $ec, $25, $02
    sprite_oam_piece $ef, $04, $24, $02
    sprite_oam_piece $ef, $fc, $23, $02
    sprite_oam_piece $ef, $f4, $22, $02

SpriteFrame_1E_633C::
    db 18
    sprite_oam_piece $06, $0c, $3d, $02
    sprite_oam_piece $06, $04, $3c, $02
    sprite_oam_piece $06, $fc, $3b, $02
    sprite_oam_piece $06, $f4, $3a, $02
    sprite_oam_piece $06, $ec, $39, $02
    sprite_oam_piece $fe, $0c, $2e, $02
    sprite_oam_piece $fe, $04, $2d, $02
    sprite_oam_piece $fe, $fc, $2c, $02
    sprite_oam_piece $fe, $f4, $2b, $02
    sprite_oam_piece $fe, $ec, $2a, $02
    sprite_oam_piece $f6, $0c, $29, $02
    sprite_oam_piece $f6, $04, $28, $02
    sprite_oam_piece $f6, $fc, $27, $02
    sprite_oam_piece $f6, $f4, $26, $02
    sprite_oam_piece $f6, $ec, $25, $02
    sprite_oam_piece $ee, $04, $24, $02
    sprite_oam_piece $ee, $fc, $23, $02
    sprite_oam_piece $ee, $f4, $22, $02

SpriteFrame_1E_6385::
    db 18
    sprite_oam_piece $08, $ec, $33, $22
    sprite_oam_piece $08, $f4, $32, $22
    sprite_oam_piece $08, $fc, $31, $22
    sprite_oam_piece $08, $04, $30, $22
    sprite_oam_piece $08, $0c, $2f, $22
    sprite_oam_piece $00, $ec, $2e, $22
    sprite_oam_piece $00, $f4, $2d, $22
    sprite_oam_piece $00, $fc, $2c, $22
    sprite_oam_piece $00, $04, $2b, $22
    sprite_oam_piece $00, $0c, $2a, $22
    sprite_oam_piece $f8, $ec, $29, $22
    sprite_oam_piece $f8, $f4, $28, $22
    sprite_oam_piece $f8, $fc, $27, $22
    sprite_oam_piece $f8, $04, $26, $22
    sprite_oam_piece $f8, $0c, $25, $22
    sprite_oam_piece $f0, $f4, $24, $22
    sprite_oam_piece $f0, $fc, $23, $22
    sprite_oam_piece $f0, $04, $22, $22

SpriteFrame_1E_63CE::
    db 18
    sprite_oam_piece $07, $ec, $38, $22
    sprite_oam_piece $07, $f4, $37, $22
    sprite_oam_piece $07, $fc, $36, $22
    sprite_oam_piece $07, $04, $35, $22
    sprite_oam_piece $07, $0c, $34, $22
    sprite_oam_piece $ff, $ec, $2e, $22
    sprite_oam_piece $ff, $f4, $2d, $22
    sprite_oam_piece $ff, $fc, $2c, $22
    sprite_oam_piece $ff, $04, $2b, $22
    sprite_oam_piece $ff, $0c, $2a, $22
    sprite_oam_piece $f7, $ec, $29, $22
    sprite_oam_piece $f7, $f4, $28, $22
    sprite_oam_piece $f7, $fc, $27, $22
    sprite_oam_piece $f7, $04, $26, $22
    sprite_oam_piece $f7, $0c, $25, $22
    sprite_oam_piece $ef, $f4, $24, $22
    sprite_oam_piece $ef, $fc, $23, $22
    sprite_oam_piece $ef, $04, $22, $22

SpriteFrame_1E_6417::
    db 18
    sprite_oam_piece $06, $ec, $3d, $22
    sprite_oam_piece $06, $f4, $3c, $22
    sprite_oam_piece $06, $fc, $3b, $22
    sprite_oam_piece $06, $04, $3a, $22
    sprite_oam_piece $06, $0c, $39, $22
    sprite_oam_piece $fe, $ec, $2e, $22
    sprite_oam_piece $fe, $f4, $2d, $22
    sprite_oam_piece $fe, $fc, $2c, $22
    sprite_oam_piece $fe, $04, $2b, $22
    sprite_oam_piece $fe, $0c, $2a, $22
    sprite_oam_piece $f6, $ec, $29, $22
    sprite_oam_piece $f6, $f4, $28, $22
    sprite_oam_piece $f6, $fc, $27, $22
    sprite_oam_piece $f6, $04, $26, $22
    sprite_oam_piece $f6, $0c, $25, $22
    sprite_oam_piece $ee, $f4, $24, $22
    sprite_oam_piece $ee, $fc, $23, $22
    sprite_oam_piece $ee, $04, $22, $22

SpriteFrame_1E_6460::
    db 19
    sprite_oam_piece $08, $0c, $50, $02
    sprite_oam_piece $08, $04, $4f, $02
    sprite_oam_piece $08, $fc, $4e, $02
    sprite_oam_piece $08, $f4, $4d, $02
    sprite_oam_piece $08, $ec, $4c, $02
    sprite_oam_piece $00, $0c, $4b, $02
    sprite_oam_piece $00, $04, $4a, $02
    sprite_oam_piece $00, $fc, $49, $02
    sprite_oam_piece $00, $f4, $48, $02
    sprite_oam_piece $00, $ec, $47, $02
    sprite_oam_piece $f8, $0c, $46, $02
    sprite_oam_piece $f8, $04, $45, $02
    sprite_oam_piece $f8, $fc, $44, $02
    sprite_oam_piece $f8, $f4, $43, $02
    sprite_oam_piece $f8, $ec, $42, $02
    sprite_oam_piece $f0, $0c, $41, $02
    sprite_oam_piece $f0, $04, $40, $02
    sprite_oam_piece $f0, $fc, $3f, $02
    sprite_oam_piece $f0, $f4, $3e, $02

SpriteFrame_1E_64AD::
    db 19
    sprite_oam_piece $07, $0c, $55, $02
    sprite_oam_piece $07, $04, $54, $02
    sprite_oam_piece $07, $fc, $53, $02
    sprite_oam_piece $07, $f4, $52, $02
    sprite_oam_piece $07, $ec, $51, $02
    sprite_oam_piece $ff, $0c, $4b, $02
    sprite_oam_piece $ff, $04, $4a, $02
    sprite_oam_piece $ff, $fc, $49, $02
    sprite_oam_piece $ff, $f4, $48, $02
    sprite_oam_piece $ff, $ec, $47, $02
    sprite_oam_piece $f7, $0c, $46, $02
    sprite_oam_piece $f7, $04, $45, $02
    sprite_oam_piece $f7, $fc, $44, $02
    sprite_oam_piece $f7, $f4, $43, $02
    sprite_oam_piece $f7, $ec, $42, $02
    sprite_oam_piece $ef, $0c, $41, $02
    sprite_oam_piece $ef, $04, $40, $02
    sprite_oam_piece $ef, $fc, $3f, $02
    sprite_oam_piece $ef, $f4, $3e, $02

SpriteFrame_1E_64FA::
    db 19
    sprite_oam_piece $06, $0c, $5a, $02
    sprite_oam_piece $06, $04, $59, $02
    sprite_oam_piece $06, $fc, $58, $02
    sprite_oam_piece $06, $f4, $57, $02
    sprite_oam_piece $06, $ec, $56, $02
    sprite_oam_piece $fe, $0c, $4b, $02
    sprite_oam_piece $fe, $04, $4a, $02
    sprite_oam_piece $fe, $fc, $49, $02
    sprite_oam_piece $fe, $f4, $48, $02
    sprite_oam_piece $fe, $ec, $47, $02
    sprite_oam_piece $f6, $0c, $46, $02
    sprite_oam_piece $f6, $04, $45, $02
    sprite_oam_piece $f6, $fc, $44, $02
    sprite_oam_piece $f6, $f4, $43, $02
    sprite_oam_piece $f6, $ec, $42, $02
    sprite_oam_piece $ee, $0c, $41, $02
    sprite_oam_piece $ee, $04, $40, $02
    sprite_oam_piece $ee, $fc, $3f, $02
    sprite_oam_piece $ee, $f4, $3e, $02

SpriteFrame_1E_6547::
    db 19
    sprite_oam_piece $08, $ec, $50, $22
    sprite_oam_piece $08, $f4, $4f, $22
    sprite_oam_piece $08, $fc, $4e, $22
    sprite_oam_piece $08, $04, $4d, $22
    sprite_oam_piece $08, $0c, $4c, $22
    sprite_oam_piece $00, $ec, $4b, $22
    sprite_oam_piece $00, $f4, $4a, $22
    sprite_oam_piece $00, $fc, $49, $22
    sprite_oam_piece $00, $04, $48, $22
    sprite_oam_piece $00, $0c, $47, $22
    sprite_oam_piece $f8, $ec, $46, $22
    sprite_oam_piece $f8, $f4, $45, $22
    sprite_oam_piece $f8, $fc, $44, $22
    sprite_oam_piece $f8, $04, $43, $22
    sprite_oam_piece $f8, $0c, $42, $22
    sprite_oam_piece $f0, $ec, $41, $22
    sprite_oam_piece $f0, $f4, $40, $22
    sprite_oam_piece $f0, $fc, $3f, $22
    sprite_oam_piece $f0, $04, $3e, $22

SpriteFrame_1E_6594::
    db 19
    sprite_oam_piece $07, $ec, $55, $22
    sprite_oam_piece $07, $f4, $54, $22
    sprite_oam_piece $07, $fc, $53, $22
    sprite_oam_piece $07, $04, $52, $22
    sprite_oam_piece $07, $0c, $51, $22
    sprite_oam_piece $ff, $ec, $4b, $22
    sprite_oam_piece $ff, $f4, $4a, $22
    sprite_oam_piece $ff, $fc, $49, $22
    sprite_oam_piece $ff, $04, $48, $22
    sprite_oam_piece $ff, $0c, $47, $22
    sprite_oam_piece $f7, $ec, $46, $22
    sprite_oam_piece $f7, $f4, $45, $22
    sprite_oam_piece $f7, $fc, $44, $22
    sprite_oam_piece $f7, $04, $43, $22
    sprite_oam_piece $f7, $0c, $42, $22
    sprite_oam_piece $ef, $ec, $41, $22
    sprite_oam_piece $ef, $f4, $40, $22
    sprite_oam_piece $ef, $fc, $3f, $22
    sprite_oam_piece $ef, $04, $3e, $22

SpriteFrame_1E_65E1::
    db 19
    sprite_oam_piece $06, $ec, $5a, $22
    sprite_oam_piece $06, $f4, $59, $22
    sprite_oam_piece $06, $fc, $58, $22
    sprite_oam_piece $06, $04, $57, $22
    sprite_oam_piece $06, $0c, $56, $22
    sprite_oam_piece $fe, $ec, $4b, $22
    sprite_oam_piece $fe, $f4, $4a, $22
    sprite_oam_piece $fe, $fc, $49, $22
    sprite_oam_piece $fe, $04, $48, $22
    sprite_oam_piece $fe, $0c, $47, $22
    sprite_oam_piece $f6, $ec, $46, $22
    sprite_oam_piece $f6, $f4, $45, $22
    sprite_oam_piece $f6, $fc, $44, $22
    sprite_oam_piece $f6, $04, $43, $22
    sprite_oam_piece $f6, $0c, $42, $22
    sprite_oam_piece $ee, $ec, $41, $22
    sprite_oam_piece $ee, $f4, $40, $22
    sprite_oam_piece $ee, $fc, $3f, $22
    sprite_oam_piece $ee, $04, $3e, $22

SpriteAnimation_094:: ; $1E:$662E
    sprite_anim_entry SpriteFrame_1E_607C, $0a
    sprite_anim_entry SpriteFrame_1E_60D9, $0a
    sprite_anim_entry SpriteFrame_1E_6136, $0a
    sprite_anim_entry SpriteFrame_1E_60D9, $0a
    sprite_anim_end

SpriteAnimation_098:: ; $1E:$663C
    sprite_anim_entry SpriteFrame_1E_62AA, $0a
    sprite_anim_entry SpriteFrame_1E_62F3, $0a
    sprite_anim_entry SpriteFrame_1E_633C, $0a
    sprite_anim_entry SpriteFrame_1E_62F3, $0a
    sprite_anim_end

SpriteAnimation_096:: ; $1E:$664A
    sprite_anim_entry SpriteFrame_1E_6193, $0a
    sprite_anim_entry SpriteFrame_1E_61F0, $0a
    sprite_anim_entry SpriteFrame_1E_624D, $0a
    sprite_anim_entry SpriteFrame_1E_61F0, $0a
    sprite_anim_end

SpriteAnimation_100:: ; $1E:$6658
    sprite_anim_entry SpriteFrame_1E_6385, $0a
    sprite_anim_entry SpriteFrame_1E_63CE, $0a
    sprite_anim_entry SpriteFrame_1E_6417, $0a
    sprite_anim_entry SpriteFrame_1E_63CE, $0a
    sprite_anim_end

SpriteAnimation_102:: ; $1E:$6666
    sprite_anim_entry SpriteFrame_1E_6460, $0a
    sprite_anim_entry SpriteFrame_1E_64AD, $0a
    sprite_anim_entry SpriteFrame_1E_64FA, $0a
    sprite_anim_entry SpriteFrame_1E_64AD, $0a
    sprite_anim_end

SpriteAnimation_104:: ; $1E:$6674
    sprite_anim_entry SpriteFrame_1E_6547, $0a
    sprite_anim_entry SpriteFrame_1E_6594, $0a
    sprite_anim_entry SpriteFrame_1E_65E1, $0a
    sprite_anim_entry SpriteFrame_1E_6594, $0a
    sprite_anim_end

SpriteAnimation_095:: ; $1E:$6682
    sprite_anim_entry SpriteFrame_1E_60D9, $ff
    sprite_anim_end

SpriteAnimation_097:: ; $1E:$6687
    sprite_anim_entry SpriteFrame_1E_61F0, $ff
    sprite_anim_end

SpriteAnimation_099:: ; $1E:$668C
    sprite_anim_entry SpriteFrame_1E_62F3, $ff
    sprite_anim_end

SpriteAnimation_101:: ; $1E:$6691
    sprite_anim_entry SpriteFrame_1E_63CE, $ff
    sprite_anim_end

SpriteAnimation_103:: ; $1E:$6696
    sprite_anim_entry SpriteFrame_1E_64AD, $ff
    sprite_anim_end

SpriteAnimation_105:: ; $1E:$669B
    sprite_anim_entry SpriteFrame_1E_6594, $ff
    sprite_anim_end

assert @ == $66a0

section "Sprite Animation Data 1E:6CA8", romx[$6ca8], bank[$1e]

SpriteFrame_1E_6CA8::
    db 17
    sprite_oam_piece $08, $04, $11, $02
    sprite_oam_piece $08, $fc, $10, $02
    sprite_oam_piece $08, $f4, $0f, $02
    sprite_oam_piece $08, $ec, $0e, $02
    sprite_oam_piece $00, $0c, $0d, $02
    sprite_oam_piece $00, $04, $0c, $02
    sprite_oam_piece $00, $fc, $0b, $02
    sprite_oam_piece $00, $f4, $0a, $02
    sprite_oam_piece $00, $ec, $09, $02
    sprite_oam_piece $f8, $0c, $08, $02
    sprite_oam_piece $f8, $04, $07, $02
    sprite_oam_piece $f8, $fc, $06, $02
    sprite_oam_piece $f8, $f4, $05, $02
    sprite_oam_piece $f8, $ec, $04, $02
    sprite_oam_piece $f0, $05, $03, $02
    sprite_oam_piece $f0, $fd, $02, $02
    sprite_oam_piece $f0, $f5, $01, $02

SpriteFrame_1E_6CED::
    db 17
    sprite_oam_piece $07, $04, $15, $02
    sprite_oam_piece $07, $fc, $14, $02
    sprite_oam_piece $07, $f4, $13, $02
    sprite_oam_piece $07, $ec, $12, $02
    sprite_oam_piece $ff, $0c, $0d, $02
    sprite_oam_piece $ff, $04, $0c, $02
    sprite_oam_piece $ff, $fc, $0b, $02
    sprite_oam_piece $ff, $f4, $0a, $02
    sprite_oam_piece $ff, $ec, $09, $02
    sprite_oam_piece $f7, $0c, $08, $02
    sprite_oam_piece $f7, $04, $07, $02
    sprite_oam_piece $f7, $fc, $06, $02
    sprite_oam_piece $f7, $f4, $05, $02
    sprite_oam_piece $f7, $ec, $04, $02
    sprite_oam_piece $ef, $05, $03, $02
    sprite_oam_piece $ef, $fd, $02, $02
    sprite_oam_piece $ef, $f5, $01, $02

SpriteFrame_1E_6D32::
    db 17
    sprite_oam_piece $06, $04, $19, $02
    sprite_oam_piece $06, $fc, $18, $02
    sprite_oam_piece $06, $f4, $17, $02
    sprite_oam_piece $06, $ec, $16, $02
    sprite_oam_piece $fe, $0c, $0d, $02
    sprite_oam_piece $fe, $04, $0c, $02
    sprite_oam_piece $fe, $fc, $0b, $02
    sprite_oam_piece $fe, $f4, $0a, $02
    sprite_oam_piece $fe, $ec, $09, $02
    sprite_oam_piece $f6, $0c, $08, $02
    sprite_oam_piece $f6, $04, $07, $02
    sprite_oam_piece $f6, $fc, $06, $02
    sprite_oam_piece $f6, $f4, $05, $02
    sprite_oam_piece $f6, $ec, $04, $02
    sprite_oam_piece $ee, $05, $03, $02
    sprite_oam_piece $ee, $fd, $02, $02
    sprite_oam_piece $ee, $f5, $01, $02

SpriteFrame_1E_6D77::
    db 17
    sprite_oam_piece $08, $f4, $11, $22
    sprite_oam_piece $08, $fc, $10, $22
    sprite_oam_piece $08, $04, $0f, $22
    sprite_oam_piece $08, $0c, $0e, $22
    sprite_oam_piece $00, $ec, $0d, $22
    sprite_oam_piece $00, $f4, $0c, $22
    sprite_oam_piece $00, $fc, $0b, $22
    sprite_oam_piece $00, $04, $0a, $22
    sprite_oam_piece $00, $0c, $09, $22
    sprite_oam_piece $f8, $ec, $08, $22
    sprite_oam_piece $f8, $f4, $07, $22
    sprite_oam_piece $f8, $fc, $06, $22
    sprite_oam_piece $f8, $04, $05, $22
    sprite_oam_piece $f8, $0c, $04, $22
    sprite_oam_piece $f0, $f3, $03, $22
    sprite_oam_piece $f0, $fb, $02, $22
    sprite_oam_piece $f0, $03, $01, $22

SpriteFrame_1E_6DBC::
    db 17
    sprite_oam_piece $07, $f4, $15, $22
    sprite_oam_piece $07, $fc, $14, $22
    sprite_oam_piece $07, $04, $13, $22
    sprite_oam_piece $07, $0c, $12, $22
    sprite_oam_piece $ff, $ec, $0d, $22
    sprite_oam_piece $ff, $f4, $0c, $22
    sprite_oam_piece $ff, $fc, $0b, $22
    sprite_oam_piece $ff, $04, $0a, $22
    sprite_oam_piece $ff, $0c, $09, $22
    sprite_oam_piece $f7, $ec, $08, $22
    sprite_oam_piece $f7, $f4, $07, $22
    sprite_oam_piece $f7, $fc, $06, $22
    sprite_oam_piece $f7, $04, $05, $22
    sprite_oam_piece $f7, $0c, $04, $22
    sprite_oam_piece $ef, $f3, $03, $22
    sprite_oam_piece $ef, $fb, $02, $22
    sprite_oam_piece $ef, $03, $01, $22

SpriteFrame_1E_6E01::
    db 17
    sprite_oam_piece $06, $f4, $19, $22
    sprite_oam_piece $06, $fc, $18, $22
    sprite_oam_piece $06, $04, $17, $22
    sprite_oam_piece $06, $0c, $16, $22
    sprite_oam_piece $fe, $ec, $0d, $22
    sprite_oam_piece $fe, $f4, $0c, $22
    sprite_oam_piece $fe, $fc, $0b, $22
    sprite_oam_piece $fe, $04, $0a, $22
    sprite_oam_piece $fe, $0c, $09, $22
    sprite_oam_piece $f6, $ec, $08, $22
    sprite_oam_piece $f6, $f4, $07, $22
    sprite_oam_piece $f6, $fc, $06, $22
    sprite_oam_piece $f6, $04, $05, $22
    sprite_oam_piece $f6, $0c, $04, $22
    sprite_oam_piece $ee, $f3, $03, $22
    sprite_oam_piece $ee, $fb, $02, $22
    sprite_oam_piece $ee, $03, $01, $22

SpriteFrame_1E_6E46::
    db 22
    sprite_oam_piece $08, $10, $2f, $02
    sprite_oam_piece $08, $08, $2e, $02
    sprite_oam_piece $08, $00, $2d, $02
    sprite_oam_piece $08, $f8, $2c, $02
    sprite_oam_piece $08, $f0, $2b, $02
    sprite_oam_piece $08, $e8, $2a, $02
    sprite_oam_piece $00, $10, $29, $02
    sprite_oam_piece $00, $08, $28, $02
    sprite_oam_piece $00, $00, $27, $02
    sprite_oam_piece $00, $f8, $26, $02
    sprite_oam_piece $00, $f0, $25, $02
    sprite_oam_piece $00, $e8, $24, $02
    sprite_oam_piece $f8, $10, $23, $02
    sprite_oam_piece $f8, $08, $22, $02
    sprite_oam_piece $f8, $00, $21, $02
    sprite_oam_piece $f8, $f8, $20, $02
    sprite_oam_piece $f8, $f0, $1f, $02
    sprite_oam_piece $f8, $e8, $1e, $02
    sprite_oam_piece $f0, $10, $1d, $02
    sprite_oam_piece $f0, $08, $1c, $02
    sprite_oam_piece $f0, $00, $1b, $02
    sprite_oam_piece $f0, $f8, $1a, $02

SpriteFrame_1E_6E9F::
    db 22
    sprite_oam_piece $07, $10, $35, $02
    sprite_oam_piece $07, $08, $34, $02
    sprite_oam_piece $07, $00, $33, $02
    sprite_oam_piece $07, $f8, $32, $02
    sprite_oam_piece $07, $f0, $31, $02
    sprite_oam_piece $07, $e8, $30, $02
    sprite_oam_piece $ff, $10, $29, $02
    sprite_oam_piece $ff, $08, $28, $02
    sprite_oam_piece $ff, $00, $27, $02
    sprite_oam_piece $ff, $f8, $26, $02
    sprite_oam_piece $ff, $f0, $25, $02
    sprite_oam_piece $ff, $e8, $24, $02
    sprite_oam_piece $f7, $10, $23, $02
    sprite_oam_piece $f7, $08, $22, $02
    sprite_oam_piece $f7, $00, $21, $02
    sprite_oam_piece $f7, $f8, $20, $02
    sprite_oam_piece $f7, $f0, $1f, $02
    sprite_oam_piece $f7, $e8, $1e, $02
    sprite_oam_piece $ef, $10, $1d, $02
    sprite_oam_piece $ef, $08, $1c, $02
    sprite_oam_piece $ef, $00, $1b, $02
    sprite_oam_piece $ef, $f8, $1a, $02

SpriteFrame_1E_6EF8::
    db 22
    sprite_oam_piece $06, $10, $3b, $02
    sprite_oam_piece $06, $08, $3a, $02
    sprite_oam_piece $06, $00, $39, $02
    sprite_oam_piece $06, $f8, $38, $02
    sprite_oam_piece $06, $f0, $37, $02
    sprite_oam_piece $06, $e8, $36, $02
    sprite_oam_piece $fe, $10, $29, $02
    sprite_oam_piece $fe, $08, $28, $02
    sprite_oam_piece $fe, $00, $27, $02
    sprite_oam_piece $fe, $f8, $26, $02
    sprite_oam_piece $fe, $f0, $25, $02
    sprite_oam_piece $fe, $e8, $24, $02
    sprite_oam_piece $f6, $10, $23, $02
    sprite_oam_piece $f6, $08, $22, $02
    sprite_oam_piece $f6, $00, $21, $02
    sprite_oam_piece $f6, $f8, $20, $02
    sprite_oam_piece $f6, $f0, $1f, $02
    sprite_oam_piece $f6, $e8, $1e, $02
    sprite_oam_piece $ee, $10, $1d, $02
    sprite_oam_piece $ee, $08, $1c, $02
    sprite_oam_piece $ee, $00, $1b, $02
    sprite_oam_piece $ee, $f8, $1a, $02

SpriteFrame_1E_6F51::
    db 22
    sprite_oam_piece $08, $e8, $2f, $22
    sprite_oam_piece $08, $f0, $2e, $22
    sprite_oam_piece $08, $f8, $2d, $22
    sprite_oam_piece $08, $00, $2c, $22
    sprite_oam_piece $08, $08, $2b, $22
    sprite_oam_piece $08, $10, $2a, $22
    sprite_oam_piece $00, $e8, $29, $22
    sprite_oam_piece $00, $f0, $28, $22
    sprite_oam_piece $00, $f8, $27, $22
    sprite_oam_piece $00, $00, $26, $22
    sprite_oam_piece $00, $08, $25, $22
    sprite_oam_piece $00, $10, $24, $22
    sprite_oam_piece $f8, $e8, $23, $22
    sprite_oam_piece $f8, $f0, $22, $22
    sprite_oam_piece $f8, $f8, $21, $22
    sprite_oam_piece $f8, $00, $20, $22
    sprite_oam_piece $f8, $08, $1f, $22
    sprite_oam_piece $f8, $10, $1e, $22
    sprite_oam_piece $f0, $e8, $1d, $22
    sprite_oam_piece $f0, $f0, $1c, $22
    sprite_oam_piece $f0, $f8, $1b, $22
    sprite_oam_piece $f0, $00, $1a, $22

SpriteFrame_1E_6FAA::
    db 22
    sprite_oam_piece $07, $e8, $35, $22
    sprite_oam_piece $07, $f0, $34, $22
    sprite_oam_piece $07, $f8, $33, $22
    sprite_oam_piece $07, $00, $32, $22
    sprite_oam_piece $07, $08, $31, $22
    sprite_oam_piece $07, $10, $30, $22
    sprite_oam_piece $ff, $e8, $29, $22
    sprite_oam_piece $ff, $f0, $28, $22
    sprite_oam_piece $ff, $f8, $27, $22
    sprite_oam_piece $ff, $00, $26, $22
    sprite_oam_piece $ff, $08, $25, $22
    sprite_oam_piece $ff, $10, $24, $22
    sprite_oam_piece $f7, $e8, $23, $22
    sprite_oam_piece $f7, $f0, $22, $22
    sprite_oam_piece $f7, $f8, $21, $22
    sprite_oam_piece $f7, $00, $20, $22
    sprite_oam_piece $f7, $08, $1f, $22
    sprite_oam_piece $f7, $10, $1e, $22
    sprite_oam_piece $ef, $e8, $1d, $22
    sprite_oam_piece $ef, $f0, $1c, $22
    sprite_oam_piece $ef, $f8, $1b, $22
    sprite_oam_piece $ef, $00, $1a, $22

SpriteFrame_1E_7003::
    db 22
    sprite_oam_piece $06, $e8, $3b, $22
    sprite_oam_piece $06, $f0, $3a, $22
    sprite_oam_piece $06, $f8, $39, $22
    sprite_oam_piece $06, $00, $38, $22
    sprite_oam_piece $06, $08, $37, $22
    sprite_oam_piece $06, $10, $36, $22
    sprite_oam_piece $fe, $e8, $29, $22
    sprite_oam_piece $fe, $f0, $28, $22
    sprite_oam_piece $fe, $f8, $27, $22
    sprite_oam_piece $fe, $00, $26, $22
    sprite_oam_piece $fe, $08, $25, $22
    sprite_oam_piece $fe, $10, $24, $22
    sprite_oam_piece $f6, $e8, $23, $22
    sprite_oam_piece $f6, $f0, $22, $22
    sprite_oam_piece $f6, $f8, $21, $22
    sprite_oam_piece $f6, $00, $20, $22
    sprite_oam_piece $f6, $08, $1f, $22
    sprite_oam_piece $f6, $10, $1e, $22
    sprite_oam_piece $ee, $e8, $1d, $22
    sprite_oam_piece $ee, $f0, $1c, $22
    sprite_oam_piece $ee, $f8, $1b, $22
    sprite_oam_piece $ee, $00, $1a, $22

SpriteFrame_1E_705C::
    db 21
    sprite_oam_piece $08, $0c, $50, $02
    sprite_oam_piece $08, $04, $4f, $02
    sprite_oam_piece $08, $fc, $4e, $02
    sprite_oam_piece $08, $f4, $4d, $02
    sprite_oam_piece $08, $ec, $4c, $02
    sprite_oam_piece $00, $0c, $4b, $02
    sprite_oam_piece $00, $04, $4a, $02
    sprite_oam_piece $00, $fc, $49, $02
    sprite_oam_piece $00, $f4, $48, $02
    sprite_oam_piece $00, $ec, $47, $02
    sprite_oam_piece $f8, $0c, $46, $02
    sprite_oam_piece $f8, $04, $45, $02
    sprite_oam_piece $f8, $fc, $44, $02
    sprite_oam_piece $f8, $f4, $43, $02
    sprite_oam_piece $f8, $ec, $42, $02
    sprite_oam_piece $f0, $0c, $41, $02
    sprite_oam_piece $f0, $04, $40, $02
    sprite_oam_piece $f0, $fc, $3f, $02
    sprite_oam_piece $f0, $f4, $3e, $02
    sprite_oam_piece $f0, $ec, $3d, $02
    sprite_oam_piece $f0, $e4, $3c, $02

SpriteFrame_1E_70B1::
    db 21
    sprite_oam_piece $07, $0c, $55, $02
    sprite_oam_piece $07, $04, $54, $02
    sprite_oam_piece $07, $fc, $53, $02
    sprite_oam_piece $07, $f4, $52, $02
    sprite_oam_piece $07, $ec, $51, $02
    sprite_oam_piece $ff, $0c, $4b, $02
    sprite_oam_piece $ff, $04, $4a, $02
    sprite_oam_piece $ff, $fc, $49, $02
    sprite_oam_piece $ff, $f4, $48, $02
    sprite_oam_piece $ff, $ec, $47, $02
    sprite_oam_piece $f7, $0c, $46, $02
    sprite_oam_piece $f7, $04, $45, $02
    sprite_oam_piece $f7, $fc, $44, $02
    sprite_oam_piece $f7, $f4, $43, $02
    sprite_oam_piece $f7, $ec, $42, $02
    sprite_oam_piece $ef, $0c, $41, $02
    sprite_oam_piece $ef, $04, $40, $02
    sprite_oam_piece $ef, $fc, $3f, $02
    sprite_oam_piece $ef, $f4, $3e, $02
    sprite_oam_piece $ef, $ec, $3d, $02
    sprite_oam_piece $ef, $e4, $3c, $02

SpriteFrame_1E_7106::
    db 21
    sprite_oam_piece $06, $0c, $5a, $02
    sprite_oam_piece $06, $04, $59, $02
    sprite_oam_piece $06, $fc, $58, $02
    sprite_oam_piece $06, $f4, $57, $02
    sprite_oam_piece $06, $ec, $56, $02
    sprite_oam_piece $fe, $0c, $4b, $02
    sprite_oam_piece $fe, $04, $4a, $02
    sprite_oam_piece $fe, $fc, $49, $02
    sprite_oam_piece $fe, $f4, $48, $02
    sprite_oam_piece $fe, $ec, $47, $02
    sprite_oam_piece $f6, $0c, $46, $02
    sprite_oam_piece $f6, $04, $45, $02
    sprite_oam_piece $f6, $fc, $44, $02
    sprite_oam_piece $f6, $f4, $43, $02
    sprite_oam_piece $f6, $ec, $42, $02
    sprite_oam_piece $ee, $0c, $41, $02
    sprite_oam_piece $ee, $04, $40, $02
    sprite_oam_piece $ee, $fc, $3f, $02
    sprite_oam_piece $ee, $f4, $3e, $02
    sprite_oam_piece $ee, $ec, $3d, $02
    sprite_oam_piece $ee, $e4, $3c, $02

SpriteFrame_1E_715B::
    db 21
    sprite_oam_piece $08, $ec, $50, $22
    sprite_oam_piece $08, $f4, $4f, $22
    sprite_oam_piece $08, $fc, $4e, $22
    sprite_oam_piece $08, $04, $4d, $22
    sprite_oam_piece $08, $0c, $4c, $22
    sprite_oam_piece $00, $ec, $4b, $22
    sprite_oam_piece $00, $f4, $4a, $22
    sprite_oam_piece $00, $fc, $49, $22
    sprite_oam_piece $00, $04, $48, $22
    sprite_oam_piece $00, $0c, $47, $22
    sprite_oam_piece $f8, $ec, $46, $22
    sprite_oam_piece $f8, $f4, $45, $22
    sprite_oam_piece $f8, $fc, $44, $22
    sprite_oam_piece $f8, $04, $43, $22
    sprite_oam_piece $f8, $0c, $42, $22
    sprite_oam_piece $f0, $ec, $41, $22
    sprite_oam_piece $f0, $f4, $40, $22
    sprite_oam_piece $f0, $fc, $3f, $22
    sprite_oam_piece $f0, $04, $3e, $22
    sprite_oam_piece $f0, $0c, $3d, $22
    sprite_oam_piece $f0, $14, $3c, $22

SpriteFrame_1E_71B0::
    db 21
    sprite_oam_piece $07, $ec, $55, $22
    sprite_oam_piece $07, $f4, $54, $22
    sprite_oam_piece $07, $fc, $53, $22
    sprite_oam_piece $07, $04, $52, $22
    sprite_oam_piece $07, $0c, $51, $22
    sprite_oam_piece $ff, $ec, $4b, $22
    sprite_oam_piece $ff, $f4, $4a, $22
    sprite_oam_piece $ff, $fc, $49, $22
    sprite_oam_piece $ff, $04, $48, $22
    sprite_oam_piece $ff, $0c, $47, $22
    sprite_oam_piece $f7, $ec, $46, $22
    sprite_oam_piece $f7, $f4, $45, $22
    sprite_oam_piece $f7, $fc, $44, $22
    sprite_oam_piece $f7, $04, $43, $22
    sprite_oam_piece $f7, $0c, $42, $22
    sprite_oam_piece $ef, $ec, $41, $22
    sprite_oam_piece $ef, $f4, $40, $22
    sprite_oam_piece $ef, $fc, $3f, $22
    sprite_oam_piece $ef, $04, $3e, $22
    sprite_oam_piece $ef, $0c, $3d, $22
    sprite_oam_piece $ef, $14, $3c, $22

SpriteFrame_1E_7205::
    db 21
    sprite_oam_piece $06, $ec, $5a, $22
    sprite_oam_piece $06, $f4, $59, $22
    sprite_oam_piece $06, $fc, $58, $22
    sprite_oam_piece $06, $04, $57, $22
    sprite_oam_piece $06, $0c, $56, $22
    sprite_oam_piece $fe, $ec, $4b, $22
    sprite_oam_piece $fe, $f4, $4a, $22
    sprite_oam_piece $fe, $fc, $49, $22
    sprite_oam_piece $fe, $04, $48, $22
    sprite_oam_piece $fe, $0c, $47, $22
    sprite_oam_piece $f6, $ec, $46, $22
    sprite_oam_piece $f6, $f4, $45, $22
    sprite_oam_piece $f6, $fc, $44, $22
    sprite_oam_piece $f6, $04, $43, $22
    sprite_oam_piece $f6, $0c, $42, $22
    sprite_oam_piece $ee, $ec, $41, $22
    sprite_oam_piece $ee, $f4, $40, $22
    sprite_oam_piece $ee, $fc, $3f, $22
    sprite_oam_piece $ee, $04, $3e, $22
    sprite_oam_piece $ee, $0c, $3d, $22
    sprite_oam_piece $ee, $14, $3c, $22

SpriteAnimation_106:: ; $1E:$725A
    sprite_anim_entry SpriteFrame_1E_6CA8, $0a
    sprite_anim_entry SpriteFrame_1E_6CED, $0a
    sprite_anim_entry SpriteFrame_1E_6D32, $0a
    sprite_anim_entry SpriteFrame_1E_6CED, $0a
    sprite_anim_end

SpriteAnimation_110:: ; $1E:$7268
    sprite_anim_entry SpriteFrame_1E_6E46, $0a
    sprite_anim_entry SpriteFrame_1E_6E9F, $0a
    sprite_anim_entry SpriteFrame_1E_6EF8, $0a
    sprite_anim_entry SpriteFrame_1E_6E9F, $0a
    sprite_anim_end

SpriteAnimation_108:: ; $1E:$7276
    sprite_anim_entry SpriteFrame_1E_6D77, $0a
    sprite_anim_entry SpriteFrame_1E_6DBC, $0a
    sprite_anim_entry SpriteFrame_1E_6E01, $0a
    sprite_anim_entry SpriteFrame_1E_6DBC, $0a
    sprite_anim_end

SpriteAnimation_112:: ; $1E:$7284
    sprite_anim_entry SpriteFrame_1E_6F51, $0a
    sprite_anim_entry SpriteFrame_1E_6FAA, $0a
    sprite_anim_entry SpriteFrame_1E_7003, $0a
    sprite_anim_entry SpriteFrame_1E_6FAA, $0a
    sprite_anim_end

SpriteAnimation_114:: ; $1E:$7292
    sprite_anim_entry SpriteFrame_1E_705C, $0a
    sprite_anim_entry SpriteFrame_1E_70B1, $0a
    sprite_anim_entry SpriteFrame_1E_7106, $0a
    sprite_anim_entry SpriteFrame_1E_70B1, $0a
    sprite_anim_end

SpriteAnimation_116:: ; $1E:$72A0
    sprite_anim_entry SpriteFrame_1E_715B, $0a
    sprite_anim_entry SpriteFrame_1E_71B0, $0a
    sprite_anim_entry SpriteFrame_1E_7205, $0a
    sprite_anim_entry SpriteFrame_1E_71B0, $0a
    sprite_anim_end

SpriteAnimation_107:: ; $1E:$72AE
    sprite_anim_entry SpriteFrame_1E_6CED, $ff
    sprite_anim_end

SpriteAnimation_109:: ; $1E:$72B3
    sprite_anim_entry SpriteFrame_1E_6DBC, $ff
    sprite_anim_end

SpriteAnimation_111:: ; $1E:$72B8
    sprite_anim_entry SpriteFrame_1E_6E9F, $ff
    sprite_anim_end

SpriteAnimation_113:: ; $1E:$72BD
    sprite_anim_entry SpriteFrame_1E_6FAA, $ff
    sprite_anim_end

SpriteAnimation_115:: ; $1E:$72C2
    sprite_anim_entry SpriteFrame_1E_70B1, $ff
    sprite_anim_end

SpriteAnimation_117:: ; $1E:$72C7
    sprite_anim_entry SpriteFrame_1E_71B0, $ff
    sprite_anim_end

assert @ == $72cc

section "Sprite Animation Data 1F:4000", romx[$4000], bank[$1f]

SpriteFrame_1F_4000::
    db 24
    sprite_oam_piece $08, $10, $18, $02
    sprite_oam_piece $08, $08, $17, $02
    sprite_oam_piece $08, $00, $16, $02
    sprite_oam_piece $08, $f8, $15, $02
    sprite_oam_piece $08, $f0, $14, $02
    sprite_oam_piece $08, $e8, $13, $02
    sprite_oam_piece $00, $10, $12, $02
    sprite_oam_piece $00, $08, $11, $02
    sprite_oam_piece $00, $00, $10, $02
    sprite_oam_piece $00, $f8, $0f, $02
    sprite_oam_piece $00, $f0, $0e, $02
    sprite_oam_piece $00, $e8, $0d, $02
    sprite_oam_piece $f8, $10, $0c, $02
    sprite_oam_piece $f8, $08, $0b, $02
    sprite_oam_piece $f8, $00, $0a, $02
    sprite_oam_piece $f8, $f8, $09, $02
    sprite_oam_piece $f8, $f0, $08, $02
    sprite_oam_piece $f8, $e8, $07, $02
    sprite_oam_piece $f0, $10, $06, $02
    sprite_oam_piece $f0, $08, $05, $02
    sprite_oam_piece $f0, $00, $04, $02
    sprite_oam_piece $f0, $f8, $03, $02
    sprite_oam_piece $f0, $f0, $02, $02
    sprite_oam_piece $f0, $e8, $01, $02

SpriteFrame_1F_4061::
    db 24
    sprite_oam_piece $07, $10, $1e, $02
    sprite_oam_piece $07, $08, $1d, $02
    sprite_oam_piece $07, $00, $1c, $02
    sprite_oam_piece $07, $f8, $1b, $02
    sprite_oam_piece $07, $f0, $1a, $02
    sprite_oam_piece $07, $e8, $19, $02
    sprite_oam_piece $ff, $10, $12, $02
    sprite_oam_piece $ff, $08, $11, $02
    sprite_oam_piece $ff, $00, $10, $02
    sprite_oam_piece $ff, $f8, $0f, $02
    sprite_oam_piece $ff, $f0, $0e, $02
    sprite_oam_piece $ff, $e8, $0d, $02
    sprite_oam_piece $f7, $10, $0c, $02
    sprite_oam_piece $f7, $08, $0b, $02
    sprite_oam_piece $f7, $00, $0a, $02
    sprite_oam_piece $f7, $f8, $09, $02
    sprite_oam_piece $f7, $f0, $08, $02
    sprite_oam_piece $f7, $e8, $07, $02
    sprite_oam_piece $ef, $10, $06, $02
    sprite_oam_piece $ef, $08, $05, $02
    sprite_oam_piece $ef, $00, $04, $02
    sprite_oam_piece $ef, $f8, $03, $02
    sprite_oam_piece $ef, $f0, $02, $02
    sprite_oam_piece $ef, $e8, $01, $02

SpriteFrame_1F_40C2::
    db 24
    sprite_oam_piece $06, $10, $24, $02
    sprite_oam_piece $06, $08, $23, $02
    sprite_oam_piece $06, $00, $22, $02
    sprite_oam_piece $06, $f8, $21, $02
    sprite_oam_piece $06, $f0, $20, $02
    sprite_oam_piece $06, $e8, $1f, $02
    sprite_oam_piece $fe, $10, $12, $02
    sprite_oam_piece $fe, $08, $11, $02
    sprite_oam_piece $fe, $00, $10, $02
    sprite_oam_piece $fe, $f8, $0f, $02
    sprite_oam_piece $fe, $f0, $0e, $02
    sprite_oam_piece $fe, $e8, $0d, $02
    sprite_oam_piece $f6, $10, $0c, $02
    sprite_oam_piece $f6, $08, $0b, $02
    sprite_oam_piece $f6, $00, $0a, $02
    sprite_oam_piece $f6, $f8, $09, $02
    sprite_oam_piece $f6, $f0, $08, $02
    sprite_oam_piece $f6, $e8, $07, $02
    sprite_oam_piece $ee, $10, $06, $02
    sprite_oam_piece $ee, $08, $05, $02
    sprite_oam_piece $ee, $00, $04, $02
    sprite_oam_piece $ee, $f8, $03, $02
    sprite_oam_piece $ee, $f0, $02, $02
    sprite_oam_piece $ee, $e8, $01, $02

SpriteFrame_1F_4123::
    db 24
    sprite_oam_piece $08, $e8, $18, $22
    sprite_oam_piece $08, $f0, $17, $22
    sprite_oam_piece $08, $f8, $16, $22
    sprite_oam_piece $08, $00, $15, $22
    sprite_oam_piece $08, $08, $14, $22
    sprite_oam_piece $08, $10, $13, $22
    sprite_oam_piece $00, $e8, $12, $22
    sprite_oam_piece $00, $f0, $11, $22
    sprite_oam_piece $00, $f8, $10, $22
    sprite_oam_piece $00, $00, $0f, $22
    sprite_oam_piece $00, $08, $0e, $22
    sprite_oam_piece $00, $10, $0d, $22
    sprite_oam_piece $f8, $e8, $0c, $22
    sprite_oam_piece $f8, $f0, $0b, $22
    sprite_oam_piece $f8, $f8, $0a, $22
    sprite_oam_piece $f8, $00, $09, $22
    sprite_oam_piece $f8, $08, $08, $22
    sprite_oam_piece $f8, $10, $07, $22
    sprite_oam_piece $f0, $e8, $06, $22
    sprite_oam_piece $f0, $f0, $05, $22
    sprite_oam_piece $f0, $f8, $04, $22
    sprite_oam_piece $f0, $00, $03, $22
    sprite_oam_piece $f0, $08, $02, $22
    sprite_oam_piece $f0, $10, $01, $22

SpriteFrame_1F_4184::
    db 24
    sprite_oam_piece $07, $e8, $1e, $22
    sprite_oam_piece $07, $f0, $1d, $22
    sprite_oam_piece $07, $f8, $1c, $22
    sprite_oam_piece $07, $00, $1b, $22
    sprite_oam_piece $07, $08, $1a, $22
    sprite_oam_piece $07, $10, $19, $22
    sprite_oam_piece $ff, $e8, $12, $22
    sprite_oam_piece $ff, $f0, $11, $22
    sprite_oam_piece $ff, $f8, $10, $22
    sprite_oam_piece $ff, $00, $0f, $22
    sprite_oam_piece $ff, $08, $0e, $22
    sprite_oam_piece $ff, $10, $0d, $22
    sprite_oam_piece $f7, $e8, $0c, $22
    sprite_oam_piece $f7, $f0, $0b, $22
    sprite_oam_piece $f7, $f8, $0a, $22
    sprite_oam_piece $f7, $00, $09, $22
    sprite_oam_piece $f7, $08, $08, $22
    sprite_oam_piece $f7, $10, $07, $22
    sprite_oam_piece $ef, $e8, $06, $22
    sprite_oam_piece $ef, $f0, $05, $22
    sprite_oam_piece $ef, $f8, $04, $22
    sprite_oam_piece $ef, $00, $03, $22
    sprite_oam_piece $ef, $08, $02, $22
    sprite_oam_piece $ef, $10, $01, $22

SpriteFrame_1F_41E5::
    db 24
    sprite_oam_piece $06, $e8, $24, $22
    sprite_oam_piece $06, $f0, $23, $22
    sprite_oam_piece $06, $f8, $22, $22
    sprite_oam_piece $06, $00, $21, $22
    sprite_oam_piece $06, $08, $20, $22
    sprite_oam_piece $06, $10, $1f, $22
    sprite_oam_piece $fe, $e8, $12, $22
    sprite_oam_piece $fe, $f0, $11, $22
    sprite_oam_piece $fe, $f8, $10, $22
    sprite_oam_piece $fe, $00, $0f, $22
    sprite_oam_piece $fe, $08, $0e, $22
    sprite_oam_piece $fe, $10, $0d, $22
    sprite_oam_piece $f6, $e8, $0c, $22
    sprite_oam_piece $f6, $f0, $0b, $22
    sprite_oam_piece $f6, $f8, $0a, $22
    sprite_oam_piece $f6, $00, $09, $22
    sprite_oam_piece $f6, $08, $08, $22
    sprite_oam_piece $f6, $10, $07, $22
    sprite_oam_piece $ee, $e8, $06, $22
    sprite_oam_piece $ee, $f0, $05, $22
    sprite_oam_piece $ee, $f8, $04, $22
    sprite_oam_piece $ee, $00, $03, $22
    sprite_oam_piece $ee, $08, $02, $22
    sprite_oam_piece $ee, $10, $01, $22

SpriteFrame_1F_4246::
    db 17
    sprite_oam_piece $08, $0c, $35, $02
    sprite_oam_piece $08, $04, $34, $02
    sprite_oam_piece $08, $fc, $33, $02
    sprite_oam_piece $08, $f4, $32, $02
    sprite_oam_piece $08, $ec, $31, $02
    sprite_oam_piece $00, $0c, $30, $02
    sprite_oam_piece $00, $04, $2f, $02
    sprite_oam_piece $00, $fc, $2e, $02
    sprite_oam_piece $00, $f4, $2d, $02
    sprite_oam_piece $00, $ec, $2c, $02
    sprite_oam_piece $f8, $0c, $2b, $02
    sprite_oam_piece $f8, $04, $2a, $02
    sprite_oam_piece $f8, $fc, $29, $02
    sprite_oam_piece $f8, $f4, $28, $02
    sprite_oam_piece $f8, $ec, $27, $02
    sprite_oam_piece $f0, $06, $26, $02
    sprite_oam_piece $f0, $fe, $25, $02

SpriteFrame_1F_428B::
    db 17
    sprite_oam_piece $07, $0c, $3a, $02
    sprite_oam_piece $07, $04, $39, $02
    sprite_oam_piece $07, $fc, $38, $02
    sprite_oam_piece $07, $f4, $37, $02
    sprite_oam_piece $07, $ec, $36, $02
    sprite_oam_piece $ff, $0c, $30, $02
    sprite_oam_piece $ff, $04, $2f, $02
    sprite_oam_piece $ff, $fc, $2e, $02
    sprite_oam_piece $ff, $f4, $2d, $02
    sprite_oam_piece $ff, $ec, $2c, $02
    sprite_oam_piece $f7, $0c, $2b, $02
    sprite_oam_piece $f7, $04, $2a, $02
    sprite_oam_piece $f7, $fc, $29, $02
    sprite_oam_piece $f7, $f4, $28, $02
    sprite_oam_piece $f7, $ec, $27, $02
    sprite_oam_piece $ef, $06, $26, $02
    sprite_oam_piece $ef, $fe, $25, $02

SpriteFrame_1F_42D0::
    db 17
    sprite_oam_piece $06, $0c, $3f, $02
    sprite_oam_piece $06, $04, $3e, $02
    sprite_oam_piece $06, $fc, $3d, $02
    sprite_oam_piece $06, $f4, $3c, $02
    sprite_oam_piece $06, $ec, $3b, $02
    sprite_oam_piece $fe, $0c, $30, $02
    sprite_oam_piece $fe, $04, $2f, $02
    sprite_oam_piece $fe, $fc, $2e, $02
    sprite_oam_piece $fe, $f4, $2d, $02
    sprite_oam_piece $fe, $ec, $2c, $02
    sprite_oam_piece $f6, $0c, $2b, $02
    sprite_oam_piece $f6, $04, $2a, $02
    sprite_oam_piece $f6, $fc, $29, $02
    sprite_oam_piece $f6, $f4, $28, $02
    sprite_oam_piece $f6, $ec, $27, $02
    sprite_oam_piece $ee, $06, $26, $02
    sprite_oam_piece $ee, $fe, $25, $02

SpriteFrame_1F_4315::
    db 17
    sprite_oam_piece $08, $ec, $35, $22
    sprite_oam_piece $08, $f4, $34, $22
    sprite_oam_piece $08, $fc, $33, $22
    sprite_oam_piece $08, $04, $32, $22
    sprite_oam_piece $08, $0c, $31, $22
    sprite_oam_piece $00, $ec, $30, $22
    sprite_oam_piece $00, $f4, $2f, $22
    sprite_oam_piece $00, $fc, $2e, $22
    sprite_oam_piece $00, $04, $2d, $22
    sprite_oam_piece $00, $0c, $2c, $22
    sprite_oam_piece $f8, $ec, $2b, $22
    sprite_oam_piece $f8, $f4, $2a, $22
    sprite_oam_piece $f8, $fc, $29, $22
    sprite_oam_piece $f8, $04, $28, $22
    sprite_oam_piece $f8, $0c, $27, $22
    sprite_oam_piece $f0, $f2, $26, $22
    sprite_oam_piece $f0, $fa, $25, $22

SpriteFrame_1F_435A::
    db 17
    sprite_oam_piece $07, $ec, $3a, $22
    sprite_oam_piece $07, $f4, $39, $22
    sprite_oam_piece $07, $fc, $38, $22
    sprite_oam_piece $07, $04, $37, $22
    sprite_oam_piece $07, $0c, $36, $22
    sprite_oam_piece $ff, $ec, $30, $22
    sprite_oam_piece $ff, $f4, $2f, $22
    sprite_oam_piece $ff, $fc, $2e, $22
    sprite_oam_piece $ff, $04, $2d, $22
    sprite_oam_piece $ff, $0c, $2c, $22
    sprite_oam_piece $f7, $ec, $2b, $22
    sprite_oam_piece $f7, $f4, $2a, $22
    sprite_oam_piece $f7, $fc, $29, $22
    sprite_oam_piece $f7, $04, $28, $22
    sprite_oam_piece $f7, $0c, $27, $22
    sprite_oam_piece $ef, $f2, $26, $22
    sprite_oam_piece $ef, $fa, $25, $22

SpriteFrame_1F_439F::
    db 17
    sprite_oam_piece $06, $ec, $3f, $22
    sprite_oam_piece $06, $f4, $3e, $22
    sprite_oam_piece $06, $fc, $3d, $22
    sprite_oam_piece $06, $04, $3c, $22
    sprite_oam_piece $06, $0c, $3b, $22
    sprite_oam_piece $fe, $ec, $30, $22
    sprite_oam_piece $fe, $f4, $2f, $22
    sprite_oam_piece $fe, $fc, $2e, $22
    sprite_oam_piece $fe, $04, $2d, $22
    sprite_oam_piece $fe, $0c, $2c, $22
    sprite_oam_piece $f6, $ec, $2b, $22
    sprite_oam_piece $f6, $f4, $2a, $22
    sprite_oam_piece $f6, $fc, $29, $22
    sprite_oam_piece $f6, $04, $28, $22
    sprite_oam_piece $f6, $0c, $27, $22
    sprite_oam_piece $ee, $f2, $26, $22
    sprite_oam_piece $ee, $fa, $25, $22

SpriteFrame_1F_43E4::
    db 18
    sprite_oam_piece $08, $0c, $51, $02
    sprite_oam_piece $08, $04, $50, $02
    sprite_oam_piece $08, $fc, $4f, $02
    sprite_oam_piece $08, $f4, $4e, $02
    sprite_oam_piece $08, $ec, $4d, $02
    sprite_oam_piece $00, $0c, $4c, $02
    sprite_oam_piece $00, $04, $4b, $02
    sprite_oam_piece $00, $fc, $4a, $02
    sprite_oam_piece $00, $f4, $49, $02
    sprite_oam_piece $00, $ec, $48, $02
    sprite_oam_piece $f8, $0c, $47, $02
    sprite_oam_piece $f8, $04, $46, $02
    sprite_oam_piece $f8, $fc, $45, $02
    sprite_oam_piece $f8, $f4, $44, $02
    sprite_oam_piece $f8, $ec, $43, $02
    sprite_oam_piece $f0, $06, $42, $02
    sprite_oam_piece $f0, $fe, $41, $02
    sprite_oam_piece $f0, $f6, $40, $02

SpriteFrame_1F_442D::
    db 18
    sprite_oam_piece $07, $0c, $56, $02
    sprite_oam_piece $07, $04, $55, $02
    sprite_oam_piece $07, $fc, $54, $02
    sprite_oam_piece $07, $f4, $53, $02
    sprite_oam_piece $07, $ec, $52, $02
    sprite_oam_piece $ff, $0c, $4c, $02
    sprite_oam_piece $ff, $04, $4b, $02
    sprite_oam_piece $ff, $fc, $4a, $02
    sprite_oam_piece $ff, $f4, $49, $02
    sprite_oam_piece $ff, $ec, $48, $02
    sprite_oam_piece $f7, $0c, $47, $02
    sprite_oam_piece $f7, $04, $46, $02
    sprite_oam_piece $f7, $fc, $45, $02
    sprite_oam_piece $f7, $f4, $44, $02
    sprite_oam_piece $f7, $ec, $43, $02
    sprite_oam_piece $ef, $06, $42, $02
    sprite_oam_piece $ef, $fe, $41, $02
    sprite_oam_piece $ef, $f6, $40, $02

SpriteFrame_1F_4476::
    db 18
    sprite_oam_piece $06, $0c, $5b, $02
    sprite_oam_piece $06, $04, $5a, $02
    sprite_oam_piece $06, $fc, $59, $02
    sprite_oam_piece $06, $f4, $58, $02
    sprite_oam_piece $06, $ec, $57, $02
    sprite_oam_piece $fe, $0c, $4c, $02
    sprite_oam_piece $fe, $04, $4b, $02
    sprite_oam_piece $fe, $fc, $4a, $02
    sprite_oam_piece $fe, $f4, $49, $02
    sprite_oam_piece $fe, $ec, $48, $02
    sprite_oam_piece $f6, $0c, $47, $02
    sprite_oam_piece $f6, $04, $46, $02
    sprite_oam_piece $f6, $fc, $45, $02
    sprite_oam_piece $f6, $f4, $44, $02
    sprite_oam_piece $f6, $ec, $43, $02
    sprite_oam_piece $ee, $06, $42, $02
    sprite_oam_piece $ee, $fe, $41, $02
    sprite_oam_piece $ee, $f6, $40, $02

SpriteFrame_1F_44BF::
    db 18
    sprite_oam_piece $08, $ec, $51, $22
    sprite_oam_piece $08, $f4, $50, $22
    sprite_oam_piece $08, $fc, $4f, $22
    sprite_oam_piece $08, $04, $4e, $22
    sprite_oam_piece $08, $0c, $4d, $22
    sprite_oam_piece $00, $ec, $4c, $22
    sprite_oam_piece $00, $f4, $4b, $22
    sprite_oam_piece $00, $fc, $4a, $22
    sprite_oam_piece $00, $04, $49, $22
    sprite_oam_piece $00, $0c, $48, $22
    sprite_oam_piece $f8, $ec, $47, $22
    sprite_oam_piece $f8, $f4, $46, $22
    sprite_oam_piece $f8, $fc, $45, $22
    sprite_oam_piece $f8, $04, $44, $22
    sprite_oam_piece $f8, $0c, $43, $22
    sprite_oam_piece $f0, $f2, $42, $22
    sprite_oam_piece $f0, $fa, $41, $22
    sprite_oam_piece $f0, $02, $40, $22

SpriteFrame_1F_4508::
    db 18
    sprite_oam_piece $07, $ec, $56, $22
    sprite_oam_piece $07, $f4, $55, $22
    sprite_oam_piece $07, $fc, $54, $22
    sprite_oam_piece $07, $04, $53, $22
    sprite_oam_piece $07, $0c, $52, $22
    sprite_oam_piece $ff, $ec, $4c, $22
    sprite_oam_piece $ff, $f4, $4b, $22
    sprite_oam_piece $ff, $fc, $4a, $22
    sprite_oam_piece $ff, $04, $49, $22
    sprite_oam_piece $ff, $0c, $48, $22
    sprite_oam_piece $f7, $ec, $47, $22
    sprite_oam_piece $f7, $f4, $46, $22
    sprite_oam_piece $f7, $fc, $45, $22
    sprite_oam_piece $f7, $04, $44, $22
    sprite_oam_piece $f7, $0c, $43, $22
    sprite_oam_piece $ef, $f2, $42, $22
    sprite_oam_piece $ef, $fa, $41, $22
    sprite_oam_piece $ef, $02, $40, $22

SpriteFrame_1F_4551::
    db 18
    sprite_oam_piece $06, $ec, $5b, $22
    sprite_oam_piece $06, $f4, $5a, $22
    sprite_oam_piece $06, $fc, $59, $22
    sprite_oam_piece $06, $04, $58, $22
    sprite_oam_piece $06, $0c, $57, $22
    sprite_oam_piece $fe, $ec, $4c, $22
    sprite_oam_piece $fe, $f4, $4b, $22
    sprite_oam_piece $fe, $fc, $4a, $22
    sprite_oam_piece $fe, $04, $49, $22
    sprite_oam_piece $fe, $0c, $48, $22
    sprite_oam_piece $f6, $ec, $47, $22
    sprite_oam_piece $f6, $f4, $46, $22
    sprite_oam_piece $f6, $fc, $45, $22
    sprite_oam_piece $f6, $04, $44, $22
    sprite_oam_piece $f6, $0c, $43, $22
    sprite_oam_piece $ee, $f2, $42, $22
    sprite_oam_piece $ee, $fa, $41, $22
    sprite_oam_piece $ee, $02, $40, $22

SpriteAnimation_122:: ; $1F:$459A
    sprite_anim_entry SpriteFrame_1F_4246, $0a
    sprite_anim_entry SpriteFrame_1F_428B, $0a
    sprite_anim_entry SpriteFrame_1F_42D0, $0a
    sprite_anim_entry SpriteFrame_1F_428B, $0a
    sprite_anim_end

SpriteAnimation_120:: ; $1F:$45A8
    sprite_anim_entry SpriteFrame_1F_4123, $0a
    sprite_anim_entry SpriteFrame_1F_4184, $0a
    sprite_anim_entry SpriteFrame_1F_41E5, $0a
    sprite_anim_entry SpriteFrame_1F_4184, $0a
    sprite_anim_end

SpriteAnimation_118:: ; $1F:$45B6
    sprite_anim_entry SpriteFrame_1F_4000, $0a
    sprite_anim_entry SpriteFrame_1F_4061, $0a
    sprite_anim_entry SpriteFrame_1F_40C2, $0a
    sprite_anim_entry SpriteFrame_1F_4061, $0a
    sprite_anim_end

SpriteAnimation_124:: ; $1F:$45C4
    sprite_anim_entry SpriteFrame_1F_4315, $0a
    sprite_anim_entry SpriteFrame_1F_435A, $0a
    sprite_anim_entry SpriteFrame_1F_439F, $0a
    sprite_anim_entry SpriteFrame_1F_435A, $0a
    sprite_anim_end

SpriteAnimation_126:: ; $1F:$45D2
    sprite_anim_entry SpriteFrame_1F_43E4, $0a
    sprite_anim_entry SpriteFrame_1F_442D, $0a
    sprite_anim_entry SpriteFrame_1F_4476, $0a
    sprite_anim_entry SpriteFrame_1F_442D, $0a
    sprite_anim_end

SpriteAnimation_128:: ; $1F:$45E0
    sprite_anim_entry SpriteFrame_1F_44BF, $0a
    sprite_anim_entry SpriteFrame_1F_4508, $0a
    sprite_anim_entry SpriteFrame_1F_4551, $0a
    sprite_anim_entry SpriteFrame_1F_4508, $0a
    sprite_anim_end

SpriteAnimation_119:: ; $1F:$45EE
    sprite_anim_entry SpriteFrame_1F_4061, $ff
    sprite_anim_end

SpriteAnimation_121:: ; $1F:$45F3
    sprite_anim_entry SpriteFrame_1F_4184, $ff
    sprite_anim_end

SpriteAnimation_123:: ; $1F:$45F8
    sprite_anim_entry SpriteFrame_1F_428B, $ff
    sprite_anim_end

SpriteAnimation_125:: ; $1F:$45FD
    sprite_anim_entry SpriteFrame_1F_435A, $ff
    sprite_anim_end

SpriteAnimation_127:: ; $1F:$4602
    sprite_anim_entry SpriteFrame_1F_442D, $ff
    sprite_anim_end

SpriteAnimation_129:: ; $1F:$4607
    sprite_anim_entry SpriteFrame_1F_4508, $ff
    sprite_anim_end

assert @ == $460c

section "Sprite Animation Data 1F:4C24", romx[$4c24], bank[$1f]

SpriteFrame_1F_4C24::
    db 14
    sprite_oam_piece $08, $08, $0f, $02
    sprite_oam_piece $08, $00, $0e, $02
    sprite_oam_piece $08, $f8, $0d, $02
    sprite_oam_piece $08, $f0, $0c, $02
    sprite_oam_piece $00, $08, $0a, $02
    sprite_oam_piece $00, $00, $09, $02
    sprite_oam_piece $00, $f8, $08, $02
    sprite_oam_piece $00, $f0, $07, $02
    sprite_oam_piece $f8, $08, $06, $02
    sprite_oam_piece $f8, $00, $05, $02
    sprite_oam_piece $f8, $f8, $04, $02
    sprite_oam_piece $f8, $f0, $03, $02
    sprite_oam_piece $f0, $00, $02, $02
    sprite_oam_piece $f0, $f8, $01, $02

SpriteFrame_1F_4C5D::
    db 14
    sprite_oam_piece $07, $08, $14, $02
    sprite_oam_piece $07, $00, $13, $02
    sprite_oam_piece $07, $f8, $12, $02
    sprite_oam_piece $07, $f0, $11, $02
    sprite_oam_piece $ff, $08, $0a, $02
    sprite_oam_piece $ff, $00, $09, $02
    sprite_oam_piece $ff, $f8, $08, $02
    sprite_oam_piece $ff, $f0, $07, $02
    sprite_oam_piece $f7, $08, $06, $02
    sprite_oam_piece $f7, $00, $05, $02
    sprite_oam_piece $f7, $f8, $04, $02
    sprite_oam_piece $f7, $f0, $03, $02
    sprite_oam_piece $ef, $00, $02, $02
    sprite_oam_piece $ef, $f8, $01, $02

SpriteFrame_1F_4C96::
    db 14
    sprite_oam_piece $06, $08, $19, $02
    sprite_oam_piece $06, $00, $18, $02
    sprite_oam_piece $06, $f8, $17, $02
    sprite_oam_piece $06, $f0, $16, $02
    sprite_oam_piece $fe, $08, $0a, $02
    sprite_oam_piece $fe, $00, $09, $02
    sprite_oam_piece $fe, $f8, $08, $02
    sprite_oam_piece $fe, $f0, $07, $02
    sprite_oam_piece $f6, $08, $06, $02
    sprite_oam_piece $f6, $00, $05, $02
    sprite_oam_piece $f6, $f8, $04, $02
    sprite_oam_piece $f6, $f0, $03, $02
    sprite_oam_piece $ee, $00, $02, $02
    sprite_oam_piece $ee, $f8, $01, $02

SpriteFrame_1F_4CCF::
    db 14
    sprite_oam_piece $08, $f0, $0f, $22
    sprite_oam_piece $08, $f8, $0e, $22
    sprite_oam_piece $08, $00, $0d, $22
    sprite_oam_piece $08, $08, $0c, $22
    sprite_oam_piece $00, $f0, $0a, $22
    sprite_oam_piece $00, $f8, $09, $22
    sprite_oam_piece $00, $00, $08, $22
    sprite_oam_piece $00, $08, $07, $22
    sprite_oam_piece $f8, $f0, $06, $22
    sprite_oam_piece $f8, $f8, $05, $22
    sprite_oam_piece $f8, $00, $04, $22
    sprite_oam_piece $f8, $08, $03, $22
    sprite_oam_piece $f0, $f8, $02, $22
    sprite_oam_piece $f0, $00, $01, $22

SpriteFrame_1F_4D08::
    db 14
    sprite_oam_piece $07, $f0, $14, $22
    sprite_oam_piece $07, $f8, $13, $22
    sprite_oam_piece $07, $00, $12, $22
    sprite_oam_piece $07, $08, $11, $22
    sprite_oam_piece $ff, $f0, $0a, $22
    sprite_oam_piece $ff, $f8, $09, $22
    sprite_oam_piece $ff, $00, $08, $22
    sprite_oam_piece $ff, $08, $07, $22
    sprite_oam_piece $f7, $f0, $06, $22
    sprite_oam_piece $f7, $f8, $05, $22
    sprite_oam_piece $f7, $00, $04, $22
    sprite_oam_piece $f7, $08, $03, $22
    sprite_oam_piece $ef, $f8, $02, $22
    sprite_oam_piece $ef, $00, $01, $22

SpriteFrame_1F_4D41::
    db 14
    sprite_oam_piece $06, $f0, $19, $22
    sprite_oam_piece $06, $f8, $18, $22
    sprite_oam_piece $06, $00, $17, $22
    sprite_oam_piece $06, $08, $16, $22
    sprite_oam_piece $fe, $f0, $0a, $22
    sprite_oam_piece $fe, $f8, $09, $22
    sprite_oam_piece $fe, $00, $08, $22
    sprite_oam_piece $fe, $08, $07, $22
    sprite_oam_piece $f6, $f0, $06, $22
    sprite_oam_piece $f6, $f8, $05, $22
    sprite_oam_piece $f6, $00, $04, $22
    sprite_oam_piece $f6, $08, $03, $22
    sprite_oam_piece $ee, $f8, $02, $22
    sprite_oam_piece $ee, $00, $01, $22

SpriteFrame_1F_4D7A::
    db 19
    sprite_oam_piece $08, $0c, $2c, $02
    sprite_oam_piece $08, $04, $2b, $02
    sprite_oam_piece $08, $fc, $2a, $02
    sprite_oam_piece $08, $f4, $29, $02
    sprite_oam_piece $08, $ec, $28, $02
    sprite_oam_piece $00, $0c, $27, $02
    sprite_oam_piece $00, $04, $26, $02
    sprite_oam_piece $00, $fc, $25, $02
    sprite_oam_piece $00, $f4, $24, $02
    sprite_oam_piece $00, $ec, $23, $02
    sprite_oam_piece $f8, $0c, $22, $02
    sprite_oam_piece $f8, $04, $21, $02
    sprite_oam_piece $f8, $fc, $20, $02
    sprite_oam_piece $f8, $f4, $1f, $02
    sprite_oam_piece $f8, $ec, $1e, $02
    sprite_oam_piece $f0, $07, $1d, $02
    sprite_oam_piece $f0, $ff, $1c, $02
    sprite_oam_piece $f0, $f7, $1b, $02
    sprite_oam_piece $f0, $ef, $1a, $02

SpriteFrame_1F_4DC7::
    db 19
    sprite_oam_piece $07, $0c, $31, $02
    sprite_oam_piece $07, $04, $30, $02
    sprite_oam_piece $07, $fc, $2f, $02
    sprite_oam_piece $07, $f4, $2e, $02
    sprite_oam_piece $07, $ec, $2d, $02
    sprite_oam_piece $ff, $0c, $27, $02
    sprite_oam_piece $ff, $04, $26, $02
    sprite_oam_piece $ff, $fc, $25, $02
    sprite_oam_piece $ff, $f4, $24, $02
    sprite_oam_piece $ff, $ec, $23, $02
    sprite_oam_piece $f7, $0c, $22, $02
    sprite_oam_piece $f7, $04, $21, $02
    sprite_oam_piece $f7, $fc, $20, $02
    sprite_oam_piece $f7, $f4, $1f, $02
    sprite_oam_piece $f7, $ec, $1e, $02
    sprite_oam_piece $ef, $07, $1d, $02
    sprite_oam_piece $ef, $ff, $1c, $02
    sprite_oam_piece $ef, $f7, $1b, $02
    sprite_oam_piece $ef, $ef, $1a, $02

SpriteFrame_1F_4E14::
    db 19
    sprite_oam_piece $06, $0c, $36, $02
    sprite_oam_piece $06, $04, $35, $02
    sprite_oam_piece $06, $fc, $34, $02
    sprite_oam_piece $06, $f4, $33, $02
    sprite_oam_piece $06, $ec, $32, $02
    sprite_oam_piece $fe, $0c, $27, $02
    sprite_oam_piece $fe, $04, $26, $02
    sprite_oam_piece $fe, $fc, $25, $02
    sprite_oam_piece $fe, $f4, $24, $02
    sprite_oam_piece $fe, $ec, $23, $02
    sprite_oam_piece $f6, $0c, $22, $02
    sprite_oam_piece $f6, $04, $21, $02
    sprite_oam_piece $f6, $fc, $20, $02
    sprite_oam_piece $f6, $f4, $1f, $02
    sprite_oam_piece $f6, $ec, $1e, $02
    sprite_oam_piece $ee, $07, $1d, $02
    sprite_oam_piece $ee, $ff, $1c, $02
    sprite_oam_piece $ee, $f7, $1b, $02
    sprite_oam_piece $ee, $ef, $1a, $02

SpriteFrame_1F_4E61::
    db 19
    sprite_oam_piece $08, $ec, $2c, $22
    sprite_oam_piece $08, $f4, $2b, $22
    sprite_oam_piece $08, $fc, $2a, $22
    sprite_oam_piece $08, $04, $29, $22
    sprite_oam_piece $08, $0c, $28, $22
    sprite_oam_piece $00, $ec, $27, $22
    sprite_oam_piece $00, $f4, $26, $22
    sprite_oam_piece $00, $fc, $25, $22
    sprite_oam_piece $00, $04, $24, $22
    sprite_oam_piece $00, $0c, $23, $22
    sprite_oam_piece $f8, $ec, $22, $22
    sprite_oam_piece $f8, $f4, $21, $22
    sprite_oam_piece $f8, $fc, $20, $22
    sprite_oam_piece $f8, $04, $1f, $22
    sprite_oam_piece $f8, $0c, $1e, $22
    sprite_oam_piece $f0, $f1, $1d, $22
    sprite_oam_piece $f0, $f9, $1c, $22
    sprite_oam_piece $f0, $01, $1b, $22
    sprite_oam_piece $f0, $09, $1a, $22

SpriteFrame_1F_4EAE::
    db 19
    sprite_oam_piece $07, $ec, $31, $22
    sprite_oam_piece $07, $f4, $30, $22
    sprite_oam_piece $07, $fc, $2f, $22
    sprite_oam_piece $07, $04, $2e, $22
    sprite_oam_piece $07, $0c, $2d, $22
    sprite_oam_piece $ff, $ec, $27, $22
    sprite_oam_piece $ff, $f4, $26, $22
    sprite_oam_piece $ff, $fc, $25, $22
    sprite_oam_piece $ff, $04, $24, $22
    sprite_oam_piece $ff, $0c, $23, $22
    sprite_oam_piece $f7, $ec, $22, $22
    sprite_oam_piece $f7, $f4, $21, $22
    sprite_oam_piece $f7, $fc, $20, $22
    sprite_oam_piece $f7, $04, $1f, $22
    sprite_oam_piece $f7, $0c, $1e, $22
    sprite_oam_piece $ef, $f1, $1d, $22
    sprite_oam_piece $ef, $f9, $1c, $22
    sprite_oam_piece $ef, $01, $1b, $22
    sprite_oam_piece $ef, $09, $1a, $22

SpriteFrame_1F_4EFB::
    db 19
    sprite_oam_piece $06, $ec, $36, $22
    sprite_oam_piece $06, $f4, $35, $22
    sprite_oam_piece $06, $fc, $34, $22
    sprite_oam_piece $06, $04, $33, $22
    sprite_oam_piece $06, $0c, $32, $22
    sprite_oam_piece $fe, $ec, $27, $22
    sprite_oam_piece $fe, $f4, $26, $22
    sprite_oam_piece $fe, $fc, $25, $22
    sprite_oam_piece $fe, $04, $24, $22
    sprite_oam_piece $fe, $0c, $23, $22
    sprite_oam_piece $f6, $ec, $22, $22
    sprite_oam_piece $f6, $f4, $21, $22
    sprite_oam_piece $f6, $fc, $20, $22
    sprite_oam_piece $f6, $04, $1f, $22
    sprite_oam_piece $f6, $0c, $1e, $22
    sprite_oam_piece $ee, $f1, $1d, $22
    sprite_oam_piece $ee, $f9, $1c, $22
    sprite_oam_piece $ee, $01, $1b, $22
    sprite_oam_piece $ee, $09, $1a, $22

SpriteFrame_1F_4F48::
    db 22
    sprite_oam_piece $08, $0c, $4b, $02
    sprite_oam_piece $08, $04, $4a, $02
    sprite_oam_piece $08, $fc, $49, $02
    sprite_oam_piece $08, $f4, $48, $02
    sprite_oam_piece $08, $ec, $47, $02
    sprite_oam_piece $00, $0c, $46, $02
    sprite_oam_piece $00, $04, $45, $02
    sprite_oam_piece $00, $fc, $44, $02
    sprite_oam_piece $00, $f4, $43, $02
    sprite_oam_piece $00, $ec, $42, $02
    sprite_oam_piece $f8, $0c, $41, $02
    sprite_oam_piece $f8, $04, $40, $02
    sprite_oam_piece $f8, $fc, $3f, $02
    sprite_oam_piece $f8, $f4, $3e, $02
    sprite_oam_piece $f8, $ec, $3d, $02
    sprite_oam_piece $f8, $e4, $78, $02
    sprite_oam_piece $f0, $0c, $3c, $02
    sprite_oam_piece $f0, $04, $3b, $02
    sprite_oam_piece $f0, $fc, $3a, $02
    sprite_oam_piece $f0, $f4, $39, $02
    sprite_oam_piece $f0, $ec, $38, $02
    sprite_oam_piece $f0, $e4, $37, $02

SpriteFrame_1F_4FA1::
    db 22
    sprite_oam_piece $07, $0c, $50, $02
    sprite_oam_piece $07, $04, $4f, $02
    sprite_oam_piece $07, $fc, $4e, $02
    sprite_oam_piece $07, $f4, $4d, $02
    sprite_oam_piece $07, $ec, $4c, $02
    sprite_oam_piece $ff, $0c, $46, $02
    sprite_oam_piece $ff, $04, $45, $02
    sprite_oam_piece $ff, $fc, $44, $02
    sprite_oam_piece $ff, $f4, $43, $02
    sprite_oam_piece $ff, $ec, $42, $02
    sprite_oam_piece $f7, $0c, $41, $02
    sprite_oam_piece $f7, $04, $40, $02
    sprite_oam_piece $f7, $fc, $3f, $02
    sprite_oam_piece $f7, $f4, $3e, $02
    sprite_oam_piece $f7, $ec, $3d, $02
    sprite_oam_piece $f7, $e4, $78, $02
    sprite_oam_piece $ef, $0c, $3c, $02
    sprite_oam_piece $ef, $04, $3b, $02
    sprite_oam_piece $ef, $fc, $3a, $02
    sprite_oam_piece $ef, $f4, $39, $02
    sprite_oam_piece $ef, $ec, $38, $02
    sprite_oam_piece $ef, $e4, $37, $02

SpriteFrame_1F_4FFA::
    db 22
    sprite_oam_piece $06, $0c, $55, $02
    sprite_oam_piece $06, $04, $54, $02
    sprite_oam_piece $06, $fc, $53, $02
    sprite_oam_piece $06, $f4, $52, $02
    sprite_oam_piece $06, $ec, $51, $02
    sprite_oam_piece $fe, $0c, $46, $02
    sprite_oam_piece $fe, $04, $45, $02
    sprite_oam_piece $fe, $fc, $44, $02
    sprite_oam_piece $fe, $f4, $43, $02
    sprite_oam_piece $fe, $ec, $42, $02
    sprite_oam_piece $f6, $0c, $41, $02
    sprite_oam_piece $f6, $04, $40, $02
    sprite_oam_piece $f6, $fc, $3f, $02
    sprite_oam_piece $f6, $f4, $3e, $02
    sprite_oam_piece $f6, $ec, $3d, $02
    sprite_oam_piece $f6, $e4, $78, $02
    sprite_oam_piece $ee, $0c, $3c, $02
    sprite_oam_piece $ee, $04, $3b, $02
    sprite_oam_piece $ee, $fc, $3a, $02
    sprite_oam_piece $ee, $f4, $39, $02
    sprite_oam_piece $ee, $ec, $38, $02
    sprite_oam_piece $ee, $e4, $37, $02

SpriteFrame_1F_5053::
    db 22
    sprite_oam_piece $08, $ec, $4b, $22
    sprite_oam_piece $08, $f4, $4a, $22
    sprite_oam_piece $08, $fc, $49, $22
    sprite_oam_piece $08, $04, $48, $22
    sprite_oam_piece $08, $0c, $47, $22
    sprite_oam_piece $00, $ec, $46, $22
    sprite_oam_piece $00, $f4, $45, $22
    sprite_oam_piece $00, $fc, $44, $22
    sprite_oam_piece $00, $04, $43, $22
    sprite_oam_piece $00, $0c, $42, $22
    sprite_oam_piece $f8, $ec, $41, $22
    sprite_oam_piece $f8, $f4, $40, $22
    sprite_oam_piece $f8, $fc, $3f, $22
    sprite_oam_piece $f8, $04, $3e, $22
    sprite_oam_piece $f8, $0c, $3d, $22
    sprite_oam_piece $f8, $14, $78, $22
    sprite_oam_piece $f0, $ec, $3c, $22
    sprite_oam_piece $f0, $f4, $3b, $22
    sprite_oam_piece $f0, $fc, $3a, $22
    sprite_oam_piece $f0, $04, $39, $22
    sprite_oam_piece $f0, $0c, $38, $22
    sprite_oam_piece $f0, $14, $37, $22

SpriteFrame_1F_50AC::
    db 22
    sprite_oam_piece $07, $ec, $50, $22
    sprite_oam_piece $07, $f4, $4f, $22
    sprite_oam_piece $07, $fc, $4e, $22
    sprite_oam_piece $07, $04, $4d, $22
    sprite_oam_piece $07, $0c, $4c, $22
    sprite_oam_piece $ff, $ec, $46, $22
    sprite_oam_piece $ff, $f4, $45, $22
    sprite_oam_piece $ff, $fc, $44, $22
    sprite_oam_piece $ff, $04, $43, $22
    sprite_oam_piece $ff, $0c, $42, $22
    sprite_oam_piece $f7, $ec, $41, $22
    sprite_oam_piece $f7, $f4, $40, $22
    sprite_oam_piece $f7, $fc, $3f, $22
    sprite_oam_piece $f7, $04, $3e, $22
    sprite_oam_piece $f7, $0c, $3d, $22
    sprite_oam_piece $f7, $14, $78, $22
    sprite_oam_piece $ef, $ec, $3c, $22
    sprite_oam_piece $ef, $f4, $3b, $22
    sprite_oam_piece $ef, $fc, $3a, $22
    sprite_oam_piece $ef, $04, $39, $22
    sprite_oam_piece $ef, $0c, $38, $22
    sprite_oam_piece $ef, $14, $37, $22

SpriteFrame_1F_5105::
    db 22
    sprite_oam_piece $06, $ec, $55, $22
    sprite_oam_piece $06, $f4, $54, $22
    sprite_oam_piece $06, $fc, $53, $22
    sprite_oam_piece $06, $04, $52, $22
    sprite_oam_piece $06, $0c, $51, $22
    sprite_oam_piece $fe, $ec, $46, $22
    sprite_oam_piece $fe, $f4, $45, $22
    sprite_oam_piece $fe, $fc, $44, $22
    sprite_oam_piece $fe, $04, $43, $22
    sprite_oam_piece $fe, $0c, $42, $22
    sprite_oam_piece $f6, $ec, $41, $22
    sprite_oam_piece $f6, $f4, $40, $22
    sprite_oam_piece $f6, $fc, $3f, $22
    sprite_oam_piece $f6, $04, $3e, $22
    sprite_oam_piece $f6, $0c, $3d, $22
    sprite_oam_piece $f6, $14, $78, $22
    sprite_oam_piece $ee, $ec, $3c, $22
    sprite_oam_piece $ee, $f4, $3b, $22
    sprite_oam_piece $ee, $fc, $3a, $22
    sprite_oam_piece $ee, $04, $39, $22
    sprite_oam_piece $ee, $0c, $38, $22
    sprite_oam_piece $ee, $14, $37, $22

SpriteFrame_1F_515E::
    db 24
    sprite_oam_piece $08, $10, $6b, $02
    sprite_oam_piece $08, $08, $6a, $02
    sprite_oam_piece $08, $00, $69, $02
    sprite_oam_piece $08, $f8, $68, $02
    sprite_oam_piece $08, $f0, $67, $02
    sprite_oam_piece $08, $e8, $66, $02
    sprite_oam_piece $00, $10, $65, $02
    sprite_oam_piece $00, $08, $64, $02
    sprite_oam_piece $00, $00, $63, $02
    sprite_oam_piece $00, $f8, $62, $02
    sprite_oam_piece $00, $f0, $61, $02
    sprite_oam_piece $00, $e8, $60, $02
    sprite_oam_piece $f8, $10, $7a, $02
    sprite_oam_piece $f8, $08, $79, $02
    sprite_oam_piece $f8, $00, $5f, $02
    sprite_oam_piece $f8, $f8, $5e, $02
    sprite_oam_piece $f8, $f0, $5d, $02
    sprite_oam_piece $f8, $e8, $5c, $02
    sprite_oam_piece $f0, $10, $5b, $02
    sprite_oam_piece $f0, $08, $5a, $02
    sprite_oam_piece $f0, $00, $59, $02
    sprite_oam_piece $f0, $f8, $58, $02
    sprite_oam_piece $f0, $f0, $57, $02
    sprite_oam_piece $f0, $e8, $56, $02

SpriteFrame_1F_51BF::
    db 24
    sprite_oam_piece $07, $10, $71, $02
    sprite_oam_piece $07, $08, $70, $02
    sprite_oam_piece $07, $00, $6f, $02
    sprite_oam_piece $07, $f8, $6e, $02
    sprite_oam_piece $07, $f0, $6d, $02
    sprite_oam_piece $07, $e8, $6c, $02
    sprite_oam_piece $ff, $10, $65, $02
    sprite_oam_piece $ff, $08, $64, $02
    sprite_oam_piece $ff, $00, $63, $02
    sprite_oam_piece $ff, $f8, $62, $02
    sprite_oam_piece $ff, $f0, $61, $02
    sprite_oam_piece $ff, $e8, $60, $02
    sprite_oam_piece $f7, $10, $7a, $02
    sprite_oam_piece $f7, $08, $79, $02
    sprite_oam_piece $f7, $00, $5f, $02
    sprite_oam_piece $f7, $f8, $5e, $02
    sprite_oam_piece $f7, $f0, $5d, $02
    sprite_oam_piece $f7, $e8, $5c, $02
    sprite_oam_piece $ef, $10, $5b, $02
    sprite_oam_piece $ef, $08, $5a, $02
    sprite_oam_piece $ef, $00, $59, $02
    sprite_oam_piece $ef, $f8, $58, $02
    sprite_oam_piece $ef, $f0, $57, $02
    sprite_oam_piece $ef, $e8, $56, $02

SpriteFrame_1F_5220::
    db 24
    sprite_oam_piece $06, $10, $77, $02
    sprite_oam_piece $06, $08, $76, $02
    sprite_oam_piece $06, $00, $75, $02
    sprite_oam_piece $06, $f8, $74, $02
    sprite_oam_piece $06, $f0, $73, $02
    sprite_oam_piece $06, $e8, $72, $02
    sprite_oam_piece $fe, $10, $65, $02
    sprite_oam_piece $fe, $08, $64, $02
    sprite_oam_piece $fe, $00, $63, $02
    sprite_oam_piece $fe, $f8, $62, $02
    sprite_oam_piece $fe, $f0, $61, $02
    sprite_oam_piece $fe, $e8, $60, $02
    sprite_oam_piece $f6, $10, $7a, $02
    sprite_oam_piece $f6, $08, $79, $02
    sprite_oam_piece $f6, $00, $5f, $02
    sprite_oam_piece $f6, $f8, $5e, $02
    sprite_oam_piece $f6, $f0, $5d, $02
    sprite_oam_piece $f6, $e8, $5c, $02
    sprite_oam_piece $ee, $10, $5b, $02
    sprite_oam_piece $ee, $08, $5a, $02
    sprite_oam_piece $ee, $00, $59, $02
    sprite_oam_piece $ee, $f8, $58, $02
    sprite_oam_piece $ee, $f0, $57, $02
    sprite_oam_piece $ee, $e8, $56, $02

SpriteFrame_1F_5281::
    db 24
    sprite_oam_piece $08, $e8, $6b, $22
    sprite_oam_piece $08, $f0, $6a, $22
    sprite_oam_piece $08, $f8, $69, $22
    sprite_oam_piece $08, $00, $68, $22
    sprite_oam_piece $08, $08, $67, $22
    sprite_oam_piece $08, $10, $66, $22
    sprite_oam_piece $00, $e8, $65, $22
    sprite_oam_piece $00, $f0, $64, $22
    sprite_oam_piece $00, $f8, $63, $22
    sprite_oam_piece $00, $00, $62, $22
    sprite_oam_piece $00, $08, $61, $22
    sprite_oam_piece $00, $10, $60, $22
    sprite_oam_piece $f8, $e8, $7a, $22
    sprite_oam_piece $f8, $f0, $79, $22
    sprite_oam_piece $f8, $f8, $5f, $22
    sprite_oam_piece $f8, $00, $5e, $22
    sprite_oam_piece $f8, $08, $5d, $22
    sprite_oam_piece $f8, $10, $5c, $22
    sprite_oam_piece $f0, $e8, $5b, $22
    sprite_oam_piece $f0, $f0, $5a, $22
    sprite_oam_piece $f0, $f8, $59, $22
    sprite_oam_piece $f0, $00, $58, $22
    sprite_oam_piece $f0, $08, $57, $22
    sprite_oam_piece $f0, $10, $56, $22

SpriteFrame_1F_52E2::
    db 24
    sprite_oam_piece $07, $e8, $71, $22
    sprite_oam_piece $07, $f0, $70, $22
    sprite_oam_piece $07, $f8, $6f, $22
    sprite_oam_piece $07, $00, $6e, $22
    sprite_oam_piece $07, $08, $6d, $22
    sprite_oam_piece $07, $10, $6c, $22
    sprite_oam_piece $ff, $e8, $65, $22
    sprite_oam_piece $ff, $f0, $64, $22
    sprite_oam_piece $ff, $f8, $63, $22
    sprite_oam_piece $ff, $00, $62, $22
    sprite_oam_piece $ff, $08, $61, $22
    sprite_oam_piece $ff, $10, $60, $22
    sprite_oam_piece $f7, $e8, $7a, $22
    sprite_oam_piece $f7, $f0, $79, $22
    sprite_oam_piece $f7, $f8, $5f, $22
    sprite_oam_piece $f7, $00, $5e, $22
    sprite_oam_piece $f7, $08, $5d, $22
    sprite_oam_piece $f7, $10, $5c, $22
    sprite_oam_piece $ef, $e8, $5b, $22
    sprite_oam_piece $ef, $f0, $5a, $22
    sprite_oam_piece $ef, $f8, $59, $22
    sprite_oam_piece $ef, $00, $58, $22
    sprite_oam_piece $ef, $08, $57, $22
    sprite_oam_piece $ef, $10, $56, $22

SpriteFrame_1F_5343::
    db 24
    sprite_oam_piece $06, $e8, $77, $22
    sprite_oam_piece $06, $f0, $76, $22
    sprite_oam_piece $06, $f8, $75, $22
    sprite_oam_piece $06, $00, $74, $22
    sprite_oam_piece $06, $08, $73, $22
    sprite_oam_piece $06, $10, $72, $22
    sprite_oam_piece $fe, $e8, $65, $22
    sprite_oam_piece $fe, $f0, $64, $22
    sprite_oam_piece $fe, $f8, $63, $22
    sprite_oam_piece $fe, $00, $62, $22
    sprite_oam_piece $fe, $08, $61, $22
    sprite_oam_piece $fe, $10, $60, $22
    sprite_oam_piece $f6, $e8, $7a, $22
    sprite_oam_piece $f6, $f0, $79, $22
    sprite_oam_piece $f6, $f8, $5f, $22
    sprite_oam_piece $f6, $00, $5e, $22
    sprite_oam_piece $f6, $08, $5d, $22
    sprite_oam_piece $f6, $10, $5c, $22
    sprite_oam_piece $ee, $e8, $5b, $22
    sprite_oam_piece $ee, $f0, $5a, $22
    sprite_oam_piece $ee, $f8, $59, $22
    sprite_oam_piece $ee, $00, $58, $22
    sprite_oam_piece $ee, $08, $57, $22
    sprite_oam_piece $ee, $10, $56, $22

SpriteAnimation_136:: ; $1F:$53A4
    sprite_anim_entry SpriteFrame_1F_4E61, $0a
    sprite_anim_entry SpriteFrame_1F_4EAE, $0a
    sprite_anim_entry SpriteFrame_1F_4EFB, $0a
    sprite_anim_entry SpriteFrame_1F_4EAE, $0a
    sprite_anim_end

SpriteAnimation_134:: ; $1F:$53B2
    sprite_anim_entry SpriteFrame_1F_4D7A, $0a
    sprite_anim_entry SpriteFrame_1F_4DC7, $0a
    sprite_anim_entry SpriteFrame_1F_4E14, $0a
    sprite_anim_entry SpriteFrame_1F_4DC7, $0a
    sprite_anim_end

SpriteAnimation_132:: ; $1F:$53C0
    sprite_anim_entry SpriteFrame_1F_4CCF, $0a
    sprite_anim_entry SpriteFrame_1F_4D08, $0a
    sprite_anim_entry SpriteFrame_1F_4D41, $0a
    sprite_anim_entry SpriteFrame_1F_4D08, $0a
    sprite_anim_end

SpriteAnimation_130:: ; $1F:$53CE
    sprite_anim_entry SpriteFrame_1F_4C24, $0a
    sprite_anim_entry SpriteFrame_1F_4C5D, $0a
    sprite_anim_entry SpriteFrame_1F_4C96, $0a
    sprite_anim_entry SpriteFrame_1F_4C5D, $0a
    sprite_anim_end

SpriteAnimation_138:: ; $1F:$53DC
    sprite_anim_entry SpriteFrame_1F_4F48, $0a
    sprite_anim_entry SpriteFrame_1F_4FA1, $0a
    sprite_anim_entry SpriteFrame_1F_4FFA, $0a
    sprite_anim_entry SpriteFrame_1F_4FA1, $0a
    sprite_anim_end

SpriteAnimation_140:: ; $1F:$53EA
    sprite_anim_entry SpriteFrame_1F_5053, $0a
    sprite_anim_entry SpriteFrame_1F_50AC, $0a
    sprite_anim_entry SpriteFrame_1F_5105, $0a
    sprite_anim_entry SpriteFrame_1F_50AC, $0a
    sprite_anim_end

SpriteAnimation_142:: ; $1F:$53F8
    sprite_anim_entry SpriteFrame_1F_515E, $0a
    sprite_anim_entry SpriteFrame_1F_51BF, $0a
    sprite_anim_entry SpriteFrame_1F_5220, $0a
    sprite_anim_entry SpriteFrame_1F_51BF, $0a
    sprite_anim_end

SpriteAnimation_144:: ; $1F:$5406
    sprite_anim_entry SpriteFrame_1F_5281, $0a
    sprite_anim_entry SpriteFrame_1F_52E2, $0a
    sprite_anim_entry SpriteFrame_1F_5343, $0a
    sprite_anim_entry SpriteFrame_1F_52E2, $0a
    sprite_anim_end

SpriteAnimation_131:: ; $1F:$5414
    sprite_anim_entry SpriteFrame_1F_4C5D, $ff
    sprite_anim_end

SpriteAnimation_133:: ; $1F:$5419
    sprite_anim_entry SpriteFrame_1F_4D08, $ff
    sprite_anim_end

SpriteAnimation_135:: ; $1F:$541E
    sprite_anim_entry SpriteFrame_1F_4DC7, $ff
    sprite_anim_end

SpriteAnimation_137:: ; $1F:$5423
    sprite_anim_entry SpriteFrame_1F_4EAE, $ff
    sprite_anim_end

SpriteAnimation_139:: ; $1F:$5428
    sprite_anim_entry SpriteFrame_1F_4FA1, $ff
    sprite_anim_end

SpriteAnimation_141:: ; $1F:$542D
    sprite_anim_entry SpriteFrame_1F_50AC, $ff
    sprite_anim_end

SpriteAnimation_143:: ; $1F:$5432
    sprite_anim_entry SpriteFrame_1F_51BF, $ff
    sprite_anim_end

SpriteAnimation_145:: ; $1F:$5437
    sprite_anim_entry SpriteFrame_1F_52E2, $ff
    sprite_anim_end

assert @ == $543c

section "Sprite Animation Data 1F:5C4C", romx[$5c4c], bank[$1f]

SpriteFrame_1F_5C4C::
    db 6
    sprite_oam_piece $04, $00, $06, $02
    sprite_oam_piece $04, $f8, $05, $04
    sprite_oam_piece $fc, $00, $04, $02
    sprite_oam_piece $fc, $f8, $03, $03
    sprite_oam_piece $f4, $00, $02, $02
    sprite_oam_piece $f4, $f8, $01, $02

SpriteFrame_1F_5C65::
    db 6
    sprite_oam_piece $03, $00, $0c, $02
    sprite_oam_piece $03, $f8, $0b, $02
    sprite_oam_piece $fb, $00, $0a, $02
    sprite_oam_piece $fb, $f8, $09, $03
    sprite_oam_piece $f3, $00, $08, $02
    sprite_oam_piece $f3, $f8, $07, $02

SpriteFrame_1F_5C7E::
    db 6
    sprite_oam_piece $04, $00, $12, $02
    sprite_oam_piece $04, $f8, $11, $02
    sprite_oam_piece $fc, $00, $10, $02
    sprite_oam_piece $fc, $f8, $0f, $03
    sprite_oam_piece $f4, $00, $0e, $02
    sprite_oam_piece $f4, $f8, $0d, $02

SpriteFrame_1F_5C97::
    db 6
    sprite_oam_piece $04, $f8, $06, $22
    sprite_oam_piece $04, $00, $05, $24
    sprite_oam_piece $fc, $f8, $04, $22
    sprite_oam_piece $fc, $00, $03, $23
    sprite_oam_piece $f4, $f8, $02, $22
    sprite_oam_piece $f4, $00, $01, $22

SpriteFrame_1F_5CB0::
    db 6
    sprite_oam_piece $03, $f8, $0c, $22
    sprite_oam_piece $03, $00, $0b, $22
    sprite_oam_piece $fb, $f8, $0a, $22
    sprite_oam_piece $fb, $00, $09, $23
    sprite_oam_piece $f3, $f8, $08, $22
    sprite_oam_piece $f3, $00, $07, $22

SpriteFrame_1F_5CC9::
    db 6
    sprite_oam_piece $04, $f8, $12, $22
    sprite_oam_piece $04, $00, $11, $22
    sprite_oam_piece $fc, $f8, $10, $22
    sprite_oam_piece $fc, $00, $0f, $23
    sprite_oam_piece $f4, $f8, $0e, $22
    sprite_oam_piece $f4, $00, $0d, $22

SpriteFrame_1F_5CE2::
    db 7
    sprite_oam_piece $03, $fd, $67, $06
    sprite_oam_piece $03, $00, $3d, $02
    sprite_oam_piece $03, $f8, $3c, $02
    sprite_oam_piece $fb, $00, $3b, $02
    sprite_oam_piece $fb, $f8, $3a, $03
    sprite_oam_piece $f3, $00, $39, $02
    sprite_oam_piece $f3, $f8, $38, $02

SpriteFrame_1F_5CFF::
    db 6
    sprite_oam_piece $03, $00, $67, $06
    sprite_oam_piece $03, $fd, $37, $02
    sprite_oam_piece $fb, $00, $36, $02
    sprite_oam_piece $fb, $f8, $35, $03
    sprite_oam_piece $f3, $00, $34, $02
    sprite_oam_piece $f3, $f8, $33, $02

SpriteFrame_1F_5D18::
    db 7
    sprite_oam_piece $02, $fd, $68, $06
    sprite_oam_piece $03, $00, $32, $02
    sprite_oam_piece $03, $f8, $31, $02
    sprite_oam_piece $fb, $00, $30, $02
    sprite_oam_piece $fb, $f8, $2f, $03
    sprite_oam_piece $f3, $00, $2e, $02
    sprite_oam_piece $f3, $f8, $2d, $02

SpriteFrame_1F_5D35::
    db 7
    sprite_oam_piece $03, $fb, $67, $26
    sprite_oam_piece $03, $f8, $3d, $22
    sprite_oam_piece $03, $00, $3c, $22
    sprite_oam_piece $fb, $f8, $3b, $22
    sprite_oam_piece $fb, $00, $3a, $23
    sprite_oam_piece $f3, $f8, $39, $22
    sprite_oam_piece $f3, $00, $38, $22

SpriteFrame_1F_5D52::
    db 6
    sprite_oam_piece $03, $f8, $67, $26
    sprite_oam_piece $03, $fb, $37, $22
    sprite_oam_piece $fb, $f8, $36, $22
    sprite_oam_piece $fb, $00, $35, $23
    sprite_oam_piece $f3, $f8, $34, $22
    sprite_oam_piece $f3, $00, $33, $22

SpriteFrame_1F_5D6B::
    db 7
    sprite_oam_piece $02, $fb, $68, $26
    sprite_oam_piece $03, $f8, $32, $22
    sprite_oam_piece $03, $00, $31, $22
    sprite_oam_piece $fb, $f8, $30, $22
    sprite_oam_piece $fb, $00, $2f, $23
    sprite_oam_piece $f3, $f8, $2e, $22
    sprite_oam_piece $f3, $00, $2d, $22

SpriteFrame_1F_5D88::
    db 8
    sprite_oam_piece $05, $00, $1a, $02
    sprite_oam_piece $05, $f8, $19, $02
    sprite_oam_piece $fd, $05, $18, $06
    sprite_oam_piece $fd, $fd, $17, $03
    sprite_oam_piece $fd, $f5, $16, $02
    sprite_oam_piece $f5, $05, $15, $06
    sprite_oam_piece $f5, $fd, $14, $02
    sprite_oam_piece $f5, $f5, $13, $02

SpriteFrame_1F_5DA9::
    db 7
    sprite_oam_piece $04, $f9, $22, $02
    sprite_oam_piece $fc, $04, $21, $06
    sprite_oam_piece $fc, $fc, $20, $03
    sprite_oam_piece $fc, $f4, $1f, $02
    sprite_oam_piece $f4, $04, $1e, $06
    sprite_oam_piece $f4, $fc, $1d, $02
    sprite_oam_piece $f4, $f4, $1c, $02

SpriteFrame_1F_5DC6::
    db 8
    sprite_oam_piece $fd, $fc, $27, $03
    sprite_oam_piece $05, $04, $2b, $06
    sprite_oam_piece $05, $fc, $2a, $02
    sprite_oam_piece $05, $f4, $29, $02
    sprite_oam_piece $fd, $04, $28, $06
    sprite_oam_piece $fd, $f4, $26, $02
    sprite_oam_piece $f5, $fc, $25, $02
    sprite_oam_piece $f5, $f4, $24, $02

SpriteFrame_1F_5DE7::
    db 7
    sprite_oam_piece $03, $f6, $52, $02
    sprite_oam_piece $fb, $fa, $51, $03
    sprite_oam_piece $fb, $f2, $50, $02
    sprite_oam_piece $fb, $ea, $4f, $02
    sprite_oam_piece $f3, $fa, $4e, $02
    sprite_oam_piece $f3, $f2, $4d, $02
    sprite_oam_piece $f3, $ea, $4c, $02

SpriteFrame_1F_5E04::
    db 8
    sprite_oam_piece $03, $fc, $5a, $02
    sprite_oam_piece $03, $f4, $59, $02
    sprite_oam_piece $fb, $04, $58, $02
    sprite_oam_piece $fb, $fc, $57, $03
    sprite_oam_piece $fb, $f4, $56, $02
    sprite_oam_piece $f3, $04, $55, $02
    sprite_oam_piece $f3, $fc, $54, $02
    sprite_oam_piece $f3, $f4, $53, $02

SpriteFrame_1F_5E25::
    db 8
    sprite_oam_piece $02, $06, $4b, $02
    sprite_oam_piece $02, $fe, $4a, $03
    sprite_oam_piece $02, $f6, $49, $02
    sprite_oam_piece $fa, $06, $48, $02
    sprite_oam_piece $fa, $fe, $47, $03
    sprite_oam_piece $fa, $f6, $46, $02
    sprite_oam_piece $f2, $fe, $45, $02
    sprite_oam_piece $f2, $f6, $44, $02

SpriteFrame_1F_5E46::
    db 6
    sprite_oam_piece $05, $00, $43, $02
    sprite_oam_piece $05, $f8, $42, $02
    sprite_oam_piece $fd, $00, $41, $03
    sprite_oam_piece $fd, $f8, $40, $02
    sprite_oam_piece $f5, $00, $3f, $02
    sprite_oam_piece $f5, $f8, $3e, $02

SpriteFrame_1F_5E5F::
    db 8
    sprite_oam_piece $03, $05, $62, $06
    sprite_oam_piece $f9, $fa, $61, $06
    sprite_oam_piece $04, $00, $60, $02
    sprite_oam_piece $04, $f8, $5f, $02
    sprite_oam_piece $fc, $00, $5e, $02
    sprite_oam_piece $fc, $f8, $5d, $02
    sprite_oam_piece $f4, $00, $5c, $02
    sprite_oam_piece $f4, $f8, $5b, $02

SpriteFrame_1F_5E80::
    db 8
    sprite_oam_piece $03, $f3, $62, $26
    sprite_oam_piece $f9, $fe, $61, $26
    sprite_oam_piece $04, $f8, $60, $22
    sprite_oam_piece $04, $00, $5f, $22
    sprite_oam_piece $fc, $f8, $5e, $22
    sprite_oam_piece $fc, $00, $5d, $22
    sprite_oam_piece $f4, $f8, $5c, $22
    sprite_oam_piece $f4, $00, $5b, $22

SpriteAnimation_SoldierHardWork::
SpriteAnimation_146:: ; $1F:$5EA1
    sprite_anim_entry SpriteFrame_1F_5DE7, $0b
    sprite_anim_entry SpriteFrame_1F_5E04, $09
    sprite_anim_entry SpriteFrame_1F_5E25, $0d
    sprite_anim_entry SpriteFrame_1F_5E04, $07
    sprite_anim_end

SpriteAnimation_SoldierRunLeft::
SpriteAnimation_147:: ; $1F:$5EAF
    sprite_anim_entry SpriteFrame_1F_5C4C, $0a
    sprite_anim_entry SpriteFrame_1F_5C65, $0a
    sprite_anim_entry SpriteFrame_1F_5C7E, $0a
    sprite_anim_entry SpriteFrame_1F_5C65, $0a
    sprite_anim_end

SpriteAnimation_148:: ; $1F:$5EBD
    sprite_anim_entry SpriteFrame_1F_5D88, $0f
    sprite_anim_entry SpriteFrame_1F_5DA9, $0d
    sprite_anim_entry SpriteFrame_1F_5DC6, $11
    sprite_anim_entry SpriteFrame_1F_5DA9, $0f
    sprite_anim_end

SpriteAnimation_149:: ; $1F:$5ECB
    sprite_anim_entry SpriteFrame_1F_5CE2, $0c
    sprite_anim_entry SpriteFrame_1F_5CFF, $0c
    sprite_anim_entry SpriteFrame_1F_5D18, $0c
    sprite_anim_entry SpriteFrame_1F_5CFF, $0c
    sprite_anim_end

SpriteAnimation_150:: ; $1F:$5ED9
    sprite_anim_entry SpriteFrame_1F_5E46, $ff
    sprite_anim_end

SpriteAnimation_151:: ; $1F:$5EDE
    sprite_anim_entry SpriteFrame_1F_5DA9, $ff
    sprite_anim_end

SpriteAnimation_SoldierRunRight::
SpriteAnimation_152:: ; $1F:$5EE3
    sprite_anim_entry SpriteFrame_1F_5C97, $0a
    sprite_anim_entry SpriteFrame_1F_5CB0, $0a
    sprite_anim_entry SpriteFrame_1F_5CC9, $0a
    sprite_anim_entry SpriteFrame_1F_5CB0, $0a
    sprite_anim_end

SpriteAnimation_153:: ; $1F:$5EF1
    sprite_anim_entry SpriteFrame_1F_5D35, $0a
    sprite_anim_entry SpriteFrame_1F_5D52, $0a
    sprite_anim_entry SpriteFrame_1F_5D6B, $0a
    sprite_anim_entry SpriteFrame_1F_5D52, $0a
    sprite_anim_end

SpriteAnimation_SoldierVictoryLeft::
SpriteAnimation_154:: ; $1F:$5EFF
    sprite_anim_entry SpriteFrame_1F_5E5F, $ff
    sprite_anim_end

SpriteAnimation_155:: ; $1F:$5F04
    sprite_anim_entry SpriteFrame_1F_5E80, $ff
    sprite_anim_end

SpriteAnimation_156:: ; $1F:$5F09
    sprite_anim_entry SpriteFrame_1F_5DA9, $ff
    sprite_anim_end

SpriteAnimation_157:: ; $1F:$5F0E
    sprite_anim_entry SpriteFrame_1F_5CFF, $ff
    sprite_anim_end

SpriteAnimation_158:: ; $1F:$5F13
    sprite_anim_entry SpriteFrame_1F_5D52, $ff
    sprite_anim_end

assert @ == $5f18

section "Sprite Animation Data 1F:6602", romx[$6602], bank[$1f]

SpriteFrame_1F_6602::
    db 25
    sprite_oam_piece $fc, $ec, $45, $01
    sprite_oam_piece $fc, $18, $14, $02
    sprite_oam_piece $fc, $10, $13, $02
    sprite_oam_piece $fc, $08, $12, $02
    sprite_oam_piece $fc, $00, $12, $02
    sprite_oam_piece $fc, $f8, $11, $02
    sprite_oam_piece $fc, $f0, $10, $02
    sprite_oam_piece $fc, $e8, $0f, $02
    sprite_oam_piece $fc, $e0, $0e, $02
    sprite_oam_piece $f4, $18, $0d, $02
    sprite_oam_piece $f4, $10, $0c, $02
    sprite_oam_piece $f4, $08, $0b, $02
    sprite_oam_piece $f4, $00, $0b, $02
    sprite_oam_piece $f4, $f8, $0a, $02
    sprite_oam_piece $f4, $f0, $09, $02
    sprite_oam_piece $f4, $e8, $08, $02
    sprite_oam_piece $f4, $e0, $07, $02
    sprite_oam_piece $ec, $10, $06, $02
    sprite_oam_piece $ec, $08, $05, $02
    sprite_oam_piece $ec, $00, $05, $02
    sprite_oam_piece $ec, $f8, $04, $02
    sprite_oam_piece $ec, $f0, $03, $02
    sprite_oam_piece $ec, $e8, $02, $02
    sprite_oam_piece $e4, $f0, $01, $02
    sprite_oam_piece $e4, $e8, $00, $02

SpriteFrame_1F_6667::
    db 26
    sprite_oam_piece $fc, $10, $44, $01
    sprite_oam_piece $fc, $e8, $46, $01
    sprite_oam_piece $fd, $18, $1b, $02
    sprite_oam_piece $fd, $10, $1a, $02
    sprite_oam_piece $fd, $08, $19, $02
    sprite_oam_piece $fd, $00, $19, $02
    sprite_oam_piece $fd, $f8, $18, $02
    sprite_oam_piece $fd, $f0, $17, $02
    sprite_oam_piece $fd, $e8, $16, $02
    sprite_oam_piece $fd, $e0, $15, $02
    sprite_oam_piece $f5, $18, $0d, $02
    sprite_oam_piece $f5, $10, $0c, $02
    sprite_oam_piece $f5, $08, $0b, $02
    sprite_oam_piece $f5, $00, $0b, $02
    sprite_oam_piece $f5, $f8, $0a, $02
    sprite_oam_piece $f5, $f0, $09, $02
    sprite_oam_piece $f5, $e8, $08, $02
    sprite_oam_piece $f5, $e0, $07, $02
    sprite_oam_piece $ed, $10, $06, $02
    sprite_oam_piece $ed, $08, $05, $02
    sprite_oam_piece $ed, $00, $05, $02
    sprite_oam_piece $ed, $f8, $04, $02
    sprite_oam_piece $ed, $f0, $03, $02
    sprite_oam_piece $ed, $e8, $02, $02
    sprite_oam_piece $e5, $f0, $01, $02
    sprite_oam_piece $e5, $e8, $00, $02

SpriteFrame_1F_66D0::
    db 25
    sprite_oam_piece $fc, $0c, $45, $01
    sprite_oam_piece $fe, $18, $22, $02
    sprite_oam_piece $fe, $10, $21, $02
    sprite_oam_piece $fe, $08, $20, $02
    sprite_oam_piece $fe, $00, $20, $02
    sprite_oam_piece $fe, $f8, $1f, $02
    sprite_oam_piece $fe, $f0, $1e, $02
    sprite_oam_piece $fe, $e8, $1d, $02
    sprite_oam_piece $fe, $e0, $1c, $02
    sprite_oam_piece $f6, $18, $0d, $02
    sprite_oam_piece $f6, $10, $0c, $02
    sprite_oam_piece $f6, $08, $0b, $02
    sprite_oam_piece $f6, $00, $0b, $02
    sprite_oam_piece $f6, $f8, $0a, $02
    sprite_oam_piece $f6, $f0, $09, $02
    sprite_oam_piece $f6, $e8, $08, $02
    sprite_oam_piece $f6, $e0, $07, $02
    sprite_oam_piece $ee, $10, $06, $02
    sprite_oam_piece $ee, $08, $05, $02
    sprite_oam_piece $ee, $00, $05, $02
    sprite_oam_piece $ee, $f8, $04, $02
    sprite_oam_piece $ee, $f0, $03, $02
    sprite_oam_piece $ee, $e8, $02, $02
    sprite_oam_piece $e6, $f0, $01, $02
    sprite_oam_piece $e6, $e8, $00, $02

SpriteFrame_1F_6735::
    db 26
    sprite_oam_piece $fc, $f0, $44, $01
    sprite_oam_piece $fc, $08, $46, $01
    sprite_oam_piece $fd, $18, $1b, $02
    sprite_oam_piece $fd, $10, $1a, $02
    sprite_oam_piece $fd, $08, $19, $02
    sprite_oam_piece $fd, $00, $19, $02
    sprite_oam_piece $fd, $f8, $18, $02
    sprite_oam_piece $fd, $f0, $17, $02
    sprite_oam_piece $fd, $e8, $16, $02
    sprite_oam_piece $fd, $e0, $15, $02
    sprite_oam_piece $f5, $18, $0d, $02
    sprite_oam_piece $f5, $10, $0c, $02
    sprite_oam_piece $f5, $08, $0b, $02
    sprite_oam_piece $f5, $00, $0b, $02
    sprite_oam_piece $f5, $f8, $0a, $02
    sprite_oam_piece $f5, $f0, $09, $02
    sprite_oam_piece $f5, $e8, $08, $02
    sprite_oam_piece $f5, $e0, $07, $02
    sprite_oam_piece $ed, $10, $06, $02
    sprite_oam_piece $ed, $08, $05, $02
    sprite_oam_piece $ed, $00, $05, $02
    sprite_oam_piece $ed, $f8, $04, $02
    sprite_oam_piece $ed, $f0, $03, $02
    sprite_oam_piece $ed, $e8, $02, $02
    sprite_oam_piece $e5, $f0, $01, $02
    sprite_oam_piece $e5, $e8, $00, $02

SpriteFrame_1F_679E::
    db 18
    sprite_oam_piece $fc, $f4, $45, $01
    sprite_oam_piece $fc, $18, $33, $02
    sprite_oam_piece $fc, $10, $32, $02
    sprite_oam_piece $fc, $08, $31, $02
    sprite_oam_piece $fc, $00, $30, $02
    sprite_oam_piece $fc, $f8, $2f, $02
    sprite_oam_piece $fc, $f0, $2e, $02
    sprite_oam_piece $fc, $e8, $2d, $02
    sprite_oam_piece $fc, $e0, $2c, $02
    sprite_oam_piece $f4, $18, $2b, $02
    sprite_oam_piece $f4, $10, $2a, $02
    sprite_oam_piece $f4, $08, $29, $02
    sprite_oam_piece $f4, $00, $28, $02
    sprite_oam_piece $f4, $f8, $27, $02
    sprite_oam_piece $f4, $f0, $26, $02
    sprite_oam_piece $f4, $e8, $25, $02
    sprite_oam_piece $f4, $e0, $24, $02
    sprite_oam_piece $ec, $0b, $23, $02

SpriteFrame_1F_67E7::
    db 19
    sprite_oam_piece $fc, $10, $44, $01
    sprite_oam_piece $fc, $f0, $46, $01
    sprite_oam_piece $fd, $18, $3b, $02
    sprite_oam_piece $fd, $10, $3a, $02
    sprite_oam_piece $fd, $08, $39, $02
    sprite_oam_piece $fd, $00, $38, $02
    sprite_oam_piece $fd, $f8, $37, $02
    sprite_oam_piece $fd, $f0, $36, $02
    sprite_oam_piece $fd, $e8, $35, $02
    sprite_oam_piece $fd, $e0, $34, $02
    sprite_oam_piece $f5, $18, $2b, $02
    sprite_oam_piece $f5, $10, $2a, $02
    sprite_oam_piece $f5, $08, $29, $02
    sprite_oam_piece $f5, $00, $28, $02
    sprite_oam_piece $f5, $f8, $27, $02
    sprite_oam_piece $f5, $f0, $26, $02
    sprite_oam_piece $f5, $e8, $25, $02
    sprite_oam_piece $f5, $e0, $24, $02
    sprite_oam_piece $ed, $0b, $23, $02

SpriteFrame_1F_6834::
    db 18
    sprite_oam_piece $fc, $0c, $45, $01
    sprite_oam_piece $fe, $18, $43, $02
    sprite_oam_piece $fe, $10, $42, $02
    sprite_oam_piece $fe, $08, $41, $02
    sprite_oam_piece $fe, $00, $40, $02
    sprite_oam_piece $fe, $f8, $3f, $02
    sprite_oam_piece $fe, $f0, $3e, $02
    sprite_oam_piece $fe, $e8, $3d, $02
    sprite_oam_piece $fe, $e0, $3c, $02
    sprite_oam_piece $f6, $18, $2b, $02
    sprite_oam_piece $f6, $10, $2a, $02
    sprite_oam_piece $f6, $08, $29, $02
    sprite_oam_piece $f6, $00, $28, $02
    sprite_oam_piece $f6, $f8, $27, $02
    sprite_oam_piece $f6, $f0, $26, $02
    sprite_oam_piece $f6, $e8, $25, $02
    sprite_oam_piece $f6, $e0, $24, $02
    sprite_oam_piece $ee, $0b, $23, $02

SpriteFrame_1F_687D::
    db 19
    sprite_oam_piece $fc, $f8, $44, $01
    sprite_oam_piece $fc, $08, $46, $01
    sprite_oam_piece $fd, $18, $3b, $02
    sprite_oam_piece $fd, $10, $3a, $02
    sprite_oam_piece $fd, $08, $39, $02
    sprite_oam_piece $fd, $00, $38, $02
    sprite_oam_piece $fd, $f8, $37, $02
    sprite_oam_piece $fd, $f0, $36, $02
    sprite_oam_piece $fd, $e8, $35, $02
    sprite_oam_piece $fd, $e0, $34, $02
    sprite_oam_piece $f5, $18, $2b, $02
    sprite_oam_piece $f5, $10, $2a, $02
    sprite_oam_piece $f5, $08, $29, $02
    sprite_oam_piece $f5, $00, $28, $02
    sprite_oam_piece $f5, $f8, $27, $02
    sprite_oam_piece $f5, $f0, $26, $02
    sprite_oam_piece $f5, $e8, $25, $02
    sprite_oam_piece $f5, $e0, $24, $02
    sprite_oam_piece $ed, $0b, $23, $02

SpriteAnimation_160:: ; $1F:$68CA
    sprite_anim_entry SpriteFrame_1F_6602, $0c
    sprite_anim_entry SpriteFrame_1F_6667, $0c
    sprite_anim_entry SpriteFrame_1F_66D0, $0c
    sprite_anim_entry SpriteFrame_1F_6735, $0c
    sprite_anim_end

SpriteAnimation_SubmarineDefault::
SpriteAnimation_161:: ; $1F:$68D8
    sprite_anim_entry SpriteFrame_1F_679E, $0c
    sprite_anim_entry SpriteFrame_1F_67E7, $0c
    sprite_anim_entry SpriteFrame_1F_6834, $0c
    sprite_anim_entry SpriteFrame_1F_687D, $0c
    sprite_anim_end

assert @ == $68e6

section "Sprite Animation Data 1F:6D9A", romx[$6d9a], bank[$1f]

SpriteFrame_1F_6D9A::
    db 18
    sprite_oam_piece $07, $f8, $11, $02
    sprite_oam_piece $07, $f0, $10, $02
    sprite_oam_piece $07, $e8, $0f, $02
    sprite_oam_piece $ff, $10, $0e, $02
    sprite_oam_piece $ff, $08, $0d, $02
    sprite_oam_piece $ff, $00, $0c, $02
    sprite_oam_piece $ff, $f8, $0b, $02
    sprite_oam_piece $ff, $f0, $0a, $02
    sprite_oam_piece $ff, $e8, $09, $02
    sprite_oam_piece $f7, $10, $08, $02
    sprite_oam_piece $f7, $08, $07, $05
    sprite_oam_piece $f7, $00, $06, $02
    sprite_oam_piece $f7, $f8, $05, $02
    sprite_oam_piece $f7, $f0, $04, $02
    sprite_oam_piece $f7, $e8, $03, $02
    sprite_oam_piece $ef, $f8, $02, $02
    sprite_oam_piece $ef, $f0, $01, $02
    sprite_oam_piece $ef, $e8, $00, $02

SpriteFrame_1F_6DE3::
    db 22
    sprite_oam_piece $07, $f8, $11, $02
    sprite_oam_piece $07, $f0, $10, $02
    sprite_oam_piece $07, $e8, $0f, $02
    sprite_oam_piece $ff, $10, $0e, $02
    sprite_oam_piece $ff, $08, $0d, $02
    sprite_oam_piece $ff, $00, $0c, $02
    sprite_oam_piece $ff, $f8, $0b, $02
    sprite_oam_piece $ff, $f0, $0a, $02
    sprite_oam_piece $ff, $e8, $09, $02
    sprite_oam_piece $f7, $10, $08, $02
    sprite_oam_piece $f7, $08, $07, $05
    sprite_oam_piece $f7, $00, $06, $02
    sprite_oam_piece $f7, $f8, $05, $02
    sprite_oam_piece $f7, $f0, $04, $02
    sprite_oam_piece $f7, $e8, $03, $02
    sprite_oam_piece $ef, $f8, $02, $02
    sprite_oam_piece $ef, $f0, $01, $02
    sprite_oam_piece $ef, $e8, $00, $02
    sprite_oam_piece $fe, $e5, $41, $07
    sprite_oam_piece $fe, $dd, $40, $07
    sprite_oam_piece $f6, $e5, $3f, $07
    sprite_oam_piece $f6, $dd, $3e, $07

SpriteFrame_1F_6E3C::
    db 22
    sprite_oam_piece $07, $f8, $11, $02
    sprite_oam_piece $07, $f0, $10, $02
    sprite_oam_piece $07, $e8, $0f, $02
    sprite_oam_piece $ff, $10, $0e, $02
    sprite_oam_piece $ff, $08, $0d, $02
    sprite_oam_piece $ff, $00, $0c, $02
    sprite_oam_piece $ff, $f8, $0b, $02
    sprite_oam_piece $ff, $f0, $0a, $02
    sprite_oam_piece $ff, $e8, $09, $02
    sprite_oam_piece $f7, $10, $08, $02
    sprite_oam_piece $f7, $08, $07, $05
    sprite_oam_piece $f7, $00, $06, $02
    sprite_oam_piece $f7, $f8, $05, $02
    sprite_oam_piece $f7, $f0, $04, $02
    sprite_oam_piece $f7, $e8, $03, $02
    sprite_oam_piece $ef, $f8, $02, $02
    sprite_oam_piece $ef, $f0, $01, $02
    sprite_oam_piece $ef, $e8, $00, $02
    sprite_oam_piece $fe, $e5, $45, $07
    sprite_oam_piece $fe, $dd, $44, $07
    sprite_oam_piece $f6, $e5, $43, $07
    sprite_oam_piece $f6, $dd, $42, $07

SpriteFrame_1F_6E95::
    db 15
    sprite_oam_piece $04, $08, $20, $02
    sprite_oam_piece $04, $00, $1f, $02
    sprite_oam_piece $04, $f8, $1e, $02
    sprite_oam_piece $04, $f0, $1d, $02
    sprite_oam_piece $fc, $10, $1c, $02
    sprite_oam_piece $fc, $08, $1b, $02
    sprite_oam_piece $fc, $00, $1a, $02
    sprite_oam_piece $fc, $f8, $19, $02
    sprite_oam_piece $fc, $f0, $18, $02
    sprite_oam_piece $fc, $e8, $17, $02
    sprite_oam_piece $f4, $08, $16, $02
    sprite_oam_piece $f4, $00, $15, $02
    sprite_oam_piece $f4, $f8, $14, $02
    sprite_oam_piece $f4, $f0, $13, $02
    sprite_oam_piece $f4, $e8, $12, $02

SpriteFrame_1F_6ED2::
    db 19
    sprite_oam_piece $04, $08, $20, $02
    sprite_oam_piece $04, $00, $1f, $02
    sprite_oam_piece $04, $f8, $1e, $02
    sprite_oam_piece $04, $f0, $1d, $02
    sprite_oam_piece $fc, $10, $1c, $02
    sprite_oam_piece $fc, $08, $1b, $02
    sprite_oam_piece $fc, $00, $1a, $02
    sprite_oam_piece $fc, $f8, $19, $02
    sprite_oam_piece $fc, $f0, $18, $02
    sprite_oam_piece $fc, $e8, $17, $02
    sprite_oam_piece $f4, $08, $16, $02
    sprite_oam_piece $f4, $00, $15, $02
    sprite_oam_piece $f4, $f8, $14, $02
    sprite_oam_piece $f4, $f0, $13, $02
    sprite_oam_piece $f4, $e8, $12, $02
    sprite_oam_piece $00, $e8, $41, $07
    sprite_oam_piece $00, $e0, $40, $07
    sprite_oam_piece $f8, $e8, $3f, $07
    sprite_oam_piece $f8, $e0, $3e, $07

SpriteFrame_1F_6F1F::
    db 19
    sprite_oam_piece $04, $08, $20, $02
    sprite_oam_piece $04, $00, $1f, $02
    sprite_oam_piece $04, $f8, $1e, $02
    sprite_oam_piece $04, $f0, $1d, $02
    sprite_oam_piece $fc, $10, $1c, $02
    sprite_oam_piece $fc, $08, $1b, $02
    sprite_oam_piece $fc, $00, $1a, $02
    sprite_oam_piece $fc, $f8, $19, $02
    sprite_oam_piece $fc, $f0, $18, $02
    sprite_oam_piece $fc, $e8, $17, $02
    sprite_oam_piece $f4, $08, $16, $02
    sprite_oam_piece $f4, $00, $15, $02
    sprite_oam_piece $f4, $f8, $14, $02
    sprite_oam_piece $f4, $f0, $13, $02
    sprite_oam_piece $f4, $e8, $12, $02
    sprite_oam_piece $00, $e8, $45, $07
    sprite_oam_piece $00, $e0, $44, $07
    sprite_oam_piece $f8, $e8, $43, $07
    sprite_oam_piece $f8, $e0, $42, $07

SpriteFrame_1F_6F6C::
    db 29
    sprite_oam_piece $10, $f4, $3d, $02
    sprite_oam_piece $10, $ec, $3c, $02
    sprite_oam_piece $10, $e4, $3b, $02
    sprite_oam_piece $08, $04, $3a, $02
    sprite_oam_piece $08, $fc, $39, $02
    sprite_oam_piece $08, $f4, $38, $02
    sprite_oam_piece $08, $ec, $37, $02
    sprite_oam_piece $08, $e4, $36, $02
    sprite_oam_piece $00, $14, $35, $02
    sprite_oam_piece $00, $0c, $34, $02
    sprite_oam_piece $00, $04, $33, $02
    sprite_oam_piece $00, $fc, $32, $02
    sprite_oam_piece $00, $f4, $31, $02
    sprite_oam_piece $00, $ec, $30, $02
    sprite_oam_piece $00, $e4, $2f, $02
    sprite_oam_piece $f8, $14, $2e, $02
    sprite_oam_piece $f8, $0c, $2d, $02
    sprite_oam_piece $f8, $04, $2c, $02
    sprite_oam_piece $f8, $fc, $2b, $02
    sprite_oam_piece $f8, $f4, $2a, $02
    sprite_oam_piece $f8, $ec, $29, $02
    sprite_oam_piece $f8, $e4, $28, $02
    sprite_oam_piece $f0, $04, $27, $02
    sprite_oam_piece $f0, $fc, $26, $02
    sprite_oam_piece $f0, $f4, $25, $02
    sprite_oam_piece $f0, $ec, $24, $02
    sprite_oam_piece $f0, $e4, $23, $02
    sprite_oam_piece $e8, $ec, $22, $02
    sprite_oam_piece $e8, $e4, $21, $02

SpriteFrame_1F_6FE1::
    db 35
    sprite_oam_piece $10, $f4, $3d, $02
    sprite_oam_piece $10, $ec, $3c, $02
    sprite_oam_piece $10, $e4, $3b, $02
    sprite_oam_piece $08, $04, $3a, $02
    sprite_oam_piece $08, $fc, $39, $02
    sprite_oam_piece $08, $f4, $38, $02
    sprite_oam_piece $08, $ec, $37, $02
    sprite_oam_piece $08, $e4, $36, $02
    sprite_oam_piece $00, $14, $35, $02
    sprite_oam_piece $00, $0c, $34, $02
    sprite_oam_piece $00, $04, $33, $02
    sprite_oam_piece $00, $fc, $32, $02
    sprite_oam_piece $00, $f4, $31, $02
    sprite_oam_piece $00, $ec, $30, $02
    sprite_oam_piece $00, $e4, $2f, $02
    sprite_oam_piece $f8, $14, $2e, $02
    sprite_oam_piece $f8, $0c, $2d, $02
    sprite_oam_piece $f8, $04, $2c, $02
    sprite_oam_piece $f8, $fc, $2b, $02
    sprite_oam_piece $f8, $f4, $2a, $02
    sprite_oam_piece $f8, $ec, $29, $02
    sprite_oam_piece $f8, $e4, $28, $02
    sprite_oam_piece $f0, $04, $27, $02
    sprite_oam_piece $f0, $fc, $26, $02
    sprite_oam_piece $f0, $f4, $25, $02
    sprite_oam_piece $f0, $ec, $24, $02
    sprite_oam_piece $f0, $e4, $23, $02
    sprite_oam_piece $e8, $ec, $22, $02
    sprite_oam_piece $e8, $e4, $21, $02
    sprite_oam_piece $04, $e4, $41, $07
    sprite_oam_piece $04, $dc, $40, $07
    sprite_oam_piece $f4, $e4, $3f, $07
    sprite_oam_piece $f4, $dc, $3e, $07
    sprite_oam_piece $fc, $e4, $47, $07
    sprite_oam_piece $fc, $dc, $46, $07

SpriteFrame_1F_706E::
    db 35
    sprite_oam_piece $10, $f4, $3d, $02
    sprite_oam_piece $10, $ec, $3c, $02
    sprite_oam_piece $10, $e4, $3b, $02
    sprite_oam_piece $08, $04, $3a, $02
    sprite_oam_piece $08, $fc, $39, $02
    sprite_oam_piece $08, $f4, $38, $02
    sprite_oam_piece $08, $ec, $37, $02
    sprite_oam_piece $08, $e4, $36, $02
    sprite_oam_piece $00, $14, $35, $02
    sprite_oam_piece $00, $0c, $34, $02
    sprite_oam_piece $00, $04, $33, $02
    sprite_oam_piece $00, $fc, $32, $02
    sprite_oam_piece $00, $f4, $31, $02
    sprite_oam_piece $00, $ec, $30, $02
    sprite_oam_piece $00, $e4, $2f, $02
    sprite_oam_piece $f8, $14, $2e, $02
    sprite_oam_piece $f8, $0c, $2d, $02
    sprite_oam_piece $f8, $04, $2c, $02
    sprite_oam_piece $f8, $fc, $2b, $02
    sprite_oam_piece $f8, $f4, $2a, $02
    sprite_oam_piece $f8, $ec, $29, $02
    sprite_oam_piece $f8, $e4, $28, $02
    sprite_oam_piece $f0, $04, $27, $02
    sprite_oam_piece $f0, $fc, $26, $02
    sprite_oam_piece $f0, $f4, $25, $02
    sprite_oam_piece $f0, $ec, $24, $02
    sprite_oam_piece $f0, $e4, $23, $02
    sprite_oam_piece $e8, $ec, $22, $02
    sprite_oam_piece $e8, $e4, $21, $02
    sprite_oam_piece $04, $e4, $45, $07
    sprite_oam_piece $04, $dc, $44, $07
    sprite_oam_piece $fc, $e4, $49, $07
    sprite_oam_piece $fc, $dc, $48, $07
    sprite_oam_piece $f4, $e4, $43, $07
    sprite_oam_piece $f4, $dc, $42, $07

SpriteAnimation_162:: ; $1F:$70FB
    sprite_anim_entry SpriteFrame_1F_6D9A, $02
    sprite_anim_entry SpriteFrame_1F_6DE3, $02
    sprite_anim_entry SpriteFrame_1F_6E3C, $02
    sprite_anim_end

SpriteAnimation_163:: ; $1F:$7106
    sprite_anim_entry SpriteFrame_1F_6E95, $02
    sprite_anim_entry SpriteFrame_1F_6ED2, $02
    sprite_anim_entry SpriteFrame_1F_6F1F, $02
    sprite_anim_end

SpriteAnimation_MercenaryBomberDefault::
SpriteAnimation_164:: ; $1F:$7111
    sprite_anim_entry SpriteFrame_1F_6F6C, $02
    sprite_anim_entry SpriteFrame_1F_6FE1, $02
    sprite_anim_entry SpriteFrame_1F_706E, $02
    sprite_anim_end

assert @ == $711c

section "Sprite Animation Data 20:4000", romx[$4000], bank[$20]

SpriteFrame_20_4000::
    db 4
    sprite_oam_piece $00, $00, $01, $60
    sprite_oam_piece $00, $f8, $01, $40
    sprite_oam_piece $f8, $00, $01, $20
    sprite_oam_piece $f8, $f8, $01, $00

SpriteFrame_20_4011::
    db 9
    sprite_oam_piece $04, $04, $02, $60
    sprite_oam_piece $04, $fc, $03, $40
    sprite_oam_piece $04, $f4, $02, $40
    sprite_oam_piece $fc, $04, $04, $20
    sprite_oam_piece $f4, $04, $02, $20
    sprite_oam_piece $fc, $fc, $05, $00
    sprite_oam_piece $fc, $f4, $04, $00
    sprite_oam_piece $f4, $fc, $03, $00
    sprite_oam_piece $f4, $f4, $02, $00

SpriteFrame_20_4036::
    db 8
    sprite_oam_piece $04, $04, $06, $60
    sprite_oam_piece $04, $fc, $07, $40
    sprite_oam_piece $04, $f4, $06, $40
    sprite_oam_piece $fc, $04, $08, $20
    sprite_oam_piece $f4, $04, $06, $20
    sprite_oam_piece $fc, $f4, $08, $00
    sprite_oam_piece $f4, $fc, $07, $00
    sprite_oam_piece $f4, $f4, $06, $00

SpriteAnimation_165:: ; $20:$4057
    sprite_anim_entry SpriteFrame_20_4000, $06
    sprite_anim_entry SpriteFrame_20_4011, $08
    sprite_anim_entry SpriteFrame_20_4036, $0a
    sprite_anim_end

assert @ == $4062

section "Sprite Animation Data 20:4132", romx[$4132], bank[$20]

SpriteFrame_20_4132::
    db 20
    sprite_oam_piece $00, $22, $13, $00
    sprite_oam_piece $00, $1a, $12, $00
    sprite_oam_piece $00, $12, $11, $00
    sprite_oam_piece $00, $0a, $10, $00
    sprite_oam_piece $00, $02, $0f, $00
    sprite_oam_piece $f8, $22, $0e, $00
    sprite_oam_piece $f8, $1a, $0d, $00
    sprite_oam_piece $f8, $12, $0c, $00
    sprite_oam_piece $f8, $0a, $0b, $00
    sprite_oam_piece $f8, $02, $0a, $00
    sprite_oam_piece $00, $f6, $09, $00
    sprite_oam_piece $00, $ee, $08, $00
    sprite_oam_piece $00, $e6, $07, $00
    sprite_oam_piece $00, $de, $06, $00
    sprite_oam_piece $00, $d6, $05, $00
    sprite_oam_piece $f8, $f6, $04, $00
    sprite_oam_piece $f8, $ee, $03, $00
    sprite_oam_piece $f8, $e6, $02, $00
    sprite_oam_piece $f8, $de, $01, $00
    sprite_oam_piece $f8, $d6, $00, $00

SpriteAnimation_166:: ; $20:$4183
    sprite_anim_entry SpriteFrame_20_4132, $02
    sprite_anim_end

assert @ == $4188

section "Sprite Animation Data 20:4308", romx[$4308], bank[$20]

SpriteFrame_20_4308::
    db 25
    sprite_oam_piece $0c, $0c, $18, $04
    sprite_oam_piece $0c, $04, $17, $04
    sprite_oam_piece $0c, $fc, $16, $04
    sprite_oam_piece $0c, $f4, $15, $04
    sprite_oam_piece $0c, $ec, $14, $04
    sprite_oam_piece $04, $0c, $13, $04
    sprite_oam_piece $04, $04, $12, $04
    sprite_oam_piece $04, $fc, $11, $04
    sprite_oam_piece $04, $f4, $10, $04
    sprite_oam_piece $04, $ec, $0f, $04
    sprite_oam_piece $fc, $0c, $0e, $02
    sprite_oam_piece $fc, $04, $0d, $02
    sprite_oam_piece $fc, $fc, $0c, $02
    sprite_oam_piece $fc, $f4, $0b, $02
    sprite_oam_piece $fc, $ec, $0a, $02
    sprite_oam_piece $f4, $0c, $09, $02
    sprite_oam_piece $f4, $04, $08, $02
    sprite_oam_piece $f4, $fc, $07, $02
    sprite_oam_piece $f4, $f4, $06, $02
    sprite_oam_piece $f4, $ec, $05, $02
    sprite_oam_piece $ec, $0c, $04, $05
    sprite_oam_piece $ec, $04, $03, $05
    sprite_oam_piece $ec, $fc, $02, $05
    sprite_oam_piece $ec, $f4, $01, $02
    sprite_oam_piece $ec, $ec, $00, $02

SpriteFrame_20_436D::
    db 1
    sprite_oam_piece $00, $14, $19, $04

SpriteFrame_20_4372::
    db 2
    sprite_oam_piece $f8, $14, $1b, $04
    sprite_oam_piece $00, $14, $1a, $04

SpriteFrame_20_437B::
    db 2
    sprite_oam_piece $f8, $14, $1d, $04
    sprite_oam_piece $00, $14, $1c, $04

SpriteFrame_20_4384::
    db 9
    sprite_oam_piece $00, $08, $25, $02
    sprite_oam_piece $00, $00, $24, $02
    sprite_oam_piece $00, $f8, $24, $02
    sprite_oam_piece $00, $f0, $23, $02
    sprite_oam_piece $f0, $04, $1e, $02
    sprite_oam_piece $f8, $08, $22, $02
    sprite_oam_piece $f8, $00, $21, $02
    sprite_oam_piece $f8, $f8, $20, $02
    sprite_oam_piece $f8, $f0, $1f, $02

SpriteFrame_20_43A9::
    db 9
    sprite_oam_piece $01, $08, $28, $02
    sprite_oam_piece $01, $00, $27, $02
    sprite_oam_piece $01, $f8, $27, $02
    sprite_oam_piece $01, $f0, $26, $02
    sprite_oam_piece $f1, $04, $1e, $02
    sprite_oam_piece $f9, $08, $22, $02
    sprite_oam_piece $f9, $00, $21, $02
    sprite_oam_piece $f9, $f8, $20, $02
    sprite_oam_piece $f9, $f0, $1f, $02

SpriteFrame_20_43CE::
    db 9
    sprite_oam_piece $02, $08, $2b, $02
    sprite_oam_piece $02, $00, $2a, $02
    sprite_oam_piece $02, $f8, $2a, $02
    sprite_oam_piece $02, $f0, $29, $02
    sprite_oam_piece $f2, $04, $1e, $02
    sprite_oam_piece $fa, $08, $22, $02
    sprite_oam_piece $fa, $00, $21, $02
    sprite_oam_piece $fa, $f8, $20, $02
    sprite_oam_piece $fa, $f0, $1f, $02

SpriteAnimation_167:: ; $20:$43F3
    sprite_anim_entry SpriteFrame_20_436D, $0a
    sprite_anim_entry SpriteFrame_20_4372, $0a
    sprite_anim_entry SpriteFrame_20_437B, $0a
    sprite_anim_entry SpriteFrame_20_437B, $ff
    sprite_anim_end

SpriteAnimation_168:: ; $20:$4401
    sprite_anim_entry SpriteFrame_20_436D, $02
    sprite_anim_end

SpriteAnimation_169:: ; $20:$4406
    sprite_anim_entry SpriteFrame_20_4384, $14
    sprite_anim_entry SpriteFrame_20_43A9, $14
    sprite_anim_entry SpriteFrame_20_43CE, $14
    sprite_anim_entry SpriteFrame_20_43A9, $14
    sprite_anim_end

SpriteAnimation_170:: ; $20:$4414
    sprite_anim_entry SpriteFrame_20_4308, $02
    sprite_anim_end

assert @ == $4419

section "Sprite Animation Data 20:4721", romx[$4721], bank[$20]

SpriteFrame_20_4721::
    db 2
    sprite_oam_piece $04, $fc, $01, $00
    sprite_oam_piece $fc, $fc, $00, $00

SpriteFrame_20_472A::
    db 2
    sprite_oam_piece $04, $fc, $01, $21
    sprite_oam_piece $fc, $fc, $00, $21

SpriteFrame_20_4733::
    db 4
    sprite_oam_piece $00, $00, $02, $60
    sprite_oam_piece $00, $f8, $02, $40
    sprite_oam_piece $f8, $00, $02, $20
    sprite_oam_piece $f8, $f8, $02, $00

SpriteFrame_20_4744::
    db 1
    sprite_oam_piece $fc, $fc, $03, $01

SpriteFrame_20_4749::
    db 4
    sprite_oam_piece $00, $00, $04, $60
    sprite_oam_piece $00, $f8, $04, $40
    sprite_oam_piece $f8, $00, $04, $20
    sprite_oam_piece $f8, $f8, $04, $00

SpriteFrame_20_475A::
    db 4
    sprite_oam_piece $00, $00, $05, $61
    sprite_oam_piece $00, $f8, $05, $41
    sprite_oam_piece $f8, $00, $05, $21
    sprite_oam_piece $f8, $f8, $05, $01

SpriteFrame_20_476B::
    db 12
    sprite_oam_piece $08, $00, $06, $60
    sprite_oam_piece $08, $f8, $06, $40
    sprite_oam_piece $00, $00, $08, $60
    sprite_oam_piece $00, $08, $07, $60
    sprite_oam_piece $00, $f8, $08, $40
    sprite_oam_piece $00, $f0, $07, $40
    sprite_oam_piece $f8, $00, $08, $20
    sprite_oam_piece $f8, $08, $07, $20
    sprite_oam_piece $f0, $00, $06, $20
    sprite_oam_piece $f8, $f8, $08, $00
    sprite_oam_piece $f8, $f0, $07, $00
    sprite_oam_piece $f0, $f8, $06, $00

SpriteFrame_20_479C::
    db 16
    sprite_oam_piece $08, $00, $0a, $61
    sprite_oam_piece $08, $08, $09, $61
    sprite_oam_piece $08, $f8, $0a, $41
    sprite_oam_piece $08, $f0, $09, $41
    sprite_oam_piece $00, $00, $0c, $61
    sprite_oam_piece $00, $08, $0b, $61
    sprite_oam_piece $00, $f8, $0c, $41
    sprite_oam_piece $00, $f0, $0b, $41
    sprite_oam_piece $f8, $00, $0c, $21
    sprite_oam_piece $f8, $08, $0b, $21
    sprite_oam_piece $f8, $f8, $0c, $01
    sprite_oam_piece $f8, $f0, $0b, $01
    sprite_oam_piece $f0, $00, $0a, $21
    sprite_oam_piece $f0, $08, $09, $21
    sprite_oam_piece $f0, $f8, $0a, $01
    sprite_oam_piece $f0, $f0, $09, $01

SpriteFrame_20_47DD::
    db 31
    sprite_oam_piece $e8, $00, $0e, $20
    sprite_oam_piece $e8, $08, $0d, $20
    sprite_oam_piece $10, $00, $0e, $60
    sprite_oam_piece $10, $08, $0d, $60
    sprite_oam_piece $10, $f8, $0e, $40
    sprite_oam_piece $10, $f0, $0d, $40
    sprite_oam_piece $08, $10, $0f, $60
    sprite_oam_piece $08, $e8, $0f, $40
    sprite_oam_piece $f0, $00, $11, $20
    sprite_oam_piece $f0, $08, $10, $20
    sprite_oam_piece $08, $00, $11, $60
    sprite_oam_piece $08, $08, $10, $60
    sprite_oam_piece $08, $f8, $11, $40
    sprite_oam_piece $08, $f0, $10, $40
    sprite_oam_piece $00, $00, $14, $60
    sprite_oam_piece $00, $08, $13, $60
    sprite_oam_piece $00, $10, $12, $60
    sprite_oam_piece $00, $f8, $14, $40
    sprite_oam_piece $00, $f0, $13, $40
    sprite_oam_piece $00, $e8, $12, $40
    sprite_oam_piece $f8, $00, $14, $20
    sprite_oam_piece $f8, $08, $13, $20
    sprite_oam_piece $f8, $10, $12, $20
    sprite_oam_piece $f8, $f8, $14, $00
    sprite_oam_piece $f8, $f0, $13, $00
    sprite_oam_piece $f8, $e8, $12, $00
    sprite_oam_piece $f0, $f8, $11, $00
    sprite_oam_piece $f0, $f0, $10, $00
    sprite_oam_piece $f0, $e8, $0f, $00
    sprite_oam_piece $e8, $f8, $0e, $00
    sprite_oam_piece $e8, $f0, $0d, $00

SpriteFrame_20_485A::
    db 32
    sprite_oam_piece $00, $00, $1c, $61
    sprite_oam_piece $00, $08, $1b, $61
    sprite_oam_piece $00, $10, $1a, $61
    sprite_oam_piece $00, $f8, $1c, $41
    sprite_oam_piece $00, $f0, $1b, $41
    sprite_oam_piece $00, $e8, $1a, $41
    sprite_oam_piece $f8, $00, $1c, $21
    sprite_oam_piece $f8, $08, $1b, $21
    sprite_oam_piece $f8, $10, $1a, $21
    sprite_oam_piece $f8, $f8, $1c, $01
    sprite_oam_piece $f8, $f0, $1b, $01
    sprite_oam_piece $f8, $e8, $1a, $01
    sprite_oam_piece $f0, $00, $19, $21
    sprite_oam_piece $f0, $08, $18, $21
    sprite_oam_piece $f0, $10, $17, $21
    sprite_oam_piece $08, $00, $19, $61
    sprite_oam_piece $08, $08, $18, $61
    sprite_oam_piece $08, $10, $17, $61
    sprite_oam_piece $08, $f8, $19, $41
    sprite_oam_piece $08, $f0, $18, $41
    sprite_oam_piece $08, $e8, $17, $41
    sprite_oam_piece $f0, $f8, $19, $01
    sprite_oam_piece $f0, $f0, $18, $01
    sprite_oam_piece $f0, $e8, $17, $01
    sprite_oam_piece $10, $f8, $16, $41
    sprite_oam_piece $10, $f0, $15, $41
    sprite_oam_piece $10, $00, $16, $61
    sprite_oam_piece $10, $08, $15, $61
    sprite_oam_piece $e8, $00, $16, $21
    sprite_oam_piece $e8, $08, $15, $21
    sprite_oam_piece $e8, $f8, $16, $01
    sprite_oam_piece $e8, $f0, $15, $01

SpriteFrame_20_48DB::
    db 32
    sprite_oam_piece $00, $00, $24, $60
    sprite_oam_piece $00, $08, $23, $60
    sprite_oam_piece $00, $10, $22, $60
    sprite_oam_piece $00, $f8, $24, $40
    sprite_oam_piece $00, $f0, $23, $40
    sprite_oam_piece $00, $e8, $22, $40
    sprite_oam_piece $f8, $00, $24, $20
    sprite_oam_piece $f8, $08, $23, $20
    sprite_oam_piece $f8, $10, $22, $20
    sprite_oam_piece $f8, $f8, $24, $00
    sprite_oam_piece $f8, $f0, $23, $00
    sprite_oam_piece $f8, $e8, $22, $00
    sprite_oam_piece $08, $00, $21, $60
    sprite_oam_piece $08, $08, $20, $60
    sprite_oam_piece $08, $f8, $21, $40
    sprite_oam_piece $08, $f0, $20, $40
    sprite_oam_piece $f0, $f8, $21, $00
    sprite_oam_piece $f0, $f0, $20, $00
    sprite_oam_piece $f0, $00, $21, $20
    sprite_oam_piece $f0, $08, $20, $20
    sprite_oam_piece $f0, $10, $1f, $20
    sprite_oam_piece $08, $10, $1f, $60
    sprite_oam_piece $08, $e8, $1f, $40
    sprite_oam_piece $f0, $e8, $1f, $00
    sprite_oam_piece $10, $00, $1e, $60
    sprite_oam_piece $10, $08, $1d, $60
    sprite_oam_piece $10, $f8, $1e, $40
    sprite_oam_piece $10, $f0, $1d, $40
    sprite_oam_piece $e8, $00, $1e, $20
    sprite_oam_piece $e8, $08, $1d, $20
    sprite_oam_piece $e8, $f8, $1e, $00
    sprite_oam_piece $e8, $f0, $1d, $00

SpriteFrame_20_495C::
    db 32
    sprite_oam_piece $00, $00, $2c, $60
    sprite_oam_piece $00, $08, $2b, $60
    sprite_oam_piece $00, $10, $2a, $60
    sprite_oam_piece $00, $f8, $2c, $40
    sprite_oam_piece $00, $f0, $2b, $40
    sprite_oam_piece $00, $e8, $2a, $40
    sprite_oam_piece $f8, $00, $2c, $20
    sprite_oam_piece $f8, $08, $2b, $20
    sprite_oam_piece $f8, $10, $2a, $20
    sprite_oam_piece $f8, $f8, $2c, $00
    sprite_oam_piece $f8, $f0, $2b, $00
    sprite_oam_piece $f8, $e8, $2a, $00
    sprite_oam_piece $08, $00, $29, $60
    sprite_oam_piece $08, $08, $28, $60
    sprite_oam_piece $08, $10, $27, $60
    sprite_oam_piece $08, $f8, $29, $40
    sprite_oam_piece $08, $f0, $28, $40
    sprite_oam_piece $08, $e8, $27, $40
    sprite_oam_piece $f0, $00, $29, $20
    sprite_oam_piece $f0, $08, $28, $20
    sprite_oam_piece $f0, $10, $27, $20
    sprite_oam_piece $f0, $f8, $29, $00
    sprite_oam_piece $f0, $f0, $28, $00
    sprite_oam_piece $f0, $e8, $27, $00
    sprite_oam_piece $10, $00, $26, $60
    sprite_oam_piece $10, $08, $25, $60
    sprite_oam_piece $10, $f8, $26, $40
    sprite_oam_piece $10, $f0, $25, $40
    sprite_oam_piece $e8, $00, $26, $20
    sprite_oam_piece $e8, $08, $25, $20
    sprite_oam_piece $e8, $f8, $26, $00
    sprite_oam_piece $e8, $f0, $25, $00

SpriteFrame_20_49DD::
    db 2
    sprite_oam_piece $04, $fc, $01, $02
    sprite_oam_piece $fc, $fc, $00, $02

SpriteFrame_20_49E6::
    db 2
    sprite_oam_piece $04, $fc, $01, $23
    sprite_oam_piece $fc, $fc, $00, $23

SpriteFrame_20_49EF::
    db 4
    sprite_oam_piece $00, $00, $02, $62
    sprite_oam_piece $00, $f8, $02, $42
    sprite_oam_piece $f8, $00, $02, $22
    sprite_oam_piece $f8, $f8, $02, $02

SpriteFrame_20_4A00::
    db 1
    sprite_oam_piece $fc, $fc, $03, $03

SpriteFrame_20_4A05::
    db 4
    sprite_oam_piece $00, $00, $04, $62
    sprite_oam_piece $00, $f8, $04, $42
    sprite_oam_piece $f8, $00, $04, $22
    sprite_oam_piece $f8, $f8, $04, $02

SpriteFrame_20_4A16::
    db 4
    sprite_oam_piece $00, $00, $05, $63
    sprite_oam_piece $00, $f8, $05, $43
    sprite_oam_piece $f8, $00, $05, $23
    sprite_oam_piece $f8, $f8, $05, $03

SpriteFrame_20_4A27::
    db 12
    sprite_oam_piece $08, $00, $06, $62
    sprite_oam_piece $08, $f8, $06, $42
    sprite_oam_piece $00, $00, $08, $62
    sprite_oam_piece $00, $08, $07, $62
    sprite_oam_piece $00, $f8, $08, $42
    sprite_oam_piece $00, $f0, $07, $42
    sprite_oam_piece $f8, $00, $08, $22
    sprite_oam_piece $f8, $08, $07, $22
    sprite_oam_piece $f0, $00, $06, $22
    sprite_oam_piece $f8, $f8, $08, $02
    sprite_oam_piece $f8, $f0, $07, $02
    sprite_oam_piece $f0, $f8, $06, $02

SpriteFrame_20_4A58::
    db 16
    sprite_oam_piece $08, $00, $0a, $63
    sprite_oam_piece $08, $08, $09, $63
    sprite_oam_piece $08, $f8, $0a, $43
    sprite_oam_piece $08, $f0, $09, $43
    sprite_oam_piece $00, $00, $0c, $63
    sprite_oam_piece $00, $08, $0b, $63
    sprite_oam_piece $00, $f8, $0c, $43
    sprite_oam_piece $00, $f0, $0b, $43
    sprite_oam_piece $f8, $00, $0c, $23
    sprite_oam_piece $f8, $08, $0b, $23
    sprite_oam_piece $f8, $f8, $0c, $03
    sprite_oam_piece $f8, $f0, $0b, $03
    sprite_oam_piece $f0, $00, $0a, $23
    sprite_oam_piece $f0, $08, $09, $23
    sprite_oam_piece $f0, $f8, $0a, $03
    sprite_oam_piece $f0, $f0, $09, $03

SpriteFrame_20_4A99::
    db 31
    sprite_oam_piece $e8, $00, $0e, $22
    sprite_oam_piece $e8, $08, $0d, $22
    sprite_oam_piece $10, $00, $0e, $62
    sprite_oam_piece $10, $08, $0d, $62
    sprite_oam_piece $10, $f8, $0e, $42
    sprite_oam_piece $10, $f0, $0d, $42
    sprite_oam_piece $08, $10, $0f, $62
    sprite_oam_piece $08, $e8, $0f, $42
    sprite_oam_piece $f0, $00, $11, $22
    sprite_oam_piece $f0, $08, $10, $22
    sprite_oam_piece $08, $00, $11, $62
    sprite_oam_piece $08, $08, $10, $62
    sprite_oam_piece $08, $f8, $11, $42
    sprite_oam_piece $08, $f0, $10, $42
    sprite_oam_piece $00, $00, $14, $62
    sprite_oam_piece $00, $08, $13, $62
    sprite_oam_piece $00, $10, $12, $62
    sprite_oam_piece $00, $f8, $14, $42
    sprite_oam_piece $00, $f0, $13, $42
    sprite_oam_piece $00, $e8, $12, $42
    sprite_oam_piece $f8, $00, $14, $22
    sprite_oam_piece $f8, $08, $13, $22
    sprite_oam_piece $f8, $10, $12, $22
    sprite_oam_piece $f8, $f8, $14, $02
    sprite_oam_piece $f8, $f0, $13, $02
    sprite_oam_piece $f8, $e8, $12, $02
    sprite_oam_piece $f0, $f8, $11, $02
    sprite_oam_piece $f0, $f0, $10, $02
    sprite_oam_piece $f0, $e8, $0f, $02
    sprite_oam_piece $e8, $f8, $0e, $02
    sprite_oam_piece $e8, $f0, $0d, $02

SpriteFrame_20_4B16::
    db 32
    sprite_oam_piece $00, $00, $1c, $63
    sprite_oam_piece $00, $08, $1b, $63
    sprite_oam_piece $00, $10, $1a, $63
    sprite_oam_piece $00, $f8, $1c, $43
    sprite_oam_piece $00, $f0, $1b, $43
    sprite_oam_piece $00, $e8, $1a, $43
    sprite_oam_piece $f8, $00, $1c, $23
    sprite_oam_piece $f8, $08, $1b, $23
    sprite_oam_piece $f8, $10, $1a, $23
    sprite_oam_piece $f8, $f8, $1c, $03
    sprite_oam_piece $f8, $f0, $1b, $03
    sprite_oam_piece $f8, $e8, $1a, $03
    sprite_oam_piece $f0, $00, $19, $23
    sprite_oam_piece $f0, $08, $18, $23
    sprite_oam_piece $f0, $10, $17, $23
    sprite_oam_piece $08, $00, $19, $63
    sprite_oam_piece $08, $08, $18, $63
    sprite_oam_piece $08, $10, $17, $63
    sprite_oam_piece $08, $f8, $19, $43
    sprite_oam_piece $08, $f0, $18, $43
    sprite_oam_piece $08, $e8, $17, $43
    sprite_oam_piece $f0, $f8, $19, $03
    sprite_oam_piece $f0, $f0, $18, $03
    sprite_oam_piece $f0, $e8, $17, $03
    sprite_oam_piece $10, $f8, $16, $43
    sprite_oam_piece $10, $f0, $15, $43
    sprite_oam_piece $10, $00, $16, $63
    sprite_oam_piece $10, $08, $15, $63
    sprite_oam_piece $e8, $00, $16, $23
    sprite_oam_piece $e8, $08, $15, $23
    sprite_oam_piece $e8, $f8, $16, $03
    sprite_oam_piece $e8, $f0, $15, $03

SpriteFrame_20_4B97::
    db 32
    sprite_oam_piece $00, $00, $24, $62
    sprite_oam_piece $00, $08, $23, $62
    sprite_oam_piece $00, $10, $22, $62
    sprite_oam_piece $00, $f8, $24, $42
    sprite_oam_piece $00, $f0, $23, $42
    sprite_oam_piece $00, $e8, $22, $42
    sprite_oam_piece $f8, $00, $24, $22
    sprite_oam_piece $f8, $08, $23, $22
    sprite_oam_piece $f8, $10, $22, $22
    sprite_oam_piece $f8, $f8, $24, $02
    sprite_oam_piece $f8, $f0, $23, $02
    sprite_oam_piece $f8, $e8, $22, $02
    sprite_oam_piece $08, $00, $21, $62
    sprite_oam_piece $08, $08, $20, $62
    sprite_oam_piece $08, $f8, $21, $42
    sprite_oam_piece $08, $f0, $20, $42
    sprite_oam_piece $f0, $f8, $21, $02
    sprite_oam_piece $f0, $f0, $20, $02
    sprite_oam_piece $f0, $00, $21, $22
    sprite_oam_piece $f0, $08, $20, $22
    sprite_oam_piece $f0, $10, $1f, $22
    sprite_oam_piece $08, $10, $1f, $62
    sprite_oam_piece $08, $e8, $1f, $42
    sprite_oam_piece $f0, $e8, $1f, $02
    sprite_oam_piece $10, $00, $1e, $62
    sprite_oam_piece $10, $08, $1d, $62
    sprite_oam_piece $10, $f8, $1e, $42
    sprite_oam_piece $10, $f0, $1d, $42
    sprite_oam_piece $e8, $00, $1e, $22
    sprite_oam_piece $e8, $08, $1d, $22
    sprite_oam_piece $e8, $f8, $1e, $02
    sprite_oam_piece $e8, $f0, $1d, $02

SpriteFrame_20_4C18::
    db 32
    sprite_oam_piece $00, $00, $2c, $62
    sprite_oam_piece $00, $08, $2b, $62
    sprite_oam_piece $00, $10, $2a, $62
    sprite_oam_piece $00, $f8, $2c, $42
    sprite_oam_piece $00, $f0, $2b, $42
    sprite_oam_piece $00, $e8, $2a, $42
    sprite_oam_piece $f8, $00, $2c, $22
    sprite_oam_piece $f8, $08, $2b, $22
    sprite_oam_piece $f8, $10, $2a, $22
    sprite_oam_piece $f8, $f8, $2c, $02
    sprite_oam_piece $f8, $f0, $2b, $02
    sprite_oam_piece $f8, $e8, $2a, $02
    sprite_oam_piece $08, $00, $29, $62
    sprite_oam_piece $08, $08, $28, $62
    sprite_oam_piece $08, $10, $27, $62
    sprite_oam_piece $08, $f8, $29, $42
    sprite_oam_piece $08, $f0, $28, $42
    sprite_oam_piece $08, $e8, $27, $42
    sprite_oam_piece $f0, $00, $29, $22
    sprite_oam_piece $f0, $08, $28, $22
    sprite_oam_piece $f0, $10, $27, $22
    sprite_oam_piece $f0, $f8, $29, $02
    sprite_oam_piece $f0, $f0, $28, $02
    sprite_oam_piece $f0, $e8, $27, $02
    sprite_oam_piece $10, $00, $26, $62
    sprite_oam_piece $10, $08, $25, $62
    sprite_oam_piece $10, $f8, $26, $42
    sprite_oam_piece $10, $f0, $25, $42
    sprite_oam_piece $e8, $00, $26, $22
    sprite_oam_piece $e8, $08, $25, $22
    sprite_oam_piece $e8, $f8, $26, $02
    sprite_oam_piece $e8, $f0, $25, $02

SpriteFrame_20_4C99::
    db 2
    sprite_oam_piece $04, $fc, $01, $04
    sprite_oam_piece $fc, $fc, $00, $04

SpriteFrame_20_4CA2::
    db 2
    sprite_oam_piece $04, $fc, $01, $25
    sprite_oam_piece $fc, $fc, $00, $25

SpriteFrame_20_4CAB::
    db 4
    sprite_oam_piece $00, $00, $02, $64
    sprite_oam_piece $00, $f8, $02, $44
    sprite_oam_piece $f8, $00, $02, $24
    sprite_oam_piece $f8, $f8, $02, $04

SpriteFrame_20_4CBC::
    db 1
    sprite_oam_piece $fc, $fc, $03, $05

SpriteFrame_20_4CC1::
    db 4
    sprite_oam_piece $00, $00, $04, $64
    sprite_oam_piece $00, $f8, $04, $44
    sprite_oam_piece $f8, $00, $04, $24
    sprite_oam_piece $f8, $f8, $04, $04

SpriteFrame_20_4CD2::
    db 4
    sprite_oam_piece $00, $00, $05, $65
    sprite_oam_piece $00, $f8, $05, $45
    sprite_oam_piece $f8, $00, $05, $25
    sprite_oam_piece $f8, $f8, $05, $05

SpriteFrame_20_4CE3::
    db 12
    sprite_oam_piece $08, $00, $06, $64
    sprite_oam_piece $08, $f8, $06, $44
    sprite_oam_piece $00, $00, $08, $64
    sprite_oam_piece $00, $08, $07, $64
    sprite_oam_piece $00, $f8, $08, $44
    sprite_oam_piece $00, $f0, $07, $44
    sprite_oam_piece $f8, $00, $08, $24
    sprite_oam_piece $f8, $08, $07, $24
    sprite_oam_piece $f0, $00, $06, $24
    sprite_oam_piece $f8, $f8, $08, $04
    sprite_oam_piece $f8, $f0, $07, $04
    sprite_oam_piece $f0, $f8, $06, $04

SpriteFrame_20_4D14::
    db 16
    sprite_oam_piece $08, $00, $0a, $65
    sprite_oam_piece $08, $08, $09, $65
    sprite_oam_piece $08, $f8, $0a, $45
    sprite_oam_piece $08, $f0, $09, $45
    sprite_oam_piece $00, $00, $0c, $65
    sprite_oam_piece $00, $08, $0b, $65
    sprite_oam_piece $00, $f8, $0c, $45
    sprite_oam_piece $00, $f0, $0b, $45
    sprite_oam_piece $f8, $00, $0c, $25
    sprite_oam_piece $f8, $08, $0b, $25
    sprite_oam_piece $f8, $f8, $0c, $05
    sprite_oam_piece $f8, $f0, $0b, $05
    sprite_oam_piece $f0, $00, $0a, $25
    sprite_oam_piece $f0, $08, $09, $25
    sprite_oam_piece $f0, $f8, $0a, $05
    sprite_oam_piece $f0, $f0, $09, $05

SpriteFrame_20_4D55::
    db 31
    sprite_oam_piece $e8, $00, $0e, $24
    sprite_oam_piece $e8, $08, $0d, $24
    sprite_oam_piece $10, $00, $0e, $64
    sprite_oam_piece $10, $08, $0d, $64
    sprite_oam_piece $10, $f8, $0e, $44
    sprite_oam_piece $10, $f0, $0d, $44
    sprite_oam_piece $08, $10, $0f, $64
    sprite_oam_piece $08, $e8, $0f, $44
    sprite_oam_piece $f0, $00, $11, $24
    sprite_oam_piece $f0, $08, $10, $24
    sprite_oam_piece $08, $00, $11, $64
    sprite_oam_piece $08, $08, $10, $64
    sprite_oam_piece $08, $f8, $11, $44
    sprite_oam_piece $08, $f0, $10, $44
    sprite_oam_piece $00, $00, $14, $64
    sprite_oam_piece $00, $08, $13, $64
    sprite_oam_piece $00, $10, $12, $64
    sprite_oam_piece $00, $f8, $14, $44
    sprite_oam_piece $00, $f0, $13, $44
    sprite_oam_piece $00, $e8, $12, $44
    sprite_oam_piece $f8, $00, $14, $24
    sprite_oam_piece $f8, $08, $13, $24
    sprite_oam_piece $f8, $10, $12, $24
    sprite_oam_piece $f8, $f8, $14, $04
    sprite_oam_piece $f8, $f0, $13, $04
    sprite_oam_piece $f8, $e8, $12, $04
    sprite_oam_piece $f0, $f8, $11, $04
    sprite_oam_piece $f0, $f0, $10, $04
    sprite_oam_piece $f0, $e8, $0f, $04
    sprite_oam_piece $e8, $f8, $0e, $04
    sprite_oam_piece $e8, $f0, $0d, $04

SpriteFrame_20_4DD2::
    db 32
    sprite_oam_piece $00, $00, $1c, $65
    sprite_oam_piece $00, $08, $1b, $65
    sprite_oam_piece $00, $10, $1a, $65
    sprite_oam_piece $00, $f8, $1c, $45
    sprite_oam_piece $00, $f0, $1b, $45
    sprite_oam_piece $00, $e8, $1a, $45
    sprite_oam_piece $f8, $00, $1c, $25
    sprite_oam_piece $f8, $08, $1b, $25
    sprite_oam_piece $f8, $10, $1a, $25
    sprite_oam_piece $f8, $f8, $1c, $05
    sprite_oam_piece $f8, $f0, $1b, $05
    sprite_oam_piece $f8, $e8, $1a, $05
    sprite_oam_piece $f0, $00, $19, $25
    sprite_oam_piece $f0, $08, $18, $25
    sprite_oam_piece $f0, $10, $17, $25
    sprite_oam_piece $08, $00, $19, $65
    sprite_oam_piece $08, $08, $18, $65
    sprite_oam_piece $08, $10, $17, $65
    sprite_oam_piece $08, $f8, $19, $45
    sprite_oam_piece $08, $f0, $18, $45
    sprite_oam_piece $08, $e8, $17, $45
    sprite_oam_piece $f0, $f8, $19, $05
    sprite_oam_piece $f0, $f0, $18, $05
    sprite_oam_piece $f0, $e8, $17, $05
    sprite_oam_piece $10, $f8, $16, $45
    sprite_oam_piece $10, $f0, $15, $45
    sprite_oam_piece $10, $00, $16, $65
    sprite_oam_piece $10, $08, $15, $65
    sprite_oam_piece $e8, $00, $16, $25
    sprite_oam_piece $e8, $08, $15, $25
    sprite_oam_piece $e8, $f8, $16, $05
    sprite_oam_piece $e8, $f0, $15, $05

SpriteFrame_20_4E53::
    db 32
    sprite_oam_piece $00, $00, $24, $64
    sprite_oam_piece $00, $08, $23, $64
    sprite_oam_piece $00, $10, $22, $64
    sprite_oam_piece $00, $f8, $24, $44
    sprite_oam_piece $00, $f0, $23, $44
    sprite_oam_piece $00, $e8, $22, $44
    sprite_oam_piece $f8, $00, $24, $24
    sprite_oam_piece $f8, $08, $23, $24
    sprite_oam_piece $f8, $10, $22, $24
    sprite_oam_piece $f8, $f8, $24, $04
    sprite_oam_piece $f8, $f0, $23, $04
    sprite_oam_piece $f8, $e8, $22, $04
    sprite_oam_piece $08, $00, $21, $64
    sprite_oam_piece $08, $08, $20, $64
    sprite_oam_piece $08, $f8, $21, $44
    sprite_oam_piece $08, $f0, $20, $44
    sprite_oam_piece $f0, $f8, $21, $04
    sprite_oam_piece $f0, $f0, $20, $04
    sprite_oam_piece $f0, $00, $21, $24
    sprite_oam_piece $f0, $08, $20, $24
    sprite_oam_piece $f0, $10, $1f, $24
    sprite_oam_piece $08, $10, $1f, $64
    sprite_oam_piece $08, $e8, $1f, $44
    sprite_oam_piece $f0, $e8, $1f, $04
    sprite_oam_piece $10, $00, $1e, $64
    sprite_oam_piece $10, $08, $1d, $64
    sprite_oam_piece $10, $f8, $1e, $44
    sprite_oam_piece $10, $f0, $1d, $44
    sprite_oam_piece $e8, $00, $1e, $24
    sprite_oam_piece $e8, $08, $1d, $24
    sprite_oam_piece $e8, $f8, $1e, $04
    sprite_oam_piece $e8, $f0, $1d, $04

SpriteFrame_20_4ED4::
    db 32
    sprite_oam_piece $00, $00, $2c, $64
    sprite_oam_piece $00, $08, $2b, $64
    sprite_oam_piece $00, $10, $2a, $64
    sprite_oam_piece $00, $f8, $2c, $44
    sprite_oam_piece $00, $f0, $2b, $44
    sprite_oam_piece $00, $e8, $2a, $44
    sprite_oam_piece $f8, $00, $2c, $24
    sprite_oam_piece $f8, $08, $2b, $24
    sprite_oam_piece $f8, $10, $2a, $24
    sprite_oam_piece $f8, $f8, $2c, $04
    sprite_oam_piece $f8, $f0, $2b, $04
    sprite_oam_piece $f8, $e8, $2a, $04
    sprite_oam_piece $08, $00, $29, $64
    sprite_oam_piece $08, $08, $28, $64
    sprite_oam_piece $08, $10, $27, $64
    sprite_oam_piece $08, $f8, $29, $44
    sprite_oam_piece $08, $f0, $28, $44
    sprite_oam_piece $08, $e8, $27, $44
    sprite_oam_piece $f0, $00, $29, $24
    sprite_oam_piece $f0, $08, $28, $24
    sprite_oam_piece $f0, $10, $27, $24
    sprite_oam_piece $f0, $f8, $29, $04
    sprite_oam_piece $f0, $f0, $28, $04
    sprite_oam_piece $f0, $e8, $27, $04
    sprite_oam_piece $10, $00, $26, $64
    sprite_oam_piece $10, $08, $25, $64
    sprite_oam_piece $10, $f8, $26, $44
    sprite_oam_piece $10, $f0, $25, $44
    sprite_oam_piece $e8, $00, $26, $24
    sprite_oam_piece $e8, $08, $25, $24
    sprite_oam_piece $e8, $f8, $26, $04
    sprite_oam_piece $e8, $f0, $25, $04

SpriteFrame_20_4F55::
    db 1
    sprite_oam_piece $fe, $fb, $2d, $00

SpriteFrame_20_4F5A::
    db 1
    sprite_oam_piece $fe, $fc, $2d, $21

SpriteFrame_20_4F5F::
    db 1
    sprite_oam_piece $fc, $fb, $2e, $00

SpriteFrame_20_4F64::
    db 1
    sprite_oam_piece $fc, $fb, $2f, $01

SpriteFrame_20_4F69::
    db 1
    sprite_oam_piece $fc, $fc, $30, $01

SpriteFrame_20_4F6E::
    db 4
    sprite_oam_piece $00, $00, $34, $00
    sprite_oam_piece $00, $f8, $33, $00
    sprite_oam_piece $f8, $00, $32, $00
    sprite_oam_piece $f8, $f8, $31, $00

SpriteFrame_20_4F7F::
    db 4
    sprite_oam_piece $00, $00, $38, $01
    sprite_oam_piece $00, $f8, $37, $01
    sprite_oam_piece $f8, $00, $36, $01
    sprite_oam_piece $f8, $f8, $35, $01

SpriteFrame_20_4F90::
    db 9
    sprite_oam_piece $04, $04, $41, $00
    sprite_oam_piece $04, $fc, $40, $00
    sprite_oam_piece $04, $f4, $3f, $00
    sprite_oam_piece $fc, $04, $3e, $00
    sprite_oam_piece $fc, $fc, $3d, $00
    sprite_oam_piece $fc, $f4, $3c, $00
    sprite_oam_piece $f4, $04, $3b, $00
    sprite_oam_piece $f4, $fc, $3a, $00
    sprite_oam_piece $f4, $f4, $39, $00

SpriteFrame_20_4FB5::
    db 9
    sprite_oam_piece $04, $04, $4a, $01
    sprite_oam_piece $04, $fc, $49, $01
    sprite_oam_piece $04, $f4, $48, $01
    sprite_oam_piece $fc, $04, $47, $01
    sprite_oam_piece $fc, $fc, $46, $01
    sprite_oam_piece $fc, $f4, $45, $01
    sprite_oam_piece $f4, $04, $44, $01
    sprite_oam_piece $f4, $fc, $43, $01
    sprite_oam_piece $f4, $f4, $42, $01

SpriteFrame_20_4FDA::
    db 9
    sprite_oam_piece $04, $04, $53, $00
    sprite_oam_piece $04, $fc, $52, $00
    sprite_oam_piece $04, $f4, $51, $00
    sprite_oam_piece $fc, $04, $50, $00
    sprite_oam_piece $fc, $fc, $4f, $00
    sprite_oam_piece $fc, $f4, $4e, $00
    sprite_oam_piece $f4, $04, $4d, $00
    sprite_oam_piece $f4, $fc, $4c, $00
    sprite_oam_piece $f4, $f4, $4b, $00

SpriteFrame_20_4FFF::
    db 8
    sprite_oam_piece $04, $04, $5b, $00
    sprite_oam_piece $04, $fc, $5a, $00
    sprite_oam_piece $04, $f4, $59, $00
    sprite_oam_piece $fc, $04, $58, $00
    sprite_oam_piece $fc, $f4, $57, $00
    sprite_oam_piece $f4, $04, $56, $00
    sprite_oam_piece $f4, $fc, $55, $00
    sprite_oam_piece $f4, $f4, $54, $00

SpriteFrame_20_5020::
    db 1
    sprite_oam_piece $fe, $fb, $2d, $02

SpriteFrame_20_5025::
    db 1
    sprite_oam_piece $fe, $fc, $2d, $23

SpriteFrame_20_502A::
    db 1
    sprite_oam_piece $fc, $fb, $2e, $02

SpriteFrame_20_502F::
    db 1
    sprite_oam_piece $fc, $fc, $30, $03

SpriteFrame_20_5034::
    db 4
    sprite_oam_piece $00, $00, $34, $02
    sprite_oam_piece $00, $f8, $33, $02
    sprite_oam_piece $f8, $00, $32, $02
    sprite_oam_piece $f8, $f8, $31, $02

SpriteFrame_20_5045::
    db 4
    sprite_oam_piece $00, $00, $38, $03
    sprite_oam_piece $00, $f8, $37, $03
    sprite_oam_piece $f8, $00, $36, $03
    sprite_oam_piece $f8, $f8, $35, $03

SpriteFrame_20_5056::
    db 9
    sprite_oam_piece $04, $04, $41, $02
    sprite_oam_piece $04, $fc, $40, $02
    sprite_oam_piece $04, $f4, $3f, $02
    sprite_oam_piece $fc, $04, $3e, $02
    sprite_oam_piece $fc, $fc, $3d, $02
    sprite_oam_piece $fc, $f4, $3c, $02
    sprite_oam_piece $f4, $04, $3b, $02
    sprite_oam_piece $f4, $fc, $3a, $02
    sprite_oam_piece $f4, $f4, $39, $02

SpriteFrame_20_507B::
    db 9
    sprite_oam_piece $04, $04, $4a, $03
    sprite_oam_piece $04, $fc, $49, $03
    sprite_oam_piece $04, $f4, $48, $03
    sprite_oam_piece $fc, $04, $47, $03
    sprite_oam_piece $fc, $fc, $46, $03
    sprite_oam_piece $fc, $f4, $45, $03
    sprite_oam_piece $f4, $04, $44, $03
    sprite_oam_piece $f4, $fc, $43, $03
    sprite_oam_piece $f4, $f4, $42, $03

SpriteFrame_20_50A0::
    db 9
    sprite_oam_piece $04, $04, $53, $02
    sprite_oam_piece $04, $fc, $52, $02
    sprite_oam_piece $04, $f4, $51, $02
    sprite_oam_piece $fc, $04, $50, $02
    sprite_oam_piece $fc, $fc, $4f, $02
    sprite_oam_piece $fc, $f4, $4e, $02
    sprite_oam_piece $f4, $04, $4d, $02
    sprite_oam_piece $f4, $fc, $4c, $02
    sprite_oam_piece $f4, $f4, $4b, $02

SpriteFrame_20_50C5::
    db 8
    sprite_oam_piece $04, $04, $5b, $02
    sprite_oam_piece $04, $fc, $5a, $02
    sprite_oam_piece $04, $f4, $59, $02
    sprite_oam_piece $fc, $04, $58, $02
    sprite_oam_piece $fc, $f4, $57, $02
    sprite_oam_piece $f4, $04, $56, $02
    sprite_oam_piece $f4, $fc, $55, $02
    sprite_oam_piece $f4, $f4, $54, $02

SpriteFrame_20_50E6::
    db 1
    sprite_oam_piece $fe, $fb, $2d, $04

SpriteFrame_20_50EB::
    db 1
    sprite_oam_piece $fe, $fc, $2d, $25

SpriteFrame_20_50F0::
    db 1
    sprite_oam_piece $fc, $fb, $2e, $04

SpriteFrame_20_50F5::
    db 1
    sprite_oam_piece $fc, $fc, $30, $05

SpriteFrame_20_50FA::
    db 4
    sprite_oam_piece $00, $00, $34, $04
    sprite_oam_piece $00, $f8, $33, $04
    sprite_oam_piece $f8, $00, $32, $04
    sprite_oam_piece $f8, $f8, $31, $04

SpriteFrame_20_510B::
    db 4
    sprite_oam_piece $00, $00, $38, $05
    sprite_oam_piece $00, $f8, $37, $05
    sprite_oam_piece $f8, $00, $36, $05
    sprite_oam_piece $f8, $f8, $35, $05

SpriteFrame_20_511C::
    db 9
    sprite_oam_piece $04, $04, $41, $04
    sprite_oam_piece $04, $fc, $40, $04
    sprite_oam_piece $04, $f4, $3f, $04
    sprite_oam_piece $fc, $04, $3e, $04
    sprite_oam_piece $fc, $fc, $3d, $04
    sprite_oam_piece $fc, $f4, $3c, $04
    sprite_oam_piece $f4, $04, $3b, $04
    sprite_oam_piece $f4, $fc, $3a, $04
    sprite_oam_piece $f4, $f4, $39, $04

SpriteFrame_20_5141::
    db 9
    sprite_oam_piece $04, $04, $4a, $05
    sprite_oam_piece $04, $fc, $49, $05
    sprite_oam_piece $04, $f4, $48, $05
    sprite_oam_piece $fc, $04, $47, $05
    sprite_oam_piece $fc, $fc, $46, $05
    sprite_oam_piece $fc, $f4, $45, $05
    sprite_oam_piece $f4, $04, $44, $05
    sprite_oam_piece $f4, $fc, $43, $05
    sprite_oam_piece $f4, $f4, $42, $05

SpriteFrame_20_5166::
    db 9
    sprite_oam_piece $04, $04, $53, $04
    sprite_oam_piece $04, $fc, $52, $04
    sprite_oam_piece $04, $f4, $51, $04
    sprite_oam_piece $fc, $04, $50, $04
    sprite_oam_piece $fc, $fc, $4f, $04
    sprite_oam_piece $fc, $f4, $4e, $04
    sprite_oam_piece $f4, $04, $4d, $04
    sprite_oam_piece $f4, $fc, $4c, $04
    sprite_oam_piece $f4, $f4, $4b, $04

SpriteFrame_20_518B::
    db 8
    sprite_oam_piece $04, $04, $5b, $04
    sprite_oam_piece $04, $fc, $5a, $04
    sprite_oam_piece $04, $f4, $59, $04
    sprite_oam_piece $fc, $04, $58, $04
    sprite_oam_piece $fc, $f4, $57, $04
    sprite_oam_piece $f4, $04, $56, $04
    sprite_oam_piece $f4, $fc, $55, $04
    sprite_oam_piece $f4, $f4, $54, $04

SpriteAnimation_171:: ; $20:$51AC
    sprite_anim_entry SpriteFrame_20_4733, $04
    sprite_anim_entry SpriteFrame_20_4744, $04
    sprite_anim_entry SpriteFrame_20_4749, $04
    sprite_anim_entry SpriteFrame_20_475A, $04
    sprite_anim_entry SpriteFrame_20_476B, $04
    sprite_anim_entry SpriteFrame_20_479C, $04
    sprite_anim_entry SpriteFrame_20_47DD, $04
    sprite_anim_entry SpriteFrame_20_485A, $04
    sprite_anim_entry SpriteFrame_20_48DB, $06
    sprite_anim_entry SpriteFrame_20_495C, $08
    sprite_anim_entry SpriteFrame_20_495C, $ff
    sprite_anim_end

SpriteAnimation_172:: ; $20:$51CF
    sprite_anim_entry SpriteFrame_20_49EF, $04
    sprite_anim_entry SpriteFrame_20_4A00, $04
    sprite_anim_entry SpriteFrame_20_4A05, $04
    sprite_anim_entry SpriteFrame_20_4A16, $04
    sprite_anim_entry SpriteFrame_20_4A27, $04
    sprite_anim_entry SpriteFrame_20_4A58, $04
    sprite_anim_entry SpriteFrame_20_4A99, $04
    sprite_anim_entry SpriteFrame_20_4B16, $04
    sprite_anim_entry SpriteFrame_20_4B97, $06
    sprite_anim_entry SpriteFrame_20_4C18, $08
    sprite_anim_entry SpriteFrame_20_4C18, $ff
    sprite_anim_end

SpriteAnimation_173:: ; $20:$51F2
    sprite_anim_entry SpriteFrame_20_4CAB, $04
    sprite_anim_entry SpriteFrame_20_4CBC, $04
    sprite_anim_entry SpriteFrame_20_4CC1, $04
    sprite_anim_entry SpriteFrame_20_4CD2, $04
    sprite_anim_entry SpriteFrame_20_4CE3, $04
    sprite_anim_entry SpriteFrame_20_4D14, $04
    sprite_anim_entry SpriteFrame_20_4D55, $04
    sprite_anim_entry SpriteFrame_20_4DD2, $04
    sprite_anim_entry SpriteFrame_20_4E53, $06
    sprite_anim_entry SpriteFrame_20_4ED4, $08
    sprite_anim_entry SpriteFrame_20_4ED4, $ff
    sprite_anim_end

SpriteAnimation_174:: ; $20:$5215
    sprite_anim_entry SpriteFrame_20_4F5F, $04
    sprite_anim_entry SpriteFrame_20_4F64, $04
    sprite_anim_entry SpriteFrame_20_4F69, $04
    sprite_anim_entry SpriteFrame_20_4F6E, $04
    sprite_anim_entry SpriteFrame_20_4F7F, $04
    sprite_anim_entry SpriteFrame_20_4F90, $04
    sprite_anim_entry SpriteFrame_20_4FB5, $04
    sprite_anim_entry SpriteFrame_20_4FDA, $06
    sprite_anim_entry SpriteFrame_20_4FFF, $08
    sprite_anim_entry SpriteFrame_20_4FFF, $ff
    sprite_anim_end

SpriteAnimation_175:: ; $20:$5235
    sprite_anim_entry SpriteFrame_20_502A, $04
    sprite_anim_entry SpriteFrame_20_4F64, $04
    sprite_anim_entry SpriteFrame_20_502F, $04
    sprite_anim_entry SpriteFrame_20_5034, $04
    sprite_anim_entry SpriteFrame_20_5045, $04
    sprite_anim_entry SpriteFrame_20_5056, $04
    sprite_anim_entry SpriteFrame_20_507B, $04
    sprite_anim_entry SpriteFrame_20_50A0, $06
    sprite_anim_entry SpriteFrame_20_50C5, $08
    sprite_anim_entry SpriteFrame_20_50C5, $ff
    sprite_anim_end

SpriteAnimation_176:: ; $20:$5255
    sprite_anim_entry SpriteFrame_20_50F0, $04
    sprite_anim_entry SpriteFrame_20_4F64, $04
    sprite_anim_entry SpriteFrame_20_50F5, $04
    sprite_anim_entry SpriteFrame_20_50FA, $04
    sprite_anim_entry SpriteFrame_20_510B, $04
    sprite_anim_entry SpriteFrame_20_511C, $04
    sprite_anim_entry SpriteFrame_20_5141, $04
    sprite_anim_entry SpriteFrame_20_5166, $06
    sprite_anim_entry SpriteFrame_20_518B, $08
    sprite_anim_entry SpriteFrame_20_518B, $ff
    sprite_anim_end

SpriteAnimation_177:: ; $20:$5275
    sprite_anim_entry SpriteFrame_20_4721, $02
    sprite_anim_entry SpriteFrame_20_472A, $02
    sprite_anim_end

SpriteAnimation_178:: ; $20:$527D
    sprite_anim_entry SpriteFrame_20_49DD, $02
    sprite_anim_entry SpriteFrame_20_49E6, $02
    sprite_anim_end

SpriteAnimation_179:: ; $20:$5285
    sprite_anim_entry SpriteFrame_20_4C99, $02
    sprite_anim_entry SpriteFrame_20_4CA2, $02
    sprite_anim_end

SpriteAnimation_180:: ; $20:$528D
    sprite_anim_entry SpriteFrame_20_4F55, $02
    sprite_anim_entry SpriteFrame_20_4F5A, $02
    sprite_anim_end

SpriteAnimation_181:: ; $20:$5295
    sprite_anim_entry SpriteFrame_20_5020, $02
    sprite_anim_entry SpriteFrame_20_5025, $02
    sprite_anim_end

SpriteAnimation_182:: ; $20:$529D
    sprite_anim_entry SpriteFrame_20_50E6, $02
    sprite_anim_entry SpriteFrame_20_50EB, $02
    sprite_anim_end

assert @ == $52a5

section "Sprite Animation Data 20:58BD", romx[$58bd], bank[$20]

SpriteFrame_20_58BD::
    db 6
    sprite_oam_piece $04, $fc, $04, $03
    sprite_oam_piece $fc, $04, $03, $03
    sprite_oam_piece $fc, $fc, $02, $03
    sprite_oam_piece $fc, $f4, $01, $63
    sprite_oam_piece $f4, $fc, $01, $03
    sprite_oam_piece $f4, $f4, $00, $03

SpriteFrame_20_58D6::
    db 7
    sprite_oam_piece $04, $04, $05, $07
    sprite_oam_piece $04, $fc, $04, $03
    sprite_oam_piece $fc, $04, $03, $03
    sprite_oam_piece $fc, $fc, $02, $03
    sprite_oam_piece $fc, $f4, $01, $63
    sprite_oam_piece $f4, $fc, $01, $03
    sprite_oam_piece $f4, $f4, $00, $03

SpriteFrame_20_58F3::
    db 7
    sprite_oam_piece $04, $04, $06, $07
    sprite_oam_piece $04, $fc, $04, $03
    sprite_oam_piece $fc, $04, $03, $03
    sprite_oam_piece $fc, $fc, $02, $03
    sprite_oam_piece $fc, $f4, $01, $63
    sprite_oam_piece $f4, $fc, $01, $03
    sprite_oam_piece $f4, $f4, $00, $03

SpriteAnimation_186:: ; $20:$5910
    sprite_anim_entry SpriteFrame_20_58BD, $02
    sprite_anim_entry SpriteFrame_20_58D6, $02
    sprite_anim_entry SpriteFrame_20_58BD, $02
    sprite_anim_entry SpriteFrame_20_58F3, $02
    sprite_anim_end

assert @ == $591e

section "Sprite Animation Data 20:59CE", romx[$59ce], bank[$20]

SpriteFrame_20_59CE::
    db 12
    sprite_oam_piece $07, $08, $0b, $02
    sprite_oam_piece $07, $00, $0a, $02
    sprite_oam_piece $07, $f8, $09, $02
    sprite_oam_piece $ff, $08, $08, $02
    sprite_oam_piece $ff, $00, $07, $02
    sprite_oam_piece $ff, $f8, $06, $02
    sprite_oam_piece $f7, $08, $05, $03
    sprite_oam_piece $f7, $00, $04, $02
    sprite_oam_piece $f7, $f8, $03, $03
    sprite_oam_piece $ef, $08, $02, $02
    sprite_oam_piece $ef, $00, $01, $02
    sprite_oam_piece $ef, $f8, $00, $02

SpriteFrame_20_59FF::
    db 11
    sprite_oam_piece $09, $00, $16, $02
    sprite_oam_piece $09, $f8, $15, $02
    sprite_oam_piece $01, $08, $14, $03
    sprite_oam_piece $01, $00, $13, $02
    sprite_oam_piece $01, $f8, $12, $02
    sprite_oam_piece $f9, $08, $11, $03
    sprite_oam_piece $f9, $00, $10, $02
    sprite_oam_piece $f9, $f8, $0f, $03
    sprite_oam_piece $f1, $08, $0e, $02
    sprite_oam_piece $f1, $00, $0d, $02
    sprite_oam_piece $f1, $f8, $0c, $02

SpriteFrame_20_5A2C::
    db 12
    sprite_oam_piece $07, $08, $22, $02
    sprite_oam_piece $07, $00, $21, $02
    sprite_oam_piece $07, $f8, $20, $02
    sprite_oam_piece $ff, $08, $1f, $03
    sprite_oam_piece $ff, $00, $1e, $02
    sprite_oam_piece $ff, $f8, $1d, $02
    sprite_oam_piece $f7, $08, $1c, $03
    sprite_oam_piece $f7, $00, $1b, $02
    sprite_oam_piece $f7, $f8, $1a, $03
    sprite_oam_piece $ef, $08, $19, $02
    sprite_oam_piece $ef, $00, $18, $02
    sprite_oam_piece $ef, $f8, $17, $02

SpriteFrame_20_5A5D::
    db 4
    sprite_oam_piece $00, $00, $26, $03
    sprite_oam_piece $00, $f8, $25, $03
    sprite_oam_piece $f8, $00, $24, $03
    sprite_oam_piece $f8, $f8, $23, $03

SpriteFrame_20_5A6E::
    db 4
    sprite_oam_piece $fe, $00, $2a, $03
    sprite_oam_piece $fe, $f8, $29, $03
    sprite_oam_piece $f6, $00, $28, $03
    sprite_oam_piece $f6, $f8, $27, $03

SpriteAnimation_187:: ; $20:$5A7F
    sprite_anim_entry SpriteFrame_20_59CE, $0a
    sprite_anim_entry SpriteFrame_20_59FF, $0a
    sprite_anim_entry SpriteFrame_20_5A2C, $0a
    sprite_anim_entry SpriteFrame_20_59FF, $0a
    sprite_anim_end

SpriteAnimation_188:: ; $20:$5A8D
    sprite_anim_entry SpriteFrame_20_5A5D, $08
    sprite_anim_entry SpriteFrame_20_5A6E, $08
    sprite_anim_end

assert @ == $5a95

section "Sprite Animation Data 20:5D89", romx[$5d89], bank[$20]

SpriteFrame_20_5D89::
    db 8
    sprite_oam_piece $04, $04, $8c, $00
    sprite_oam_piece $04, $fc, $8b, $00
    sprite_oam_piece $04, $f4, $8a, $00
    sprite_oam_piece $fc, $04, $89, $00
    sprite_oam_piece $fc, $fc, $88, $00
    sprite_oam_piece $fc, $f4, $87, $00
    sprite_oam_piece $f4, $04, $86, $00
    sprite_oam_piece $f4, $fc, $85, $00

SpriteFrame_20_5DAA::
    db 10
    sprite_oam_piece $04, $04, $96, $00
    sprite_oam_piece $04, $fc, $95, $00
    sprite_oam_piece $04, $f4, $94, $00
    sprite_oam_piece $fc, $04, $93, $00
    sprite_oam_piece $fc, $fc, $92, $00
    sprite_oam_piece $fc, $f4, $91, $00
    sprite_oam_piece $f4, $fc, $90, $00
    sprite_oam_piece $ec, $fc, $8f, $00
    sprite_oam_piece $e4, $fc, $8e, $00
    sprite_oam_piece $e4, $f4, $8d, $00

SpriteFrame_20_5DD3::
    db 15
    sprite_oam_piece $04, $04, $a5, $00
    sprite_oam_piece $04, $fc, $a4, $00
    sprite_oam_piece $04, $f4, $a3, $00
    sprite_oam_piece $fc, $04, $a2, $00
    sprite_oam_piece $fc, $fc, $a1, $00
    sprite_oam_piece $fc, $f4, $a0, $00
    sprite_oam_piece $f4, $04, $9f, $00
    sprite_oam_piece $f4, $fc, $9e, $00
    sprite_oam_piece $f4, $f4, $9d, $00
    sprite_oam_piece $ec, $04, $9c, $00
    sprite_oam_piece $ec, $fc, $9b, $00
    sprite_oam_piece $ec, $f4, $9a, $00
    sprite_oam_piece $e4, $04, $99, $00
    sprite_oam_piece $e4, $fc, $98, $00
    sprite_oam_piece $e4, $f4, $97, $00

SpriteFrame_20_5E10::
    db 8
    sprite_oam_piece $04, $08, $ad, $00
    sprite_oam_piece $04, $00, $ac, $00
    sprite_oam_piece $04, $f8, $ab, $00
    sprite_oam_piece $04, $f0, $aa, $00
    sprite_oam_piece $fc, $08, $a9, $00
    sprite_oam_piece $fc, $00, $a8, $00
    sprite_oam_piece $fc, $f8, $a7, $00
    sprite_oam_piece $fc, $f0, $a6, $00

SpriteFrame_20_5E31::
    db 6
    sprite_oam_piece $00, $04, $b3, $00
    sprite_oam_piece $00, $fc, $b2, $00
    sprite_oam_piece $00, $f4, $b1, $00
    sprite_oam_piece $f8, $04, $b0, $00
    sprite_oam_piece $f8, $fc, $af, $00
    sprite_oam_piece $f8, $f4, $ae, $00

SpriteFrame_20_5E4A::
    db 6
    sprite_oam_piece $00, $f4, $b3, $20
    sprite_oam_piece $00, $fc, $b2, $20
    sprite_oam_piece $00, $04, $b1, $20
    sprite_oam_piece $f8, $f4, $b0, $20
    sprite_oam_piece $f8, $fc, $af, $20
    sprite_oam_piece $f8, $04, $ae, $20

SpriteFrame_20_5E63::
    db 6
    sprite_oam_piece $00, $04, $ba, $00
    sprite_oam_piece $00, $fc, $b9, $00
    sprite_oam_piece $00, $f4, $b8, $00
    sprite_oam_piece $f8, $04, $b7, $00
    sprite_oam_piece $f8, $fc, $b6, $00
    sprite_oam_piece $f8, $f4, $b5, $00

SpriteFrame_20_5E7C::
    db 6
    sprite_oam_piece $00, $04, $c0, $00
    sprite_oam_piece $00, $fc, $bf, $00
    sprite_oam_piece $00, $f4, $be, $00
    sprite_oam_piece $f8, $04, $bd, $00
    sprite_oam_piece $f8, $fc, $bc, $00
    sprite_oam_piece $f8, $f4, $bb, $00

SpriteFrame_20_5E95::
    db 14
    sprite_oam_piece $f4, $06, $02, $06
    sprite_oam_piece $04, $10, $0e, $00
    sprite_oam_piece $04, $08, $0d, $00
    sprite_oam_piece $04, $00, $0c, $00
    sprite_oam_piece $04, $f8, $0b, $00
    sprite_oam_piece $04, $f0, $0a, $00
    sprite_oam_piece $04, $e8, $09, $00
    sprite_oam_piece $fc, $10, $08, $06
    sprite_oam_piece $fc, $08, $07, $06
    sprite_oam_piece $fc, $00, $06, $06
    sprite_oam_piece $fc, $f8, $05, $06
    sprite_oam_piece $fc, $f0, $04, $06
    sprite_oam_piece $fc, $e8, $03, $06
    sprite_oam_piece $f4, $ee, $01, $06

SpriteFrame_20_5ECE::
    db 18
    sprite_oam_piece $f4, $10, $20, $06
    sprite_oam_piece $f4, $08, $1f, $06
    sprite_oam_piece $f4, $00, $1e, $06
    sprite_oam_piece $f4, $f8, $1d, $06
    sprite_oam_piece $f4, $f0, $1c, $06
    sprite_oam_piece $f4, $e8, $1b, $06
    sprite_oam_piece $04, $10, $1a, $00
    sprite_oam_piece $04, $08, $19, $00
    sprite_oam_piece $04, $00, $18, $00
    sprite_oam_piece $04, $f8, $17, $00
    sprite_oam_piece $04, $f0, $16, $00
    sprite_oam_piece $04, $e8, $15, $00
    sprite_oam_piece $fc, $10, $14, $06
    sprite_oam_piece $fc, $08, $13, $06
    sprite_oam_piece $fc, $00, $12, $06
    sprite_oam_piece $fc, $f8, $11, $06
    sprite_oam_piece $fc, $f0, $10, $06
    sprite_oam_piece $fc, $e8, $0f, $06

SpriteFrame_20_5F17::
    db 24
    sprite_oam_piece $04, $10, $32, $00
    sprite_oam_piece $04, $08, $31, $00
    sprite_oam_piece $04, $00, $30, $00
    sprite_oam_piece $04, $f8, $2f, $00
    sprite_oam_piece $04, $f0, $2e, $00
    sprite_oam_piece $04, $e8, $2d, $00
    sprite_oam_piece $fc, $10, $2c, $06
    sprite_oam_piece $fc, $08, $2b, $06
    sprite_oam_piece $fc, $00, $2a, $06
    sprite_oam_piece $fc, $f8, $29, $06
    sprite_oam_piece $fc, $f0, $28, $01
    sprite_oam_piece $fc, $e8, $27, $06
    sprite_oam_piece $f4, $10, $26, $06
    sprite_oam_piece $f4, $08, $25, $06
    sprite_oam_piece $f4, $00, $24, $06
    sprite_oam_piece $f4, $f8, $23, $06
    sprite_oam_piece $f4, $f0, $22, $01
    sprite_oam_piece $f4, $e8, $21, $06
    sprite_oam_piece $ec, $10, $20, $06
    sprite_oam_piece $ec, $08, $1f, $06
    sprite_oam_piece $ec, $00, $1e, $06
    sprite_oam_piece $ec, $f8, $1d, $06
    sprite_oam_piece $ec, $f0, $1c, $06
    sprite_oam_piece $ec, $e8, $1b, $06

SpriteFrame_20_5F78::
    db 24
    sprite_oam_piece $fb, $f8, $29, $06
    sprite_oam_piece $fb, $f0, $28, $01
    sprite_oam_piece $f3, $10, $26, $06
    sprite_oam_piece $f3, $08, $25, $06
    sprite_oam_piece $f3, $00, $24, $06
    sprite_oam_piece $f3, $f8, $23, $06
    sprite_oam_piece $f3, $f0, $22, $01
    sprite_oam_piece $f3, $e8, $21, $06
    sprite_oam_piece $eb, $10, $20, $06
    sprite_oam_piece $eb, $08, $1f, $06
    sprite_oam_piece $eb, $00, $1e, $06
    sprite_oam_piece $eb, $f8, $1d, $06
    sprite_oam_piece $eb, $f0, $1c, $06
    sprite_oam_piece $eb, $e8, $1b, $06
    sprite_oam_piece $03, $10, $3c, $00
    sprite_oam_piece $03, $08, $3b, $00
    sprite_oam_piece $03, $00, $3a, $00
    sprite_oam_piece $03, $f8, $39, $00
    sprite_oam_piece $03, $f0, $38, $00
    sprite_oam_piece $03, $e8, $37, $00
    sprite_oam_piece $fb, $10, $36, $06
    sprite_oam_piece $fb, $08, $35, $06
    sprite_oam_piece $fb, $00, $34, $06
    sprite_oam_piece $fb, $e8, $33, $06

SpriteFrame_20_5FD9::
    db 24
    sprite_oam_piece $fa, $f8, $29, $06
    sprite_oam_piece $fa, $f0, $28, $01
    sprite_oam_piece $f2, $10, $26, $06
    sprite_oam_piece $f2, $08, $25, $06
    sprite_oam_piece $f2, $00, $24, $06
    sprite_oam_piece $f2, $f8, $23, $06
    sprite_oam_piece $f2, $f0, $22, $01
    sprite_oam_piece $f2, $e8, $21, $06
    sprite_oam_piece $ea, $10, $20, $06
    sprite_oam_piece $ea, $08, $1f, $06
    sprite_oam_piece $ea, $00, $1e, $06
    sprite_oam_piece $ea, $f8, $1d, $06
    sprite_oam_piece $ea, $f0, $1c, $06
    sprite_oam_piece $ea, $e8, $1b, $06
    sprite_oam_piece $02, $10, $46, $00
    sprite_oam_piece $02, $08, $45, $00
    sprite_oam_piece $02, $00, $44, $00
    sprite_oam_piece $02, $f8, $43, $00
    sprite_oam_piece $02, $f0, $42, $00
    sprite_oam_piece $02, $e8, $41, $00
    sprite_oam_piece $fa, $10, $40, $06
    sprite_oam_piece $fa, $08, $3f, $06
    sprite_oam_piece $fa, $00, $3e, $06
    sprite_oam_piece $fa, $e8, $3d, $06

SpriteFrame_20_603A::
    db 25
    sprite_oam_piece $de, $f8, $68, $06
    sprite_oam_piece $de, $f0, $67, $06
    sprite_oam_piece $ee, $10, $73, $06
    sprite_oam_piece $fe, $10, $7f, $07
    sprite_oam_piece $f6, $10, $79, $06
    sprite_oam_piece $fe, $08, $7e, $07
    sprite_oam_piece $fe, $00, $7d, $06
    sprite_oam_piece $fe, $f8, $7c, $07
    sprite_oam_piece $fe, $f0, $7b, $07
    sprite_oam_piece $fe, $e8, $7a, $06
    sprite_oam_piece $f6, $08, $78, $06
    sprite_oam_piece $f6, $00, $77, $06
    sprite_oam_piece $f6, $f8, $76, $06
    sprite_oam_piece $f6, $f0, $75, $06
    sprite_oam_piece $f6, $e8, $74, $06
    sprite_oam_piece $ee, $08, $72, $06
    sprite_oam_piece $ee, $00, $71, $06
    sprite_oam_piece $ee, $f8, $70, $01
    sprite_oam_piece $ee, $f0, $6f, $01
    sprite_oam_piece $ee, $e8, $6e, $06
    sprite_oam_piece $e6, $08, $6d, $06
    sprite_oam_piece $e6, $00, $6c, $06
    sprite_oam_piece $e6, $f8, $6b, $06
    sprite_oam_piece $e6, $f0, $6a, $06
    sprite_oam_piece $e6, $e8, $69, $06

SpriteFrame_20_609F::
    db 26
    sprite_oam_piece $f6, $ea, $55, $07
    sprite_oam_piece $fe, $ea, $5b, $07
    sprite_oam_piece $e6, $ea, $4b, $06
    sprite_oam_piece $de, $ea, $47, $06
    sprite_oam_piece $fe, $12, $60, $07
    sprite_oam_piece $fe, $0a, $5f, $07
    sprite_oam_piece $fe, $02, $5e, $07
    sprite_oam_piece $fe, $fa, $5d, $07
    sprite_oam_piece $fe, $f2, $5c, $06
    sprite_oam_piece $f6, $12, $5a, $06
    sprite_oam_piece $f6, $0a, $59, $06
    sprite_oam_piece $f6, $02, $58, $06
    sprite_oam_piece $f6, $fa, $57, $06
    sprite_oam_piece $f6, $f2, $56, $06
    sprite_oam_piece $ee, $12, $54, $06
    sprite_oam_piece $ee, $0a, $53, $06
    sprite_oam_piece $ee, $02, $52, $06
    sprite_oam_piece $ee, $fa, $51, $06
    sprite_oam_piece $ee, $f2, $50, $06
    sprite_oam_piece $e6, $0a, $4f, $06
    sprite_oam_piece $e6, $02, $4e, $06
    sprite_oam_piece $e6, $fa, $4d, $01
    sprite_oam_piece $e6, $f2, $4c, $01
    sprite_oam_piece $de, $02, $4a, $06
    sprite_oam_piece $de, $fa, $49, $06
    sprite_oam_piece $de, $f2, $48, $06

SpriteFrame_20_6108::
    db 26
    sprite_oam_piece $fe, $12, $66, $07
    sprite_oam_piece $fe, $0a, $65, $07
    sprite_oam_piece $fe, $02, $64, $07
    sprite_oam_piece $fe, $fa, $63, $07
    sprite_oam_piece $fe, $f2, $62, $06
    sprite_oam_piece $fe, $ea, $61, $06
    sprite_oam_piece $f6, $ea, $55, $07
    sprite_oam_piece $e6, $ea, $4b, $06
    sprite_oam_piece $de, $ea, $47, $06
    sprite_oam_piece $f6, $12, $5a, $06
    sprite_oam_piece $f6, $0a, $59, $06
    sprite_oam_piece $f6, $02, $58, $06
    sprite_oam_piece $f6, $fa, $57, $06
    sprite_oam_piece $f6, $f2, $56, $06
    sprite_oam_piece $ee, $12, $54, $06
    sprite_oam_piece $ee, $0a, $53, $06
    sprite_oam_piece $ee, $02, $52, $06
    sprite_oam_piece $ee, $fa, $51, $06
    sprite_oam_piece $ee, $f2, $50, $06
    sprite_oam_piece $e6, $0a, $4f, $06
    sprite_oam_piece $e6, $02, $4e, $06
    sprite_oam_piece $e6, $fa, $4d, $01
    sprite_oam_piece $e6, $f2, $4c, $01
    sprite_oam_piece $de, $02, $4a, $06
    sprite_oam_piece $de, $fa, $49, $06
    sprite_oam_piece $de, $f2, $48, $06

SpriteFrame_20_6171::
    db 4
    sprite_oam_piece $00, $00, $cd, $01
    sprite_oam_piece $00, $f8, $cc, $01
    sprite_oam_piece $f8, $00, $cb, $01
    sprite_oam_piece $f8, $f8, $ca, $01

SpriteFrame_20_6182::
    db 9
    sprite_oam_piece $04, $04, $c9, $01
    sprite_oam_piece $04, $fc, $c8, $01
    sprite_oam_piece $04, $f4, $c7, $01
    sprite_oam_piece $fc, $04, $c6, $01
    sprite_oam_piece $fc, $fc, $c5, $01
    sprite_oam_piece $fc, $f4, $c4, $01
    sprite_oam_piece $f4, $04, $c3, $01
    sprite_oam_piece $f4, $fc, $c2, $01
    sprite_oam_piece $f4, $f4, $c1, $01

SpriteFrame_20_61A7::
    db 2
    sprite_oam_piece $fc, $00, $81, $03
    sprite_oam_piece $fc, $f8, $80, $03

SpriteFrame_20_61B0::
    db 2
    sprite_oam_piece $fc, $00, $83, $03
    sprite_oam_piece $fc, $f8, $82, $03

SpriteAnimation_189:: ; $20:$61B9
    sprite_anim_entry SpriteFrame_20_5D89, $07
    sprite_anim_entry SpriteFrame_20_5DAA, $0a
    sprite_anim_entry SpriteFrame_20_5DD3, $07
    sprite_anim_entry SpriteFrame_20_5E10, $0a
    sprite_anim_entry SpriteFrame_20_5E10, $ff
    sprite_anim_end

SpriteAnimation_190:: ; $20:$61CA
    sprite_anim_entry SpriteFrame_20_5E31, $0a
    sprite_anim_entry SpriteFrame_20_5E4A, $0a
    sprite_anim_end

SpriteAnimation_191:: ; $20:$61D2
    sprite_anim_entry SpriteFrame_20_5E31, $0a
    sprite_anim_entry SpriteFrame_20_5E4A, $0a
    sprite_anim_entry SpriteFrame_20_5E63, $0a
    sprite_anim_entry SpriteFrame_20_5E7C, $0a
    sprite_anim_entry SpriteFrame_20_5E95, $0c
    sprite_anim_entry SpriteFrame_20_5ECE, $0e
    sprite_anim_entry SpriteFrame_20_5F17, $10
    sprite_anim_entry SpriteFrame_20_5F78, $12
    sprite_anim_entry SpriteFrame_20_5FD9, $14
    sprite_anim_entry SpriteFrame_20_5F78, $10
    sprite_anim_entry SpriteFrame_20_5F78, $ff
    sprite_anim_end

SpriteAnimation_192:: ; $20:$61F5
    sprite_anim_entry SpriteFrame_20_5F17, $0f
    sprite_anim_entry SpriteFrame_20_5F78, $0f
    sprite_anim_entry SpriteFrame_20_5FD9, $0f
    sprite_anim_entry SpriteFrame_20_5F78, $0f
    sprite_anim_end

SpriteAnimation_193:: ; $20:$6203
    sprite_anim_entry SpriteFrame_20_5F17, $0f
    sprite_anim_entry SpriteFrame_20_603A, $0a
    sprite_anim_entry SpriteFrame_20_609F, $0a
    sprite_anim_entry SpriteFrame_20_6108, $0a
    sprite_anim_entry SpriteFrame_20_6108, $ff
    sprite_anim_end

SpriteAnimation_194:: ; $20:$6214
    sprite_anim_entry SpriteFrame_20_609F, $0a
    sprite_anim_entry SpriteFrame_20_6108, $0a
    sprite_anim_end

SpriteAnimation_195:: ; $20:$621C
    sprite_anim_entry SpriteFrame_20_609F, $0a
    sprite_anim_entry SpriteFrame_20_6108, $0a
    sprite_anim_entry SpriteFrame_20_603A, $0a
    sprite_anim_entry SpriteFrame_20_5F17, $0a
    sprite_anim_entry SpriteFrame_20_5F17, $ff
    sprite_anim_end

SpriteAnimation_196:: ; $20:$622D
    sprite_anim_entry SpriteFrame_20_5ECE, $0e
    sprite_anim_entry SpriteFrame_20_5E95, $0c
    sprite_anim_entry SpriteFrame_20_5E7C, $0a
    sprite_anim_entry SpriteFrame_20_5E63, $0a
    sprite_anim_entry SpriteFrame_20_5E4A, $0a
    sprite_anim_entry SpriteFrame_20_5E31, $0a
    sprite_anim_entry SpriteFrame_20_5E31, $ff
    sprite_anim_end

SpriteAnimation_197:: ; $20:$6244
    sprite_anim_entry SpriteFrame_20_6171, $0e
    sprite_anim_entry SpriteFrame_20_6182, $1e
    sprite_anim_entry SpriteFrame_20_6182, $ff
    sprite_anim_end

SpriteAnimation_198:: ; $20:$624F
    sprite_anim_entry SpriteFrame_20_61A7, $0a
    sprite_anim_entry SpriteFrame_20_61B0, $0a
    sprite_anim_end

assert @ == $6257

section "Sprite Animation Data 20:6F8B", romx[$6f8b], bank[$20]

SpriteFrame_20_6F8B::
    db 21
    sprite_oam_piece $08, $0c, $14, $02
    sprite_oam_piece $08, $04, $13, $02
    sprite_oam_piece $08, $fc, $12, $02
    sprite_oam_piece $08, $f4, $11, $02
    sprite_oam_piece $08, $ec, $10, $02
    sprite_oam_piece $00, $0c, $0f, $02
    sprite_oam_piece $00, $04, $0e, $02
    sprite_oam_piece $00, $fc, $0d, $02
    sprite_oam_piece $00, $f4, $0c, $02
    sprite_oam_piece $00, $ec, $0b, $02
    sprite_oam_piece $f8, $0c, $0a, $02
    sprite_oam_piece $f8, $04, $09, $02
    sprite_oam_piece $f8, $fc, $08, $02
    sprite_oam_piece $f8, $f4, $07, $02
    sprite_oam_piece $f8, $ec, $06, $02
    sprite_oam_piece $f0, $0c, $05, $02
    sprite_oam_piece $f0, $04, $04, $02
    sprite_oam_piece $f0, $fc, $03, $02
    sprite_oam_piece $f0, $f4, $02, $02
    sprite_oam_piece $f0, $ec, $01, $02
    sprite_oam_piece $f0, $e4, $00, $02

SpriteFrame_20_6FE0::
    db 21
    sprite_oam_piece $07, $0c, $19, $02
    sprite_oam_piece $07, $04, $18, $02
    sprite_oam_piece $07, $fc, $17, $02
    sprite_oam_piece $07, $f4, $16, $02
    sprite_oam_piece $07, $ec, $15, $02
    sprite_oam_piece $ff, $0c, $0f, $02
    sprite_oam_piece $ff, $04, $0e, $02
    sprite_oam_piece $ff, $fc, $0d, $02
    sprite_oam_piece $ff, $f4, $0c, $02
    sprite_oam_piece $ff, $ec, $0b, $02
    sprite_oam_piece $f7, $0c, $0a, $02
    sprite_oam_piece $f7, $04, $09, $02
    sprite_oam_piece $f7, $fc, $08, $02
    sprite_oam_piece $f7, $f4, $07, $02
    sprite_oam_piece $f7, $ec, $06, $02
    sprite_oam_piece $ef, $0c, $05, $02
    sprite_oam_piece $ef, $04, $04, $02
    sprite_oam_piece $ef, $fc, $03, $02
    sprite_oam_piece $ef, $f4, $02, $02
    sprite_oam_piece $ef, $ec, $01, $02
    sprite_oam_piece $ef, $e4, $00, $02

SpriteFrame_20_7035::
    db 21
    sprite_oam_piece $06, $0c, $1e, $02
    sprite_oam_piece $06, $04, $1d, $02
    sprite_oam_piece $06, $fc, $1c, $02
    sprite_oam_piece $06, $f4, $1b, $02
    sprite_oam_piece $06, $ec, $1a, $02
    sprite_oam_piece $fe, $0c, $0f, $02
    sprite_oam_piece $fe, $04, $0e, $02
    sprite_oam_piece $fe, $fc, $0d, $02
    sprite_oam_piece $fe, $f4, $0c, $02
    sprite_oam_piece $fe, $ec, $0b, $02
    sprite_oam_piece $f6, $0c, $0a, $02
    sprite_oam_piece $f6, $04, $09, $02
    sprite_oam_piece $f6, $fc, $08, $02
    sprite_oam_piece $f6, $f4, $07, $02
    sprite_oam_piece $f6, $ec, $06, $02
    sprite_oam_piece $ee, $0c, $05, $02
    sprite_oam_piece $ee, $04, $04, $02
    sprite_oam_piece $ee, $fc, $03, $02
    sprite_oam_piece $ee, $f4, $02, $02
    sprite_oam_piece $ee, $ec, $01, $02
    sprite_oam_piece $ee, $e4, $00, $02

SpriteFrame_20_708A::
    db 21
    sprite_oam_piece $07, $0c, $19, $02
    sprite_oam_piece $07, $04, $18, $02
    sprite_oam_piece $07, $fc, $17, $02
    sprite_oam_piece $07, $f4, $16, $02
    sprite_oam_piece $07, $ec, $15, $02
    sprite_oam_piece $ff, $0c, $0f, $02
    sprite_oam_piece $ff, $04, $0e, $02
    sprite_oam_piece $ff, $fc, $0d, $02
    sprite_oam_piece $ff, $f4, $0c, $02
    sprite_oam_piece $ff, $ec, $0b, $02
    sprite_oam_piece $f7, $0c, $0a, $02
    sprite_oam_piece $f7, $04, $09, $02
    sprite_oam_piece $f7, $fc, $08, $02
    sprite_oam_piece $f7, $f4, $07, $02
    sprite_oam_piece $f7, $ec, $06, $02
    sprite_oam_piece $ef, $0c, $05, $02
    sprite_oam_piece $ef, $04, $04, $02
    sprite_oam_piece $ef, $fc, $03, $02
    sprite_oam_piece $ef, $f4, $02, $02
    sprite_oam_piece $ef, $ec, $01, $02
    sprite_oam_piece $ef, $e4, $00, $02

SpriteFrame_20_70DF::
    db 33
    sprite_oam_piece $e8, $ca, $31, $07
    sprite_oam_piece $f0, $e2, $37, $07
    sprite_oam_piece $f0, $da, $36, $07
    sprite_oam_piece $f0, $d2, $35, $07
    sprite_oam_piece $e8, $e2, $34, $07
    sprite_oam_piece $e8, $da, $33, $07
    sprite_oam_piece $e8, $d2, $32, $07
    sprite_oam_piece $e0, $e2, $30, $07
    sprite_oam_piece $e0, $da, $2f, $07
    sprite_oam_piece $e0, $d2, $2e, $07
    sprite_oam_piece $eb, $ed, $4a, $07
    sprite_oam_piece $e7, $e4, $26, $02
    sprite_oam_piece $f7, $fc, $2d, $02
    sprite_oam_piece $f7, $f4, $2c, $02
    sprite_oam_piece $f7, $ec, $2b, $02
    sprite_oam_piece $ef, $fc, $2a, $02
    sprite_oam_piece $ef, $f4, $29, $02
    sprite_oam_piece $ef, $ec, $28, $02
    sprite_oam_piece $ef, $e4, $27, $02
    sprite_oam_piece $07, $0c, $19, $02
    sprite_oam_piece $07, $04, $18, $02
    sprite_oam_piece $07, $fc, $17, $02
    sprite_oam_piece $07, $f4, $16, $02
    sprite_oam_piece $07, $ec, $15, $02
    sprite_oam_piece $ff, $0c, $0f, $02
    sprite_oam_piece $ff, $04, $0e, $02
    sprite_oam_piece $ff, $fc, $0d, $02
    sprite_oam_piece $ff, $f4, $0c, $02
    sprite_oam_piece $ff, $ec, $0b, $02
    sprite_oam_piece $f7, $0c, $0a, $02
    sprite_oam_piece $f7, $04, $09, $02
    sprite_oam_piece $ef, $0c, $05, $02
    sprite_oam_piece $ef, $04, $04, $02

SpriteFrame_20_7164::
    db 30
    sprite_oam_piece $08, $0d, $14, $02
    sprite_oam_piece $08, $05, $13, $02
    sprite_oam_piece $08, $fd, $12, $02
    sprite_oam_piece $08, $f5, $11, $02
    sprite_oam_piece $08, $ed, $10, $02
    sprite_oam_piece $f3, $e5, $40, $07
    sprite_oam_piece $f3, $dd, $3f, $07
    sprite_oam_piece $f3, $d5, $3e, $07
    sprite_oam_piece $eb, $e5, $3d, $07
    sprite_oam_piece $eb, $dd, $3c, $07
    sprite_oam_piece $eb, $d5, $3b, $07
    sprite_oam_piece $e3, $e5, $3a, $07
    sprite_oam_piece $e3, $dd, $39, $07
    sprite_oam_piece $e3, $d5, $38, $07
    sprite_oam_piece $f8, $fd, $25, $02
    sprite_oam_piece $f8, $f5, $24, $02
    sprite_oam_piece $f8, $ed, $23, $02
    sprite_oam_piece $f0, $fd, $22, $02
    sprite_oam_piece $f0, $f5, $21, $02
    sprite_oam_piece $f0, $ed, $20, $02
    sprite_oam_piece $f0, $e5, $1f, $02
    sprite_oam_piece $00, $0d, $0f, $02
    sprite_oam_piece $00, $05, $0e, $02
    sprite_oam_piece $00, $fd, $0d, $02
    sprite_oam_piece $00, $f5, $0c, $02
    sprite_oam_piece $00, $ed, $0b, $02
    sprite_oam_piece $f8, $0d, $0a, $02
    sprite_oam_piece $f8, $05, $09, $02
    sprite_oam_piece $f0, $0d, $05, $02
    sprite_oam_piece $f0, $05, $04, $02

SpriteFrame_20_71DD::
    db 35
    sprite_oam_piece $e9, $d5, $44, $07
    sprite_oam_piece $f9, $ed, $4d, $07
    sprite_oam_piece $f9, $e5, $4c, $07
    sprite_oam_piece $f9, $dd, $4b, $07
    sprite_oam_piece $f1, $ed, $4a, $07
    sprite_oam_piece $f1, $e5, $49, $07
    sprite_oam_piece $f1, $dd, $48, $07
    sprite_oam_piece $e9, $ed, $47, $07
    sprite_oam_piece $e9, $e5, $46, $07
    sprite_oam_piece $e9, $dd, $45, $07
    sprite_oam_piece $e1, $ed, $43, $07
    sprite_oam_piece $e1, $e5, $42, $07
    sprite_oam_piece $e1, $dd, $41, $07
    sprite_oam_piece $e7, $e6, $26, $02
    sprite_oam_piece $f7, $fe, $2d, $02
    sprite_oam_piece $f7, $f6, $2c, $02
    sprite_oam_piece $f7, $ee, $2b, $02
    sprite_oam_piece $ef, $fe, $2a, $02
    sprite_oam_piece $ef, $f6, $29, $02
    sprite_oam_piece $ef, $ee, $28, $02
    sprite_oam_piece $ef, $e6, $27, $02
    sprite_oam_piece $07, $0e, $19, $02
    sprite_oam_piece $07, $06, $18, $02
    sprite_oam_piece $07, $fe, $17, $02
    sprite_oam_piece $07, $f6, $16, $02
    sprite_oam_piece $07, $ee, $15, $02
    sprite_oam_piece $ff, $0e, $0f, $02
    sprite_oam_piece $ff, $06, $0e, $02
    sprite_oam_piece $ff, $fe, $0d, $02
    sprite_oam_piece $ff, $f6, $0c, $02
    sprite_oam_piece $ff, $ee, $0b, $02
    sprite_oam_piece $f7, $0e, $0a, $02
    sprite_oam_piece $f7, $06, $09, $02
    sprite_oam_piece $ef, $0e, $05, $02
    sprite_oam_piece $ef, $06, $04, $02

SpriteFrame_20_726A::
    db 21
    sprite_oam_piece $07, $0d, $19, $02
    sprite_oam_piece $07, $05, $18, $02
    sprite_oam_piece $07, $fd, $17, $02
    sprite_oam_piece $07, $f5, $16, $02
    sprite_oam_piece $07, $ed, $15, $02
    sprite_oam_piece $ff, $0d, $0f, $02
    sprite_oam_piece $ff, $05, $0e, $02
    sprite_oam_piece $ff, $fd, $0d, $02
    sprite_oam_piece $ff, $f5, $0c, $02
    sprite_oam_piece $ff, $ed, $0b, $02
    sprite_oam_piece $f7, $0d, $0a, $02
    sprite_oam_piece $f7, $05, $09, $02
    sprite_oam_piece $f7, $fd, $08, $02
    sprite_oam_piece $f7, $f5, $07, $02
    sprite_oam_piece $f7, $ed, $06, $02
    sprite_oam_piece $ef, $0d, $05, $02
    sprite_oam_piece $ef, $05, $04, $02
    sprite_oam_piece $ef, $fd, $03, $02
    sprite_oam_piece $ef, $f5, $02, $02
    sprite_oam_piece $ef, $ed, $01, $02
    sprite_oam_piece $ef, $e5, $00, $02

SpriteAnimation_199:: ; $20:$72BF
    sprite_anim_entry SpriteFrame_20_6F8B, $0a
    sprite_anim_entry SpriteFrame_20_6FE0, $0a
    sprite_anim_entry SpriteFrame_20_7035, $0a
    sprite_anim_entry SpriteFrame_20_6FE0, $0a
    sprite_anim_end

SpriteAnimation_200:: ; $20:$72CD
    sprite_anim_entry SpriteFrame_20_708A, $19
    sprite_anim_entry SpriteFrame_20_70DF, $05
    sprite_anim_entry SpriteFrame_20_7164, $06
    sprite_anim_entry SpriteFrame_20_71DD, $07
    sprite_anim_entry SpriteFrame_20_726A, $32
    sprite_anim_end

assert @ == $72de

section "Sprite Animation Data 21:4000", romx[$4000], bank[$21]

SpriteFrame_21_4000::
    db 11
    sprite_oam_piece $08, $f8, $3a, $02
    sprite_oam_piece $08, $f0, $39, $02
    sprite_oam_piece $00, $00, $38, $02
    sprite_oam_piece $00, $f8, $37, $03
    sprite_oam_piece $00, $f0, $36, $03
    sprite_oam_piece $f8, $00, $35, $02
    sprite_oam_piece $f8, $f8, $34, $02
    sprite_oam_piece $f8, $f0, $33, $02
    sprite_oam_piece $f0, $00, $32, $02
    sprite_oam_piece $f0, $f8, $31, $02
    sprite_oam_piece $f0, $f0, $30, $02

SpriteFrame_21_402D::
    db 10
    sprite_oam_piece $08, $00, $2f, $22
    sprite_oam_piece $00, $00, $2e, $23
    sprite_oam_piece $08, $f8, $2f, $02
    sprite_oam_piece $00, $f8, $2e, $03
    sprite_oam_piece $f8, $04, $2d, $02
    sprite_oam_piece $f8, $fc, $2c, $02
    sprite_oam_piece $f8, $f4, $2b, $02
    sprite_oam_piece $f0, $04, $2a, $02
    sprite_oam_piece $f0, $fc, $29, $02
    sprite_oam_piece $f0, $f4, $28, $02

SpriteFrame_21_4056::
    db 11
    sprite_oam_piece $08, $00, $3a, $22
    sprite_oam_piece $08, $08, $39, $22
    sprite_oam_piece $00, $f8, $38, $22
    sprite_oam_piece $00, $00, $37, $23
    sprite_oam_piece $00, $08, $36, $23
    sprite_oam_piece $f8, $f8, $35, $22
    sprite_oam_piece $f8, $00, $34, $22
    sprite_oam_piece $f8, $08, $33, $22
    sprite_oam_piece $f0, $f8, $32, $22
    sprite_oam_piece $f0, $00, $31, $22
    sprite_oam_piece $f0, $08, $30, $22

SpriteFrame_21_4083::
    db 9
    sprite_oam_piece $08, $00, $08, $02
    sprite_oam_piece $08, $f8, $07, $02
    sprite_oam_piece $00, $00, $06, $03
    sprite_oam_piece $00, $f8, $05, $03
    sprite_oam_piece $f8, $08, $04, $02
    sprite_oam_piece $f8, $00, $03, $03
    sprite_oam_piece $f8, $f8, $02, $03
    sprite_oam_piece $f0, $00, $01, $02
    sprite_oam_piece $f0, $f8, $00, $02

SpriteFrame_21_40A8::
    db 10
    sprite_oam_piece $f7, $08, $04, $02
    sprite_oam_piece $f7, $00, $03, $03
    sprite_oam_piece $f7, $f8, $02, $03
    sprite_oam_piece $ef, $00, $01, $02
    sprite_oam_piece $ef, $f8, $00, $02
    sprite_oam_piece $07, $00, $0d, $02
    sprite_oam_piece $07, $f8, $0c, $02
    sprite_oam_piece $ff, $08, $0b, $02
    sprite_oam_piece $ff, $00, $0a, $03
    sprite_oam_piece $ff, $f8, $09, $03

SpriteFrame_21_40D1::
    db 10
    sprite_oam_piece $f6, $08, $04, $02
    sprite_oam_piece $f6, $00, $03, $03
    sprite_oam_piece $f6, $f8, $02, $03
    sprite_oam_piece $ee, $00, $01, $02
    sprite_oam_piece $ee, $f8, $00, $02
    sprite_oam_piece $06, $00, $12, $02
    sprite_oam_piece $06, $f8, $11, $02
    sprite_oam_piece $fe, $08, $10, $02
    sprite_oam_piece $fe, $00, $0f, $03
    sprite_oam_piece $fe, $f8, $0e, $03

SpriteFrame_21_40FA::
    db 12
    sprite_oam_piece $08, $04, $8f, $02
    sprite_oam_piece $08, $fc, $8e, $02
    sprite_oam_piece $08, $f4, $8d, $02
    sprite_oam_piece $00, $04, $8c, $02
    sprite_oam_piece $00, $fc, $8b, $02
    sprite_oam_piece $00, $f4, $8a, $02
    sprite_oam_piece $f8, $04, $89, $03
    sprite_oam_piece $f8, $fc, $88, $03
    sprite_oam_piece $f8, $f4, $87, $03
    sprite_oam_piece $f0, $04, $86, $02
    sprite_oam_piece $f0, $fc, $85, $02
    sprite_oam_piece $f0, $f4, $84, $02

SpriteFrame_21_412B::
    db 12
    sprite_oam_piece $f0, $f4, $86, $22
    sprite_oam_piece $f0, $fc, $85, $22
    sprite_oam_piece $f0, $04, $84, $22
    sprite_oam_piece $f8, $04, $92, $03
    sprite_oam_piece $f8, $fc, $91, $03
    sprite_oam_piece $f8, $f4, $90, $03
    sprite_oam_piece $08, $04, $8f, $02
    sprite_oam_piece $08, $fc, $8e, $02
    sprite_oam_piece $08, $f4, $8d, $02
    sprite_oam_piece $00, $04, $8c, $02
    sprite_oam_piece $00, $fc, $8b, $02
    sprite_oam_piece $00, $f4, $8a, $02

SpriteFrame_21_415C::
    db 12
    sprite_oam_piece $00, $08, $1e, $02
    sprite_oam_piece $00, $00, $1d, $02
    sprite_oam_piece $00, $f8, $1c, $02
    sprite_oam_piece $00, $f0, $1b, $02
    sprite_oam_piece $f8, $08, $1a, $02
    sprite_oam_piece $f8, $00, $19, $02
    sprite_oam_piece $f8, $f8, $18, $02
    sprite_oam_piece $f8, $f0, $17, $02
    sprite_oam_piece $f0, $08, $16, $02
    sprite_oam_piece $f0, $00, $15, $02
    sprite_oam_piece $f0, $f8, $14, $02
    sprite_oam_piece $f0, $f0, $13, $02

SpriteFrame_21_418D::
    db 9
    sprite_oam_piece $fe, $04, $27, $02
    sprite_oam_piece $fe, $fc, $26, $02
    sprite_oam_piece $fe, $f4, $25, $02
    sprite_oam_piece $f6, $04, $24, $02
    sprite_oam_piece $f6, $fc, $23, $02
    sprite_oam_piece $f6, $f4, $22, $02
    sprite_oam_piece $ee, $04, $21, $02
    sprite_oam_piece $ee, $fc, $20, $02
    sprite_oam_piece $ee, $f4, $1f, $02

SpriteFrame_21_41B2::
    db 13
    sprite_oam_piece $f7, $f5, $b7, $01
    sprite_oam_piece $08, $04, $aa, $02
    sprite_oam_piece $08, $fc, $a9, $02
    sprite_oam_piece $08, $f4, $a8, $02
    sprite_oam_piece $00, $04, $a7, $02
    sprite_oam_piece $00, $fc, $a6, $02
    sprite_oam_piece $00, $f4, $a5, $02
    sprite_oam_piece $f8, $04, $a4, $03
    sprite_oam_piece $f8, $fc, $a3, $02
    sprite_oam_piece $f8, $f4, $a2, $03
    sprite_oam_piece $f0, $04, $a1, $02
    sprite_oam_piece $f0, $fc, $a0, $02
    sprite_oam_piece $f0, $f4, $9f, $02

SpriteFrame_21_41E7::
    db 12
    sprite_oam_piece $f8, $f5, $b6, $01
    sprite_oam_piece $0a, $fc, $b5, $02
    sprite_oam_piece $0a, $f4, $b4, $02
    sprite_oam_piece $02, $04, $b3, $02
    sprite_oam_piece $02, $fc, $b2, $02
    sprite_oam_piece $02, $f4, $b1, $02
    sprite_oam_piece $fa, $04, $b0, $03
    sprite_oam_piece $fa, $fc, $af, $02
    sprite_oam_piece $fa, $f4, $ae, $03
    sprite_oam_piece $f2, $04, $ad, $02
    sprite_oam_piece $f2, $fc, $ac, $02
    sprite_oam_piece $f2, $f4, $ab, $02

SpriteFrame_21_4218::
    db 13
    sprite_oam_piece $f7, $f5, $b7, $01
    sprite_oam_piece $08, $04, $9e, $02
    sprite_oam_piece $08, $fc, $9d, $02
    sprite_oam_piece $08, $f4, $9c, $02
    sprite_oam_piece $00, $04, $9b, $03
    sprite_oam_piece $00, $fc, $9a, $02
    sprite_oam_piece $00, $f4, $99, $02
    sprite_oam_piece $f8, $04, $98, $02
    sprite_oam_piece $f8, $fc, $97, $02
    sprite_oam_piece $f8, $f4, $96, $03
    sprite_oam_piece $f0, $04, $95, $02
    sprite_oam_piece $f0, $fc, $94, $02
    sprite_oam_piece $f0, $f4, $93, $02

SpriteFrame_21_424D::
    db 14
    sprite_oam_piece $0a, $0c, $48, $06
    sprite_oam_piece $0a, $04, $47, $06
    sprite_oam_piece $0a, $fc, $46, $06
    sprite_oam_piece $0a, $f4, $45, $06
    sprite_oam_piece $0a, $ec, $44, $06
    sprite_oam_piece $02, $0c, $43, $06
    sprite_oam_piece $02, $04, $42, $06
    sprite_oam_piece $02, $fc, $41, $06
    sprite_oam_piece $02, $f4, $40, $06
    sprite_oam_piece $02, $ec, $3f, $06
    sprite_oam_piece $fa, $04, $3e, $06
    sprite_oam_piece $fa, $fc, $3d, $06
    sprite_oam_piece $fa, $f4, $3c, $06
    sprite_oam_piece $fa, $ec, $3b, $06

SpriteFrame_21_4286::
    db 16
    sprite_oam_piece $09, $0c, $58, $06
    sprite_oam_piece $01, $0c, $53, $06
    sprite_oam_piece $09, $04, $57, $06
    sprite_oam_piece $09, $fc, $56, $06
    sprite_oam_piece $09, $f4, $55, $06
    sprite_oam_piece $09, $ec, $54, $06
    sprite_oam_piece $01, $04, $52, $06
    sprite_oam_piece $01, $fc, $51, $06
    sprite_oam_piece $01, $f4, $50, $06
    sprite_oam_piece $01, $ec, $4f, $06
    sprite_oam_piece $f9, $04, $4e, $06
    sprite_oam_piece $f9, $fc, $4d, $06
    sprite_oam_piece $f9, $f4, $4c, $06
    sprite_oam_piece $f9, $ec, $4b, $06
    sprite_oam_piece $f1, $f4, $4a, $06
    sprite_oam_piece $f1, $ec, $49, $06

SpriteFrame_21_42C7::
    db 12
    sprite_oam_piece $08, $08, $74, $06
    sprite_oam_piece $08, $00, $73, $06
    sprite_oam_piece $08, $f8, $72, $06
    sprite_oam_piece $08, $f0, $71, $06
    sprite_oam_piece $00, $08, $70, $06
    sprite_oam_piece $00, $00, $6f, $06
    sprite_oam_piece $00, $f8, $6e, $06
    sprite_oam_piece $00, $f0, $6d, $06
    sprite_oam_piece $f8, $08, $6c, $06
    sprite_oam_piece $f8, $00, $6b, $06
    sprite_oam_piece $f8, $f8, $6a, $06
    sprite_oam_piece $f8, $f0, $69, $06

SpriteFrame_21_42F8::
    db 16
    sprite_oam_piece $0c, $f8, $66, $06
    sprite_oam_piece $0c, $08, $67, $06
    sprite_oam_piece $0c, $10, $68, $06
    sprite_oam_piece $04, $10, $65, $06
    sprite_oam_piece $04, $08, $64, $06
    sprite_oam_piece $04, $00, $63, $06
    sprite_oam_piece $04, $f8, $62, $06
    sprite_oam_piece $04, $f0, $61, $06
    sprite_oam_piece $fc, $0c, $60, $06
    sprite_oam_piece $fc, $04, $5f, $06
    sprite_oam_piece $fc, $fc, $5e, $06
    sprite_oam_piece $fc, $f4, $5d, $06
    sprite_oam_piece $fc, $ec, $5c, $06
    sprite_oam_piece $f4, $fc, $5b, $06
    sprite_oam_piece $f4, $f4, $5a, $06
    sprite_oam_piece $f4, $ec, $59, $06

SpriteFrame_21_4339::
    db 15
    sprite_oam_piece $02, $0e, $83, $06
    sprite_oam_piece $02, $06, $82, $06
    sprite_oam_piece $02, $fe, $81, $06
    sprite_oam_piece $02, $f6, $80, $06
    sprite_oam_piece $02, $ee, $7f, $06
    sprite_oam_piece $02, $e6, $7e, $06
    sprite_oam_piece $fa, $0e, $7d, $06
    sprite_oam_piece $fa, $06, $7c, $06
    sprite_oam_piece $fa, $fe, $7b, $06
    sprite_oam_piece $fa, $f6, $7a, $06
    sprite_oam_piece $fa, $ee, $79, $06
    sprite_oam_piece $fa, $e6, $78, $06
    sprite_oam_piece $f2, $f6, $5b, $06
    sprite_oam_piece $f2, $ee, $5a, $06
    sprite_oam_piece $f2, $e6, $59, $06

SpriteFrame_21_4376::
    db 2
    sprite_oam_piece $00, $fc, $b9, $06
    sprite_oam_piece $f8, $fc, $b8, $06

SpriteFrame_21_437F::
    db 2
    sprite_oam_piece $00, $fc, $bb, $06
    sprite_oam_piece $f8, $fc, $ba, $06

SpriteFrame_21_4388::
    db 13
    sprite_oam_piece $f7, $03, $b7, $21
    sprite_oam_piece $08, $f4, $aa, $22
    sprite_oam_piece $08, $fc, $a9, $22
    sprite_oam_piece $08, $04, $a8, $22
    sprite_oam_piece $00, $f4, $a7, $22
    sprite_oam_piece $00, $fc, $a6, $22
    sprite_oam_piece $00, $04, $a5, $22
    sprite_oam_piece $f8, $f4, $a4, $23
    sprite_oam_piece $f8, $fc, $a3, $22
    sprite_oam_piece $f8, $04, $a2, $23
    sprite_oam_piece $f0, $f4, $a1, $22
    sprite_oam_piece $f0, $fc, $a0, $22
    sprite_oam_piece $f0, $04, $9f, $22

SpriteFrame_21_43BD::
    db 12
    sprite_oam_piece $f8, $03, $b6, $21
    sprite_oam_piece $0a, $fc, $b5, $22
    sprite_oam_piece $0a, $04, $b4, $22
    sprite_oam_piece $02, $f4, $b3, $22
    sprite_oam_piece $02, $fc, $b2, $22
    sprite_oam_piece $02, $04, $b1, $22
    sprite_oam_piece $fa, $f4, $b0, $23
    sprite_oam_piece $fa, $fc, $af, $22
    sprite_oam_piece $fa, $04, $ae, $23
    sprite_oam_piece $f2, $f4, $ad, $22
    sprite_oam_piece $f2, $fc, $ac, $22
    sprite_oam_piece $f2, $04, $ab, $22

SpriteFrame_21_43EE::
    db 13
    sprite_oam_piece $f7, $03, $b7, $21
    sprite_oam_piece $08, $f4, $9e, $22
    sprite_oam_piece $08, $fc, $9d, $22
    sprite_oam_piece $08, $04, $9c, $22
    sprite_oam_piece $00, $f4, $9b, $23
    sprite_oam_piece $00, $fc, $9a, $22
    sprite_oam_piece $00, $04, $99, $22
    sprite_oam_piece $f8, $f4, $98, $22
    sprite_oam_piece $f8, $fc, $97, $22
    sprite_oam_piece $f8, $04, $96, $23
    sprite_oam_piece $f0, $f4, $95, $22
    sprite_oam_piece $f0, $fc, $94, $22
    sprite_oam_piece $f0, $04, $93, $22

SpriteFrame_21_4423::
    db 12
    sprite_oam_piece $08, $f0, $74, $26
    sprite_oam_piece $08, $f8, $73, $26
    sprite_oam_piece $08, $00, $72, $26
    sprite_oam_piece $08, $08, $71, $26
    sprite_oam_piece $00, $f0, $70, $26
    sprite_oam_piece $00, $f8, $6f, $26
    sprite_oam_piece $00, $00, $6e, $26
    sprite_oam_piece $00, $08, $6d, $26
    sprite_oam_piece $f8, $f0, $6c, $26
    sprite_oam_piece $f8, $f8, $6b, $26
    sprite_oam_piece $f8, $00, $6a, $26
    sprite_oam_piece $f8, $08, $69, $26

SpriteFrame_21_4454::
    db 16
    sprite_oam_piece $0c, $00, $66, $26
    sprite_oam_piece $0c, $f0, $67, $26
    sprite_oam_piece $0c, $e8, $68, $26
    sprite_oam_piece $04, $e8, $65, $26
    sprite_oam_piece $04, $f0, $64, $26
    sprite_oam_piece $04, $f8, $63, $26
    sprite_oam_piece $04, $00, $62, $26
    sprite_oam_piece $04, $08, $61, $26
    sprite_oam_piece $fc, $ec, $60, $26
    sprite_oam_piece $fc, $f4, $5f, $26
    sprite_oam_piece $fc, $fc, $5e, $26
    sprite_oam_piece $fc, $04, $5d, $26
    sprite_oam_piece $fc, $0c, $5c, $26
    sprite_oam_piece $f4, $fc, $5b, $26
    sprite_oam_piece $f4, $04, $5a, $26
    sprite_oam_piece $f4, $0c, $59, $26

SpriteFrame_21_4495::
    db 15
    sprite_oam_piece $02, $ea, $83, $26
    sprite_oam_piece $02, $f2, $82, $26
    sprite_oam_piece $02, $fa, $81, $26
    sprite_oam_piece $02, $02, $80, $26
    sprite_oam_piece $02, $0a, $7f, $26
    sprite_oam_piece $02, $12, $7e, $26
    sprite_oam_piece $fa, $ea, $7d, $26
    sprite_oam_piece $fa, $f2, $7c, $26
    sprite_oam_piece $fa, $fa, $7b, $26
    sprite_oam_piece $fa, $02, $7a, $26
    sprite_oam_piece $fa, $0a, $79, $26
    sprite_oam_piece $fa, $12, $78, $26
    sprite_oam_piece $f2, $02, $5b, $26
    sprite_oam_piece $f2, $0a, $5a, $26
    sprite_oam_piece $f2, $12, $59, $26

SpriteAnimation_201:: ; $21:$44D2
    sprite_anim_entry SpriteFrame_21_4000, $19
    sprite_anim_entry SpriteFrame_21_402D, $14
    sprite_anim_entry SpriteFrame_21_4056, $19
    sprite_anim_entry SpriteFrame_21_402D, $14
    sprite_anim_end

SpriteAnimation_202:: ; $21:$44E0
    sprite_anim_entry SpriteFrame_21_4083, $0f
    sprite_anim_entry SpriteFrame_21_40A8, $0f
    sprite_anim_entry SpriteFrame_21_40D1, $0f
    sprite_anim_entry SpriteFrame_21_40A8, $0f
    sprite_anim_end

SpriteAnimation_203:: ; $21:$44EE
    sprite_anim_entry SpriteFrame_21_40FA, $64
    sprite_anim_entry SpriteFrame_21_412B, $64
    sprite_anim_entry SpriteFrame_21_412B, $ff
    sprite_anim_end

SpriteAnimation_204:: ; $21:$44F9
    sprite_anim_entry SpriteFrame_21_415C, $ff
    sprite_anim_end

SpriteAnimation_205:: ; $21:$44FE
    sprite_anim_entry SpriteFrame_21_418D, $ff
    sprite_anim_end

SpriteAnimation_206:: ; $21:$4503
    sprite_anim_entry SpriteFrame_21_41B2, $0a
    sprite_anim_entry SpriteFrame_21_41E7, $0a
    sprite_anim_entry SpriteFrame_21_4218, $0a
    sprite_anim_entry SpriteFrame_21_41E7, $0a
    sprite_anim_end

SpriteAnimation_207:: ; $21:$4511
    sprite_anim_entry SpriteFrame_21_424D, $ff
    sprite_anim_end

SpriteAnimation_208:: ; $21:$4516
    sprite_anim_entry SpriteFrame_21_424D, $3c
    sprite_anim_entry SpriteFrame_21_4286, $32
    sprite_anim_entry SpriteFrame_21_42C7, $0f
    sprite_anim_entry SpriteFrame_21_42F8, $0f
    sprite_anim_entry SpriteFrame_21_42F8, $37
    sprite_anim_end

SpriteAnimation_209:: ; $21:$4527
    sprite_anim_entry SpriteFrame_21_42C7, $0a
    sprite_anim_entry SpriteFrame_21_42F8, $08
    sprite_anim_entry SpriteFrame_21_4339, $0a
    sprite_anim_entry SpriteFrame_21_42F8, $08
    sprite_anim_end

SpriteAnimation_210:: ; $21:$4535
    sprite_anim_entry SpriteFrame_21_4376, $0d
    sprite_anim_entry SpriteFrame_21_437F, $0d
    sprite_anim_end

SpriteAnimation_221:: ; $21:$453D
    sprite_anim_entry SpriteFrame_21_4388, $0a
    sprite_anim_entry SpriteFrame_21_43BD, $0a
    sprite_anim_entry SpriteFrame_21_43EE, $0a
    sprite_anim_entry SpriteFrame_21_43BD, $0a
    sprite_anim_end

SpriteAnimation_222:: ; $21:$454B
    sprite_anim_entry SpriteFrame_21_4423, $0a
    sprite_anim_entry SpriteFrame_21_4454, $08
    sprite_anim_entry SpriteFrame_21_4495, $0a
    sprite_anim_entry SpriteFrame_21_4454, $08
    sprite_anim_end

assert @ == $4559

section "Sprite Animation Data 21:5171", romx[$5171], bank[$21]

SpriteFrame_21_5171::
    db 12
    sprite_oam_piece $02, $fe, $58, $03
    sprite_oam_piece $09, $04, $0a, $02
    sprite_oam_piece $09, $fb, $09, $02
    sprite_oam_piece $01, $04, $08, $02
    sprite_oam_piece $01, $fc, $07, $02
    sprite_oam_piece $01, $f4, $06, $03
    sprite_oam_piece $f9, $04, $05, $03
    sprite_oam_piece $f9, $fc, $04, $02
    sprite_oam_piece $f9, $f4, $03, $03
    sprite_oam_piece $f1, $04, $02, $02
    sprite_oam_piece $f1, $fc, $01, $02
    sprite_oam_piece $f1, $f4, $00, $02

SpriteFrame_21_51A2::
    db 11
    sprite_oam_piece $f0, $04, $02, $02
    sprite_oam_piece $f0, $fc, $01, $02
    sprite_oam_piece $f0, $f4, $00, $02
    sprite_oam_piece $02, $fb, $58, $03
    sprite_oam_piece $08, $ff, $11, $02
    sprite_oam_piece $00, $04, $10, $02
    sprite_oam_piece $00, $fc, $0f, $02
    sprite_oam_piece $00, $f4, $0e, $03
    sprite_oam_piece $f8, $04, $0d, $02
    sprite_oam_piece $f8, $fc, $0c, $02
    sprite_oam_piece $f8, $f4, $0b, $03

SpriteFrame_21_51CF::
    db 12
    sprite_oam_piece $f1, $04, $02, $02
    sprite_oam_piece $f1, $fc, $01, $02
    sprite_oam_piece $f1, $f4, $00, $02
    sprite_oam_piece $02, $f9, $58, $03
    sprite_oam_piece $09, $04, $19, $02
    sprite_oam_piece $09, $fc, $18, $02
    sprite_oam_piece $01, $04, $17, $02
    sprite_oam_piece $01, $fc, $16, $02
    sprite_oam_piece $01, $f4, $15, $03
    sprite_oam_piece $f9, $04, $14, $02
    sprite_oam_piece $f9, $fc, $13, $02
    sprite_oam_piece $f9, $f4, $12, $03

SpriteFrame_21_5200::
    db 12
    sprite_oam_piece $08, $04, $25, $02
    sprite_oam_piece $08, $fc, $24, $02
    sprite_oam_piece $08, $f4, $23, $02
    sprite_oam_piece $00, $04, $22, $02
    sprite_oam_piece $00, $fc, $21, $02
    sprite_oam_piece $00, $f4, $20, $02
    sprite_oam_piece $f8, $04, $1f, $03
    sprite_oam_piece $f8, $fc, $1e, $03
    sprite_oam_piece $f8, $f4, $1d, $03
    sprite_oam_piece $f0, $04, $1c, $02
    sprite_oam_piece $f0, $fc, $1b, $02
    sprite_oam_piece $f0, $f4, $1a, $02

SpriteFrame_21_5231::
    db 12
    sprite_oam_piece $ec, $04, $1c, $02
    sprite_oam_piece $ec, $fc, $1b, $02
    sprite_oam_piece $ec, $f4, $1a, $02
    sprite_oam_piece $04, $04, $2e, $02
    sprite_oam_piece $04, $fc, $2d, $02
    sprite_oam_piece $04, $f4, $2c, $02
    sprite_oam_piece $fc, $04, $2b, $02
    sprite_oam_piece $fc, $fc, $2a, $02
    sprite_oam_piece $fc, $f4, $29, $02
    sprite_oam_piece $f4, $04, $28, $03
    sprite_oam_piece $f4, $fc, $27, $03
    sprite_oam_piece $f4, $f4, $26, $03

SpriteFrame_21_5262::
    db 13
    sprite_oam_piece $00, $06, $59, $03
    sprite_oam_piece $08, $03, $3a, $02
    sprite_oam_piece $08, $fb, $39, $02
    sprite_oam_piece $08, $f3, $38, $02
    sprite_oam_piece $00, $03, $37, $02
    sprite_oam_piece $00, $fb, $36, $02
    sprite_oam_piece $00, $f3, $35, $03
    sprite_oam_piece $f8, $03, $34, $03
    sprite_oam_piece $f8, $fb, $33, $03
    sprite_oam_piece $f8, $f3, $32, $03
    sprite_oam_piece $f0, $03, $31, $02
    sprite_oam_piece $f0, $fb, $30, $02
    sprite_oam_piece $f0, $f3, $2f, $02

SpriteFrame_21_5297::
    db 13
    sprite_oam_piece $00, $f5, $59, $03
    sprite_oam_piece $08, $f6, $3a, $22
    sprite_oam_piece $08, $fe, $39, $22
    sprite_oam_piece $08, $06, $38, $22
    sprite_oam_piece $00, $f6, $37, $22
    sprite_oam_piece $00, $fe, $36, $22
    sprite_oam_piece $00, $06, $35, $23
    sprite_oam_piece $f8, $f6, $34, $23
    sprite_oam_piece $f8, $fe, $33, $23
    sprite_oam_piece $f8, $06, $32, $23
    sprite_oam_piece $f0, $f6, $31, $22
    sprite_oam_piece $f0, $fe, $30, $22
    sprite_oam_piece $f0, $06, $2f, $22

SpriteFrame_21_52CC::
    db 11
    sprite_oam_piece $f0, $02, $31, $02
    sprite_oam_piece $f0, $fa, $30, $02
    sprite_oam_piece $f0, $f2, $2f, $02
    sprite_oam_piece $02, $ff, $5a, $03
    sprite_oam_piece $08, $fd, $41, $02
    sprite_oam_piece $00, $06, $40, $02
    sprite_oam_piece $00, $fe, $3f, $02
    sprite_oam_piece $00, $f6, $3e, $03
    sprite_oam_piece $f8, $06, $3d, $03
    sprite_oam_piece $f8, $fe, $3c, $02
    sprite_oam_piece $f8, $f6, $3b, $03

SpriteFrame_21_52F9::
    db 11
    sprite_oam_piece $08, $fd, $41, $02
    sprite_oam_piece $02, $01, $5a, $03
    sprite_oam_piece $00, $06, $4a, $02
    sprite_oam_piece $00, $fe, $49, $02
    sprite_oam_piece $00, $f6, $48, $02
    sprite_oam_piece $f8, $06, $47, $03
    sprite_oam_piece $f8, $fe, $46, $03
    sprite_oam_piece $f8, $f6, $45, $03
    sprite_oam_piece $f0, $06, $44, $02
    sprite_oam_piece $f0, $fe, $43, $02
    sprite_oam_piece $f0, $f6, $42, $03

SpriteFrame_21_5326::
    db 11
    sprite_oam_piece $07, $fe, $51, $02
    sprite_oam_piece $f7, $06, $47, $03
    sprite_oam_piece $ef, $06, $44, $02
    sprite_oam_piece $ef, $fe, $43, $02
    sprite_oam_piece $ff, $03, $5b, $03
    sprite_oam_piece $ff, $06, $50, $02
    sprite_oam_piece $ff, $fe, $4f, $02
    sprite_oam_piece $ff, $f6, $4e, $02
    sprite_oam_piece $f7, $fe, $4d, $03
    sprite_oam_piece $f7, $f6, $4c, $03
    sprite_oam_piece $ef, $f6, $4b, $03

SpriteFrame_21_5353::
    db 8
    sprite_oam_piece $08, $00, $55, $22
    sprite_oam_piece $00, $00, $54, $22
    sprite_oam_piece $f8, $00, $53, $22
    sprite_oam_piece $f0, $00, $52, $22
    sprite_oam_piece $08, $f8, $55, $02
    sprite_oam_piece $00, $f8, $54, $02
    sprite_oam_piece $f8, $f8, $53, $02
    sprite_oam_piece $f0, $f8, $52, $02

SpriteFrame_21_5374::
    db 8
    sprite_oam_piece $f8, $00, $57, $22
    sprite_oam_piece $f0, $00, $56, $22
    sprite_oam_piece $f8, $f8, $57, $02
    sprite_oam_piece $f0, $f8, $56, $02
    sprite_oam_piece $08, $00, $55, $22
    sprite_oam_piece $00, $00, $54, $22
    sprite_oam_piece $08, $f8, $55, $02
    sprite_oam_piece $00, $f8, $54, $02

SpriteAnimation_211:: ; $21:$5395
    sprite_anim_entry SpriteFrame_21_5171, $19
    sprite_anim_entry SpriteFrame_21_51A2, $19
    sprite_anim_entry SpriteFrame_21_51CF, $19
    sprite_anim_entry SpriteFrame_21_51A2, $19
    sprite_anim_end

SpriteAnimation_212:: ; $21:$53A3
    sprite_anim_entry SpriteFrame_21_5200, $0a
    sprite_anim_entry SpriteFrame_21_5231, $14
    sprite_anim_entry SpriteFrame_21_5200, $0a
    sprite_anim_entry SpriteFrame_21_5200, $ff
    sprite_anim_end

SpriteAnimation_213:: ; $21:$53B1
    sprite_anim_entry SpriteFrame_21_5200, $0a
    sprite_anim_entry SpriteFrame_21_5262, $2d
    sprite_anim_entry SpriteFrame_21_5200, $0a
    sprite_anim_entry SpriteFrame_21_5297, $2d
    sprite_anim_end

SpriteAnimation_214:: ; $21:$53BF
    sprite_anim_entry SpriteFrame_21_52CC, $28
    sprite_anim_entry SpriteFrame_21_52F9, $41
    sprite_anim_entry SpriteFrame_21_5326, $64
    sprite_anim_entry SpriteFrame_21_5326, $ff
    sprite_anim_end

SpriteAnimation_215:: ; $21:$53CD
    sprite_anim_entry SpriteFrame_21_5353, $32
    sprite_anim_entry SpriteFrame_21_5374, $ff
    sprite_anim_end

SpriteAnimation_217:: ; $21:$53D5
    sprite_anim_entry SpriteFrame_21_5262, $ff
    sprite_anim_end

SpriteAnimation_218:: ; $21:$53DA
    sprite_anim_entry SpriteFrame_21_5262, $0a
    sprite_anim_entry SpriteFrame_21_52CC, $1e
    sprite_anim_entry SpriteFrame_21_5353, $32
    sprite_anim_entry SpriteFrame_21_5374, $ff
    sprite_anim_end

assert @ == $53e8

section "Sprite Animation Data 22:5BE0", romx[$5be0], bank[$22]

SpriteFrame_22_5BE0::
    db 10
    sprite_oam_piece $fd, $02, $12, $06
    sprite_oam_piece $ff, $fa, $11, $06
    sprite_oam_piece $f5, $05, $0f, $07
    sprite_oam_piece $04, $01, $06, $02
    sprite_oam_piece $04, $f9, $05, $02
    sprite_oam_piece $fc, $01, $04, $02
    sprite_oam_piece $fc, $f9, $03, $02
    sprite_oam_piece $f4, $09, $02, $02
    sprite_oam_piece $f4, $01, $01, $02
    sprite_oam_piece $f4, $f9, $00, $02

SpriteFrame_22_5C09::
    db 9
    sprite_oam_piece $ff, $fa, $14, $06
    sprite_oam_piece $fc, $fd, $13, $06
    sprite_oam_piece $f4, $fe, $10, $07
    sprite_oam_piece $04, $01, $06, $02
    sprite_oam_piece $04, $f9, $05, $02
    sprite_oam_piece $fc, $ff, $0a, $02
    sprite_oam_piece $fc, $f7, $09, $02
    sprite_oam_piece $f4, $fe, $08, $02
    sprite_oam_piece $f4, $f6, $07, $02

SpriteFrame_22_5C2E::
    db 9
    sprite_oam_piece $f5, $f8, $0f, $27
    sprite_oam_piece $ff, $fa, $14, $06
    sprite_oam_piece $fc, $fc, $15, $06
    sprite_oam_piece $04, $01, $06, $02
    sprite_oam_piece $04, $f9, $05, $02
    sprite_oam_piece $fc, $ff, $0e, $02
    sprite_oam_piece $fc, $f7, $0d, $02
    sprite_oam_piece $f4, $ff, $0c, $02
    sprite_oam_piece $f4, $f7, $0b, $02

SpriteAnimation_YieldingInfantry::
SpriteAnimation_216:: ; $22:$5C53
    sprite_anim_entry SpriteFrame_22_5BE0, $11
    sprite_anim_entry SpriteFrame_22_5C09, $0d
    sprite_anim_entry SpriteFrame_22_5C2E, $11
    sprite_anim_entry SpriteFrame_22_5C09, $0d
    sprite_anim_end

assert @ == $5c61

section "Sprite Animation Data 26:4000", romx[$4000], bank[$26]

SpriteFrame_26_4000::
    db 25
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_4065::
    db 26
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_40CE::
    db 25
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_26_4133::
    db 30
    sprite_oam_piece $00, $f8, $33, $21
    sprite_oam_piece $00, $e8, $33, $01
    sprite_oam_piece $08, $f0, $32, $41
    sprite_oam_piece $f8, $f0, $32, $01
    sprite_oam_piece $00, $f0, $34, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_41AC::
    db 35
    sprite_oam_piece $08, $f0, $36, $41
    sprite_oam_piece $f8, $f0, $36, $01
    sprite_oam_piece $08, $f8, $35, $61
    sprite_oam_piece $08, $e8, $35, $41
    sprite_oam_piece $f8, $f8, $35, $21
    sprite_oam_piece $f8, $e8, $35, $01
    sprite_oam_piece $00, $f8, $37, $21
    sprite_oam_piece $00, $e8, $37, $01
    sprite_oam_piece $00, $f0, $38, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_4239::
    db 33
    sprite_oam_piece $08, $f8, $39, $61
    sprite_oam_piece $08, $e8, $39, $41
    sprite_oam_piece $f8, $f8, $39, $21
    sprite_oam_piece $f8, $e8, $39, $01
    sprite_oam_piece $00, $f8, $3b, $21
    sprite_oam_piece $00, $e8, $3b, $01
    sprite_oam_piece $08, $f0, $3a, $41
    sprite_oam_piece $f8, $f0, $3a, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_26_42BE::
    db 30
    sprite_oam_piece $f0, $00, $33, $21
    sprite_oam_piece $f0, $f0, $33, $01
    sprite_oam_piece $f8, $f8, $32, $41
    sprite_oam_piece $e8, $f8, $32, $01
    sprite_oam_piece $f0, $f8, $34, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_4337::
    db 35
    sprite_oam_piece $f0, $00, $37, $21
    sprite_oam_piece $f0, $f0, $37, $01
    sprite_oam_piece $f8, $00, $35, $61
    sprite_oam_piece $f8, $f0, $35, $41
    sprite_oam_piece $e8, $00, $35, $21
    sprite_oam_piece $e8, $f0, $35, $01
    sprite_oam_piece $f8, $f8, $36, $41
    sprite_oam_piece $e8, $f8, $36, $01
    sprite_oam_piece $f0, $f8, $38, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_43C4::
    db 33
    sprite_oam_piece $f0, $00, $3b, $21
    sprite_oam_piece $f0, $f0, $3b, $01
    sprite_oam_piece $f8, $00, $39, $61
    sprite_oam_piece $e8, $00, $39, $21
    sprite_oam_piece $f8, $f0, $39, $41
    sprite_oam_piece $e8, $f0, $39, $01
    sprite_oam_piece $f8, $f8, $3a, $41
    sprite_oam_piece $e8, $f8, $3a, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_26_4449::
    db 30
    sprite_oam_piece $00, $10, $33, $21
    sprite_oam_piece $00, $00, $33, $01
    sprite_oam_piece $08, $08, $32, $41
    sprite_oam_piece $f8, $08, $32, $01
    sprite_oam_piece $00, $08, $34, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_44C2::
    db 35
    sprite_oam_piece $08, $08, $36, $41
    sprite_oam_piece $f8, $08, $36, $01
    sprite_oam_piece $f8, $10, $35, $21
    sprite_oam_piece $08, $10, $35, $61
    sprite_oam_piece $08, $00, $35, $41
    sprite_oam_piece $f8, $00, $35, $01
    sprite_oam_piece $00, $10, $37, $21
    sprite_oam_piece $00, $00, $37, $01
    sprite_oam_piece $00, $08, $38, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_454F::
    db 33
    sprite_oam_piece $00, $10, $3b, $21
    sprite_oam_piece $00, $00, $3b, $01
    sprite_oam_piece $08, $08, $3a, $41
    sprite_oam_piece $f8, $08, $3a, $01
    sprite_oam_piece $08, $10, $39, $61
    sprite_oam_piece $08, $00, $39, $41
    sprite_oam_piece $f8, $10, $39, $21
    sprite_oam_piece $f8, $00, $39, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_26_45D4::
    db 30
    sprite_oam_piece $f0, $f8, $33, $21
    sprite_oam_piece $f0, $e8, $33, $01
    sprite_oam_piece $f8, $f0, $32, $41
    sprite_oam_piece $e8, $f0, $32, $01
    sprite_oam_piece $f0, $f0, $34, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_464D::
    db 35
    sprite_oam_piece $f8, $f0, $36, $41
    sprite_oam_piece $e8, $f0, $36, $01
    sprite_oam_piece $f8, $f8, $35, $61
    sprite_oam_piece $f8, $e8, $35, $41
    sprite_oam_piece $e8, $f8, $35, $21
    sprite_oam_piece $e8, $e8, $35, $01
    sprite_oam_piece $f0, $f8, $37, $21
    sprite_oam_piece $f0, $e8, $37, $01
    sprite_oam_piece $f0, $f0, $38, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_46DA::
    db 33
    sprite_oam_piece $f8, $f8, $39, $61
    sprite_oam_piece $f8, $e8, $39, $41
    sprite_oam_piece $e8, $f8, $39, $21
    sprite_oam_piece $e8, $e8, $39, $01
    sprite_oam_piece $f0, $f8, $3b, $21
    sprite_oam_piece $f0, $e8, $3b, $01
    sprite_oam_piece $f8, $f0, $3a, $41
    sprite_oam_piece $e8, $f0, $3a, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_26_475F::
    db 30
    sprite_oam_piece $00, $08, $33, $21
    sprite_oam_piece $00, $f8, $33, $01
    sprite_oam_piece $08, $00, $32, $41
    sprite_oam_piece $f8, $00, $32, $01
    sprite_oam_piece $00, $00, $34, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_47D8::
    db 35
    sprite_oam_piece $f8, $08, $35, $21
    sprite_oam_piece $08, $08, $35, $61
    sprite_oam_piece $08, $f8, $35, $41
    sprite_oam_piece $f8, $f8, $35, $01
    sprite_oam_piece $08, $00, $36, $41
    sprite_oam_piece $f8, $00, $36, $01
    sprite_oam_piece $00, $08, $37, $21
    sprite_oam_piece $00, $f8, $37, $01
    sprite_oam_piece $00, $00, $38, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_4865::
    db 33
    sprite_oam_piece $f8, $08, $39, $21
    sprite_oam_piece $08, $08, $39, $61
    sprite_oam_piece $08, $f8, $39, $41
    sprite_oam_piece $f8, $f8, $39, $01
    sprite_oam_piece $00, $08, $3b, $21
    sprite_oam_piece $00, $f8, $3b, $01
    sprite_oam_piece $08, $00, $3a, $41
    sprite_oam_piece $f8, $00, $3a, $01
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_26_48EA::
    db 26
    sprite_oam_piece $f0, $08, $3c, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_4953::
    db 28
    sprite_oam_piece $ed, $0b, $3d, $06
    sprite_oam_piece $f8, $08, $3c, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_49C4::
    db 30
    sprite_oam_piece $ee, $11, $41, $06
    sprite_oam_piece $ee, $09, $40, $06
    sprite_oam_piece $e6, $11, $3f, $06
    sprite_oam_piece $e6, $09, $3e, $06
    sprite_oam_piece $f5, $0a, $3d, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_26_4A3D::
    db 34
    sprite_oam_piece $ea, $14, $45, $06
    sprite_oam_piece $ea, $0c, $44, $06
    sprite_oam_piece $e2, $14, $43, $06
    sprite_oam_piece $e2, $0c, $42, $06
    sprite_oam_piece $f8, $10, $41, $06
    sprite_oam_piece $f8, $08, $40, $06
    sprite_oam_piece $f0, $10, $3f, $06
    sprite_oam_piece $f0, $08, $3e, $06
    sprite_oam_piece $f0, $f8, $3c, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_4AC6::
    db 36
    sprite_oam_piece $f5, $13, $45, $06
    sprite_oam_piece $f5, $0b, $44, $06
    sprite_oam_piece $ed, $13, $43, $06
    sprite_oam_piece $ed, $0b, $42, $06
    sprite_oam_piece $e6, $18, $41, $06
    sprite_oam_piece $e6, $10, $40, $06
    sprite_oam_piece $de, $18, $3f, $06
    sprite_oam_piece $de, $10, $3e, $06
    sprite_oam_piece $ee, $fa, $3d, $06
    sprite_oam_piece $00, $00, $3c, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_4B57::
    db 35
    sprite_oam_piece $f0, $15, $41, $06
    sprite_oam_piece $f0, $0d, $40, $06
    sprite_oam_piece $e8, $15, $3f, $06
    sprite_oam_piece $e8, $0d, $3e, $06
    sprite_oam_piece $f0, $00, $41, $06
    sprite_oam_piece $f0, $f8, $40, $06
    sprite_oam_piece $e8, $00, $3f, $06
    sprite_oam_piece $e8, $f8, $3e, $06
    sprite_oam_piece $dd, $16, $3d, $06
    sprite_oam_piece $fe, $02, $3d, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_26_4BE4::
    db 35
    sprite_oam_piece $ed, $02, $45, $06
    sprite_oam_piece $ed, $fa, $44, $06
    sprite_oam_piece $e5, $02, $43, $06
    sprite_oam_piece $e5, $fa, $42, $06
    sprite_oam_piece $00, $08, $41, $06
    sprite_oam_piece $00, $00, $40, $06
    sprite_oam_piece $f8, $08, $3f, $06
    sprite_oam_piece $f8, $00, $3e, $06
    sprite_oam_piece $e8, $13, $3d, $06
    sprite_oam_piece $f0, $f0, $3c, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_4C71::
    db 35
    sprite_oam_piece $fd, $0b, $45, $06
    sprite_oam_piece $fd, $03, $44, $06
    sprite_oam_piece $f5, $0b, $43, $06
    sprite_oam_piece $f5, $03, $42, $06
    sprite_oam_piece $e8, $04, $41, $06
    sprite_oam_piece $e8, $fc, $40, $06
    sprite_oam_piece $e0, $04, $3f, $06
    sprite_oam_piece $e0, $fc, $3e, $06
    sprite_oam_piece $ee, $f2, $3d, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_4CFE::
    db 34
    sprite_oam_piece $f8, $0d, $41, $06
    sprite_oam_piece $f8, $05, $40, $06
    sprite_oam_piece $f0, $0d, $3f, $06
    sprite_oam_piece $f0, $05, $3e, $06
    sprite_oam_piece $f0, $f8, $41, $06
    sprite_oam_piece $f0, $f0, $40, $06
    sprite_oam_piece $e8, $f8, $3f, $06
    sprite_oam_piece $e8, $f0, $3e, $06
    sprite_oam_piece $df, $02, $3d, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteFrame_26_4D87::
    db 30
    sprite_oam_piece $ed, $fa, $45, $06
    sprite_oam_piece $ed, $f2, $44, $06
    sprite_oam_piece $e5, $fa, $43, $06
    sprite_oam_piece $e5, $f2, $42, $06
    sprite_oam_piece $f0, $0b, $3d, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $0c, $0c, $02
    sprite_oam_piece $f0, $04, $0b, $02
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $f4, $09, $02
    sprite_oam_piece $f0, $ec, $08, $02
    sprite_oam_piece $f0, $e4, $07, $02
    sprite_oam_piece $e8, $14, $06, $02
    sprite_oam_piece $e8, $0c, $05, $02
    sprite_oam_piece $e8, $04, $04, $02
    sprite_oam_piece $e8, $fc, $03, $02
    sprite_oam_piece $e8, $f4, $02, $02
    sprite_oam_piece $e8, $ec, $01, $02
    sprite_oam_piece $e8, $e4, $00, $02

SpriteFrame_26_4E00::
    db 30
    sprite_oam_piece $eb, $fb, $41, $06
    sprite_oam_piece $eb, $f3, $40, $06
    sprite_oam_piece $e3, $fb, $3f, $06
    sprite_oam_piece $e3, $f3, $3e, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $fc, $0a, $02
    sprite_oam_piece $f0, $14, $25, $02
    sprite_oam_piece $f0, $0c, $24, $02
    sprite_oam_piece $f0, $04, $23, $02
    sprite_oam_piece $f0, $f4, $22, $02
    sprite_oam_piece $f0, $ec, $21, $02
    sprite_oam_piece $f0, $e4, $20, $02
    sprite_oam_piece $e8, $14, $1f, $02
    sprite_oam_piece $e8, $0c, $1e, $02
    sprite_oam_piece $e8, $04, $1d, $02
    sprite_oam_piece $e8, $fc, $1c, $02
    sprite_oam_piece $e8, $f4, $1b, $02
    sprite_oam_piece $e8, $ec, $1a, $02
    sprite_oam_piece $e8, $e4, $19, $02

SpriteFrame_26_4E79::
    db 26
    sprite_oam_piece $e3, $fa, $3d, $06
    sprite_oam_piece $00, $0c, $18, $02
    sprite_oam_piece $00, $04, $17, $02
    sprite_oam_piece $00, $fc, $16, $02
    sprite_oam_piece $00, $f4, $15, $02
    sprite_oam_piece $00, $ec, $14, $05
    sprite_oam_piece $00, $e4, $13, $05
    sprite_oam_piece $f8, $0c, $12, $05
    sprite_oam_piece $f8, $04, $11, $05
    sprite_oam_piece $f8, $fc, $10, $05
    sprite_oam_piece $f8, $f4, $0f, $02
    sprite_oam_piece $f8, $ec, $0e, $05
    sprite_oam_piece $f8, $e4, $0d, $04
    sprite_oam_piece $f0, $04, $0a, $02
    sprite_oam_piece $f0, $0c, $31, $02
    sprite_oam_piece $f0, $fc, $30, $02
    sprite_oam_piece $f0, $f4, $2f, $02
    sprite_oam_piece $f0, $ec, $2e, $02
    sprite_oam_piece $f0, $e4, $2d, $02
    sprite_oam_piece $e8, $14, $2c, $02
    sprite_oam_piece $e8, $0c, $2b, $02
    sprite_oam_piece $e8, $04, $2a, $02
    sprite_oam_piece $e8, $fc, $29, $02
    sprite_oam_piece $e8, $f4, $28, $02
    sprite_oam_piece $e8, $ec, $27, $02
    sprite_oam_piece $e8, $e4, $26, $02

SpriteAnimation_183:: ; $26:$4EE2
    sprite_anim_entry SpriteFrame_26_4000, $01
    sprite_anim_end

SpriteAnimation_184:: ; $26:$4EE7
    sprite_anim_entry SpriteFrame_26_4000, $02
    sprite_anim_entry SpriteFrame_26_4065, $02
    sprite_anim_entry SpriteFrame_26_40CE, $02
    sprite_anim_end

SpriteAnimation_185:: ; $26:$4EF2
    sprite_anim_entry SpriteFrame_26_4000, $0c
    sprite_anim_entry SpriteFrame_26_4065, $0c
    sprite_anim_entry SpriteFrame_26_40CE, $0b
    sprite_anim_entry SpriteFrame_26_4000, $0b
    sprite_anim_entry SpriteFrame_26_4065, $0a
    sprite_anim_entry SpriteFrame_26_40CE, $0a
    sprite_anim_entry SpriteFrame_26_4000, $09
    sprite_anim_entry SpriteFrame_26_4065, $09
    sprite_anim_entry SpriteFrame_26_40CE, $08
    sprite_anim_entry SpriteFrame_26_4000, $08
    sprite_anim_entry SpriteFrame_26_4065, $07
    sprite_anim_entry SpriteFrame_26_40CE, $07
    sprite_anim_entry SpriteFrame_26_4000, $06
    sprite_anim_entry SpriteFrame_26_4065, $06
    sprite_anim_entry SpriteFrame_26_40CE, $05
    sprite_anim_entry SpriteFrame_26_4000, $05
    sprite_anim_entry SpriteFrame_26_4065, $04
    sprite_anim_entry SpriteFrame_26_40CE, $04
    sprite_anim_entry SpriteFrame_26_4000, $03
    sprite_anim_entry SpriteFrame_26_4065, $03
    sprite_anim_entry SpriteFrame_26_40CE, $02
    sprite_anim_end

SpriteAnimation_219:: ; $26:$4F33
    sprite_anim_entry SpriteFrame_26_4133, $02
    sprite_anim_entry SpriteFrame_26_41AC, $02
    sprite_anim_entry SpriteFrame_26_4239, $02
    sprite_anim_entry SpriteFrame_26_42BE, $02
    sprite_anim_entry SpriteFrame_26_4337, $02
    sprite_anim_entry SpriteFrame_26_43C4, $02
    sprite_anim_entry SpriteFrame_26_4449, $02
    sprite_anim_entry SpriteFrame_26_44C2, $02
    sprite_anim_entry SpriteFrame_26_454F, $02
    sprite_anim_entry SpriteFrame_26_45D4, $02
    sprite_anim_entry SpriteFrame_26_464D, $02
    sprite_anim_entry SpriteFrame_26_46DA, $02
    sprite_anim_entry SpriteFrame_26_475F, $02
    sprite_anim_entry SpriteFrame_26_47D8, $02
    sprite_anim_entry SpriteFrame_26_4865, $02
    sprite_anim_entry SpriteFrame_26_48EA, $02
    sprite_anim_entry SpriteFrame_26_4953, $02
    sprite_anim_entry SpriteFrame_26_49C4, $02
    sprite_anim_entry SpriteFrame_26_4A3D, $02
    sprite_anim_entry SpriteFrame_26_4AC6, $02
    sprite_anim_entry SpriteFrame_26_4B57, $02
    sprite_anim_entry SpriteFrame_26_4BE4, $02
    sprite_anim_entry SpriteFrame_26_4C71, $02
    sprite_anim_entry SpriteFrame_26_4CFE, $02
    sprite_anim_entry SpriteFrame_26_4D87, $02
    sprite_anim_entry SpriteFrame_26_4E00, $02
    sprite_anim_entry SpriteFrame_26_4E79, $02
    sprite_anim_entry SpriteFrame_26_48EA, $02
    sprite_anim_entry SpriteFrame_26_4953, $02
    sprite_anim_entry SpriteFrame_26_49C4, $02
    sprite_anim_entry SpriteFrame_26_4A3D, $02
    sprite_anim_entry SpriteFrame_26_4AC6, $02
    sprite_anim_entry SpriteFrame_26_4B57, $02
    sprite_anim_entry SpriteFrame_26_4BE4, $02
    sprite_anim_entry SpriteFrame_26_4C71, $02
    sprite_anim_entry SpriteFrame_26_4CFE, $02
    sprite_anim_entry SpriteFrame_26_4D87, $02
    sprite_anim_entry SpriteFrame_26_4E00, $02
    sprite_anim_entry SpriteFrame_26_4E79, $02
    sprite_anim_entry SpriteFrame_26_48EA, $02
    sprite_anim_entry SpriteFrame_26_4953, $02
    sprite_anim_entry SpriteFrame_26_49C4, $02
    sprite_anim_entry SpriteFrame_26_4A3D, $02
    sprite_anim_entry SpriteFrame_26_4AC6, $02
    sprite_anim_entry SpriteFrame_26_4B57, $02
    sprite_anim_entry SpriteFrame_26_4BE4, $02
    sprite_anim_entry SpriteFrame_26_4C71, $02
    sprite_anim_entry SpriteFrame_26_4CFE, $02
    sprite_anim_entry SpriteFrame_26_4D87, $02
    sprite_anim_entry SpriteFrame_26_4E00, $02
    sprite_anim_entry SpriteFrame_26_4E79, $02
    sprite_anim_entry SpriteFrame_26_48EA, $02
    sprite_anim_entry SpriteFrame_26_4953, $02
    sprite_anim_entry SpriteFrame_26_49C4, $02
    sprite_anim_entry SpriteFrame_26_4A3D, $02
    sprite_anim_entry SpriteFrame_26_4AC6, $02
    sprite_anim_entry SpriteFrame_26_4B57, $02
    sprite_anim_entry SpriteFrame_26_4BE4, $02
    sprite_anim_entry SpriteFrame_26_4C71, $02
    sprite_anim_entry SpriteFrame_26_4CFE, $02
    sprite_anim_entry SpriteFrame_26_4D87, $02
    sprite_anim_entry SpriteFrame_26_4E00, $02
    sprite_anim_entry SpriteFrame_26_4E79, $02
    sprite_anim_end

assert @ == $4ff2

section "Sprite Animation Data 27:5195", romx[$5195], bank[$27]

SpriteFrame_27_5195::
    db 10
    sprite_oam_piece $fc, $24, $00, $00
    sprite_oam_piece $fc, $1c, $00, $00
    sprite_oam_piece $fc, $14, $00, $00
    sprite_oam_piece $fc, $0c, $00, $00
    sprite_oam_piece $fc, $04, $00, $00
    sprite_oam_piece $fc, $f4, $00, $00
    sprite_oam_piece $fc, $ec, $00, $00
    sprite_oam_piece $fc, $e4, $00, $00
    sprite_oam_piece $fc, $dc, $00, $00
    sprite_oam_piece $fc, $d4, $00, $00

SpriteFrame_27_51BE::
    db 10
    sprite_oam_piece $fc, $24, $05, $00
    sprite_oam_piece $fc, $1c, $02, $00
    sprite_oam_piece $fc, $14, $06, $00
    sprite_oam_piece $fc, $0c, $05, $00
    sprite_oam_piece $fc, $04, $04, $00
    sprite_oam_piece $fc, $f4, $04, $00
    sprite_oam_piece $fc, $ec, $04, $00
    sprite_oam_piece $fc, $e4, $03, $00
    sprite_oam_piece $fc, $dc, $02, $00
    sprite_oam_piece $fc, $d4, $01, $00

SpriteAnimation_PressStart::
SpriteAnimation_220:: ; $27:$51E7
    sprite_anim_entry SpriteFrame_27_5195, $1e
    sprite_anim_entry SpriteFrame_27_51BE, $1e
    sprite_anim_end

assert @ == $51ef
