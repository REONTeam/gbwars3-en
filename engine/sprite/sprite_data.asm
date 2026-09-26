include "macros/macros.inc"
include "constants/sprite_constants.inc"

; Bank $1A sprite lookup and graphics-group data.
; Byte-authoritative to the Japanese retail ROM while preserving the custom English build.
;
; The fixed-bank sprite engine stores only a ROM bank + pointer to an animation
; metadata stream. This bank owns the central lookup tables that translate a
; sprite/animation ID into that far pointer and, for unit sprites, select the
; graphics group that must be uploaded to VRAM first.

DEF SPRITE_ANIMATION_POINTER_COUNT EQU 223
DEF SPRITE_GROUP_COUNT EQU 30
DEF UNIT_SPRITE_DEFINITION_COUNT EQU 52

macro sprite_farptr
    dw \1
    if _NARG == 1
        db BANK(\1)
    else
        db \2
    endc
endm

macro sprite_group
    dw \1 ; graphics pointer
    dw \2 ; palette pointer, variant 0
    dw \3 ; palette pointer, variant 1
    dw \4 ; graphics byte count
    db \5 ; source ROM bank
endm

macro unit_sprite
    db \1 ; graphics group
    db \2 ; sprite/animation ID
endm

section "Sprite Group Loader", romx[$43d7], bank[$1a]

; Load sprite graphics group A into VRAM at HL and stage its OBJ palettes.
; A group descriptor provides graphics/palette pointers, upload size, and bank.
; wSpritePaletteVariant selects the alternate/fallback palette treatment.
SpriteGroup_LoadGraphicsAndPalettes::
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld a, d
    push hl
    push af
    call SpriteGroup_CopyDescriptor
    ld a, [wSpritePaletteVariant]
    cp $00
    jr nz, .fallback_palette
    ld a, [wSpriteGroupPalette0Pointer]
    ld l, a
    ld a, [wSpriteGroupPalette0Pointer + 1]
    ld h, a
    ld a, [wSpriteGroupBank]
    ld c, a
    ld a, $08
    ld b, $08
    call Vram_SetFarPals
    call Vram_ApplyPals
    jr .copy_graphics
.fallback_palette
    ld hl, SpriteGroup_FallbackPalettes
    ld a, $1a
    ld c, a
    ld a, $08
    ld b, $08
    call Vram_SetPals
    call Vram_ApplyPals
.copy_graphics
    ld a, [wSpriteGroupGraphicsPointer]
    ld e, a
    ld a, [wSpriteGroupGraphicsPointer + 1]
    ld d, a
    ld a, [wSpriteGroupGraphicsSize]
    ld c, a
    ld a, [wSpriteGroupGraphicsSize + 1]
    ld b, a
    pop af
    pop hl
    ld a, [wSpriteGroupBank]
    ld [wFarCopySourceBank], a
    call FarCopy_ToVRAM
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ret

assert @ == $4437

section "Sprite Group Descriptor Copy", romx[$44eb], bank[$1a]

; Copy sprite-group descriptor A into WRAM-bank-4 scratch.
SpriteGroup_CopyDescriptor::
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld a, d
    ld b, $09
    call MultiplyAByB
    ld bc, SpriteGroupDefinitions
    add hl, bc
    ld d, h
    ld e, l
    ld hl, wSpriteGroupGraphicsPointer
    ld bc, $0009
    call Memcpy
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ret

assert @ == $4510

section "Sprite Animation Lookup", romx[$4510], bank[$1a]

; Resolve sprite/animation ID A to the far pointer consumed by SpriteObject_Create.
; Out: B = source ROM bank, DE = animation/frame metadata pointer.
SpriteAnimation_GetFarPointer::
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld a, d
    ld b, $03
    call MultiplyAByB
    ld bc, SpriteAnimationPointers
    add hl, bc
    ld d, h
    ld e, l
    ld hl, wSpriteAnimationPointerScratch
    ld bc, $0003
    call Memcpy
    ld a, [wSpriteAnimationBankScratch]
    ld b, a
    ld a, [wSpriteAnimationPointerScratch]
    ld e, a
    ld a, [wSpriteAnimationPointerScratch + 1]
    ld d, a
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ret

assert @ == $4541

section "Unit Sprite Lookup", romx[$457a], bank[$1a]

; Resolve unit type A to its sprite graphics group and initial animation ID.
; Uploads that group at $8000, stores the initial animation ID in WRAM, and
; returns the animation far pointer in B:DE.
UnitSprite_LoadDefinition::
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $04
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ld a, d
    ld b, $02
    call MultiplyAByB
    ld bc, UnitSpriteDefinitions
    add hl, bc
    ld a, [hl+]
    push hl
    ld hl, $8000
    call SpriteGroup_LoadGraphicsAndPalettes
    pop hl
    ld a, [hl]
    ld [wUnitSpriteAnimationID], a
    farcall $1a, SpriteAnimation_GetFarPointer
    pop af
    ldh [hWRAMBank], a
    ldh [$ff70], a ; rSVBK
    ret

assert @ == $45a5

section "Sprite Animation Pointer Table", romx[$65d8], bank[$1a]

; 223 entries: little-endian pointer + ROM bank.
SpriteAnimationPointers::
    sprite_farptr SpriteAnimation_000 ;   0 - Transport Copter taking off
    sprite_farptr SpriteAnimation_001 ;   1 - Transport Copter standard flying
    sprite_farptr SpriteAnimation_002 ;   2 - Transport Copter landing
    sprite_farptr SpriteAnimation_003 ;   3 - Transport Copter landed
    sprite_farptr SpriteAnimation_004 ;   4 - Transport Copter-S taking off
    sprite_farptr SpriteAnimation_005 ;   5 - Transport Copter-S standard flying
    sprite_farptr SpriteAnimation_006 ;   6 - Transport Copter-S landing
    sprite_farptr SpriteAnimation_007 ;   7 - Transport Copter-S landed
    sprite_farptr SpriteAnimation_008 ;   8
    sprite_farptr SpriteAnimation_009 ;   9
    sprite_farptr SpriteAnimation_010 ;  10
    sprite_farptr SpriteAnimation_011 ;  11
    sprite_farptr SpriteAnimation_012 ;  12
    sprite_farptr SpriteAnimation_013 ;  13
    sprite_farptr SpriteAnimation_014 ;  14
    sprite_farptr SpriteAnimation_015 ;  15
    sprite_farptr SpriteAnimation_016 ;  16
    sprite_farptr SpriteAnimation_017 ;  17
    sprite_farptr SpriteAnimation_018 ;  18
    sprite_farptr SpriteAnimation_019 ;  19
    sprite_farptr SpriteAnimation_020 ;  20
    sprite_farptr SpriteAnimation_021 ;  21
    sprite_farptr SpriteAnimation_022 ;  22
    sprite_farptr SpriteAnimation_023 ;  23
    sprite_farptr SpriteAnimation_024 ;  24
    sprite_farptr SpriteAnimation_025 ;  25
    sprite_farptr SpriteAnimation_026 ;  26
    sprite_farptr SpriteAnimation_027 ;  27
    sprite_farptr SpriteAnimation_028 ;  28
    sprite_farptr SpriteAnimation_029 ;  29
    sprite_farptr SpriteAnimation_030 ;  30 - Supply Plane
    sprite_farptr SpriteAnimation_031 ;  31 - Fighter
    sprite_farptr SpriteAnimation_032 ;  32
    sprite_farptr SpriteAnimation_033 ;  33
    sprite_farptr SpriteAnimation_034 ;  34
    sprite_farptr SpriteAnimation_035 ;  35
    sprite_farptr SpriteAnimation_036 ;  36
    sprite_farptr SpriteAnimation_037 ;  37
    sprite_farptr SpriteAnimation_038 ;  38
    sprite_farptr SpriteAnimation_039 ;  39
    sprite_farptr SpriteAnimation_040 ;  40
    sprite_farptr SpriteAnimation_041 ;  41
    sprite_farptr SpriteAnimation_042 ;  42
    sprite_farptr SpriteAnimation_043 ;  43
    sprite_farptr SpriteAnimation_044 ;  44
    sprite_farptr SpriteAnimation_045 ;  45
    sprite_farptr SpriteAnimation_046 ;  46 - Work Car basic movement (left)
    sprite_farptr SpriteAnimation_047 ;  47
    sprite_farptr SpriteAnimation_048 ;  48 - Work Car basic movement (right)
    sprite_farptr SpriteAnimation_049 ;  49
    sprite_farptr SpriteAnimation_050 ;  50
    sprite_farptr SpriteAnimation_051 ;  51
    sprite_farptr SpriteAnimation_052 ;  52
    sprite_farptr SpriteAnimation_053 ;  53
    sprite_farptr SpriteAnimation_054 ;  54
    sprite_farptr SpriteAnimation_055 ;  55
    sprite_farptr SpriteAnimation_056 ;  56
    sprite_farptr SpriteAnimation_057 ;  57
    sprite_farptr SpriteAnimation_058 ;  58
    sprite_farptr SpriteAnimation_059 ;  59
    sprite_farptr SpriteAnimation_060 ;  60
    sprite_farptr SpriteAnimation_061 ;  61
    sprite_farptr SpriteAnimation_062 ;  62
    sprite_farptr SpriteAnimation_063 ;  63
    sprite_farptr SpriteAnimation_064 ;  64
    sprite_farptr SpriteAnimation_065 ;  65
    sprite_farptr SpriteAnimation_066 ;  66
    sprite_farptr SpriteAnimation_067 ;  67
    sprite_farptr SpriteAnimation_068 ;  68
    sprite_farptr SpriteAnimation_069 ;  69
    sprite_farptr SpriteAnimation_070 ;  70
    sprite_farptr SpriteAnimation_071 ;  71
    sprite_farptr SpriteAnimation_072 ;  72
    sprite_farptr SpriteAnimation_073 ;  73
    sprite_farptr SpriteAnimation_074 ;  74
    sprite_farptr SpriteAnimation_075 ;  75
    sprite_farptr SpriteAnimation_076 ;  76
    sprite_farptr SpriteAnimation_077 ;  77
    sprite_farptr SpriteAnimation_078 ;  78
    sprite_farptr SpriteAnimation_079 ;  79
    sprite_farptr SpriteAnimation_080 ;  80
    sprite_farptr SpriteAnimation_081 ;  81
    sprite_farptr SpriteAnimation_082 ;  82
    sprite_farptr SpriteAnimation_083 ;  83
    sprite_farptr SpriteAnimation_084 ;  84
    sprite_farptr SpriteAnimation_085 ;  85
    sprite_farptr SpriteAnimation_086 ;  86
    sprite_farptr SpriteAnimation_087 ;  87
    sprite_farptr SpriteAnimation_088 ;  88
    sprite_farptr SpriteAnimation_089 ;  89
    sprite_farptr SpriteAnimation_090 ;  90
    sprite_farptr SpriteAnimation_091 ;  91
    sprite_farptr SpriteAnimation_092 ;  92
    sprite_farptr SpriteAnimation_093 ;  93
    sprite_farptr SpriteAnimation_094 ;  94
    sprite_farptr SpriteAnimation_095 ;  95
    sprite_farptr SpriteAnimation_096 ;  96
    sprite_farptr SpriteAnimation_097 ;  97
    sprite_farptr SpriteAnimation_098 ;  98
    sprite_farptr SpriteAnimation_099 ;  99
    sprite_farptr SpriteAnimation_100 ; 100
    sprite_farptr SpriteAnimation_101 ; 101
    sprite_farptr SpriteAnimation_102 ; 102
    sprite_farptr SpriteAnimation_103 ; 103
    sprite_farptr SpriteAnimation_104 ; 104
    sprite_farptr SpriteAnimation_105 ; 105
    sprite_farptr SpriteAnimation_106 ; 106
    sprite_farptr SpriteAnimation_107 ; 107
    sprite_farptr SpriteAnimation_108 ; 108
    sprite_farptr SpriteAnimation_109 ; 109
    sprite_farptr SpriteAnimation_110 ; 110
    sprite_farptr SpriteAnimation_111 ; 111
    sprite_farptr SpriteAnimation_112 ; 112
    sprite_farptr SpriteAnimation_113 ; 113
    sprite_farptr SpriteAnimation_114 ; 114
    sprite_farptr SpriteAnimation_115 ; 115
    sprite_farptr SpriteAnimation_116 ; 116
    sprite_farptr SpriteAnimation_117 ; 117
    sprite_farptr SpriteAnimation_118 ; 118
    sprite_farptr SpriteAnimation_119 ; 119
    sprite_farptr SpriteAnimation_120 ; 120
    sprite_farptr SpriteAnimation_121 ; 121
    sprite_farptr SpriteAnimation_122 ; 122
    sprite_farptr SpriteAnimation_123 ; 123
    sprite_farptr SpriteAnimation_124 ; 124
    sprite_farptr SpriteAnimation_125 ; 125
    sprite_farptr SpriteAnimation_126 ; 126
    sprite_farptr SpriteAnimation_127 ; 127
    sprite_farptr SpriteAnimation_128 ; 128
    sprite_farptr SpriteAnimation_129 ; 129
    sprite_farptr SpriteAnimation_130 ; 130
    sprite_farptr SpriteAnimation_131 ; 131
    sprite_farptr SpriteAnimation_132 ; 132
    sprite_farptr SpriteAnimation_133 ; 133
    sprite_farptr SpriteAnimation_134 ; 134
    sprite_farptr SpriteAnimation_135 ; 135
    sprite_farptr SpriteAnimation_136 ; 136
    sprite_farptr SpriteAnimation_137 ; 137
    sprite_farptr SpriteAnimation_138 ; 138
    sprite_farptr SpriteAnimation_139 ; 139
    sprite_farptr SpriteAnimation_140 ; 140
    sprite_farptr SpriteAnimation_141 ; 141
    sprite_farptr SpriteAnimation_142 ; 142
    sprite_farptr SpriteAnimation_143 ; 143
    sprite_farptr SpriteAnimation_144 ; 144
    sprite_farptr SpriteAnimation_145 ; 145
    sprite_farptr SpriteAnimation_146 ; 146 - Soldier hard work
    sprite_farptr SpriteAnimation_147 ; 147 - Soldier basic running (left)
    sprite_farptr SpriteAnimation_148 ; 148
    sprite_farptr SpriteAnimation_149 ; 149
    sprite_farptr SpriteAnimation_150 ; 150
    sprite_farptr SpriteAnimation_151 ; 151
    sprite_farptr SpriteAnimation_152 ; 152 - Soldier basic running (right)
    sprite_farptr SpriteAnimation_153 ; 153
    sprite_farptr SpriteAnimation_154 ; 154 - Soldier victory pose (left)
    sprite_farptr SpriteAnimation_155 ; 155 - Soldier victory pose (right)
    sprite_farptr SpriteAnimation_156 ; 156
    sprite_farptr SpriteAnimation_157 ; 157
    sprite_farptr SpriteAnimation_158 ; 158
    sprite_farptr SpriteAnimation_159 ; 159 - Communication Tower signal electricity
    sprite_farptr SpriteAnimation_160 ; 160
    sprite_farptr SpriteAnimation_161 ; 161 - Submarine default
    sprite_farptr SpriteAnimation_162 ; 162
    sprite_farptr SpriteAnimation_163 ; 163
    sprite_farptr SpriteAnimation_164 ; 164 - Mercenary Bomber default
    sprite_farptr SpriteAnimation_165 ; 165
    sprite_farptr SpriteAnimation_166 ; 166
    sprite_farptr SpriteAnimation_167 ; 167
    sprite_farptr SpriteAnimation_168 ; 168
    sprite_farptr SpriteAnimation_169 ; 169
    sprite_farptr SpriteAnimation_170 ; 170
    sprite_farptr SpriteAnimation_171 ; 171
    sprite_farptr SpriteAnimation_172 ; 172
    sprite_farptr SpriteAnimation_173 ; 173
    sprite_farptr SpriteAnimation_174 ; 174
    sprite_farptr SpriteAnimation_175 ; 175
    sprite_farptr SpriteAnimation_176 ; 176
    sprite_farptr SpriteAnimation_177 ; 177
    sprite_farptr SpriteAnimation_178 ; 178
    sprite_farptr SpriteAnimation_179 ; 179
    sprite_farptr SpriteAnimation_180 ; 180
    sprite_farptr SpriteAnimation_181 ; 181
    sprite_farptr SpriteAnimation_182 ; 182
    sprite_farptr SpriteAnimation_183 ; 183
    sprite_farptr SpriteAnimation_184 ; 184
    sprite_farptr SpriteAnimation_185 ; 185
    sprite_farptr SpriteAnimation_186 ; 186
    sprite_farptr SpriteAnimation_187 ; 187
    sprite_farptr SpriteAnimation_188 ; 188
    sprite_farptr SpriteAnimation_189 ; 189
    sprite_farptr SpriteAnimation_190 ; 190
    sprite_farptr SpriteAnimation_191 ; 191
    sprite_farptr SpriteAnimation_192 ; 192
    sprite_farptr SpriteAnimation_193 ; 193
    sprite_farptr SpriteAnimation_194 ; 194
    sprite_farptr SpriteAnimation_195 ; 195
    sprite_farptr SpriteAnimation_196 ; 196
    sprite_farptr SpriteAnimation_197 ; 197
    sprite_farptr SpriteAnimation_198 ; 198
    sprite_farptr SpriteAnimation_199 ; 199
    sprite_farptr SpriteAnimation_200 ; 200
    sprite_farptr SpriteAnimation_201 ; 201
    sprite_farptr SpriteAnimation_202 ; 202
    sprite_farptr SpriteAnimation_203 ; 203
    sprite_farptr SpriteAnimation_204 ; 204
    sprite_farptr SpriteAnimation_205 ; 205
    sprite_farptr SpriteAnimation_206 ; 206
    sprite_farptr SpriteAnimation_207 ; 207
    sprite_farptr SpriteAnimation_208 ; 208
    sprite_farptr SpriteAnimation_209 ; 209
    sprite_farptr SpriteAnimation_210 ; 210
    sprite_farptr SpriteAnimation_211 ; 211
    sprite_farptr SpriteAnimation_212 ; 212
    sprite_farptr SpriteAnimation_213 ; 213
    sprite_farptr SpriteAnimation_214 ; 214
    sprite_farptr SpriteAnimation_215 ; 215
    sprite_farptr SpriteAnimation_216 ; 216 - Yielding Infantry
    sprite_farptr SpriteAnimation_217 ; 217
    sprite_farptr SpriteAnimation_218 ; 218
    sprite_farptr SpriteAnimation_219 ; 219
    sprite_farptr SpriteAnimation_220 ; 220 - PRESS START
    sprite_farptr SpriteAnimation_221 ; 221
    sprite_farptr SpriteAnimation_222 ; 222

assert @ == $6875

section "Sprite Group Definition Table", romx[$6875], bank[$1a]

; 30 entries, 9 bytes each:
; graphics ptr, palette ptr variant 0, palette ptr variant 1, byte count, ROM bank.
SpriteGroupDefinitions::
    sprite_group $44da, $49da, $69eb, $0500, $1d ;  0 - Transport Copters
    sprite_group $4ee8, $5568, $69eb, $0680, $1d ;  1 - Gunships
    sprite_group $586f, $5d2f, $69eb, $04c0, $1d ;  2 - Ship Buster and Lite Attacker
    sprite_group $614d, $691d, $69eb, $07d0, $1d ;  3 - Ships
    sprite_group $6d4b, $70eb, $69eb, $03a0, $1d ;  4 - Jets and Supply Plane
    sprite_group $7737, $7dd7, $69eb, $06e0, $1d ;  5 - Work Car and Supply Trucks
    sprite_group $45ac, $4abc, $69eb, $0560, $1e ;  6 - Convoys and Buggy
    sprite_group $50c0, $55e0, $69eb, $0530, $1e ;  7 - Buggy-S and Humvees
    sprite_group $5b6c, $603c, $69eb, $05c0, $1e ;  8 - APCs and Rockets
    sprite_group $66b8, $6c68, $69eb, $0660, $1e ;  9 - Rockets-S and Anti-Air Tanks
    sprite_group $72e4, $7894, $69eb, $0600, $1e ; 10 - Missile launchers and Artillery
    sprite_group $4624, $4be4, $69eb, $0600, $1f ; 11 - Artillery-S and IFVs
    sprite_group $545c, $5c0c, $69eb, $07b0, $1f ; 12 - Regular tanks
    sprite_group $5f32, $65c2, $69eb, $0690, $1f ; 13 - Infantry
    sprite_group $751b, $75fb, $75fb, $00e0, $1c ; 14 - Communication Tower signal
    sprite_group $68ea, $6d5a, $6d5a, $0470, $1f ; 15 - Submarines
    sprite_group $7122, $75c2, $75c2, $04a0, $1f ; 16 - Mercenary Bomber
    sprite_group $4062, $40f2, $40f2, $0090, $20 ; 17 - Unknown group 17
    sprite_group $4188, $42c8, $42c8, $0180, $20 ; 18 - Unknown group 18
    sprite_group $4421, $46e1, $46e1, $02c0, $20 ; 19 - Unknown group 19
    sprite_group $52bd, $587d, $587d, $05c0, $20 ; 20 - Unknown group 20
    sprite_group $4ffa, $545a, $545a, $0460, $26 ; 21 - Unknown group 21
    sprite_group $591e, $598e, $598e, $0070, $20 ; 22 - Unknown group 22
    sprite_group $5a99, $77c2, $5d49, $02b0, $20 ; 23 - Unknown group 23
    sprite_group $626b, $6f4b, $6f4b, $0ce0, $20 ; 24 - Unknown group 24
    sprite_group $72e2, $77c2, $77c2, $04e0, $20 ; 25 - Unknown group 25
    sprite_group $4571, $5131, $5131, $0bc0, $21 ; 26 - Unknown group 26
    sprite_group $53f6, $59b6, $59b6, $05c0, $21 ; 27 - Unknown group 27
    sprite_group $5c61, $5dc1, $5e01, $0160, $22 ; 28 - Yielding Infantry
    sprite_group $51ef, $525f, $525f, $0070, $27 ; 29 - PRESS START

assert @ == $6983

section "Unit Sprite Definition Table", romx[$6983], bank[$1a]

; Unit IDs 0..51 map to graphics-group ID + initial sprite/animation ID.
UnitSpriteDefinitions::
    unit_sprite $00, $00 ;  0 - Empty
    unit_sprite $0d, $93 ;  1 - Infantry
    unit_sprite $0d, $93 ;  2 - Mech
    unit_sprite $0d, $93 ;  3 - Mercenary
    unit_sprite $05, $2e ;  4 - Bulldozer
    unit_sprite $05, $32 ;  5 - Supply Truck
    unit_sprite $05, $36 ;  6 - Supply Truck-S
    unit_sprite $06, $3a ;  7 - Transport Truck
    unit_sprite $06, $3e ;  8 - Transport Truck-S
    unit_sprite $06, $42 ;  9 - Buggy
    unit_sprite $07, $46 ; 10 - Buggy-S
    unit_sprite $07, $4a ; 11 - Humvee
    unit_sprite $07, $4e ; 12 - Humvee-S
    unit_sprite $08, $52 ; 13 - APC
    unit_sprite $08, $56 ; 14 - APC-S
    unit_sprite $08, $5a ; 15 - Rockets
    unit_sprite $09, $5e ; 16 - Rockets-S
    unit_sprite $09, $62 ; 17 - Anti-Air
    unit_sprite $09, $66 ; 18 - Mercenary Missiles
    unit_sprite $0a, $6a ; 19 - Missiles
    unit_sprite $0a, $6e ; 20 - Missiles-S
    unit_sprite $0a, $72 ; 21 - Artillery
    unit_sprite $0b, $76 ; 22 - Artillery-S
    unit_sprite $0b, $7a ; 23 - IFV
    unit_sprite $0b, $7e ; 24 - IFV-S
    unit_sprite $0c, $82 ; 25 - Buster
    unit_sprite $0c, $86 ; 26 - Buster-S
    unit_sprite $0c, $8a ; 27 - Tank
    unit_sprite $0c, $8e ; 28 - Mercenary Tank
    unit_sprite $04, $1f ; 29 - Fighter-A
    unit_sprite $04, $22 ; 30 - Fighter-B
    unit_sprite $04, $25 ; 31 - Fighter-S
    unit_sprite $04, $28 ; 32 - Attacker-A
    unit_sprite $02, $16 ; 33 - Attacker-B
    unit_sprite $04, $2b ; 34 - Attacker-S
    unit_sprite $00, $00 ; 35 - Bomber
    unit_sprite SPRITE_GROUP_MERCENARY_BOMBER, SPRITE_ANIM_MERCENARY_BOMBER_DEFAULT ; 36 - Mercenary Bomber
    unit_sprite $00, $00 ; 37 - Transport Plane
    unit_sprite $04, $1e ; 38 - Supply Plane
    unit_sprite $01, $09 ; 39 - Battle Copter
    unit_sprite $01, $0d ; 40 - Battle Copter-S
    unit_sprite $02, $12 ; 41 - AS Copter
    unit_sprite $00, $00 ; 42 - Transport Copter
    unit_sprite $00, $04 ; 43 - Transport Copter-S
    unit_sprite $03, $1c ; 44 - Warship
    unit_sprite $03, $1d ; 45 - Mercenary Frigate
    unit_sprite $03, $1b ; 46 - Large Carrier
    unit_sprite $03, $1a ; 47 - Small Carrier
    unit_sprite $03, $19 ; 48 - Lander
    unit_sprite $03, $18 ; 49 - Supply Ship
    unit_sprite SPRITE_GROUP_SUBMARINES, SPRITE_ANIM_SUBMARINE_DEFAULT ; 50 - Submarine
    unit_sprite SPRITE_GROUP_SUBMARINES, SPRITE_ANIM_SUBMARINE_DEFAULT ; 51 - Submarine-S

assert @ == $69eb

section "Sprite Group Fallback Palettes", romx[$69eb], bank[$1a]

; Eight 8-byte CGB OBJ palettes used by the shared fallback/alternate path.
SpriteGroup_FallbackPalettes::
    db $f8, $57, $ff, $7f, $1f, $02, $ff, $03 ; palette 0
    db $f8, $63, $ff, $7f, $7f, $18, $fe, $30 ; palette 1
    db $fb, $5b, $00, $00, $ff, $7f, $cd, $45 ; palette 2
    db $fb, $5b, $00, $00, $cd, $45, $fd, $3e ; palette 3
    db $fb, $5b, $00, $00, $ff, $7f, $e0, $7e ; palette 4
    db $fb, $5b, $00, $00, $cd, $45, $e0, $7e ; palette 5
    db $f8, $5b, $00, $00, $fd, $3e, $b6, $29 ; palette 6
    db $fb, $5b, $ff, $7f, $7f, $1a, $fd, $34 ; palette 7

assert @ == $6a2b
