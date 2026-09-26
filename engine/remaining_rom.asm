INCLUDE "macros/macros.inc"

; Explicit ownership for all ROM ranges formerly inherited from the base-ROM overlay.
; Directly reachable code is promoted to LR35902 mnemonics. Unreached bytes remain
; standalone structural assets/padding until stronger semantic evidence exists.

SECTION "Remaining ROM 00:0000-014F", ROM0[$0000]
RemainingROM_Bank00_0000::
RuntimeEntry_Bank00_0000::
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
RuntimeEntry_Bank00_0008::
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
RuntimeEntry_Bank00_0010::
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
RuntimeEntry_Bank00_0018::
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
RuntimeEntry_Bank00_0020::
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
FarcallVector::
    jp Farcall
    ds $5, $00
RuntimeEntry_Bank00_0030::
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
RuntimeEntry_Bank00_0038::
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
VBlankInterruptVector::
    jp $c008
    ds $5, $00
LCDStatInterruptVector::
    jp $c002
    ds $5, $00
TimerInterruptVector::
    jp $c005
    ds $5, $00
SerialInterruptVector::
    jp MobileSerialInterrupt
    db $c3, $0b, $c0, $00, $00
JoypadInterrupt::
    ld a, $10
    ldh [$ff00], a
    ldh a, [$ff00]
    ldh a, [$ff00]
    ldh a, [$ff00]
    ldh a, [$ff00]
    ldh a, [$ff00]
    ldh a, [$ff00]
    cpl
    and $09
    jp nz, SoftReset
    reti
    ds $89, $00
CartridgeHeaderEntry::
    nop
    jp CartridgeBootEntry
    ; Source-owned structural bytes formerly data/home/structural/bank00_0104_014f.dat
    db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
    db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
    db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e
    db $47, $42, $20, $57, $41, $52, $53, $33, $00, $00, $00, $42, $57, $57, $4a, $c0
    db $31, $38, $00, $1b, $05, $04, $00, $33, $00, $14, $ea, $69
    assert @ == $0150

SECTION "Remaining ROM 00:08F5-090A", ROM0[$08F5]
RemainingROM_Bank00_08F5::
    db $f0, $82, $f5, $3e, $05, $e0, $82, $e0, $70, $cd, $d7, $08, $6e, $f1, $e0, $82, $e0, $70, $7d, $fe, $ff, $c9
    assert @ == $090B

SECTION "Remaining ROM 00:09A6-0C2F", ROM0[$09A6]
RemainingROM_Bank00_09A6::
BankedReadByte::
    ldh a, [$ff80]
    push af
    ld a, b
    ldh [$ff80], a
    ld [$2000], a
    ld a, [hl]
    ld [$c624], a
    pop af
    ldh [$ff80], a
    ld [$2000], a
    ld a, [$c624]
    ret
RuntimeEntry_Bank00_09BD::
    ld de, $0a00
    ld hl, $c4e0
    ld bc, $0040
    call Memcpy
    ld bc, $ff00
    call Vram_ApplySelectedPals
    ret
    ; Source-owned structural bytes formerly data/home/structural/bank00_09d0_0c2f.dat
    db $09, $09, $09, $09, $09, $09, $0b, $0b, $0b, $0f, $0b, $0b, $0b, $0b, $0b, $0f
    db $0b, $0b, $0b, $0b, $0b, $4b, $0b, $4b, $2d, $6d, $2d, $6d, $6d, $6d, $6e, $6e
    db $6f, $6e, $6e, $6e, $6e, $6e, $6f, $6e, $6e, $6e, $6e, $6e, $6e, $6e, $6e, $6e
    db $e7, $1c, $07, $69, $ff, $7f, $47, $72, $ff, $7f, $e7, $1c, $7f, $1f, $ff, $4b
    db $ff, $7f, $6c, $1f, $08, $1e, $e7, $1c, $ff, $7f, $e7, $1c, $7f, $1f, $16, $1e
    db $10, $42, $6b, $2d, $ff, $7f, $ff, $7f, $ff, $7f, $e7, $1c, $ff, $1c, $9f, $31
    db $ff, $7f, $e7, $1c, $ff, $1c, $f1, $1c, $ff, $7f, $e7, $1c, $08, $21, $07, $1f
    db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $00, $14, $0c, $0d, $0e, $13
    db $00, $0b, $0f, $10, $11, $04, $12, $06, $00, $00, $00, $00, $00, $00, $01, $01
    db $01, $04, $01, $01, $01, $01, $01, $04, $01, $01, $01, $01, $01, $41, $01, $41
    db $06, $12, $04, $11, $10, $0f, $0b, $00, $13, $0e, $0d, $0c, $14, $00, $0a, $09
    db $08, $07, $06, $05, $04, $03, $02, $01, $22, $62, $22, $62, $62, $62, $63, $63
    db $64, $63, $63, $63, $63, $63, $64, $63, $63, $63, $63, $63, $63, $63, $63, $63
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $3f, $ff, $7f, $bf, $7f, $9f, $7f, $0f, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $ff, $ff, $ff, $e7, $ff, $e7, $ff, $e7, $ff, $00, $ff, $00, $18, $e7
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $01, $fe, $03, $fc, $03, $fc
    db $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $f0, $00
    db $ff, $ff, $ff, $ff, $ff, $00, $ff, $03, $ff, $03, $ff, $00, $ff, $00, $00, $00
    db $ff, $fe, $ff, $ff, $ff, $07, $ff, $03, $ff, $03, $fc, $03, $fc, $03, $1c, $03
    db $00, $ff, $00, $ff, $0c, $ff, $2c, $f7, $2c, $f7, $0c, $f7, $2c, $ff, $00, $ff
    db $18, $e7, $18, $e7, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $03, $fc, $03, $fc, $03, $fc, $33, $fc, $4b, $fc, $7b, $fc, $4b, $fc, $7b, $fc
    db $f0, $00, $f0, $00, $f0, $00, $30, $c0, $30, $c0, $f0, $00, $30, $c0, $30, $c0
    db $1c, $03, $1c, $03, $1c, $03, $1c, $03, $1c, $03, $1c, $03, $1c, $03, $1c, $03
    db $00, $ff, $0c, $ff, $2c, $f7, $2c, $f7, $0c, $f7, $2c, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $3c, $e7, $3c, $c3, $3c, $c3, $3c, $e7
    db $6b, $fc, $5b, $fc, $6b, $fc, $4b, $fc, $33, $fc, $03, $fc, $03, $fc, $03, $fc
    db $14, $eb, $0a, $f5, $14, $eb, $0f, $f5, $9f, $6b, $bf, $75, $ff, $7f, $ff, $3f
    db $00, $ff, $00, $ff, $0f, $f9, $ff, $f0, $ff, $f0, $ff, $f9, $ff, $ff, $ff, $ff
    db $03, $fc, $03, $fc, $01, $fe, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff
    db $f0, $00, $f0, $c0, $f0, $c0, $f0, $00, $f0, $c0, $f0, $c0, $f0, $00, $f0, $00
    db $1e, $03, $1f, $03, $1e, $03, $1c, $03, $1c, $03, $1c, $03, $1c, $03, $1c, $03
    db $ff, $7f, $84, $10, $7f, $03, $ff, $4b, $ff, $7f, $84, $10, $7f, $03, $16, $02
    db $ff, $7f, $84, $10, $1f, $00, $9f, $31, $ff, $7f, $84, $10, $5f, $08, $11, $00
    db $ff, $7f, $84, $10, $08, $21, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    assert @ == $0C30

SECTION "Remaining ROM 00:0FC2-108B", ROM0[$0FC2]
RemainingROM_Bank00_0FC2::
RuntimeEntry_Bank00_0FC2::
    ld [$c8c0], a
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ldh a, [$ff80]
    push af
    ld a, $30
    ldh [$ff80], a
    ld [$2000], a
    ld a, [$c8c0]
    push hl
    push af
    push af
    ld a, [$c8c1]
    and $1f
    ld hl, $c8c2
    add a, l
    ld l, a
    ld a, $00
    add a, h
    ld h, a
    pop af
    ld [hl], a
    ld a, [$c8c1]
    inc a
    and $1f
    ld [$c8c1], a
    xor a
    ld [$c8bb], a
    ld [$c8bc], a
    ld [$c8bd], a
    ld hl, $3e0e
    ld a, [hli]
    ld h, [hl]
    ld l, a
    pop af
    add a, l
    ld l, a
    ld a, $00
    adc a, h
    ld h, a
    ld a, [hl]
    pop hl
    call MobileAdapter_Dispatch
    ld [$c8c0], a
    pop af
    ldh [$ff80], a
    ld [$2000], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [$c8c0]
    ret
RuntimeEntry_Bank00_1025::
    push de
    push hl
    push af
    call Mobile_GetStatusPointer
    pop af
    ld e, a
.loc_102D:
    ld a, [hl]
    ld [$c8bf], a
    ld d, a
    bit 1, d
    jr nz, .loc_105C
    bit 2, d
    jr nz, .loc_104D
    bit 0, d
    jr z, .loc_1044
    bit 0, e
    jr nz, .loc_1048
    jr .loc_102D
.loc_1044:
    xor a
.loc_1045:
    pop hl
    pop de
    ret
.loc_1048:
    xor a
    ld a, $ff
    jr .loc_1045
.loc_104D:
    xor a
    ld [$c8bc], a
    ld [$c8bd], a
    ld a, $ff
    ld [$c8bb], a
    scf
    jr .loc_1045
.loc_105C:
    ld a, $17
    call RuntimeEntry_Bank00_0FC2
    ld [$c8bb], a
    ld a, l
    ld [$c8bc], a
    ld a, h
    ld [$c8bd], a
    ld a, [$c8bb]
    cp $32
    jr nz, .loc_1086
    ld a, h
    cp $03
    jr nz, .loc_1086
    ld a, l
    dec a
    cp $02
    jr nc, .loc_1086
    ld a, c
    ld [$c8e8], a
    ld a, b
    ld [$c8e9], a
.loc_1086:
    ld a, [$c8bb]
    scf
    jr .loc_1045
    assert @ == $108C

SECTION "Remaining ROM 00:10B9-1213", ROM0[$10B9]
RemainingROM_Bank00_10B9::
RuntimeEntry_Bank00_10B9::
    jp RuntimeEntry_Bank00_10B9
    ; Source-owned structural bytes formerly data/home/structural/bank00_10bc_10fc.dat
    db $68, $74, $74, $70, $3a, $2f, $2f, $67, $61, $6d, $65, $62, $6f, $79, $2e, $64
    db $61, $74, $61, $63, $65, $6e, $74, $65, $72, $2e, $6e, $65, $2e, $6a, $70, $2f
    db $63, $67, $62, $2f, $64, $6f, $77, $6e, $6c, $6f, $61, $64, $00, $3f, $6e, $61
    db $6d, $65, $3d, $2f, $31, $38, $2f, $43, $47, $42, $2d, $42, $57, $57, $4a, $2f
    db $00
RuntimeEntry_Bank00_10FD::
    call $58d4
    call InfraredHW_EnableReceiver
.loc_1103:
    ld a, $46
    ld [$c8f6], a
    ld a, $22
    ld [$c8f7], a
    call InfraredHW_NegotiateLinkRole
    ld a, [$c900]
    ld [$c8f9], a
    ld a, [$c901]
    cp $8b
    jp z, .loc_112E
    cp $ff
    jp z, .loc_1203
    ld a, [$c900]
    cp $02
    jp z, .loc_1194
    jp .loc_1103
.loc_112E:
    ld a, [$c900]
    cp $02
    jr z, .loc_11AC
    ld hl, $c8f6
    ld b, $02
    call InfraredHW_ReceiveBuffer
    ld a, [$c901]
    cp $8b
    jp nz, .loc_1103
    call InfraredHW_ReceiveControlByte
    ld a, [$c901]
    cp $8b
    jp nz, .loc_1103
    ld a, [$c8f6]
    ld b, a
    cp $46
    jp nz, .loc_1203
    ld a, [$c8f7]
    cp $22
    jp nz, .loc_1203
    ld [$c8f6], a
    ld a, b
    ld [$c8f7], a
    call InfraredHW_EnableReceiver
    call InfraredHW_LinkRoleSendFirst
    ld a, [$c901]
    cp $8b
    jp nz, .loc_1103
    ld hl, $c8f6
    ld b, $02
    call InfraredHW_SendBuffer
    ld a, [$c901]
    cp $8b
    jp nz, .loc_1103
    call InfraredHW_SendControlByte
    ld a, [$c901]
    cp $8b
    jp nz, .loc_1103
    jp .loc_11FD
.loc_1194:
    call InfraredHW_EnableReceiver
    call InfraredHW_PollJoypad
    ld a, [$c909]
    bit 0, a
    jr .loc_1203
    db $cd, $02, $13, $fa, $01, $c9, $fe, $8b, $c2, $97, $11
.loc_11AC:
    ld hl, $c8f6
    ld b, $02
    call InfraredHW_SendBuffer
    ld a, [$c901]
    cp $8b
    jp nz, .loc_1194
    call InfraredHW_SendControlByte
    ld a, [$c901]
    cp $8b
    jp nz, .loc_1194
    call InfraredHW_EnableReceiver
    call InfraredHW_LinkRoleReceiveFirst
    ld a, [$c901]
    cp $8b
    jp nz, .loc_1194
    ld hl, $c8f6
    ld b, $02
    call InfraredHW_ReceiveBuffer
    ld a, [$c901]
    cp $8b
    jp nz, .loc_1194
    call InfraredHW_ReceiveControlByte
    ld a, [$c901]
    cp $8b
    jr nz, .loc_1194
    ld a, [$c8f6]
    cp $22
    jr nz, .loc_1203
    ld a, [$c8f7]
    cp $46
    jr nz, .loc_1203
.loc_11FD:
    xor a
    ld a, [$c8f9]
    jr .loc_1204
.loc_1203:
    scf
.loc_1204:
    push af
    call $58eb
    pop af
    ret
    db $18, $f7, $18, $f5, $18, $f3, $18, $f1, $18, $ef
    assert @ == $1214

SECTION "Remaining ROM 00:18DF-1C6B", ROM0[$18DF]
RemainingROM_Bank00_18DF::
    ; Source-owned structural data formerly data/home/structural/bank00_18df_1c6b.bin
    db $03, $00, $60, $03, $f5, $00, $40, $f5, $03, $00, $20, $f5, $f5, $00, $00, $04
    db $03, $03, $01, $60, $03, $f5, $01, $40, $f5, $03, $01, $20, $f5, $f5, $01, $00
    db $08, $fc, $05, $03, $21, $fc, $f3, $03, $01, $05, $fc, $02, $41, $f3, $fc, $02
    db $01, $03, $03, $01, $61, $03, $f5, $01, $41, $f5, $03, $01, $21, $f5, $f5, $01
    db $01, $08, $fc, $04, $03, $21, $fc, $f4, $03, $01, $04, $fc, $02, $41, $f4, $fc
    db $02, $01, $03, $03, $01, $61, $03, $f5, $01, $41, $f5, $03, $01, $21, $f5, $f5
    db $01, $01, $0c, $f0, $f8, $0f, $60, $f0, $00, $0e, $60, $f8, $f0, $0d, $60, $f8
    db $f8, $0c, $60, $f8, $00, $0b, $60, $f8, $08, $0a, $60, $00, $f0, $09, $60, $00
    db $f8, $08, $60, $00, $00, $07, $60, $00, $08, $06, $60, $08, $f8, $05, $60, $08
    db $00, $04, $60, $08, $04, $04, $17, $02, $04, $fc, $16, $02, $04, $f4, $15, $02
    db $fc, $04, $14, $02, $fc, $f4, $13, $02, $f4, $04, $12, $02, $f4, $fc, $11, $02
    db $f4, $f4, $10, $02, $04, $03, $03, $00, $61, $03, $f5, $00, $41, $f5, $03, $00
    db $21, $f5, $f5, $00, $01, $04, $03, $03, $00, $62, $03, $f5, $00, $42, $f5, $03
    db $00, $22, $f5, $f5, $00, $02, $0c, $1f, $1b, $1a, $60, $d9, $1b, $1a, $20, $1f
    db $dd, $1a, $40, $e1, $23, $18, $20, $17, $23, $18, $60, $17, $d5, $18, $40, $d9
    db $23, $19, $20, $1f, $23, $19, $60, $1f, $d5, $19, $40, $d9, $dd, $1a, $00, $e1
    db $d5, $18, $00, $d9, $d5, $19, $00, $0c, $1f, $1b, $1a, $62, $d9, $1b, $1a, $22
    db $1f, $dd, $1a, $42, $e1, $23, $18, $22, $17, $23, $18, $62, $17, $d5, $18, $42
    db $d9, $23, $19, $22, $1f, $23, $19, $62, $1f, $d5, $19, $42, $d9, $dd, $1a, $02
    db $e1, $d5, $18, $02, $d9, $d5, $19, $02, $08, $13, $0b, $00, $60, $13, $ed, $00
    db $40, $03, $13, $00, $60, $f5, $13, $00, $20, $03, $e5, $00, $40, $f5, $e5, $00
    db $00, $e5, $0b, $00, $20, $e5, $ed, $00, $00, $08, $13, $0b, $01, $60, $13, $ed
    db $01, $40, $03, $13, $01, $60, $f5, $13, $01, $20, $03, $e5, $01, $40, $f5, $e5
    db $01, $00, $e5, $0b, $01, $20, $e5, $ed, $01, $00, $dd, $18, $0f, $ee, $18, $0f
    db $00, $00, $ff, $18, $0f, $20, $19, $0f, $00, $00, $41, $19, $0a, $00, $00, $72
    db $19, $01, $00, $00, $dd, $18, $ff, $00, $00, $93, $19, $ff, $00, $00, $a4, $19
    db $ff, $00, $00, $b5, $19, $0f, $e6, $19, $0f, $00, $00, $17, $1a, $0f, $38, $1a
    db $0f, $00, $00, $59, $1a, $61, $1a, $69, $1a, $6e, $1a, $73, $1a, $78, $1a, $7d
    db $1a, $82, $1a, $8a, $1a, $fc, $00, $84, $78, $bc, $40, $a0, $40, $a0, $40, $e0
    db $00, $00, $00, $00, $00, $fc, $00, $fc, $78, $fc, $40, $e0, $40, $e0, $40, $e0
    db $00, $00, $00, $00, $00, $00, $00, $ff, $00, $81, $7e, $42, $3c, $24, $18, $18
    db $00, $00, $00, $00, $00, $60, $00, $50, $20, $48, $30, $44, $38, $44, $38, $48
    db $30, $50, $20, $60, $00, $00, $00, $03, $00, $02, $01, $02, $01, $06, $01, $18
    db $07, $66, $19, $9a, $61, $00, $00, $80, $00, $80, $00, $80, $00, $e0, $00, $18
    db $e0, $e6, $18, $99, $06, $01, $00, $02, $01, $02, $01, $05, $02, $05, $02, $0a
    db $04, $0a, $04, $7b, $04, $62, $81, $81, $00, $80, $00, $04, $00, $0e, $04, $1c
    db $08, $38, $10, $90, $00, $86, $01, $01, $00, $41, $00, $e0, $40, $70, $20, $38
    db $10, $11, $00, $02, $01, $80, $00, $40, $80, $40, $80, $a0, $40, $a0, $40, $50
    db $20, $de, $20, $02, $fc, $40, $3f, $7b, $04, $0a, $04, $05, $02, $05, $02, $02
    db $01, $02, $01, $01, $00, $40, $80, $88, $00, $1c, $08, $0e, $04, $07, $02, $82
    db $00, $80, $00, $61, $80, $09, $00, $1c, $08, $38, $10, $70, $20, $20, $00, $01
    db $00, $81, $00, $46, $81, $de, $20, $50, $20, $50, $20, $a0, $40, $a0, $40, $40
    db $80, $40, $80, $80, $00, $99, $60, $67, $18, $18, $07, $07, $00, $01, $00, $01
    db $00, $01, $00, $00, $00, $59, $86, $66, $98, $18, $e0, $60, $80, $40, $80, $40
    db $80, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02
    db $01, $05, $02, $0a, $04, $00, $00, $1c, $00, $14, $08, $76, $08, $81, $7e, $76
    db $89, $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $40
    db $80, $a0, $40, $50, $20, $0a, $04, $14, $08, $74, $08, $42, $3c, $74, $08, $14
    db $08, $14, $08, $0a, $04, $50, $20, $28, $10, $28, $10, $2e, $10, $42, $3c, $2e
    db $10, $28, $10, $50, $20, $0a, $04, $05, $02, $02, $01, $01, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $91, $00, $6e, $91, $81, $7e, $6e, $10, $28
    db $10, $38, $00, $00, $00, $50, $20, $a0, $40, $40, $80, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $a0, $40, $a0, $40, $a0, $40, $a0, $40, $a0, $40, $a0
    db $40, $a0, $40, $e0, $00, $ff, $00, $80, $7f, $bf, $40, $a0, $40, $a0, $40, $a0
    db $40, $a0, $40, $a0, $40, $ff, $00, $01, $fe, $ff, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $ce, $39, $00, $00, $ff, $7f, $0b, $5b, $ce, $39, $00
    db $00, $e8, $7e, $e3, $4c, $ce, $39, $00, $00, $df, $19, $73, $04
    assert @ == $1C6C

SECTION "Remaining ROM 00:2633-26B6", ROM0[$2633]
RemainingROM_Bank00_2633::
MapControl_RunPhaseController::
    farcall MapControl_InitializeRuntimeOnce
    farcall MapControl_InitializePhaseRuntime
    farcall MapControl_CheckLatePhaseResolution
    and a
    jp z, .loc_264A
    farcall MapControl_TriggerLatePhaseResolution
    and a
    jr nz, .loc_268A
.loc_264A:
    xor a
    ld [$c99d], a
.loc_264E:
    ld a, [$c99d]
    ld b, a
    add a, a
    add a, b
    ld hl, $2692
    call AddAtoHL
    ld a, [hli]
    and a
    jr z, .loc_267A
    ld b, a
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ldh a, [$ff80]
    push af
    call CallHLInBankB
    pop af
    ldh [$ff80], a
    ld [$2000], a
    ld a, [$ca94]
    and a
    jr nz, .loc_268A
    ld hl, $c99d
    inc [hl]
    jr .loc_264E
.loc_267A:
    farcall MapControl_PostAIActionUpdate
    ld a, [$ca94]
    and a
    jp nz, .loc_268A
    ld a, $3c
    call AdvanceFrames
.loc_268A:
    ret
CallHLInBankB::
    ld a, b
    ldh [$ff80], a
    ld [$2000], a
    jp hl
MapControl_PhaseHandlerTable::
    banked_callback MapAI_ProcessActiveUnitActions
    banked_callback MapAI_PlanBridgeConstruction
    banked_callback MapAI_RunAirTransportRouting
    banked_callback MapAI_RunTransportShipRouting
    banked_callback MapAI_RunAttackPlannerFamily0
    banked_callback $0d, $62ad ; alternate family-1 entry, one byte after public wrapper
    banked_callback MapAI_RunBomberAreaAttackPlanner
    banked_callback MapAI_TacticalPlanningSweepA
    banked_callback MapAI_TacticalPlanningSweepB
    banked_callback MapAI_RunAirTransportRouting
    banked_callback MapAI_RunTransportShipRouting
    banked_callback MapAI_BuildProcurementState
    db $00 ; end of handler table
    assert @ == $26B7

SECTION "Remaining ROM 00:26CB-289F", ROM0[$26CB]
RemainingROM_Bank00_26CB::
    ; Source-owned structural bytes formerly data/home/structural/bank00_26cb_2813.dat
    db $f5, $f0, $44, $3c, $e6, $0f, $28, $18, $e6, $07, $20, $26, $f0, $96, $cb, $5f
    db $20, $08, $f0, $95, $d6, $04, $e0, $43, $18, $18, $f0, $95, $e0, $43, $18, $12
    db $f0, $96, $cb, $5f, $20, $06, $f0, $95, $e0, $43, $18, $06, $f0, $95, $d6, $04
    db $e0, $43, $f1, $d9, $f5, $c5, $d5, $e5, $21, $01, $c0, $cb, $46, $20, $47, $cb
    db $c6, $fa, $c4, $c9, $e6, $1f, $cb, $27, $cb, $27, $cb, $27, $e0, $96, $e0, $42
    db $e6, $08, $0f, $47, $fa, $c3, $c9, $e6, $1f, $cb, $27, $cb, $27, $cb, $27, $e0
    db $95, $90, $e0, $43, $fa, $0f, $c0, $e0, $40, $fa, $0e, $c0, $a7, $28, $07, $cd
    db $84, $ff, $af, $ea, $0e, $c0, $cd, $56, $27, $fb, $cd, $1b, $07, $21, $8e, $ff
    db $34, $21, $01, $c0, $cb, $86, $e1, $d1, $c1, $f1, $d9, $f0, $ac, $cb, $7f, $c8
    db $cb, $57, $20, $18, $cb, $5f, $20, $14, $cb, $47, $20, $08, $cd, $ba, $27, $a7
    db $20, $1a, $18, $10, $cd, $88, $27, $a7, $20, $12, $18, $08, $cd, $e7, $27, $a7
    db $20, $0a, $18, $00, $f0, $ac, $cb, $bf, $cb, $f7, $e0, $ac, $c9, $f0, $83, $f5
    db $f0, $82, $f5, $f0, $ae, $4f, $f0, $af, $57, $f0, $ad, $47, $cb, $41, $28, $01
    db $05, $cd, $14, $28, $f0, $44, $fe, $8e, $38, $04, $0c, $15, $20, $eb, $f1, $e0
    db $82, $e0, $70, $f1, $e0, $83, $e0, $4f, $79, $e0, $ae, $7a, $e0, $af, $c9, $f0
    db $83, $f5, $f0, $82, $f5, $f0, $ad, $47, $f0, $ae, $4f, $f0, $af, $57, $cd, $14
    db $28, $f0, $44, $fe, $8e, $38, $04, $0c, $15, $20, $f3, $f1, $e0, $82, $e0, $70
    db $f1, $e0, $83, $e0, $4f, $79, $e0, $ae, $7a, $e0, $af, $c9, $f0, $83, $f5, $f0
    db $82, $f5, $f0, $ad, $47, $f0, $ae, $4f, $f0, $af, $57, $cd, $14, $28, $f0, $44
    db $fe, $8e, $38, $04, $04, $15, $20, $f3, $f1, $e0, $82, $e0, $70, $f1, $e0, $83
    db $e0, $4f, $78, $e0, $ad, $7a, $e0, $af, $c9
RuntimeEntry_Bank00_2814::
    push de
    call .loc_283A
    ld a, $01
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, [hl]
    and $3f
    ld d, a
    ld hl, $286e
    add a, l
    ld l, a
    ld a, h
    adc a, $00
    ld h, a
    ld e, [hl]
    call .loc_2858
    ld a, $01
    ldh [$ff4f], a
    ld [hl], e
    xor a
    ldh [$ff4f], a
    ld [hl], d
    pop de
    ret
.loc_283A:
    push bc
    ld a, b
    cp $f0
    jr c, .loc_2842
    ld b, $32
.loc_2842:
    ld a, c
    cp $f0
    jr c, .loc_2849
    ld a, $32
.loc_2849:
    rrca
    rrca
    ld l, a
    and $0f
    add a, $d0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    pop bc
    ret
.loc_2858:
    ld a, c
    and $1f
    rlca
    swap a
    ld l, a
    and $0f
    add a, $98
    ld h, a
    ld a, $f0
    and l
    ld l, a
    ld a, b
    and $1f
    add a, l
    ld l, a
    ret
    ; Source-owned structural bytes formerly data/home/structural/bank00_286e_289f.dat
    db $00, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $03, $02, $00, $00, $01, $03, $01, $01, $05, $05, $05, $05, $05, $05, $05, $05
    db $05, $05
    assert @ == $28A0

SECTION "Remaining ROM 00:2A82-2A82", ROM0[$2A82]
RemainingROM_Bank00_2A82::
    ds $1, $00
    assert @ == $2A83

SECTION "Remaining ROM 00:2AEE-2D7B", ROM0[$2AEE]
RemainingROM_Bank00_2AEE::
    ; Source-owned structural bytes formerly data/home/structural/bank00_2aee_2b37.dat
    db $21, $cb, $32, $cb, $53, $cb, $64, $cb, $83, $cb, $94, $cb, $a5, $cb, $78, $ea
    db $c9, $cb, $79, $ea, $cb, $cb, $af, $ea, $ca, $cb, $7e, $fe, $00, $28, $2a, $fe
    db $01, $20, $0c, $af, $ea, $ca, $cb, $fa, $cb, $cb, $3c, $ea, $cb, $cb, $23, $fa
    db $ca, $cb, $4f, $fa, $c9, $cb, $81, $47, $fa, $cb, $cb, $4f, $2a, $cd, $ed, $34
    db $fa, $ca, $cb, $3c, $ea, $ca, $cb, $18, $d1, $c9
TextPrint::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, b
    ld [$cbc9], a
    ld a, c
    ld [$cbcb], a
    xor a
    ld [$cbca], a
.loc_2B4D:
    ld a, [hl]
    cp $00
    jr z, .loc_2B85
    cp $01
    jr nz, .loc_2B64
    xor a
    ld [$cbca], a
    ld a, [$cbcb]
    inc a
    ld [$cbcb], a
    inc hl
    jr .loc_2B4D
.loc_2B64:
    ld a, [$cbca]
    ld c, a
    ld a, [$cbc9]
    add a, c
    ld b, a
    ld a, [$cbcb]
    ld c, a
    ld a, [hli]
    push hl
    push af
    call Vram_TilemapCoord
    pop af
    call Vram_Put
    pop hl
    ld a, [$cbca]
    inc a
    ld [$cbca], a
    jr .loc_2B4D
.loc_2B85:
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ret
    ; Source-owned structural bytes formerly data/home/structural/bank00_2b8b_2c0a.dat
    db $f0, $83, $f5, $3e, $00, $e0, $83, $e0, $4f, $78, $ea, $c9, $cb, $79, $ea, $cb
    db $cb, $af, $ea, $ca, $cb, $7e, $fe, $00, $20, $15, $23, $7e, $fe, $00, $28, $30
    db $2b, $af, $ea, $ca, $cb, $fa, $cb, $cb, $3c, $ea, $cb, $cb, $23, $18, $e6, $fa
    db $ca, $cb, $4f, $fa, $c9, $cb, $81, $47, $fa, $cb, $cb, $4f, $2a, $e5, $f5, $cd
    db $d4, $0e, $f1, $cd, $1c, $0f, $e1, $fa, $ca, $cb, $3c, $ea, $ca, $cb, $18, $c5
    db $f1, $e0, $83, $e0, $4f, $c9, $e5, $58, $51, $af, $f5, $d5, $06, $02, $cd, $95
    db $29, $01, $14, $75, $09, $2a, $47, $7e, $60, $6f, $d1, $cd, $ca, $29, $28, $0b
    db $f1, $3c, $fe, $00, $20, $e4, $e1, $3e, $0a, $37, $c9, $f1, $e1, $37, $3f, $c9
RuntimeEntry_Bank00_2C0B::
    ld a, h
    ld [$df00], a
    ld a, l
    ld [$df01], a
    ld a, d
    ld [$df04], a
    ld a, e
    ld [$df05], a
    xor a
    ld [$df02], a
    ld [$df03], a
    ld [$df06], a
    ld [$df07], a
    ld a, [$df00]
    ld h, a
    ld a, [$df01]
    ld l, a
.loc_2C30:
    ld a, [hl]
    cp $00
    jr z, .loc_2C5B
    ld a, [hl]
    call $63de
    jr c, .loc_2C49
    ld a, [hl]
    call $63f0
    jr c, .loc_2C43
    jr .loc_2C4F
.loc_2C43:
    ld a, [hl]
    call .loc_2CC5
    jr .loc_2C30
.loc_2C49:
    ld a, [hl]
    call .loc_2C5C
    jr .loc_2C30
.loc_2C4F:
    ld a, [hl]
    call .loc_2CFC
    jr .loc_2C30
    db $7e, $cd, $91, $2c, $18, $d5
.loc_2C5B:
    ret
.loc_2C5C:
    push hl
    xor a
    ld b, a
    ld a, [hl]
    ld c, a
    call Text_ConvertShiftJISToGameCode
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
    ld de, $dc0e
    call Math_CompareHLToDE
    jr z, .loc_2C83
    pop af
    ld [hl], a
    inc hl
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    pop hl
    inc hl
    ret
.loc_2C83:
    ld hl, $dc0e
    ld [hl], $00
    ld hl, $dc0f
    ld [hl], $00
    pop af
    pop hl
    inc hl
    ret
    ; Source-owned structural bytes formerly data/home/structural/bank00_2c91_2cc4.dat
    db $e5, $af, $47, $7e, $4f, $3e, $0a, $f5, $fa, $04, $df, $67, $fa, $05, $df, $6f
    db $11, $0e, $dc, $cd, $ca, $29, $28, $0e, $f1, $77, $23, $7c, $ea, $04, $df, $7d
    db $ea, $05, $df, $e1, $23, $c9, $21, $0e, $dc, $36, $00, $21, $0f, $dc, $36, $00
    db $f1, $e1, $23, $c9
.loc_2CC5:
    push hl
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    call Text_ConvertShiftJISToGameCode
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
    ld de, $dc0e
    call Math_CompareHLToDE
    jr z, .loc_2CED
    pop af
    ld [hl], a
    inc hl
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    pop hl
    inc hl
    inc hl
    ret
.loc_2CED:
    ld hl, $dc0e
    ld [hl], $00
    ld hl, $dc0f
    ld [hl], $00
    pop af
    pop hl
    inc hl
    inc hl
    ret
.loc_2CFC:
    push hl
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    ld a, $0a
    push af
    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
    call Math_CompareHLToDE
    jr z, .loc_2D20
    pop af
    ld [hl], a
    inc hl
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    pop hl
    inc hl
    inc hl
    ret
.loc_2D20:
    ld hl, $dc0e
    ld [hl], $00
    ld hl, $dc0f
    ld [hl], $00
    pop af
    pop hl
    inc hl
    ret
RuntimeEntry_Bank00_2D2E::
    ldh a, [$ff80]
    push af
    ld a, $33
    ldh [$ff80], a
    ld [$2000], a
    ld h, d
    ld l, e
    ld bc, $0207
    call TextPrint
    farcall BANK_31, Bank31_Entry_718C
    pop af
    ldh [$ff80], a
    ld [$2000], a
    ret
    ; Source-owned structural bytes formerly data/home/structural/bank00_2d4b_2d7b.dat
    db $f0, $80, $f5, $3e, $33, $e0, $80, $ea, $00, $20, $62, $6b, $01, $07, $02, $cd
    db $38, $2b, $f1, $e0, $80, $ea, $00, $20, $c9, $e5, $1a, $b7, $28, $04, $22, $13
    db $18, $f8, $36, $00, $e1, $c9, $e5, $2a, $b7, $20, $fc, $2b, $cd, $64, $2d, $e1
    db $c9
    assert @ == $2D7C

SECTION "Remaining ROM 00:31F5-338A", ROM0[$31F5]
RemainingROM_Bank00_31F5::
RuntimeEntry_Bank00_31F5::
    push bc
    push hl
    push de
    ld l, a
    ld h, $00
    ld a, $20
    ld [$cc45], a
RuntimeEntry_Bank00_3200::
    push de
    push bc
    ld de, $cc46
    ld bc, $ff9c
    call RuntimeEntry_Bank00_3334
    ld bc, $fff6
    call RuntimeEntry_Bank00_3334
    ld a, $30
    ld [$cc45], a
    ld bc, $ffff
    call RuntimeEntry_Bank00_3334
    pop bc
    pop de
    call Vram_TilemapCoord
    ld b, d
    push bc
    ld a, $03
    sub d
    ld c, a
    ld b, $00
    ld e, l
    ld d, h
    ld hl, $cc46
    add hl, bc
    pop bc
    call VBlankFIFO_Queue
    pop de
    pop hl
    pop bc
    ret
DrawNumberFixedWidth::
    push bc
    push hl
    push de
    ld l, a
    ld h, $00
    ld a, $30
    ld [$cc45], a
    jr RuntimeEntry_Bank00_3200
RuntimeEntry_Bank00_3244::
    push bc
    push hl
    push de
    ld l, a
    ld h, $00
    ld a, $5f
    ld [$cc45], a
    jr RuntimeEntry_Bank00_3200
RuntimeEntry_Bank00_3251::
    ld a, $20
    ld [$cc45], a
    jr RuntimeEntry_Bank00_325D
RuntimeEntry_Bank00_3258::
    ld a, $30
    ld [$cc45], a
RuntimeEntry_Bank00_325D::
    push bc
    push de
    push hl
    push de
    push bc
    ld de, $cc46
    ld bc, $d8f0
    call RuntimeEntry_Bank00_3334
    ld bc, $fc18
    call RuntimeEntry_Bank00_3334
    ld bc, $ff9c
    call RuntimeEntry_Bank00_3334
    ld bc, $fff6
    call RuntimeEntry_Bank00_3334
    ld bc, $ffff
    ld a, $30
    ld [$cc45], a
    call RuntimeEntry_Bank00_3334
    pop bc
    pop de
    call Vram_TilemapCoord
    ld b, d
    push bc
    ld a, $05
    sub d
    ld c, a
    ld b, $00
    ld e, l
    ld d, h
    ld hl, $cc46
    add hl, bc
    pop bc
    call VBlankFIFO_Queue
    pop hl
    pop de
    pop bc
    ret
RuntimeEntry_Bank00_32A3::
    push bc
    push de
    push hl
    ld a, $02
    call AddAtoHL
    ld d, [hl]
    dec hl
    dec hl
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, $20
    ld [$cc45], a
    push bc
    ld a, d
    and a
    jr z, .loc_32CC
    ld bc, $15a0
    add hl, bc
    ld a, $35
    ld bc, $d8f0
    ld de, $cc46
    call .loc_3317
    jr .loc_32D5
.loc_32CC:
    ld de, $cc46
    ld bc, $d8f0
    call .loc_3315
.loc_32D5:
    ld bc, $fc18
    call .loc_3315
    ld bc, $ff9c
    call .loc_3315
    ld bc, $fff6
    call .loc_3315
    ld bc, $ffff
    ld a, $30
    ld [$cc45], a
    call .loc_3315
    ld a, $00
    ld [de], a
    pop bc
    pop hl
    pop de
    call Vram_TilemapCoord
    ld b, d
    push bc
    ld a, $05
    sub d
    ld c, a
    ld b, $00
    ld e, l
    ld d, h
    ld hl, $cc46
    add hl, bc
    pop bc
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    call VBlankFIFO_Queue
    pop bc
    ret
.loc_3315:
    ld a, $2f
.loc_3317:
    inc a
    add hl, bc
    jr c, .loc_3317
    cp $30
    jr z, .loc_3328
    push af
    ld a, $30
    ld [$cc45], a
    pop af
    jr .loc_332B
.loc_3328:
    ld a, [$cc45]
.loc_332B:
    ld [de], a
    inc de
    ld a, l
    sub c
    ld l, a
    ld a, h
    sbc a, b
    ld h, a
    ret
RuntimeEntry_Bank00_3334::
    ld a, $2f
.loc_3336:
    inc a
    add hl, bc
    jr c, .loc_3336
    cp $30
    jr z, .loc_3347
    push af
    ld a, $30
    ld [$cc45], a
    pop af
    jr .loc_334A
.loc_3347:
    ld a, [$cc45]
.loc_334A:
    ld [de], a
    inc de
    ld a, l
    sub c
    ld l, a
    ld a, h
    sbc a, b
    ld h, a
    ret
TextPut::
    push hl
    push bc
    push hl
    call Vram_TilemapCoord
    ld d, h
    ld e, l
    ld b, $00
    pop hl
    push hl
.loc_335F:
    ld a, [hli]
    cp $00
    jr z, .loc_3367
    inc b
    jr .loc_335F
.loc_3367:
    pop hl
    call VBlankFIFO_Queue
    pop bc
    pop hl
    ret
CoordTextPut::
    push bc
    ld b, [hl]
    inc hl
    ld c, [hl]
    inc hl
    push hl
    call Vram_TilemapCoord
    ld d, h
    ld e, l
    pop hl
    push hl
    ld b, $00
.loc_337D:
    ld a, [hli]
    cp $00
    jr z, .loc_3385
    inc b
    jr .loc_337D
.loc_3385:
    pop hl
    call VBlankFIFO_Queue
    pop bc
    ret
    assert @ == $338B

SECTION "Remaining ROM 00:3537-357A", ROM0[$3537]
RemainingROM_Bank00_3537::
VBlankFIFO_Process::
    ldh a, [$ffc9]
    ld l, a
    ld h, $c3
.loc_353C:
    ld de, $ffca
    ld a, [de]
    or a
    jr z, .loc_3573
    dec a
    ld [de], a
    ld c, l
    ld b, [hl]
    inc l
    ld e, [hl]
    inc l
    ld d, [hl]
    inc l
    bit 7, d
    jr z, .loc_3555
    xor a
    ldh [$ff4f], a
    jr .loc_355B
.loc_3555:
    ld a, $01
    ldh [$ff4f], a
    set 7, d
.loc_355B:
    ld a, [hl]
    inc l
    ld [de], a
    inc de
    dec b
    jr nz, .loc_355B
    ld a, [$c00f]
    rla
    jr nc, .loc_353C
    ldh a, [$ff44]
    cp $8e
    jr nc, .loc_353C
    ld hl, $ffca
    inc [hl]
    ld l, c
.loc_3573:
    ld a, l
    ldh [$ffc9], a
    ldh a, [$ff83]
    ldh [$ff4f], a
    ret
    assert @ == $357B

SECTION "Remaining ROM 00:36C4-377B", ROM0[$36C4]
RemainingROM_Bank00_36C4::
    ; Source-owned structural bytes formerly data/home/structural/bank00_36c4_377b.dat
    db $f0, $80, $f5, $af, $ea, $54, $cc, $ea, $55, $cc, $ea, $50, $cc, $ea, $51, $cc
    db $fa, $57, $cc, $4f, $fa, $55, $cc, $b9, $d2, $75, $37, $fa, $54, $cc, $4f, $fa
    db $52, $cc, $81, $47, $fa, $55, $cc, $4f, $fa, $53, $cc, $81, $4f, $cd, $d4, $0e
    db $e5, $3e, $00, $e0, $83, $e0, $4f, $f5, $fa, $61, $cc, $7f, $e0, $80, $ea, $00
    db $20, $f1, $fa, $59, $cc, $6f, $fa, $58, $cc, $67, $fa, $50, $cc, $4f, $fa, $51
    db $cc, $47, $09, $7e, $e1, $e5, $cd, $1c, $0f, $3e, $01, $e0, $83, $e0, $4f, $f5
    db $fa, $62, $cc, $7f, $e0, $80, $ea, $00, $20, $f1, $fa, $5b, $cc, $6f, $fa, $5a
    db $cc, $67, $fa, $50, $cc, $4f, $fa, $51, $cc, $47, $09, $7e, $e1, $cd, $1c, $0f
    db $fa, $51, $cc, $47, $fa, $50, $cc, $4f, $03, $78, $ea, $51, $cc, $79, $ea, $50
    db $cc, $fa, $54, $cc, $3c, $ea, $54, $cc, $fa, $56, $cc, $4f, $fa, $54, $cc, $b9
    db $da, $df, $36, $af, $ea, $54, $cc, $fa, $55, $cc, $3c, $ea, $55, $cc, $c3, $d4
    db $36, $f1, $e0, $80, $ea, $00, $20, $c9
    assert @ == $377C

SECTION "Remaining ROM 00:3A8E-3A92", ROM0[$3A8E]
RemainingROM_Bank00_3A8E::
RuntimeEntry_Bank00_3A8E::
    ret
CallWordTableByIndex::
    call WordTable_Get
    jp hl
    assert @ == $3A93

SECTION "Remaining ROM 00:3A9E-3AC6", ROM0[$3A9E]
RemainingROM_Bank00_3A9E::
WordTable_GetFirstSetBitEntry::
    push bc
    ld b, $00
    rrca
    jr c, .loc_3AC1
    inc b
    rrca
    jr c, .loc_3AC1
    inc b
    rrca
    jr c, .loc_3AC1
    inc b
    rrca
    jr c, .loc_3AC1
    inc b
    rrca
    jr c, .loc_3AC1
    inc b
    rrca
    jr c, .loc_3AC1
    inc b
    rrca
    jr c, .loc_3AC1
    inc b
    rrca
    jr c, .loc_3AC1
    inc b
.loc_3AC1:
    ld a, b
    call WordTable_Get
    pop bc
    ret
    assert @ == $3AC7

SECTION "Remaining ROM 00:3B06-3B4F", ROM0[$3B06]
RemainingROM_Bank00_3B06::
Farcall::
    ldh [$ffce], a
    ldh a, [$ff80]
    push af
    push bc
    ld a, l
    ldh [$ffcf], a
    ld a, h
    ldh [$ffd0], a
    ld hl, sp + 4
    ld a, [hl]
    ld c, a
    add a, $03
    ld [hli], a
    ld a, [hl]
    ld b, a
    adc a, $00
    ld [hl], a
    ld l, c
    ld h, b
    ld a, [hli]
    push af
    ld a, [hli]
    ld h, [hl]
    ld l, a
    pop af
    ldh [$ff80], a
    ld [$2000], a
    pop bc
    call Farcall_Jump
    push af
    ld a, b
    ldh [$ffce], a
    ld a, c
    ldh [$ffcf], a
    pop bc
    pop af
    ldh [$ff80], a
    ld [$2000], a
    push bc
    ldh a, [$ffce]
    ld b, a
    ldh a, [$ffcf]
    ld c, a
    pop af
    ret
Farcall_Jump::
    push hl
    ldh a, [$ffcf]
    ld l, a
    ldh a, [$ffd0]
    ld h, a
    ldh a, [$ffce]
    ret
    assert @ == $3B50

SECTION "Remaining ROM 00:3C63-3DFF", ROM0[$3C63]
RemainingROM_Bank00_3C63::
    ds $19d, $ff
    assert @ == $3E00

SECTION "Remaining ROM 00:3EAB-3FDF", ROM0[$3EAB]
RemainingROM_Bank00_3EAB::
    ; Source-owned structural bytes formerly data/home/structural/bank00_3eab_3fdf.dat
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff
    assert @ == $3FE0

SECTION "Remaining ROM 00:3FF6-3FFF", ROM0[$3FF6]
RemainingROM_Bank00_3FF6::
    ds $a, $00
    assert @ == $4000

SECTION "Remaining ROM 01:5118-511F", ROMX[$5118], BANK[$01]
RemainingROM_Bank01_5118::
    db $00, $00, $00, $69, $ff, $7f, $40, $72
    assert @ == $5120

SECTION "Remaining ROM 01:5260-5267", ROMX[$5260], BANK[$01]
RemainingROM_Bank01_5260::
    db $00, $00, $80, $69, $ff, $7f, $c0, $72
    assert @ == $5268

SECTION "Remaining ROM 01:5868-5897", ROMX[$5868], BANK[$01]
RemainingROM_Bank01_5868::
    db $00, $00, $8c, $31, $25, $7e, $91, $7f, $00, $00, $6c, $03, $54, $15, $1b, $1f
    db $00, $00, $ff, $7f, $e0, $67, $cd, $45, $00, $00, $ff, $03, $ec, $03, $80, $02
    db $00, $00, $9f, $52, $e0, $7e, $9c, $00, $25, $7e, $e0, $7c, $60, $40, $91, $7f
    assert @ == $5898

SECTION "Structural UI/Icon Tiles 01:6648-6987", ROMX[$6648], BANK[$01]
StructuralUIIconTiles_Bank01_6648::
    INCBIN "gfx/structural/bank01_ui_icon_tiles_6648_6987.2bpp"
    assert @ == $6988

SECTION "Bank 01 Tail Padding", ROMX[$6988], BANK[$01]
    ds $1678, $ff
    assert @ == $8000

SECTION "Mobile Debug/Test Harness", ROMX[$4B9B], BANK[$02]
; Retail diagnostic harness for Mobile Adapter/PPP/HTTP bring-up. The embedded
; ASCII status strings and connection-test constants are kept byte-exact.
MobileDebug_RunHarness::
    call $04f3
    farcall BANK(SharedGraphics_LoadMainFontBG), SharedGraphics_LoadMainFontBG
    ld hl, $9800
    ld bc, $0800
    ld a, $20
    call $3b79
    ld hl, $4be8
    ld b, $00
    ld c, $00
    call $3353
    ld hl, $4bf3
    ld b, $00
    ld c, $20
    call $3353
    call $038b
    xor a
    ld [$c911], a
    ld [$c912], a
    call MobileDebug_InitializeState
    call $04e5
MobileDebug_MainLoop::
    call $04d2
    call $05ac
    ldh a, [$ff91]
    bit 3, a
    jr nz, MobileDebug_Exit
    call MobileDebug_UpdateCounter
    call MobileDebug_ToggleDisplay
    call MobileDebug_UpdateState
    jr MobileDebug_MainLoop
    db $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $00, $41, $42, $43, $44, $45
    db $46, $47, $48, $49, $4a, $00
MobileDebug_Exit::
    call $04f3
    call $039d
    jp $4b68
MobileDebug_UpdateCounter::
    ld a, [$c911]
    inc a
    ld [$c911], a
    ld b, $0a
    ld c, $09
    jp $34ed
MobileDebug_ToggleDisplay::
    ldh a, [$ff91]
    bit 0, a
    ret z
    ld a, [$c912]
    xor $01
    ld [$c912], a
    jp z, $051f
    ld a, $07
    ldh [$ff97], a
    xor a
    ldh [$ff98], a
    jp $0514
    db $4d, $4f, $42, $49, $4c, $45, $20, $53, $59, $53, $20, $49, $4e, $49, $54, $2e
    db $2e, $2e, $20, $20, $00, $50, $50, $50, $20, $43, $4f, $4e, $4e, $45, $43, $54
    db $49, $4e, $47, $2e, $2e, $2e, $20, $20, $20, $00, $48, $54, $54, $50, $20, $44
    db $41, $54, $41, $20, $52, $45, $41, $44, $2e, $2e, $2e, $20, $20, $20, $00, $45
    db $52, $52, $4f, $52, $21, $20, $45, $52, $52, $4f, $52, $21, $20, $45, $52, $52
    db $4f, $52, $21, $00, $52, $45, $41, $44, $20, $4f, $4b, $21, $20, $50, $52, $45
    db $53, $53, $20, $41, $5f, $42, $54, $4e, $00, $44, $45, $42, $55, $47, $20, $57
    db $41, $49, $54, $20, $57, $41, $49, $54, $20, $57, $41, $49, $54, $00, $4f, $46
    db $46, $4c, $49, $4e, $45, $20, $57, $41, $49, $54, $2e, $2e, $2e, $2e, $2e, $2e
    db $2e, $2e, $00, $30, $37, $35, $36, $30, $35, $36, $36, $31, $35, $00, $67, $30
    db $30, $30, $30, $30, $31, $30, $33, $39, $00, $67, $62, $70, $77, $31, $30, $33
    db $39, $00
MobileDebug_CopyConnectionParameters::
    ld hl, $4cc2
    ld de, $c915
    ld b, $1f
MobileDebug_CopyConnectionParametersLoop::
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, MobileDebug_CopyConnectionParametersLoop
    ret
MobileDebug_PrepareConnectionPointers::
    call MobileDebug_CopyConnectionParameters
    ld de, $000b
    ld hl, $c915
    add hl, de
    ld a, l
    ld [$c915], a
    ld a, h
    ld [$c916], a
    ld de, $0016
    ld hl, $c915
    add hl, de
    ld a, l
    ld [$c917], a
    ld a, h
    ld [$c918], a
    ret
MobileDebug_InitializeState::
    call MobileDebug_ResetState
    ret
MobileDebug_UpdateState::
    ld a, [$c913]
    or a
    jp nz, MobileDebug_DispatchState
    ldh a, [$ff91]
    bit 6, a
    jr nz, MobileDebug_StartMobileSystem
    ret
MobileDebug_ResetState::
    xor a
    ld [$c913], a
    ret
MobileDebug_DispatchState::
    ld a, [$c913]
    dec a
    jr z, MobileDebug_WaitPPP
    dec a
    jp z, MobileDebug_StartHTTPRead
    dec a
    jp z, MobileDebug_WaitHTTPRead
    dec a
    jp z, MobileDebug_FinishRead
    xor a
    ld [$c913], a
    ret
MobileDebug_StartMobileSystem::
    ld b, $00
    ld c, $11
    ld hl, $4c2f
    call $3353
    ld hl, $c913
    inc [hl]
    farcall BANK_0A, Bank0A_Entry_4039
MobileDebug_WaitPPP::
    farcall BANK_0A, Bank0A_Entry_4012
    jr c, MobileDebug_ShowError
    or a
    ret nz
    ld b, $00
    ld c, $11
    ld hl, $4c44
    call $3353
    ld hl, $c913
    inc [hl]
    call MobileDebug_CopyConnectionParameters
    ld hl, $c915
    farcall BANK_0A, Bank0A_Entry_4073
MobileDebug_StartHTTPRead::
    farcall BANK_0A, Bank0A_Entry_4012
    jp c, MobileDebug_ShowError
    or a
    ret nz
    ld b, $00
    ld c, $11
    ld hl, $4c59
    call $3353
    ld hl, $c913
    ld [hl], $03
    call MobileDebug_PrepareConnectionPointers
    ld de, $c915
    farcall BANK_0A, Bank0A_Entry_48AE
MobileDebug_WaitHTTPRead::
    farcall BANK_0A, Bank0A_Entry_48E9
    jp c, MobileDebug_ShowError
    or a
    ret nz
    ld b, $00
    ld c, $11
    ld hl, $4cad
    call $3353
    ld hl, $c913
    ld [hl], $04
    farcall BANK_0A, Bank0A_Entry_43D4
MobileDebug_FinishRead::
    farcall BANK_0A, Bank0A_Entry_4012
    jr c, MobileDebug_ShowError
    or a
    ret nz
    farcall BANK_0A, Bank0A_Entry_406B
    ld b, $00
    ld c, $11
    ld hl, $4c83
    call $3353
    ld [$c914], a
    xor a
    ld [$c913], a
    ret
MobileDebug_ShowError::
    ld b, $00
    ld c, $11
    ld hl, $4c6e
    call $3353
    xor a
    ld [$c913], a
    ret
    assert @ == $4DDD

SECTION "Bank 02 Padding", ROMX[$4DDD], BANK[$02]
    ds $3223, $ff
    assert @ == $8000





SECTION "Remaining ROM 08:6801-7FFF", ROMX[$6801], BANK[$08]
RemainingROM_Bank08_6801::
    INCBIN "audio/raw_resources/sfx_bank08_tail_6801_7fff.sfx"
    assert @ == $8000


SECTION "Remaining ROM 09:6882-7FFF", ROMX[$6882], BANK[$09]
RemainingROM_Bank09_6882::
    INCBIN "audio/raw_resources/sfx_bank09_tail_6882_7fff.sfx"
    assert @ == $8000

SECTION "Remaining ROM 0A:4000-7FFF", ROMX[$4000], BANK[$0A]
RemainingROM_Bank0A_4000::
    db $3e, $07, $e0, $82, $e0, $70, $3e, $0f, $cd, $8d, $05, $cd, $93, $05, $cd, $9b, $05, $c9
RuntimeEntry_Bank0A_4012::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $01
    call RuntimeEntry_Bank00_1025
    jr c, .loc_4025
    push af
    call .loc_4025
    pop af
    ret
.loc_4025:
    ld a, [$c8bc]
    ld [$c8e3], a
    ld a, [$c8bd]
    ld [$c8e4], a
    ld a, [$c8bb]
    ld [$c8e2], a
    scf
    ret
RuntimeEntry_Bank0A_4039::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld hl, $d000
    ld bc, $0480
    ld hl, $d480
    ld bc, $03ae
    call .loc_4060
    xor a
    ld [$c8c1], a
    ld a, $00
    ld de, $c8e6
    ld hl, $0000
    ld bc, $0000
    jp RuntimeEntry_Bank00_0FC2
.loc_4060:
    xor a
    ld [hli], a
    dec bc
    ld a, b
    or c
    jr nz, .loc_4060
    ret
RuntimeEntry_Bank0A_4068::
    jp RuntimeEntry_Bank0A_4012
RuntimeEntry_Bank0A_406B::
    ld a, $13
    jp RuntimeEntry_Bank00_0FC2
RuntimeEntry_Bank0A_4070::
    jp RuntimeEntry_Bank0A_4012
RuntimeEntry_Bank0A_4073::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $15
    jp RuntimeEntry_Bank00_0FC2
RuntimeEntry_Bank0A_407E::
    jp RuntimeEntry_Bank0A_4012
RuntimeEntry_Bank0A_4081::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call Mobile_GetStatusFlags
    bit 0, a
    jr z, .loc_40AB
    swap a
    srl a
    and $07
    cp $04
    jr z, .loc_40A2
    cp $05
    jr z, .loc_40A2
    cp $01
    jr z, .loc_40A2
    jr .loc_40AB
.loc_40A2:
    ld a, $14
    call RuntimeEntry_Bank00_0FC2
    ld a, $ff
    scf
    ret
.loc_40AB:
    xor a
    ret
RuntimeEntry_Bank0A_40AD::
    jp RuntimeEntry_Bank0A_4012
RuntimeEntry_Bank0A_40B0::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_40B3::
    ld a, [de]
    ld [hli], a
    or a
    jr z, .loc_40BC
    inc de
    dec b
    jr nz, RuntimeEntry_Bank0A_40B3
.loc_40BC:
    ret
RuntimeEntry_Bank0A_40BD::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_40C0::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_40C3::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_40C6::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_40C9::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_40CC::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_40CF::
    jp RuntimeEntry_Bank00_10B9
    db $c3, $b9, $10, $c3, $b9, $10, $c3, $b9, $10, $c3, $b9, $10, $c3, $b9, $10, $c3, $b9, $10, $c3, $b9, $10, $c3, $b9, $10, $c3, $b9, $10, $c3, $b9, $10
RuntimeEntry_Bank0A_40F0::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_40F3::
    jp RuntimeEntry_Bank00_10B9
    db $c3, $b9, $10, $3e, $07, $e0, $82, $e0, $70, $3e, $0f, $cd, $8d, $05, $cd, $93, $05
RuntimeEntry_Bank0A_4107::
    ld a, e
    ld [$d6bd], a
    ld a, d
    ld [$d6be], a
    ld de, $a0cc
    ld a, c
    ld [$d6bf], a
    ld a, b
    ld [$d6c0], a
    ld a, $0e
    ld [$d6bc], a
    call RuntimeEntry_Bank0A_432A
    jp RuntimeEntry_Bank00_0FC2
RuntimeEntry_Bank0A_4125::
    ld a, e
    ld [$d6bd], a
    ld a, d
    ld [$d6be], a
    ld de, $d480
    ld a, c
    ld [$d6bf], a
    ld a, b
    ld [$d6c0], a
    ld a, $0e
    ld [$d6bc], a
    call RuntimeEntry_Bank0A_432A
    jp RuntimeEntry_Bank00_0FC2
RuntimeEntry_Bank0A_4143::
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call RuntimeEntry_Bank0A_4012
    push af
    jr c, .loc_4162
    or a
    jr nz, .loc_4192
    call RuntimeEntry_Bank0A_41DF
    call RuntimeEntry_Bank0A_4205
    jr .loc_418F
.loc_4162:
    ld a, [$c8e2]
    cp $ff
    jr z, .loc_4189
    ld a, [$c8bb]
    cp $32
    jr nz, .loc_418F
    ld a, [$c8bd]
    cp $03
    jr nz, .loc_418F
    ld a, [$c8bc]
    dec a
    cp $02
    jr nc, .loc_418F
    call RuntimeEntry_Bank0A_42D7
    pop af
    or a
    ld a, $ff
    push af
    jr .loc_4192
.loc_4189:
    call RuntimeEntry_Bank0A_41DF
    call RuntimeEntry_Bank0A_4205
.loc_418F:
    call SRAM_Disable
.loc_4192:
    pop af
    ret
RuntimeEntry_Bank0A_4194::
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call RuntimeEntry_Bank0A_4012
    push af
    jr c, .loc_41B0
    or a
    jr nz, .loc_41DD
    call RuntimeEntry_Bank0A_4205
    jr .loc_41DA
.loc_41B0:
    ld a, [$c8e2]
    cp $ff
    jr z, .loc_41D7
    ld a, [$c8bb]
    cp $32
    jr nz, .loc_41DA
    ld a, [$c8bd]
    cp $03
    jr nz, .loc_41DA
    ld a, [$c8bc]
    dec a
    cp $02
    jr nc, .loc_41DA
    call RuntimeEntry_Bank0A_42D7
    pop af
    or a
    ld a, $ff
    push af
    jr .loc_41DD
.loc_41D7:
    call RuntimeEntry_Bank0A_4205
.loc_41DA:
    call SRAM_Disable
.loc_41DD:
    pop af
    ret
RuntimeEntry_Bank0A_41DF::
    ld hl, $d6bf
    ld a, [hli]
    or [hl]
    jr z, .loc_4204
    ld hl, $a0cc
    ld a, [hli]
    ld [$d826], a
    ld c, a
    ld b, [hl]
    ld a, b
    ld [$d827], a
    or c
    jr z, .loc_4204
    ld hl, $a0ce
    ld de, $a0cc
.loc_41FC:
    ld a, [hli]
    ld [de], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .loc_41FC
.loc_4204:
    ret
RuntimeEntry_Bank0A_4205::
    ld a, $30
    ld [$d828], a
    ld [$d829], a
    ld [$d82a], a
    ld [$d82b], a
    ld [$d82c], a
    ld [$d82d], a
    ld hl, $d7dc
    ld a, $20
    call RuntimeEntry_Bank0A_4A85
    call RuntimeEntry_Bank0A_444A
    ld a, [hli]
    ld [$d828], a
    ld a, [hl]
    ld [$d829], a
    ld a, $20
    call RuntimeEntry_Bank0A_4A85
    call RuntimeEntry_Bank0A_444A
    ld a, [hli]
    ld [$d6cb], a
    ld a, [hli]
    ld [$d6cc], a
    ld a, [hl]
    ld [$d6cd], a
    xor a
    ld [$d6ce], a
    push hl
    ld hl, $42a7
    ld b, $01
    ld c, $0c
.loc_424C:
    push bc
    push hl
    ld de, $d6cb
    call String_CompareZeroTerminated
    pop hl
    pop bc
    jr nc, .loc_4262
    ld de, $0004
    add hl, de
    inc b
    dec c
    jr nz, .loc_424C
    ld b, $00
.loc_4262:
    ld a, b
    daa
    ld b, a
    swap a
    and $0f
    add a, $30
    ld [$d82a], a
    ld a, b
    and $0f
    add a, $30
    ld [$d82b], a
    pop hl
    ld a, $20
    call RuntimeEntry_Bank0A_4A85
    call RuntimeEntry_Bank0A_444A
    inc hl
    inc hl
    ld a, [hli]
    ld [$d82c], a
    ld a, [hl]
    ld [$d82d], a
    ret
    ; Source-owned structural bytes formerly data/mobile/structural/bank0a_428a_42d6.dat
    db $54, $68, $75, $2c, $20, $32, $37, $20, $4f, $63, $74, $20, $32, $30, $33, $34
    db $20, $30, $30, $3a, $30, $31, $3a, $30, $32, $20, $47, $4d, $54, $4a, $61, $6e
    db $00, $46, $65, $62, $00, $4d, $61, $72, $00, $41, $70, $72, $00, $4d, $61, $79
    db $00, $4a, $75, $6e, $00, $4a, $75, $6c, $00, $41, $75, $67, $00, $53, $65, $70
    db $00, $4f, $63, $74, $00, $4e, $6f, $76, $00, $44, $65, $63, $00
RuntimeEntry_Bank0A_42D7::
    ld hl, $c8e8
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld hl, $bbcc
    ld bc, $03ff
.loc_42E3:
    ld a, [de]
    ld [hli], a
    inc de
    or a
    jr z, .loc_42F0
    dec bc
    ld a, b
    or c
    jr nz, .loc_42E3
    ld [hl], $00
.loc_42F0:
    ld de, $0002
    ld a, [$d81e]
    cp $0e
    jr z, .loc_42FD
    ld de, $0006
.loc_42FD:
    ld a, [$d823]
    ld l, a
    ld a, [$d824]
    ld h, a
    add hl, de
    ld a, $cc
    ld [hli], a
    ld a, $bb
    ld [hl], a
    ld a, [$d81f]
    ld c, a
    ld a, [$d820]
    ld b, a
    ld a, [$d821]
    ld e, a
    ld a, [$d822]
    ld d, a
    ld a, [$d823]
    ld l, a
    ld a, [$d824]
    ld h, a
    ld a, [$d81e]
    jp RuntimeEntry_Bank00_0FC2
RuntimeEntry_Bank0A_432A::
    push af
    ld a, c
    ld [$d81f], a
    ld a, b
    ld [$d820], a
    ld a, e
    ld [$d821], a
    ld a, d
    ld [$d822], a
    ld a, l
    ld [$d823], a
    ld a, h
    ld [$d824], a
    pop af
    ld [$d81e], a
    ret
    ; Source-owned structural bytes formerly data/mobile/structural/bank0a_4348_43c6.dat
    db $cd, $12, $40, $30, $0c, $fa, $bb, $c8, $fe, $ff, $28, $0d, $ea, $e2, $c8, $37
    db $c9, $fe, $ff, $c8, $cd, $74, $43, $af, $c9, $cd, $74, $43, $01, $02, $01, $fa
    db $bc, $d6, $11, $80, $d4, $cd, $c2, $0f, $af, $3e, $ff, $c9, $fa, $cd, $d7, $3c
    db $ea, $cd, $d7, $21, $80, $d4, $2a, $4f, $2a, $47, $fa, $bd, $d6, $5f, $fa, $be
    db $d6, $57, $c5, $fa, $bf, $d6, $4f, $fa, $c0, $d6, $b1, $c1, $28, $2a, $2a, $12
    db $fa, $cb, $d7, $c6, $01, $ea, $cb, $d7, $fa, $cc, $d7, $ce, $00, $ea, $cc, $d7
    db $13, $c5, $fa, $bf, $d6, $d6, $01, $ea, $bf, $d6, $fa, $c0, $d6, $de, $00, $ea
    db $c0, $d6, $c1, $0b, $78, $b1, $20, $ca, $21, $bd, $d6, $73, $23, $72, $c9
RuntimeEntry_Bank0A_43C7::
    push af
    xor a
    ld [$d7cb], a
    ld [$d7cc], a
    ld [$d7cd], a
    pop af
    ret
RuntimeEntry_Bank0A_43D4::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call Mobile_GetStatusFlags
    bit 0, a
    jr nz, .loc_43E6
    ld a, $02
    jp RuntimeEntry_Bank00_0FC2
.loc_43E6:
    ld a, $18
    jp RuntimeEntry_Bank00_0FC2
RuntimeEntry_Bank0A_43EB::
    jp RuntimeEntry_Bank0A_4012
RuntimeEntry_Bank0A_43EE::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    ld de, $a0cc
    ld a, $12
    jp RuntimeEntry_Bank00_0FC2
RuntimeEntry_Bank0A_4404::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call RuntimeEntry_Bank0A_4012
    jr c, .loc_4411
    or a
    ret nz
.loc_4411:
    push af
    call SRAM_Disable
    pop af
    ret
RuntimeEntry_Bank0A_4417::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    ld de, $a0cc
    ld a, $11
    jp RuntimeEntry_Bank00_0FC2
RuntimeEntry_Bank0A_442D::
    jr RuntimeEntry_Bank0A_4404
RuntimeEntry_Bank0A_442F::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    ld de, $a0cc
    ld a, $10
    jp RuntimeEntry_Bank00_0FC2
RuntimeEntry_Bank0A_4445::
    jr RuntimeEntry_Bank0A_4404
    db $c3, $b9, $10
RuntimeEntry_Bank0A_444A::
    ld a, [hl]
    cp $20
    jr z, .loc_4452
    cp $09
    ret nz
.loc_4452:
    inc hl
    jr RuntimeEntry_Bank0A_444A
    db $c3, $b9, $10
RuntimeEntry_Bank0A_4458::
    push hl
    ld h, d
    ld l, e
    add hl, hl
    add hl, hl
    add hl, de
    add hl, hl
    ld d, h
    ld e, l
    pop hl
    ret
    db $c3, $b9, $10
RuntimeEntry_Bank0A_4466::
    ld [$d7d1], a
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    call RuntimeEntry_Bank0A_4799
    ld hl, $d6cb
    call RuntimeEntry_Bank0A_44AC
    ld de, $10bc
    call RuntimeEntry_Bank0A_4A6D
    ld de, $10e9
    call RuntimeEntry_Bank0A_4A7A
    push hl
    ld a, [$d7d1]
    add a, a
    add a, $01
    ld l, a
    ld a, $00
    adc a, $45
    ld h, a
    ld a, [hli]
    ld d, [hl]
    ld e, a
    pop hl
    call RuntimeEntry_Bank0A_4A7A
    ld hl, $d6cb
    ld de, $a0cc
    ld bc, $0400
    jp RuntimeEntry_Bank0A_4107
RuntimeEntry_Bank0A_44AC::
    ld a, $dc
    ld [hli], a
    ld a, $d7
    ld [hli], a
    ld a, $fb
    ld [hli], a
    ld a, $d6
    ld [hli], a
    push hl
    call RuntimeEntry_Bank0A_47A4
    ld b, $11
    call RuntimeEntry_Bank0A_40B3
    call RuntimeEntry_Bank0A_47B2
    ld b, $11
    call RuntimeEntry_Bank0A_40B3
    ld [hl], $00
    pop hl
    ld hl, $d6fb
    ret
RuntimeEntry_Bank0A_44D0::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call RuntimeEntry_Bank0A_4143
    push af
    jr c, .loc_44E7
    or a
    jr nz, .loc_44FF
.loc_44DF:
    call SRAM_Enable
    call .loc_453B
    jr .loc_44FC
.loc_44E7:
    ld a, [$c8e2]
    cp $33
    jr nz, .loc_44FC
    ld a, [$c8e3]
    cp $01
    jr nz, .loc_44FC
    ld a, [$c8e4]
    cp $01
    jr z, .loc_44DF
.loc_44FC:
    call SRAM_Disable
.loc_44FF:
    pop af
    ret
    ; Source-owned structural bytes formerly data/mobile/structural/bank0a_4501_453a.dat
    db $07, $45, $16, $45, $28, $45, $30, $2e, $6d, $61, $70, $5f, $6d, $65, $6e, $75
    db $2e, $74, $78, $74, $00, $30, $2e, $79, $6f, $75, $68, $65, $69, $5f, $6d, $65
    db $6e, $75, $2e, $74, $78, $74, $00, $30, $2e, $63, $6d, $64, $70, $6f, $73, $74
    db $5f, $6d, $65, $6e, $75, $2e, $74, $78, $74, $00
.loc_453B:
    ld a, [$d7d1]
    cp $01
    jp z, RuntimeEntry_Bank0A_45ED
    cp $02
    jp z, RuntimeEntry_Bank0A_4647
    ld hl, $a048
    ld b, $40
    ld a, $ff
.loc_454F:
    ld [hli], a
    dec b
    jr nz, .loc_454F
    ld hl, $a0cc
    ld b, $08
    ld c, $00
.loc_455A:
    call RuntimeEntry_Bank0A_464A
    push hl
    ld hl, $d582
    call RuntimeEntry_Bank0A_444A
    ld a, [hl]
    cp $2e
    jr nz, .loc_456C
    pop hl
    jr .loc_45D1
.loc_456C:
    or a
    jr z, .loc_45CC
    cp $23
    jr z, .loc_45CC
    call RuntimeEntry_Bank0A_45D2
    ld a, e
    ld [$d7d4], a
    ld a, d
    ld [$d7d5], a
    call RuntimeEntry_Bank0A_444A
    call RuntimeEntry_Bank0A_45D2
    ld a, e
    ld [$d7d6], a
    ld a, d
    ld [$d7d7], a
    call RuntimeEntry_Bank0A_444A
    push bc
    ld b, $04
    ld de, $d7d8
.loc_4595:
    ld a, [hli]
    or a
    jr z, .loc_45A6
    cp $20
    jr z, .loc_45A6
    cp $09
    jr z, .loc_45A6
    ld [de], a
    inc de
    dec b
    jr nz, .loc_4595
.loc_45A6:
    ld a, b
    or a
    jr z, .loc_45B0
    xor a
    ld [de], a
    inc de
    dec b
    jr .loc_45A6
.loc_45B0:
    pop bc
    ld a, c
    add a, a
    add a, a
    add a, a
    add a, $48
    ld l, a
    ld a, $00
    adc a, $a0
    ld h, a
    ld de, $d7d4
    push bc
    ld b, $08
.loc_45C3:
    ld a, [de]
    ld [hli], a
    inc de
    dec b
    jr nz, .loc_45C3
    pop bc
    inc c
    dec b
.loc_45CC:
    pop hl
    ld a, b
    or a
    jr nz, .loc_455A
.loc_45D1:
    ret
RuntimeEntry_Bank0A_45D2::
    ld de, $0000
.loc_45D5:
    ld a, [hl]
    sub $30
    jr c, .loc_45EC
    cp $0a
    jr nc, .loc_45EC
    push af
    call RuntimeEntry_Bank0A_4458
    pop af
    add a, e
    ld e, a
    ld a, $00
    adc a, d
    ld d, a
    inc hl
    jr .loc_45D5
.loc_45EC:
    ret
RuntimeEntry_Bank0A_45ED::
    ld hl, $a088
    ld b, $20
    ld a, $ff
.loc_45F4:
    ld [hli], a
    dec b
    jr nz, .loc_45F4
    ld hl, $a0cc
    call RuntimeEntry_Bank0A_4670
    ld b, $08
    ld c, $00
.loc_4602:
    call RuntimeEntry_Bank0A_464A
    push hl
    ld hl, $d582
    call RuntimeEntry_Bank0A_444A
    ld a, [hl]
    cp $2e
    jr nz, .loc_4614
    pop hl
    jr .loc_4634
.loc_4614:
    or a
    jr z, .loc_462F
    cp $23
    jr z, .loc_462F
    push bc
    ld a, c
    add a, a
    add a, a
    add a, $88
    ld e, a
    ld a, $00
    adc a, $a0
    ld d, a
    ld b, $04
    call .loc_4635
    pop bc
    inc c
    dec b
.loc_462F:
    pop hl
    ld a, b
    or a
    jr nz, .loc_4602
.loc_4634:
    ret
.loc_4635:
    ld a, [hli]
    or a
    jr z, .loc_4640
    ld [de], a
    inc de
    dec b
    jr nz, .loc_4635
    jr .loc_4646
.loc_4640:
    xor a
.loc_4641:
    ld [de], a
    inc de
    dec b
    jr nz, .loc_4641
.loc_4646:
    ret
RuntimeEntry_Bank0A_4647::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_464A::
    push bc
    push de
    ld de, $d582
    ld b, $ff
.loc_4651:
    ld a, [hli]
    cp $0d
    jr nz, .loc_465B
    ld a, [hl]
    cp $0a
    jr z, .loc_466A
.loc_465B:
    ld [de], a
    inc de
    dec b
    jr nz, .loc_4651
.loc_4660:
    ld a, [hli]
    cp $0d
    jr nz, .loc_4660
    ld a, [hl]
    cp $0a
    jr nz, .loc_4660
.loc_466A:
    inc hl
    xor a
    ld [de], a
    pop de
    pop bc
    ret
RuntimeEntry_Bank0A_4670::
    ret
RuntimeEntry_Bank0A_4671::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    call RuntimeEntry_Bank0A_45D2
    ld b, $08
    ld c, $00
.loc_4686:
    ld a, c
    add a, a
    add a, a
    add a, a
    add a, $49
    ld l, a
    ld a, $00
    adc a, $a0
    ld h, a
    ld a, [hld]
    cp $ff
    jr z, .loc_46AC
    ld a, e
    sub [hl]
    inc hl
    ld a, d
    sbc a, [hl]
    jr c, .loc_46A8
    inc hl
    ld a, [hli]
    sub e
    ld [$a0cc], a
    ld a, [hli]
    sbc a, d
    jr nc, .loc_46B1
.loc_46A8:
    inc c
    dec b
    jr nz, .loc_4686
.loc_46AC:
    ld a, $ff
    scf
    jr .loc_46BF
.loc_46B1:
    ld de, $a0cc
    ld b, $04
.loc_46B6:
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, .loc_46B6
    xor a
    ld [de], a
    ld a, c
.loc_46BF:
    push af
    call SRAM_Disable
    pop af
    ret
RuntimeEntry_Bank0A_46C5::
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    pop af
    cp $08
    jr nc, .loc_46F7
    add a, a
    add a, a
    ld e, a
    ld d, $00
    ld hl, $a088
    add hl, de
    ld a, [hl]
    or a
    cp $ff
    jr z, .loc_46F7
    ld b, $04
    ld de, $a0cc
.loc_46ED:
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, .loc_46ED
    xor a
    ld [de], a
    jr .loc_46F8
.loc_46F7:
    scf
.loc_46F8:
    push af
    call SRAM_Disable
    pop af
    ret
RuntimeEntry_Bank0A_46FE::
    jp RuntimeEntry_Bank00_10B9
RuntimeEntry_Bank0A_4701::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    push hl
    call RuntimeEntry_Bank0A_4799
    ld hl, $d6cb
    call RuntimeEntry_Bank0A_44AC
    ld de, $10bc
    call RuntimeEntry_Bank0A_4A6D
    ld de, $10e9
    call RuntimeEntry_Bank0A_4A7A
    ld de, $478a
    call RuntimeEntry_Bank0A_4A7A
    pop de
    push de
    ld bc, $0500
.loc_4730:
    ld a, [de]
    or a
    jr z, .loc_4739
    inc de
    inc c
    dec b
    jr nz, .loc_4730
.loc_4739:
    ld a, c
    cp $04
    jr nc, .loc_4742
    ld a, $30
    jr .loc_4745
.loc_4742:
    pop de
    push de
    ld a, [de]
.loc_4745:
    ld [$a0cc], a
    ld a, $2f
    ld [$a0cd], a
    xor a
    ld [$a0ce], a
    ld de, $a0cc
    call RuntimeEntry_Bank0A_4A7A
    ld de, $478f
    call RuntimeEntry_Bank0A_4A7A
    pop de
    call RuntimeEntry_Bank0A_4A7A
    ld de, $4794
    call RuntimeEntry_Bank0A_4A7A
    call RuntimeEntry_Bank0A_43C7
    ld hl, $d6cb
    ld de, $a0cc
    ld bc, $1b00
    jp RuntimeEntry_Bank0A_4107
RuntimeEntry_Bank0A_4776::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call RuntimeEntry_Bank0A_4143
    push af
    jr c, .loc_4785
    or a
    jr nz, .loc_4788
.loc_4785:
    call SRAM_Disable
.loc_4788:
    pop af
    ret
    db $6d, $61, $70, $2f, $00, $6d, $61, $70, $5f, $00, $2e, $63, $67, $62, $00
RuntimeEntry_Bank0A_4799::
    push af
    ld a, e
    ld [$d7fc], a
    ld a, d
    ld [$d7fd], a
    pop af
    ret
RuntimeEntry_Bank0A_47A4::
    push af
    push hl
    ld hl, $d7fc
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld a, [hli]
    ld d, [hl]
    ld e, a
    pop hl
    pop af
    ret
RuntimeEntry_Bank0A_47B2::
    push af
    push hl
    ld hl, $d7fc
    ld a, [hli]
    ld h, [hl]
    ld l, a
    inc hl
    inc hl
    ld a, [hli]
    ld d, [hl]
    ld e, a
    pop hl
    pop af
    ret
RuntimeEntry_Bank0A_47C2::
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    pop af
    push de
    ld e, l
    ld d, h
    call RuntimeEntry_Bank0A_4799
    pop de
    ld hl, $a088
    sla e
    sla e
    or a
    jr nz, .loc_47E8
    sla e
    ld hl, $a04c
.loc_47E8:
    ld d, $00
    add hl, de
    push hl
    ld hl, $d6cb
    call RuntimeEntry_Bank0A_44AC
    ld de, $10bc
    call RuntimeEntry_Bank0A_4A6D
    ld de, $10e9
    call RuntimeEntry_Bank0A_4A7A
    ld de, $4840
    call RuntimeEntry_Bank0A_4A7A
    pop de
    push hl
    call RuntimeEntry_Bank0A_4A91
    ld b, $04
.loc_480B:
    ld a, [de]
    or a
    jr z, .loc_4814
    ld [hli], a
    inc de
    dec b
    jr nz, .loc_480B
.loc_4814:
    ld [hl], $00
    pop hl
    ld de, $4848
    call RuntimeEntry_Bank0A_4A7A
    ld hl, $d6cb
    ld de, $d480
    ld bc, $0102
    jp RuntimeEntry_Bank0A_4125
RuntimeEntry_Bank0A_4829::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call RuntimeEntry_Bank0A_4194
    push af
    jr c, .loc_483B
    or a
    jr nz, .loc_483E
    call SRAM_Enable
.loc_483B:
    call SRAM_Disable
.loc_483E:
    pop af
    ret
    ; Source-owned structural bytes formerly data/mobile/structural/bank0a_4840_48ad.dat
    db $63, $68, $61, $72, $67, $65, $2f, $00, $2e, $63, $68, $61, $72, $67, $65, $2e
    db $63, $67, $62, $00, $c3, $b9, $10, $c3, $b9, $10, $c3, $b9, $10, $6d, $62, $6f
    db $78, $2f, $00, $6d, $62, $6f, $78, $5f, $73, $65, $72, $69, $61, $6c, $2e, $74
    db $78, $74, $00, $6d, $62, $6f, $78, $5f, $00, $2e, $63, $67, $62, $00, $30, $30
    db $00, $30, $31, $00, $30, $32, $00, $30, $33, $00, $30, $34, $00, $30, $35, $00
    db $30, $36, $00, $30, $37, $00, $30, $38, $00, $30, $39, $00, $31, $30, $00, $31
    db $31, $00, $31, $32, $00, $31, $33, $00, $31, $34, $00, $31, $35, $00
RuntimeEntry_Bank0A_48AE::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    call RuntimeEntry_Bank0A_4799
    ld hl, $d6cb
    call RuntimeEntry_Bank0A_44AC
    ld de, $10bc
    call RuntimeEntry_Bank0A_4A6D
    ld de, $10e9
    call RuntimeEntry_Bank0A_4A7A
    ld de, $485d
    call RuntimeEntry_Bank0A_4A7A
    ld de, $4863
    call RuntimeEntry_Bank0A_4A7A
    ld hl, $d6cb
    ld de, $a0cc
    ld bc, $0400
    jp RuntimeEntry_Bank0A_4107
RuntimeEntry_Bank0A_48E9::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call RuntimeEntry_Bank0A_4143
    push af
    jr c, .loc_4900
    or a
    jr nz, .loc_4918
.loc_48F8:
    call SRAM_Enable
    call .loc_491A
    jr .loc_4915
.loc_4900:
    ld a, [$c8e2]
    cp $33
    jr nz, .loc_4915
    ld a, [$c8e3]
    cp $01
    jr nz, .loc_4915
    ld a, [$c8e4]
    cp $01
    jr z, .loc_48F8
.loc_4915:
    call SRAM_Disable
.loc_4918:
    pop af
    ret
.loc_491A:
    ld de, $a0cc
    ld b, $10
    ld c, $00
.loc_4921:
    ld hl, $0000
.loc_4924:
    ld a, [de]
    sub $30
    cp $0a
    jr nc, .loc_493B
    push af
    push de
    ld e, l
    ld d, h
    add hl, hl
    add hl, hl
    add hl, de
    add hl, hl
    pop de
    pop af
    add a, l
    ld l, a
    ld a, $00
    adc a, h
    ld h, a
.loc_493B:
    inc de
    ld a, [de]
    cp $0a
    jr nz, .loc_4924
    push de
    ld a, c
    add a, a
    add a, $fe
    ld e, a
    ld a, $d7
    adc a, $00
    ld d, a
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    pop de
    inc de
    inc c
    dec b
    jr nz, .loc_4921
    ret
RuntimeEntry_Bank0A_4958::
    add a, a
    add a, $fe
    ld l, a
    ld a, $d7
    adc a, $00
    ld h, a
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret
RuntimeEntry_Bank0A_4965::
    ld c, a
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    push bc
    call RuntimeEntry_Bank0A_4799
    ld hl, $d6cb
    call RuntimeEntry_Bank0A_44AC
    ld de, $10bc
    call RuntimeEntry_Bank0A_4A6D
    ld de, $10e9
    call RuntimeEntry_Bank0A_4A7A
    ld de, $485d
    call RuntimeEntry_Bank0A_4A7A
    ld de, $4873
    call RuntimeEntry_Bank0A_4A7A
    pop bc
    ld a, c
    add a, a
    add a, c
    add a, $7e
    ld e, a
    ld a, $48
    adc a, $00
    ld d, a
    call RuntimeEntry_Bank0A_4A7A
    ld de, $4879
    call RuntimeEntry_Bank0A_4A7A
    ld hl, $d6cb
    ld de, $a0cc
    ld bc, $0400
    jp RuntimeEntry_Bank0A_4107
RuntimeEntry_Bank0A_49B7::
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    call RuntimeEntry_Bank0A_4143
    push af
    jr c, .loc_49CB
    or a
    jr nz, .loc_49E3
.loc_49C6:
    call SRAM_Enable
    jr .loc_49E0
.loc_49CB:
    ld a, [$c8e2]
    cp $33
    jr nz, .loc_49E0
    ld a, [$c8e3]
    cp $01
    jr nz, .loc_49E0
    ld a, [$c8e4]
    cp $01
    jr z, .loc_49C6
.loc_49E0:
    call SRAM_Disable
.loc_49E3:
    pop af
    ret
    db $f5, $3e, $0f, $cd, $8d, $05, $cd, $93, $05, $f1, $cd, $43, $4a, $7e, $b7, $28, $01, $37, $f5, $cd, $9b, $05, $f1, $c9
RuntimeEntry_Bank0A_49FD::
    cp $09
    jr c, .loc_4A03
    scf
    ret
.loc_4A03:
    push af
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    pop af
    call .loc_4A15
    call SRAM_Disable
    xor a
    ret
.loc_4A15:
    push bc
    call .loc_4A43
    ld b, $08
    xor a
.loc_4A1C:
    ld [hli], a
    dec b
    jr nz, .loc_4A1C
    pop bc
    ret
    ; Source-owned structural bytes formerly data/mobile/structural/bank0a_4a22_4a42.dat
    db $e5, $cd, $43, $4a, $d1, $06, $08, $1a, $b7, $28, $07, $22, $13, $05, $20, $f7
    db $18, $05, $af, $22, $05, $20, $fc, $c9, $54, $5d, $cd, $43, $4a, $cd, $53, $4a
    db $c9
.loc_4A43:
    push de
    add a, a
    add a, a
    add a, a
    ld e, a
    ld d, $00
    ld hl, $a000
    add hl, de
    pop de
    ret
    db $c3, $b9, $10
String_CompareZeroTerminated::
    ld c, $00
.loc_4A55:
    ld a, [de]
    cp [hl]
    jr nz, .loc_4A61
    or [hl]
    jr z, .loc_4A6A
    inc hl
    inc de
    inc c
    jr .loc_4A55
.loc_4A61:
    or a
    jr z, .loc_4A67
    xor a
    jr .loc_4A68
.loc_4A67:
    ld a, c
.loc_4A68:
    scf
    ret
.loc_4A6A:
    xor a
    ld a, c
    ret
RuntimeEntry_Bank0A_4A6D::
    push hl
.loc_4A6E:
    ld a, [de]
    or a
    jr z, .loc_4A76
    ld [hli], a
    inc de
    jr .loc_4A6E
.loc_4A76:
    ld [hl], $00
    pop hl
    ret
RuntimeEntry_Bank0A_4A7A::
    push hl
.loc_4A7B:
    ld a, [hli]
    or a
    jr nz, .loc_4A7B
    dec hl
    call RuntimeEntry_Bank0A_4A6D
    pop hl
    ret
RuntimeEntry_Bank0A_4A85::
    push de
    ld e, a
.loc_4A87:
    ld a, [hli]
    or a
    jr z, .loc_4A8E
    cp e
    jr nz, .loc_4A87
.loc_4A8E:
    dec hl
    pop de
    ret
RuntimeEntry_Bank0A_4A91::
    ld a, [hl]
    or a
    ret z
    inc hl
    jr RuntimeEntry_Bank0A_4A91
    ; Mobile Adapter result-code strings followed by unused bank padding.
    db $42, $44, $3d, $00, $45, $52, $3d, $30, $30, $00, $45, $52, $3d, $30, $31, $00
    db $45, $52, $3d, $30, $32, $00, $45, $52, $3d, $38, $30, $00, $45, $52, $3d, $46
    db $46, $00, $4f, $4b, $3d, $30, $30, $00
    ds $3541, $ff
    assert @ == $8000

SECTION "Remaining ROM 0B:51CC-52BB", ROMX[$51CC], BANK[$0B]
RemainingROM_Bank0B_51CC::
    db $c9
RuntimeEntry_Bank0B_51CD::
    push bc
    push de
    push hl
    ld b, a
    add a, a
    add a, b
    ld hl, $5271
    call AddAtoHL
    ld a, [hli]
    ld c, [hl]
    inc hl
    ld b, [hl]
    push bc
    ld l, a
    ld h, c
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $5e10
    add hl, de
    ld d, h
    ld e, l
    ld l, b
    ld h, $00
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ld b, h
    ld c, l
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $8c00
    farcall BANK_11, Bank11_Entry_3B59
    pop bc
    ld d, b
    ld e, $02
    ld a, $14
    sub d
    srl a
    ld b, a
    ld c, $05
    call MapPresentation_PrepareCoordinatesAndDraw
    call Vram_TilemapCoord
    ld c, $c0
.loc_5215:
    push de
    push hl
.loc_5217:
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, c
    call Vram_PutWaitBlank
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    call Vram_PutWaitBlank
    call Vram_TilemapAdvanceColumnWrapped
    inc c
    dec d
    jr nz, .loc_5217
    pop hl
    call Vram_TilemapAdvanceRowWrapped
    pop de
    dec e
    jr nz, .loc_5215
    ld a, [$c633]
    and $01
    ld hl, $c631
    call AddAtoHL
    ld c, [hl]
    ld a, c
    and a
    jr z, .loc_524E
    ld b, $1e
    jr .loc_5250
.loc_524E:
    ld b, $3c
.loc_5250:
    push bc
    call Joypad_Update
    pop bc
    ld a, c
    and a
    jr nz, .loc_5267
    ldh a, [$ff91]
    bit 0, a
    jr nz, .loc_526A
    bit 1, a
    jr nz, .loc_526A
    bit 3, a
    jr nz, .loc_526A
.loc_5267:
    dec b
    jr nz, .loc_5250
.loc_526A:
    call MapPresentation_RunSharedRefresh
    pop hl
    pop de
    pop bc
    ret
    ; Source-owned structural bytes formerly data/gameplay/structural/bank0b_5271_52bb.dat
    db $00, $00, $08, $10, $00, $08, $20, $00, $08, $30, $00, $06, $3c, $00, $08, $4c
    db $00, $08, $5c, $00, $04, $64, $00, $04, $6c, $00, $04, $74, $00, $08, $84, $00
    db $08, $94, $00, $08, $a4, $00, $06, $b0, $00, $08, $c0, $00, $08, $d0, $00, $08
    db $e0, $00, $08, $f0, $00, $08, $00, $01, $0a, $14, $01, $0a, $28, $01, $0a, $3c
    db $01, $0a, $50, $01, $08, $60, $01, $08, $70, $01, $0d
    assert @ == $52BC

SECTION "Remaining ROM 0B:7D83-7D8F", ROMX[$7D83], BANK[$0B]
RemainingROM_Bank0B_7D83::
    ds $d, $ff
    assert @ == $7D90

SECTION "Remaining ROM 0B:7DA4-7FFF", ROMX[$7DA4], BANK[$0B]
RemainingROM_Bank0B_7DA4::
    ds $25c, $ff
    assert @ == $8000

SECTION "Remaining ROM 0C:4E26-4E26", ROMX[$4E26], BANK[$0C]
RemainingROM_Bank0C_4E26::
    db $c9
    assert @ == $4E27

SECTION "Remaining ROM 0C:57FA-57FB", ROMX[$57FA], BANK[$0C]
RemainingROM_Bank0C_57FA::
    db $03, $21
    assert @ == $57FC

SECTION "Remaining ROM 0C:6867-6982", ROMX[$6867], BANK[$0C]
RemainingROM_Bank0C_6867::
RuntimeEntry_Bank0C_6867::
    push bc
    push de
    ld a, [$c62f]
    cp $01
    jp nz, .loc_6903
    xor a
    ld [$c9b2], a
    ld a, $ff
    ld [$c9b3], a
    ld e, $00
.loc_687C:
    ld hl, $c7b1
    ld a, e
    call Bitfield_Test
    jr nz, .loc_68AC
    ld a, e
    ld hl, $6906
    call CallWordTableByIndex
    and a
    jr nz, .loc_68AC
    ld hl, $c7b1
    ld a, e
    call Bitfield_Set
    ld hl, $c9b2
    ld a, e
    call Bitfield_Set
    ld a, e
    ld [$c9b4], a
    ld a, [$c9b3]
    cp $ff
    jr nz, .loc_68AC
    ld a, e
    ld [$c9b3], a
.loc_68AC:
    inc e
    ld a, e
    cp $04
    jr nz, .loc_687C
    ld a, [$c9b2]
    and a
    jr z, .loc_6903
    call .loc_690E
    farcall BANK_0B, Bank0B_Entry_2164
    ld e, $00
.loc_68C1:
    ld a, e
    ld hl, $c9b2
    call Bitfield_Test
    jr z, .loc_68EB
.loc_68CA:
    ld b, $00
    ld a, [$c9b3]
    cp e
    jr z, .loc_68D4
    ld b, $01
.loc_68D4:
    push de
    ld a, e
    farcall BANK_31, Bank31_Entry_7628
    pop de
    cp $ff
    jr nz, .loc_68EB
.loc_68DF:
    dec e
    ld a, e
    ld hl, $c9b2
    call Bitfield_Test
    jr nz, .loc_68CA
    jr .loc_68DF
.loc_68EB:
    inc e
    ld a, e
    cp $04
    jr nz, .loc_68C1
    farcall BANK_31, Bank31_Entry_77BD
    cp $ff
    jr nz, .loc_68FF
    ld a, [$c9b4]
    ld e, a
    jr .loc_68C1
.loc_68FF:
    farcall MapControl_ReinitializeAfterResolution
.loc_6903:
    pop de
    pop bc
    ret
    db $28, $69, $34, $69, $4e, $69, $66, $69
.loc_690E:
    push bc
    push de
    ld b, $03
.loc_6912:
    push bc
    ld a, $18
    farcall MapControl_ResolutionSceneRefresh
    ld a, $1e
    call AdvanceFrames
    pop bc
    dec b
    jr nz, .loc_6912
    call FadeToWhite8
    pop de
    pop bc
    ret
    ; Source-owned structural bytes formerly data/gameplay/structural/bank0c_6928_6982.dat
    db $fa, $a8, $c6, $a7, $28, $03, $af, $18, $02, $3e, $01, $c9, $d5, $1e, $00, $7b
    db $ef, $12, $98, $44, $a7, $20, $08, $1c, $7b, $fe, $32, $20, $f2, $18, $03, $af
    db $18, $02, $3e, $01, $d1, $c9, $fa, $55, $c6, $a7, $20, $10, $fa, $60, $c6, $a7
    db $20, $0a, $fa, $69, $c6, $a7, $20, $04, $3e, $01, $18, $01, $af, $c9, $fa, $a8
    db $c6, $a7, $28, $14, $3e, $0e, $cd, $8d, $05, $cd, $93, $05, $fa, $06, $a1, $cd
    db $9b, $05, $a7, $28, $03, $af, $18, $02, $3e, $01, $c9
    assert @ == $6983

SECTION "Remaining ROM 0C:73A5-76F0", ROMX[$73A5], BANK[$0C]
RemainingROM_Bank0C_73A5::
RuntimeEntry_Bank0C_73A5::
    xor a
    ld [$ca97], a
    farcall MapCursor_Hide
    call Sprite_Update
    ld a, [$c633]
    and $01
    add a, a
    ld hl, $c993
    call AddAtoHL
    ld b, [hl]
    inc hl
    ld c, [hl]
    farcall MapControl_PanToCoordinates
    call .loc_745E
    xor a
    ldh [$ffb1], a
    farcall BANK_0B, Bank0B_Entry_4057
    call Vram_ApplyPals
    call DelayFrame
    xor a
    set 0, a
    ldh [$ffb1], a
    farcall MapEconomy_RecalculateIncome
    call .loc_7430
    call UnitPhase_ProcessAircraftFuelUpkeep
    ld a, [$c633]
    and $01
    farcall Unit_ClearSupplyFlagsForSide
    ld a, [$c633]
    and $01
    ld hl, $c631
    call AddAtoHL
    ld a, [hl]
    cp $01
    jr z, .loc_7402
    ld a, [$c685]
    bit 3, a
    jr z, .loc_741C
.loc_7402:
    call .loc_7503
    ld a, [$c633]
    and $01
    farcall Unit_CountSuppliedForSide
    and a
    jr z, .loc_741C
    ld a, $0f
    call Audio_PlaySFX
    ld a, $09
    farcall MapControl_ResolutionSceneRefresh
.loc_741C:
    ld a, [$c633]
    and $01
    ld hl, $c631
    call AddAtoHL
    ld a, [hl]
    cp $01
    ret z
    farcall BANK_13, Bank13_Entry_5CA3
    ret
.loc_7430:
    ld a, [$c633]
    and $01
    add a, a
    ld c, a
    ld b, $00
    ld hl, $c63e
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld b, $0a
.loc_7442:
    farcall MapEconomy_AddCurrentSideGold
    dec b
    jr nz, .loc_7442
    ld a, [$c633]
    and $01
    add a, a
    ld c, a
    ld b, $00
    ld hl, $c642
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    farcall MapEconomy_AddCurrentSideMaterials
    ret
.loc_745E:
    call .loc_7623
.loc_7461:
    call Joypad_Update
    call Audio_IsSFXActive
    and a
    jr nz, .loc_7461
    ld a, [$c633]
    and $01
    add a, $60
    call Audio_PlaySFX
    ld bc, $0506
    ld de, $0a06
    farcall MapPresentation_PrepareCoordinatesAndDraw
    farcall UIWindow_DrawFrame
    call .loc_7573
.loc_7485:
    call Sprite_Update
    call Joypad_Update
    ldh a, [$ff91]
    and $0b
    jr nz, .loc_74CA
    ld a, [$c9d4]
    ld b, $02
    call SpriteObject_GetField
    add a, $04
    cp $58
    jr z, .loc_74BC
    ld c, a
    ld a, [$c9d4]
    ld b, $02
    call SpriteObject_SetField
    ld a, [$c9d5]
    call .loc_74F3
    ld a, [$c9d6]
    call .loc_74F3
    ld a, [$c9d7]
    call .loc_74F3
    jr .loc_7485
.loc_74BC:
    ld d, $78
.loc_74BE:
    call Joypad_Update
    ldh a, [$ff91]
    and $03
    jr nz, .loc_74CA
    dec d
    jr nz, .loc_74BE
.loc_74CA:
    ld a, [$c9d4]
    call SpriteObject_Destroy
    ld a, [$c9d5]
    call SpriteObject_Destroy
    ld a, [$c9d6]
    call SpriteObject_Destroy
    ld a, [$c9d7]
    call SpriteObject_Destroy
    call Sprite_Update
    call DelayFrame
    farcall MapPresentation_RunSharedRefresh
    ld a, $ab
    farcall UIWindowStack_SetBorderTile
    ret
.loc_74F3:
    push af
    ld b, $02
    call SpriteObject_GetField
    sub $04
    ld c, a
    pop af
    ld b, $02
    call SpriteObject_SetField
    ret
.loc_7503:
    push bc
    push de
    xor a
    ld [$c940], a
    ld e, $32
    ld a, [$c633]
    and $01
    jr z, .loc_7517
    ld a, $32
    ld [$c940], a
.loc_7517:
    ld a, [$c940]
    ld c, $00
    farcall UnitRecord_GetByte
    and a
    jr z, .loc_752A
    ld a, [$c940]
    farcall UnitSupply_ApplyTerrainServices
.loc_752A:
    ld a, [$c940]
    inc a
    ld [$c940], a
    dec e
    jr nz, .loc_7517
    xor a
    ld [$c940], a
    ld e, $32
    ld a, [$c633]
    and $01
    jr z, .loc_7546
    ld a, $32
    ld [$c940], a
.loc_7546:
    ld a, [$c940]
    ld c, $00
    farcall UnitRecord_GetByte
    and a
    jr z, .loc_7566
    ld a, [$c940]
    ld c, $03
    farcall UnitRecord_GetByte
    bit 0, a
    jr z, .loc_7566
    ld a, [$c940]
    farcall UnitSupply_ApplyAdjacentOrCarriedAirServices
.loc_7566:
    ld a, [$c940]
    inc a
    ld [$c940], a
    dec e
    jr nz, .loc_7546
    pop de
    pop bc
    ret
.loc_7573:
    ld a, [$c633]
    and $01
    add a, a
    ld hl, $7601
    call AddAtoHL
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, $20
    ld c, $98
    ld b, $0c
    call SpriteObject_Create
    ld [$c9d4], a
    ld b, $05
    call SpriteObject_SetPalette
    ld a, [$c9d4]
    ld b, $e8
    ld c, $50
    call SpriteObject_SetPosition
    ld a, $20
    ld c, $98
    ld b, $0c
    ld de, $76dc
    call SpriteObject_Create
    ld [$c9d5], a
    ld b, $05
    call SpriteObject_SetPalette
    ld a, [$c9d5]
    ld b, $d8
    ld c, $65
    call SpriteObject_SetPosition
    ld a, [$c633]
    srl a
    inc a
    call Number_ByteToPackedBCD
    push af
    swap a
    call .loc_75E3
    ld [$c9d6], a
    ld b, $b0
    ld c, $65
    call SpriteObject_SetPosition
    pop af
    call .loc_75E3
    ld [$c9d7], a
    ld b, $c0
    ld c, $65
    call SpriteObject_SetPosition
    ret
.loc_75E3:
    and $0f
    ld hl, $7605
    call AddAtoHL
    ld a, [hl]
    add a, $98
    ld c, a
    ld b, $0c
    ld a, $20
    ld de, $760f
    call SpriteObject_Create
    push af
    ld b, $05
    call SpriteObject_SetPalette
    pop af
    ret
    ; Source-owned structural bytes formerly data/gameplay/structural/bank0c_7601_7622.dat
    db $e1, $76, $e6, $76, $00, $01, $02, $03, $04, $05, $06, $07, $10, $11, $12, $76
    db $ff, $04, $f4, $f8, $00, $00, $f4, $00, $01, $00, $fc, $f8, $10, $00, $fc, $00
    db $11, $00
.loc_7623:
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $76f1
    ld hl, $8300
    ld bc, $0440
    call MemcpyWaitLCD
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $7b49
    ld hl, $8c00
    ld bc, $0040
    call MemcpyWaitLCD
    ld a, $c1
    farcall UIWindowStack_SetBorderTile
    xor a
    ldh [$ffb1], a
    ld a, $0d
    ld b, $03
    ld hl, $7b31
    call Vram_SetPals
    ld bc, $00e0
    call Vram_ApplySelectedPals
    call DelayFrame
    xor a
    set 0, a
    ldh [$ffb1], a
    ret
    ; Source-owned structural bytes formerly data/gameplay/structural/bank0c_7669_76f0.dat
    db $04, $fc, $08, $43, $00, $fc, $00, $42, $00, $fc, $f8, $41, $00, $fc, $f0, $40
    db $00, $0c, $00, $18, $3b, $01, $00, $10, $3a, $01, $00, $08, $39, $01, $00, $00
    db $38, $01, $f8, $18, $2b, $01, $f8, $10, $2a, $01, $f8, $08, $29, $01, $f8, $00
    db $28, $01, $00, $f0, $35, $01, $00, $e8, $34, $01, $f8, $f0, $25, $01, $f8, $e8
    db $24, $01, $0c, $00, $18, $3f, $02, $00, $10, $3e, $02, $00, $08, $3d, $02, $00
    db $00, $3c, $02, $f8, $18, $2f, $02, $f8, $10, $2e, $02, $f8, $08, $2d, $02, $f8
    db $00, $2c, $02, $00, $f0, $37, $02, $00, $e8, $36, $02, $f8, $f0, $27, $02, $f8
    db $e8, $26, $02, $69, $76, $ff, $00, $00, $7a, $76, $ff, $00, $00, $ab, $76, $ff
    db $00, $00, $dc, $76, $e1, $76, $e6, $76
    assert @ == $76F1

SECTION "Remaining ROM 0C:7B31-7B88", ROMX[$7B31], BANK[$0C]
RemainingROM_Bank0C_7B31::
    ; Source-owned structural bytes formerly data/gameplay/structural/bank0c_7b31_7b88.dat
    db $1f, $7c, $bf, $02, $75, $01, $00, $00, $1f, $7c, $df, $00, $ff, $7f, $00, $00
    db $1f, $7c, $40, $7d, $ff, $7f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $80, $80, $bf, $80, $bf, $9f
    db $bf, $9f, $b8, $98, $b8, $98, $b8, $98, $ff, $ff, $00, $00, $ff, $00, $ff, $ff
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $b8, $98, $b8, $98, $b8, $98, $b8, $98
    db $b8, $98, $b8, $98, $b8, $98, $b8, $98
    assert @ == $7B89

SECTION "Remaining ROM 0C:7D95-7FFF", ROMX[$7D95], BANK[$0C]
RemainingROM_Bank0C_7D95::
    ds $26b, $ff
    assert @ == $8000

SECTION "Remaining ROM 0D:68C2-7FFF", ROMX[$68C2], BANK[$0D]
RemainingROM_Bank0D_68C2::
    ds $173e, $ff
    assert @ == $8000

SECTION "Remaining ROM 0E:4000-7FFF", ROMX[$4000], BANK[$0E]
RemainingROM_Bank0E_4000::
    ds $4000, $ff
    assert @ == $8000

SECTION "Remaining ROM 0F:536F-53FF", ROMX[$536F], BANK[$0F]
RemainingROM_Bank0F_536F::
    ds $91, $ff
    assert @ == $5400

SECTION "Remaining ROM 0F:5433-7FFF", ROMX[$5433], BANK[$0F]
RemainingROM_Bank0F_5433::
    ds $2bcd, $ff
    assert @ == $8000

SECTION "Remaining ROM 10:6B45-7FFF", ROMX[$6B45], BANK[$10]
RemainingROM_Bank10_6B45::
    ds $14bb, $ff
    assert @ == $8000

SECTION "Remaining ROM 11:5E08-5E0F", ROMX[$5E08], BANK[$11]
RemainingROM_Bank11_5E08::
    db $00, $00, $00, $69, $ff, $7f, $40, $72
    assert @ == $5E10

SECTION "Remaining ROM 11:76B0-7FFF", ROMX[$76B0], BANK[$11]
RemainingROM_Bank11_76B0::
    ds $950, $ff
    assert @ == $8000

SECTION "Remaining ROM 13:402F-40FA", ROMX[$402F], BANK[$13]
RemainingROM_Bank13_402F::
    db $ee, $01, $21, $31, $c6, $cd, $bc, $29, $3e, $01, $77, $c9
RuntimeEntry_Bank13_403B::
    ld hl, $ca73
    ld bc, $001e
    xor a
    call Memset
    ret
RuntimeEntry_Bank13_4046::
    push af
    call RuntimeEntry_Bank13_403B
    pop af
    add a, a
    ld hl, $391c
    call AddAtoHL
    ld a, [hli]
    ld a, a
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [hl]
    ld h, a
    ld l, $00
    push hl
    ld bc, $0008
    add hl, bc
    ld d, h
    ld e, l
    ld hl, $ca73
    ld bc, $0008
    call Memcpy
    pop hl
    push hl
    ld bc, $0010
    add hl, bc
    ld d, h
    ld e, l
    ld hl, $ca7c
    ld bc, $000c
    call Memcpy
    pop hl
    ld bc, $001c
    add hl, bc
    ld d, h
    ld e, l
    ld hl, $cc14
    ld bc, $0004
    call Memcpy
    farcall BANK_26, Bank26_Entry_5CCB
    ld de, $cc19
    ld hl, $ca89
    ld bc, $0007
    call Memcpy
    call SRAM_Disable
    ret
RuntimeEntry_Bank13_40A3::
    ld a, [hli]
    cp $00
    jr nz, .loc_40CD
    ld a, [hli]
    cp $00
    jr nz, .loc_40CD
    ld a, [hli]
    cp $00
    jr nz, .loc_40CD
    ld a, [hli]
    cp $00
    jr nz, .loc_40CD
    ld a, [hli]
    cp $00
    jr nz, .loc_40CD
    ld a, [hli]
    cp $00
    jr nz, .loc_40CD
    ld a, [hli]
    cp $00
    jr nz, .loc_40CD
    ld a, [hli]
    cp $00
    jr nz, .loc_40CD
    jr .loc_40CF
.loc_40CD:
    scf
    ret
.loc_40CF:
    ret
RuntimeEntry_Bank13_40D0::
    ld hl, $ca73
    call RuntimeEntry_Bank13_40A3
    jr c, .loc_40EC
    call .loc_40EE
    jr c, .loc_40DF
    xor a
    ret
.loc_40DF:
    ld hl, $ca89
    farcall Bank31_TestSevenASCIIZeroBytes
    jr c, .loc_40EA
    scf
    ret
.loc_40EA:
    xor a
    ret
.loc_40EC:
    scf
    ret
.loc_40EE:
    ld hl, $ca89
    farcall NetworkRuntime_4F0E
    jr c, .loc_40F9
    xor a
    ret
.loc_40F9:
    scf
    ret
    assert @ == $40FB

SECTION "Remaining ROM 13:415D-4212", ROMX[$415D], BANK[$13]
RemainingROM_Bank13_415D::
    ; Source-owned structural bytes formerly data/map/structural/bank13_415d_4212.dat
    db $cd, $f3, $04, $cd, $ce, $34, $cd, $7c, $2d, $af, $e0, $95, $e0, $96, $ef, $10
    db $a8, $68, $ef, $01, $00, $40, $cd, $18, $06, $cd, $02, $0f, $3e, $00, $e0, $83
    db $e0, $4f, $3e, $00, $ef, $15, $91, $66, $f0, $83, $f5, $3e, $01, $e0, $83, $e0
    db $4f, $11, $cc, $57, $21, $00, $90, $01, $90, $00, $cd, $50, $3b, $11, $10, $5a
    db $21, $90, $90, $01, $40, $01, $ef, $15, $50, $3b, $f1, $e0, $83, $e0, $4f, $3e
    db $00, $06, $08, $21, $5c, $58, $cd, $bc, $06, $cd, $af, $06, $cd, $f2, $06, $3e
    db $0a, $01, $01, $05, $11, $02, $0a, $26, $09, $ef, $15, $fd, $67, $3e, $0a, $01
    db $11, $0f, $11, $01, $01, $26, $05, $ef, $15, $fd, $67, $3e, $08, $01, $11, $10
    db $11, $01, $03, $26, $06, $ef, $15, $fd, $67, $01, $04, $05, $11, $07, $0a, $ef
    db $10, $09, $6a, $f0, $83, $f5, $3e, $01, $e0, $83, $e0, $4f, $af, $01, $05, $06
    db $11, $05, $08, $ef, $15, $d3, $6a, $f1, $e0, $83, $e0, $4f, $01, $0c, $01, $11
    db $05, $12, $ef, $22, $47, $62
    assert @ == $4213

SECTION "Remaining ROM 13:4231-43E2", ROMX[$4231], BANK[$13]
RemainingROM_Bank13_4231::
    ; Source-owned structural bytes formerly data/map/structural/bank13_4231_4337.dat
    db $f0, $83, $f5, $3e, $20, $0e, $00, $06, $15, $11, $6e, $6f, $cd, $e8, $2d, $ea
    db $2c, $dc, $cd, $23, $43, $cd, $4f, $42, $f1, $e0, $83, $e0, $4f, $c9, $f0, $83
    db $f5, $3e, $00, $e0, $83, $e0, $4f, $af, $01, $0d, $02, $11, $03, $10, $ef, $15
    db $d3, $6a, $f1, $e0, $83, $e0, $4f, $21, $82, $42, $fa, $2a, $dc, $87, $4f, $06
    db $00, $09, $2a, $5f, $7e, $57, $7a, $67, $7b, $6f, $01, $0d, $02, $cd, $38, $2b
    db $c9, $0f, $57, $1a, $57, $3a, $57, $49, $57, $59, $57, $f0, $82, $f5, $3e, $04
    db $e0, $82, $e0, $70, $cd, $5d, $41, $3e, $02, $cd, $16, $38, $cd, $1d, $08, $cd
    db $a2, $05, $cd, $56, $30, $3e, $00, $ef, $15, $91, $67, $f0, $92, $cb, $77, $28
    db $1a, $3e, $01, $cd, $44, $38, $fa, $2a, $dc, $3d, $fe, $ff, $20, $02, $3e, $04
    db $ea, $2a, $dc, $cd, $23, $43, $cd, $4f, $42, $18, $d4, $cb, $7f, $28, $19, $3e
    db $01, $cd, $44, $38, $fa, $2a, $dc, $3c, $fe, $05, $20, $01, $af, $ea, $2a, $dc
    db $cd, $23, $43, $cd, $4f, $42, $18, $b7, $cb, $47, $28, $0c, $3e, $02, $cd, $44
    db $38, $fa, $2a, $dc, $18, $11, $18, $a7, $cb, $4f, $28, $09, $3e, $0c, $cd, $44
    db $38, $3e, $ff, $18, $02, $18, $98, $57, $f1, $e0, $82, $e0, $70, $d5, $cd, $b4
    db $07, $cd, $67, $2e, $d1, $7a, $fe, $04, $20, $07, $ef, $18, $08, $5c, $c3, $8c
    db $42, $c9, $fa, $2a, $dc, $06, $08, $cd, $95, $29, $7d, $c6, $3c, $4f, $06, $38
    db $fa, $2c, $dc, $cd, $ae, $2e, $c9
RuntimeEntry_Bank13_4338::
    push af
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $57cc
    ld hl, $9000
    ld bc, $0090
    call Memcpy
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$dc50]
    cp $08
    jr c, .loc_43A0
    ld a, $00
    ld b, $08
    ld hl, $589c
    call Vram_SetPals
    call Vram_SetDefaultBGPal
    ld a, $07
    ld b, $01
    ld c, $19
    ld hl, $7924
    call Vram_SetFarPals
    call Vram_ApplyPals
    jr .loc_43BC
.loc_43A0:
    ld a, $00
    ld b, $08
    ld hl, $585c
    call Vram_SetPals
    call Vram_SetDefaultBGPal
    ld a, $07
    ld b, $01
    ld c, $19
    ld hl, $7924
    call Vram_SetFarPals
    call Vram_ApplyPals
.loc_43BC:
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $05
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $06
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0101
    ld de, $1203
    farcall UIWindow_DrawFrame
    pop af
    assert @ == $43E3

SECTION "Remaining ROM 13:444C-4637", ROMX[$444C], BANK[$13]
RemainingROM_Bank13_444C::
    ; Source-owned structural bytes formerly data/map/structural/bank13_444c_449f.dat
    db $01, $0c, $01, $11, $05, $12, $ef, $10, $09, $6a, $f0, $83, $f5, $3e, $01, $e0
    db $83, $e0, $4f, $af, $01, $02, $02, $11, $01, $10, $ef, $15, $d3, $6a, $af, $01
    db $0d, $02, $11, $03, $10, $ef, $15, $d3, $6a, $f1, $e0, $83, $e0, $4f, $01, $06
    db $03, $16, $00, $cd, $29, $47, $01, $09, $03, $16, $05, $cd, $29, $47, $3e, $20
    db $0e, $00, $06, $15, $11, $44, $6f, $cd, $e8, $2d, $ea, $2c, $dc, $cd, $a0, $44
    db $cd, $17, $47, $c9
RuntimeEntry_Bank13_44A0::
    ld a, [$dc2b]
    ld b, $05
    farcall Math_DivideAByB
    ld b, $18
    call MultiplyAByB
    ld a, l
    add a, $28
    ld [$dc2d], a
    ld a, [$dc2b]
    ld b, $05
    farcall Math_DivideAByB
    ld a, b
    ld b, $18
    call MultiplyAByB
    ld a, l
    add a, $38
    ld [$dc2e], a
    ld a, [$dc2f]
    cp $01
    jr nz, .loc_44D8
    ld a, [$dc2e]
    sub $40
    ld [$dc2e], a
.loc_44D8:
    ld a, [$dc2d]
    ld b, a
    ld a, [$dc2e]
    ld c, a
    ld a, [$dc2c]
    call SpriteObject_SetPosition
    ret
RuntimeEntry_Bank13_44E7::
    ld a, [$dc30]
    ld b, $05
    farcall Math_DivideAByB
    ld b, $18
    call MultiplyAByB
    ld a, l
    add a, $28
    ld [$dc32], a
    ld a, [$dc30]
    ld b, $05
    farcall Math_DivideAByB
    ld a, b
    ld b, $18
    call MultiplyAByB
    ld a, l
    add a, $38
    ld [$dc33], a
    ld a, [$dc34]
    cp $01
    jr nz, .loc_451F
    ld a, [$dc33]
    sub $40
    ld [$dc33], a
.loc_451F:
    ld a, [$dc32]
    ld b, a
    ld a, [$dc33]
    ld c, a
    ld a, [$dc31]
    call SpriteObject_SetPosition
    ret
RuntimeEntry_Bank13_452E::
    push bc
    push de
    push hl
    ld a, [$dc50]
    cp $08
    jr c, .loc_4540
    ld a, d
    call RuntimeEntry_Bank13_4563
    jr c, .loc_4553
    jr .loc_454F
.loc_4540:
    ld a, d
    farcall MapRuntime_LoadCurrentModeRecord
    ld a, $01
    ld hl, $ca1d
    call Bitfield_Test
    jr z, .loc_4553
.loc_454F:
    ld a, $08
    jr .loc_4555
.loc_4553:
    ld a, $0d
.loc_4555:
    pop hl
    pop de
    pop bc
    ret
RuntimeEntry_Bank13_4559::
    ld b, $12
    call MultiplyAByB
    ld bc, $ba8a
    add hl, bc
    ret
RuntimeEntry_Bank13_4563::
    push af
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    pop af
    call RuntimeEntry_Bank13_4559
    ld bc, $0000
    add hl, bc
    ld a, [hl]
    cp $00
    jr z, .loc_457C
    xor a
    jr .loc_457D
.loc_457C:
    scf
.loc_457D:
    call SRAM_Disable
    ret
RuntimeEntry_Bank13_4581::
    ld hl, $459d
    ld bc, $020d
    call TextPut
    ld hl, $459d
    ld bc, $020e
    call TextPut
    ld hl, $459d
    ld bc, $020f
    call TextPut
    ret
    ; Source-owned structural bytes formerly data/map/structural/bank13_459d_45f7.dat
    db $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    db $00, $11, $3d, $ca, $21, $14, $cc, $01, $04, $00, $cd, $50, $3b, $ef, $26, $cb
    db $5c, $21, $19, $cc, $2a, $fe, $30, $20, $20, $2a, $fe, $30, $20, $1b, $2a, $fe
    db $30, $20, $16, $2a, $fe, $30, $20, $11, $2a, $fe, $30, $20, $0c, $2a, $fe, $30
    db $20, $07, $2a, $fe, $30, $20, $02, $18, $10, $3e, $00, $ea, $20, $cc, $21, $1c
    db $cc, $01, $0e, $08, $cd, $53, $33, $af, $c9, $37, $c9
RuntimeEntry_Bank13_45F8::
    call RuntimeEntry_Bank13_4581
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$dc2b]
    call RuntimeEntry_Bank13_4559
    ld bc, $0001
    add hl, bc
    ld d, h
    ld e, l
    ld hl, $ca6a
    ld bc, $0008
    call Memcpy
    ld a, [$dc2b]
    call RuntimeEntry_Bank13_4559
    ld bc, $000a
    add hl, bc
    ld d, h
    ld e, l
    ld hl, $dc44
    ld bc, $0008
    call Memcpy
    ld a, [$dc2b]
    call RuntimeEntry_Bank13_4559
    ld bc, $0000
    add hl, bc
    ld a, [hl]
    assert @ == $4638

SECTION "Remaining ROM 13:46AA-46AE", ROMX[$46AA], BANK[$13]
RemainingROM_Bank13_46AA::
    db $cd, $ae, $45, $38, $08
    assert @ == $46AF

SECTION "Remaining ROM 13:46B5-46FE", ROMX[$46B5], BANK[$13]
RemainingROM_Bank13_46B5::
    ; Source-owned structural bytes formerly data/map/structural/bank13_46b5_46fd.dat
    db $18, $00, $11, $31, $ca, $21, $a8, $da, $01, $0c, $00, $cd, $50, $3b, $af, $ea
    db $b4, $da, $fa, $a8, $da, $fe, $00, $28, $0b, $21, $a8, $da, $01, $0f, $02, $cd
    db $53, $33, $18, $2f, $11, $29, $ca, $21, $a8, $da, $01, $08, $00, $cd, $50, $3b
    db $fa, $a8, $da, $fe, $00, $28, $02, $18, $05, $21, $09, $47, $18, $03, $21, $09
    db $47, $01, $0f, $02, $cd, $53, $33, $18, $0a
RuntimeEntry_Bank13_46FE::
    pop af
    assert @ == $46FF

SECTION "Remaining ROM 13:4708-4708", ROMX[$4708], BANK[$13]
RemainingROM_Bank13_4708::
    db $c9
    assert @ == $4709

SECTION "Remaining ROM 13:4A7E-4AC2", ROMX[$4A7E], BANK[$13]
RemainingROM_Bank13_4A7E::
    ; Source-owned structural bytes formerly data/map/structural/bank13_4a7e_4ac2.dat
    db $01, $0c, $01, $11, $05, $12, $ef, $22, $47, $62, $01, $06, $03, $16, $00, $cd
    db $29, $47, $01, $09, $03, $16, $05, $cd, $29, $47, $3e, $20, $0e, $00, $06, $15
    db $11, $98, $6f, $cd, $e8, $2d, $ea, $37, $dc, $cd, $c3, $4a, $3e, $20, $0e, $00
    db $06, $15, $11, $44, $6f, $cd, $e8, $2d, $ea, $2c, $dc, $cd, $a0, $44, $fa, $2c
    db $dc, $cd, $5f, $2f, $c9
    assert @ == $4AC3

SECTION "Remaining ROM 13:4B0A-4B48", ROMX[$4B0A], BANK[$13]
RemainingROM_Bank13_4B0A::
RuntimeEntry_Bank13_4B0A::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $020d
    ld de, $1003
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $4b3d
    ld a, [$dc36]
    add a, a
    ld c, a
    ld b, $00
    add hl, bc
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld a, d
    ld h, a
    ld a, e
    ld l, a
    ld bc, $020d
    call TextPrint
    ret
    db $0f, $57, $3a, $57, $78, $57, $1a, $57, $49, $57, $9e, $57
    assert @ == $4B49

SECTION "Remaining ROM 13:4D55-4F3F", ROMX[$4D55], BANK[$13]
RemainingROM_Bank13_4D55::
    ; Source-owned structural bytes formerly data/map/structural/bank13_4d55_4e5f.dat
    db $fa, $2c, $dc, $cd, $11, $2f, $3e, $20, $0e, $00, $06, $15, $11, $44, $6f, $cd
    db $e8, $2d, $ea, $31, $dc, $cd, $e7, $44, $fa, $30, $dc, $cd, $63, $46, $cd, $a2
    db $05, $cd, $56, $30, $3e, $00, $ef, $15, $91, $67, $f0, $92, $cb, $77, $28, $1a
    db $3e, $01, $cd, $44, $38, $fa, $30, $dc, $d6, $05, $38, $0c, $ea, $30, $dc, $cd
    db $e7, $44, $fa, $30, $dc, $cd, $63, $46, $18, $d4, $cb, $7f, $28, $1c, $3e, $01
    db $cd, $44, $38, $fa, $30, $dc, $c6, $05, $fe, $0a, $30, $0c, $ea, $30, $dc, $cd
    db $e7, $44, $fa, $30, $dc, $cd, $63, $46, $18, $b4, $cb, $6f, $28, $1d, $3e, $01
    db $cd, $44, $38, $fa, $30, $dc, $3d, $fe, $ff, $20, $02, $3e, $09, $ea, $30, $dc
    db $cd, $e7, $44, $fa, $30, $dc, $cd, $63, $46, $18, $93, $cb, $67, $28, $1c, $3e
    db $01, $cd, $44, $38, $fa, $30, $dc, $3c, $fe, $0a, $20, $01, $af, $ea, $30, $dc
    db $cd, $e7, $44, $fa, $30, $dc, $cd, $63, $46, $18, $56, $cb, $47, $28, $3d, $3e
    db $02, $cd, $44, $38, $fa, $30, $dc, $cd, $bd, $51, $28, $09, $3e, $01, $cd, $01
    db $53, $fe, $01, $28, $3c, $fa, $31, $dc, $ef, $15, $1e, $5d, $cd, $f4, $52, $fa
    db $30, $dc, $ea, $2b, $dc, $cd, $a0, $44, $fa, $31, $dc, $cd, $1f, $2e, $ef, $10
    db $08, $69, $18, $20, $cd, $ac, $51, $cd, $17, $47, $18, $15, $cb, $4f, $28, $11
    db $3e, $0c, $cd, $44, $38, $fa, $31, $dc, $cd, $1f, $2e, $ef, $10, $08, $69, $18
    db $03, $c3, $73, $4d, $fa, $2c, $dc, $cd, $2b, $2f, $c9
RuntimeEntry_Bank13_4E60::
    ld bc, $0101
    ld de, $1204
    farcall UIWindowStack_PushAndDraw
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0202
    ld de, $1001
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    call $4b49
    ld a, [$dc37]
    call SpriteObject_Hide
    ld a, [$dc2c]
    call SpriteObject_Show
    call MapMenu_DrawCurrentSelectionSummary
    ld a, $02
    call Audio_PlayMusic
    ret
    ; Source-owned structural bytes formerly data/map/structural/bank13_4e9b_4ef3.dat
    db $f5, $ef, $26, $ac, $56, $01, $08, $00, $3e, $30, $21, $a8, $da, $cd, $79, $3b
    db $af, $ea, $b0, $da, $21, $cd, $cb, $01, $00, $00, $7e, $fe, $00, $28, $04, $03
    db $23, $18, $f7, $c5, $3e, $08, $91, $21, $a8, $da, $cd, $bc, $29, $c1, $11, $cd
    db $cb, $cd, $50, $3b, $f1, $87, $21, $1c, $39, $cd, $bc, $29, $2a, $7f, $cd, $8d
    db $05, $cd, $93, $05, $7e, $67, $2e, $00, $01, $08, $00, $09, $11, $a8, $da, $01
    db $08, $00, $cd, $50, $3b, $cd, $9b, $05, $c9
RuntimeEntry_Bank13_4EF4::
    add a, a
    ld hl, $391c
    call AddAtoHL
    ld a, [hli]
    ld a, a
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [hl]
    ld h, a
    ld l, $00
    ld bc, $0008
    add hl, bc
    ld bc, $0008
    xor a
    call Memset
    call SRAM_Disable
    ret
    ; Source-owned structural bytes formerly data/map/structural/bank13_4f16_4f3f.dat
    db $f5, $ef, $26, $ac, $56, $f1, $87, $21, $1c, $39, $cd, $bc, $29, $2a, $7f, $cd
    db $8d, $05, $cd, $93, $05, $7e, $67, $2e, $00, $01, $08, $00, $09, $11, $cd, $cb
    db $01, $08, $00, $cd, $50, $3b, $cd, $9b, $05, $c9
    assert @ == $4F40

SECTION "Remaining ROM 13:585C-58DB", ROMX[$585C], BANK[$13]
RemainingROM_Bank13_585C::
    ; Source-owned structural bytes formerly data/map/structural/bank13_585c_58db.dat
    db $00, $00, $00, $69, $ff, $7f, $40, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $00, $00, $9f, $00, $ff, $7f, $1f, $42
    db $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c
    db $00, $00, $80, $69, $ff, $7f, $c0, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $bf, $02, $75, $01, $00, $00, $80, $7d, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $00, $00, $9f, $00, $ff, $7f, $1f, $42
    db $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c
    assert @ == $58DC

SECTION "Remaining ROM 13:5D37-5D53", ROMX[$5D37], BANK[$13]
RemainingROM_Bank13_5D37::
RuntimeEntry_Bank13_5D37::
    push bc
    push de
    push hl
    add a, a
    ld hl, $391c
    call AddAtoHL
    ld a, [hli]
    ld [$c87e], a
    ld a, [hli]
    ld [$c880], a
    xor a
    ld [$c87f], a
    call $6161
    pop hl
    pop de
    pop bc
    ret
    assert @ == $5D54

SECTION "Remaining ROM 13:5E54-5E54", ROMX[$5E54], BANK[$13]
RemainingROM_Bank13_5E54::
    db $c9
    assert @ == $5E55

SECTION "Remaining ROM 13:6256-6367", ROMX[$6256], BANK[$13]
RemainingROM_Bank13_6256::
    ; Source-owned structural bytes formerly data/map/structural/bank13_6256_6367.dat
    db $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4
    db $3e, $01, $ea, $d3, $c4, $3e, $0e, $ea, $d4, $c4, $3e, $62, $ea, $d5, $c4, $3e
    db $8e, $ea, $d6, $c4, $3e, $13, $ea, $d7, $c4, $3e, $bf, $ef, $1a, $10, $45, $fa
    db $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $3e, $ff, $ea, $cc, $c4, $af, $ea, $cd
    db $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $2d, $ea
    db $d4, $c4, $3e, $74, $ea, $d5, $c4, $3e, $b3, $ea, $d6, $c4, $3e, $1a, $ea, $d7
    db $c4, $3e, $c3, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $3e, $7e, $ea
    db $db, $c4, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea
    db $d2, $c4, $af, $ea, $d3, $c4, $3e, $01, $ea, $d4, $c4, $af, $ea, $d5, $c4, $ea
    db $d6, $c4, $ea, $d7, $c4, $3e, $79, $cd, $44, $38, $c3, $8a, $02, $3e, $01, $ea
    db $cc, $c4, $3e, $80, $ea, $cd, $c4, $af, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1
    db $c4, $3e, $1e, $ea, $d2, $c4, $af, $ea, $d3, $c4, $3e, $b4, $ea, $d4, $c4, $af
    db $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $3e, $dd, $ef, $1a, $10, $45, $fa
    db $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $3e, $01, $ea, $cc, $c4, $3e, $80, $ea
    db $cd, $c4, $af, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $3e, $1e, $ea, $d2
    db $c4, $ea, $d3, $c4, $3e, $aa, $ea, $d4, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4
    db $ea, $d7, $c4, $3e, $de, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3
    db $8a, $02
    assert @ == $6368

SECTION "Remaining ROM 13:64F5-7FFF", ROMX[$64F5], BANK[$13]
RemainingROM_Bank13_64F5::
    ds $1b0b, $ff
    assert @ == $8000

SECTION "Remaining ROM 14:4C96-4CD2", ROMX[$4C96], BANK[$14]
RemainingROM_Bank14_4C96::
RuntimeEntry_Bank14_4C96::
    ld a, $00
    ld [$cc3d], a
    ld a, $fc
    ldh [$ff95], a
    xor a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    xor a
    ld [$cc38], a
    ld [$cc39], a
    ld [$cc3e], a
    ld [$cc3f], a
    ld a, [$cc43]
    cp $00
    jr z, .loc_4CC2
    cp $01
    jr z, RuntimeEntry_Bank14_4CDB
    cp $02
    jr z, TextInput_MapNameLengthHook
.loc_4CC2:
    xor a
    ld [$cc3a], a
    ld hl, $cc2f
    ld bc, $0007
    ld a, $00
    call Memset
    jr RuntimeEntry_Bank14_4CEF
    assert @ == $4CD3

SECTION "Remaining ROM 14:4CDA-4E3A", ROMX[$4CDA], BANK[$14]
RemainingROM_Bank14_4CDA::
    db $14
RuntimeEntry_Bank14_4CDB::
    ld de, $c67e
    ld hl, $cc2f
    ld bc, $0007
    call Memcpy
    call TextInput_GetLength
    ld [$cc3a], a
    jr RuntimeEntry_Bank14_4CEF
RuntimeEntry_Bank14_4CEF::
    ld a, [$55aa]
    ld [$cc3b], a
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $56f8
    ld hl, $9000
    ld bc, $0270
    call Memcpy
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    ld b, $08
    ld hl, $5968
    call Vram_SetPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [$cc3c], a
    call RuntimeEntry_Bank14_5375
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0a
    ld bc, $0011
    ld de, $0301
    ld h, $19
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0311
    ld de, $0401
    ld h, $1c
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0811
    ld de, $0301
    ld h, $20
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0b11
    ld de, $0401
    ld h, $23
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $1011
    ld de, $0101
    ld h, $16
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1111
    ld de, $0201
    ld h, $17
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0000
    ld de, $1303
    farcall UIWindow_DrawFrame
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0101
    ld de, $1101
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0101
    ld de, $1101
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0003
    ld de, $130e
    farcall UIWindow_DrawFrame
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0104
    ld de, $110c
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$cc43]
    cp $02
    jr nz, .loc_4E19
    ld hl, $4e33
    jr .loc_4E1C
.loc_4E19:
    ld hl, $4e29
.loc_4E1C:
    ld bc, $0101
    call TextPut
    call TextInput_RedrawCurrentValue
    call RuntimeEntry_Bank14_4E8D
    ret
    db $6c, $8a, $62, $66, $8d, $79, $75, $7f, $64, $00, $cf, $ff, $f4, $79, $75, $7f, $64, $00
    assert @ == $4E3B

SECTION "Remaining ROM 14:4E8D-5244", ROMX[$4E8D], BANK[$14]
RemainingROM_Bank14_4E8D::
RuntimeEntry_Bank14_4E8D::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0105
    call Vram_TilemapCoord
    ld de, $55aa
    call Vram_DrawZeroTerminatedRow
    ld bc, $0107
    call Vram_TilemapCoord
    ld de, $55bc
    call Vram_DrawZeroTerminatedRow
    ld bc, $0109
    call Vram_TilemapCoord
    ld de, $55ce
    call Vram_DrawZeroTerminatedRow
    ld bc, $010b
    call Vram_TilemapCoord
    ld de, $55e0
    call Vram_DrawZeroTerminatedRow
    ld bc, $010d
    call Vram_TilemapCoord
    ld de, $55f2
    call Vram_DrawZeroTerminatedRow
    ld bc, $010f
    call Vram_TilemapCoord
    ld de, $5604
    call Vram_DrawZeroTerminatedRow
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0b
    ld bc, $0d0d
    ld de, $0501
    ld h, $06
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0b
    ld bc, $0d0f
    ld de, $0501
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
RuntimeEntry_Bank14_4F00::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0105
    call Vram_TilemapCoord
    ld de, $5616
    call Vram_DrawZeroTerminatedRow
    ld bc, $0107
    call Vram_TilemapCoord
    ld de, $5628
    call Vram_DrawZeroTerminatedRow
    ld bc, $0109
    call Vram_TilemapCoord
    ld de, $563a
    call Vram_DrawZeroTerminatedRow
    ld bc, $010b
    call Vram_TilemapCoord
    ld de, $564c
    call Vram_DrawZeroTerminatedRow
    ld bc, $010d
    call Vram_TilemapCoord
    ld de, $565e
    call Vram_DrawZeroTerminatedRow
    ld bc, $010f
    call Vram_TilemapCoord
    ld de, $5670
    call Vram_DrawZeroTerminatedRow
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0b
    ld bc, $0d0d
    ld de, $0501
    ld h, $0b
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0b
    ld bc, $0d0f
    ld de, $0501
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
RuntimeEntry_Bank14_4F73::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0105
    call Vram_TilemapCoord
    ld de, $5682
    call Vram_DrawZeroTerminatedRow
    ld bc, $0107
    call Vram_TilemapCoord
    ld de, $5694
    call Vram_DrawZeroTerminatedRow
    ld bc, $0109
    call Vram_TilemapCoord
    ld de, $56a6
    call Vram_DrawZeroTerminatedRow
    ld bc, $010b
    call Vram_TilemapCoord
    ld de, $56b8
    call Vram_DrawZeroTerminatedRow
    ld bc, $010d
    call Vram_TilemapCoord
    ld de, $56ca
    call Vram_DrawZeroTerminatedRow
    ld bc, $010f
    call Vram_TilemapCoord
    ld de, $56dc
    call Vram_DrawZeroTerminatedRow
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0b
    ld bc, $0d0d
    ld de, $0501
    ld h, $10
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0b
    ld bc, $0d0f
    ld de, $0501
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
RuntimeEntry_Bank14_4FE6::
    ldh a, [$ff92]
    bit 0, a
    jr z, .loc_4FF7
    ld a, $02
    call Audio_PlaySFX
    call RuntimeEntry_Bank14_51DE
    jp .loc_512A
.loc_4FF7:
    bit 1, a
    jr z, .loc_5006
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    call TextInput_Backspace
    jp .loc_512A
.loc_5006:
    bit 5, a
    jr z, .loc_5045
    ld a, $01
    call Audio_PlaySFX
.loc_500F:
    ld a, [$cc38]
    dec a
    cp $ff
    jr z, .loc_502D
    ld [$cc38], a
    call .loc_5151
    call RuntimeEntry_Bank14_5375
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    cp $02
    jr z, .loc_500F
    jp .loc_512A
.loc_502D:
    ld a, $10
    ld [$cc38], a
    call .loc_5151
    call RuntimeEntry_Bank14_5375
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    cp $02
    jr z, .loc_500F
    jp .loc_512A
.loc_5045:
    bit 4, a
    jr z, .loc_5083
    ld a, $01
    call Audio_PlaySFX
.loc_504E:
    ld a, [$cc38]
    inc a
    cp $11
    jr nc, .loc_506C
    ld [$cc38], a
    call .loc_512B
    call RuntimeEntry_Bank14_5375
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    cp $02
    jr z, .loc_504E
    jp .loc_512A
.loc_506C:
    xor a
    ld [$cc38], a
    call .loc_512B
    call RuntimeEntry_Bank14_5375
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    cp $02
    jr z, .loc_504E
    jp .loc_512A
.loc_5083:
    bit 6, a
    jr z, .loc_50C8
    ld a, $01
    call Audio_PlaySFX
.loc_508C:
    ld a, [$cc39]
    dec a
    cp $ff
    jr z, .loc_50A7
    ld [$cc39], a
    call RuntimeEntry_Bank14_5375
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    cp $02
    jr z, .loc_508C
    jp .loc_512A
.loc_50A7:
    ld a, $05
    ld [$cc39], a
    call RuntimeEntry_Bank14_5375
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    cp $02
    jr z, .loc_508C
    jr .loc_512A
    db $3e, $03, $ea, $39, $cc, $cd, $75, $53, $cd, $ae, $51, $18, $62
.loc_50C8:
    bit 7, a
    jr z, .loc_50FF
    ld a, $01
    call Audio_PlaySFX
.loc_50D1:
    ld a, [$cc39]
    inc a
    cp $06
    jr z, .loc_50EC
    ld [$cc39], a
    call RuntimeEntry_Bank14_5375
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    cp $02
    jr z, .loc_50D1
    jp .loc_512A
.loc_50EC:
    xor a
    ld [$cc39], a
    call RuntimeEntry_Bank14_5375
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    cp $02
    jr z, .loc_50D1
    jr .loc_512A
.loc_50FF:
    bit 2, a
    jr z, .loc_5110
    ld a, $01
    call Audio_PlaySFX
    call .loc_517B
    call .loc_5195
    jr .loc_512A
.loc_5110:
    bit 3, a
    jr z, .loc_512A
    ld a, $02
    call Audio_PlaySFX
    ld a, [$cc3a]
    cp $00
    jr nz, .loc_5127
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jr .loc_512A
.loc_5127:
    call RuntimeEntry_Bank14_53EF
.loc_512A:
    ret
.loc_512B:
    ld a, [$cc3b]
    push af
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    ld c, a
    pop af
    cp c
    jr nz, .loc_5143
    ld a, [$cc38]
    inc a
    ld [$cc38], a
    jr .loc_512B
.loc_5143:
    ld a, [$cc38]
    inc a
    cp $12
    jr nc, .loc_514C
    ret
.loc_514C:
    xor a
    ld [$cc38], a
    ret
.loc_5151:
    ld a, [$cc3b]
    push af
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3b]
    ld c, a
    pop af
    cp c
    jr nz, .loc_5169
    ld a, [$cc38]
    dec a
    ld [$cc38], a
    jr .loc_5151
.loc_5169:
    ret
    db $3e, $0c, $ea, $38, $cc, $3e, $05, $ea, $39, $cc, $cd, $75, $53, $cd, $ae, $51, $c9
.loc_517B:
    ld a, [$cc3d]
    inc a
    cp $03
    jr nz, .loc_5184
    xor a
.loc_5184:
    ld [$cc3d], a
    xor a
    ld [$cc38], a
    ld [$cc39], a
    call RuntimeEntry_Bank14_5375
    call RuntimeEntry_Bank14_51AE
    ret
.loc_5195:
    ld a, [$cc3d]
    cp $00
    jr nz, .loc_51A1
    call RuntimeEntry_Bank14_4E8D
    jr .loc_51AD
.loc_51A1:
    cp $01
    jr nz, .loc_51AA
    call RuntimeEntry_Bank14_4F00
    jr .loc_51AD
.loc_51AA:
    call RuntimeEntry_Bank14_4F73
.loc_51AD:
    ret
RuntimeEntry_Bank14_51AE::
    ld a, [$cc39]
    ld b, $12
    call MultiplyAByB
    ld a, l
    ld hl, $cc38
    add a, [hl]
    push af
    ld a, [$cc3d]
    cp $00
    jr nz, .loc_51C8
    ld hl, $55aa
    jr .loc_51D4
.loc_51C8:
    cp $01
    jr nz, .loc_51D1
    ld hl, $5616
    jr .loc_51D4
.loc_51D1:
    ld hl, $5682
.loc_51D4:
    pop af
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [$cc3b], a
    ret
RuntimeEntry_Bank14_51DE::
    ld a, [$cc3b]
    cp $04
    jr nz, .loc_51EF
    ld a, $00
    ld [$cc3d], a
    call RuntimeEntry_Bank14_4E8D
    jr .loc_5222
.loc_51EF:
    cp $03
    jr nz, .loc_51FD
    ld a, $01
    ld [$cc3d], a
    call RuntimeEntry_Bank14_4F00
    jr .loc_5222
.loc_51FD:
    cp $05
    jr nz, .loc_520B
    ld a, $02
    ld [$cc3d], a
    call RuntimeEntry_Bank14_4F73
    jr .loc_5222
.loc_520B:
    cp $06
    jr nz, .loc_5226
    ld a, [$cc3a]
    cp $00
    jr nz, .loc_521D
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jr .loc_5222
.loc_521D:
    call RuntimeEntry_Bank14_53EF
    jr .loc_5222
.loc_5222:
    call RuntimeEntry_Bank14_51AE
    ret
.loc_5226:
    call TextInput_AppendCharacter
    ret
    db $15, $15, $15, $15, $15, $15, $15, $15, $ff, $08, $08, $08, $08, $08, $08, $08, $08, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $ff
    assert @ == $5245

SECTION "Remaining ROM 14:52B9-531D", ROMX[$52B9], BANK[$14]
RemainingROM_Bank14_52B9::
    ; Source-owned structural bytes formerly data/battle/structural/bank14_52b9_531d.dat
    db $f5, $21, $2a, $98, $fa, $3a, $cc, $cd, $bc, $29, $54, $5d, $d5, $fa, $3a, $cc
    db $4f, $3e, $08, $91, $47, $c5, $fa, $3a, $cc, $fe, $08, $28, $06, $21, $2a, $52
    db $cd, $0f, $35, $3e, $01, $ea, $cb, $ff, $c1, $d1, $fa, $3a, $cc, $fe, $08, $28
    db $06, $21, $33, $52, $cd, $0f, $35, $3e, $01, $ea, $cb, $ff, $11, $2a, $98, $fa
    db $3a, $cc, $47, $fe, $00, $28, $06, $21, $3c, $52, $cd, $0f, $35, $af, $ea, $cb
    db $ff, $fa, $3a, $cc, $fe, $00, $28, $09, $01, $01, $0a, $21, $2f, $cc, $cd, $53
    db $33, $f1, $ea, $cb, $ff
    assert @ == $531E

SECTION "Remaining ROM 14:5324-5354", ROMX[$5324], BANK[$14]
RemainingROM_Bank14_5324::
    ; Source-owned structural bytes formerly data/battle/structural/bank14_5324_5354.dat
    db $28, $0a, $fa, $3a, $cc, $fe, $06, $ca, $51, $53, $18, $08, $fa, $3a, $cc, $fe
    db $08, $ca, $51, $53, $21, $2f, $cc, $fa, $3a, $cc, $06, $00, $4f, $09, $fa, $3b
    db $cc, $77, $23, $3e, $00, $77, $fa, $3a, $cc, $3c, $ea, $3a, $cc, $cd, $45, $52
    db $c9
    assert @ == $5355

SECTION "Remaining ROM 14:535A-546C", ROMX[$535A], BANK[$14]
RemainingROM_Bank14_535A::
    db $28, $18, $3d, $fe, $ff, $28, $10, $ea, $3a, $cc, $21, $2f, $cc, $fa, $3a, $cc, $06, $00, $4f, $09, $3e, $00, $77, $cd, $45, $52, $c9
RuntimeEntry_Bank14_5375::
    ld a, [$cc38]
    ld b, $08
    call MultiplyAByB
    ld a, l
    add a, $18
    ld d, a
    push de
    call RuntimeEntry_Bank14_51AE
    ld a, [$cc3d]
    cp $00
    jr z, .loc_5394
    cp $01
    jr z, .loc_53A5
    cp $02
    jr z, .loc_53B6
.loc_5394:
    ld a, [$cc3b]
    cp $03
    jr z, .loc_53C7
    cp $05
    jr z, .loc_53CD
    cp $06
    jr z, .loc_53D3
    jr .loc_53D9
.loc_53A5:
    ld a, [$cc3b]
    cp $04
    jr z, .loc_53C7
    cp $05
    jr z, .loc_53CD
    cp $06
    jr z, .loc_53D3
    jr .loc_53D9
.loc_53B6:
    ld a, [$cc3b]
    cp $04
    jr z, .loc_53C7
    cp $03
    jr z, .loc_53CD
    cp $06
    jr z, .loc_53D3
    jr .loc_53D9
.loc_53C7:
    pop de
    ld a, $7e
    ld d, a
    jr .loc_53DA
.loc_53CD:
    pop de
    ld a, $92
    ld d, a
    jr .loc_53DA
.loc_53D3:
    pop de
    ld a, $88
    ld d, a
    jr .loc_53DA
.loc_53D9:
    pop de
.loc_53DA:
    ld a, [$cc39]
    ld b, $10
    call MultiplyAByB
    ld a, l
    add a, $37
    ld c, a
    ld a, d
    ld b, a
    ld a, [$cc3c]
    call SpriteObject_SetPosition
    ret
RuntimeEntry_Bank14_53EF::
    push bc
    push hl
    call $546d
.loc_53F4:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff91]
    bit 5, a
    jr z, .loc_5413
    ld a, $01
    call Audio_PlaySFX
    call RuntimeEntry_Bank14_54AD
    ld a, $01
    ld [$cc40], a
.loc_5413:
    ldh a, [$ff91]
    bit 4, a
    jr z, .loc_5425
    ld a, $01
    call Audio_PlaySFX
    call RuntimeEntry_Bank14_54D8
    xor a
    ld [$cc40], a
.loc_5425:
    ldh a, [$ff91]
    bit 0, a
    jr z, .loc_5430
    ld a, [$cc40]
    jr .loc_543F
.loc_5430:
    ldh a, [$ff91]
    bit 1, a
    jr z, .loc_53F4
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    xor a
    ld [$cc40], a
.loc_543F:
    ld a, [$cc40]
    cp $00
    jr z, .loc_544B
    ld a, $01
    ld [$cc3e], a
.loc_544B:
    ld a, [$cc3c]
    call SpriteObject_Show
    push af
    ld a, [$cc3e]
    cp $00
    jr z, .loc_5460
    ld a, $02
    call Audio_PlaySFX
    jr .loc_5469
.loc_5460:
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    farcall UIWindowStack_PopRestore
.loc_5469:
    pop af
    pop hl
    pop bc
    ret
    assert @ == $546D

SECTION "Remaining ROM 14:54AD-56ED", ROMX[$54AD], BANK[$14]
RemainingROM_Bank14_54AD::
RuntimeEntry_Bank14_54AD::
    ld a, $0f
    ld bc, $0709
    ld de, $0201
    ld h, $fb
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0909
    ld de, $0101
    ld h, $fd
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0a09
    ld de, $0201
    ld h, $fe
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
RuntimeEntry_Bank14_54D8::
    ld a, $08
    ld bc, $0709
    ld de, $0201
    ld h, $fb
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0909
    ld de, $0101
    ld h, $fd
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0f
    ld bc, $0a09
    ld de, $0201
    ld h, $fe
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
RuntimeEntry_Bank14_5503::
    ld a, [$ffcb]
    push af
    push bc
    ld a, $01
    ld [$ffcb], a
    ld a, $08
    call Vram_DrawTileAtCoordinates
    pop bc
    xor a
    ld [$ffcb], a
    ld a, $15
    call Vram_DrawTileAtCoordinates
    pop af
    ld [$ffcb], a
    xor a
    ld [$cc42], a
    ret
RuntimeEntry_Bank14_5525::
    ld a, [$ffcb]
    push af
    push bc
    ld a, $01
    ld [$ffcb], a
    xor a
    call Vram_DrawTileAtCoordinates
    pop bc
    xor a
    ld [$ffcb], a
    xor a
    call Vram_DrawTileAtCoordinates
    pop af
    ld [$ffcb], a
    ret
RuntimeEntry_Bank14_5541::
    ld a, [$cc43]
    cp $02
    jr z, .loc_5551
    ld a, [$cc3a]
    cp $06
    jp c, .loc_555A
    ret
.loc_5551:
    ld a, [$cc3a]
    cp $08
    jp c, .loc_555A
    ret
.loc_555A:
    ld a, [$cc41]
    cp $0a
    jp c, .loc_55A2
    xor a
    ld [$cc41], a
    ld a, [$cc42]
    cp $00
    jp z, .loc_5586
    ld a, [$cc3a]
    ld b, $0c
    add a, b
    ld b, a
    ld c, $01
    ld a, [$cc43]
    cp $02
    jr nz, .loc_5580
    dec b
    dec b
.loc_5580:
    call RuntimeEntry_Bank14_5503
    jp .loc_55A2
.loc_5586:
    ld a, [$cc3a]
    ld b, $0c
    add a, b
    ld b, a
    ld c, $01
    ld a, [$cc43]
    cp $02
    jr nz, .loc_5598
    dec b
    dec b
.loc_5598:
    push bc
    pop bc
    call RuntimeEntry_Bank14_5525
    ld a, $01
    ld [$cc42], a
.loc_55A2:
    ld a, [$cc41]
    inc a
    ld [$cc41], a
    ret
    ; Source-owned structural bytes formerly data/battle/structural/bank14_55aa_56ed.dat
    db $61, $62, $63, $64, $65, $02, $7f, $80, $81, $82, $83, $02, $93, $94, $95, $96
    db $97, $00, $66, $67, $68, $69, $6a, $02, $84, $85, $86, $8c, $60, $02, $98, $99
    db $9a, $9b, $9c, $00, $6b, $6c, $6d, $6e, $6f, $02, $87, $88, $89, $8a, $8b, $02
    db $9d, $9e, $9f, $a0, $a1, $00, $70, $71, $72, $73, $74, $02, $a7, $a8, $a9, $aa
    db $ab, $02, $a2, $a3, $a4, $a5, $a6, $00, $75, $76, $77, $78, $79, $02, $af, $ac
    db $ad, $ae, $8d, $02, $03, $03, $03, $05, $05, $00, $7a, $7b, $7c, $7d, $7e, $02
    db $8e, $8f, $90, $91, $92, $02, $06, $06, $06, $06, $06, $00, $b1, $b2, $b3, $b4
    db $b5, $02, $cf, $d0, $d1, $d2, $d3, $02, $e3, $e4, $e5, $e6, $e7, $00, $b6, $b7
    db $b8, $b9, $ba, $02, $d4, $d5, $d6, $dc, $b0, $02, $e8, $e9, $ea, $eb, $ec, $00
    db $bb, $bc, $bd, $be, $bf, $02, $d7, $d8, $d9, $da, $db, $02, $ed, $ee, $ef, $f0
    db $f1, $00, $c0, $c1, $c2, $c3, $c4, $02, $f7, $f8, $f9, $fa, $fb, $02, $f2, $f3
    db $f4, $f5, $f6, $00, $c5, $c6, $c7, $c8, $c9, $02, $ff, $fc, $fd, $fe, $dd, $02
    db $04, $04, $04, $05, $05, $00, $ca, $cb, $cc, $cd, $ce, $02, $de, $df, $e0, $e1
    db $e2, $02, $06, $06, $06, $06, $06, $00, $41, $42, $43, $44, $45, $02, $31, $32
    db $33, $34, $35, $02, $02, $02, $02, $02, $02, $00, $46, $47, $48, $49, $4a, $02
    db $36, $37, $38, $39, $30, $02, $02, $02, $02, $02, $02, $00, $4b, $4c, $4d, $4e
    db $4f, $02, $20, $11, $12, $13, $14, $02, $02, $02, $02, $02, $02, $00, $50, $51
    db $52, $53, $54, $02, $15, $2d, $17, $18, $19, $02, $02, $02, $02, $02, $02, $00
    db $55, $56, $57, $58, $59, $02, $1b, $1d, $1c, $21, $10, $02, $04, $04, $04, $03
    db $03, $00, $5a, $23, $24, $25, $26, $02, $28, $29, $2a, $2b, $2f, $02, $06, $06
    db $06, $06, $06, $00
    assert @ == $56EE

SECTION "Remaining ROM 14:56F8-5707", ROMX[$56F8], BANK[$14]
RemainingROM_Bank14_56F8::
    ds $10, $00
    assert @ == $5708

SECTION "Remaining ROM 14:5968-59A7", ROMX[$5968], BANK[$14]
RemainingROM_Bank14_5968::
    ; Source-owned structural bytes formerly data/battle/structural/bank14_5968_59a7.dat
    db $00, $00, $00, $69, $ff, $7f, $40, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $f0, $63, $c0, $4a, $60, $25, $00, $00, $1f, $7c, $1f, $7c, $00, $00, $ff, $7f
    assert @ == $59A8

SECTION "Remaining ROM 14:5B13-5B41", ROMX[$5B13], BANK[$14]
RemainingROM_Bank14_5B13::
    ; Source-owned structural bytes formerly data/battle/structural/bank14_5b13_5b41.dat
    db $cd, $f3, $04, $cd, $ce, $34, $cd, $7c, $2d, $af, $e0, $95, $e0, $96, $ef, $10
    db $a8, $68, $ef, $01, $00, $40, $cd, $18, $06, $cd, $02, $0f, $3e, $00, $e0, $83
    db $e0, $4f, $01, $00, $00, $cd, $d4, $0e, $11, $42, $5b, $cd, $63, $0f, $c9
    assert @ == $5B42

SECTION "Remaining ROM 14:5B48-5B4B", ROMX[$5B48], BANK[$14]
RemainingROM_Bank14_5B48::
    db $cd, $67, $2e, $c9
    assert @ == $5B4C

SECTION "Remaining ROM 14:5DE0-5E14", ROMX[$5DE0], BANK[$14]
RemainingROM_Bank14_5DE0::
    ; Source-owned structural bytes formerly data/battle/structural/bank14_5de0_5e14.dat
    db $ea, $50, $cc, $78, $ea, $52, $cc, $79, $ea, $53, $cc, $af, $ea, $54, $cc, $ea
    db $55, $cc, $7a, $ea, $56, $cc, $7b, $ea, $57, $cc, $fa, $50, $cc, $fe, $00, $28
    db $04, $3d, $ea, $50, $cc, $fa, $50, $cc, $06, $06, $cd, $95, $29, $7d, $ea, $50
    db $cc, $cd, $7b, $35, $c9
    assert @ == $5E15

SECTION "Remaining ROM 14:6330-6340", ROMX[$6330], BANK[$14]
RemainingROM_Bank14_6330::
    ds $11, $00
    assert @ == $6341

SECTION "Remaining ROM 14:6561-65B0", ROMX[$6561], BANK[$14]
RemainingROM_Bank14_6561::
    ; Source-owned structural bytes formerly data/battle/structural/bank14_6561_65b0.dat
    db $00, $00, $80, $69, $ff, $7f, $c0, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $80, $7d, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $f0, $63, $c0, $4a, $60, $25, $00, $00, $1f, $7c, $1f, $7c, $00, $00, $ff, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    assert @ == $65B1

SECTION "Remaining ROM 14:6AF1-6B40", ROMX[$6AF1], BANK[$14]
RemainingROM_Bank14_6AF1::
    ; Source-owned structural bytes formerly data/battle/structural/bank14_6af1_6b40.dat
    db $00, $00, $80, $69, $ff, $7f, $c0, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $80, $7d, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $f0, $63, $c0, $4a, $60, $25, $00, $00, $1f, $7c, $1f, $7c, $00, $00, $ff, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    assert @ == $6B41

SECTION "Remaining ROM 14:6D01-73E0", ROMX[$6D01], BANK[$14]
RemainingROM_Bank14_6D01::
    INCBIN "gfx/ui/structural/bank14_ui_tiles_6d01_73e0.2bpp", $0, $6e0
    assert @ == $73E1

SECTION "Remaining ROM 14:77A1-7EFF", ROMX[$77A1], BANK[$14]
RemainingROM_Bank14_77A1::
    db $00, $00, $00, $69, $ff, $7f, $40, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $f0, $63, $c0, $4a, $60, $25, $00, $00, $1f, $7c, $1f, $7c, $00, $00, $ff, $7f
    db $00, $00, $00, $00, $00, $00, $4d, $4d, $01, $02, $03, $04, $05, $06, $07, $08
    db $09, $0a, $4d, $4d, $0b, $0c, $0d, $0e, $4e, $4e, $0f, $10, $11, $12, $4f, $4f
    db $13, $14, $15, $16, $50, $50, $17, $18, $19, $1a, $51, $51, $1b, $1c, $1d, $1e
    db $52, $52, $1f, $20, $21, $22, $52, $52, $23, $24, $25, $26, $53, $53, $27, $28
    db $29, $2a, $54, $54, $27, $28, $29, $2a, $53, $53, $2b, $2c, $2d, $2e, $54, $54
    db $2b, $2c, $2d, $2e, $53, $53, $2f, $30, $31, $32, $54, $54, $2f, $30, $31, $32
    db $53, $53, $33, $34, $35, $36, $54, $54, $33, $34, $35, $36, $55, $55, $37, $38
    db $39, $3a, $56, $56, $37, $38, $39, $3a, $55, $55, $3b, $3c, $3d, $3e, $56, $56
    db $3b, $3c, $3d, $3e, $57, $57, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48
    db $58, $58, $49, $4a, $4b, $4c, $00, $00, $00, $00, $00, $00, $07, $27, $06, $06
    db $06, $06, $05, $05, $05, $05, $05, $05, $03, $23, $06, $06, $06, $06, $03, $23
    db $01, $01, $01, $01, $03, $23, $05, $05, $05, $05, $03, $23, $05, $05, $05, $05
    db $03, $23, $01, $01, $01, $01, $03, $23, $01, $01, $01, $01, $07, $27, $06, $06
    db $06, $06, $03, $23, $01, $01, $01, $01, $03, $23, $05, $05, $05, $05, $03, $23
    db $01, $01, $01, $01, $03, $23, $05, $05, $05, $05, $03, $23, $01, $01, $01, $01
    db $03, $23, $05, $05, $05, $05, $03, $23, $01, $01, $01, $01, $03, $23, $05, $05
    db $05, $05, $07, $27, $01, $01, $01, $01, $07, $27, $05, $05, $05, $05, $07, $27
    db $01, $01, $01, $01, $07, $27, $05, $05, $05, $05, $03, $23, $05, $05, $05, $05
    db $01, $01, $01, $01, $01, $01, $03, $23, $05, $05, $05, $05, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0c, $f7, $08, $f4
    db $02, $f1, $44, $9e, $62, $e4, $58, $9a, $09, $ca, $25, $e5, $30, $df, $d0, $3f
    db $70, $8f, $22, $79, $4e, $27, $9e, $5b, $bc, $53, $fc, $a7, $5e, $bc, $5e, $a4
    db $23, $da, $35, $cf, $18, $e5, $0c, $f3, $03, $fc, $00, $ff, $7a, $3f, $fa, $2f
    db $e4, $5f, $ac, $f7, $18, $af, $30, $ff, $c0, $ff, $00, $ff, $00, $ff, $40, $8e
    db $74, $f2, $2f, $cd, $30, $ce, $05, $f3, $30, $8f, $04, $b8, $00, $ff, $06, $71
    db $9e, $4f, $fc, $b7, $8c, $7f, $b0, $df, $0e, $f3, $22, $1f, $00, $ef, $54, $aa
    db $00, $dc, $2c, $e7, $52, $b6, $14, $b9, $29, $db, $02, $96, $08, $f7, $aa, $5d
    db $c0, $3b, $34, $e7, $ca, $6f, $6a, $bd, $b4, $df, $56, $69, $6a, $f6, $2d, $fb
    db $56, $bd, $53, $e6, $2c, $cf, $12, $dc, $4c, $ba, $00, $ff, $d6, $7f, $b4, $df
    db $6a, $bf, $ca, $ef, $34, $e7, $c8, $f3, $b2, $fd, $00, $ff, $0c, $f7, $08, $f4
    db $02, $f1, $0f, $e4, $10, $cf, $10, $d9, $20, $90, $20, $b0, $30, $df, $d0, $3f
    db $70, $8f, $f8, $27, $0c, $f3, $6c, $9b, $76, $09, $36, $0d, $6c, $b0, $66, $98
    db $33, $dc, $31, $ce, $1c, $e7, $0f, $f1, $03, $fc, $00, $ff, $f6, $3f, $e6, $7b
    db $cc, $ff, $8c, $f7, $38, $ef, $f0, $bf, $c0, $ff, $00, $ff, $0c, $f7, $08, $f4
    db $03, $f1, $0c, $e7, $11, $cf, $12, $d9, $24, $99, $28, $be, $30, $df, $d0, $3f
    db $f0, $8f, $38, $e7, $8c, $f3, $4c, $9b, $26, $99, $96, $7d, $69, $be, $64, $99
    db $32, $d9, $31, $cf, $1c, $e7, $0f, $f1, $03, $fc, $00, $ff, $96, $ff, $26, $9b
    db $4c, $9f, $8c, $f7, $38, $ef, $f0, $bf, $c0, $ff, $00, $ff, $40, $83, $58, $e4
    db $23, $dc, $09, $e6, $16, $f3, $09, $fa, $0b, $fd, $06, $ea, $02, $c1, $1a, $27
    db $c4, $3b, $90, $67, $68, $cf, $90, $5f, $d0, $bf, $a8, $7f, $17, $ea, $0a, $dd
    db $29, $d3, $16, $a7, $48, $af, $20, $df, $00, $ff, $00, $ff, $a8, $f7, $54, $ff
    db $94, $db, $6a, $cf, $12, $e5, $04, $fb, $00, $ff, $00, $ff, $0c, $f7, $08, $ff
    db $20, $d8, $09, $a6, $16, $b3, $2b, $99, $2c, $9d, $24, $9e, $30, $df, $10, $ff
    db $04, $1b, $92, $67, $6a, $cf, $d6, $1b, $36, $bb, $a6, $7b, $25, $9e, $2c, $99
    db $2b, $93, $16, $a7, $08, $ef, $24, $df, $08, $ff, $00, $ff, $a6, $fb, $36, $bb
    db $d6, $1b, $6a, $cf, $10, $e7, $24, $fb, $18, $ff, $00, $ff, $0c, $f7, $08, $f4
    db $23, $d9, $08, $e7, $16, $f3, $0b, $d9, $2c, $9d, $24, $be, $30, $df, $d0, $3f
    db $e4, $9b, $10, $e7, $68, $cf, $d4, $1b, $36, $b9, $a6, $7d, $65, $be, $6c, $99
    db $2b, $d3, $16, $e7, $08, $ef, $26, $db, $02, $ff, $00, $ff, $a6, $ff, $36, $bb
    db $d4, $1f, $68, $cf, $10, $e7, $64, $bb, $40, $bf, $00, $ff, $0c, $f7, $08, $ff
    db $20, $d8, $09, $a6, $16, $b3, $2b, $99, $2d, $98, $36, $8c, $30, $df, $10, $ff
    db $e4, $1b, $92, $67, $6a, $cf, $d6, $1b, $b6, $3b, $6e, $33, $76, $8c, $2d, $d8
    db $0b, $f3, $16, $e7, $09, $ee, $23, $de, $01, $ff, $00, $ff, $6e, $33, $b4, $3f
    db $d0, $1f, $68, $cf, $90, $67, $c4, $7b, $80, $ff, $00, $ff, $0c, $f7, $08, $f7
    db $20, $d8, $13, $ec, $05, $d6, $0a, $d9, $15, $c8, $12, $cc, $30, $df, $10, $ff
    db $04, $1b, $c8, $37, $a4, $6f, $54, $9f, $ac, $17, $4c, $37, $12, $cc, $15, $c8
    db $0a, $d9, $05, $d6, $11, $ef, $20, $df, $00, $ff, $00, $ff, $cc, $37, $ac, $37
    db $54, $9f, $a4, $6f, $88, $f7, $04, $fb, $00, $ff, $00, $ff, $10, $ef, $00, $87
    db $00, $b8, $07, $bf, $40, $bf, $38, $c6, $40, $86, $41, $86, $08, $f7, $1e, $e1
    db $02, $1d, $8a, $ff, $04, $97, $62, $b7, $02, $65, $fa, $05, $42, $85, $7e, $81
    db $7f, $fc, $47, $ff, $2b, $ef, $28, $d7, $38, $ff, $00, $ff, $26, $d9, $26, $d9
    db $fe, $07, $e2, $ff, $d4, $f7, $14, $eb, $1c, $ff, $00, $ff, $10, $ef, $02, $84
    db $00, $bd, $00, $bd, $02, $bc, $03, $be, $01, $ba, $01, $b3, $08, $f7, $5e, $21
    db $02, $bd, $02, $bd, $42, $3d, $c2, $7d, $82, $5d, $b2, $dd, $42, $b1, $40, $bf
    db $3b, $c7, $07, $88, $00, $8f, $07, $ff, $38, $df, $00, $ff, $72, $9f, $02, $ff
    db $dc, $e3, $e0, $11, $00, $f1, $e0, $ff, $1c, $ef, $00, $ff, $10, $ef, $64, $f8
    db $78, $cf, $25, $de, $22, $f1, $51, $f0, $48, $b0, $14, $a8, $08, $f7, $00, $1f
    db $1e, $f1, $c2, $03, $88, $0f, $62, $bf, $82, $7d, $42, $7d, $5a, $a4, $55, $a3
    db $44, $a7, $20, $e7, $28, $cf, $20, $cf, $37, $dc, $00, $ff, $40, $3f, $ae, $11
    db $74, $9b, $3a, $ef, $5a, $bf, $62, $9f, $5e, $bf, $00, $ff, $10, $ef, $00, $80
    db $00, $bf, $00, $bf, $08, $b7, $00, $b7, $00, $b4, $41, $be, $08, $f7, $ae, $59
    db $02, $dd, $02, $fd, $8a, $05, $1a, $ed, $58, $2f, $da, $6d, $2c, $e7, $30, $e0
    db $30, $e4, $58, $f0, $4f, $b8, $40, $bf, $7f, $80, $00, $ff, $00, $ff, $06, $01
    db $3e, $07, $3e, $07, $fc, $3f, $02, $ff, $fe, $ff, $00, $ff, $00, $f7, $00, $f8
    db $03, $f8, $08, $f7, $03, $f6, $22, $94, $05, $ac, $05, $a8, $00, $ef, $00, $1f
    db $e0, $3f, $e0, $3f, $00, $e7, $e2, $41, $c6, $81, $c4, $83, $45, $a8, $0b, $d9
    db $0b, $d1, $03, $dd, $1c, $b3, $1f, $a0, $5f, $ff, $00, $ff, $c4, $83, $8c, $03
    db $8a, $07, $9a, $77, $62, $df, $fe, $03, $fe, $ff, $00, $ff, $00, $ff, $02, $84
    db $41, $be, $46, $b3, $08, $c7, $10, $cf, $2c, $97, $42, $bb, $00, $ff, $de, $61
    db $82, $fd, $12, $cf, $4a, $87, $64, $c3, $32, $e1, $5e, $f3, $41, $fd, $21, $df
    db $12, $ee, $0c, $f5, $08, $fb, $02, $f5, $01, $fe, $00, $ff, $cc, $bf, $00, $7f
    db $48, $ff, $70, $bf, $00, $df, $40, $ef, $80, $ff, $00, $ff, $08, $f7, $08, $f4
    db $03, $f8, $06, $f3, $0c, $e7, $18, $c0, $3f, $80, $20, $9f, $10, $ef, $50, $6f
    db $e0, $3f, $70, $df, $38, $ef, $1c, $07, $fe, $03, $06, $fb, $20, $91, $26, $93
    db $66, $f3, $06, $f3, $06, $83, $7e, $83, $7e, $ff, $00, $ff, $06, $8b, $36, $9b
    db $36, $9f, $30, $9f, $3e, $83, $3e, $83, $3e, $bf, $00, $ff, $00, $ff, $07, $f8
    db $18, $e0, $10, $e0, $20, $c0, $28, $c6, $30, $ce, $20, $de, $00, $ff, $e0, $ff
    db $f8, $1f, $f8, $0f, $fc, $07, $9c, $77, $8c, $7f, $84, $7f, $20, $de, $30, $fd
    db $1c, $e3, $0c, $f8, $16, $f9, $08, $ff, $0c, $fb, $54, $88, $84, $7f, $4c, $bf
    db $38, $ff, $f0, $3f, $68, $ff, $10, $ff, $30, $ff, $ea, $31, $41, $86, $78, $c1
    db $06, $f8, $07, $fe, $56, $81, $48, $87, $70, $cf, $00, $ff, $82, $e1, $5e, $83
    db $60, $7f, $80, $1f, $6a, $81, $12, $e1, $0e, $f3, $00, $ff, $10, $ff, $10, $f2
    db $10, $ef, $06, $f3, $09, $c7, $13, $cf, $2d, $97, $52, $bb, $08, $ff, $38, $4f
    db $08, $f7, $94, $cb, $4a, $85, $64, $c3, $b2, $e1, $5e, $f3, $59, $fd, $1d, $ff
    db $5a, $be, $54, $bd, $29, $db, $10, $f7, $07, $e8, $00, $ff, $cc, $bf, $32, $7d
    db $5a, $fd, $6a, $bd, $94, $db, $08, $ef, $e0, $17, $00, $ff, $ff, $ff, $e1, $fe
    db $e1, $fe, $e1, $fe, $e1, $fe, $f1, $fe, $f9, $fe, $fd, $fe, $ff, $ff, $ed, $f2
    db $ed, $f2, $ed, $f2, $ed, $f2, $fd, $f2, $fd, $fa, $fd, $fe, $ff, $ff, $c3, $e6
    db $c3, $e6, $c3, $e6, $c3, $e6, $c3, $e6, $c3, $e6, $ff, $ff, $ff, $ff, $dd, $e3
    db $dd, $e3, $dd, $e3, $fd, $e3, $fd, $f3, $fd, $fb, $fd, $ff, $ff, $ff, $c0, $e0
    db $c0, $e0, $c0, $e0, $e0, $e0, $f0, $f0, $f8, $f8, $fc, $fc, $ff, $ff, $df, $e0
    db $df, $e0, $df, $e0, $ff, $e0, $ff, $f0, $ff, $f8, $ff, $fc, $ff, $ff, $fe, $e3
    db $fe, $e3, $fe, $e3, $fe, $e3, $fe, $f3, $fe, $fb, $e6, $ff, $ff, $ff, $e0, $f9
    db $e0, $f9, $e0, $f9, $e0, $f9, $f0, $f9, $f8, $f9, $e4, $fd, $ff, $ff, $fc, $e7
    db $fc, $e7, $fc, $e7, $fc, $e7, $fc, $f7, $fc, $ff, $f4, $ff, $ff, $ff, $fa, $e6
    db $fa, $e6, $fa, $e6, $fa, $e6, $fa, $f6, $fa, $fe, $f6, $fe, $ff, $ff, $e7, $fc
    db $e7, $fc, $e7, $fc, $e7, $fc, $f7, $fc, $ff, $fc, $ff, $fc, $ff, $ff, $f4, $fc
    db $f4, $fc, $f4, $fc, $f4, $fc, $f4, $fc, $f4, $fc, $f4, $fc, $00, $00, $00, $69
    db $ff, $7f, $40, $72, $ff, $7f, $b5, $56, $00, $00, $6b, $2d, $ff, $7f, $6c, $03
    db $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00, $10, $42, $6b, $2d
    db $c6, $18, $00, $00, $9f, $53, $df, $02, $00, $00, $74, $01, $5f, $32, $9a, $01
    db $00, $00, $6f, $00, $1f, $00, $80, $02, $ff, $7f, $00, $00, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    assert @ == $7F00

SECTION "Remaining ROM 14:7F0C-7F1F", ROMX[$7F0C], BANK[$14]
RemainingROM_Bank14_7F0C::
    ds $14, $ff
    assert @ == $7F20

SECTION "Remaining ROM 14:7F93-7FFF", ROMX[$7F93], BANK[$14]
RemainingROM_Bank14_7F93::
    ds $6d, $ff
    assert @ == $8000

SECTION "Remaining ROM 15:4501-4512", ROMX[$4501], BANK[$15]
RemainingROM_Bank15_4501::
    ds $12, $00
    assert @ == $4513

SECTION "Remaining ROM 15:4893-4A3A", ROMX[$4893], BANK[$15]
RemainingROM_Bank15_4893::
    ; Source-owned structural bytes formerly data/map/structural/bank15_4893_4a3a.dat
    db $00, $00, $00, $69, $ff, $7f, $40, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $f0, $63, $c0, $4a, $60, $25, $00, $00, $1f, $7c, $1f, $7c, $00, $00, $ff, $7f
    db $cd, $f3, $04, $cd, $ce, $34, $cd, $7c, $2d, $af, $e0, $95, $e0, $96, $ef, $10
    db $a8, $68, $ef, $01, $00, $40, $cd, $18, $06, $cd, $02, $0f, $3e, $00, $e0, $83
    db $e0, $4f, $3e, $00, $ef, $15, $91, $66, $f0, $83, $f5, $3e, $01, $e0, $83, $e0
    db $4f, $11, $6b, $4a, $21, $00, $90, $01, $00, $08, $cd, $50, $3b, $11, $6b, $52
    db $21, $00, $88, $01, $10, $02, $cd, $50, $3b, $f1, $e0, $83, $e0, $4f, $3e, $00
    db $06, $08, $21, $7b, $54, $cd, $bc, $06, $cd, $af, $06, $cd, $f2, $06, $3e, $0a
    db $01, $03, $05, $11, $02, $0a, $26, $49, $ef, $15, $fd, $67, $3e, $0a, $01, $05
    db $05, $11, $02, $0a, $26, $5d, $ef, $15, $fd, $67, $3e, $0a, $01, $07, $05, $11
    db $02, $0a, $26, $71, $ef, $15, $fd, $67, $3e, $0a, $01, $09, $03, $11, $02, $0e
    db $26, $85, $ef, $15, $fd, $67, $01, $0c, $01, $11, $05, $12, $ef, $10, $09, $6a
    db $f0, $83, $f5, $3e, $20, $0e, $00, $06, $15, $11, $6e, $6f, $cd, $e8, $2d, $ea
    db $2c, $cc, $3e, $20, $0e, $00, $06, $15, $11, $7c, $6f, $cd, $e8, $2d, $ea, $2d
    db $cc, $cd, $a0, $49, $f1, $e0, $83, $e0, $4f, $cd, $e3, $49, $c9, $fa, $2e, $cc
    db $06, $10, $cd, $95, $29, $7d, $c6, $30, $4f, $fa, $2e, $cc, $fe, $03, $20, $04
    db $06, $20, $18, $02, $06, $30, $fa, $2c, $cc, $cd, $ae, $2e, $fa, $2e, $cc, $06
    db $10, $cd, $95, $29, $7d, $c6, $30, $4f, $fa, $2e, $cc, $fe, $03, $20, $04, $06
    db $90, $18, $02, $06, $80, $fa, $2d, $cc, $cd, $ae, $2e, $c9, $cd, $67, $2e, $c9
    db $f0, $83, $f5, $3e, $00, $e0, $83, $e0, $4f, $af, $01, $0d, $02, $11, $03, $10
    db $ef, $15, $d3, $6a, $3e, $01, $e0, $83, $e0, $4f, $af, $01, $0d, $02, $11, $03
    db $10, $ef, $15, $d3, $6a, $f1, $e0, $83, $e0, $4f, $f0, $83, $f5, $3e, $00, $e0
    db $83, $e0, $4f, $01, $0d, $02, $cd, $d4, $0e, $e5, $fa, $2e, $cc, $06, $0c, $cd
    db $95, $29, $7c, $47, $7d, $4f, $21, $3b, $4a, $09, $7c, $57, $7d, $5f, $e1, $cd
    db $63, $0f, $f1, $e0, $83, $e0, $4f, $c9
    assert @ == $4A3B

SECTION "Remaining ROM 15:4A6B-54BA", ROMX[$4A6B], BANK[$15]
RemainingROM_Bank15_4A6B::
    INCBIN "gfx/ui/structural/bank15_menu_text_tiles_4a6b_54ba.2bpp", $0, $a50
    assert @ == $54BB

SECTION "Remaining ROM 15:5640-5CCF", ROMX[$5640], BANK[$15]
RemainingROM_Bank15_5640::
    INCBIN "gfx/ui/structural/bank15_menu_text_tiles_5640_5ccf.2bpp", $0, $690
    assert @ == $5CD0

SECTION "Remaining ROM 15:6049-6057", ROMX[$6049], BANK[$15]
RemainingROM_Bank15_6049::
    db $3e, $01, $ea, $68, $dc, $01, $0e, $07, $cd, $37, $66, $cd, $63, $5f, $c9
    assert @ == $6058

SECTION "Remaining ROM 15:61C7-6294", ROMX[$61C7], BANK[$15]
RemainingROM_Bank15_61C7::
RuntimeEntry_Bank15_61C7::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $70
    farcall Gfx_LoadCommonScreenAssets
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $65a1
    ld hl, $90e0
    ld bc, $0550
    farcall BANK_14, Bank14_Entry_3B50
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    ld b, $08
    ld hl, $6561
    ld c, $14
    call Vram_SetFarPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals
    ld a, $0a
    ld bc, $0201
    ld de, $1002
    ld h, $0f
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0104
    ld de, $1204
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $0109
    ld de, $1208
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    farcall MapSave_LoadPreviewGraphics
    call SuspendResume_DrawLeftPreview
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $080c
    ld de, $0202
    xor a
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $080c
    ld de, $0202
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld hl, $6295
    ld bc, $020a
    call TextPrint
    call SuspendResume_DrawRank
    ld de, $c67e
    ld hl, $dc5e
    ld bc, $0007
    call Memcpy
    ld bc, $0206
    ld hl, $dc5e
    call TextPut
    ret
    assert @ == $6295

SECTION "Remaining ROM 15:62C3-64C0", ROMX[$62C3], BANK[$15]
RemainingROM_Bank15_62C3::
    ds $1, $00
RuntimeEntry_Bank15_62C4::
    push hl
    ld hl, $0000
.loc_62C8:
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    ld a, $70
    farcall Gfx_UpdateCommonAnimatedTile
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr z, .loc_62EC
    ldh a, [$ff95]
    add a, b
    ldh [$ff95], a
    ldh a, [$ff96]
    add a, c
    ldh [$ff96], a
    inc hl
    jr .loc_62C8
.loc_62EC:
    pop hl
    ret
RuntimeEntry_Bank15_62EE::
    xor a
    ld [$dc65], a
    ld [$dc66], a
    push hl
    ld hl, $0000
.loc_62F9:
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    ld a, $70
    farcall Gfx_UpdateCommonAnimatedTile
    ld a, [$dc66]
    cp $0a
    jr nz, .loc_6333
    ld a, [$dc65]
    cp $00
    jr z, .loc_6318
    jr .loc_6326
.loc_6318:
    xor a
    ld [$dc66], a
    call SuspendResume_DrawRightPreview
    ld a, $01
    ld [$dc65], a
    jr .loc_6337
.loc_6326:
    xor a
    ld [$dc66], a
    call SuspendResume_DrawLeftPreview
    xor a
    ld [$dc65], a
    jr .loc_6337
.loc_6333:
    inc a
    ld [$dc66], a
.loc_6337:
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr z, .loc_6342
    inc hl
    jr .loc_62F9
.loc_6342:
    pop hl
    ret
RuntimeEntry_Bank15_6344::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, b
    ld [$dc5c], a
    ld a, c
    ld [$dc5d], a
    call RuntimeEntry_Bank15_61C7
    call FadeFromWhite8
    ld de, $001e
    ld bc, $0000
    call RuntimeEntry_Bank15_62C4
    ld de, $0078
    call RuntimeEntry_Bank15_62EE
    call SuspendResume_DrawRightPreview
.loc_636D:
    call Joypad_Update
    call Sprite_Update
    ld a, $70
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 0, a
    jr z, .loc_6386
    ld a, $02
    call Audio_PlaySFX
    jr .loc_6388
.loc_6386:
    jr .loc_636D
.loc_6388:
    call FadeToWhite8
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
RuntimeEntry_Bank15_6391::
    push hl
    ld hl, $0000
.loc_6395:
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    ld a, $40
    farcall Gfx_UpdateCommonAnimatedTile
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr z, .loc_63AF
    inc hl
    jr .loc_6395
.loc_63AF:
    pop hl
    ret
RuntimeEntry_Bank15_63B1::
    xor a
    ld [$dc65], a
    ld [$dc66], a
    push hl
    ld hl, $0000
.loc_63BC:
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    ld a, $40
    farcall Gfx_UpdateCommonAnimatedTile
    ld a, [$dc66]
    cp $06
    jr nz, .loc_6413
    ld a, [$dc65]
    cp $00
    jr z, .loc_63DB
    jr .loc_63F9
.loc_63DB:
    xor a
    ld [$dc66], a
    ld a, [$dc67]
    inc a
    farcall BANK_14, Bank14_Entry_5B79
    ld de, $0203
    ld a, [$dc67]
    inc a
    farcall BANK_14, Bank14_Entry_5E5E
    ld a, $01
    ld [$dc65], a
    jr .loc_6417
.loc_63F9:
    xor a
    ld [$dc66], a
    ld a, [$dc67]
    inc a
    farcall BANK_14, Bank14_Entry_5B79
    ld de, $0203
    xor a
    farcall BANK_14, Bank14_Entry_5E5E
    xor a
    ld [$dc65], a
    jr .loc_6417
.loc_6413:
    inc a
    ld [$dc66], a
.loc_6417:
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr z, .loc_6422
    inc hl
    jr .loc_63BC
.loc_6422:
    pop hl
    ret
RuntimeEntry_Bank15_6424::
    ld d, a
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ld [$dc67], a
    farcall BANK_14, Bank14_Entry_5BFE
    ld de, $c67e
    ld hl, $dc5e
    ld bc, $0007
    call Memcpy
    ld bc, $0224
    ld hl, $dc5e
    call TextPut
    ld hl, $64c1
    call CoordTextPut
    ld a, [$dc67]
    ld bc, $0225
    farcall BANK_14, Bank14_Entry_5F7A
    ld hl, $64c5
    call CoordTextPut
    ld a, [$dc67]
    cp $0c
    jr c, .loc_646C
    ld a, $40
    ldh [$ff96], a
.loc_646C:
    call FadeFromWhite8
    ld de, $001e
    ld bc, $0000
    call RuntimeEntry_Bank15_6391
    ld de, $0078
    ld bc, $0000
    call RuntimeEntry_Bank15_63B1
    ld a, [$dc67]
    inc a
    farcall BANK_14, Bank14_Entry_5B79
    ld de, $0203
    ld a, [$dc67]
    inc a
    farcall BANK_14, Bank14_Entry_5E5E
.loc_6494:
    call Joypad_Update
    call Sprite_Update
    ld a, $40
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 0, a
    jr z, .loc_64AD
    ld a, $02
    call Audio_PlaySFX
    jr .loc_64AF
.loc_64AD:
    jr .loc_6494
.loc_64AF:
    call FadeToWhite8
    farcall MapSave_PrepareFileSelectDisplay
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    assert @ == $64C1

SECTION "Remaining ROM 15:64F6-6589", ROMX[$64F6], BANK[$15]
RemainingROM_Bank15_64F6::
    ; Source-owned structural bytes formerly data/map/structural/bank15_64f6_6589.dat
    db $01, $0c, $01, $11, $05, $12, $ef, $10, $fa, $68, $f0, $83, $f5, $3e, $01, $e0
    db $83, $e0, $4f, $af, $01, $0d, $02, $11, $03, $10, $ef, $15, $d3, $6a, $f1, $e0
    db $83, $e0, $4f, $21, $8a, $65, $01, $0d, $02, $cd, $53, $33, $3e, $01, $ea, $a9
    db $cc, $01, $0f, $07, $cd, $64, $66, $cd, $a2, $05, $cd, $56, $30, $3e, $00, $ef
    db $15, $91, $67, $f0, $92, $cb, $6f, $28, $11, $3e, $01, $cd, $44, $38, $01, $0f
    db $07, $cd, $37, $66, $af, $ea, $a9, $cc, $18, $31, $cb, $67, $28, $12, $3e, $01
    db $cd, $44, $38, $01, $0f, $07, $cd, $64, $66, $3e, $01, $ea, $a9, $cc, $18, $1b
    db $cb, $47, $28, $0a, $3e, $02, $cd, $44, $38, $fa, $a9, $cc, $18, $0f, $cb, $4f
    db $28, $09, $3e, $02, $cd, $44, $38, $3e, $ff, $18, $02, $18, $aa, $f5, $ef, $10
    db $08, $69, $f1, $c9
    assert @ == $658A

SECTION "Remaining ROM 15:659B-662D", ROMX[$659B], BANK[$15]
RemainingROM_Bank15_659B::
    ; Source-owned structural bytes formerly data/map/structural/bank15_659b_662d.dat
    db $01, $0c, $01, $11, $05, $12, $ef, $10, $fa, $68, $f0, $83, $f5, $3e, $01, $e0
    db $83, $e0, $4f, $af, $01, $0d, $02, $11, $03, $10, $ef, $15, $d3, $6a, $f1, $e0
    db $83, $e0, $4f, $21, $2e, $66, $01, $0d, $02, $cd, $53, $33, $af, $ea, $aa, $cc
    db $01, $0f, $07, $cd, $37, $66, $cd, $a2, $05, $cd, $56, $30, $3e, $00, $ef, $15
    db $91, $67, $f0, $92, $cb, $6f, $28, $11, $3e, $01, $cd, $44, $38, $01, $0f, $07
    db $cd, $37, $66, $af, $ea, $aa, $cc, $18, $31, $cb, $67, $28, $12, $3e, $01, $cd
    db $44, $38, $01, $0f, $07, $cd, $64, $66, $3e, $01, $ea, $aa, $cc, $18, $1b, $cb
    db $47, $28, $0a, $3e, $02, $cd, $44, $38, $fa, $aa, $cc, $18, $0f, $cb, $4f, $28
    db $09, $3e, $02, $cd, $44, $38, $3e, $ff, $18, $02, $18, $aa, $f5, $ef, $10, $08
    db $69, $f1, $c9
    assert @ == $662E

SECTION "Remaining ROM 15:6CCA-7023", ROMX[$6CCA], BANK[$15]
RemainingROM_Bank15_6CCA::
    ; Source-owned structural data formerly data/map/structural/bank15_6cca_7023.bin
    db $02, $00, $fc, $01, $00, $f8, $fc, $00, $00, $02, $02, $fc, $01, $00, $fa, $fc
    db $00, $00, $02, $04, $fc, $01, $00, $fc, $fc, $00, $00, $04, $00, $00, $03, $20
    db $00, $f8, $03, $00, $f8, $00, $02, $20, $f8, $f8, $02, $00, $04, $00, $00, $03
    db $21, $00, $f8, $03, $01, $f8, $00, $02, $21, $f8, $f8, $02, $01, $04, $00, $00
    db $03, $22, $00, $f8, $03, $02, $f8, $00, $02, $22, $f8, $f8, $02, $02, $04, $f8
    db $00, $03, $60, $f8, $f8, $03, $40, $00, $00, $02, $60, $00, $f8, $02, $40, $04
    db $f8, $00, $03, $61, $f8, $f8, $03, $41, $00, $00, $02, $61, $00, $f8, $02, $41
    db $04, $f8, $00, $03, $62, $f8, $f8, $03, $42, $00, $00, $02, $62, $00, $f8, $02
    db $42, $02, $fc, $f8, $05, $00, $fc, $f0, $04, $00, $04, $fc, $fa, $05, $00, $fc
    db $f2, $04, $00, $fc, $fa, $05, $00, $fc, $f2, $04, $00, $04, $fc, $fc, $05, $00
    db $fc, $f4, $04, $00, $fc, $fc, $05, $00, $fc, $f4, $04, $00, $02, $fc, $00, $05
    db $20, $fc, $08, $04, $20, $02, $fc, $fe, $05, $20, $fc, $06, $04, $20, $02, $fc
    db $fc, $05, $20, $fc, $04, $04, $20, $01, $fb, $fc, $06, $00, $01, $fb, $fc, $06
    db $01, $01, $fb, $fc, $06, $02, $01, $fc, $fb, $07, $00, $01, $fc, $fb, $07, $01
    db $01, $fc, $fb, $07, $02, $04, $00, $00, $09, $40, $00, $f8, $08, $40, $f8, $00
    db $09, $00, $f8, $f8, $08, $00, $04, $00, $00, $09, $41, $00, $f8, $08, $41, $f8
    db $00, $09, $01, $f8, $f8, $08, $01, $04, $00, $00, $09, $42, $00, $f8, $08, $42
    db $f8, $00, $09, $02, $f8, $f8, $08, $02, $01, $fd, $fc, $06, $40, $01, $fd, $fc
    db $06, $41, $01, $fd, $fc, $06, $42, $01, $fc, $fd, $07, $20, $01, $fc, $fd, $07
    db $21, $01, $fc, $fd, $07, $22, $08, $04, $00, $0b, $60, $04, $08, $0a, $60, $04
    db $f8, $0b, $40, $04, $f0, $0a, $40, $f4, $00, $0b, $20, $f4, $08, $0a, $20, $f4
    db $f8, $0b, $00, $f4, $f0, $0a, $00, $08, $04, $00, $0b, $61, $04, $08, $0a, $61
    db $04, $f8, $0b, $41, $04, $f0, $0a, $41, $f4, $00, $0b, $21, $f4, $08, $0a, $21
    db $f4, $f8, $0b, $01, $f4, $f0, $0a, $01, $08, $04, $00, $0b, $62, $04, $08, $0a
    db $62, $04, $f8, $0b, $42, $04, $f0, $0a, $42, $f4, $00, $0b, $22, $f4, $08, $0a
    db $22, $f4, $f8, $0b, $02, $f4, $f0, $0a, $02, $04, $00, $f8, $09, $60, $00, $00
    db $08, $60, $f8, $f8, $09, $20, $f8, $00, $08, $20, $04, $00, $f8, $09, $61, $00
    db $00, $08, $61, $f8, $f8, $09, $21, $f8, $00, $08, $21, $04, $00, $f8, $09, $62
    db $00, $00, $08, $62, $f8, $f8, $09, $22, $f8, $00, $08, $22, $04, $01, $01, $0a
    db $60, $f7, $01, $0a, $20, $01, $f7, $0a, $40, $f7, $f7, $0a, $00, $04, $01, $01
    db $0a, $61, $f7, $01, $0a, $21, $01, $f7, $0a, $41, $f7, $f7, $0a, $01, $04, $01
    db $01, $0a, $64, $f7, $01, $0a, $24, $01, $f7, $0a, $44, $f7, $f7, $0a, $04, $0a
    db $f4, $08, $0d, $40, $f4, $00, $0d, $40, $f4, $f8, $0d, $40, $f4, $f0, $0d, $40
    db $04, $08, $0d, $00, $04, $00, $0d, $00, $04, $f8, $0d, $00, $04, $f0, $0d, $00
    db $fc, $10, $0c, $20, $fc, $e8, $0c, $00, $0a, $f4, $08, $0d, $41, $f4, $00, $0d
    db $41, $f4, $f8, $0d, $41, $f4, $f0, $0d, $41, $04, $08, $0d, $01, $04, $00, $0d
    db $01, $04, $f8, $0d, $01, $04, $f0, $0d, $01, $fc, $10, $0c, $21, $fc, $e8, $0c
    db $01, $0a, $f4, $08, $0d, $44, $f4, $00, $0d, $44, $f4, $f8, $0d, $44, $f4, $f0
    db $0d, $44, $04, $08, $0d, $04, $04, $00, $0d, $04, $04, $f8, $0d, $04, $04, $f0
    db $0d, $04, $fc, $10, $0c, $24, $fc, $e8, $0c, $04, $ca, $6c, $0c, $d3, $6c, $0c
    db $dc, $6c, $0c, $d3, $6c, $0c, $00, $00, $e5, $6c, $0c, $f6, $6c, $0c, $e5, $6c
    db $0c, $07, $6d, $0c, $00, $00, $18, $6d, $0c, $29, $6d, $0c, $18, $6d, $0c, $3a
    db $6d, $0c, $00, $00, $4b, $6d, $0c, $54, $6d, $0c, $65, $6d, $0c, $54, $6d, $0c
    db $00, $00, $76, $6d, $0c, $7f, $6d, $0c, $88, $6d, $0c, $7f, $6d, $0c, $00, $00
    db $91, $6d, $0c, $96, $6d, $0c, $91, $6d, $0c, $9b, $6d, $0c, $00, $00, $a0, $6d
    db $0c, $a5, $6d, $0c, $a0, $6d, $0c, $aa, $6d, $0c, $00, $00, $af, $6d, $0c, $c0
    db $6d, $0c, $af, $6d, $0c, $d1, $6d, $0c, $00, $00, $e2, $6d, $0c, $e7, $6d, $0c
    db $e2, $6d, $0c, $ec, $6d, $0c, $00, $00, $f1, $6d, $0c, $f6, $6d, $0c, $f1, $6d
    db $0c, $fb, $6d, $0c, $00, $00, $00, $6e, $0c, $21, $6e, $0c, $00, $6e, $0c, $42
    db $6e, $0c, $00, $00, $63, $6e, $0c, $74, $6e, $0c, $63, $6e, $0c, $85, $6e, $0c
    db $00, $00, $a7, $6e, $0c, $b8, $6e, $0c, $a7, $6e, $0c, $96, $6e, $0c, $00, $00
    db $f2, $6e, $0c, $1b, $6f, $0c, $f2, $6e, $0c, $c9, $6e, $0c, $00, $00, $44, $6f
    db $52, $6f, $60, $6f, $6e, $6f, $7c, $6f, $8a, $6f, $98, $6f, $a6, $6f, $b4, $6f
    db $c2, $6f, $d0, $6f, $de, $6f, $ec, $6f, $fa, $6f
    assert @ == $7024

SECTION "Remaining ROM 15:7124-712B", ROMX[$7124], BANK[$15]
RemainingROM_Bank15_7124::
    db $00, $00, $16, $00, $00, $00, $00, $00
    assert @ == $712C

SECTION "Remaining ROM 15:7A1C-7FFF", ROMX[$7A1C], BANK[$15]
RemainingROM_Bank15_7A1C::
    ds $5e4, $ff
    assert @ == $8000

SECTION "Remaining ROM 16:5F81-5FC0", ROMX[$5F81], BANK[$16]
RemainingROM_Bank16_5F81::
    db $52, $4a, $00, $00, $5d, $36, $7f, $14, $52, $4a, $00, $00, $18, $63, $ad, $35
    db $ff, $7f, $00, $00, $10, $7c, $1f, $7c, $6e, $62, $e7, $5d, $68, $15, $00, $00
    db $1a, $4f, $00, $00, $18, $63, $ad, $35, $f0, $03, $e0, $03, $e0, $43, $e0, $7f
    db $00, $7e, $00, $7c, $10, $7c, $1f, $7c, $1f, $40, $10, $42, $18, $63, $ff, $7f
    assert @ == $5FC1

SECTION "Remaining ROM 16:6E51-6E90", ROMX[$6E51], BANK[$16]
RemainingROM_Bank16_6E51::
    db $a6, $59, $00, $00, $5d, $36, $9c, $00, $a6, $59, $00, $00, $18, $63, $ad, $35
    db $ff, $7f, $00, $00, $10, $7c, $1f, $7c, $6e, $62, $e7, $5d, $68, $15, $00, $00
    db $1a, $4f, $00, $00, $18, $63, $ad, $35, $f0, $03, $e0, $03, $e0, $43, $e0, $7f
    db $00, $7e, $00, $7c, $10, $7c, $1f, $7c, $1f, $40, $10, $42, $18, $63, $ff, $7f
    assert @ == $6E91

SECTION "Remaining ROM 16:7B21-7B60", ROMX[$7B21], BANK[$16]
RemainingROM_Bank16_7B21::
    db $6e, $62, $00, $00, $5d, $36, $9c, $00, $6e, $62, $00, $00, $18, $63, $ad, $35
    db $ff, $7f, $00, $00, $10, $7c, $1f, $7c, $6e, $62, $e7, $5d, $68, $15, $00, $00
    db $1a, $4f, $00, $00, $18, $63, $ad, $35, $f0, $03, $e0, $03, $e0, $43, $e0, $7f
    db $00, $7e, $00, $7c, $10, $7c, $1f, $7c, $1f, $40, $10, $42, $18, $63, $ff, $7f
    assert @ == $7B61

SECTION "Remaining ROM 16:7D21-7FFF", ROMX[$7D21], BANK[$16]
RemainingROM_Bank16_7D21::
    db $3f, $18, $3f, $1f, $1f, $0d, $1f, $0d, $0f, $00, $0e, $07, $07, $03, $03, $00
    db $80, $7f, $ff, $ff, $ff, $56, $ff, $56, $ff, $02, $17, $ec, $ff, $ee, $fe, $00
    db $38, $f0, $fc, $f0, $fc, $20, $f4, $a8, $ff, $b8, $fc, $20, $f0, $00, $00, $00
    db $6e, $62, $00, $00, $5d, $36, $9c, $00, $6e, $62, $00, $00, $18, $63, $ad, $35
    db $ff, $7f, $00, $00, $10, $7c, $1f, $7c, $6e, $62, $e7, $5d, $68, $15, $00, $00
    db $1a, $4f, $00, $00, $18, $63, $ad, $35, $f0, $03, $e0, $03, $e0, $43, $e0, $7f
    db $00, $7e, $00, $7c, $10, $7c, $1f, $7c, $1f, $40, $10, $42, $18, $63, $ff, $7f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    assert @ == $8000

SECTION "Remaining ROM 17:449F-44A0", ROMX[$449F], BANK[$17]
RemainingROM_Bank17_449F::
    db $3b, $c9
    assert @ == $44A1

SECTION "Remaining ROM 17:4754-4754", ROMX[$4754], BANK[$17]
RemainingROM_Bank17_4754::
    db $c9
    assert @ == $4755

SECTION "Remaining ROM 17:4CEB-4D52", ROMX[$4CEB], BANK[$17]
RemainingROM_Bank17_4CEB::
    db $10, $07, $10, $07, $10, $08, $10, $03, $10, $07, $10, $07, $10, $07, $10, $07
    db $10, $07, $10, $07, $10, $07, $10, $07, $10, $07, $10, $07, $10, $07, $10, $07
    db $10, $07, $10, $07, $10, $07, $10, $07, $10, $07, $10, $07, $10, $07, $10, $07
    db $10, $07, $10, $07, $10, $07, $10, $07, $10, $07, $10, $07, $10, $07, $10, $07
    db $10, $07, $10, $07, $10, $07, $3a, $18, $28, $20, $38, $20, $40, $20, $10, $07
    db $10, $07, $10, $07, $10, $07, $10, $07, $30, $0a, $30, $0a, $30, $10, $20, $10
    db $30, $07, $30, $07, $2a, $10, $20, $10
    assert @ == $4D53

SECTION "Remaining ROM 17:6BF3-6F02", ROMX[$6BF3], BANK[$17]
RemainingROM_Bank17_6BF3::
    db $7c, $83, $7c, $83, $7c, $83, $7c, $83, $7c, $83, $7f, $80, $3f, $c0, $00, $ff
    db $3e, $c1, $3e, $c1, $3e, $c1, $3e, $c1, $3e, $c1, $fe, $01, $fc, $03, $00, $ff
    db $00, $ff, $00, $ff, $03, $fc, $1f, $e0, $1f, $e0, $07, $f8, $07, $f8, $07, $f8
    db $00, $ff, $00, $ff, $c0, $3f, $c0, $3f, $c0, $3f, $c0, $3f, $c0, $3f, $c0, $3f
    db $07, $f8, $07, $f8, $07, $f8, $07, $f8, $07, $f8, $07, $f8, $07, $f8, $00, $ff
    db $c0, $3f, $c0, $3f, $c0, $3f, $c0, $3f, $c0, $3f, $c0, $3f, $c0, $3f, $00, $ff
    db $00, $ff, $00, $ff, $3f, $c0, $7f, $80, $40, $bf, $00, $ff, $1f, $e0, $7f, $80
    db $00, $ff, $00, $ff, $fc, $03, $fe, $01, $3e, $c1, $3e, $c1, $fe, $01, $fe, $01
    db $7f, $80, $7f, $80, $7c, $83, $7c, $83, $7c, $83, $7f, $80, $7f, $80, $00, $ff
    db $fe, $01, $fc, $03, $00, $ff, $00, $ff, $02, $fd, $fe, $01, $fe, $01, $00, $ff
    db $00, $ff, $00, $ff, $3f, $c0, $7f, $80, $40, $bf, $00, $ff, $00, $ff, $0f, $f0
    db $00, $ff, $00, $ff, $fc, $03, $fe, $01, $3e, $c1, $3e, $c1, $3e, $c1, $fc, $03
    db $0f, $f0, $00, $ff, $00, $ff, $00, $ff, $40, $bf, $7f, $80, $3f, $c0, $00, $ff
    db $fc, $03, $3e, $c1, $3e, $c1, $3e, $c1, $3e, $c1, $fe, $01, $fc, $03, $00, $ff
    db $00, $ff, $00, $ff, $03, $fc, $07, $f8, $0e, $f1, $1c, $e3, $38, $c7, $70, $8f
    db $00, $ff, $00, $ff, $f8, $07, $f8, $07, $f8, $07, $f8, $07, $f8, $07, $f8, $07
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $f8, $07, $f8, $07, $f8, $07, $00, $ff
    db $00, $ff, $00, $ff, $7f, $80, $7f, $80, $7e, $81, $7e, $81, $7f, $80, $7f, $80
    db $00, $ff, $00, $ff, $fe, $01, $fe, $01, $00, $ff, $00, $ff, $fc, $03, $fe, $01
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $40, $bf, $7f, $80, $7f, $80, $00, $ff
    db $3e, $c1, $3e, $c1, $3e, $c1, $3e, $c1, $3e, $c1, $fe, $01, $fc, $03, $00, $ff
    db $00, $ff, $00, $ff, $3f, $c0, $7f, $80, $7c, $83, $7c, $83, $7f, $80, $7f, $80
    db $00, $ff, $00, $ff, $fe, $01, $fe, $01, $02, $fd, $00, $ff, $fc, $03, $fe, $01
    db $7c, $83, $7c, $83, $7c, $83, $7c, $83, $7c, $83, $7f, $80, $3f, $c0, $00, $ff
    db $3e, $c1, $3e, $c1, $3e, $c1, $3e, $c1, $3e, $c1, $fe, $01, $fc, $03, $00, $ff
    db $00, $ff, $00, $ff, $7f, $80, $7f, $80, $00, $ff, $00, $ff, $01, $fe, $03, $fc
    db $00, $ff, $00, $ff, $fc, $03, $fc, $03, $7c, $83, $f8, $07, $f0, $0f, $e0, $1f
    db $03, $fc, $07, $f8, $0f, $f0, $0f, $f0, $1f, $e0, $1f, $e0, $3f, $c0, $00, $ff
    db $e0, $1f, $c0, $3f, $80, $7f, $80, $7f, $80, $7f, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $3f, $c0, $7f, $80, $7c, $83, $7c, $83, $7c, $83, $3f, $c0
    db $00, $ff, $00, $ff, $fc, $03, $fe, $01, $3e, $c1, $3e, $c1, $3e, $c1, $fc, $03
    db $3f, $c0, $7c, $83, $7c, $83, $7c, $83, $7c, $83, $7f, $80, $3f, $c0, $00, $ff
    db $fc, $03, $3e, $c1, $3e, $c1, $3e, $c1, $3e, $c1, $fe, $01, $fc, $03, $00, $ff
    db $00, $ff, $00, $ff, $3f, $c0, $7f, $80, $7c, $83, $7c, $83, $7c, $83, $7c, $83
    db $00, $ff, $00, $ff, $fc, $03, $fe, $01, $3e, $c1, $3e, $c1, $3e, $c1, $3e, $c1
    db $7f, $80, $3f, $c0, $00, $ff, $00, $ff, $00, $ff, $3f, $c0, $3f, $c0, $00, $ff
    db $fe, $01, $fe, $01, $3e, $c1, $3e, $c1, $3e, $c1, $fe, $01, $fc, $03, $00, $ff
    db $00, $ff, $00, $ff, $39, $c6, $fb, $04, $fb, $04, $7b, $84, $7b, $84, $7b, $84
    db $00, $ff, $00, $ff, $fe, $01, $ff, $00, $cf, $30, $cf, $30, $cf, $30, $cf, $30
    db $7b, $84, $7b, $84, $7b, $84, $7b, $84, $7b, $84, $7b, $84, $79, $86, $00, $ff
    db $cf, $30, $cf, $30, $cf, $30, $cf, $30, $cf, $30, $ff, $00, $fe, $01, $00, $ff
    db $ff, $00, $ff, $7f, $c0, $7f, $c0, $7f, $cf, $70, $cf, $70, $cf, $70, $cf, $71
    db $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $ff
    db $cf, $71, $cf, $71, $cf, $71, $cf, $71, $cf, $71, $cf, $71, $cf, $71, $cf, $71
    db $00, $00, $00, $69, $ff, $7f, $00, $00, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $f0, $63, $c0, $4a, $60, $25, $00, $00, $1f, $7c, $1f, $7c, $1f, $7c, $1f, $7c
    assert @ == $6F03

SECTION "Remaining ROM 19:55EE-5679", ROMX[$55EE], BANK[$19]
RemainingROM_Bank19_55EE::
    ; Source-owned structural bytes formerly data/network/structural/bank19_55ee_5635.dat
    db $fe, $03, $28, $02, $18, $1c, $3e, $0e, $cd, $8d, $05, $cd, $93, $05, $fa, $5c
    db $bb, $fe, $00, $28, $03, $18, $06, $c9, $cd, $9b, $05, $af, $c9, $cd, $9b, $05
    db $37, $c9, $af, $c9, $fe, $02, $28, $03, $18, $15, $c9, $ef, $26, $8e, $56, $fe
    db $00, $28, $02, $18, $0a, $3e, $03, $cd, $44, $38, $cd, $57, $56, $37, $c9, $fa
    db $32, $da, $ef, $15, $d0, $5c, $af, $c9
RuntimeEntry_Bank19_5636::
    cp $01
    jr z, .loc_5641
    cp $02
    jr z, .loc_5641
    jr .loc_5655
    db $c9
.loc_5641:
    farcall BANK_26, Bank26_Entry_568E
    cp $00
    jr z, .loc_564B
    jr .loc_5655
.loc_564B:
    ld a, SFX_ERROR
    call Audio_PlaySFX
    call .loc_5657
    scf
    ret
.loc_5655:
    xor a
    ret
.loc_5657:
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $020d
    ld de, $1003
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $020d
    ld hl, $567a
    call TextPrint
    ret
    assert @ == $567A

SECTION "Remaining ROM 1A:4437-44C5", ROMX[$4437], BANK[$1A]
RemainingROM_Bank1A_4437::
    ; Source-owned structural bytes formerly data/sprite/structural/bank1a_4437_44c5.dat
    db $e5, $f0, $82, $f5, $3e, $04, $e0, $82, $e0, $70, $3e, $01, $cd, $eb, $44, $fa
    db $a0, $c4, $fe, $00, $20, $0a, $fa, $11, $d3, $6f, $fa, $12, $d3, $67, $18, $08
    db $fa, $13, $d3, $6f, $fa, $14, $d3, $67, $fa, $17, $d3, $4f, $3e, $08, $06, $08
    db $cd, $d9, $06, $cd, $f2, $06, $fa, $0f, $d3, $5f, $fa, $10, $d3, $57, $fa, $15
    db $d3, $4f, $fa, $16, $d3, $47, $3e, $00, $e0, $83, $e0, $4f, $21, $00, $80, $fa
    db $17, $d3, $ea, $a3, $c4, $cd, $50, $01, $3e, $00, $e0, $83, $e0, $4f, $af, $ea
    db $cc, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $78
    db $ea, $d3, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $06, $1d, $0e
    db $00, $11, $a7, $4d, $e1, $ef, $17, $63, $40, $f1, $e0, $82, $e0, $70, $c9
    assert @ == $44C6

SECTION "Remaining ROM 1A:6A2B-7FFF", ROMX[$6A2B], BANK[$1A]
RemainingROM_Bank1A_6A2B::
    ; Source-owned structural data formerly data/sprite/structural/bank1a_6a2b_6fba.bin
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $15, $16, $17, $18, $02, $02, $02, $2b, $2c, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $19, $1a, $02, $1b, $1c, $1d, $02, $02, $02, $02, $02, $02, $02, $28
    db $29, $2a, $02, $02, $02, $02, $02, $1e, $1f, $02, $02, $02, $02, $02, $02, $02
    db $1e, $1f, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $20, $21, $22, $23
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $03, $02, $02, $28, $29, $2a, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $24, $25, $26, $27
    db $02, $02, $02, $02, $02, $02, $02, $02, $1b, $1c, $1d, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $0e, $0f, $10, $06, $07, $08, $09, $0a, $11, $12, $13, $14, $05, $05, $0b, $0c
    db $0d, $05, $05, $05, $05, $05, $05, $0b, $0c, $0d, $05, $11, $12, $13, $14, $05
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $03, $03, $03, $03, $01, $01, $01, $03, $03, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $03, $03, $01, $03, $03, $03, $01, $01, $01, $01, $01, $01, $01, $03
    db $03, $03, $01, $01, $01, $01, $01, $03, $03, $01, $01, $01, $01, $01, $01, $01
    db $03, $03, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $03, $03, $03, $03
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $03, $03, $03, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $03, $03, $03, $03
    db $01, $01, $01, $01, $01, $01, $01, $01, $03, $03, $03, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $02, $02
    db $02, $01, $01, $01, $01, $01, $01, $02, $02, $02, $01, $02, $02, $02, $02, $01
    ds $20, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $ff, $ff, $00, $ff, $00, $00, $ff, $00
    ds $1d, $ff
    db $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $ff, $00, $ff, $00, $ff, $00, $ff
    ds $1c, $00
    db $03, $00, $1f, $00, $ff, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $7e, $00
    db $ff, $00, $ff, $01, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $0f
    db $90, $3f, $c0, $ff, $0c, $00, $00, $00, $00, $00, $00, $70, $88, $fe, $01, $ff
    db $00, $ff, $38, $ff, $7f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $e0, $10, $f8, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01
    db $02, $03, $0c, $0f, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0
    db $20, $f0, $09, $fc, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $60, $00, $f0, $00, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $04, $00, $0d, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02
    db $10, $16, $a9, $17, $e8, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $00
    db $94, $84, $52, $cc, $33, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $02, $24, $0a, $35, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10
    db $84, $11, $ac, $b9, $46, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $44, $40, $b5, $64, $99, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $28, $00, $e8, $ff, $ff, $ff, $ff, $fe, $ff, $f8, $ff, $e6, $f8, $cc
    db $f0, $f3, $fc, $fc, $ff, $ff, $ff, $f0, $ff, $0f, $f0, $f0, $00, $18, $00, $0c
    db $00, $fc, $00, $3f, $c0, $ff, $ff, $1f, $ff, $e1, $1f, $1c, $03, $03, $00, $61
    db $00, $f3, $00, $9c, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f, $ff, $ef
    db $1f, $87, $7f, $3f, $ff, $c7, $f8, $f8, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $f6, $ff, $f1, $fe, $ee, $f0, $d0, $e0, $40, $80, $b8
    db $c0, $e7, $f8, $f8, $ff, $3f, $ff, $c4, $3f, $3b, $04, $04, $00, $00, $00, $8e
    db $00, $73, $8e, $8f, $ff, $ff, $ff, $3f, $ff, $c3, $3f, $3d, $03, $02, $01, $7d
    db $03, $83, $7f, $ff, $ff, $fa, $ff, $e5, $fa, $ca, $f0, $d8, $e0, $b0, $c0, $cc
    db $f0, $f3, $fc, $fc, $ff, $1f, $ff, $af, $5f, $53, $0f, $0d, $03, $4e, $01, $b3
    db $4f, $4f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $fe, $ff, $f1, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0, $ff, $de
    db $e1, $33, $c0, $e0, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e1, $ff, $4e
    db $f1, $bb, $40, $f0, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $0f
    db $ff, $f7, $0f, $3b, $07, $ff, $f0, $b8, $c0, $c6, $f8, $f9, $fe, $fe, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $02, $00, $07, $00, $ff, $00, $e7, $18, $38
    db $ff, $ff, $ff, $ff, $ff, $18, $00, $3c, $00, $ef, $10, $93, $7c, $7c, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $05, $03, $1c, $03, $f7, $0f, $cf, $3f, $3f, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f3, $ff, $e1, $fe, $01, $ff, $f0
    db $ff, $ff, $ff, $ff, $ff, $8f, $ff, $27, $ff, $10, $ef, $07, $f8, $00, $ff, $70
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $4f, $ff, $81, $7f, $0f, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f1, $ff, $e4, $fb, $0f, $f0, $80
    db $ff, $e0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $0f, $ff, $20, $df, $07
    db $ff, $ff, $ff, $ff, $ff, $00, $00, $d6, $5a, $73, $4e, $10, $42, $f5, $7f, $f0
    db $7f, $ea, $7f, $e0, $7f, $f5, $7f, $46, $3f, $ae, $53, $a0, $2e, $ff, $7f, $f8
    db $7f, $f1, $7f, $e0, $7f, $00, $7c, $00, $00, $1f, $02, $ff, $03, $f0, $03, $e0
    db $03, $e0, $43, $e0, $7f, $00, $7e, $00, $7c, $10, $7c, $1f, $7c, $1f, $40, $10
    db $42, $18, $63, $ff, $7f
RuntimeEntry_Bank1A_6FBB::
    farcall CampaignEnding_ResetDisplayState
    farcall AdvancedSprite_Reset
    ret
    ; Source-owned structural bytes formerly data/sprite/structural/bank1a_6fc4_6fe5.dat
    db $af, $ea, $cc, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4
    db $3e, $c8, $ea, $d4, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $c3
    db $8a, $02
RuntimeEntry_Bank1A_6FE6::
    ld a, $01
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $17
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $bb
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    xor a
    ld [$c4ce], a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $64
    ld [$c4d4], a
    ld a, $6f
    ld [$c4d5], a
    ld a, $c4
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $00
    ld hl, $b070
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $bb
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    xor a
    ld [$c4ce], a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $64
    ld [$c4d4], a
    ld a, $6f
    ld [$c4d5], a
    ld a, $c4
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $00
    ld hl, $e070
    farcall AdvancedSprite_Add
    call Sprite_Update
    ret
    ; Source-owned structural bytes formerly data/sprite/structural/bank1a_7071_70ce.dat
    db $af, $ea, $cc, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $af, $ea, $d3
    db $c4, $3e, $23, $ea, $d4, $c4, $3e, $62, $ea, $d5, $c4, $3e, $cb, $ea, $d6, $c4
    db $3e, $13, $ea, $d7, $c4, $3e, $a7, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8
    db $2e, $c3, $8a, $02, $3e, $ff, $ea, $cc, $c4, $3e, $80, $ea, $cd, $c4, $af, $ea
    db $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $af, $ea, $d3, $c4, $3e, $78, $ea, $d4
    db $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $c3, $8a, $02
RuntimeEntry_Bank1A_70CF::
    ld a, $01
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $17
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $01
    ld [$c4a0], a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $13
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld hl, $46e1
    ld c, $20
    ld a, $08
    ld b, $08
    call Vram_SetFarPals
    call Vram_ApplyPals
    ld a, $a8
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4ce], a
    ld [$c4d1], a
    ld [$c4d2], a
    ld a, $01
    ld [$c4d3], a
    ld a, $a4
    ld [$c4d4], a
    ld a, $70
    ld [$c4d5], a
    ld a, $71
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $80
    ld hl, $1470
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $bc
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    ld a, $80
    ld [$c4cd], a
    xor a
    ld [$c4ce], a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, $01
    ld [$c4d3], a
    ld a, $18
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld c, $00
    ld hl, $b070
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $bc
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    ld a, $80
    ld [$c4cd], a
    xor a
    ld [$c4ce], a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    ld a, $01
    ld [$c4d3], a
    ld a, $5e
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld c, $00
    ld hl, $d070
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $aa
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld [$c4d2], a
    ld a, $01
    ld [$c4d3], a
    ld a, $e0
    ld [$c4d4], a
    ld a, $70
    ld [$c4d5], a
    ld a, $a5
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $80
    ld hl, $1670
    farcall AdvancedSprite_Add
    call Sprite_Update
    ret
    ; Source-owned structural bytes formerly data/sprite/structural/bank1a_71f5_725b.dat
    db $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4
    db $ea, $d3, $c4, $3e, $c8, $ea, $d4, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4, $ea
    db $d7, $c4, $fa, $d0, $c4, $cd, $11, $2f, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea
    db $cd, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $5d
    db $ea, $d4, $c4, $af, $3e, $71, $ea, $d5, $c4, $3e, $f5, $ea, $d6, $c4, $3e, $1a
    db $ea, $d7, $c4, $3e, $c8, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $3e
    db $7b, $cd, $44, $38, $c3, $8a, $02
RuntimeEntry_Bank1A_725C::
    xor a
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $19
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $c7
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    ld a, $80
    ld [$c4cd], a
    xor a
    ld [$c4ce], a
    ld [$c4d1], a
    ld [$c4d2], a
    ld [$c4d3], a
    ld a, $d2
    ld [$c4d4], a
    xor a
    ld a, $72
    ld [$c4d5], a
    ld a, $20
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $00
    ld hl, $c070
    farcall AdvancedSprite_Add
    ld a, $7a
    call Audio_PlaySFX
    call Sprite_Update
    ret
    ; Source-owned structural bytes formerly data/sprite/structural/bank1a_72b3_72d9.dat
    db $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4
    db $3e, $02, $ea, $d3, $c4, $3e, $94, $ea, $d4, $c4, $af, $ea, $d5, $c4, $ea, $d6
    db $c4, $ea, $d7, $c4, $c3, $8a, $02
RuntimeEntry_Bank1A_72DA::
    ld a, $01
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $13
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $01
    ld [$c4a0], a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $18
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld hl, $6f4b
    ld c, $20
    ld a, $08
    ld b, $08
    call Vram_SetFarPals
    call Vram_ApplyPals
    ld a, $a9
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    ld a, $80
    ld [$c4cd], a
    xor a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld [$c4d2], a
    ld [$c4d3], a
    ld a, $96
    ld [$c4d4], a
    ld a, $72
    ld [$c4d5], a
    ld a, $b3
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $00
    ld hl, $a060
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $bd
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld a, $b4
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $22
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld a, $7c
    ld [$c4db], a
    ld c, $80
    ld hl, $8040
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $bd
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld a, $e6
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $22
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld a, $7c
    ld [$c4db], a
    ld c, $80
    ld hl, $4090
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $bd
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld a, $01
    ld [$c4d1], a
    ld a, $04
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $22
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld a, $7c
    ld [$c4db], a
    ld c, $80
    ld hl, $8858
    farcall AdvancedSprite_Add
    call Sprite_Update
    ret
    ; Source-owned structural bytes formerly data/sprite/structural/bank1a_7411_74e8.dat
    db $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4
    db $ea, $d3, $c4, $3e, $14, $ea, $d4, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4, $ea
    db $d7, $c4, $3e, $be, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a
    db $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2
    db $c4, $ea, $d3, $c4, $3e, $22, $ea, $d4, $c4, $3e, $74, $ea, $d5, $c4, $3e, $11
    db $ea, $d6, $c4, $3e, $1a, $ea, $d7, $c4, $3e, $bd, $ef, $1a, $10, $45, $fa, $d0
    db $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce
    db $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $42, $ea, $d4, $c4, $3e
    db $74, $ea, $d5, $c4, $3e, $42, $ea, $d6, $c4, $3e, $1a, $ea, $d7, $c4, $3e, $c4
    db $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $3e, $7f, $cd, $44, $38, $c3
    db $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea
    db $d2, $c4, $ea, $d3, $c4, $3e, $78, $ea, $d4, $c4, $3e, $74, $ea, $d5, $c4, $3e
    db $78, $ea, $d6, $c4, $3e, $1a, $ea, $d7, $c4, $3e, $c0, $ef, $1a, $10, $45, $fa
    db $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02
RuntimeEntry_Bank1A_74E9::
    ld a, $01
    ld [$c4a0], a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $18
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld hl, $6f4b
    ld c, $20
    ld a, $08
    ld b, $08
    call Vram_SetFarPals
    call Vram_ApplyPals
    ld a, $c5
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld [$c4d2], a
    ld [$c4d3], a
    ld a, $58
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld a, $7d
    ld [$c4db], a
    ld c, $80
    ld hl, $544a
    farcall AdvancedSprite_Add
    call Sprite_Update
    xor a
    ld [$c4db], a
    ld a, $be
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld [$c4d2], a
    ld [$c4d3], a
    ld a, $58
    ld [$c4d4], a
    ld a, $62
    ld [$c4d5], a
    ld a, $56
    ld [$c4d6], a
    ld a, $13
    ld [$c4d7], a
    ld c, $80
    ld hl, $8060
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $c6
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld a, $b2
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $94
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld c, $80
    ld hl, $7048
    farcall AdvancedSprite_Add
    call Sprite_Update
    ret
RuntimeEntry_Bank1A_75C3::
    xor a
    ld [$c4a0], a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $12
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $a6
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld [$c4d2], a
    ld a, $01
    ld [$c4d3], a
    ld a, $e0
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld c, $80
    ld hl, $3890
    farcall AdvancedSprite_Add
    call Sprite_Update
    ret
RuntimeEntry_Bank1A_7610::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, h
    ld [$c021], a
    ld a, l
    ld [$c022], a
    ld a, [$c023]
    cp $14
    jp c, .loc_766C
    xor a
    ld [$c023], a
    ld a, [$c024]
    inc a
    ld [$c024], a
    ld a, [$c024]
    cp $03
    jp c, .loc_7640
    xor a
    ld [$c024], a
.loc_7640:
    ld a, [$c024]
    ld b, $30
    call MultiplyAByB
    ld a, h
    ld b, a
    ld a, l
    ld c, a
    ld hl, $6616
    add hl, bc
    ld a, h
    ld d, a
    ld a, l
    ld e, a
    push de
    ld a, $20
    ld b, $10
    call MultiplyAByB
    ld a, h
    ld b, a
    ld a, l
    ld c, a
    ld hl, $9000
    add hl, bc
    pop de
    ld bc, $0030
    farcall BANK_21, Bank21_Entry_3B59
.loc_766C:
    ld a, [$c023]
    inc a
    ld [$c023], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ret
RuntimeEntry_Bank1A_7679::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, h
    ld [$c021], a
    ld a, l
    ld [$c022], a
    ld a, [$c023]
    cp $14
    jp c, .loc_76D5
    xor a
    ld [$c023], a
    ld a, [$c024]
    inc a
    ld [$c024], a
    ld a, [$c024]
    cp $03
    jp c, .loc_76A9
    xor a
    ld [$c024], a
.loc_76A9:
    ld a, [$c024]
    ld b, $30
    call MultiplyAByB
    ld a, h
    ld b, a
    ld a, l
    ld c, a
    ld hl, $69c6
    add hl, bc
    ld a, h
    ld d, a
    ld a, l
    ld e, a
    push de
    ld a, $01
    ld b, $10
    call MultiplyAByB
    ld a, h
    ld b, a
    ld a, l
    ld c, a
    ld hl, $9000
    add hl, bc
    pop de
    ld bc, $0030
    farcall BANK_21, Bank21_Entry_3B59
.loc_76D5:
    ld a, [$c023]
    inc a
    ld [$c023], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ret
RuntimeEntry_Bank1A_76E2::
    push bc
    push de
    push hl
    ld a, $01
    ld hl, $c6a7
    call Bitfield_Test
    pop hl
    pop de
    pop bc
    ret
RuntimeEntry_Bank1A_76F1::
    push bc
    push de
    push hl
    ld a, $03
    ld hl, $c6a7
    call Bitfield_Test
    pop hl
    pop de
    pop bc
    ret
RuntimeEntry_Bank1A_7700::
    push hl
    ld hl, $0000
.loc_7704:
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    farcall AdvancedSprite_UpdateSpawnFirst
    call RuntimeEntry_Bank1A_7610
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr nz, .loc_771F
    xor a
    jr .loc_7745
.loc_771F:
    call RuntimeEntry_Bank1A_76E2
    jr z, .loc_7738
    ldh a, [$ff91]
    bit 0, a
    jr nz, .loc_7734
    bit 1, a
    jr nz, .loc_7734
    bit 3, a
    jr nz, .loc_7734
    jr .loc_7738
.loc_7734:
    xor a
    scf
    jr .loc_7745
.loc_7738:
    ldh a, [$ff95]
    add a, b
    ldh [$ff95], a
    ldh a, [$ff96]
    add a, c
    ldh [$ff96], a
    inc hl
    jr .loc_7704
.loc_7745:
    pop hl
    ret
RuntimeEntry_Bank1A_7747::
    push hl
    ld hl, $0000
.loc_774B:
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    farcall AdvancedSprite_UpdateSpawnFirst
    call RuntimeEntry_Bank1A_7679
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr nz, .loc_7766
    xor a
    jr .loc_778C
.loc_7766:
    call RuntimeEntry_Bank1A_76E2
    jr z, .loc_777F
    ldh a, [$ff91]
    bit 0, a
    jr nz, .loc_777B
    bit 1, a
    jr nz, .loc_777B
    bit 3, a
    jr nz, .loc_777B
    jr .loc_777F
.loc_777B:
    xor a
    scf
    jr .loc_778C
.loc_777F:
    ldh a, [$ff95]
    add a, b
    ldh [$ff95], a
    ldh a, [$ff96]
    add a, c
    ldh [$ff96], a
    inc hl
    jr .loc_774B
.loc_778C:
    pop hl
    ret
RuntimeEntry_Bank1A_778E::
    push hl
    ld hl, $0000
.loc_7792:
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    farcall AdvancedSprite_UpdateSpawnFirst
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr nz, .loc_77AA
    xor a
    jr .loc_77D0
.loc_77AA:
    call RuntimeEntry_Bank1A_76E2
    jr z, .loc_77C3
    ldh a, [$ff91]
    bit 0, a
    jr nz, .loc_77BF
    bit 1, a
    jr nz, .loc_77BF
    bit 3, a
    jr nz, .loc_77BF
    jr .loc_77C3
.loc_77BF:
    xor a
    scf
    jr .loc_77D0
.loc_77C3:
    ldh a, [$ff95]
    add a, b
    ldh [$ff95], a
    ldh a, [$ff96]
    add a, c
    ldh [$ff96], a
    inc hl
    jr .loc_7792
.loc_77D0:
    pop hl
    ret
RuntimeEntry_Bank1A_77D2::
    push hl
    ld hl, $0000
.loc_77D6:
    push hl
    push de
    push bc
    call Joypad_Update
    call Sprite_Update
    farcall AdvancedSprite_UpdateSpawnFirst
    pop bc
    pop de
    pop hl
    call Math_CompareHLToDE
    jr nz, .loc_77EE
    xor a
    jr .loc_7814
.loc_77EE:
    call RuntimeEntry_Bank1A_76F1
    jr z, .loc_7807
    ldh a, [$ff91]
    bit 0, a
    jr nz, .loc_7803
    bit 1, a
    jr nz, .loc_7803
    bit 3, a
    jr nz, .loc_7803
    jr .loc_7807
.loc_7803:
    xor a
    scf
    jr .loc_7814
.loc_7807:
    ldh a, [$ff95]
    add a, b
    ldh [$ff95], a
    ldh a, [$ff96]
    add a, c
    ldh [$ff96], a
    inc hl
    jr .loc_77D6
.loc_7814:
    pop hl
    ret
RuntimeEntry_Bank1A_7816::
    call RuntimeEntry_Bank1A_6FBB
    ld a, $14
    ld c, $00
    farcall CampaignBackground_Load
    call RuntimeEntry_Bank1A_6FE6
    call Sprite_Update
    call DelayFrame
    ld a, $1d
    call Audio_PlayMusic
    call FadeFromWhite8
    ld de, $012c
    ld bc, $fe00
    call RuntimeEntry_Bank1A_778E
    jr c, .loc_78B1
    call FadeToWhite8
    call RuntimeEntry_Bank1A_6FBB
    ld a, $15
    ld c, $00
    farcall CampaignBackground_Load
    call RuntimeEntry_Bank1A_70CF
    call Sprite_Update
    ld de, $0001
    ld bc, $0000
    call RuntimeEntry_Bank1A_778E
    call FadeFromWhite8
    ld de, $0276
    ld bc, $0000
    call RuntimeEntry_Bank1A_7700
    jr c, .loc_78B1
    call RuntimeEntry_Bank1A_725C
    ld de, $012c
    ld bc, $0000
    call RuntimeEntry_Bank1A_7700
    jr c, .loc_78B1
    call FadeToWhite8
    call RuntimeEntry_Bank1A_6FBB
    ld a, $16
    ld c, $00
    farcall CampaignBackground_Load
    call RuntimeEntry_Bank1A_72DA
    call FadeFromWhite8
    ld de, $0186
    ld bc, $0000
    call RuntimeEntry_Bank1A_7747
    jr c, .loc_78B1
    call RuntimeEntry_Bank1A_74E9
    ld de, $02e4
    ld bc, $0000
    call RuntimeEntry_Bank1A_7747
    jr c, .loc_78B1
    call RuntimeEntry_Bank1A_75C3
    ld de, $01e0
    ld bc, $0000
    call RuntimeEntry_Bank1A_7747
    jr c, .loc_78B1
.loc_78B1:
    call FadeToWhite8
    call Audio_StopMusic
    farcall AdvancedSprite_Reset
    ret
RuntimeEntry_Bank1A_78BC::
    xor a
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $17
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $bb
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    xor a
    ld [$c4ce], a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $64
    ld [$c4d4], a
    ld a, $6f
    ld [$c4d5], a
    ld a, $c4
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $00
    ld hl, $b070
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $bb
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    xor a
    ld [$c4ce], a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $64
    ld [$c4d4], a
    ld a, $6f
    ld [$c4d5], a
    ld a, $c4
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $00
    ld hl, $e070
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld hl, $5131
    ld c, $21
    ld a, $08
    ld b, $08
    call Vram_SetFarPals
    call Vram_ApplyPals
    ret
    ; Source-owned structural bytes formerly data/sprite/structural/bank1a_7955_7ab2.dat
    db $af, $ea, $cc, $c4, $3e, $fe, $ea, $ce, $c4, $af, $ea, $cf, $c4, $af, $ea, $d1
    db $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $42, $ea, $d4, $c4, $af, $ea, $d5, $c4
    db $ea, $d6, $c4, $ea, $d7, $c4, $c3, $8a, $02, $af, $ea, $cc, $c4, $3e, $ff, $ea
    db $ce, $c4, $af, $ea, $cf, $c4, $af, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4
    db $3e, $08, $ea, $d4, $c4, $3e, $79, $ea, $d5, $c4, $3e, $55, $ea, $d6, $c4, $3e
    db $1a, $ea, $d7, $c4, $c3, $8a, $02, $af, $ea, $cc, $c4, $3e, $ff, $ea, $ce, $c4
    db $3e, $80, $ea, $cf, $c4, $af, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e
    db $30, $ea, $d4, $c4, $3e, $79, $ea, $d5, $c4, $3e, $7e, $ea, $d6, $c4, $3e, $1a
    db $ea, $d7, $c4, $3e, $b8, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3
    db $8a, $02, $af, $ea, $cc, $c4, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea
    db $d3, $c4, $3e, $98, $ea, $d4, $c4, $3e, $79, $ea, $d5, $c4, $3e, $ac, $ea, $d6
    db $c4, $3e, $1a, $ea, $d7, $c4, $3e, $b9, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd
    db $e8, $2e, $3e, $80, $cd, $44, $38, $c3, $8a, $02, $3e, $ff, $ea, $cc, $c4, $af
    db $ea, $cd, $c4, $3e, $fe, $ea, $ce, $c4, $af, $ea, $cf, $c4, $3e, $7a, $ea, $d5
    db $c4, $3e, $52, $ea, $d6, $c4, $3e, $1a, $ea, $d7, $c4, $af, $ea, $d3, $c4, $3e
    db $02, $ea, $d4, $c4, $fa, $d0, $c4, $cd, $2b, $2f, $c3, $8a, $02, $3e, $ff, $ea
    db $cc, $c4, $af, $ea, $cd, $c4, $3e, $ff, $ea, $ce, $c4, $af, $ea, $cf, $c4, $3e
    db $7a, $ea, $d5, $c4, $3e, $85, $ea, $d6, $c4, $3e, $1a, $ea, $d7, $c4, $af, $ea
    db $d3, $c4, $3e, $04, $ea, $d4, $c4, $fa, $d0, $c4, $cd, $2b, $2f, $c3, $8a, $02
    db $3e, $ff, $ea, $cc, $c4, $af, $ea, $cd, $c4, $3e, $ff, $ea, $ce, $c4, $3e, $80
    db $ea, $cf, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $ea, $d3, $c4
    db $3e, $08, $ea, $d4, $c4, $fa, $d0, $c4, $cd, $2b, $2f, $c3, $8a, $02
RuntimeEntry_Bank1A_7AB3::
    xor a
    ld [$c4a0], a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $15
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    xor a
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0d
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $93
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    xor a
    ld [$c4ce], a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $32
    ld [$c4d4], a
    ld a, $7a
    ld [$c4d5], a
    ld a, $1f
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $00
    ld hl, $b074
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $93
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    xor a
    ld [$c4ce], a
    ld [$c4d1], a
    ld a, $5a
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $32
    ld [$c4d4], a
    ld a, $7a
    ld [$c4d5], a
    ld a, $1f
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $00
    ld hl, $b074
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $b7
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld [$c4d2], a
    ld [$c4d3], a
    ld a, $d2
    ld [$c4d4], a
    ld a, $79
    ld [$c4d5], a
    ld a, $e7
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $80
    ld hl, $5874
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld de, $0001
    ld bc, $0000
    call RuntimeEntry_Bank1A_778E
    ret
    ; Source-owned structural bytes formerly data/sprite/structural/bank1a_7b95_7c31.dat
    db $3e, $ff, $ea, $cc, $c4, $3e, $80, $ea, $cd, $c4, $af, $ea, $ce, $c4, $3e, $40
    db $ea, $cf, $c4, $af, $ea, $d1, $c4, $ea, $d2, $c4, $3e, $01, $ea, $d3, $c4, $af
    db $ea, $d4, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $c3, $8a, $02
    db $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4
    db $ea, $d2, $c4, $ea, $d3, $c4, $3e, $1e, $ea, $d4, $c4, $3e, $7b, $ea, $d5, $c4
    db $3e, $95, $ea, $d6, $c4, $3e, $1a, $ea, $d7, $c4, $3e, $db, $ef, $1a, $10, $45
    db $3e, $82, $cd, $44, $38, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea
    db $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $ea, $d2
    db $c4, $3e, $01, $ea, $d3, $c4, $3e, $3b, $ea, $d4, $c4, $3e, $7b, $ea, $d5, $c4
    db $3e, $c5, $ea, $d6, $c4, $3e, $1a, $ea, $d7, $c4, $c3, $8a, $02
RuntimeEntry_Bank1A_7C32::
    call RuntimeEntry_Bank1A_6FBB
    ld a, $14
    ld c, $00
    farcall CampaignBackground_Load
    call RuntimeEntry_Bank1A_78BC
    ld a, $1e
    call Audio_PlayMusic
    call FadeFromWhite8
    ld de, $012c
    ld bc, $fe00
    call RuntimeEntry_Bank1A_77D2
    jp c, .loc_7D18
    call FadeToWhite8
    call RuntimeEntry_Bank1A_6FBB
    ld a, $14
    ld c, $00
    farcall CampaignBackground_Load
    call RuntimeEntry_Bank1A_7AB3
    call FadeFromWhite8
    ld de, $01fe
    ld bc, $0000
    call RuntimeEntry_Bank1A_77D2
    jp c, .loc_7D18
    call FadeToWhite8
    call RuntimeEntry_Bank1A_6FBB
    ld a, $17
    ld c, $00
    farcall CampaignBackground_Load
    farcall BANK_26, Bank26_Entry_769F
    call FadeFromWhite8
    ld de, $0348
    ld bc, $fe00
    call RuntimeEntry_Bank1A_77D2
    jp c, .loc_7D18
    call FadeToWhite8
    call RuntimeEntry_Bank1A_6FBB
    ld a, $17
    ld c, $00
    farcall CampaignBackground_Load
    farcall BANK_26, Bank26_Entry_77E2
    call FadeFromWhite8
    ld de, $02b2
    ld bc, $0000
    call RuntimeEntry_Bank1A_77D2
    jp c, .loc_7D18
    call FadeToWhite8
    call RuntimeEntry_Bank1A_6FBB
    ld a, $19
    ld c, $00
    farcall CampaignBackground_Load
    farcall BANK_26, Bank26_Entry_7A0D
    call FadeFromWhite8
    ld de, $030c
    ld bc, $0000
    call RuntimeEntry_Bank1A_77D2
    jr c, .loc_7D18
    call FadeToWhite8
    call RuntimeEntry_Bank1A_6FBB
    ld a, $1a
    ld c, $00
    farcall CampaignBackground_Load
    ld a, $70
    ldh [$ff96], a
    farcall BANK_26, Bank26_Entry_71AC
    farcall BANK_26, Bank26_Entry_7D13
    call FadeFromWhite8
    ld de, $041a
    ld bc, $0000
    call RuntimeEntry_Bank1A_77D2
    jr c, .loc_7D18
    ld de, $0070
    ld bc, $00ff
    call RuntimeEntry_Bank1A_77D2
    jr c, .loc_7D18
    farcall BANK_26, Bank26_Entry_7EAF
    ld de, $0960
    ld bc, $0000
    call RuntimeEntry_Bank1A_77D2
    jr c, .loc_7D18
.loc_7D18:
    call FadeToWhite8
    call Audio_StopMusic
    farcall AdvancedSprite_Reset
    ret
    ds $2dd, $ff
    assert @ == $8000

SECTION "Structural Graphics 1B:4000-7BAF", ROMX[$4000], BANK[$1B]
StructuralGraphics_Bank1B_4000::
    INCBIN "gfx/structural/bank1b_tiles_4000_7baf.2bpp"
    assert @ == $7BB0

SECTION "Bank 1B Padding", ROMX[$7BB0], BANK[$1B]
    ds $450, $ff
    assert @ == $8000

SECTION "Remaining ROM 1C:4000-745F", ROMX[$4000], BANK[$1C]
RemainingROM_Bank1C_4000::
    INCBIN "gfx/sprites/raw_resources/bank1c_tiles_4000_745f.2bpp"
    assert @ == $7460

SECTION "Remaining ROM 1C:751B-7FFF", ROMX[$751B], BANK[$1C]
RemainingROM_Bank1C_751B::
    INCBIN "gfx/sprites/raw_resources/bank1c_sprite_resources_751b_7fff.2bpp"
    assert @ == $8000

SECTION "Remaining ROM 1D:44C8-4A19", ROMX[$44C8], BANK[$1D]
RemainingROM_Bank1D_44C8::
    INCBIN "gfx/sprites/raw_resources/bank1d_44c8_4a19.2bpp", $0, $552
    assert @ == $4A1A

SECTION "Remaining ROM 1D:4ED6-55A7", ROMX[$4ED6], BANK[$1D]
RemainingROM_Bank1D_4ED6::
    INCBIN "gfx/sprites/raw_resources/bank1d_4ed6_55a7.2bpp", $0, $6d2
    assert @ == $55A8

SECTION "Remaining ROM 1D:5863-5D6E", ROMX[$5863], BANK[$1D]
RemainingROM_Bank1D_5863::
    INCBIN "gfx/sprites/raw_resources/bank1d_5863_5d6e.2bpp", $0, $50c
    assert @ == $5D6F

SECTION "Remaining ROM 1D:6141-695C", ROMX[$6141], BANK[$1D]
RemainingROM_Bank1D_6141::
    INCBIN "gfx/sprites/raw_resources/bank1d_6141_695c.2bpp", $0, $81c
    assert @ == $695D

SECTION "Remaining ROM 1D:6D2B-712A", ROMX[$6D2B], BANK[$1D]
RemainingROM_Bank1D_6D2B::
    INCBIN "gfx/sprites/raw_resources/bank1d_6d2b_712a.2bpp", $0, $400
    assert @ == $712B

SECTION "Remaining ROM 1D:771F-7FFF", ROMX[$771F], BANK[$1D]
RemainingROM_Bank1D_771F::
    INCBIN "gfx/sprites/raw_resources/bank1d_771f_7fff.2bpp", $0, $8e1
    assert @ == $8000

SECTION "Remaining ROM 1E:4594-4AFB", ROMX[$4594], BANK[$1E]
RemainingROM_Bank1E_4594::
    INCBIN "gfx/sprites/raw_resources/bank1e_4594_4afb.2bpp", $0, $568
    assert @ == $4AFC

SECTION "Remaining ROM 1E:50A8-561F", ROMX[$50A8], BANK[$1E]
RemainingROM_Bank1E_50A8::
    INCBIN "gfx/sprites/raw_resources/bank1e_50a8_561f.2bpp", $0, $578
    assert @ == $5620

SECTION "Remaining ROM 1E:5B54-607B", ROMX[$5B54], BANK[$1E]
RemainingROM_Bank1E_5B54::
    INCBIN "gfx/sprites/raw_resources/bank1e_5b54_607b.2bpp", $0, $528
    assert @ == $607C

SECTION "Remaining ROM 1E:66A0-6CA7", ROMX[$66A0], BANK[$1E]
RemainingROM_Bank1E_66A0::
    INCBIN "gfx/sprites/raw_resources/bank1e_66a0_6ca7.2bpp", $0, $608
    assert @ == $6CA8

SECTION "Remaining ROM 1E:72CC-7FFF", ROMX[$72CC], BANK[$1E]
RemainingROM_Bank1E_72CC::
    INCBIN "gfx/sprites/raw_resources/bank1e_72cc_7fff.2bpp", $0, $d34
    assert @ == $8000

SECTION "Remaining ROM 1F:460C-4C23", ROMX[$460C], BANK[$1F]
RemainingROM_Bank1F_460C::
    INCBIN "gfx/sprites/raw_resources/bank1f_460c_4c23.2bpp", $0, $618
    assert @ == $4C24

SECTION "Remaining ROM 1F:543C-5C4B", ROMX[$543C], BANK[$1F]
RemainingROM_Bank1F_543C::
    INCBIN "gfx/sprites/raw_resources/bank1f_543c_5c4b.2bpp", $0, $810
    assert @ == $5C4C

SECTION "Remaining ROM 1F:5F18-6601", ROMX[$5F18], BANK[$1F]
RemainingROM_Bank1F_5F18::
    INCBIN "gfx/sprites/raw_resources/bank1f_5f18_6601.2bpp", $0, $6ea
    assert @ == $6602

SECTION "Remaining ROM 1F:68E6-6D99", ROMX[$68E6], BANK[$1F]
RemainingROM_Bank1F_68E6::
    INCBIN "gfx/sprites/raw_resources/bank1f_68e6_6d99.2bpp", $0, $4b4
    assert @ == $6D9A

SECTION "Remaining ROM 1F:711C-7FFF", ROMX[$711C], BANK[$1F]
RemainingROM_Bank1F_711C::
    INCBIN "gfx/sprites/raw_resources/bank1f_711c_7fff.2bpp", $0, $ee4
    assert @ == $8000

SECTION "Remaining ROM 20:4062-4131", ROMX[$4062], BANK[$20]
RemainingROM_Bank20_4062::
    INCBIN "gfx/sprites/raw_resources/bank20_4062_4131.2bpp", $0, $d0
    assert @ == $4132

SECTION "Remaining ROM 20:4188-4307", ROMX[$4188], BANK[$20]
RemainingROM_Bank20_4188::
    INCBIN "gfx/sprites/raw_resources/bank20_4188_4307.2bpp", $0, $180
    assert @ == $4308

SECTION "Remaining ROM 20:4419-4720", ROMX[$4419], BANK[$20]
RemainingROM_Bank20_4419::
    INCBIN "gfx/sprites/raw_resources/bank20_4419_4720.2bpp", $0, $308
    assert @ == $4721

SECTION "Remaining ROM 20:52A5-58BC", ROMX[$52A5], BANK[$20]
RemainingROM_Bank20_52A5::
    INCBIN "gfx/sprites/raw_resources/bank20_52a5_58bc.2bpp", $0, $618
    assert @ == $58BD

SECTION "Remaining ROM 20:591E-59CD", ROMX[$591E], BANK[$20]
RemainingROM_Bank20_591E::
    INCBIN "gfx/sprites/raw_resources/bank20_591e_59cd.2bpp", $0, $b0
    assert @ == $59CE

SECTION "Remaining ROM 20:5A95-5D88", ROMX[$5A95], BANK[$20]
RemainingROM_Bank20_5A95::
    INCBIN "gfx/sprites/raw_resources/bank20_5a95_5d88.2bpp", $0, $2f4
    assert @ == $5D89

SECTION "Remaining ROM 20:6257-6F8A", ROMX[$6257], BANK[$20]
RemainingROM_Bank20_6257::
    INCBIN "gfx/sprites/raw_resources/bank20_6257_6f8a.2bpp", $0, $d34
    assert @ == $6F8B

SECTION "Remaining ROM 20:72DE-7FFF", ROMX[$72DE], BANK[$20]
RemainingROM_Bank20_72DE::
    INCBIN "gfx/sprites/raw_resources/bank20_72de_7fff.2bpp", $0, $d22
    assert @ == $8000

SECTION "Remaining ROM 21:4559-5170", ROMX[$4559], BANK[$21]
RemainingROM_Bank21_4559::
    INCBIN "gfx/sprites/raw_resources/bank21_4559_5170.2bpp", $0, $c18
    assert @ == $5171

SECTION "Remaining ROM 21:53E8-7FFF", ROMX[$53E8], BANK[$21]
RemainingROM_Bank21_53E8::
    INCBIN "gfx/sprites/raw_resources/bank21_53e8_7fff.2bpp", $0, $2c18
    assert @ == $8000

SECTION "Remaining ROM 22:4000-5BDF", ROMX[$4000], BANK[$22]
RemainingROM_Bank22_4000::
    INCBIN "gfx/network/structural/bank22_network_tiles_4000_5bdf.2bpp", $0, $1be0
    assert @ == $5BE0

SECTION "Remaining ROM 22:5C61-620C", ROMX[$5C61], BANK[$22]
RemainingROM_Bank22_5C61::
    INCBIN "gfx/sprites/raw_resources/bank22_sprite_resources_5c61_620c.2bpp", $0, $5ac
    assert @ == $620D

SECTION "Remaining ROM 22:64B8-64D3", ROMX[$64B8], BANK[$22]
RemainingROM_Bank22_64B8::
RuntimeEntry_Bank22_64B8::
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $64d4
    ld hl, $9000
    ld bc, $0800
    call Memcpy
    ld hl, $8800
    ld bc, $0800
    call Memcpy
    ret
    assert @ == $64D4

SECTION "Remaining ROM 22:74D4-7513", ROMX[$74D4], BANK[$22]
RemainingROM_Bank22_74D4::
    db $00, $00, $00, $69, $ff, $7f, $40, $72, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    assert @ == $7514

SECTION "Remaining ROM 22:7714-77C1", ROMX[$7714], BANK[$22]
RemainingROM_Bank22_7714::
    db $fa, $38, $ba, $fe, $06, $38, $0f, $fa, $38, $ba, $d6, $06, $4f, $fa, $27, $cc
    db $b9, $30, $22, $18, $0c, $c9, $af, $ea, $26, $cc, $fa, $27, $cc, $ea, $25, $cc
    db $c9, $fa, $27, $cc, $ea, $26, $cc, $ea, $25, $cc, $fa, $27, $cc, $ea, $26, $cc
    db $af, $ea, $25, $cc, $c9, $fa, $38, $ba, $d6, $06, $ea, $26, $cc, $fa, $27, $cc
    db $4f, $fa, $38, $ba, $91, $4f, $3e, $06, $91, $ea, $25, $cc, $c9, $21, $c2, $77
    db $cd, $6e, $33, $21, $ce, $77, $cd, $6e, $33, $fa, $38, $ba, $fe, $00, $20, $03
    db $af, $18, $09, $fa, $25, $cc, $4f, $fa, $26, $cc, $81, $3c, $01, $01, $0d, $16
    db $02, $cd, $44, $32, $fa, $38, $ba, $01, $01, $10, $16, $02, $cd, $44, $32, $c9
    db $21, $c2, $77, $cd, $6e, $33, $21, $ce, $77, $cd, $6e, $33, $fa, $38, $ba, $fe
    db $00, $20, $03, $af, $18, $04, $fa, $27, $cc, $3c, $01, $01, $0d, $16, $02, $cd
    db $44, $32, $fa, $38, $ba, $01, $01, $10, $16, $02, $cd, $44, $32, $c9
    assert @ == $77C2

SECTION "Remaining ROM 22:77CD-79B4", ROMX[$77CD], BANK[$22]
RemainingROM_Bank22_77CD::
    db $00, $0f, $01, $0f, $00, $fa, $29, $cc, $4f, $3e, $0c, $b9, $30, $26, $fa, $28
    db $cc, $fe, $00, $20, $05, $cd, $16, $78, $18, $03, $cd, $08, $78, $3e, $0c, $4f
    db $fa, $29, $cc, $91, $4f, $fa, $28, $cc, $b9, $28, $05, $cd, $0f, $78, $18, $03
    db $cd, $1d, $78, $c9, $cd, $16, $78, $cd, $1d, $78, $c9, $fa, $31, $df, $cd, $45
    db $2f, $c9, $fa, $32, $df, $cd, $45, $2f, $c9, $fa, $31, $df, $cd, $5f, $2f, $c9
    db $fa, $32, $df, $cd, $5f, $2f, $c9, $fa, $38, $ba, $fe, $01, $28, $18, $fa, $27
    db $cc, $fe, $00, $28, $18, $f5, $fa, $38, $ba, $3d, $4f, $f1, $b9, $28, $15, $cd
    db $66, $78, $cd, $6d, $78, $c9, $cd, $58, $78, $cd, $5f, $78, $c9, $cd, $58, $78
    db $cd, $6d, $78, $c9, $cd, $66, $78, $cd, $5f, $78, $c9, $fa, $33, $df, $cd, $5f
    db $2f, $c9, $fa, $34, $df, $cd, $5f, $2f, $c9, $fa, $33, $df, $cd, $45, $2f, $c9
    db $fa, $34, $df, $cd, $45, $2f, $c9, $ef, $22, $fe, $79, $23, $af, $77, $c9, $21
    db $e9, $78, $01, $04, $02, $cd, $53, $33, $21, $e9, $78, $01, $05, $02, $cd, $53
    db $33, $21, $e9, $78, $01, $06, $02, $cd, $53, $33, $21, $e9, $78, $01, $07, $02
    db $cd, $53, $33, $21, $e9, $78, $01, $08, $02, $cd, $53, $33, $21, $e9, $78, $01
    db $09, $02, $cd, $53, $33, $21, $e9, $78, $01, $0a, $02, $cd, $53, $33, $21, $e9
    db $78, $01, $0b, $02, $cd, $53, $33, $21, $e9, $78, $01, $0c, $02, $cd, $53, $33
    db $21, $e9, $78, $01, $0d, $02, $cd, $53, $33, $21, $e9, $78, $01, $0e, $02, $cd
    db $53, $33, $21, $e9, $78, $01, $0f, $02, $cd, $53, $33, $c9, $5f, $5f, $5f, $5f
    db $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f, $00, $fa, $25, $cc
    db $06, $10, $cd, $95, $29, $7d, $c6, $34, $4f, $06, $14, $fa, $22, $df, $cd, $ae
    db $2e, $fa, $38, $ba, $fe, $00, $20, $06, $fa, $22, $df, $cd, $5f, $2f, $c9, $01
    db $06, $03, $11, $08, $0e, $ef, $10, $01, $69, $f0, $83, $f5, $3e, $01, $e0, $83
    db $e0, $4f, $af, $01, $07, $04, $11, $06, $0c, $ef, $15, $d3, $6a, $f1, $e0, $83
    db $e0, $4f, $01, $08, $05, $21, $b5, $79, $cd, $53, $33, $01, $09, $05, $21, $be
    db $79, $cd, $53, $33, $01, $0b, $07, $ef, $15, $64, $66, $3e, $01, $ea, $2a, $cc
    db $ef, $22, $0d, $62, $f0, $92, $cb, $47, $28, $02, $18, $3a, $cb, $4f, $28, $07
    db $3e, $01, $ea, $2a, $cc, $18, $2f, $cb, $67, $28, $13, $3e, $01, $cd, $44, $38
    db $3e, $01, $ea, $2a, $cc, $01, $0b, $07, $ef, $15, $64, $66, $18, $16, $cb, $6f
    db $28, $12, $3e, $01, $cd, $44, $38, $af, $ea, $2a, $cc, $01, $0b, $07, $ef, $15
    db $37, $66, $18, $00, $18, $ba, $ef, $10, $08, $69, $fa, $2a, $cc, $fe, $01, $28
    db $02, $18, $03, $af, $37, $c9, $af, $c9
    assert @ == $79B5

SECTION "Remaining ROM 22:79C8-7FFF", ROMX[$79C8], BANK[$22]
RemainingROM_Bank22_79C8::
    db $fa, $25, $cc, $4f, $fa, $26, $cc, $81, $ef, $22, $fe, $79, $23, $af, $77, $c9
    db $fa, $25, $cc, $4f, $fa, $26, $cc, $81, $4f, $fa, $38, $ba, $b9, $28, $03, $38
    db $01, $c9, $fa, $25, $cc, $3d, $fe, $ff, $28, $03, $ea, $25, $cc, $ef, $22, $fa
    db $78, $ef, $22, $61, $77, $c9
RuntimeEntry_Bank22_79FE::
    ld de, $0140
    ld h, $00
    ld l, a
    call Math_SignedMultiplyHLByDE
    ld bc, $a138
    add hl, bc
    ret
    db $2a, $fe, $00, $28, $05, $cd, $2a, $7a, $18, $08, $2a, $fe, $00, $28, $0b, $cd
    db $43, $7a, $fa, $ca, $cb, $3c, $ea, $ca, $cb, $c9, $cd, $5c, $7a, $c9, $fa, $ca
    db $cb, $4f, $fa, $c9, $cb, $81, $47, $fa, $cb, $cb, $4f, $3e, $0e, $11, $02, $01
    db $26, $3f, $ef, $15, $fd, $67, $c9, $fa, $ca, $cb, $4f, $fa, $c9, $cb, $81, $47
    db $fa, $cb, $cb, $4f, $3e, $0e, $11, $02, $01, $26, $3d, $ef, $15, $fd, $67, $c9
    db $fa, $ca, $cb, $4f, $fa, $c9, $cb, $81, $47, $fa, $cb, $cb, $4f, $c5, $f0, $83
    db $f5, $3e, $00, $e0, $83, $e0, $4f, $af, $11, $01, $01, $ef, $15, $d3, $6a, $3e
    db $01, $e0, $83, $e0, $4f, $af, $11, $01, $01, $ef, $15, $d3, $6a, $f1, $e0, $83
    db $e0, $4f, $c1, $0c, $ef, $22, $1a, $62, $c9, $e5, $21, $a8, $da, $01, $10, $00
    db $3e, $5f, $cd, $79, $3b, $3e, $00, $ea, $b7, $da, $e1, $54, $5d, $21, $a8, $da
    db $01, $02, $00, $cd, $50, $3b, $3e, $0f, $ea, $aa, $da, $21, $ab, $da, $01, $02
    db $00, $cd, $50, $3b, $3e, $5f, $ea, $ad, $da, $62, $6b, $11, $ae, $da, $06, $00
    db $2a, $fe, $00, $20, $0a, $7e, $fe, $00, $20, $05, $23, $fe, $00, $28, $0a, $12
    db $13, $0c, $3e, $09, $b9, $28, $02, $18, $e7, $c9, $3e, $02, $ea, $c9, $cb, $3e
    db $04, $ea, $cb, $cb, $af, $ea, $ca, $cb, $af, $ea, $2a, $df, $fa, $38, $ba, $fe
    db $00, $28, $51, $fa, $2a, $df, $4f, $fa, $26, $cc, $81, $ef, $22, $fe, $79, $e5
    db $cd, $0c, $7a, $e1, $23, $23, $cd, $95, $7a, $0e, $01, $fa, $c9, $cb, $81, $47
    db $fa, $cb, $cb, $4f, $2a, $21, $a8, $da, $cd, $53, $33, $fa, $cb, $cb, $3c, $3c
    db $ea, $cb, $cb, $af, $ea, $ca, $cb, $fa, $2a, $df, $3c, $fe, $06, $28, $15, $4f
    db $fa, $26, $cc, $81, $4f, $fa, $38, $ba, $b9, $28, $09, $fa, $2a, $df, $3c, $ea
    db $2a, $df, $18, $af, $fa, $2a, $df, $fe, $05, $28, $34, $21, $a8, $da, $01, $10
    db $00, $3e, $5f, $cd, $79, $3b, $3e, $00, $ea, $b7, $da, $06, $03, $fa, $cb, $cb
    db $4f, $21, $a8, $da, $cd, $53, $33, $cd, $5c, $7a, $fa, $2a, $df, $3c, $ea, $2a
    db $df, $fe, $05, $28, $0a, $fa, $cb, $cb, $3c, $3c, $ea, $cb, $cb, $18, $dc, $c9
    db $7a, $fe, $01, $28, $1d, $d5, $e5, $16, $00, $7e, $fe, $00, $28, $04, $2b, $14
    db $18, $f7, $7a, $fe, $10, $38, $02, $18, $05, $3e, $01, $e1, $d1, $c9, $af, $e1
    db $d1, $c9, $c9, $3e, $0e, $cd, $8d, $05, $fa, $27, $cc, $11, $40, $01, $26, $00
    db $6f, $cd, $d8, $29, $01, $3e, $a1, $09, $16, $00, $2a, $fe, $00, $20, $0c, $7e
    db $fe, $00, $20, $07, $23, $7e, $fe, $00, $28, $03, $14, $18, $ed, $14, $7a, $ea
    db $29, $cc, $c9
RuntimeEntry_Bank22_7BDF::
    ld a, [$cc22]
    cp $00
    jr nz, .loc_7BEC
    ld hl, $dc10
    ld a, $20
    ld [hl], a
.loc_7BEC:
    ld hl, $dc10
    ld a, [$df27]
    ld d, a
    ld a, [$df28]
    ld e, a
    call RuntimeEntry_Bank00_2C0B
    ld a, [$df04]
    ld [$df27], a
    ld a, [$df05]
    ld [$df28], a
    ld a, [$df27]
    ld h, a
    ld a, [$df28]
    ld l, a
    inc hl
    inc hl
    ld a, h
    ld [$df27], a
    ld a, l
    ld [$df28], a
    ret
RuntimeEntry_Bank22_7C19::
    ld [$cc24], a
    push hl
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    pop hl
    ld a, h
    ld [$df25], a
    ld a, l
    ld [$df26], a
    xor a
    ld [$df29], a
    ld a, $da
    ld [$df27], a
    ld a, $a8
    ld [$df28], a
    ld hl, $daa8
    ld bc, $012c
    xor a
    call Memset
.loc_7C46:
    ld hl, $dc10
    ld bc, $02d0
    xor a
    call Memset
    xor a
    ld [$cc22], a
    ld a, [$df25]
    ld h, a
    ld a, [$df26]
    ld l, a
    ld de, $dc10
.loc_7C5F:
    ld a, [hli]
    cp $0d
    jr nz, .loc_7C78
    ld a, [hl]
    cp $0a
    jr nz, .loc_7C78
    push hl
    inc hl
    ld a, [hl]
    cp $00
    jr nz, .loc_7C75
    ld a, $01
    ld [$df29], a
.loc_7C75:
    pop hl
    jr .loc_7C85
.loc_7C78:
    push af
    ld a, [$cc22]
    inc a
    ld [$cc22], a
    pop af
    ld [de], a
    inc de
    jr .loc_7C5F
.loc_7C85:
    inc hl
    ld a, h
    ld [$df25], a
    ld a, l
    ld [$df26], a
    call RuntimeEntry_Bank22_7BDF
    ld a, [$df29]
    cp $01
    jr nz, .loc_7C46
    ld a, [$df27]
    ld h, a
    ld a, [$df28]
    ld l, a
    inc hl
    ld a, $ff
    ld [hl], a
    call SRAM_Disable
    ret
    db $ea, $24, $cc, $e5, $3e, $0f, $cd, $8d, $05, $cd, $93, $05, $e1, $7c, $ea, $25
    db $df, $7d, $ea, $26, $df, $af, $ea, $29, $df, $3e, $da, $ea, $27, $df, $3e, $a8
    db $ea, $28, $df, $21, $a8, $da, $01, $2c, $01, $af, $cd, $79, $3b, $21, $10, $dc
    db $01, $d0, $02, $af, $cd, $79, $3b, $af, $ea, $22, $cc, $fa, $25, $df, $67, $fa
    db $26, $df, $6f, $11, $10, $dc, $2a, $fe, $0d, $20, $14, $7e, $fe, $0a, $20, $0f
    db $e5, $23, $7e, $fe, $00, $20, $05, $3e, $01, $ea, $29, $df, $e1, $18, $0d, $f5
    db $fa, $22, $cc, $3c, $ea, $22, $cc, $f1, $12, $13, $18, $da, $23, $7c, $ea, $25
    db $df, $7d, $ea, $26, $df, $cd, $df, $7b, $fa, $29, $df, $fe, $01, $20, $ae, $fa
    db $27, $df, $67, $fa, $28, $df, $6f, $23, $3e, $ff, $77, $cd, $9b, $05, $c9
RuntimeEntry_Bank22_7D37::
    ld a, [$ba38]
    dec a
    ld [$df2f], a
.loc_7D3E:
    farcall BANK_22, Bank22_Entry_79FE
    ld a, [hl]
    cp $00
    jr z, .loc_7D50
    ld a, [$df2f]
    dec a
    ld [$df2f], a
    jr .loc_7D3E
.loc_7D50:
    ld a, [$df2f]
    ret
RuntimeEntry_Bank22_7D54::
    push bc
    ld a, b
    farcall BANK_22, Bank22_Entry_79FE
    ld d, h
    ld e, l
    pop bc
    ld a, c
    push de
    farcall BANK_22, Bank22_Entry_79FE
    pop de
    ld bc, $0140
    call Memcpy
    ret
RuntimeEntry_Bank22_7D6B::
    ld a, [$ba38]
    cp $00
    jr z, .loc_7DA5
    ld a, [$ba38]
    cp $14
    jr nz, .loc_7D7C
    call RuntimeEntry_Bank22_7D37
.loc_7D7C:
    ld [$df2e], a
    dec a
    ld [$df2d], a
.loc_7D83:
    ld a, [$df2d]
    cp $ff
    jr z, .loc_7DA5
    ld a, [$df2d]
    ld b, a
    ld a, [$df2e]
    ld c, a
    call RuntimeEntry_Bank22_7D54
    ld a, [$df2d]
    dec a
    ld [$df2d], a
    ld a, [$df2e]
    dec a
    ld [$df2e], a
    jr .loc_7D83
.loc_7DA5:
    scf
    ccf
    ret
    db $37, $c9
RuntimeEntry_Bank22_7DAA::
    xor a
    ld [$cc2b], a
    push hl
.loc_7DAF:
    ld a, [de]
    cp $00
    jr z, .loc_7DB6
    jr .loc_7DBE
.loc_7DB6:
    push af
    xor a
    ld [$cc2b], a
    pop af
    jr .loc_7DBE
.loc_7DBE:
    push af
    cp $00
    jr z, .loc_7DCA
    ld a, [$cc2b]
    inc a
    ld [$cc2b], a
.loc_7DCA:
    cp $11
    jr z, .loc_7DD0
    jr .loc_7DDD
.loc_7DD0:
    ld a, [de]
    cp $00
    jr z, .loc_7DD9
    ld a, $00
    ld [hli], a
    ld [hli], a
.loc_7DD9:
    xor a
    ld [$cc2b], a
.loc_7DDD:
    pop af
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .loc_7DAF
    pop hl
    dec hl
    ld bc, $012c
    add hl, bc
    ld a, $00
    ld [hld], a
    ld [hld], a
    ld [hld], a
    ret
RuntimeEntry_Bank22_7DF1::
    ld a, [$deed]
    inc a
    ld [$deed], a
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    call RuntimeEntry_Bank22_7D6B
    jr c, .loc_7E52
    xor a
    farcall BANK_22, Bank22_Entry_79FE
    push hl
    ld bc, $0006
    add hl, bc
    ld de, $daa8
    ld bc, $012c
    call RuntimeEntry_Bank22_7DAA
    pop hl
    push hl
    xor a
    ld bc, $0000
    add hl, bc
    ld [hli], a
    ld a, $01
    ld [hli], a
    ld a, [$d6a7]
    ld [hli], a
    ld a, [$d6a8]
    ld [hli], a
    ld a, [$d6aa]
    ld [hli], a
    ld a, [$d6ab]
    ld [hli], a
    pop hl
    ld bc, $0132
    add hl, bc
    ld a, [$cc24]
    ld [hl], a
    ld a, [$ba38]
    cp $14
    jr z, .loc_7E47
    inc a
    ld [$ba38], a
.loc_7E47:
    call SRAM_Disable
    call .loc_7E5A
    farcall BattleSceneBank31Runtime_543A
    ret
.loc_7E52:
    call SRAM_Disable
    farcall BattleSceneBank31Runtime_543A
    ret
.loc_7E5A:
    ld a, [$cbf6]
    ld h, a
    ld a, [$cbf7]
    ld l, a
    inc hl
    ld a, h
    ld [$cbf6], a
    ld a, l
    ld [$cbf7], a
    ret
    db $78, $ea, $c9, $cb, $79, $ea, $cb, $cb, $af, $ea, $ca, $cb, $ea, $30, $df, $e5
    db $21, $11, $df, $01, $10, $00, $3e, $5f, $cd, $79, $3b, $e1, $3e, $00, $ea, $21
    db $df, $2a, $fe, $00, $20, $0d, $7e, $fe, $00, $20, $08, $23, $7e, $fe, $00, $28
    db $5d, $18, $32, $fa, $ca, $cb, $fe, $10, $20, $03, $2b, $18, $28, $fa, $ca, $cb
    db $4f, $fa, $c9, $cb, $81, $47, $fa, $cb, $cb, $4f, $2b, $7e, $e5, $f5, $fa, $ca
    db $cb, $4f, $06, $00, $21, $11, $df, $09, $f1, $77, $e1, $fa, $ca, $cb, $3c, $ea
    db $ca, $cb, $23, $18, $bc, $e5, $21, $11, $df, $fa, $c9, $cb, $47, $fa, $cb, $cb
    db $4f, $cd, $53, $33, $e1, $af, $ea, $ca, $cb, $fa, $cb, $cb, $3c, $ea, $cb, $cb
    db $fa, $30, $df, $3c, $ea, $30, $df, $3d, $fe, $0b, $28, $13, $18, $81, $e5, $21
    db $11, $df, $fa, $c9, $cb, $47, $fa, $cb, $cb, $4f, $cd, $53, $33, $e1, $c9, $c9
    db $3e, $0e, $cd, $8d, $05, $16, $00, $e5, $2a, $fe, $00, $20, $13, $7e, $fe, $00
    db $20, $0e, $fa, $28, $cc, $ba, $28, $0a, $44, $4d, $e1, $60, $69, $23, $e5, $14
    db $18, $e6, $e1, $c9, $11, $40, $01, $26, $00, $6f, $cd, $d8, $29, $01, $3e, $a1
    db $09, $c9, $fa, $27, $cc, $cd, $30, $7f, $cd, $0c, $7f, $3e, $0e, $cd, $8d, $05
    db $01, $04, $02, $cd, $6c, $7e, $c9, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff
    assert @ == $8000

SECTION "Remaining ROM 25:44F3-44FC", ROMX[$44F3], BANK[$25]
RemainingROM_Bank25_44F3::
    ds $a, $ff
    assert @ == $44FD

SECTION "Remaining ROM 25:5C15-5DA4", ROMX[$5C15], BANK[$25]
RemainingROM_Bank25_5C15::
    ; Source-owned structural bytes formerly data/ui/structural/bank25_5c15_5da4.dat
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $fe, $7f, $fe, $7f, $fe, $7f
    db $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $03, $ff, $fe, $03, $fe, $3f, $fe, $3f
    db $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $03, $ff, $fd, $03, $f7, $39, $f7, $39
    db $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $0e, $ff, $7f, $8e, $75, $8e, $7f, $84
    db $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $21, $ff, $ef, $31, $ee, $31, $ef, $30
    db $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $c7, $ff, $ff, $c7, $bf, $c7, $fe, $87
    db $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $8e, $ff, $7e, $8f, $b6, $4f, $de, $67
    db $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $0c, $ff, $fd, $0e, $b5, $4e, $fd, $46
    db $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $80, $ff, $bf, $c0, $bd, $ce, $bd, $ce
    db $ff, $00, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $7f, $fe, $ff, $7e, $ff, $7e
    db $fe, $7f, $fe, $7f, $fe, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $00
    db $fe, $3f, $fe, $3f, $c2, $3f, $7f, $83, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $f7, $39, $f7, $39, $c7, $39, $7f, $83, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $5a, $a5, $7e, $a1, $6c, $b3, $7e, $b3, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $eb, $34, $ef, $34, $ed, $36, $ef, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $5f, $a6, $dd, $26, $9e, $65, $db, $65, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $1a, $e7, $fe, $03, $fc, $f3, $f6, $f9, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $d9, $66, $fd, $62, $ed, $72, $ff, $70, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $bd, $ce, $bd, $ce, $b1, $ce, $bf, $c0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $ff, $7e, $ff, $7e, $ff, $7e, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $00
    db $00, $00, $00, $69, $ff, $7f, $40, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $ff, $7f, $3f, $2b, $b0, $15, $00, $00, $1f, $7c, $1f, $7c, $00, $00, $ff, $7f
    assert @ == $5DA5

SECTION "Remaining ROM 26:4FF2-5499", ROMX[$4FF2], BANK[$26]
RemainingROM_Bank26_4FF2::
    ; Source-owned structural data formerly data/campaign/structural/bank26_4ff2_5499.bin
    db $e2, $4e, $e7, $4e, $f2, $4e, $33, $4f, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $7f, $00, $80, $7f, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $f7, $00, $fd, $f7, $ff, $00, $00, $00, $00, $00, $0e, $00, $32, $0c
    db $ec, $30, $b0, $c0, $c0, $00, $f0, $40, $01, $00, $01, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $30, $c0, $dc, $30, $37, $0c
    db $0f, $01, $0f, $04, $1f, $0b, $3b, $06, $00, $00, $00, $00, $00, $00, $df, $00
    db $7f, $df, $ff, $00, $fe, $1c, $f2, $fc, $00, $00, $00, $00, $00, $00, $fe, $00
    db $01, $fe, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $01, $00, $01, $00, $01, $00, $7f, $11, $6f, $3e, $f0, $3f, $ff, $7f
    db $ff, $7f, $ff, $c0, $c7, $3f, $f0, $ff, $ff, $a0, $bf, $cf, $d0, $6f, $ef, $b7
    db $e7, $d8, $ff, $03, $ff, $ff, $00, $ff, $ff, $00, $ff, $ff, $00, $ff, $ff, $ff
    db $ff, $00, $ff, $ff, $ff, $ff, $00, $ff, $f6, $2d, $ef, $9b, $4f, $b7, $ff, $80
    db $e0, $7f, $ff, $7f, $ff, $80, $00, $ff, $0f, $fc, $ff, $fc, $ff, $fc, $fd, $02
    db $03, $fe, $ff, $fe, $ff, $0e, $0f, $f6, $03, $00, $03, $01, $07, $03, $07, $03
    db $0f, $03, $0b, $05, $0b, $05, $0d, $02, $80, $7f, $80, $7f, $e0, $9f, $ee, $d1
    db $ee, $d5, $ce, $b5, $de, $ad, $de, $2d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $02, $87, $7a, $ff, $4b, $ff, $7b, $00, $ff, $00, $ff, $00, $ff, $c6, $39
    db $ef, $d6, $ef, $d6, $c6, $39, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $31, $ce
    db $7b, $b5, $7b, $b5, $31, $ce, $00, $ff, $05, $fa, $02, $fc, $02, $fc, $82, $7c
    db $c2, $bc, $c6, $b8, $84, $78, $0c, $f0, $0c, $03, $07, $00, $07, $03, $03, $01
    db $01, $00, $00, $00, $00, $00, $00, $00, $1e, $e1, $00, $ff, $c0, $3f, $c0, $bf
    db $f0, $0f, $7f, $00, $0f, $00, $00, $00, $ff, $4b, $ff, $7b, $ff, $03, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $00, $00, $00, $f8, $ff, $f7, $f8, $ef, $f7, $ff, $ef
    db $f8, $ef, $f7, $0f, $ff, $0f, $0f, $00, $03, $ff, $fd, $03, $ff, $fd, $ff, $fe
    db $03, $fe, $ff, $fe, $ff, $fe, $fe, $00, $f8, $f0, $f8, $e0, $f0, $80, $e0, $00
    db $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $02, $01
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $60, $80
    db $98, $60, $6f, $18, $1d, $07, $3f, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $00, $7e, $01, $f1, $7e, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f0, $00, $1f, $e0, $f8, $07, $0f, $00, $00, $00, $00, $00, $00, $00, $01, $00
    db $ff, $01, $1f, $fe, $ff, $00, $33, $0f, $70, $00, $b0, $60, $a0, $40, $e0, $00
    db $70, $c0, $fc, $20, $fb, $1c, $fc, $e3, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $00, $70, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $00, $02, $01, $03, $00, $01, $00, $7f, $0c, $6f, $1b, $d8, $37, $bf, $6f
    db $3f, $df, $7f, $80, $c7, $3f, $f0, $ff, $ff, $60, $ff, $ef, $30, $ef, $df, $ef
    db $ff, $f0, $ff, $07, $ff, $ff, $00, $ff, $fc, $2f, $ff, $bf, $7f, $9f, $df, $a0
    db $e0, $7f, $ff, $7f, $ff, $80, $00, $ff, $0f, $fc, $ff, $fc, $ff, $fc, $fd, $02
    db $03, $fe, $ff, $fe, $ff, $0e, $0f, $f6, $8e, $70, $71, $0e, $0f
    ds $19, $00
    db $07, $00, $00, $00, $00, $00, $01, $00, $01, $00, $03, $01, $07, $00, $7d, $07
    db $ff, $70, $00, $00, $e0, $00, $60, $c0, $40, $80, $c0, $80, $80, $00, $f0, $00
    db $ff, $70, $00, $00, $3e, $00, $21, $1e, $1e, $01, $01, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $e0, $00, $3d, $e0, $ff, $1d, $1f, $00, $1f, $0c
    db $33, $0f, $00, $00, $00, $00, $03, $00, $dc, $03, $7b, $dc, $fc, $00, $be, $dc
    db $f2, $5c, $00, $00, $78, $00, $88, $70, $78, $80, $80, $00, $00, $00, $00, $00
    db $00, $00, $79, $07, $8f, $78, $f8, $00, $00, $00, $00, $00, $01, $00, $01, $00
    db $01, $00, $ff, $80, $ef, $3f, $f0, $3f, $ff, $7f, $ff, $7f, $ff, $c0, $c7, $3f
    db $f0, $ff, $f8, $0f, $ff, $e0, $30, $ef, $df, $ef, $ff, $f0, $ff, $07, $ff, $ff
    db $00, $ff, $ff, $00, $1f, $ef, $f0, $0f, $ff, $ff, $ff, $00, $ff, $ff, $ff, $ff
    db $00, $ff, $df, $6c, $df, $ac, $cf, $b4, $fd, $02, $03, $fe, $ff, $fe, $ff, $0e
    db $0f, $f6, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3c, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $00, $00
    db $00, $00, $42, $3c, $bd, $7e, $7e, $ff, $7e, $ff, $7e, $ff, $7e, $ff, $bd, $7e
    db $42, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01, $05, $03
    db $0b, $07, $00, $00, $00, $00, $00, $00, $7e, $00, $81, $7e, $7e, $ff, $ff, $ff
    db $ff, $ff, $0b, $07, $17, $0f, $17, $0f, $17, $0f, $17, $0f, $17, $0f, $17, $0f
    db $0b, $07
    ds $10, $ff
    db $00, $00, $01, $00, $06, $01, $09, $07, $16, $0f, $29, $1e, $2a, $1c, $54, $38
    db $7e, $00, $81, $7e, $7e, $ff, $81, $ff, $7e, $81, $81, $00, $00, $00, $00, $00
    db $54, $38, $a8, $70, $a8, $70, $a8, $70, $a8, $70, $a8, $70, $a8, $70, $54, $38
    db $00, $00, $00, $00, $00, $00, $00, $18, $18, $3c, $3a, $1c, $1c, $00, $00, $00
    db $00, $00, $00, $18, $18, $3c, $3c, $7e, $1a, $7c, $42, $3c, $3c, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $03, $03, $0f, $07, $0f, $0f, $1f, $07, $1f
    db $00, $00, $00, $00, $00, $00, $00, $e0, $e0, $f8, $f0, $f8, $f0, $f8, $f4, $f8
    db $11, $2f, $08, $17, $07, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $cc, $f0, $18, $e4, $e0, $18, $c0
    ds $10, $00
    db $03, $01, $0f, $07, $3f, $0f, $3f, $2f, $1f, $00, $00, $00, $00, $00, $00, $00
    db $f0, $e4, $f8, $fa, $fc, $fa, $fc, $fa, $fc, $2f, $1f, $17, $2f, $0b, $17, $07
    db $08, $00, $03, $00, $00, $00, $00, $00, $00, $f6, $f8, $8c, $f0, $18, $e0, $f0
    db $08, $00, $e0, $00, $00, $00, $00, $00, $00, $1f, $7c, $1f, $7c, $1f, $7c, $1f
    db $7c, $db, $7e, $7f, $01, $5f, $03, $ff, $77, $db, $7e, $00, $00, $5d, $36, $7f
    db $14, $fb, $5b, $00, $00, $ff, $7f, $cd, $45, $db, $7e, $00, $00, $5d, $36, $e0
    db $7e, $db, $7e, $00, $00, $7f, $14, $e0, $7e, $db, $7e, $52, $4a, $d6, $5a, $9c
    db $73, $db, $7e, $ff, $7f, $7f, $1a, $fd, $34
    assert @ == $549A

SECTION "Remaining ROM 26:54C8-6A25", ROMX[$54C8], BANK[$26]
RemainingROM_Bank26_54C8::
RuntimeEntry_Bank26_54C8::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $020d
    ld de, $1003
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$cbe6]
    add a, $05
    ld bc, $020d
    farcall Bank31_PrintIndexedMessage_5CE6
    ret
RuntimeEntry_Bank26_54EE::
    ld a, [$cbf8]
    cp $01
    ret z
    ld a, [$cace]
    cp $01
    jr z, .loc_5545
    ld a, [$def4]
    cp $00
    jr z, .loc_555D
    cp $01
    jp z, .loc_556A
    cp $02
    jp z, .loc_557E
    cp $03
    jp z, .loc_5592
    cp $0a
    jp z, .loc_55A6
    cp $80
    jp z, .loc_55BA
    cp $05
    jp z, .loc_55CE
    cp $0b
    jp z, .loc_55F9
    cp $0c
    jp z, .loc_5606
    cp $82
    jp z, .loc_552F
.loc_552F:
    ld a, $11
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $0e
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0307
    ld a, $82
    farcall BANK_27, Bank27_Entry_6A61
    ret
.loc_5545:
    ld a, $11
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $0e
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0307
    ld a, [$def4]
    farcall BANK_27, Bank27_Entry_6A61
    ret
    db $c9
.loc_555D:
    ld a, $07
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $08
    farcall BANK_32, Bank32_Entry_4659
    ret
.loc_556A:
    ld a, $0a
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $09
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0307
    farcall Bank31_RuntimeWRAM4BufferClear_599F
    ret
.loc_557E:
    ld a, $0c
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $0b
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0607
    farcall Bank31_RuntimeWRAM4BufferClear_598A
    ret
.loc_5592:
    ld a, $09
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $02
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0607
    farcall Bank31_RuntimeBufferClear_5983
    ret
.loc_55A6:
    ld a, $04
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $0a
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0607
    farcall Bank31_RuntimeWRAM4BufferClear_598A
    ret
.loc_55BA:
    ld a, $06
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $01
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0607
    farcall Bank31_RuntimeBufferClear_5983
    ret
.loc_55CE:
    ld a, [$cbde]
    cp $01
    jr z, .loc_55E2
    ld a, $12
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $0f
    farcall BANK_32, Bank32_Entry_4659
    ret
.loc_55E2:
    ld a, $13
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $10
    farcall BANK_32, Bank32_Entry_4659
    ld bc, $0307
    ld a, [$def4]
    farcall BANK_27, Bank27_Entry_6A61
    ret
.loc_55F9:
    ld a, $14
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $12
    farcall BANK_32, Bank32_Entry_4659
    ret
.loc_5606:
    ld a, $15
    farcall BANK_32, Bank32_Entry_43B8
    ld a, $13
    farcall BANK_32, Bank32_Entry_4659
    ret
RuntimeEntry_Bank26_5613::
    ld hl, $5628
    ld bc, $020a
    call TextPrint
    ld a, [$deed]
    ld bc, $080a
    ld d, $02
    call RuntimeEntry_Bank00_31F5
    ret
    db $d2, $ff, $be, $2d, $e4, $8e, $20, $20, $6a, $01, $74, $9c, $67, $7f, $6c, $70, $2e, $00
RuntimeEntry_Bank26_563A::
    farcall NetworkUI_InitializeMobileMenu
    ld bc, $0104
    ld de, $120a
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, $566e
    ld bc, $0206
    call TextPrint
    call RuntimeEntry_Bank26_5613
    call FadeFromWhite8
.loc_5657:
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff91]
    bit 0, a
    jr z, .loc_5668
    ld a, $02
    call Audio_PlaySFX
    jr .loc_566A
.loc_5668:
    jr .loc_5657
.loc_566A:
    call FadeToWhite8
    ret
    db $b3, $fb, $2d, $e5, $c8, $ff, $c4, $be, $dd, $c0, $2d, $7d, $79, $01, $b1, $b8, $be, $bd, $60, $01, $6c, $ad, $63, $88, $ae, $63, $6c, $7f, $6c, $70, $2e, $00
RuntimeEntry_Bank26_568E::
    call NetworkPersistent_LoadSavedField16
    call .loc_5695
    ret
.loc_5695:
    ld d, $10
    ld hl, $cbcd
.loc_569A:
    ld a, [hli]
    cp $00
    jr nz, .loc_56A7
    dec d
    ld a, d
    cp $00
    jr z, .loc_56AA
    jr .loc_569A
.loc_56A7:
    ld a, $01
    ret
.loc_56AA:
    xor a
    ret
NetworkPersistent_LoadSavedField16::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld de, $ba7a
    ld hl, $cbcd
    ld bc, $0010
    call Memcpy
    call SRAM_Disable
    ret
RuntimeEntry_Bank26_56C4::
    ld de, $0000
    farcall NetworkRuntime_547E
    ld a, $61
    farcall BANK_0A, Bank0A_Entry_40CC
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    ld a, $62
    farcall BANK_0A, Bank0A_Entry_40CC
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    ld a, $63
    farcall BANK_0A, Bank0A_Entry_40CC
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    ld a, $32
    ld [$d85a], a
    ld a, $30
    ld [$d85b], a
    ld a, $30
    ld [$d85c], a
    ld a, $31
    ld [$d85d], a
    ld a, $30
    ld [$d85e], a
    ld a, $31
    ld [$d85f], a
    ld a, $30
    ld [$d860], a
    ld a, $31
    ld [$d861], a
    ld hl, $d85a
    ld de, $dc10
    farcall Text_ConvertGameCodeToShiftJISStream
    ld hl, $dc10
    ld bc, $0000
    farcall BANK_0A, Bank0A_Entry_40C9
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    ld a, $30
    farcall BANK_0A, Bank0A_Entry_40CC
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    ld a, $30
    farcall BANK_0A, Bank0A_Entry_40CC
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    ld hl, $d867
    ld a, [hl]
    cp $00
    jr z, .loc_574D
    jr .loc_5755
.loc_574D:
    ld hl, $d867
    ld a, $5f
    ld [hl], a
    jr .loc_5755
.loc_5755:
    ld de, $dc10
    farcall Text_ConvertGameCodeToShiftJISStream
    ld hl, $dc10
    ld bc, $0000
    farcall BANK_0A, Bank0A_Entry_40C9
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    ld a, $31
    farcall BANK_0A, Bank0A_Entry_40CC
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld de, $a0cb
    ld hl, $dc10
    ld bc, $001f
    call Memcpy
    call SRAM_Disable
    ld hl, $dc10
    ld bc, $0000
    farcall BANK_0A, Bank0A_Entry_40C9
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    farcall BANK_0A, Bank0A_Entry_40CF
    ret
RuntimeEntry_Bank26_57A6::
    ld de, $0001
    farcall NetworkRuntime_547E
    ld a, [$cbc8]
    farcall BANK_0A, Bank0A_Entry_40CC
    ld a, [$cbc7]
    farcall NetworkRuntime_54A9
    farcall BANK_0A, Bank0A_Entry_40CF
    ret
RuntimeEntry_Bank26_57C0::
    ld de, $0001
    farcall NetworkRuntime_547E
    ld a, [$cbc8]
    farcall BANK_0A, Bank0A_Entry_40CC
    ld d, $00
.loc_57D0:
    ld a, d
    cp $20
    jr z, .loc_57DD
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    inc d
    jr .loc_57D0
.loc_57DD:
    farcall BANK_0A, Bank0A_Entry_40CF
    ret
RuntimeEntry_Bank26_57E2::
    ld de, $0002
    farcall NetworkRuntime_547E
    ld a, [$cbc8]
    farcall BANK_0A, Bank0A_Entry_40CC
    farcall BANK_0A, Bank0A_Entry_40CF
    ret
RuntimeEntry_Bank26_57F5::
    ld de, $0003
    farcall NetworkRuntime_547E
    ld bc, $0007
    ld hl, $cbee
    farcall NetworkText_SkipLeadingASCIIZeroes
    farcall BANK_0A, Bank0A_Entry_40C6
    xor a
    farcall BANK_0A, Bank0A_Entry_40CC
    farcall BANK_0A, Bank0A_Entry_40CF
    ret
RuntimeEntry_Bank26_5814::
    ld de, $0005
    farcall NetworkRuntime_547E
    farcall BANK_0A, Bank0A_Entry_40CF
    ret
RuntimeEntry_Bank26_5820::
    ld de, $0007
    farcall NetworkRuntime_547E
    farcall BANK_0A, Bank0A_Entry_40CF
    ret
RuntimeEntry_Bank26_582C::
    ld a, $0f
    ld bc, $070f
    ld de, $0201
    ld h, $fb
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $090f
    ld de, $0101
    ld h, $fd
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0a0f
    ld de, $0201
    ld h, $fe
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
RuntimeEntry_Bank26_5857::
    ld a, $08
    ld bc, $070f
    ld de, $0201
    ld h, $fb
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $090f
    ld de, $0101
    ld h, $fd
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0f
    ld bc, $0a0f
    ld de, $0201
    ld h, $fe
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
RuntimeEntry_Bank26_5882::
    push af
    ld bc, $0106
    ld de, $120b
    farcall UIWindowStack_PushAndDraw
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0207
    ld de, $1009
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    pop af
    cp $00
    jr z, .loc_58DE
    cp $01
    jr z, .loc_58B1
    jr .loc_58FB
.loc_58B1:
    ld bc, $0207
    ld hl, $59cc
    call TextPut
    ld hl, $59da
    ld bc, $0208
    call TextPut
    ld a, [$c4a1]
    sla a
    farcall UnitData_CopyNameToBuffer
    ld hl, $cd28
    farcall UnitList_EncodeDisplayValue
    ld bc, $0307
    ld hl, $cd28
    call TextPut
    jr .loc_5910
.loc_58DE:
    ld bc, $0207
    ld hl, $59be
    call TextPut
    ld bc, $0607
    ld hl, $cbf1
    call TextPut
    ld hl, $59e5
    ld bc, $0208
    call TextPut
    jr .loc_5910
.loc_58FB:
    ld bc, $0207
    ld hl, $5a05
    call TextPrint
    ld bc, $0307
    ld a, [$def4]
    farcall BANK_27, Bank27_Entry_6A61
    jr .loc_5922
.loc_5910:
    ld bc, $060a
    ld hl, $59f3
    call TextPut
    ld bc, $020c
    ld hl, $59f6
    call TextPut
.loc_5922:
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    ld de, $a0cc
    ld hl, $def7
    ld bc, $0005
    call Memcpy
    ld a, $00
    ld [$defb], a
    call SRAM_Disable
    ld bc, $020a
    ld hl, $def7
    call TextPut
    ld a, $ff
    ld [$def6], a
    call RuntimeEntry_Bank26_5857
    xor a
    ld [$cac8], a
    ld [$cac9], a
.loc_5956:
    call .loc_5A36
    jr c, .loc_59B0
    farcall MapMenuMessage_ServiceFrame
    call MobileSessionTimer_Draw
    ldh a, [$ff91]
    bit 0, a
    jr z, .loc_5972
    ld a, $02
    call Audio_PlaySFX
    ld a, [$def6]
    jr .loc_59A6
.loc_5972:
    bit 1, a
    jr z, .loc_597F
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .loc_59A6
.loc_597F:
    bit 5, a
    jr z, .loc_5991
    ld a, $01
    call Audio_PlaySFX
    xor a
    ld [$def6], a
    call RuntimeEntry_Bank26_582C
    jr .loc_59A4
.loc_5991:
    bit 4, a
    jr z, .loc_59A4
    ld a, $01
    call Audio_PlaySFX
    ld a, $ff
    ld [$def6], a
    call RuntimeEntry_Bank26_5857
    jr .loc_59A4
.loc_59A4:
    jr .loc_5956
.loc_59A6:
    push af
    call DelayFrame
    farcall UIWindowStack_PopRestore
    pop af
    ret
.loc_59B0:
    call DelayFrame
    farcall UIWindowStack_PopRestore
    ld a, $01
    ld [$caca], a
    xor a
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_59be_5a35.dat
    db $3c, $4e, $4f, $2f, $20, $20, $20, $20, $3e, $20, $20, $20, $20, $00, $3c, $20
    db $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $3e, $00, $6a, $79, $9f, $70
    db $62, $60, $86, $9f, $76, $7a, $00, $6a, $79, $cf, $ff, $f4, $79, $e8, $b3, $dd
    db $db, $2d, $ec, $7a, $00, $64, $8d, $00, $66, $66, $88, $7f, $6d, $8e, $86, $8b
    db $6c, $62, $9b, $6d, $66, $3f, $00, $3c, $20, $20, $20, $20, $20, $20, $20, $20
    db $20, $20, $20, $20, $3e, $01, $6a, $79, $bb, $2d, $ee, $bd, $76, $7a, $01, $01
    db $20, $20, $20, $20, $64, $8d, $01, $01, $66, $66, $88, $7f, $6d, $8e, $20, $86
    db $8b, $6c, $62, $9b, $6d, $66, $3f, $00
.loc_5A36:
    ld a, [$cac8]
    ld h, a
    ld a, [$cac9]
    ld l, a
    inc hl
    ld a, h
    ld [$cac8], a
    ld a, l
    ld [$cac9], a
    ld de, $0e10
    call Math_CompareHLToDE
    jr z, .loc_5A51
    xor a
    ret
.loc_5A51:
    scf
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_5a53_5ab4.dat
    db $fa, $bb, $c8, $fe, $33, $20, $0e, $fa, $bc, $c8, $fe, $01, $20, $07, $fa, $bd
    db $c8, $fe, $01, $28, $02, $af, $c9, $cd, $97, $5a, $af, $c9, $01, $06, $01, $11
    db $0b, $12, $ef, $10, $fa, $68, $f0, $83, $f5, $3e, $01, $e0, $83, $e0, $4f, $af
    db $01, $07, $02, $11, $09, $10, $ef, $15, $d3, $6a, $f1, $e0, $83, $e0, $4f, $ef
    db $31, $b8, $71, $c9, $cd, $6f, $5a, $ef, $22, $0d, $62, $cd, $cc, $2a, $f0, $91
    db $cb, $47, $28, $07, $3e, $02, $cd, $44, $38, $18, $02, $18, $ea, $ef, $10, $08
    db $69, $c9
RuntimeEntry_Bank26_5AB5::
    ld a, $0f
    ld bc, $070c
    ld de, $0201
    ld h, $fb
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $090c
    ld de, $0101
    ld h, $fd
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0a0c
    ld de, $0201
    ld h, $fe
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
RuntimeEntry_Bank26_5AE0::
    ld a, $08
    ld bc, $070c
    ld de, $0201
    ld h, $fb
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $090c
    ld de, $0101
    ld h, $fd
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0f
    ld bc, $0a0c
    ld de, $0201
    ld h, $fe
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_5b0b_5b34.dat
    db $fa, $e6, $cb, $fe, $00, $28, $0c, $fe, $01, $28, $0d, $fe, $02, $28, $0f, $fe
    db $03, $28, $11, $af, $cd, $35, $5b, $c9, $3e, $01, $cd, $35, $5b, $c9, $3e, $02
    db $cd, $35, $5b, $c9, $3e, $03, $cd, $35, $5b, $c9
RuntimeEntry_Bank26_5B35::
    push af
    ld a, [$deee]
    call SpriteObject_Hide
    ld bc, $0102
    ld de, $120d
    farcall UIWindowStack_PushAndDrawAnimated
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0203
    ld de, $100b
    xor a
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    pop af
    farcall BANK_31, Bank31_Entry_70A1
    ld a, $ff
    ld [$df0a], a
    call RuntimeEntry_Bank26_5AE0
.loc_5B6C:
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff92]
    bit 0, a
    jr z, .loc_5B80
    ld a, $02
    call Audio_PlaySFX
    ld a, [$df0a]
    jr .loc_5BB4
.loc_5B80:
    bit 1, a
    jr z, .loc_5B8D
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .loc_5BB4
.loc_5B8D:
    bit 5, a
    jr z, .loc_5B9F
    ld a, $01
    call Audio_PlaySFX
    xor a
    ld [$df0a], a
    call RuntimeEntry_Bank26_5AB5
    jr .loc_5BB2
.loc_5B9F:
    bit 4, a
    jr z, .loc_5BB2
    ld a, $01
    call Audio_PlaySFX
    ld a, $ff
    ld [$df0a], a
    call RuntimeEntry_Bank26_5AE0
    jr .loc_5BB2
.loc_5BB2:
    jr .loc_5B6C
.loc_5BB4:
    push af
    farcall UIWindowStack_PopRestore
    ld a, [$deee]
    call SpriteObject_Show
    pop af
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_5bc1_5be7.dat
    db $3e, $0e, $cd, $8d, $05, $cd, $93, $05, $fa, $7a, $ba, $fe, $00, $28, $05, $3e
    db $01, $f5, $18, $0e, $af, $f5, $11, $cd, $cb, $21, $7a, $ba, $01, $10, $00, $cd
    db $50, $3b, $f1, $cd, $9b, $05, $c9
RuntimeEntry_Bank26_5BE8::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$bb3f]
    cp $ff
    jr nz, .loc_5BFC
    xor a
    call SRAM_Disable
    ret
.loc_5BFC:
    scf
    call SRAM_Disable
    ret
RuntimeEntry_Bank26_5C01::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$bb3e]
    cp $ff
    jr nz, .loc_5C15
    xor a
    call SRAM_Disable
    ret
.loc_5C15:
    scf
    call SRAM_Disable
    ret
RuntimeEntry_Bank26_5C1A::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$bb40]
    cp $ff
    jr nz, .loc_5C2E
    xor a
    call SRAM_Disable
    ret
.loc_5C2E:
    scf
    call SRAM_Disable
    ret
RuntimeEntry_Bank26_5C33::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$bb41]
    cp $ff
    jr nz, .loc_5C47
    xor a
    call SRAM_Disable
    ret
.loc_5C47:
    scf
    call SRAM_Disable
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_5c4c_5c82.dat
    db $2a, $fe, $0d, $20, $fb, $2a, $fe, $0a, $20, $f6, $c9, $3e, $0f, $cd, $8d, $05
    db $cd, $93, $05, $af, $21, $19, $cc, $01, $07, $00, $cd, $79, $3b, $11, $cf, $a0
    db $21, $19, $cc, $1a, $fe, $0d, $20, $07, $13, $1a, $fe, $0a, $28, $05, $1b, $22
    db $13, $18, $f0, $cd, $9b, $05, $c9
RuntimeEntry_Bank26_5C83::
    ld a, [$cc19]
    sub $30
    ld [$cc14], a
    ld a, [$cc1a]
    sub $30
    ld b, $0a
    call MultiplyAByB
    ld a, l
    ld c, a
    ld a, [$cc1b]
    sub $30
    add a, c
    ld [$cc15], a
    ld a, [$cc1c]
    sub $30
    ld b, $0a
    call MultiplyAByB
    ld a, l
    ld c, a
    ld a, [$cc1d]
    sub $30
    add a, c
    ld [$cc16], a
    ld a, [$cc1e]
    sub $30
    ld b, $0a
    call MultiplyAByB
    ld a, l
    ld c, a
    ld a, [$cc1f]
    sub $30
    add a, c
    ld [$cc17], a
    ret
RuntimeEntry_Bank26_5CCB::
    ld a, [$cc14]
    add a, $30
    ld [$cc19], a
    ld a, [$cc15]
    ld d, $00
    ld e, a
    ld bc, $000a
    call Math_DivideDEByBC
    ld a, e
    add a, $30
    ld [$cc1a], a
    ld a, c
    add a, $30
    ld [$cc1b], a
    ld a, [$cc16]
    ld d, $00
    ld e, a
    ld bc, $000a
    call Math_DivideDEByBC
    ld a, e
    add a, $30
    ld [$cc1c], a
    ld a, c
    add a, $30
    ld [$cc1d], a
    ld a, [$cc17]
    ld d, $00
    ld e, a
    ld bc, $000a
    call Math_DivideDEByBC
    ld a, e
    add a, $30
    ld [$cc1e], a
    ld a, c
    add a, $30
    ld [$cc1f], a
    ret
RuntimeEntry_Bank26_5D1C::
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld de, $cc14
    ld hl, $d01c
    ld bc, $0004
    call Memcpy
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
RuntimeEntry_Bank26_5D37::
    ldh a, [$ff82]
    push af
    ld a, $05
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, $0f
    call SwitchSRAMBank
    call SRAM_Enable
    ld de, $a0cc
    ld hl, $d000
    ld bc, $1000
    call Memcpy
    call SRAM_Disable
    ld de, $cbee
    ld hl, $cc19
    ld bc, $0008
    call Memcpy
    call SRAM_Enable
    ld a, $0e
    call SwitchSRAMBank
    ld a, [$cad1]
    ld [$bb3e], a
    call SRAM_Disable
    jr .loc_5D9B
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_5d76_5d9a.dat
    db $f0, $82, $f5, $3e, $05, $e0, $82, $e0, $70, $3e, $0f, $cd, $8d, $05, $cd, $93
    db $05, $21, $cc, $a0, $cd, $4c, $5c, $54, $5d, $21, $00, $d0, $01, $00, $10, $cd
    db $50, $3b, $cd, $9b, $05
.loc_5D9B:
    call SRAM_Enable
    ld a, $0e
    call SwitchSRAMBank
    call RuntimeEntry_Bank26_5C83
    call RuntimeEntry_Bank26_5D1C
    ld a, [$bb3e]
    call SRAM_Disable
    push af
    ld b, $05
    farcall MapSRAM_SaveSlotFromWRAMBank
    pop af
    farcall MapMenu_PrepareSlotSummary
    ld a, $00
    farcall BANK_26, Bank26_Entry_5E54
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_5dc7_5e53.dat
    db $fa, $0b, $cc, $fe, $ff, $28, $44, $fe, $01, $28, $0d, $fe, $0a, $28, $09, $fe
    db $02, $28, $05, $fe, $03, $28, $01, $c9, $3e, $0f, $cd, $8d, $05, $cd, $93, $05
    db $21, $cc, $a0, $ef, $19, $0b, $55, $11, $13, $5e, $cd, $71, $2d, $21, $cc, $a0
    db $ef, $19, $0b, $55, $11, $0c, $cc, $cd, $71, $2d, $21, $cc, $a0, $ef, $19, $0b
    db $55, $11, $26, $5e, $cd, $71, $2d, $cd, $9b, $05, $c9, $c9, $0d, $0a, $83, $7d
    db $83, $62, $83, $76, $82, $ce, $82, $f1, $82, $b2, $82, $a4, $0d, $0a, $00, $0d
    db $0a, $00, $d5, $3e, $0f, $cd, $8d, $05, $cd, $93, $05, $d1, $21, $cc, $a0, $01
    db $00, $10, $cd, $50, $3b, $cd, $9b, $05, $c9, $f5, $cd, $29, $5e, $cd, $c7, $5d
    db $21, $cc, $a0, $f1, $ef, $22, $19, $7c, $ef, $22, $f1, $7d, $c9
RuntimeEntry_Bank26_5E54::
    ld d, a
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, d
    cp $00
    jr z, .loc_5E70
    cp $01
    jr z, .loc_5E77
    cp $02
    jr z, .loc_5E7E
    cp $03
    jr z, .loc_5E85
    jr .loc_5E8C
.loc_5E70:
    ld a, $ff
    ld [$bb3e], a
    jr .loc_5E8C
.loc_5E77:
    ld a, $ff
    ld [$bb3f], a
    jr .loc_5E8C
.loc_5E7E:
    ld a, $ff
    ld [$bb40], a
    jr .loc_5E8C
.loc_5E85:
    ld a, $ff
    ld [$bb41], a
    jr .loc_5E8C
.loc_5E8C:
    call SRAM_Disable
    ret
Campaign26_5E90_5E90::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld hl, $ba8a
    ld bc, $00b4
    xor a
    call Memset
    ld a, $ff
    ld [$bb3f], a
    ld [$bb3e], a
    ld [$bb40], a
    ld [$bb41], a
    call SRAM_Disable
    ret
    db $3e, $0f, $cd, $8d, $05, $cd, $93, $05, $af, $21, $0b, $df, $01, $06, $00, $cd
    db $79, $3b, $11, $cc, $a0, $21, $0b, $df, $01, $05, $00, $cd, $50, $3b, $3e, $0e
    db $cd, $8d, $05, $fa, $7a, $ba, $fe, $00, $28, $26, $11, $0b, $df, $21, $b9, $4a
    db $ef, $0a, $53, $4a, $30, $05, $cd, $9b, $05, $af, $c9, $3e, $0e, $cd, $8d, $05
    db $21, $7a, $ba, $01, $10, $00, $af, $cd, $79, $3b, $cd, $9b, $05, $3e, $01, $c9
    db $11, $0b, $df, $21, $b9, $4a, $ef, $0a, $53, $4a, $30, $02, $18, $06, $cd, $9b
    db $05, $3e, $02, $c9, $cd, $9b, $05, $3e, $ff, $c9, $fe, $00, $28, $19, $fe, $01
    db $ca, $07, $60, $fe, $02, $ca, $5e, $61, $fe, $03, $ca, $bf, $61, $fe, $06, $ca
    db $45, $62, $fe, $08, $ca, $8a, $62, $ef, $31, $cb, $6f, $da, $de, $5f, $cd, $b4
    db $5e, $fe, $00, $28, $22, $fe, $01, $28, $04, $fe, $02, $28, $07, $cd, $90, $5e
    db $ef, $0a, $00, $40, $11, $82, $d6, $21, $cd, $cb, $01, $10, $00, $cd, $50, $3b
    db $cd, $c1, $5b, $fe, $00, $28, $0f, $3e, $ff, $ea, $0b, $cc, $11, $57, $64, $3e
    db $ff, $cd, $40, $5e, $18, $0d, $3e, $ff, $ea, $0b, $cc, $11, $61, $63, $3e, $ff
    db $cd, $40, $5e, $fa, $e8, $de, $3c, $ea, $e8, $de, $3e, $0e, $cd, $8d, $05, $cd
    db $93, $05, $11, $42, $bb, $21, $e9, $cb, $01, $05, $00, $cd, $50, $3b, $af, $21
    db $42, $bb, $01, $05, $00, $cd, $79, $3b, $fa, $5d, $bb, $fe, $01, $28, $09, $fa
    db $5e, $bb, $fe, $01, $28, $10, $18, $1a, $af, $ea, $5d, $bb, $3e, $01, $ea, $5c
    db $bb, $cd, $9b, $05, $18, $0c, $af, $ea, $5e, $bb, $ea, $5c, $bb, $cd, $9b, $05
    db $18, $00, $21, $e9, $cb, $ef, $0a, $54, $48, $c9, $fe, $00, $c2, $98, $62, $21
    db $82, $d6, $7e, $fe, $00, $28, $0e, $3e, $ff, $ea, $0b, $cc, $11, $92, $66, $3e
    db $ff, $cd, $40, $5e, $c9, $3e, $ff, $ea, $0b, $cc, $11, $19, $66, $3e, $ff, $cd
    db $40, $5e, $c9, $cd, $e8, $5b, $38, $06, $cd, $1a, $5c, $da, $bd, $60, $ef, $31
    db $cb, $6f, $da, $a5, $60, $3e, $0f, $cd, $8d, $05, $cd, $93, $05, $11, $cf, $a0
    db $21, $a8, $da, $01, $07, $00, $cd, $50, $3b, $3e, $0e, $cd, $8d, $05, $fa, $3f
    db $bb, $ef, $13, $59, $45, $e5, $01, $0a, $00, $09, $11, $a8, $da, $01, $07, $00
    db $cd, $50, $3b, $11, $a8, $da, $21, $0c, $cc, $01, $07, $00, $cd, $50, $3b, $af
    db $ea, $13, $cc, $e1, $01, $00, $00, $09, $3e, $01, $77, $cd, $9b, $05, $3e, $01
    db $ef, $26, $54, $5e, $3e, $01, $ea, $0b, $cc, $11, $c8, $64, $3e, $ff, $cd, $40
    db $5e, $fa, $e9, $de, $3c, $ea, $e9, $de, $3e, $0e, $cd, $8d, $05, $cd, $93, $05
    db $11, $47, $bb, $21, $e9, $cb, $01, $05, $00, $cd, $50, $3b, $af, $21, $47, $bb
    db $01, $05, $00, $cd, $79, $3b, $cd, $9b, $05, $21, $e9, $cb, $ef, $0a, $54, $48
    db $c9, $fe, $00, $c2, $98, $62, $3e, $ff, $ea, $0b, $cc, $11, $2d, $68, $3e, $ff
    db $cd, $40, $5e, $3e, $01, $cd, $54, $5e, $c9, $ef, $31, $cb, $6f, $da, $46, $61
    db $3e, $0f, $cd, $8d, $05, $cd, $93, $05, $11, $cf, $a0, $21, $a8, $da, $01, $07
    db $00, $cd, $50, $3b, $11, $a8, $da, $21, $0c, $cc, $01, $07, $00, $cd, $50, $3b
    db $af, $ea, $13, $cc, $cd, $9b, $05, $3e, $0e, $cd, $8d, $05, $cd, $93, $05, $fa
    db $40, $bb, $ef, $13, $59, $45, $01, $00, $00, $09, $af, $77, $cd, $9b, $05, $3e
    db $02, $ef, $26, $54, $5e, $3e, $0a, $ea, $0b, $cc, $11, $2a, $65, $3e, $ff, $cd
    db $40, $5e, $fa, $eb, $de, $3c, $ea, $eb, $de, $3e, $0e, $cd, $8d, $05, $cd, $93
    db $05, $11, $56, $bb, $21, $e9, $cb, $01, $05, $00, $cd, $50, $3b, $af, $21, $56
    db $bb, $01, $05, $00, $cd, $79, $3b, $cd, $9b, $05, $21, $e9, $cb, $ef, $0a, $54
    db $48, $c9, $fe, $00, $c2, $98, $62, $3e, $ff, $ea, $0b, $cc, $11, $a7, $68, $3e
    db $ff, $cd, $40, $5e, $3e, $02, $cd, $54, $5e, $c9, $ef, $31, $cb, $6f, $38, $43
    db $3e, $03, $ef, $26, $54, $5e, $3e, $02, $ea, $0b, $cc, $11, $89, $65, $3e, $ff
    db $cd, $40, $5e, $fa, $ec, $de, $3c, $ea, $ec, $de, $3e, $0e, $cd, $8d, $05, $cd
    db $93, $05, $11, $4c, $bb, $21, $e9, $cb, $01, $05, $00, $cd, $50, $3b, $af, $21
    db $4c, $bb, $01, $05, $00, $cd, $79, $3b, $cd, $9b, $05, $21, $e9, $cb, $ef, $0a
    db $54, $48, $c9, $fe, $00, $c2, $98, $62, $3e, $ff, $ea, $0b, $cc, $11, $13, $67
    db $3e, $ff, $cd, $40, $5e, $3e, $03, $cd, $54, $5e, $c9, $ef, $31, $cb, $6f, $38
    db $4f, $cd, $57, $5c, $cd, $76, $5d, $11, $19, $cc, $21, $0c, $cc, $01, $07, $00
    db $cd, $50, $3b, $3e, $03, $ea, $0b, $cc, $11, $e8, $65, $3e, $ff, $cd, $40, $5e
    db $fa, $ea, $de, $3c, $ea, $ea, $de, $3e, $0e, $cd, $8d, $05, $cd, $93, $05, $11
    db $51, $bb, $21, $e9, $cb, $01, $05, $00, $cd, $50, $3b, $af, $21, $51, $bb, $01
    db $05, $00, $cd, $79, $3b, $cd, $9b, $05, $21, $e9, $cb, $ef, $0a, $54, $48, $c9
    db $fe, $00, $28, $07, $fe, $01, $28, $16, $c3, $98, $62, $3e, $ff, $ea, $0b, $cc
    db $11, $8a, $67, $3e, $ff, $cd, $40, $5e, $3e, $00, $cd, $54, $5e, $c9, $3e, $ff
    db $ea, $0b, $cc, $11, $04, $68, $3e, $ff, $cd, $40, $5e, $3e, $00, $cd, $54, $5e
    db $c9, $3e, $0f, $cd, $8d, $05, $cd, $93, $05, $21, $cf, $a0, $2a, $e5, $d6, $30
    db $06, $0a, $cd, $95, $29, $7d, $4f, $e1, $7e, $d6, $30, $81, $4f, $fa, $d0, $ca
    db $81, $ea, $d0, $ca, $21, $d3, $a0, $7e, $fe, $00, $28, $0f, $cd, $9b, $05, $3e
    db $ff, $ef, $22, $19, $7c, $ef, $22, $f1, $7d, $18, $03, $cd, $9b, $05, $fa, $d0
    db $ca, $ef, $31, $9c, $60, $c9, $21, $cc, $a0, $3e, $ff, $ef, $22, $19, $7c, $ef
    db $22, $f1, $7d, $c9, $fe, $02, $28, $12, $fe, $03, $28, $1c, $3e, $ff, $ea, $0b
    db $cc, $11, $ca, $62, $3e, $ff, $cd, $40, $5e, $c9, $3e, $ff, $ea, $0b, $cc, $11
    db $1e, $69, $3e, $ff, $cd, $40, $5e, $c9, $3e, $ff, $ea, $0b, $cc, $11, $5b, $69
    db $3e, $ff, $cd, $40, $5e, $c9, $83, $45, $83, $48, $2d, $83, $59, $83, $6c, $83
    db $62, $83, $67, $83, $54, $2d, $83, $72, $83, $58, $82, $d6, $82, $cc, $0d, $0a
    db $82, $c2, $82, $a4, $82, $b5, $82, $f1, $82, $cd, $82, $b5, $82, $c1, $82, $cf
    db $82, $a2, $82, $b5, $82, $dc, $82, $b5, $82, $bd, $2e, $0d, $0a, $0d, $0a, $82
    db $c6, $82, $e8, $82, $a0, $82, $c2, $82, $a9, $82, $a2, $82, $b9, $82, $c2, $82
    db $df, $82, $a2, $82, $b5, $82, $e5, $82, $f0, $0d, $0a, $82, $b2, $82, $e7, $82
    db $f1, $82, $cc, $82, $a4, $82, $a6, $0d, $0a, $82, $b5, $82, $ce, $82, $e7, $82
    db $ad, $82, $b5, $82, $c4, $82, $a9, $82, $e7, $0d, $0a, $82, $e0, $82, $a4, $82
    db $a2, $82, $bf, $82, $c7, $82, $e2, $82, $e8, $82, $c8, $82, $a8, $82, $b5, $82
    db $c4, $82, $ad, $82, $be, $82, $b3, $82, $a2, $2e, $0d, $0a, $00, $83, $45, $83
    db $48, $2d, $83, $59, $83, $6c, $83, $62, $83, $67, $82, $d6, $82, $e6, $82, $a4
    db $82, $b1, $82, $bb, $21, $0d, $0a, $0d, $0a, $83, $45, $83, $48, $2d, $83, $59
    db $83, $6c, $83, $62, $83, $67, $82, $cc, $0d, $0a, $83, $86, $2d, $83, $55, $2d
    db $82, $c6, $82, $a4, $82, $eb, $82, $ad, $82, $aa, $0d, $0a, $82, $a9, $82, $f1
    db $82, $e8, $82, $e5, $82, $a4, $82, $b5, $82, $dc, $82, $b5, $82, $bd, $2e, $0d
    db $0a, $0d, $0a, $83, $45, $83, $48, $2d, $83, $59, $83, $6c, $83, $62, $83, $67
    db $82, $c6, $82, $cd, $0d, $0a, $83, $82, $83, $6f, $83, $43, $83, $8b, $83, $41
    db $83, $5f, $83, $76, $83, $5e, $47, $42, $82, $f0, $82, $c2, $82, $a9, $82, $c1
    db $82, $c4, $0d, $0a, $5b, $83, $51, $2d, $83, $80, $83, $7b, $2d, $83, $43, $83
    db $45, $83, $48, $2d, $83, $59, $0d, $0a, $83, $7c, $83, $50, $83, $62, $83, $67
    db $83, $5e, $83, $4e, $83, $65, $83, $42, $83, $4e, $83, $58, $5d, $82, $f0, $0d
    db $0a, $82, $bd, $82, $cc, $82, $b5, $82, $de, $82, $bd, $82, $df, $82, $cc, $83
    db $54, $2d, $83, $72, $83, $58, $82, $c5, $82, $b7, $2e, $0d, $0a, $0d, $0a, $82
    db $c6, $82, $a4, $82, $eb, $82, $ad, $0d, $0a, $82, $a0, $82, $e8, $82, $aa, $82
    db $c6, $82, $a4, $82, $b2, $82, $b4, $82, $a2, $82, $dc, $82, $b5, $82, $bd, $2e
    db $0d, $0a, $00, $83, $45, $83, $48, $2d, $83, $59, $83, $6c, $83, $62, $83, $67
    db $82, $cc, $0d, $0a, $83, $86, $2d, $83, $55, $2d, $82, $c6, $82, $a4, $82, $eb
    db $82, $ad, $82, $d6, $82, $f1, $82, $b1, $82, $a4, $82, $aa, $0d, $0a, $82, $a9
    db $82, $f1, $82, $e8, $82, $e5, $82, $a4, $82, $b5, $82, $dc, $82, $b5, $82, $bd
    db $2e, $0d, $0a, $0d, $0a, $82, $b1, $82, $ea, $82, $a9, $82, $e7, $82, $e0, $83
    db $45, $83, $48, $2d, $83, $59, $83, $6c, $83, $62, $83, $67, $82, $f0, $0d, $0a
    db $82, $b2, $82, $e8, $82, $e6, $82, $a4, $82, $ad, $82, $be, $82, $b3, $82, $a2
    db $2e, $0d, $0a, $00, $83, $7d, $83, $62, $83, $76, $83, $66, $2d, $83, $5e, $82
    db $cc, $83, $41, $83, $62, $83, $76, $83, $8d, $2d, $83, $68, $82, $aa, $0d, $0a
    db $82, $a9, $82, $f1, $82, $e8, $82, $e5, $82, $a4, $82, $b5, $82, $dc, $82, $b5
    db $82, $bd, $2e, $0d, $0a, $0d, $0a, $82, $b1, $82, $ea, $82, $a9, $82, $e7, $82
    db $e0, $83, $45, $83, $48, $2d, $83, $59, $83, $6c, $83, $62, $83, $67, $82, $f0
    db $0d, $0a, $82, $b2, $82, $e8, $82, $e6, $82, $a4, $82, $ad, $82, $be, $82, $b3
    db $82, $a2, $2e, $0d, $0a, $00, $83, $7d, $83, $62, $83, $76, $83, $66, $2d, $83
    db $5e, $82, $cc, $82, $b3, $82, $ad, $82, $b6, $82, $e5, $82, $aa, $0d, $0a, $82
    db $a9, $82, $f1, $82, $e8, $82, $e5, $82, $a4, $82, $b5, $82, $dc, $82, $b5, $82
    db $bd, $2e, $0d, $0a, $0d, $0a, $82, $b1, $82, $ea, $82, $a9, $82, $e7, $82, $e0
    db $83, $45, $83, $48, $2d, $83, $59, $83, $6c, $83, $62, $83, $67, $82, $f0, $0d
    db $0a, $82, $b2, $82, $e8, $82, $e6, $82, $a4, $82, $ad, $82, $be, $82, $b3, $82
    db $a2, $2e, $0d, $0a, $00, $83, $7d, $83, $62, $83, $76, $83, $66, $2d, $83, $5e
    db $82, $cc, $82, $c6, $82, $a4, $82, $b1, $82, $a4, $82, $aa, $0d, $0a, $82, $a9
    db $82, $f1, $82, $e8, $82, $e5, $82, $a4, $82, $b5, $82, $dc, $82, $b5, $82, $bd
    db $2e, $0d, $0a, $0d, $0a, $82, $b1, $82, $ea, $82, $a9, $82, $e7, $82, $e0, $83
    db $45, $83, $48, $2d, $83, $59, $83, $6c, $83, $62, $83, $67, $82, $f0, $0d, $0a
    db $82, $b2, $82, $e8, $82, $e6, $82, $a4, $82, $ad, $82, $be, $82, $b3, $82, $a2
    db $2e, $0d, $0a, $00, $83, $7d, $83, $62, $83, $76, $83, $66, $2d, $83, $5e, $82
    db $cc, $83, $5f, $83, $45, $83, $93, $83, $8d, $2d, $83, $68, $82, $aa, $0d, $0a
    db $82, $a9, $82, $f1, $82, $e8, $82, $e5, $82, $a4, $82, $b5, $82, $dc, $82, $b5
    db $82, $bd, $0d, $0a, $00, $82, $b0, $82, $f1, $82, $b4, $82, $a2, $83, $45, $83
    db $48, $2d, $83, $59, $83, $6c, $83, $62, $83, $67, $0d, $0a, $83, $86, $2d, $83
    db $55, $2d, $82, $c6, $82, $a4, $82, $eb, $82, $ad, $83, $54, $2d, $83, $72, $83
    db $58, $82, $cd, $0d, $0a, $82, $c4, $82, $a2, $82, $b5, $82, $bf, $82, $e3, $82
    db $a4, $82, $c5, $82, $b7, $2e, $0d, $0a, $0d, $0a, $82, $b5, $82, $ce, $82, $e7
    db $82, $ad, $82, $b5, $82, $c4, $82, $a9, $82, $e7, $0d, $0a, $82, $e0, $82, $a4
    db $82, $a2, $82, $bf, $82, $c7, $82, $e2, $82, $e8, $82, $c8, $82, $a8, $82, $b5
    db $82, $c4, $82, $ad, $82, $be, $82, $b3, $82, $a2, $2e, $0d, $0a, $00, $82, $b0
    db $82, $f1, $82, $b4, $82, $a2, $83, $45, $83, $48, $2d, $83, $59, $83, $6c, $83
    db $62, $83, $67, $0d, $0a, $83, $86, $2d, $83, $55, $2d, $82, $c6, $82, $a4, $82
    db $eb, $82, $ad, $82, $d6, $82, $f1, $82, $b1, $82, $a4, $83, $54, $2d, $83, $72
    db $83, $58, $82, $cd, $0d, $0a, $82, $c4, $82, $a2, $82, $b5, $82, $bf, $82, $e3
    db $82, $a4, $82, $c5, $82, $b7, $2e, $0d, $0a, $0d, $0a, $82, $b5, $82, $ce, $82
    db $e7, $82, $ad, $82, $b5, $82, $c4, $82, $a9, $82, $e7, $0d, $0a, $82, $e0, $82
    db $a4, $82, $a2, $82, $bf, $82, $c7, $82, $e2, $82, $e8, $82, $c8, $82, $a8, $82
    db $b5, $82, $c4, $82, $ad, $82, $be, $82, $b3, $82, $a2, $2e, $0d, $0a, $00, $82
    db $b0, $82, $f1, $82, $b4, $82, $a2, $0d, $0a, $83, $7d, $83, $62, $83, $76, $83
    db $66, $2d, $83, $5e, $82, $cc, $0d, $0a, $82, $c6, $82, $a4, $82, $b1, $82, $a4
    db $83, $54, $2d, $83, $72, $83, $58, $82, $cd, $0d, $0a, $82, $ab, $82, $e3, $82
    db $a4, $82, $b5, $82, $bf, $82, $e3, $82, $a4, $82, $c5, $82, $b7, $2e, $0d, $0a
    db $0d, $0a, $82, $b5, $82, $ce, $82, $e7, $82, $ad, $82, $b5, $82, $c4, $82, $a9
    db $82, $e7, $0d, $0a, $82, $e0, $82, $a4, $82, $a2, $82, $bf, $82, $c7, $82, $e2
    db $82, $e8, $82, $c8, $82, $a8, $82, $b5, $82, $c4, $82, $ad, $82, $be, $82, $b3
    db $82, $a2, $2e, $0d, $0a, $00, $82, $b0, $82, $f1, $82, $b4, $82, $a2, $0d, $0a
    db $83, $7d, $83, $62, $83, $76, $83, $66, $2d, $83, $5e, $82, $cc, $0d, $0a, $83
    db $5f, $83, $45, $83, $93, $83, $8d, $2d, $83, $68, $83, $54, $2d, $83, $72, $83
    db $58, $82, $cd, $0d, $0a, $82, $ab, $82, $e3, $82, $a4, $82, $b5, $82, $bf, $82
    db $e3, $82, $a4, $82, $c5, $82, $b7, $2e, $0d, $0a, $0d, $0a, $82, $b5, $82, $ce
    db $82, $e7, $82, $ad, $82, $b5, $82, $c4, $82, $a9, $82, $e7, $0d, $0a, $82, $e0
    db $82, $a4, $82, $a2, $82, $bf, $82, $c7, $82, $e2, $82, $e8, $82, $c8, $82, $a8
    db $82, $b5, $82, $c4, $82, $ad, $82, $be, $82, $b3, $82, $a2, $2e, $0d, $0a, $00
    db $82, $bb, $82, $f1, $82, $b4, $82, $a2, $82, $b5, $82, $c4, $82, $a2, $82, $c8
    db $82, $a2, $0d, $0a, $83, $7d, $83, $62, $83, $76, $82, $ce, $82, $f1, $82, $b2
    db $82, $a4, $82, $c5, $82, $b7, $0d, $0a, $00, $82, $b0, $82, $f1, $82, $b4, $82
    db $a2, $0d, $0a, $83, $7d, $83, $62, $83, $76, $83, $66, $2d, $83, $5e, $82, $cc
    db $0d, $0a, $83, $41, $83, $62, $83, $76, $83, $8d, $2d, $83, $68, $83, $54, $2d
    db $83, $72, $83, $58, $82, $cd, $0d, $0a, $82, $ab, $82, $e3, $82, $a4, $82, $b5
    db $82, $bf, $82, $e3, $82, $a4, $82, $c5, $82, $b7, $2e, $0d, $0a, $0d, $0a, $82
    db $b5, $82, $ce, $82, $e7, $82, $ad, $82, $b5, $82, $c4, $82, $a9, $82, $e7, $0d
    db $0a, $82, $e0, $82, $a4, $82, $a2, $82, $bf, $82, $c7, $82, $e2, $82, $e8, $82
    db $c8, $82, $a8, $82, $b5, $82, $c4, $82, $ad, $82, $be, $82, $b3, $82, $a2, $2e
    db $0d, $0a, $00, $82, $b0, $82, $f1, $82, $b4, $82, $a2, $0d, $0a, $83, $7d, $83
    db $62, $83, $76, $83, $66, $2d, $83, $5e, $82, $cc, $0d, $0a, $82, $b3, $82, $ad
    db $82, $b6, $82, $e5, $83, $54, $2d, $83, $72, $83, $58, $82, $cd, $0d, $0a, $82
    db $ab, $82, $e3, $82, $a4, $82, $b5, $82, $bf, $82, $e3, $82, $a4, $82, $c5, $82
    db $b7, $2e, $0d, $0a, $0d, $0a, $82, $b5, $82, $ce, $82, $e7, $82, $ad, $82, $b5
    db $82, $c4, $82, $a9, $82, $e7, $0d, $0a, $82, $e0, $82, $a4, $82, $a2, $82, $bf
    db $82, $c7, $82, $e2, $82, $e8, $82, $c8, $82, $a8, $82, $b5, $82, $c4, $82, $ad
    db $82, $be, $82, $b3, $82, $a2, $2e, $0d, $0a, $00, $82, $c2, $82, $a4, $82, $b5
    db $82, $f1, $82, $c9, $82, $b5, $82, $c1, $82, $cf, $82, $a2, $82, $b5, $82, $dc
    db $82, $b5, $82, $bd, $0d, $0a, $82, $e0, $82, $a4, $82, $a2, $82, $bf, $82, $c7
    db $82, $bb, $82, $a4, $82, $b5, $82, $f1, $82, $b5, $82, $c4, $82, $ad, $82, $be
    db $82, $b3, $82, $a2, $0d, $0a, $00, $82, $c2, $82, $a4, $82, $b5, $82, $f1, $82
    db $c9, $82, $b5, $82, $c1, $82, $cf, $82, $a2, $82, $b5, $82, $dc, $82, $b5, $82
    db $bd, $0d, $0a, $82, $e0, $82, $a4, $82, $a2, $82, $bf, $82, $c7, $82, $bb, $82
    db $a4, $82, $b5, $82, $f1, $82, $b5, $82, $c4, $82, $ad, $82, $be, $82, $b3, $82
    db $a2, $0d, $0a, $82, $d3, $82, $bd, $82, $bd, $82, $d1, $82, $a8, $82, $b1, $82
    db $e9, $82, $ce, $82, $a0, $82, $a2, $82, $cd, $0d, $0a, $83, $86, $2d, $83, $55
    db $2d, $82, $c6, $82, $a4, $82, $eb, $82, $ad, $82, $f0, $82, $b5, $82, $c8, $82
    db $a8, $82, $b5, $82, $c4, $0d, $0a, $82, $ad, $82, $be, $82, $b3, $82, $a2, $0d
    db $0a, $00
RuntimeEntry_Bank26_69D6::
    ld a, [$cace]
    cp $01
    jr z, .loc_6A25
    ld a, [$cc21]
    cp $00
    jr nz, .loc_6A25
    ld a, [$cbc7]
    add a, a
    ld hl, $391c
    call AddAtoHL
    ld a, [hli]
    ld a, a
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [hl]
    ld h, a
    ld l, $00
    ld bc, $0020
    add hl, bc
    ld d, h
    ld e, l
    ld hl, $cbcd
    ld bc, $0008
    call Memcpy
    ld a, $0e
    call SwitchSRAMBank
    ld a, [$bb3f]
    farcall BANK_13, Bank13_Entry_4559
    ld bc, $0001
    add hl, bc
    ld de, $cbcd
    ld bc, $0008
    call Memcpy
    call SRAM_Disable
.loc_6A25:
    ret
    assert @ == $6A26

SECTION "Remaining ROM 26:6A42-7FFF", ROMX[$6A42], BANK[$26]
RemainingROM_Bank26_6A42::
    ; Source-owned structural data formerly data/campaign/structural/bank26_6a42_71ab.bin
    ds $12, $00
    db $10, $00, $10, $00, $10, $00, $18, $00, $18, $00, $00, $00, $08, $00, $00, $00
    db $d8, $00, $d8, $00, $48, $00, $d8, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $48, $00, $fc, $00, $48, $00, $48, $00, $48, $00, $fc, $00, $48, $00, $00, $00
    db $10, $00, $fe, $00, $90, $00, $fe, $00, $16, $00, $fe, $00, $10, $00, $00, $00
    db $e2, $00, $a4, $00, $e8, $00, $10, $00, $2e, $00, $4a, $00, $8e, $00, $00, $00
    db $7c, $00, $40, $00, $44, $00, $7e, $00, $c4, $00, $c4, $00, $fc, $00, $00, $00
    db $30, $00, $30, $00, $10, $00, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0c, $00, $08, $00, $18, $00, $18, $00, $18, $00, $08, $00, $0c, $00, $00, $00
    db $60, $00, $20, $00, $30, $00, $30, $00, $30, $00, $20, $00, $60, $00, $00, $00
    db $00, $00, $10, $00, $7c, $00, $38, $00, $28, $00, $00, $00, $00, $00, $00, $00
    db $10, $00, $10, $00, $10, $00, $fe, $00, $10, $00, $10, $00, $10, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $30, $00, $30, $00, $10, $00, $30, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $fe
    ds $11, $00
    db $60, $00, $60, $00, $00, $00, $00, $00, $02, $00, $06, $00, $0c, $00, $18, $00
    db $30, $00, $60, $00, $40, $00, $00, $00, $fe, $00, $82, $00, $ba, $00, $aa, $00
    db $be, $00, $80, $00, $fe, $00, $00, $00, $7c, $00, $44, $00, $44, $00, $44, $00
    db $fe, $00, $c2, $00, $c2, $00, $00, $00, $7c, $00, $44, $00, $44, $00, $7e, $00
    db $62, $00, $62, $00, $7e, $00, $00, $00, $7e, $00, $46, $00, $46, $00, $40, $00
    db $42, $00, $42, $00, $7e, $00, $00, $00, $7c, $00, $42, $00, $42, $00, $62, $00
    db $62, $00, $62, $00, $7c, $00, $00, $00, $7e, $00, $40, $00, $40, $00, $7e, $00
    db $60, $00, $60, $00, $7e, $00, $00, $00, $7e, $00, $40, $00, $40, $00, $7c, $00
    db $60, $00, $60, $00, $60, $00, $00, $00, $7e, $00, $42, $00, $42, $00, $40, $00
    db $4e, $00, $46, $00, $7e, $00, $00, $00, $42, $00, $42, $00, $42, $00, $7e, $00
    db $62, $00, $62, $00, $62, $00, $00, $00, $10, $00, $10, $00, $10, $00, $18, $00
    db $18, $00, $18, $00, $18, $00, $00, $00, $0c, $00, $0c, $00, $0c, $00, $0c, $00
    db $04, $00, $04, $00, $3c, $00, $00, $00, $48, $00, $48, $00, $48, $00, $7e, $00
    db $62, $00, $62, $00, $62, $00, $00, $00, $40, $00, $40, $00, $40, $00, $60, $00
    db $70, $00, $70, $00, $7c, $00, $00, $00, $fe, $00, $92, $00, $92, $00, $d2, $00
    db $d2, $00, $d2, $00, $d2, $00, $00, $00, $62, $00, $52, $00, $52, $00, $4a, $00
    db $6a, $00, $66, $00, $62, $00, $00, $00, $7e, $00, $42, $00, $42, $00, $62, $00
    db $62, $00, $62, $00, $7e, $00, $00, $00, $7e, $00, $42, $00, $42, $00, $7e, $00
    db $60, $00, $60, $00, $60, $00, $00, $00, $7e, $00, $42, $00, $42, $00, $42, $00
    db $42, $00, $7e, $00, $0e, $00, $00, $00, $7c, $00, $44, $00, $44, $00, $7e, $00
    db $62, $00, $62, $00, $62, $00, $00, $00, $7e, $00, $42, $00, $40, $00, $7e, $00
    db $06, $00, $46, $00, $7e, $00, $00, $00, $7e, $00, $0e, $00, $08, $00, $08, $00
    db $08, $00, $08, $00, $08, $00, $00, $00, $42, $00, $42, $00, $42, $00, $62, $00
    db $62, $00, $62, $00, $7e, $00, $00, $00, $62, $00, $62, $00, $62, $00, $26, $00
    db $24, $00, $24, $00, $3c, $00, $00, $00, $92, $00, $92, $00, $92, $00, $d2, $00
    db $d2, $00, $d2, $00, $fe, $00, $00, $00, $86, $00, $46, $00, $2c, $00, $10, $00
    db $68, $00, $c4, $00, $c2, $00, $00, $00, $42, $00, $42, $00, $42, $00, $7e, $00
    db $18, $00, $18, $00, $18, $00, $00, $00, $7e, $00, $42, $00, $04, $00, $18, $00
    db $30, $00, $62, $00, $7e, $00, $00, $00, $18, $00, $10, $00, $10, $00, $10, $00
    db $10, $00, $10, $00, $18, $00, $00, $00, $22, $00, $14, $00, $3e, $00, $08, $00
    db $3e, $00, $08, $00, $08, $00, $00, $00, $18, $00, $08, $00, $08, $00, $08, $00
    db $08, $00, $08, $00, $18, $00, $00, $00, $18, $00, $24
    ds $19, $00
    db $7e, $00, $00, $00, $7e, $00, $46, $00, $4a, $00, $72, $00, $62, $00, $62, $00
    db $7e, $00, $00, $00, $10, $00, $10, $00, $10, $00, $18, $00, $18, $00, $18, $00
    db $18, $00, $00, $00, $7e, $00, $02, $00, $02, $00, $7e, $00, $60, $00, $60, $00
    db $7e, $00, $00, $00, $7e, $00, $02, $00, $02, $00, $3e, $00, $06, $00, $06, $00
    db $7e, $00, $00, $00, $7c, $00, $44, $00, $44, $00, $44, $00, $7e, $00, $0c, $00
    db $0c, $00, $00, $00, $7c, $00, $40, $00, $40, $00, $7e, $00, $06, $00, $06, $00
    db $7e, $00, $00, $00, $3e, $00, $40, $00, $40, $00, $7e, $00, $62, $00, $62, $00
    db $7e, $00, $00, $00, $7e, $00, $02, $00, $02, $00, $06, $00, $06, $00, $06, $00
    db $06, $00, $00, $00, $7e, $00, $42, $00, $42, $00, $7e, $00, $62, $00, $62, $00
    db $7e, $00, $00, $00, $7e, $00, $42, $00, $42, $00, $7e, $00, $06, $00, $06, $00
    db $06, $00, $00, $00, $00, $00, $18, $00, $18, $00, $00, $00, $18, $00, $18, $00
    db $00, $00, $00, $00, $18, $00, $18, $00, $00, $00, $18, $00, $18, $00, $08, $00
    db $18, $00, $00, $00, $00, $00, $02, $00, $1c, $00, $70, $00, $1c, $00, $02, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $7e, $00, $00, $00, $7e, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $40, $00, $38, $00, $0e, $00, $38, $00, $40, $00
    db $00, $00, $00, $00, $3e, $00, $02, $00, $02, $00, $3e, $00, $30, $00, $00, $00
    db $10, $00, $00, $00, $18, $00, $18
    ds $2ad, $00
    db $18, $00, $10, $00, $10, $00, $20, $00, $10, $00, $10, $00, $18, $00, $00, $00
    db $10, $00, $10, $00, $10, $00, $10, $00, $10, $00, $10, $00, $10, $00, $00, $00
    db $18, $00, $08, $00, $08, $00, $04, $00, $08, $00, $08, $00, $18, $00, $00, $00
    db $16, $00, $68, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $df, $02, $ff, $7f, $9f, $53
    ds $38, $00
    db $01, $fc, $fc, $00, $00, $01, $fc, $fc, $01, $00, $72, $71, $1e, $77, $71, $1e
    ds $12, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $00, $00, $df, $02, $ff, $7f, $9f, $53
RuntimeEntry_Bank26_71AC::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $19
    ld bc, $0000
    ld de, $1410
    farcall Gfx_TilemapFill
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $02
    ld bc, $0000
    ld de, $1410
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ret
Campaign26_71D9_71D9::
    ld bc, $0015
    ld hl, $4b70
    add hl, bc
    ld a, h
    ld [$cc58], a
    ld a, l
    ld [$cc59], a
    ld hl, $4df0
    add hl, bc
    ld a, h
    ld [$cc5a], a
    ld a, l
    ld [$cc5b], a
    ld a, $01
    ld [$cc52], a
    ld a, $01
    ld [$cc53], a
    ld a, $08
    ld [$cc56], a
    ld a, $01
    ld [$cc57], a
    ld a, $22
    ld [$cc61], a
    ld [$cc62], a
    call RemainingROM_Bank00_36C4
    ld bc, $0029
    ld hl, $4b70
    add hl, bc
    ld a, h
    ld [$cc58], a
    ld a, l
    ld [$cc59], a
    ld hl, $4df0
    add hl, bc
    ld a, h
    ld [$cc5a], a
    ld a, l
    ld [$cc5b], a
    ld a, $01
    ld [$cc52], a
    ld a, $02
    ld [$cc53], a
    ld a, $08
    ld [$cc56], a
    ld a, $01
    ld [$cc57], a
    ld a, $22
    ld [$cc61], a
    ld [$cc62], a
    call RemainingROM_Bank00_36C4
    ld bc, $003d
    ld hl, $4b70
    add hl, bc
    ld a, h
    ld [$cc58], a
    ld a, l
    ld [$cc59], a
    ld hl, $4df0
    add hl, bc
    ld a, h
    ld [$cc5a], a
    ld a, l
    ld [$cc5b], a
    ld a, $01
    ld [$cc52], a
    ld a, $03
    ld [$cc53], a
    ld a, $08
    ld [$cc56], a
    ld a, $01
    ld [$cc57], a
    ld a, $22
    ld [$cc61], a
    ld [$cc62], a
    call RemainingROM_Bank00_36C4
    ld bc, $0051
    ld hl, $4b70
    add hl, bc
    ld a, h
    ld [$cc58], a
    ld a, l
    ld [$cc59], a
    ld hl, $4df0
    add hl, bc
    ld a, h
    ld [$cc5a], a
    ld a, l
    ld [$cc5b], a
    ld a, $01
    ld [$cc52], a
    ld a, $04
    ld [$cc53], a
    ld a, $08
    ld [$cc56], a
    ld a, $01
    ld [$cc57], a
    ld a, $22
    ld [$cc61], a
    ld [$cc62], a
    call RemainingROM_Bank00_36C4
    ld bc, $0065
    ld hl, $4b70
    add hl, bc
    ld a, h
    ld [$cc58], a
    ld a, l
    ld [$cc59], a
    ld hl, $4df0
    add hl, bc
    ld a, h
    ld [$cc5a], a
    ld a, l
    ld [$cc5b], a
    ld a, $01
    ld [$cc52], a
    ld a, $05
    ld [$cc53], a
    ld a, $08
    ld [$cc56], a
    ld a, $01
    ld [$cc57], a
    ld a, $22
    ld [$cc61], a
    ld [$cc62], a
    call RemainingROM_Bank00_36C4
    ld bc, $0079
    ld hl, $4b70
    add hl, bc
    ld a, h
    ld [$cc58], a
    ld a, l
    ld [$cc59], a
    ld hl, $4df0
    add hl, bc
    ld a, h
    ld [$cc5a], a
    ld a, l
    ld [$cc5b], a
    ld a, $01
    ld [$cc52], a
    ld a, $06
    ld [$cc53], a
    ld a, $08
    ld [$cc56], a
    ld a, $01
    ld [$cc57], a
    ld a, $22
    ld [$cc61], a
    ld [$cc62], a
    call RemainingROM_Bank00_36C4
    ret
    db $01, $1f, $00, $21, $70, $4b, $09, $7c, $ea, $58, $cc, $7d, $ea, $59, $cc, $21
    db $f0, $4d, $09, $7c, $ea, $5a, $cc, $7d, $ea, $5b, $cc, $3e, $0b, $ea, $52, $cc
    db $3e, $01, $ea, $53, $cc, $3e, $07, $ea, $56, $cc, $3e, $01, $ea, $57, $cc, $3e
    db $22, $ea, $61, $cc, $ea, $62, $cc, $cd, $c4, $36, $01, $33, $00, $21, $70, $4b
    db $09, $7c, $ea, $58, $cc, $7d, $ea, $59, $cc, $21, $f0, $4d, $09, $7c, $ea, $5a
    db $cc, $7d, $ea, $5b, $cc, $3e, $0b, $ea, $52, $cc, $3e, $02, $ea, $53, $cc, $3e
    db $07, $ea, $56, $cc, $3e, $01, $ea, $57, $cc, $3e, $22, $ea, $61, $cc, $ea, $62
    db $cc, $cd, $c4, $36, $01, $47, $00, $21, $70, $4b, $09, $7c, $ea, $58, $cc, $7d
    db $ea, $59, $cc, $21, $f0, $4d, $09, $7c, $ea, $5a, $cc, $7d, $ea, $5b, $cc, $3e
    db $0b, $ea, $52, $cc, $3e, $03, $ea, $53, $cc, $3e, $07, $ea, $56, $cc, $3e, $01
    db $ea, $57, $cc, $3e, $22, $ea, $61, $cc, $ea, $62, $cc, $cd, $c4, $36, $01, $5b
    db $00, $21, $70, $4b, $09, $7c, $ea, $58, $cc, $7d, $ea, $59, $cc, $21, $f0, $4d
    db $09, $7c, $ea, $5a, $cc, $7d, $ea, $5b, $cc, $3e, $0b, $ea, $52, $cc, $3e, $04
    db $ea, $53, $cc, $3e, $07, $ea, $56, $cc, $3e, $01, $ea, $57, $cc, $3e, $22, $ea
    db $61, $cc, $ea, $62, $cc, $cd, $c4, $36, $01, $6f, $00, $21, $70, $4b, $09, $7c
    db $ea, $58, $cc, $7d, $ea, $59, $cc, $21, $f0, $4d, $09, $7c, $ea, $5a, $cc, $7d
    db $ea, $5b, $cc, $3e, $0b, $ea, $52, $cc, $3e, $05, $ea, $53, $cc, $3e, $07, $ea
    db $56, $cc, $3e, $01, $ea, $57, $cc, $3e, $22, $ea, $61, $cc, $ea, $62, $cc, $cd
    db $c4, $36, $c9, $01, $7f, $00, $21, $70, $4b, $09, $7c, $ea, $58, $cc, $7d, $ea
    db $59, $cc, $21, $f0, $4d, $09, $7c, $ea, $5a, $cc, $7d, $ea, $5b, $cc, $3e, $07
    db $ea, $52, $cc, $3e, $06, $ea, $53, $cc, $3e, $05, $ea, $56, $cc, $3e, $01, $ea
    db $57, $cc, $3e, $22, $ea, $61, $cc, $ea, $62, $cc, $cd, $c4, $36, $01, $93, $00
    db $21, $70, $4b, $09, $7c, $ea, $58, $cc, $7d, $ea, $59, $cc, $21, $f0, $4d, $09
    db $7c, $ea, $5a, $cc, $7d, $ea, $5b, $cc, $3e, $07, $ea, $52, $cc, $3e, $07, $ea
    db $53, $cc, $3e, $05, $ea, $56, $cc, $3e, $01, $ea, $57, $cc, $3e, $22, $ea, $61
    db $cc, $ea, $62, $cc, $cd, $c4, $36, $01, $a7, $00, $21, $70, $4b, $09, $7c, $ea
    db $58, $cc, $7d, $ea, $59, $cc, $21, $f0, $4d, $09, $7c, $ea, $5a, $cc, $7d, $ea
    db $5b, $cc, $3e, $07, $ea, $52, $cc, $3e, $08, $ea, $53, $cc, $3e, $05, $ea, $56
    db $cc, $3e, $01, $ea, $57, $cc, $3e, $22, $ea, $61, $cc, $ea, $62, $cc, $cd, $c4
    db $36, $01, $bb, $00, $21, $70, $4b, $09, $7c, $ea, $58, $cc, $7d, $ea, $59, $cc
    db $21, $f0, $4d, $09, $7c, $ea, $5a, $cc, $7d, $ea, $5b, $cc, $3e, $07, $ea, $52
    db $cc, $3e, $09, $ea, $53, $cc, $3e, $05, $ea, $56, $cc, $3e, $01, $ea, $57, $cc
    db $3e, $22, $ea, $61, $cc, $ea, $62, $cc, $cd, $c4, $36, $01, $cf, $00, $21, $70
    db $4b, $09, $7c, $ea, $58, $cc, $7d, $ea, $59, $cc, $21, $f0, $4d, $09, $7c, $ea
    db $5a, $cc, $7d, $ea, $5b, $cc, $3e, $07, $ea, $52, $cc, $3e, $0a, $ea, $53, $cc
    db $3e, $05, $ea, $56, $cc, $3e, $01, $ea, $57, $cc, $3e, $22, $ea, $61, $cc, $ea
    db $62, $cc, $cd, $c4, $36, $c9, $01, $df, $00, $21, $70, $4b, $09, $7c, $ea, $58
    db $cc, $7d, $ea, $59, $cc, $21, $f0, $4d, $09, $7c, $ea, $5a, $cc, $7d, $ea, $5b
    db $cc, $3e, $03, $ea, $52, $cc, $3e, $0b, $ea, $53, $cc, $3e, $0d, $ea, $56, $cc
    db $3e, $01, $ea, $57, $cc, $3e, $22, $ea, $61, $cc, $ea, $62, $cc, $cd, $c4, $36
    db $01, $f3, $00, $21, $70, $4b, $09, $7c, $ea, $58, $cc, $7d, $ea, $59, $cc, $21
    db $f0, $4d, $09, $7c, $ea, $5a, $cc, $7d, $ea, $5b, $cc, $3e, $03, $ea, $52, $cc
    db $3e, $0c, $ea, $53, $cc, $3e, $0d, $ea, $56, $cc, $3e, $01, $ea, $57, $cc, $3e
    db $22, $ea, $61, $cc, $ea, $62, $cc, $cd, $c4, $36, $01, $07, $01, $21, $70, $4b
    db $09, $7c, $ea, $58, $cc, $7d, $ea, $59, $cc, $21, $f0, $4d, $09, $7c, $ea, $5a
    db $cc, $7d, $ea, $5b, $cc, $3e, $03, $ea, $52, $cc, $3e, $0d, $ea, $53, $cc, $3e
    db $0d, $ea, $56, $cc, $3e, $01, $ea, $57, $cc, $3e, $22, $ea, $61, $cc, $ea, $62
    db $cc, $cd, $c4, $36, $01, $1b, $01, $21, $70, $4b, $09, $7c, $ea, $58, $cc, $7d
    db $ea, $59, $cc, $21, $f0, $4d, $09, $7c, $ea, $5a, $cc, $7d, $ea, $5b, $cc, $3e
    db $03, $ea, $52, $cc, $3e, $0e, $ea, $53, $cc, $3e, $0d, $ea, $56, $cc, $3e, $01
    db $ea, $57, $cc, $3e, $22, $ea, $61, $cc, $ea, $62, $cc, $cd, $c4, $36, $01, $2f
    db $01, $21, $70, $4b, $09, $7c, $ea, $58, $cc, $7d, $ea, $59, $cc, $21, $f0, $4d
    db $09, $7c, $ea, $5a, $cc, $7d, $ea, $5b, $cc, $3e, $03, $ea, $52, $cc, $3e, $0f
    db $ea, $53, $cc, $3e, $0d, $ea, $56, $cc, $3e, $01, $ea, $57, $cc, $3e, $22, $ea
    db $61, $cc, $ea, $62, $cc, $cd, $c4, $36, $c9
RuntimeEntry_Bank26_769F::
    xor a
    ld [$c4a0], a
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $16
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    xor a
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $15
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $b8
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    ld a, $80
    ld [$c4cd], a
    xor a
    ld [$c4ce], a
    ld [$c4cf], a
    ld [$c4d1], a
    ld [$c4d2], a
    ld [$c4d3], a
    ld a, $f0
    ld [$c4d4], a
    ld a, $7c
    ld [$c4d5], a
    ld a, $03
    ld [$c4d6], a
    ld a, $1a
    ld [$c4d7], a
    ld c, $00
    ld hl, $d060
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $ba
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    xor a
    ld [$c4cd], a
    ld a, $ff
    ld [$c4ce], a
    xor a
    ld [$c4cf], a
    ld a, $01
    ld [$c4d1], a
    ld a, $2c
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $78
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld a, $81
    ld [$c4db], a
    ld c, $80
    ld hl, $68b0
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $ba
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    xor a
    ld [$c4cd], a
    ld a, $ff
    ld [$c4ce], a
    xor a
    ld [$c4cf], a
    ld a, $01
    ld [$c4d1], a
    ld a, $a4
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $78
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld a, $81
    ld [$c4db], a
    ld c, $80
    ld hl, $b060
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld a, $ba
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    xor a
    ld [$c4cd], a
    ld a, $ff
    ld [$c4ce], a
    xor a
    ld [$c4cf], a
    ld a, $01
    ld [$c4d1], a
    ld a, $e0
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $4b
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld a, $81
    ld [$c4db], a
    ld c, $80
    ld hl, $b0b0
    farcall AdvancedSprite_Add
    call Sprite_Update
    ld de, $0001
    ld bc, $0000
    farcall BANK_1A, Bank1A_Entry_77D2
    ret
RuntimeEntry_Bank26_77E2::
    xor a
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $1a
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $c9
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld a, $5c
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld a, $78
    ld [$c4d2], a
    ld a, $02
    ld [$c4d3], a
    ld a, $1c
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld c, $00
    ld hl, $8000
    farcall AdvancedSprite_Add
    ld a, $c9
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld a, $5c
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld a, $96
    ld [$c4d2], a
    ld a, $02
    ld [$c4d3], a
    ld a, $1c
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld c, $00
    ld hl, $3000
    farcall AdvancedSprite_Add
    call Sprite_Update
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_786f_7a0c.dat
    db $3e, $ff, $ea, $cc, $c4, $af, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea
    db $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $96, $ea, $d4, $c4, $3e, $63, $ea
    db $d5, $c4, $3e, $2e, $ea, $d6, $c4, $3e, $13, $ea, $d7, $c4, $3e, $ce, $ef, $1a
    db $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea
    db $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3
    db $c4, $3e, $c8, $ea, $d4, $c4, $3e, $78, $ea, $d5, $c4, $3e, $6f, $ea, $d6, $c4
    db $3e, $26, $ea, $d7, $c4, $3e, $cb, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8
    db $2e, $c3, $8a, $02, $3e, $ff, $ea, $cc, $c4, $af, $ea, $cd, $c4, $ea, $d1, $c4
    db $ea, $d2, $c4, $ea, $d3, $c4, $3e, $96, $ea, $d4, $c4, $3e, $62, $ea, $d5, $c4
    db $3e, $f3, $ea, $d6, $c4, $3e, $13, $ea, $d7, $c4, $3e, $d1, $ef, $1a, $10, $45
    db $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4
    db $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e
    db $c3, $ea, $d4, $c4, $3e, $78, $ea, $d5, $c4, $3e, $e3, $ea, $d6, $c4, $3e, $26
    db $ea, $d7, $c4, $3e, $d0, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3
    db $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea
    db $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $01, $ea, $d4, $c4, $fa, $d8, $c4
    db $fe, $00, $28, $47, $3d, $ea, $d8, $c4, $fa, $d9, $c4, $fe, $01, $28, $06, $3c
    db $ea, $d9, $c4, $18, $24, $af, $ea, $d9, $c4, $fa, $da, $c4, $fe, $00, $28, $0c
    db $af, $ea, $da, $c4, $fa, $d0, $c4, $cd, $5f, $2f, $18, $0d, $3e, $01, $ea, $da
    db $c4, $fa, $d0, $c4, $cd, $45, $2f, $18, $00, $3e, $79, $ea, $d5, $c4, $3e, $51
    db $ea, $d6, $c4, $3e, $26, $ea, $d7, $c4, $c3, $8a, $02, $af, $ea, $d5, $c4, $ea
    db $d6, $c4, $ea, $d7, $c4, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea
    db $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $01
    db $ea, $d4, $c4, $3e, $79, $ea, $d5, $c4, $3e, $51, $ea, $d6, $c4, $3e, $26, $ea
    db $d7, $c4, $3e, $3c, $ea, $d8, $c4, $af, $ea, $d9, $c4, $af, $ea, $da, $c4, $3e
    db $cd, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02
RuntimeEntry_Bank26_7A0D::
    xor a
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $1a
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $cf
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    ld [$c4d3], a
    ld a, $d2
    ld [$c4d4], a
    ld a, $79
    ld [$c4d5], a
    ld a, $18
    ld [$c4d6], a
    ld a, $26
    ld [$c4d7], a
    ld c, $00
    ld hl, $8068
    farcall AdvancedSprite_Add
    ld a, $cc
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld a, $80
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    ld [$c4d3], a
    ld a, $b4
    ld [$c4d4], a
    ld a, $79
    ld [$c4d5], a
    ld a, $c7
    ld [$c4d6], a
    ld a, $26
    ld [$c4d7], a
    ld c, $00
    ld hl, $59ec
    farcall AdvancedSprite_Add
    ld a, $ca
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld a, $80
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    ld [$c4d3], a
    ld a, $d2
    ld [$c4d4], a
    ld a, $78
    ld [$c4d5], a
    ld a, $aa
    ld [$c4d6], a
    ld a, $26
    ld [$c4d7], a
    ld c, $00
    ld hl, $5800
    farcall AdvancedSprite_Add
    ld a, $d2
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld [$c4ce], a
    ld [$c4cf], a
    ld a, $01
    ld [$c4d1], a
    ld a, $2c
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $3c
    ld [$c4d4], a
    xor a
    ld [$c4d5], a
    ld [$c4d6], a
    ld [$c4d7], a
    ld a, $83
    ld [$c4db], a
    ld c, $00
    ld hl, $6868
    farcall AdvancedSprite_Add
    ld de, $0001
    ld bc, $0000
    farcall BANK_1A, Bank1A_Entry_77D2
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_7b1b_7d12.dat
    db $af, $ea, $cc, $c4, $ea, $cd, $c4, $3e, $01, $ea, $ce, $c4, $af, $ea, $cf, $c4
    db $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $70, $ea, $d4, $c4, $af, $ea
    db $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea
    db $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3
    db $c4, $3e, $f0, $ea, $d4, $c4, $3e, $7b, $ea, $d5, $c4, $3e, $1b, $ea, $d6, $c4
    db $3e, $26, $ea, $d7, $c4, $3e, $d7, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8
    db $2e, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf
    db $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $cd, $ea, $d4, $c4, $3e
    db $7b, $ea, $d5, $c4, $3e, $46, $ea, $d6, $c4, $3e, $26, $ea, $d7, $c4, $3e, $d6
    db $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $cc
    db $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $ea, $d2, $c4
    db $ea, $d3, $c4, $3e, $d2, $ea, $d4, $c4, $3e, $7b, $ea, $d5, $c4, $3e, $7f, $ea
    db $d6, $c4, $3e, $26, $ea, $d7, $c4, $3e, $d5, $ef, $1a, $10, $45, $fa, $d0, $c4
    db $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4
    db $ea, $cf, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $78, $ea, $d4
    db $c4, $3e, $7b, $ea, $d5, $c4, $3e, $b8, $ea, $d6, $c4, $3e, $26, $ea, $d7, $c4
    db $3e, $d4, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af
    db $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $ea
    db $d2, $c4, $ea, $d3, $c4, $3e, $26, $ea, $d4, $c4, $3e, $7b, $ea, $d5, $c4, $3e
    db $46, $ea, $d6, $c4, $3e, $26, $ea, $d7, $c4, $3e, $da, $ef, $1a, $10, $45, $fa
    db $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea
    db $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $96
    db $ea, $d4, $c4, $3e, $7c, $ea, $d5, $c4, $3e, $2a, $ea, $d6, $c4, $3e, $26, $ea
    db $d7, $c4, $3e, $d9, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a
    db $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1
    db $c4, $ea, $d2, $c4, $ea, $d3, $c4, $3e, $d2, $ea, $d4, $c4, $3e, $7c, $ea, $d5
    db $c4, $3e, $63, $ea, $d6, $c4, $3e, $26, $ea, $d7, $c4, $3e, $d5, $ef, $1a, $10
    db $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $cd
    db $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $d3, $c4
    db $3e, $87, $ea, $d4, $c4, $3e, $7c, $ea, $d5, $c4, $3e, $9c, $ea, $d6, $c4, $3e
    db $26, $ea, $d7, $c4, $3e, $d4, $ef, $1a, $10, $45, $3e, $84, $cd, $44, $38, $fa
    db $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02
RuntimeEntry_Bank26_7D13::
    xor a
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $1b
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $d3
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    ld a, $80
    ld [$c4cd], a
    xor a
    ld [$c4ce], a
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld [$c4d2], a
    ld a, $01
    ld [$c4d3], a
    ld a, $0e
    ld [$c4d4], a
    ld a, $7b
    ld [$c4d5], a
    ld a, $f1
    ld [$c4d6], a
    ld a, $26
    ld [$c4d7], a
    ld c, $00
    ld hl, $c068
    farcall AdvancedSprite_Add
    ld a, $d3
    farcall SpriteAnimation_GetFarPointer
    ld a, $ff
    ld [$c4cc], a
    ld a, $80
    ld [$c4cd], a
    xor a
    ld [$c4ce], a
    ld [$c4cf], a
    xor a
    ld [$c4d1], a
    ld a, $3c
    ld [$c4d2], a
    xor a
    ld [$c4d3], a
    ld a, $d2
    ld [$c4d4], a
    ld a, $7c
    ld [$c4d5], a
    ld a, $d5
    ld [$c4d6], a
    ld a, $26
    ld [$c4d7], a
    ld c, $00
    ld hl, $e068
    farcall AdvancedSprite_Add
    ret
RuntimeEntry_Bank26_7DA8::
    add a, $ab
    ld [$c4d8], a
    add a, $06
    ret
RuntimeEntry_Bank26_7DB0::
    ld a, b
    ld [$c4d3], a
    ld a, c
    ld [$c4d4], a
    ret
    db $fa, $d8, $c4, $fe, $ae, $38, $02, $18, $0a, $af, $ea, $d3, $c4, $3e, $2e, $ea, $d4, $c4, $c9, $af, $ea, $d3, $c4, $3e, $2a, $ea, $d4, $c4, $c9
RuntimeEntry_Bank26_7DD6::
    ld a, d
    ld [$c4d1], a
    ld a, e
    ld [$c4d2], a
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank26_7ddf_7e6c.dat
    db $fe, $00, $28, $0d, $fe, $01, $28, $0d, $fe, $02, $28, $0d, $fe, $03, $28, $0d
    db $c9, $cd, $d9, $71, $c9, $cd, $36, $73, $c9, $cd, $59, $74, $c9, $cd, $7c, $75
    db $c9, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1
    db $c4, $ea, $d2, $c4, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $ea, $d3, $c4
    db $ea, $d4, $c4, $fa, $d9, $c4, $cd, $df, $7d, $af, $ea, $d9, $c4, $c3, $8a, $02
    db $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d1, $c4
    db $ea, $d2, $c4, $cd, $b9, $7d, $3e, $7e, $ea, $d5, $c4, $3e, $00, $ea, $d6, $c4
    db $3e, $26, $ea, $d7, $c4, $fa, $d8, $c4, $ef, $1a, $10, $45, $af, $ea, $d8, $c4
    db $3e, $67, $cd, $44, $38, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02
RuntimeEntry_Bank26_7E6D::
    push hl
    push af
    call RuntimeEntry_Bank26_7DB0
    call RuntimeEntry_Bank26_7DD6
    pop af
    call RuntimeEntry_Bank26_7DA8
    farcall SpriteAnimation_GetFarPointer
    xor a
    ld [$c4cc], a
    ld [$c4cd], a
    ld a, $ff
    ld [$c4ce], a
    xor a
    ld [$c4cf], a
    ld a, $7e
    ld [$c4d5], a
    ld a, $2f
    ld [$c4d6], a
    ld a, $26
    ld [$c4d7], a
    ld c, $00
    pop hl
    ld a, [$ccc2]
    ld [$c4d9], a
    ld a, $84
    ld [$c4db], a
    farcall AdvancedSprite_Add
    ret
RuntimeEntry_Bank26_7EAF::
    xor a
    ld [$c4a0], a
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $14
    ld hl, $8000
    farcall SpriteGroup_LoadGraphicsAndPalettes
    ld a, $00
    ld [$ccc2], a
    ld a, $01
    ld bc, $0064
    ld de, $003c
    ld hl, $3090
    call RuntimeEntry_Bank26_7E6D
    ld a, $ff
    ld [$ccc2], a
    ld a, $03
    ld bc, $0055
    ld de, $001e
    ld hl, $4090
    call RuntimeEntry_Bank26_7E6D
    ld a, $01
    ld [$ccc2], a
    ld a, $00
    ld bc, $0064
    ld de, $0110
    ld hl, $8090
    call RuntimeEntry_Bank26_7E6D
    ld a, $ff
    ld [$ccc2], a
    ld a, $04
    ld bc, $0055
    ld de, $010c
    ld hl, $7090
    call RuntimeEntry_Bank26_7E6D
    ld a, $02
    ld [$ccc2], a
    ld a, $02
    ld bc, $0041
    ld de, $017a
    ld hl, $5490
    call RuntimeEntry_Bank26_7E6D
    ld a, $03
    ld [$ccc2], a
    ld a, $01
    ld bc, $0014
    ld de, $0258
    ld hl, $5490
    call RuntimeEntry_Bank26_7E6D
    ld a, $ff
    ld [$ccc2], a
    ld a, $03
    ld bc, $001e
    ld de, $020e
    ld hl, $3090
    call RuntimeEntry_Bank26_7E6D
    ld a, $ff
    ld [$ccc2], a
    ld a, $05
    ld bc, $0014
    ld de, $0218
    ld hl, $4890
    call RuntimeEntry_Bank26_7E6D
    ld a, $ff
    ld [$ccc2], a
    ld a, $04
    ld bc, $000f
    ld de, $0218
    ld hl, $7090
    call RuntimeEntry_Bank26_7E6D
    ld a, $ff
    ld [$ccc2], a
    ld a, $03
    ld bc, $002d
    ld de, $0218
    ld hl, $8090
    call RuntimeEntry_Bank26_7E6D
    ret
    ds $7f, $ff
    assert @ == $8000

SECTION "Remaining ROM 27:40E6-43DB", ROMX[$40E6], BANK[$27]
RemainingROM_Bank27_40E6::
    ; Source-owned structural bytes formerly data/campaign/structural/bank27_40e6_43db.dat
    db $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $3e, $80, $ea, $cf, $c4, $3e
    db $41, $ea, $d5, $c4, $3e, $28, $ea, $d6, $c4, $3e, $27, $ea, $d7, $c4, $af, $ea
    db $d3, $c4, $3e, $32, $ea, $d4, $c4, $fa, $a1, $c4, $fe, $21, $28, $11, $fa, $3c
    db $d3, $3c, $ea, $3c, $d3, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3
    db $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $3e, $40, $ea, $cf
    db $c4, $3e, $41, $ea, $d5, $c4, $3e, $52, $ea, $d6, $c4, $3e, $27, $ea, $d7, $c4
    db $af, $ea, $d3, $c4, $3e, $30, $ea, $d4, $c4, $c3, $8a, $02, $af, $ea, $cc, $c4
    db $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $3e, $41, $ea, $d5, $c4, $3e, $a3
    db $ea, $d6, $c4, $3e, $27, $ea, $d7, $c4, $af, $ea, $d3, $c4, $3e, $98, $ea, $d4
    db $c4, $fa, $a1, $c4, $fe, $21, $28, $13, $fa, $3c, $d3, $3c, $ea, $3c, $d3, $ef
    db $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $18, $0f, $3e, $16, $ea, $3c, $d3
    db $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $cc
    db $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d5, $c4, $ea, $d6, $c4
    db $ea, $d7, $c4, $af, $ea, $d3, $c4, $3e, $78, $ea, $d4, $c4, $fa, $d0, $c4, $cd
    db $11, $2f, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea
    db $cf, $c4, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $af, $ea, $d3, $c4, $3e
    db $f0, $ea, $d4, $c4, $fa, $d0, $c4, $cd, $11, $2f, $c3, $8a, $02, $af, $ea, $d1
    db $c4, $ea, $d2, $c4, $ea, $cc, $c4, $3e, $80, $ea, $cd, $c4, $af, $ea, $ce, $c4
    db $ea, $cf, $c4, $3e, $42, $ea, $d5, $c4, $3e, $30, $ea, $d6, $c4, $3e, $27, $ea
    db $d7, $c4, $af, $ea, $d3, $c4, $3e, $3c, $ea, $d4, $c4, $3e, $94, $ef, $1a, $10
    db $45, $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $d1, $c4, $ea, $d2
    db $c4, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $3e, $42, $ea
    db $d5, $c4, $3e, $6a, $ea, $d6, $c4, $3e, $27, $ea, $d7, $c4, $af, $ea, $d3, $c4
    db $3e, $1e, $ea, $d4, $c4, $3e, $97, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8
    db $2e, $c3, $8a, $02, $af, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $cc, $c4, $ea, $cd
    db $c4, $ea, $ce, $c4, $ea, $cf, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7
    db $c4, $af, $ea, $d3, $c4, $3e, $ff, $ea, $d4, $c4, $3e, $9e, $ef, $1a, $10, $45
    db $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $d1, $c4, $ea, $d2, $c4
    db $ea, $cc, $c4, $3e, $80, $ea, $cd, $c4, $af, $ea, $ce, $c4, $ea, $cf, $c4, $3e
    db $42, $ea, $d5, $c4, $3e, $dc, $ea, $d6, $c4, $3e, $27, $ea, $d7, $c4, $af, $ea
    db $d3, $c4, $3e, $3c, $ea, $d4, $c4, $3e, $94, $ef, $1a, $10, $45, $fa, $d0, $c4
    db $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $cc, $c4
    db $ea, $cd, $c4, $ea, $ce, $c4, $ea, $cf, $c4, $3e, $43, $ea, $d5, $c4, $3e, $1b
    db $ea, $d6, $c4, $3e, $27, $ea, $d7, $c4, $af, $ea, $d3, $c4, $3e, $2d, $ea, $d4
    db $c4, $3e, $96, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $3e, $39, $ea
    db $db, $c4, $c3, $8a, $02, $af, $ea, $d1, $c4, $ea, $d2, $c4, $3e, $ff, $ea, $cc
    db $c4, $3e, $80, $ea, $cd, $c4, $af, $ea, $ce, $c4, $ea, $cf, $c4, $3e, $43, $ea
    db $d5, $c4, $3e, $5a, $ea, $d6, $c4, $3e, $27, $ea, $d7, $c4, $af, $ea, $d3, $c4
    db $3e, $1e, $ea, $d4, $c4, $3e, $99, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8
    db $2e, $c3, $8a, $02, $af, $ea, $d1, $c4, $ea, $d2, $c4, $ea, $cc, $c4, $ea, $cd
    db $c4, $ea, $ce, $c4, $ea, $cf, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7
    db $c4, $3e, $02, $ea, $d3, $c4, $af, $ea, $d4, $c4, $3e, $9e, $ef, $1a, $10, $45
    db $fa, $d0, $c4, $cd, $e8, $2e, $c3, $8a, $02, $af, $ea, $cc, $c4, $ea, $ce, $c4
    db $ea, $d1, $c4, $ea, $d2, $c4, $af, $ea, $d3, $c4, $3e, $3c, $ea, $d4, $c4, $3e
    db $9a, $ef, $1a, $10, $45, $fa, $d0, $c4, $cd, $e8, $2e, $af, $cd, $44, $38, $c3
    db $8a, $02, $3e, $ff, $ea, $cc, $c4, $af, $ea, $ce, $c4, $ea, $d1, $c4, $ea, $d2
    db $c4, $ea, $d3, $c4, $3e, $78, $ea, $d4, $c4, $af, $ea, $d5, $c4, $ea, $d6, $c4
    db $ea, $d7, $c4, $c3, $8a, $02
    assert @ == $43DC

SECTION "Remaining ROM 27:4465-5194", ROMX[$4465], BANK[$27]
RemainingROM_Bank27_4465::
    INCBIN "gfx/ui/structural/bank27_presentation_tiles_4465_5194.2bpp", $0, $d30
    assert @ == $5195

SECTION "Remaining ROM 27:51EF-5266", ROMX[$51EF], BANK[$27]
RemainingROM_Bank27_51EF::
    ; Source-owned structural bytes formerly data/campaign/structural/bank27_51ef_5266.dat
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $7e, $7e, $42, $42, $42, $42, $7e, $7e, $60, $60, $60, $60, $60, $60
    db $00, $00, $7c, $7c, $44, $44, $44, $44, $7e, $7e, $62, $62, $62, $62, $62, $62
    db $00, $00, $7e, $7e, $40, $40, $40, $40, $7e, $7e, $60, $60, $60, $60, $7e, $7e
    db $00, $00, $7e, $7e, $42, $42, $40, $40, $7e, $7e, $06, $06, $46, $46, $7e, $7e
    db $00, $00, $7e, $7e, $0e, $0e, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    db $00, $00, $7c, $7c, $44, $44, $44, $44, $44, $44, $fe, $fe, $c2, $c2, $c2, $c2
    db $84, $10, $b0, $2d, $55, $46, $7b, $67
    assert @ == $5267

SECTION "Remaining ROM 27:5566-5F12", ROMX[$5566], BANK[$27]
RemainingROM_Bank27_5566::
RuntimeEntry_Bank27_5566::
    ldh a, [$ff82]
    push af
    ld a, $04
    ldh [$ff82], a
    ldh [$ff70], a
    call MapResult_SetupSecondaryScreen
    call Audio_StopMusic
    call FadeFromWhite8
    ld de, $001e
    call MapResult_WaitFramesOrCancel
    jr c, .loc_55B7
    xor a
    ld [$dbc7], a
    ld a, $02
    ld [$dbbf], a
    ld a, $08
    ld [$dbc0], a
    ld a, $10
    ld [$dbbb], a
    ld a, $02
    ld [$dbbc], a
    ld a, $1f
    ld [$dbba], a
    ld a, $01
    ld [$dbc6], a
    call MapResult_BuildRandomOrder
    ld a, $1d
    call Audio_PlaySFX
    call MapResult_AnimateEntries
    jr c, .loc_55B7
    ld de, $0078
    call MapResult_WaitFramesOrCancel
    jr c, .loc_55B7
.loc_55B7:
    call Audio_StopSFX
    call Audio_StopMusic
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $e0, $c0, $e0, $c0, $e0, $c1, $e0, $c1, $e0, $c1, $e1, $c0
    db $ff, $ff, $ff, $ff, $03, $01, $00, $01, $c1, $e0, $c1, $e0, $c1, $e0, $c0, $01
    db $ff, $ff, $ff, $ff, $80, $c0, $c0, $c0, $c3, $c1, $c3, $c1, $c3, $c1, $c1, $c0
    db $ff, $ff, $ff, $ff, $0f, $06, $04, $06, $f6, $fc, $fe, $fc, $fe, $fc, $fe, $04
    db $ff, $ff, $ff, $ff, $00, $00, $00, $00, $0f, $1f, $0f, $1f, $0f, $1f, $0f, $10
    db $ff, $ff, $ff, $ff, $08, $18, $0c, $18, $ec, $f8, $fc, $f8, $fc, $f8, $fc, $08
    db $ff, $ff, $ff, $ff, $18, $30, $30, $38, $30, $38, $33, $38, $32, $39, $33, $39
    db $ff, $ff, $ff, $ff, $0e, $1f, $0f, $0f, $07, $0f, $0f, $07, $03, $07, $87, $03
    db $ff, $ff, $ff, $ff, $1f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
    db $ff, $ff, $ff, $ff, $c3, $81, $83, $c1, $c1, $c1, $e0, $c1, $e0, $c1, $c1, $e0
    db $ff, $ff, $ff, $ff, $e1, $c0, $c0, $c0, $80, $c0, $80, $c0, $c0, $80, $80, $90
    db $ff, $ff, $ff, $ff, $f3, $e3, $f7, $e3, $63, $e7, $47, $e7, $cf, $67, $6f, $47
    db $ff, $ff, $ff, $ff, $f0, $e0, $e0, $e0, $c0, $e0, $e8, $c0, $88, $c8, $dc, $88
    db $ff, $ff, $ff, $ff, $fc, $7e, $3e, $7e, $7e, $3e, $3e, $3e, $1e, $3e, $3e, $1e
    db $ff, $ff, $ff, $ff, $00, $00, $00, $00, $1f, $0e, $1f, $0e, $1f, $0e, $0e, $00
    db $ff, $ff, $ff, $ff, $2f, $1f, $07, $0f, $07, $0f, $07, $0f, $07, $0f, $07, $0f
    db $e0, $c0, $e0, $c1, $e0, $c1, $e0, $c1, $e0, $c1, $e0, $c0, $ff, $c0, $ff, $ff
    db $01, $03, $20, $c1, $c1, $e0, $c1, $e0, $21, $c0, $00, $01, $fd, $03, $ff, $ff
    db $c0, $c0, $c2, $c1, $c3, $c1, $c3, $c1, $c2, $c1, $c0, $c0, $bf, $c0, $ff, $ff
    db $0e, $04, $06, $fc, $fe, $fc, $fe, $fc, $02, $fc, $04, $06, $fe, $07, $ff, $ff
    db $08, $10, $00, $1e, $0e, $1e, $0e, $1e, $10, $0e, $00, $00, $fe, $01, $ff, $ff
    db $1c, $08, $1c, $08, $1c, $08, $1c, $08, $1c, $08, $1c, $08, $f7, $08, $ff, $ff
    db $33, $39, $33, $39, $33, $39, $33, $39, $33, $39, $33, $39, $d7, $39, $ff, $ff
    db $01, $83, $c3, $81, $80, $c1, $e1, $c0, $c0, $e0, $f0, $e0, $ef, $f0, $ff, $ff
    db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $ff, $3f, $ff, $ff
    db $e0, $e0, $f0, $e0, $f0, $e0, $e0, $f0, $f0, $f0, $f8, $f0, $f7, $f8, $ff, $ff
    db $10, $90, $b8, $10, $10, $38, $10, $38, $3c, $38, $7c, $38, $bb, $7c, $ff, $ff
    db $07, $4f, $4f, $0f, $1e, $0f, $0f, $1e, $0e, $1e, $1e, $1c, $fb, $1c, $ff, $ff
    db $08, $9c, $9c, $00, $00, $00, $7e, $00, $3f, $7e, $7e, $7f, $fe, $7f, $ff, $ff
    db $0e, $1e, $1e, $0e, $0e, $0e, $06, $0e, $0e, $06, $02, $06, $fd, $02, $ff, $ff
    db $00, $00, $14, $08, $18, $0c, $1c, $0c, $1c, $0e, $1e, $0e, $ff, $0e, $ff, $ff
    db $0f, $0f, $2f, $1f, $1f, $1f, $1f, $0f, $0f, $0f, $07, $0f, $ff, $07, $ff, $ff
    db $ff, $ff, $e0, $ff, $f0, $e0, $f0, $e0, $f0, $e0, $f0, $e0, $f0, $e0, $f0, $e0
    db $ff, $ff, $01, $ff, $00, $00, $f0, $00, $70, $f0, $70, $f0, $70, $f0, $00, $00
    db $ff, $ff, $e0, $ff, $60, $e0, $f0, $60, $f0, $60, $f0, $60, $f0, $60, $f0, $60
    db $ff, $ff, $02, $ff, $02, $03, $fd, $03, $ff, $ff, $ff, $ff, $fb, $ff, $07, $03
    db $ff, $ff, $00, $ff, $00, $00, $07, $00, $0f, $07, $0f, $07, $0f, $07, $0f, $07
    db $ff, $ff, $1f, $ff, $07, $0f, $0f, $07, $87, $07, $87, $07, $87, $07, $87, $07
    db $ff, $ff, $fc, $ff, $f0, $f8, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
    db $ff, $ff, $00, $ff, $01, $00, $7f, $00, $ff, $7f, $ff, $7f, $02, $01, $00, $00
    db $ff, $ff, $80, $ff, $c0, $80, $f8, $80, $fc, $f8, $fc, $f8, $fc, $f8, $fc, $f8
    db $ff, $ff, $03, $ff, $07, $03, $3f, $03, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
    db $ff, $ff, $e0, $ff, $e0, $f0, $f0, $e0, $c0, $e0, $e8, $c0, $84, $c8, $d8, $8c
    db $ff, $ff, $7e, $ff, $3e, $7e, $7f, $3e, $3f, $3e, $1f, $3e, $3f, $1e, $0f, $1e
    db $ff, $ff, $00, $ff, $00, $00, $0e, $00, $0e, $0f, $0e, $0f, $0e, $0f, $00, $00
    db $ff, $ff, $1f, $ff, $1f, $0f, $07, $0f, $0f, $07, $0f, $07, $0f, $07, $0f, $07
    db $f0, $e0, $f0, $e0, $f0, $e0, $f0, $e0, $f0, $e0, $f0, $e0, $ef, $f0, $ff, $ff
    db $00, $00, $40, $c1, $61, $c0, $40, $e0, $70, $e0, $60, $f0, $7f, $f0, $ff, $ff
    db $70, $e0, $f0, $e0, $f0, $e0, $70, $e0, $f0, $60, $60, $60, $bf, $60, $ff, $ff
    db $07, $03, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $03, $00, $03, $fe, $03, $ff, $ff
    db $0f, $07, $0f, $07, $0f, $07, $0f, $07, $07, $00, $00, $00, $ff, $00, $ff, $ff
    db $87, $07, $87, $07, $87, $07, $87, $07, $0f, $07, $07, $0f, $ef, $1f, $ff, $ff
    db $f0, $f0, $f8, $f0, $ff, $f8, $ff, $ff, $ff, $f0, $f8, $f0, $f7, $f8, $ff, $ff
    db $00, $00, $00, $00, $e0, $00, $f0, $e0, $e0, $00, $01, $00, $fd, $03, $ff, $ff
    db $fc, $f8, $fc, $f8, $fc, $f8, $fc, $f8, $fc, $f8, $fc, $f8, $ff, $f8, $ff, $ff
    db $3f, $3f, $3f, $3f, $3f, $3f, $3e, $3f, $3e, $3e, $3e, $3c, $df, $3c, $ff, $ff
    db $8e, $9c, $9c, $00, $00, $00, $01, $3e, $3e, $7f, $7f, $7f, $ff, $7f, $ff, $ff
    db $1f, $0e, $0f, $0e, $07, $0e, $0f, $06, $07, $06, $86, $02, $fd, $02, $ff, $ff
    db $00, $00, $08, $0c, $0c, $0c, $0e, $0c, $0e, $0e, $0f, $0e, $f6, $0f, $ff, $ff
    db $07, $0f, $1f, $1f, $0f, $1f, $0f, $0f, $07, $0f, $0f, $07, $fb, $07, $ff, $ff
    db $ff, $ff, $81, $ff, $c3, $81, $83, $c1, $c1, $c1, $e0, $c1, $e1, $c0, $c1, $e0
    db $ff, $ff, $c0, $ff, $e1, $c0, $c0, $c0, $80, $c0, $c0, $80, $c0, $80, $80, $90
    db $ff, $ff, $e0, $ff, $f0, $e2, $f4, $e2, $60, $e6, $c4, $66, $ec, $46, $6c, $46
    db $ff, $ff, $0e, $ff, $1e, $0e, $1f, $0e, $1f, $0e, $1f, $0e, $1f, $0e, $00, $00
    db $ff, $ff, $04, $ff, $06, $0c, $0e, $0c, $0e, $0c, $0e, $0c, $0e, $0c, $0e, $0c
    db $ff, $ff, $08, $ff, $18, $08, $03, $18, $0f, $1f, $0f, $1f, $0f, $1f, $0f, $1f
    db $ff, $ff, $00, $ff, $00, $00, $03, $00, $07, $83, $07, $83, $07, $83, $07, $83
    db $ff, $ff, $40, $ff, $00, $60, $20, $60, $e1, $e0, $e1, $e0, $e1, $e0, $e0, $e0
    db $ff, $ff, $03, $ff, $07, $03, $fb, $03, $ff, $ff, $ff, $ff, $fb, $ff, $07, $03
    db $ff, $ff, $f0, $ff, $f0, $f8, $f8, $f8, $f8, $f8, $f9, $f8, $f8, $f9, $f9, $f9
    db $ff, $ff, $1f, $ff, $0f, $1e, $1e, $0e, $0c, $0e, $06, $0c, $0c, $04, $00, $04
    db $ff, $ff, $03, $ff, $03, $03, $07, $03, $07, $03, $87, $03, $07, $83, $87, $83
    db $ff, $ff, $c0, $ff, $c0, $80, $83, $00, $87, $07, $87, $07, $87, $07, $87, $07
    db $ff, $ff, $0f, $ff, $03, $07, $06, $03, $83, $82, $c3, $82, $c3, $82, $c3, $82
    db $ff, $ff, $80, $ff, $80, $00, $07, $00, $07, $0f, $07, $0f, $07, $0f, $07, $0f
    db $ff, $ff, $1e, $ff, $06, $0e, $07, $06, $83, $06, $83, $06, $83, $06, $83, $06
    db $ff, $ff, $03, $ff, $03, $03, $03, $01, $01, $01, $00, $41, $20, $40, $00, $60
    db $ff, $ff, $c7, $ff, $ef, $c7, $ef, $c7, $ef, $c7, $ef, $c7, $ef, $c7, $6f, $c7
    db $e0, $e0, $f0, $e0, $f0, $e0, $e0, $f0, $f0, $f0, $f8, $f0, $f7, $f8, $ff, $ff
    db $10, $90, $b8, $10, $10, $38, $18, $38, $3c, $38, $7c, $38, $bb, $7c, $ff, $ff
    db $04, $4e, $4c, $0e, $1c, $0e, $0c, $1e, $0c, $1e, $1c, $1e, $dd, $3e, $ff, $ff
    db $00, $00, $1f, $0e, $1f, $0e, $1f, $0e, $1f, $0e, $1e, $0e, $ff, $0e, $ff, $ff
    db $0e, $0c, $0e, $0c, $0e, $0c, $0e, $0c, $0e, $0c, $0e, $0c, $f7, $0c, $ff, $ff
    db $0f, $1f, $0f, $1f, $0f, $1f, $0f, $1f, $0f, $1f, $0f, $1f, $ef, $1f, $ff, $ff
    db $07, $83, $07, $83, $07, $83, $07, $83, $07, $83, $07, $83, $7f, $83, $ff, $ff
    db $e0, $e0, $e1, $e0, $e1, $e0, $e1, $e0, $e0, $e0, $c0, $e0, $df, $e0, $ff, $ff
    db $07, $03, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $03, $03, $03, $ff, $03, $ff, $ff
    db $f9, $f9, $f9, $f9, $f9, $f9, $f9, $f9, $f9, $f9, $f0, $f9, $f6, $f9, $ff, $ff
    db $85, $00, $00, $81, $81, $81, $c3, $81, $81, $c3, $c3, $c3, $db, $e7, $ff, $ff
    db $87, $83, $87, $83, $87, $83, $87, $83, $87, $83, $03, $83, $7f, $83, $ff, $ff
    db $87, $07, $87, $07, $87, $07, $87, $07, $87, $00, $80, $80, $df, $e0, $ff, $ff
    db $c3, $82, $c3, $82, $c3, $82, $c3, $82, $82, $03, $03, $07, $f7, $0f, $ff, $ff
    db $07, $0f, $07, $0f, $07, $0f, $07, $0f, $07, $00, $80, $00, $bf, $c0, $ff, $ff
    db $83, $06, $83, $06, $83, $06, $83, $06, $07, $06, $0e, $06, $ef, $1e, $ff, $ff
    db $30, $60, $20, $70, $38, $70, $30, $78, $3c, $78, $38, $7c, $bd, $7e, $ff, $ff
    db $6f, $47, $2f, $47, $6f, $07, $2f, $07, $0f, $07, $0f, $07, $f7, $0f, $ff, $ff
    db $ff, $ff, $81, $ff, $c3, $81, $81, $c1, $e0, $c1, $c1, $e0, $c0, $e0, $f0, $e0
    db $ff, $ff, $f8, $ff, $fd, $f8, $f8, $f9, $f3, $f9, $f9, $f3, $f3, $f3, $67, $f3
    db $ff, $ff, $03, $ff, $03, $83, $87, $83, $87, $83, $87, $83, $87, $83, $87, $83
    db $ff, $ff, $c0, $ff, $c0, $80, $87, $00, $0f, $07, $0f, $07, $0f, $07, $0f, $07
    db $ff, $ff, $10, $ff, $10, $10, $c7, $10, $ee, $ff, $fe, $ff, $fe, $ff, $fe, $ff
    db $ff, $ff, $00, $ff, $00, $00, $07, $00, $0f, $07, $0f, $07, $0f, $07, $0f, $07
    db $ff, $ff, $e0, $ff, $60, $c0, $01, $c0, $c3, $83, $c3, $83, $c3, $83, $c3, $83
    db $ff, $ff, $07, $ff, $05, $03, $c3, $01, $e1, $c1, $e1, $c1, $e1, $c1, $e1, $c1
    db $ff, $ff, $00, $ff, $00, $80, $83, $80, $87, $83, $87, $83, $87, $83, $80, $80
    db $ff, $ff, $0e, $ff, $06, $03, $81, $03, $c1, $83, $c1, $83, $c1, $83, $01, $03
    db $ff, $ff, $07, $ff, $07, $03, $83, $03, $03, $81, $c0, $81, $c1, $c0, $c0, $e0
    db $ff, $ff, $c3, $ff, $e3, $c7, $cf, $c7, $cf, $8f, $0f, $9f, $bf, $1f, $1f, $3f
    db $e0, $f0, $f0, $f0, $f8, $f0, $f0, $f8, $f8, $f8, $fc, $f8, $fb, $fc, $ff, $ff
    db $f3, $67, $47, $67, $2f, $47, $47, $0f, $1f, $0f, $0f, $1f, $ff, $1f, $ff, $ff
    db $87, $83, $87, $83, $87, $83, $87, $83, $87, $83, $07, $83, $7f, $83, $ff, $ff
    db $0f, $07, $0f, $07, $0f, $07, $0f, $07, $87, $00, $00, $80, $9f, $e0, $ff, $ff
    db $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $ee, $1f, $0e, $1f, $ee, $1f, $ff, $ff
    db $0f, $07, $0f, $07, $0f, $07, $0f, $07, $0f, $07, $0f, $07, $f7, $0f, $ff, $ff
    db $c3, $83, $c3, $83, $c3, $83, $c3, $83, $c3, $80, $c0, $c0, $ef, $f0, $ff, $ff
    db $e1, $c1, $e1, $c1, $e1, $c1, $e1, $c1, $c3, $01, $01, $03, $fb, $07, $ff, $ff
    db $80, $80, $87, $82, $86, $83, $87, $83, $87, $83, $07, $83, $7f, $83, $ff, $ff
    db $07, $03, $0f, $07, $03, $07, $87, $03, $03, $83, $83, $81, $bf, $c1, $ff, $ff
    db $f0, $e0, $e0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $e0, $f0, $ef, $f0, $ff, $ff
    db $7f, $3f, $7f, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe
    db $ff, $ff, $ff, $ff, $00, $00, $00, $00, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
    db $ff, $ff, $ff, $ff, $2e, $1c, $1c, $0e, $04, $0e, $04, $0e, $04, $0e, $04, $0e
    db $ff, $ff, $ff, $ff, $00, $00, $00, $00, $1f, $0f, $1f, $0f, $1f, $0f, $0f, $00
    db $ff, $ff, $ff, $ff, $70, $20, $70, $20, $b0, $e0, $f0, $e0, $f0, $e0, $b0, $60
    db $ff, $ff, $ff, $ff, $02, $03, $01, $03, $7f, $ff, $7f, $ff, $7f, $ff, $fb, $03
    db $ff, $ff, $ff, $ff, $00, $00, $00, $00, $0f, $07, $0f, $07, $0f, $07, $07, $00
    db $ff, $ff, $ff, $ff, $3f, $1f, $1f, $1f, $df, $ff, $ff, $ff, $ff, $fe, $fe, $1e
    db $ff, $ff, $ff, $ff, $83, $81, $01, $81, $80, $01, $21, $00, $40, $20, $30, $60
    db $ff, $ff, $f0, $ff, $f8, $f0, $ff, $f0, $ff, $ff, $ff, $ff, $7f, $ff, $ff, $7f
    db $ff, $ff, $00, $ff, $00, $00, $07, $00, $87, $07, $87, $07, $87, $07, $87, $07
    db $ff, $ff, $7f, $ff, $ff, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $ff
    db $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $01, $0e, $00, $00, $ff, $00, $ff, $ff
    db $04, $0e, $04, $0e, $04, $0e, $04, $0e, $0c, $0e, $1c, $0e, $fd, $1e, $ff, $ff
    db $00, $00, $10, $0f, $1f, $0f, $1f, $0f, $10, $0f, $00, $00, $ff, $00, $ff, $ff
    db $30, $60, $30, $e0, $f0, $e0, $f0, $e0, $70, $a0, $70, $20, $ff, $20, $ff, $ff
    db $03, $03, $07, $fb, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7e, $ff, $ff, $ff
    db $00, $00, $08, $07, $0f, $07, $0f, $07, $08, $07, $00, $00, $ff, $00, $ff, $ff
    db $3c, $1e, $1c, $fc, $f8, $fc, $f9, $f8, $01, $f9, $13, $11, $ed, $13, $ff, $ff
    db $60, $70, $f0, $00, $00, $00, $f8, $00, $fc, $f8, $f8, $fc, $fb, $fc, $ff, $ff
    db $7f, $7f, $3f, $7f, $7f, $3f, $3f, $3f, $1f, $3f, $1f, $1f, $ef, $1f, $ff, $ff
    db $87, $07, $87, $07, $87, $07, $87, $07, $87, $07, $87, $07, $fb, $07, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $1f, $03, $15, $02, $0b, $01, $00, $00, $1f, $01, $75, $00, $4b, $00, $00, $00
    db $18, $63, $10, $42, $08, $21, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    assert @ == $5F13

SECTION "Remaining ROM 27:65B7-65E2", ROMX[$65B7], BANK[$27]
RemainingROM_Bank27_65B7::
    ; Source-owned structural bytes formerly data/campaign/structural/bank27_65b7_65e2.dat
    db $6c, $67, $8d, $00, $6c, $93, $62, $00, $76, $ad, $63, $6c, $ad, $6c, $67, $8d
    db $00, $76, $ad, $63, $6c, $ad, $6c, $93, $62, $00, $30, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    assert @ == $65E3

SECTION "Remaining ROM 27:67F3-6AA5", ROMX[$67F3], BANK[$27]
RemainingROM_Bank27_67F3::
    ; Source-owned structural bytes formerly data/campaign/structural/bank27_67f3_6840.dat
    db $00, $00, $00, $69, $ff, $7f, $40, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $f0, $63, $c0, $4a, $60, $25, $00, $00, $1f, $7c, $1f, $7c, $00, $00, $ff, $7f
    db $21, $50, $da, $fa, $4f, $da, $3d, $06, $00, $4f, $09, $af, $77, $c9
RuntimeEntry_Bank27_6841::
    farcall Bank31_RuntimeSetup_581F
    call RestoreDefaultDisplayInterrupts
    call FadeToWhite8
    ld a, [$def4]
    cp $05
    jr nz, .loc_6865
    ld a, [$cbde]
    cp $01
    jr z, .loc_6865
    ld a, [$cbdd]
    cp $01
    jp z, .loc_6865
    farcall BANK_32, Bank32_Entry_4D1F
.loc_6865:
    ret
RuntimeEntry_Bank27_6866::
    farcall Bank31_RuntimeSetup_581F
    call RestoreDefaultDisplayInterrupts
    ld a, [$cace]
    cp $01
    jr z, .loc_6878
    farcall Bank31_PersistentCursorController_637F
.loc_6878:
    call FadeToWhite8
    farcall BANK_32, Bank32_Entry_4D1F
    ret
RuntimeEntry_Bank27_6880::
    ld a, [$da37]
    call SpriteObject_Hide
    call Sprite_Update
    call DelayFrame
    xor a
    ld [$cadd], a
    ld bc, $0306
    ld de, $0d07
    farcall UIWindowStack_PushAndDrawAnimated
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0407
    ld de, $0b05
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0508
    ld hl, $68c4
    call TextPut
    ld bc, $070a
    farcall Gfx_DrawTwoChoiceHighlightFirst
    ret
    db $a7, $ac, $76, $62, $86, $78, $6a, $3f, $00
RuntimeEntry_Bank27_68CD::
    push bc
    push hl
    call RuntimeEntry_Bank27_6880
.loc_68D2:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff91]
    bit 5, a
    jr z, .loc_68F5
    ld a, $01
    call Audio_PlaySFX
    ld bc, $070a
    farcall Gfx_DrawTwoChoiceHighlightSecond
    ld a, $01
    ld [$cadd], a
.loc_68F5:
    ldh a, [$ff91]
    bit 4, a
    jr z, .loc_690B
    ld a, $01
    call Audio_PlaySFX
    ld bc, $070a
    farcall Gfx_DrawTwoChoiceHighlightFirst
    xor a
    ld [$cadd], a
.loc_690B:
    ldh a, [$ff91]
    bit 0, a
    jr z, .loc_692B
    ld a, [$cadd]
    cp $00
    jr z, .loc_691A
    jr .loc_6921
.loc_691A:
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    jr .loc_6926
.loc_6921:
    ld a, $02
    call Audio_PlaySFX
.loc_6926:
    ld a, [$cadd]
    jr .loc_693A
.loc_692B:
    ldh a, [$ff91]
    bit 1, a
    jr z, .loc_68D2
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    xor a
    ld [$cadd], a
.loc_693A:
    ld a, [$cadd]
    cp $00
    jr z, .loc_6946
    ld a, $01
    ld [$da40], a
.loc_6946:
    ld a, [$da37]
    call SpriteObject_Show
    push af
    ld a, [$da40]
    cp $00
    jr z, .loc_6956
    jr .loc_695A
.loc_6956:
    farcall UIWindowStack_PopRestore
.loc_695A:
    pop af
    pop hl
    pop bc
    ret
RuntimeEntry_Bank27_695E::
    ld hl, $cade
    ld bc, $0043
    xor a
    call Memset
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld hl, $cade
    push hl
    ld a, [$ba3b]
    xor a
    farcall Bank31_GetIndexed34ByteRecordAddress
    ld d, h
    ld e, l
    pop hl
    farcall BANK_07, Bank07_Entry_2D71
    ld hl, $cade
    farcall NetworkText_SkipZeroBytes
    inc hl
    ld de, $a099
    farcall BANK_07, Bank07_Entry_2D71
    ld hl, $cade
    farcall NetworkText_SkipZeroBytes
    inc hl
    farcall NetworkText_SkipZeroBytes
    inc hl
    push hl
    ld hl, $cab3
    ld de, $dc10
    farcall Text_ConvertGameCodeToShiftJISStream
    ld de, $dc10
    pop hl
    farcall BANK_07, Bank07_Entry_2D71
    call SRAM_Disable
    ret
RuntimeEntry_Bank27_69B6::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld de, $a099
    ld hl, $cb94
    ld bc, $0011
    call Memcpy
    ld hl, $cab3
    ld de, $dc10
    farcall Text_ConvertGameCodeToShiftJISStream
    ld de, $dc10
    ld hl, $cba5
    ld bc, $0020
    call Memcpy
    call SRAM_Disable
    ret
    ; Source-owned structural bytes formerly data/campaign/structural/bank27_69e4_6a1b.dat
    db $3e, $0e, $cd, $8d, $05, $cd, $93, $05, $21, $9a, $d8, $11, $10, $dc, $ef, $22
    db $aa, $62, $11, $10, $dc, $21, $99, $a0, $01, $21, $00, $cd, $50, $3b, $21, $cc
    db $d8, $11, $10, $dc, $ef, $22, $aa, $62, $11, $10, $dc, $21, $cb, $a0, $01, $1f
    db $00, $cd, $50, $3b, $cd, $9b, $05, $c9
RuntimeEntry_Bank27_6A1C::
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    ld a, [$def4]
    cp $00
    jr z, .loc_6A3B
    cp $01
    jr z, .loc_6A40
    cp $02
    jr z, .loc_6A45
    cp $03
    jr z, .loc_6A4A
    cp $0a
    jr z, .loc_6A4F
.loc_6A3B:
    ld hl, $bb42
    jr .loc_6A54
.loc_6A40:
    ld hl, $bb47
    jr .loc_6A54
.loc_6A45:
    ld hl, $bb4c
    jr .loc_6A54
.loc_6A4A:
    ld hl, $bb51
    jr .loc_6A54
.loc_6A4F:
    ld hl, $bb56
    jr .loc_6A54
.loc_6A54:
    ld de, $def7
    ld bc, $0005
    call Memcpy
    call SRAM_Disable
    ret
RuntimeEntry_Bank27_6A61::
    cp $00
    jr z, .loc_6A81
    cp $01
    jr z, .loc_6A86
    cp $02
    jr z, .loc_6A8B
    cp $03
    jr z, .loc_6A90
    cp $0a
    jr z, .loc_6A95
    cp $80
    jr z, .loc_6A90
    cp $05
    jr z, .loc_6A9A
    cp $82
    jr z, .loc_6A9F
.loc_6A81:
    ld hl, $6aa6
    jr .loc_6AA2
.loc_6A86:
    ld hl, $6aaf
    jr .loc_6AA2
.loc_6A8B:
    ld hl, $6ab9
    jr .loc_6AA2
.loc_6A90:
    ld hl, $6ac1
    jr .loc_6AA2
.loc_6A95:
    ld hl, $6acb
    jr .loc_6AA2
.loc_6A9A:
    ld hl, $6ad3
    jr .loc_6AA2
.loc_6A9F:
    ld hl, $6adc
.loc_6AA2:
    call TextPut
    ret
    assert @ == $6AA6

SECTION "Remaining ROM 27:6C7B-6C7D", ROMX[$6C7B], BANK[$27]
RemainingROM_Bank27_6C7B::
    db $66, $3f, $00
    assert @ == $6C7E

SECTION "Remaining ROM 27:7957-7996", ROMX[$7957], BANK[$27]
RemainingROM_Bank27_7957::
    ; Source-owned structural bytes formerly data/campaign/structural/bank27_7957_7996.dat
    db $00, $00, $00, $69, $ff, $7f, $40, $72, $ff, $7f, $b5, $56, $6b, $2d, $00, $00
    db $ff, $7f, $6c, $03, $08, $02, $00, $00, $00, $69, $9f, $00, $ff, $7f, $00, $00
    db $10, $42, $6b, $2d, $c6, $18, $00, $00, $9f, $53, $df, $02, $74, $01, $00, $00
    db $f0, $63, $c0, $4a, $60, $25, $00, $00, $1f, $7c, $1f, $7c, $00, $00, $ff, $7f
    assert @ == $7997

SECTION "Remaining ROM 28:434A-7FFF", ROMX[$434A], BANK[$28]
RemainingROM_Bank28_434A::
    ds $3cb6, $ff
    assert @ == $8000

SECTION "Remaining ROM 29:7EB6-7FFF", ROMX[$7EB6], BANK[$29]
RemainingROM_Bank29_7EB6::
    ds $14a, $ff
    assert @ == $8000

SECTION "Remaining ROM 2A:7CE9-7FFF", ROMX[$7CE9], BANK[$2A]
RemainingROM_Bank2A_7CE9::
    ds $317, $ff
    assert @ == $8000

SECTION "Remaining ROM 2B:79CF-7FFF", ROMX[$79CF], BANK[$2B]
RemainingROM_Bank2B_79CF::
    ds $631, $ff
    assert @ == $8000

SECTION "Remaining ROM 2C:6304-7FFF", ROMX[$6304], BANK[$2C]
RemainingROM_Bank2C_6304::
    ds $1cfc, $ff
    assert @ == $8000

SECTION "Remaining ROM 2D:74A2-7FFF", ROMX[$74A2], BANK[$2D]
RemainingROM_Bank2D_74A2::
    ds $b5e, $ff
    assert @ == $8000

SECTION "Remaining ROM 2E:7A37-7FFF", ROMX[$7A37], BANK[$2E]
RemainingROM_Bank2E_7A37::
    ds $5c9, $ff
    assert @ == $8000

SECTION "Remaining ROM 2F:7A71-7FFF", ROMX[$7A71], BANK[$2F]
RemainingROM_Bank2F_7A71::
    ds $58f, $ff
    assert @ == $8000

SECTION "Remaining ROM 30:5FF6-5FFF", ROMX[$5FF6], BANK[$30]
RemainingROM_Bank30_5FF6::
    ds $a, $00
    assert @ == $6000

SECTION "Remaining ROM 31:4000-4066", ROMX[$4000], BANK[$31]
RemainingROM_Bank31_4000::
    ; Source-owned structural bytes formerly data/network/structural/bank31_4000_4066.dat
    db $af, $ea, $d1, $c4, $ea, $d2, $c4, $af, $ea, $cc, $c4, $ea, $cd, $c4, $ea, $ce
    db $c4, $ea, $cf, $c4, $3e, $40, $ea, $d5, $c4, $3e, $2f, $ea, $d6, $c4, $3e, $31
    db $ea, $d7, $c4, $af, $ea, $d3, $c4, $3e, $1e, $ea, $d4, $c4, $c3, $8a, $02, $af
    db $ea, $d1, $c4, $ea, $d2, $c4, $af, $ea, $cc, $c4, $3e, $80, $ea, $cd, $c4, $af
    db $ea, $ce, $c4, $ea, $cf, $c4, $ea, $d5, $c4, $ea, $d6, $c4, $ea, $d7, $c4, $af
    db $ea, $d3, $c4, $3e, $96, $ea, $d4, $c4, $3e, $94, $ef, $1a, $10, $45, $fa, $d0
    db $c4, $cd, $e8, $2e, $c3, $8a, $02
    assert @ == $4067

SECTION "Remaining ROM 31:6E7B-7202", ROMX[$6E7B], BANK[$31]
RemainingROM_Bank31_6E7B::
    db $d5, $3e, $0f, $cd, $8d, $05, $cd, $93, $05, $d1, $21, $cc, $a0, $01, $00, $10, $cd, $50, $3b, $cd, $9b, $05, $c9
RuntimeEntry_Bank31_6E92::
    push bc
    push hl
    farcall Bank31_CopyFourByteStagingState_6622
    call RuntimeEntry_Bank31_6EC2
    pop hl
    pop bc
    farcall Bank31_StageAndWriteOneOrTwoDigitDecimal_6117
    farcall Bank31_FormatSelectedPersistentCursor_62C8
    farcall BANK_31, Bank31_Entry_73EC
    ret
RuntimeEntry_Bank31_6EAA::
    push bc
    push hl
    farcall Bank31_CopyFourByteStagingState_6622
    call RuntimeEntry_Bank31_6EC2
    pop hl
    pop bc
    farcall Bank31_WriteOneOrTwoDigitDecimalC_6164
    farcall Bank31_FormatSelectedPersistentCursor_62C8
    farcall BANK_31, Bank31_Entry_73EC
    ret
RuntimeEntry_Bank31_6EC2::
    ld hl, $daa8
    ld bc, $0168
    call Memcpy
    ret
RuntimeEntry_Bank31_6ECC::
    push bc
    farcall Bank31_CopyFourByteStagingState_6622
    call RuntimeEntry_Bank31_6EC2
    pop bc
    farcall Bank31_WriteOneOrTwoDigitDecimalB_619B
    farcall Bank31_FormatSelectedPersistentCursor_62C8
    farcall BANK_31, Bank31_Entry_73EC
    ret
    ; Source-owned structural bytes formerly data/network/structural/bank31_6ee2_704b.dat
    db $fe, $00, $28, $0c, $fe, $05, $28, $17, $fe, $06, $28, $1b, $fe, $07, $28, $1f
    db $ef, $19, $59, $70, $ef, $19, $41, $4d, $3e, $02, $cd, $44, $38, $18, $16, $3e
    db $05, $ef, $19, $2a, $4a, $18, $0e, $3e, $07, $ef, $19, $2a, $4a, $18, $06, $3e
    db $81, $ef, $19, $2a, $4a, $c9, $fa, $32, $da, $cd, $5f, $2f, $cd, $56, $30, $01
    db $00, $00, $11, $06, $12, $ef, $10, $fa, $68, $f0, $83, $f5, $3e, $01, $e0, $83
    db $e0, $4f, $01, $01, $01, $af, $11, $04, $10, $ef, $15, $d3, $6a, $f1, $e0, $83
    db $e0, $4f, $21, $79, $6f, $cd, $6e, $33, $21, $83, $6f, $cd, $6e, $33, $af, $ea
    db $08, $df, $ef, $22, $0d, $62, $f0, $92, $cb, $47, $28, $08, $fa, $08, $df, $cd
    db $e2, $6e, $18, $06, $cb, $4f, $28, $02, $18, $02, $18, $e6, $ef, $10, $08, $69
    db $fa, $32, $da, $cd, $45, $2f, $c9, $02, $01, $62, $8b, $62, $8b, $c3, $bd, $c4
    db $00, $02, $03, $53, $52, $41, $4d, $b8, $d8, $b1, $28, $d3, $ed, $b2, $d9, $29
    db $00, $ef, $19, $5e, $71, $f0, $83, $f5, $3e, $01, $e0, $83, $e0, $4f, $11, $b8
    db $7b, $21, $b0, $96, $01, $10, $00, $ef, $18, $50, $3b, $f1, $e0, $83, $e0, $4f
    db $01, $00, $01, $11, $03, $12, $ef, $22, $47, $62, $01, $03, $01, $11, $0e, $12
    db $ef, $22, $47, $62, $ef, $22, $b8, $64, $c9, $3e, $0f, $cd, $8d, $05, $cd, $93
    db $05, $af, $21, $0b, $df, $01, $06, $00, $cd, $79, $3b, $11, $cc, $a0, $21, $0b
    db $df, $01, $05, $00, $cd, $50, $3b, $11, $0b, $df, $21, $9b, $4a, $ef, $0a, $53
    db $4a, $30, $35, $11, $0b, $df, $21, $a1, $4a, $ef, $0a, $53, $4a, $30, $2f, $11
    db $0b, $df, $21, $a7, $4a, $ef, $0a, $53, $4a, $30, $2a, $11, $0b, $df, $21, $ad
    db $4a, $ef, $0a, $53, $4a, $30, $25, $11, $0b, $df, $21, $b3, $4a, $ef, $0a, $53
    db $4a, $30, $20, $cd, $9b, $05, $af, $c9, $cd, $9b, $05, $af, $37, $c9, $cd, $9b
    db $05, $3e, $01, $37, $c9, $cd, $9b, $05, $3e, $02, $37, $c9, $cd, $9b, $05, $3e
    db $03, $37, $c9, $cd, $9b, $05, $3e, $ff, $37, $c9
RuntimeEntry_Bank31_704C::
    farcall NetworkUI_InitializeMobileMenu
    ld bc, $0101
    ld de, $0d05
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $0e01
    ld de, $0505
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0f02
    ld de, $0303
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0106
    ld de, $120b
    farcall UIWindow_DrawFrame
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0207
    ld de, $1009
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ret
RuntimeEntry_Bank31_70A1::
    add a, a
    ld c, a
    ld b, $00
    ld hl, $70b6
    add hl, bc
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    ld bc, $0203
    call TextPrint
    ret
    ; Source-owned structural bytes formerly data/network/structural/bank31_70b6_718b.dat
    db $c0, $70, $fb, $70, $2e, $71, $5d, $71, $ff, $00, $cf, $ff, $f4, $eb, $2d, $c0
    db $79, $e8, $b3, $dd, $db, $2d, $ec, $7a, $01, $63, $69, $72, $69, $71, $ad, $63
    db $9b, $6d, $2e, $01, $71, $ad, $63, $6c, $6c, $73, $61, $70, $87, $6c, $68, $01
    db $cf, $ff, $f4, $eb, $2d, $c0, $60, $01, $e8, $b3, $dd, $db, $2d, $ec, $60, $6c
    db $7f, $6d, $66, $3f, $00, $cf, $ff, $f4, $eb, $2d, $c0, $79, $b1, $ff, $f4, $db
    db $2d, $ec, $7a, $01, $63, $69, $72, $69, $71, $ad, $63, $9b, $6d, $2e, $01, $61
    db $70, $87, $6c, $68, $cf, $ff, $f4, $eb, $2d, $c0, $60, $01, $b1, $ff, $f4, $db
    db $2d, $ec, $6c, $7f, $6d, $66, $3f, $00, $cf, $ff, $f4, $eb, $2d, $c0, $79, $6b
    db $68, $94, $ae, $7a, $01, $63, $69, $72, $69, $71, $ad, $63, $9b, $6d, $2e, $01
    db $61, $70, $87, $6c, $68, $cf, $ff, $f4, $eb, $2d, $c0, $60, $01, $6b, $68, $94
    db $ae, $6c, $7f, $6d, $66, $3f, $00, $cf, $ff, $f4, $eb, $2d, $c0, $79, $74, $63
    db $6a, $63, $7a, $01, $63, $69, $72, $69, $71, $ad, $63, $9b, $6d, $2e, $01, $61
    db $70, $87, $6c, $68, $cf, $ff, $f4, $eb, $2d, $c0, $60, $01, $74, $63, $6a, $63
    db $6c, $7f, $6d, $66, $3f, $00
RuntimeEntry_Bank31_718C::
    ld a, [$c8bb]
    ld [$cc21], a
    ld bc, $0c0f
    ld a, [$c8bb]
    call Text_QueueHexByte
    ld bc, $0e0f
    ld a, [$c8bd]
    call Text_QueueHexByte
    ld bc, $100f
    ld a, [$c8bc]
    call Text_QueueHexByte
    ld hl, $71b4
    call CoordTextPut
    ret
    db $0e, $0f, $2d, $00
RuntimeEntry_Bank31_71B8::
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0207
    ld de, $1009
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$c8bc]
    ld l, a
    ld a, [$c8bd]
    ld h, a
    ld a, [$c8bb]
    farcall BANK_33, Bank33_Entry_7461
    call RuntimeEntry_Bank00_2D2E
    ret
RuntimeEntry_Bank31_71E4::
    ld a, $30
    ld [$d6a7], a
    ld a, $30
    ld [$d6a8], a
    ld a, $30
    ld [$d6aa], a
    ld a, $30
    ld [$d6ab], a
    ld de, $7203
    call RuntimeEntry_Bank31_6EC2
    farcall BANK_22, Bank22_Entry_7DF1
    ret
    assert @ == $7203

SECTION "Remaining ROM 31:72E1-7E99", ROMX[$72E1], BANK[$31]
RemainingROM_Bank31_72E1::
    ; Source-owned structural bytes formerly data/network/structural/bank31_72e1_73aa.dat
    db $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d
    db $00, $00, $27, $15, $1c, $13, $1f, $1d, $15, $5f, $1d, $15, $23, $23, $11, $17
    db $15, $00, $00, $27, $11, $22, $23, $5f, $1e, $15, $24, $5f, $13, $15, $1e, $24
    db $15, $22, $00, $00, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d
    db $3d, $3d, $3d, $3d, $00, $00, $00, $00, $00, $ef, $31, $93, $6f, $3e, $0a, $01
    db $11, $0f, $11, $01, $01, $26, $48, $ef, $15, $fd, $67, $3e, $08, $01, $11, $10
    db $11, $01, $03, $26, $62, $ef, $15, $fd, $67, $ef, $22, $61, $77, $3e, $20, $0e
    db $00, $06, $15, $11, $b4, $6f, $cd, $e8, $2d, $ea, $31, $df, $01, $2c, $58, $cd
    db $ae, $2e, $3e, $20, $0e, $00, $06, $15, $11, $8a, $6f, $cd, $e8, $2d, $ea, $32
    db $df, $01, $94, $58, $cd, $ae, $2e, $3e, $20, $0e, $00, $06, $15, $11, $c2, $6f
    db $cd, $e8, $2d, $ea, $33, $df, $01, $60, $14, $cd, $ae, $2e, $3e, $20, $0e, $00
    db $06, $15, $11, $98, $6f, $cd, $e8, $2d, $ea, $34, $df, $01, $60, $9c, $cd, $ae
    db $2e, $ef, $22, $d2, $77, $ef, $22, $24, $78, $c9
RuntimeEntry_Bank31_73AB::
    ld a, [$ba38]
    cp $00
    jr z, .loc_73E7
    ld a, [$ba38]
    cp $14
    jr nz, .loc_73BD
    farcall BANK_22, Bank22_Entry_7D37
.loc_73BD:
    ld [$df2e], a
    dec a
    ld [$df2d], a
.loc_73C4:
    ld a, [$df2d]
    cp $ff
    jr z, .loc_73E7
    ld a, [$df2d]
    ld b, a
    ld a, [$df2e]
    ld c, a
    farcall BANK_22, Bank22_Entry_7D54
    ld a, [$df2d]
    dec a
    ld [$df2d], a
    ld a, [$df2e]
    dec a
    ld [$df2e], a
    jr .loc_73C4
.loc_73E7:
    scf
    ccf
    ret
    db $37, $c9
RuntimeEntry_Bank31_73EC::
    ld a, [$deed]
    inc a
    ld [$deed], a
    ld a, $0e
    call SwitchSRAMBank
    call SRAM_Enable
    call RuntimeEntry_Bank31_73AB
    jr c, .loc_744E
    xor a
    farcall BANK_22, Bank22_Entry_79FE
    push hl
    ld bc, $0006
    add hl, bc
    ld de, $daa8
    ld bc, $012c
    call .loc_7456
    pop hl
    push hl
    xor a
    ld bc, $0000
    add hl, bc
    ld [hli], a
    ld a, $01
    ld [hli], a
    ld a, [$d6a7]
    ld [hli], a
    ld a, [$d6a8]
    ld [hli], a
    ld a, [$d6aa]
    ld [hli], a
    ld a, [$d6ab]
    ld [hli], a
    pop hl
    ld bc, $0132
    add hl, bc
    ld a, [$cc24]
    ld [hl], a
    ld a, [$ba38]
    cp $14
    jr z, .loc_7442
    inc a
    ld [$ba38], a
.loc_7442:
    call SRAM_Disable
    farcall BANK_22, Bank22_Entry_7E5A
    farcall BattleSceneBank31Runtime_543A
    ret
.loc_744E:
    call SRAM_Disable
    farcall BattleSceneBank31Runtime_543A
    ret
.loc_7456:
    xor a
    ld [$cc2b], a
    push hl
.loc_745B:
    ld a, [de]
    cp $00
    jr z, .loc_7462
    jr .loc_746A
.loc_7462:
    push af
    xor a
    ld [$cc2b], a
    pop af
    jr .loc_746A
.loc_746A:
    push af
    cp $00
    jr z, .loc_7476
    ld a, [$cc2b]
    inc a
    ld [$cc2b], a
.loc_7476:
    cp $11
    jr z, .loc_747C
    jr .loc_7489
.loc_747C:
    ld a, [de]
    cp $00
    jr z, .loc_7485
    ld a, $00
    ld [hli], a
    ld [hli], a
.loc_7485:
    xor a
    ld [$cc2b], a
.loc_7489:
    pop af
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .loc_745B
    pop hl
    dec hl
    ld bc, $012c
    add hl, bc
    ld a, $00
    ld [hld], a
    ld [hld], a
    ld [hld], a
    ret
    ; Source-owned structural bytes formerly data/network/structural/bank31_749d_7550.dat
    db $57, $f0, $82, $f5, $3e, $03, $e0, $82, $e0, $70, $7a, $ea, $60, $d9, $cd, $ba
    db $79, $cd, $1d, $08, $cd, $a2, $05, $cd, $56, $30, $3e, $00, $ef, $15, $91, $67
    db $f0, $92, $cb, $47, $28, $07, $3e, $02, $cd, $44, $38, $18, $1f, $cb, $5f, $28
    db $07, $3e, $02, $cd, $44, $38, $18, $14, $cb, $77, $28, $05, $cd, $f5, $74, $18
    db $09, $cb, $7f, $28, $05, $cd, $13, $75, $18, $00, $18, $c8, $cd, $b4, $07, $cd
    db $67, $2e, $f1, $e0, $82, $e0, $70, $c9, $fa, $63, $d9, $3d, $fe, $ff, $20, $02
    db $18, $13, $f5, $3e, $01, $cd, $44, $38, $f1, $ea, $63, $d9, $cd, $07, $79, $cd
    db $18, $79, $cd, $7f, $78, $c9, $fa, $76, $d9, $4f, $fa, $62, $d9, $b9, $28, $33
    db $38, $31, $fa, $63, $d9, $3c, $4f, $fa, $76, $d9, $57, $fa, $62, $d9, $92, $b9
    db $30, $0a, $fa, $76, $d9, $4f, $fa, $62, $d9, $91, $18, $0b, $f5, $3e, $01, $cd
    db $44, $38, $f1, $fa, $63, $d9, $3c, $ea, $63, $d9, $cd, $07, $79, $cd, $18, $79
    db $cd, $7f, $78, $c9
RuntimeEntry_Bank31_7551::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld a, [$d961]
    cp $00
    jr z, .loc_75BB
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $7797
    ld hl, $9010
    ld bc, $0040
    farcall BANK_27, Bank27_Entry_3B50
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $02
    farcall Gfx_DrawSequentialTileRectWithAttributes
.loc_75BB:
    ld bc, $0101
    ld de, $1203
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, [$d960]
    add a, a
    ld hl, $7a53
    call AddAtoHL
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld h, d
    ld l, e
    ld bc, $0202
    call TextPut
    ld bc, $0105
    ld de, $120c
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call SpriteObject_Create
    ld [$d977], a
    ld bc, $583c
    call SpriteObject_SetPosition
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [$d978], a
    ld bc, $5894
    call SpriteObject_SetPosition
    ld a, $0a
    ld [$d976], a
    xor a
    ld [$d963], a
    call RuntimeEntry_Bank31_7907
    call RuntimeEntry_Bank31_78D3
    call RuntimeEntry_Bank31_7907
    call RuntimeEntry_Bank31_7918
    call RuntimeEntry_Bank31_787F
    ret
RuntimeEntry_Bank31_7628::
    ld d, a
    ldh a, [$ff82]
    push af
    ld a, $03
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ld [$d960], a
    ld a, b
    ld [$d961], a
    call RuntimeEntry_Bank31_7551
    call FadeFromWhite8
.loc_7640:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 0, a
    jr z, .loc_765A
    ld a, $02
    call Audio_PlaySFX
    xor a
    jr .loc_768E
.loc_765A:
    bit 1, a
    jr z, .loc_766E
    ld a, [$d961]
    cp $00
    jr z, .loc_768C
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .loc_768E
.loc_766E:
    bit 3, a
    jr z, .loc_767A
    ld a, $02
    call Audio_PlaySFX
    xor a
    jr .loc_768E
.loc_767A:
    bit 6, a
    jr z, .loc_7683
    call .loc_769E
    jr .loc_768C
.loc_7683:
    bit 7, a
    jr z, .loc_768C
    call .loc_76BC
    jr .loc_768C
.loc_768C:
    jr .loc_7640
.loc_768E:
    push af
    call FadeToWhite8
    call SpriteObject_DestroyAll
    pop af
    ld d, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ret
.loc_769E:
    ld a, [$d963]
    dec a
    cp $ff
    jr nz, .loc_76A8
    jr .loc_76BB
.loc_76A8:
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [$d963], a
    call RuntimeEntry_Bank31_7907
    call RuntimeEntry_Bank31_7918
    call RuntimeEntry_Bank31_787F
.loc_76BB:
    ret
.loc_76BC:
    ld a, [$d976]
    ld c, a
    ld a, [$d962]
    cp c
    jr z, .loc_76F9
    jr c, .loc_76F9
    ld a, [$d963]
    inc a
    ld c, a
    ld a, [$d976]
    ld d, a
    ld a, [$d962]
    sub d
    cp c
    jr nc, .loc_76E2
    ld a, [$d976]
    ld c, a
    ld a, [$d962]
    sub c
    jr .loc_76ED
.loc_76E2:
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [$d963]
    inc a
.loc_76ED:
    ld [$d963], a
    call RuntimeEntry_Bank31_7907
    call RuntimeEntry_Bank31_7918
    call RuntimeEntry_Bank31_787F
.loc_76F9:
    ret
RuntimeEntry_Bank31_76FA::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $7797
    ld hl, $9010
    ld bc, $0040
    farcall BANK_27, Bank27_Entry_3B50
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $0a
    ld bc, $0f11
    ld de, $0101
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1011
    ld de, $0301
    ld h, $02
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld bc, $0101
    ld de, $1203
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, $7a8a
    ld bc, $0202
    call TextPut
    ld bc, $0105
    ld de, $120c
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call SpriteObject_Create
    ld [$d977], a
    ld bc, $583c
    call SpriteObject_SetPosition
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [$d978], a
    ld bc, $5894
    call SpriteObject_SetPosition
    ld a, $0a
    ld [$d976], a
    xor a
    ld [$d963], a
    ld hl, $7e5e
    call RuntimeEntry_Bank31_78D3
    ld hl, $7e5e
    call RuntimeEntry_Bank31_7918
    call RuntimeEntry_Bank31_787F
    ret
RuntimeEntry_Bank31_77BD::
    ldh a, [$ff82]
    push af
    ld a, $03
    ldh [$ff82], a
    ldh [$ff70], a
    call RuntimeEntry_Bank31_76FA
    call FadeFromWhite8
.loc_77CC:
    call Joypad_Update
    call Sprite_Update
    ld a, $00
    farcall Gfx_UpdateCommonAnimatedTile
    ldh a, [$ff92]
    bit 0, a
    jr z, .loc_77E6
    ld a, $02
    call Audio_PlaySFX
    xor a
    jr .loc_7813
.loc_77E6:
    bit 1, a
    jr z, .loc_77F3
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    ld a, $ff
    jr .loc_7813
.loc_77F3:
    bit 3, a
    jr z, .loc_77FF
    ld a, $02
    call Audio_PlaySFX
    xor a
    jr .loc_7813
.loc_77FF:
    bit 6, a
    jr z, .loc_7808
    call .loc_7823
    jr .loc_7811
.loc_7808:
    bit 7, a
    jr z, .loc_7811
    call .loc_7841
    jr .loc_7811
.loc_7811:
    jr .loc_77CC
.loc_7813:
    push af
    call FadeToWhite8
    call SpriteObject_DestroyAll
    pop af
    ld d, a
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, d
    ret
.loc_7823:
    ld a, [$d963]
    dec a
    cp $ff
    jr nz, .loc_782D
    jr .loc_7840
.loc_782D:
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld [$d963], a
    ld hl, $7e5e
    call RuntimeEntry_Bank31_7918
    call RuntimeEntry_Bank31_787F
.loc_7840:
    ret
.loc_7841:
    ld a, [$d976]
    ld c, a
    ld a, [$d962]
    cp c
    jr z, .loc_787E
    jr c, .loc_787E
    ld a, [$d963]
    inc a
    ld c, a
    ld a, [$d976]
    ld d, a
    ld a, [$d962]
    sub d
    cp c
    jr nc, .loc_7867
    ld a, [$d976]
    ld c, a
    ld a, [$d962]
    sub c
    jr .loc_7872
.loc_7867:
    push af
    ld a, $01
    call Audio_PlaySFX
    pop af
    ld a, [$d963]
    inc a
.loc_7872:
    ld [$d963], a
    ld hl, $7e5e
    call RuntimeEntry_Bank31_7918
    call RuntimeEntry_Bank31_787F
.loc_787E:
    ret
RuntimeEntry_Bank31_787F::
    ld a, [$d962]
    ld c, a
    ld a, [$d976]
    cp c
    jr nc, .loc_78B0
    ld a, [$d963]
    cp $00
    jr nz, .loc_7895
    call .loc_78C5
    jr .loc_7898
.loc_7895:
    call .loc_78B7
.loc_7898:
    ld a, [$d976]
    ld c, a
    ld a, [$d962]
    sub c
    ld c, a
    ld a, [$d963]
    cp c
    jr z, .loc_78AC
    call .loc_78BE
    jr .loc_78AF
.loc_78AC:
    call .loc_78CC
.loc_78AF:
    ret
.loc_78B0:
    call .loc_78C5
    call .loc_78CC
    ret
.loc_78B7:
    ld a, [$d977]
    call SpriteObject_Show
    ret
.loc_78BE:
    ld a, [$d978]
    call SpriteObject_Show
    ret
.loc_78C5:
    ld a, [$d977]
    call SpriteObject_Hide
    ret
.loc_78CC:
    ld a, [$d978]
    call SpriteObject_Hide
    ret
RuntimeEntry_Bank31_78D3::
    ld d, $00
.loc_78D5:
    ld a, [hli]
    cp $00
    jr z, .loc_78E1
    cp $01
    jr nz, .loc_78DF
    inc d
.loc_78DF:
    jr .loc_78D5
.loc_78E1:
    inc d
    ld a, d
    ld [$d962], a
    ret
RuntimeEntry_Bank31_78E7::
    ld a, [hl]
    cp $01
    jr z, .loc_78EF
    inc hl
    jr RuntimeEntry_Bank31_78E7
.loc_78EF:
    inc hl
    ret
RuntimeEntry_Bank31_78F1::
    ld a, [$d963]
    cp $00
    jr z, .loc_7906
    ld d, $00
.loc_78FA:
    call RuntimeEntry_Bank31_78E7
    inc d
    ld a, [$d963]
    cp d
    jr z, .loc_7906
    jr .loc_78FA
.loc_7906:
    ret
RuntimeEntry_Bank31_7907::
    ld a, [$d960]
    add a, a
    ld hl, $7a97
    call AddAtoHL
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld h, d
    ld l, e
    ret
RuntimeEntry_Bank31_7918::
    call RuntimeEntry_Bank31_78F1
    ld bc, $0206
    ld a, b
    ld [$cbc9], a
    ld a, c
    ld [$cbcb], a
    xor a
    ld [$cbca], a
    ld [$d964], a
.loc_792D:
    push hl
    ld hl, $d965
    ld bc, $0010
    ld a, $20
    call MemsetWaitLCD
    pop hl
    ld a, $00
    ld [$d975], a
.loc_793F:
    ld a, [hli]
    cp $00
    jr z, .loc_79A8
    cp $01
    jr nz, .loc_794A
    jr .loc_7972
.loc_794A:
    ld a, [$cbca]
    ld c, a
    ld a, [$cbc9]
    add a, c
    ld b, a
    ld a, [$cbcb]
    ld c, a
    dec hl
    ld a, [hl]
    push hl
    push af
    ld a, [$cbca]
    ld c, a
    ld b, $00
    ld hl, $d965
    add hl, bc
    pop af
    ld [hl], a
    pop hl
    ld a, [$cbca]
    inc a
    ld [$cbca], a
    inc hl
    jr .loc_793F
.loc_7972:
    push hl
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [$cbc9]
    ld b, a
    ld a, [$cbcb]
    ld c, a
    call Vram_TilemapCoord
    ld de, $d965
    call Vram_DrawZeroTerminatedRow
    pop hl
    xor a
    ld [$cbca], a
    ld a, [$cbcb]
    inc a
    ld [$cbcb], a
    ld a, [$d976]
    dec a
    ld c, a
    ld a, [$d964]
    inc a
    ld [$d964], a
    dec a
    cp c
    jr z, .loc_79B9
    jr .loc_792D
.loc_79A8:
    push hl
    ld hl, $d965
    ld a, [$cbc9]
    ld b, a
    ld a, [$cbcb]
    ld c, a
    call TextPut
    pop hl
    ret
.loc_79B9:
    ret
Network31_79BA_79BA::
    call LCD_Disable
    call VBlankFIFO_Clear
    call SpriteObject_ResetAll
    farcall UIWindowStack_Init
    farcall SharedGraphics_LoadMainFontBG
    call Vram_ResetPals
    xor a
    ldh [$ff95], a
    ldh [$ff96], a
    ldh [$ff97], a
    ldh [$ff98], a
    call Vram_ClearBGTilemapBothBanks
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    farcall Gfx_LoadCommonScreenAssets
    ld bc, $0101
    ld de, $1203
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, [$d960]
    add a, a
    ld hl, $7a53
    call AddAtoHL
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    ld h, d
    ld l, e
    ld bc, $0202
    call TextPut
    ld bc, $0105
    ld de, $120c
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6fb4
    call SpriteObject_Create
    ld [$d977], a
    ld bc, $583c
    call SpriteObject_SetPosition
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [$d978], a
    ld bc, $5894
    call SpriteObject_SetPosition
    ld a, $0a
    ld [$d976], a
    xor a
    ld [$d963], a
    call RuntimeEntry_Bank31_7907
    call RuntimeEntry_Bank31_78D3
    call RuntimeEntry_Bank31_7907
    call RuntimeEntry_Bank31_7918
    call RuntimeEntry_Bank31_787F
    ret
    db $5b, $7a, $68, $7a, $75, $7a, $82, $7a, $d5, $c6, $ff, $c4, $79, $7a, $62, $71
    db $76, $72, $62, $73, $00, $d5, $c6, $ff, $c4, $79, $6c, $8d, $66, $76, $72, $62
    db $73, $00, $86, $63, $7d, $62, $d5, $c6, $ff, $c4, $76, $72, $62, $73, $00, $ed
    db $ff, $e4, $76, $72, $62, $73, $00, $6c, $8a, $62, $7e, $8d, $9f, $86, $88, $72
    db $63, $6c, $8d, $00, $9f, $7a, $6d, $7b, $86, $7c, $8d, $7d, $b7, $fc, $dd, $f5
    db $2d, $dd, $d3, $2d, $ec, $9b, $7a, $01, $7f, $64, $79, $4d, $41, $50, $9b, $72
    db $66, $af, $70, $d5, $c6, $ff, $c4, $60, $01, $72, $8f, $79, $4d, $41, $50, $9b
    db $83, $01, $72, $66, $63, $6a, $74, $8e, $9b, $67, $7f, $6d, $2e, $01, $01, $ba
    db $cf, $dd, $ec, $d2, $c6, $fd, $2d, $79, $1b, $9f, $70, $62, $1d, $9b, $01, $d5
    db $c6, $ff, $c4, $62, $71, $87, $8d, $66, $87, $01, $72, $66, $62, $70, $62, $d5
    db $c6, $ff, $c4, $60, $64, $87, $9e, $01, $4d, $41, $50, $76, $7a, $62, $71, $6c
    db $7f, $6d, $2e, $01, $01, $7a, $62, $71, $9b, $67, $89, $79, $7a, $01, $6f, $79
    db $d5, $c6, $ff, $c4, $60, $6e, $62, $6b, $8d, $9b, $67, $89, $01, $70, $73, $83
    db $79, $98, $69, $9b, $6d, $2e, $01, $01, $d5, $c6, $ff, $c4, $7a, $2c, $6f, $8a
    db $97, $8a, $01, $74, $68, $73, $62, $79, $6a, $63, $9c, $63, $60, $6d, $89, $74
    db $01, $da, $f0, $d9, $8e, $61, $8e, $88, $7f, $6d, $2e, $01, $01, $d5, $c6, $ff
    db $c4, $79, $da, $f0, $d9, $60, $61, $91, $89, $74, $01, $6e, $8d, $74, $63, $8e
    db $85, $63, $88, $76, $75, $88, $7f, $6d, $2e, $00, $da, $f0, $d9, $53, $76, $75
    db $af, $70, $d5, $c6, $ff, $c4, $7a, $01, $71, $8e, $63, $d5, $c6, $ff, $c4, $76
    db $6c, $8d, $66, $9b, $67, $7f, $6d, $2e, $01, $01, $70, $98, $6c, $2c, $d5, $c6
    db $ff, $c4, $76, $7a, $01, $6c, $8d, $66, $6d, $89, $83, $79, $74, $01, $6c, $75
    db $62, $83, $79, $8e, $61, $88, $7f, $6d, $2e, $01, $01, $d2, $c6, $fd, $2d, $79
    db $1b, $9f, $70, $62, $1d, $9b, $01, $d5, $c6, $ff, $c4, $62, $71, $87, $8d, $60
    db $80, $73, $01, $da, $f0, $d9, $53, $79, $86, $6a, $76, $01, $84, $94, $89, $6c
    db $b1, $b2, $ba, $dd, $8e, $61, $88, $01, $6f, $79, $d5, $c6, $ff, $c4, $8e, $80
    db $7a, $62, $71, $79, $74, $67, $01, $6c, $8d, $66, $6d, $89, $6a, $74, $8e, $9b
    db $67, $7f, $6d, $2e, $01, $01, $1b, $53, $45, $4c, $45, $43, $54, $1d, $60, $65
    db $6d, $74, $01, $d5, $c6, $ff, $c4, $94, $ae, $63, $7e, $63, $8e, $82, $8d, $8e
    db $01, $7b, $ae, $63, $94, $6b, $8a, $7f, $6d, $2e, $01, $01, $6f, $79, $8e, $82
    db $8d, $79, $1b, $6c, $8d, $66, $1d, $60, $80, $89, $74, $01, $6c, $8d, $66, $9b
    db $67, $89, $66, $2c, $01, $7f, $70, $2c, $6c, $8d, $66, $6c, $70, $87, $01, $9c
    db $8d, $75, $d5, $c6, $ff, $c4, $76, $75, $89, $66, $01, $6c, $87, $a0, $89, $6a
    db $74, $8e, $9b, $67, $7f, $6d, $2e, $01, $01, $6c, $8d, $66, $6d, $89, $74, $01
    db $d5, $c6, $ff, $c4, $79, $74, $68, $6e, $62, $8e, $01, $66, $8c, $89, $9d, $61
    db $62, $8e, $61, $89, $79, $9b, $01, $71, $ad, $63, $62, $6c, $73, $68, $98, $6b
    db $62, $2e, $00, $d3, $ed, $b2, $d9, $bc, $bd, $c3, $d1, $47, $42, $60, $72, $66
    db $af, $73, $01, $86, $63, $7d, $62, $d5, $c6, $ff, $c4, $60, $86, $a0, $7f, $6d
    db $2e, $01, $01, $86, $63, $7d, $62, $d5, $c6, $ff, $c4, $60, $86, $a0, $89, $79
    db $7a, $01, $c2, $b3, $bc, $dd, $c4, $b3, $8e, $61, $89, $4d, $41, $50, $9b, $6d
    db $2e, $01, $01, $c2, $b3, $bc, $dd, $c4, $b3, $60, $6e, $8d, $88, $ae, $63, $6d
    db $89, $74, $01, $ba, $cf, $dd, $ec, $d2, $c6, $fd, $2d, $76, $01, $1b, $72, $63
    db $6c, $8d, $1d, $8e, $7c, $64, $7f, $6d, $2e, $01, $01, $94, $90, $8d, $8e, $6a
    db $63, $9c, $63, $9b, $67, $89, $74, $67, $76, $01, $1b, $72, $63, $6c, $8d, $1d
    db $60, $64, $87, $a0, $9d, $01, $86, $63, $7d, $62, $d5, $c6, $ff, $c4, $60, $86
    db $a0, $7f, $6d, $2e, $01, $01, $35, $6c, $ad, $89, $62, $79, $01, $86, $63, $7d
    db $62, $d5, $c6, $ff, $c4, $8e, $62, $89, $79, $9b, $01, $94, $ae, $63, $67, $ae
    db $63, $76, $65, $63, $94, $73, $01, $64, $87, $8d, $9b, $68, $98, $6b, $62, $2e
    db $01, $01, $86, $63, $7d, $62, $d5, $c6, $ff, $c4, $7a, $01, $31, $4d, $41, $50
    db $76, $72, $67, $01, $31, $9f, $70, $62, $60, $31, $66, $62, $98, $69, $01, $86
    db $9f, $6a, $74, $8e, $9b, $67, $7f, $6d, $2e, $01, $01, $94, $90, $8d, $79, $d5
    db $c6, $ff, $c4, $8e, $01, $6d, $9b, $76, $35, $30, $9f, $70, $62, $62, $89, $74
    db $67, $7a, $01, $86, $a0, $7f, $6e, $8d, $2e, $00, $b3, $fb, $2d, $e5, $c8, $ff
    db $c4, $bb, $2d, $ee, $bd, $60, $01, $88, $86, $63, $6c, $73, $62, $89, $74, $01
    db $1b, $ed, $ff, $e4, $1d, $8e, $83, $87, $64, $89, $6a, $74, $8e, $01, $61, $88
    db $7f, $6d, $2e, $01, $01, $d5, $c6, $ff, $c4, $76, $70, $62, $6c, $73, $01, $ed
    db $ff, $e4, $60, $72, $66, $63, $74, $01, $da, $f0, $d9, $8e, $61, $8e, $88, $84
    db $6d, $68, $75, $88, $7f, $6d, $2e, $01, $01, $ba, $cf, $dd, $ec, $d2, $c6, $fd
    db $2d, $79, $1b, $9f, $70, $62, $1d, $9b, $01, $d5, $c6, $ff, $c4, $62, $71, $87
    db $8d, $66, $87, $01, $ed, $ff, $e4, $60, $72, $66, $62, $70, $62, $01, $d5, $c6
    db $ff, $c4, $60, $64, $87, $9e, $01, $1b, $ed, $ff, $e4, $94, $ad, $86, $1d, $60
    db $01, $6e, $8d, $70, $68, $6c, $7f, $6d, $2e, $01, $01, $da, $f0, $d9, $53, $76
    db $75, $af, $70, $d5, $c6, $ff, $c4, $76, $7a, $01, $ed, $ff, $e4, $60, $72, $66
    db $64, $7f, $6e, $8d, $2e, $01, $01, $b3, $fb, $2d, $e5, $c8, $ff, $c4, $bb, $2d
    db $ee, $bd, $60, $01, $88, $86, $63, $6d, $89, $7e, $9c, $01, $70, $68, $6b, $8d
    db $ed, $ff, $e4, $8e, $83, $87, $64, $7f, $6d, $2e, $00, $6a, $8a, $9b, $6c, $8a
    db $62, $7e, $8d, $9f, $66, $87, $79, $01, $72, $63, $6c, $8d, $60, $6c, $ad, $63
    db $88, $ae, $63, $6c, $7f, $6d, $2e, $01, $01, $1b, $42, $1d, $60, $65, $6d, $74
    db $01, $83, $63, $62, $71, $9c, $6e, $72, $82, $62, $60, $01, $86, $81, $6a, $74
    db $8e, $9b, $67, $7f, $6d, $2e, $00
    assert @ == $7E9A

SECTION "Remaining ROM 32:4000-43CC", ROMX[$4000], BANK[$32]
RemainingROM_Bank32_4000::
    farcall NetworkUI_InitializeMobileMenu
    ld bc, $0101
    ld de, $1205
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld bc, $0106
    ld de, $120b
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld hl, $4035
    call CoordTextPut
    ld a, [$cab0]
    ld [$c8bb], a
    ld a, [$cab1]
    ld [$c8bc], a
    ld a, [$cab2]
    ld [$c8bd], a
    farcall RuntimeEntry_Bank31_71B8
    ret
    db $02, $02, $b4, $d7, $2d, $00
Mobile32_4000_403B::
    call RemainingROM_Bank32_4000
    call FadeFromWhite8
Mobile32_4000_4041::
    farcall MapMenuMessage_ServiceFrame
    ldh a, [$ff91]
    and $0b
    jr z, Mobile32_4000_4041
    ld a, $02
    call Audio_PlaySFX
    jr Mobile32_4000_4052
Mobile32_4000_4052::
    ld a, $ff
    ret
    db $a7, $43, $bb, $40, $cc, $40, $dd, $40, $ee, $40, $ff, $40, $10, $41, $21, $41
    db $32, $41, $43, $41, $54, $41, $65, $41, $76, $41, $87, $41, $98, $41, $a9, $41
    db $ba, $41, $cb, $41, $dc, $41, $a7, $43, $a7, $43, $a7, $43, $a7, $43, $0f, $42
    db $20, $42, $cb, $41, $dc, $41, $31, $42, $42, $42, $53, $42, $64, $42, $75, $42
    db $86, $42, $97, $42, $a8, $42, $b9, $42, $ca, $42, $db, $42, $ec, $42, $fd, $42
    db $0e, $43, $a7, $43, $a7, $43, $1f, $43, $30, $43, $41, $43, $52, $43, $63, $43
    db $74, $43, $85, $43, $96, $43, $53, $59, $53, $20, $4f, $50, $45, $4e, $20, $20
    db $20, $20, $20, $20, $20, $20, $00, $53, $59, $53, $20, $4f, $50, $45, $4e, $20
    db $57, $41, $49, $54, $20, $20, $20, $00, $50, $50, $50, $20, $43, $4f, $4e, $4e
    db $45, $43, $54, $20, $20, $20, $20, $20, $00, $50, $50, $50, $20, $43, $4f, $4e
    db $4e, $45, $43, $54, $20, $57, $41, $49, $54, $00, $4f, $46, $46, $4c, $49, $4e
    db $45, $20, $20, $20, $20, $20, $20, $20, $20, $20, $00, $4f, $46, $46, $4c, $49
    db $4e, $45, $20, $57, $41, $49, $54, $20, $20, $20, $20, $00, $53, $59, $53, $20
    db $43, $4c, $4f, $53, $45, $20, $20, $20, $20, $20, $20, $20, $00, $53, $59, $53
    db $20, $43, $4c, $4f, $53, $45, $20, $57, $41, $49, $54, $20, $20, $00, $50, $4f
    db $50, $33, $20, $53, $54, $41, $52, $54, $20, $20, $20, $20, $20, $20, $00, $50
    db $4f, $50, $33, $20, $53, $54, $41, $52, $54, $20, $57, $41, $49, $54, $20, $00
    db $50, $4f, $50, $33, $20, $45, $4e, $44, $20, $20, $20, $20, $20, $20, $20, $20
    db $00, $50, $4f, $50, $33, $20, $45, $4e, $44, $20, $57, $41, $49, $54, $20, $20
    db $20, $00, $4d, $41, $49, $4c, $20, $43, $4f, $55, $4e, $54, $20, $20, $20, $20
    db $20, $20, $00, $4d, $41, $49, $4c, $20, $43, $4f, $55, $4e, $54, $20, $57, $41
    db $49, $54, $20, $00, $4d, $41, $49, $4c, $20, $48, $20, $52, $45, $41, $44, $20
    db $20, $20, $20, $20, $00, $4d, $41, $49, $4c, $20, $48, $20, $52, $45, $41, $44
    db $20, $57, $41, $49, $54, $00, $4d, $41, $49, $4c, $20, $44, $45, $4c, $45, $54
    db $45, $20, $20, $20, $20, $20, $00, $4d, $41, $49, $4c, $20, $44, $45, $4c, $45
    db $54, $45, $20, $57, $41, $49, $54, $00, $4d, $41, $49, $4c, $20, $52, $45, $41
    db $44, $20, $20, $20, $20, $20, $20, $20, $00, $4d, $41, $49, $4c, $20, $52, $45
    db $41, $44, $20, $57, $41, $49, $54, $20, $20, $00, $4d, $41, $49, $4c, $20, $44
    db $52, $4f, $50, $20, $20, $20, $20, $20, $20, $20, $00, $4d, $41, $49, $4c, $20
    db $44, $52, $4f, $50, $20, $57, $41, $49, $54, $20, $20, $00, $4b, $41, $4b, $49
    db $4e, $20, $52, $45, $41, $44, $20, $20, $20, $20, $20, $20, $00, $4b, $41, $4b
    db $49, $4e, $20, $52, $45, $41, $44, $20, $57, $41, $49, $54, $20, $00, $44, $4f
    db $20, $4b, $41, $4b, $49, $4e, $20, $20, $20, $20, $20, $20, $20, $20, $00, $44
    db $4f, $20, $4b, $41, $4b, $49, $4e, $20, $57, $41, $49, $54, $20, $20, $20, $00
    db $4b, $41, $4b, $49, $4e, $20, $44, $4c, $20, $20, $20, $20, $20, $20, $20, $20
    db $00, $4b, $41, $4b, $49, $4e, $20, $44, $4c, $20, $57, $41, $49, $54, $20, $20
    db $20, $00, $50, $4f, $53, $54, $20, $43, $4d, $44, $50, $4b, $54, $20, $20, $20
    db $20, $20, $00, $50, $4f, $53, $54, $20, $43, $4d, $44, $50, $4b, $54, $20, $57
    db $41, $49, $54, $00, $4b, $41, $4b, $49, $4e, $20, $20, $20, $20, $20, $20, $20
    db $20, $20, $20, $20, $00, $4b, $41, $4b, $49, $4e, $20, $57, $41, $49, $54, $20
    db $20, $20, $20, $20, $20, $00, $50, $4f, $53, $54, $20, $4e, $4f, $4f, $50, $20
    db $20, $20, $20, $20, $20, $20, $00, $50, $4f, $53, $54, $20, $4e, $4f, $4f, $50
    db $20, $57, $41, $49, $54, $20, $20, $00, $50, $4f, $53, $54, $20, $45, $4e, $47
    db $55, $4e, $20, $20, $20, $20, $20, $20, $00, $50, $4f, $53, $54, $20, $45, $4e
    db $47, $55, $4e, $20, $57, $41, $49, $54, $20, $00, $43, $41, $4e, $43, $45, $4c
    db $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $00, $43, $41, $4e, $43, $45
    db $4c, $20, $57, $41, $49, $54, $20, $20, $20, $20, $20, $00, $47, $45, $54, $20
    db $53, $46, $49, $4c, $45, $20, $20, $20, $20, $20, $20, $20, $00, $47, $45, $54
    db $20, $53, $46, $49, $4c, $45, $20, $20, $57, $41, $49, $54, $20, $00, $47, $45
    db $54, $20, $4d, $42, $4f, $58, $20, $20, $20, $20, $20, $20, $20, $20, $00, $47
    db $45, $54, $20, $4d, $42, $4f, $58, $20, $20, $20, $57, $41, $49, $54, $20, $00
    db $47, $45, $54, $20, $53, $45, $52, $49, $41, $4c, $20, $20, $20, $20, $20, $20
    db $00, $47, $45, $54, $20, $53, $45, $52, $49, $41, $4c, $20, $57, $41, $49, $54
    db $20, $00, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
    db $20, $20, $00
RuntimeEntry_Bank32_43B8::
    add a, a
    ld c, a
    ld b, $00
    ld hl, $43cd
    add hl, bc
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    ld bc, $0202
    call TextPrint
    ret
    assert @ == $43CD

SECTION "Remaining ROM 32:4659-4688", ROMX[$4659], BANK[$32]
RemainingROM_Bank32_4659::
RuntimeEntry_Bank32_4659::
    push af
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0207
    ld de, $1008
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    pop af
    add a, a
    ld c, a
    ld b, $00
    ld hl, $4689
    add hl, bc
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld b, a
    ld h, b
    ld l, c
    ld bc, $0207
    call TextPrint
    ret
    assert @ == $4689

SECTION "Remaining ROM 32:4D1F-577C", ROMX[$4D1F], BANK[$32]
RemainingROM_Bank32_4D1F::
RuntimeEntry_Bank32_4D1F::
    ld a, $02
    call Audio_PlayMusic
    ret
RuntimeEntry_Bank32_4D25::
    call Audio_StopMusic
    call Audio_StopSFX
    ret
RuntimeEntry_Bank32_4D2C::
    cp $00
    jr z, .loc_4D38
    cp $01
    jr z, .loc_4D3D
    cp $02
    jr z, .loc_4D42
.loc_4D38:
    ld de, $5f25
    jr .loc_4D45
.loc_4D3D:
    ld de, $5f33
    jr .loc_4D45
.loc_4D42:
    ld de, $5f38
.loc_4D45:
    ld a, [$def2]
    ld b, $22
    call SpriteObject_SetAnimation
    ret
RuntimeEntry_Bank32_4D4E::
    ld a, [$da34]
    cp $00
    jr z, .loc_4D5E
    cp $01
    jr z, .loc_4DBB
    cp $02
    jp z, .loc_4E18
.loc_4D5E:
    ld a, $56
    ld [$da39], a
    ld a, $1f
    ld [$da3a], a
    ld hl, $561f
    ld bc, $0105
    call TextPut
    ld hl, $5631
    ld bc, $0107
    call TextPut
    ld hl, $5643
    ld bc, $0109
    call TextPut
    ld hl, $5655
    ld bc, $010b
    call TextPut
    ld hl, $5667
    ld bc, $010d
    call TextPut
    ld hl, $5679
    ld bc, $010f
    call TextPut
    ld a, $0b
    ld bc, $0d0d
    ld de, $0501
    ld h, $06
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0b
    ld bc, $0d0f
    ld de, $0501
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
.loc_4DBB:
    ld a, $56
    ld [$da39], a
    ld a, $8b
    ld [$da3a], a
    ld hl, $568b
    ld bc, $0105
    call TextPut
    ld hl, $569d
    ld bc, $0107
    call TextPut
    ld hl, $56af
    ld bc, $0109
    call TextPut
    ld hl, $56c1
    ld bc, $010b
    call TextPut
    ld hl, $56d3
    ld bc, $010d
    call TextPut
    ld hl, $56e5
    ld bc, $010f
    call TextPut
    ld a, $0b
    ld bc, $0d0d
    ld de, $0501
    ld h, $0b
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0b
    ld bc, $0d0f
    ld de, $0501
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
.loc_4E18:
    ld a, $56
    ld [$da39], a
    ld a, $f7
    ld [$da3a], a
    ld hl, $56f7
    ld bc, $0105
    call TextPut
    ld hl, $5709
    ld bc, $0107
    call TextPut
    ld hl, $571b
    ld bc, $0109
    call TextPut
    ld hl, $572d
    ld bc, $010b
    call TextPut
    ld hl, $573f
    ld bc, $010d
    call TextPut
    ld hl, $5751
    ld bc, $010f
    call TextPut
    ld a, $0b
    ld bc, $0d0d
    ld de, $0501
    ld h, $10
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0b
    ld bc, $0d0f
    ld de, $0501
    ld h, $01
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ret
RuntimeEntry_Bank32_4E75::
    ld a, [$da33]
    cp $00
    jr z, .loc_4E85
    cp $01
    jr z, .loc_4E96
    cp $02
    jr z, .loc_4EA7
.loc_4E84:
    ret
.loc_4E85:
    ld a, [$da3d]
    cp $00
    jr z, .loc_4E84
    ld hl, $d839
    ld bc, $0601
    call TextPut
    ret
.loc_4E96:
    ld a, [$da3d]
    cp $00
    jr z, .loc_4E84
    ld hl, $d846
    ld bc, $0601
    call TextPut
    ret
.loc_4EA7:
    ld a, [$da3d]
    cp $00
    jr z, .loc_4E84
    ld hl, $d853
    ld bc, $0c01
    call TextPut
    ret
RuntimeEntry_Bank32_4EB8::
    ld a, [$da33]
    cp $00
    jr z, .loc_4EC7
    cp $01
    jr z, .loc_4EDA
    cp $02
    jr z, .loc_4EED
.loc_4EC7:
    ld a, [$da3d]
    ld c, a
    ld a, $0c
    sub c
    ld bc, $0601
    push af
    ld a, [$da3d]
    add a, b
    ld b, a
    pop af
    jr .loc_4F00
.loc_4EDA:
    ld a, [$da3d]
    ld c, a
    ld a, $0c
    sub c
    ld bc, $0601
    push af
    ld a, [$da3d]
    add a, b
    ld b, a
    pop af
    jr .loc_4F00
.loc_4EED:
    ld a, [$da3d]
    ld c, a
    ld a, $06
    sub c
    ld bc, $0c01
    push af
    ld a, [$da3d]
    add a, b
    ld b, a
    pop af
    jr .loc_4F00
.loc_4F00:
    call .loc_4F04
    ret
.loc_4F04:
    cp $00
    jr z, .loc_4F34
    ld d, a
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, d
    push af
    call Vram_TilemapCoord
    pop af
    ld b, $00
    ld c, a
    ld a, $15
    push hl
    push bc
    call Memset
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    pop bc
    pop hl
    ld a, $08
    call Memset
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
.loc_4F34:
    ret
RuntimeEntry_Bank32_4F35::
    ld b, $00
.loc_4F37:
    ld a, [hli]
    cp $00
    jr z, .loc_4F41
    ld a, b
    inc a
    ld b, a
    jr .loc_4F37
.loc_4F41:
    ld a, b
    ret
RuntimeEntry_Bank32_4F43::
    ld a, [$da3c]
    cp $00
    jr z, .loc_4F4E
    cp $01
    jr z, .loc_4F7F
.loc_4F4E:
    ld a, [$da33]
    cp $00
    jr z, .loc_4F5D
    cp $01
    jr z, .loc_4F65
    cp $02
    jr z, .loc_4F6D
.loc_4F5D:
    ld hl, $d839
    ld bc, $000d
    jr .loc_4F75
.loc_4F65:
    ld hl, $d846
    ld bc, $000d
    jr .loc_4F75
.loc_4F6D:
    ld hl, $d853
    ld bc, $0007
    jr .loc_4F75
.loc_4F75:
    ld a, $00
    call Memset
    xor a
    ld [$da3d], a
    ret
.loc_4F7F:
    ld a, [$da33]
    cp $00
    jr z, .loc_4F8E
    cp $01
    jr z, .loc_4F98
    cp $02
    jr z, .loc_4FA2
.loc_4F8E:
    ld hl, $d839
    call RuntimeEntry_Bank32_4F35
    ld [$da3d], a
    ret
.loc_4F98:
    ld hl, $d846
    call RuntimeEntry_Bank32_4F35
    ld [$da3d], a
    ret
.loc_4FA2:
    ld hl, $d853
    call RuntimeEntry_Bank32_4F35
    ld [$da3d], a
    ret
RuntimeEntry_Bank32_4FAC::
    farcall NetworkUI_InitializeMobileMenu
    ld a, $fc
    ldh [$ff95], a
    xor a
    ldh [$ff96], a
    xor a
    ld [$da35], a
    ld [$da36], a
    ld [$da3b], a
    ld [$da3e], a
    ld [$da3f], a
    ld [$da3d], a
    ld [$da40], a
    farcall BANK_22, Bank22_Entry_64B8
    ld bc, $0000
    ld de, $1303
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, [$da33]
    cp $00
    jr z, .loc_4FEA
    cp $01
    jr z, .loc_4FEF
    cp $02
    jr z, .loc_4FF4
.loc_4FEA:
    ld hl, $560c
    jr .loc_4FF9
.loc_4FEF:
    ld hl, $5611
    jr .loc_4FF9
.loc_4FF4:
    ld hl, $5615
    jr .loc_4FF9
.loc_4FF9:
    ld bc, $0101
    call TextPut
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    xor a
    ld bc, $0101
    ld de, $1101
    farcall Gfx_TilemapFill
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld bc, $0003
    ld de, $130e
    farcall UIWindow_DrawFrameAndClearInteriorAttributes
    ld a, $00
    ld [$da34], a
    call RuntimeEntry_Bank32_4D4E
    ldh a, [$ff83]
    push af
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld de, $56f8
    ld hl, $9000
    ld bc, $0270
    farcall BANK_14, Bank14_Entry_3B50
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    ld b, $08
    ld hl, $5968
    ld c, $14
    call Vram_SetFarPals
    call Vram_SetDefaultBGPal
    call Vram_ApplyPals
    ld a, $0a
    ld bc, $0011
    ld de, $0301
    ld h, $19
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0311
    ld de, $0401
    ld h, $1c
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $0811
    ld de, $0301
    ld h, $20
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $0b11
    ld de, $0401
    ld h, $23
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $0a
    ld bc, $1011
    ld de, $0101
    ld h, $16
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ld a, $08
    ld bc, $1111
    ld de, $0201
    ld h, $17
    farcall Gfx_DrawSequentialTileRectWithAttributes
    ldh a, [$ff83]
    push af
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $20
    ld c, $00
    ld b, $15
    ld de, $6f8a
    call SpriteObject_Create
    ld [$da37], a
    pop af
    ldh [$ff83], a
    ldh [$ff4f], a
    call RuntimeEntry_Bank32_50DB
    call RuntimeEntry_Bank32_52B0
    call RuntimeEntry_Bank32_513D
    call RuntimeEntry_Bank32_4F43
    call RuntimeEntry_Bank32_4EB8
    call RuntimeEntry_Bank32_4E75
    ret
RuntimeEntry_Bank32_50DB::
    ld a, [$da35]
    ld b, $08
    call MultiplyAByB
    ld a, l
    add a, $13
    ld d, a
    push de
    ld a, [$da36]
    ld b, $10
    call MultiplyAByB
    ld a, l
    add a, $36
    ld c, a
    pop de
    ld a, d
    ld b, a
    ld a, [$da3b]
    cp $01
    jr nz, .loc_5102
    ld b, $84
    jr .loc_5110
.loc_5102:
    cp $02
    jr nz, .loc_510A
    ld b, $7a
    jr .loc_5110
.loc_510A:
    cp $03
    jr nz, .loc_5110
    ld b, $8e
.loc_5110:
    ld a, b
    add a, $04
    ld b, a
    ld a, [$da37]
    call SpriteObject_SetPosition
    ret
RuntimeEntry_Bank32_511B::
    ld hl, $5763
.loc_511E:
    ld a, [hli]
    cp $ff
    jr nz, .loc_5127
    ld a, $ff
    jr .loc_513C
.loc_5127:
    ld c, a
    ld a, [$da35]
    cp c
    jr z, .loc_5131
    inc hl
    jr .loc_511E
.loc_5131:
    ld a, [hli]
    ld c, a
    ld a, [$da36]
    cp c
    jr nz, .loc_511E
    xor a
    jr .loc_513C
.loc_513C:
    ret
RuntimeEntry_Bank32_513D::
    ld a, $0c
    ld b, a
    ld a, $04
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51C1
    ld a, $0d
    ld b, a
    ld a, $04
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51C1
    ld a, $0e
    ld b, a
    ld a, $04
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51C1
    ld a, $0f
    ld b, a
    ld a, $04
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51C7
    ld a, $10
    ld b, a
    ld a, $04
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51C7
    ld a, $0c
    ld b, a
    ld a, $05
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51CD
    ld a, $0d
    ld b, a
    ld a, $05
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51CD
    ld a, $0e
    ld b, a
    ld a, $05
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51CD
    ld a, $0f
    ld b, a
    ld a, $05
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51CD
    ld a, $10
    ld b, a
    ld a, $05
    ld c, a
    call .loc_51D9
    cp $00
    jr z, .loc_51CD
    jr .loc_51D3
.loc_51C1:
    ld a, $02
    ld [$da3b], a
    ret
.loc_51C7:
    ld a, $03
    ld [$da3b], a
    ret
.loc_51CD:
    ld a, $01
    ld [$da3b], a
    ret
.loc_51D3:
    ld a, $00
    ld [$da3b], a
    ret
.loc_51D9:
    ld a, [$da35]
    ld d, a
    ld a, b
    cp d
    jr z, .loc_51E5
    ld a, $ff
    jr .loc_51F3
.loc_51E5:
    ld a, [$da36]
    ld d, a
    ld a, c
    cp d
    jr z, .loc_51F1
    ld a, $ff
    jr .loc_51F3
.loc_51F1:
    xor a
    ret
.loc_51F3:
    ret
RuntimeEntry_Bank32_51F4::
    ld a, [$da3b]
    cp $01
    jr nz, .loc_5201
    xor a
    ld [$da35], a
    jr .loc_521F
.loc_5201:
    cp $02
    jr nz, .loc_520C
    ld a, $0f
    ld [$da35], a
    jr .loc_521F
.loc_520C:
    cp $03
    jr nz, .loc_5216
    xor a
    ld [$da35], a
    jr .loc_521F
.loc_5216:
    ld a, [$da35]
    inc a
    cp $11
    jr nz, .loc_521F
    xor a
.loc_521F:
    ld [$da35], a
    call RuntimeEntry_Bank32_52B0
    call RuntimeEntry_Bank32_511B
    cp $00
    jr z, .loc_5216
    call RuntimeEntry_Bank32_513D
    call RuntimeEntry_Bank32_50DB
    ret
RuntimeEntry_Bank32_5233::
    ld a, [$da3b]
    cp $01
    jr nz, .loc_5241
    ld a, $0a
    ld [$da35], a
    jr .loc_5261
.loc_5241:
    cp $02
    jr nz, .loc_524C
    ld a, $0a
    ld [$da35], a
    jr .loc_5261
.loc_524C:
    cp $03
    jr nz, .loc_5257
    ld a, $0c
    ld [$da35], a
    jr .loc_5261
.loc_5257:
    ld a, [$da35]
    dec a
    cp $ff
    jr nz, .loc_5261
    ld a, $10
.loc_5261:
    ld [$da35], a
    call RuntimeEntry_Bank32_52B0
    call RuntimeEntry_Bank32_511B
    cp $00
    jr z, .loc_5257
    call RuntimeEntry_Bank32_513D
    call RuntimeEntry_Bank32_50DB
    ret
RuntimeEntry_Bank32_5275::
    ld a, [$da36]
    inc a
    cp $06
    jr nz, .loc_527E
    xor a
.loc_527E:
    ld [$da36], a
    call RuntimeEntry_Bank32_52B0
    call RuntimeEntry_Bank32_511B
    cp $00
    jr z, RuntimeEntry_Bank32_5275
    call RuntimeEntry_Bank32_513D
    call RuntimeEntry_Bank32_50DB
    ret
RuntimeEntry_Bank32_5292::
    ld a, [$da36]
    dec a
    cp $ff
    jr nz, .loc_529C
    ld a, $05
.loc_529C:
    ld [$da36], a
    call RuntimeEntry_Bank32_52B0
    call RuntimeEntry_Bank32_511B
    cp $00
    jr z, RuntimeEntry_Bank32_5292
    call RuntimeEntry_Bank32_513D
    call RuntimeEntry_Bank32_50DB
    ret
RuntimeEntry_Bank32_52B0::
    ld a, $12
    ld b, a
    ld a, [$da36]
    call MultiplyAByB
    ld a, [$da35]
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [$da39]
    ld b, a
    ld a, [$da3a]
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [$da38], a
    ret
RuntimeEntry_Bank32_52CE::
    ld a, [$da33]
    cp $00
    jr z, .loc_52DE
    cp $01
    jr z, .loc_52FF
    cp $02
    jp z, .loc_531E
.loc_52DE:
    ld a, [$da3d]
    cp $0c
    jr z, .loc_52F1
    ld bc, $0601
    ld a, [$da3d]
    add a, b
    ld b, a
    farcall BANK_14, Bank14_Entry_5525
.loc_52F1:
    ld a, [$da3d]
    cp $0c
    jp z, .loc_534F
    ld hl, $d839
    jp .loc_533D
.loc_52FF:
    ld a, [$da3d]
    cp $0c
    jr z, .loc_5312
    ld bc, $0601
    ld a, [$da3d]
    add a, b
    ld b, a
    farcall BANK_14, Bank14_Entry_5525
.loc_5312:
    ld a, [$da3d]
    cp $0c
    jr z, .loc_534F
    ld hl, $d846
    jr .loc_533D
.loc_531E:
    ld a, [$da3d]
    cp $06
    jr z, .loc_5331
    ld bc, $0c01
    ld a, [$da3d]
    add a, b
    ld b, a
    farcall BANK_14, Bank14_Entry_5525
.loc_5331:
    ld a, [$da3d]
    cp $06
    jr z, .loc_534F
    ld hl, $d853
    jr .loc_533D
.loc_533D:
    ld a, [$da3d]
    ld c, a
    ld b, $00
    add hl, bc
    ld a, [$da38]
    ld [hl], a
    ld a, [$da3d]
    inc a
    ld [$da3d], a
.loc_534F:
    ret
RuntimeEntry_Bank32_5350::
    ld a, [$da3d]
    ld b, a
    ld a, [$da33]
    cp $00
    jr z, .loc_5363
    cp $01
    jr z, .loc_5368
    cp $02
    jr z, .loc_5372
.loc_5363:
    ld bc, $0601
    jr .loc_537C
.loc_5368:
    ld a, $0b
    cp b
    jr z, .loc_5393
    ld bc, $0601
    jr .loc_537C
.loc_5372:
    ld a, $05
    cp b
    jr z, .loc_5393
    ld bc, $0c01
    jr .loc_537C
.loc_537C:
    ld a, [$da3d]
    add a, b
    ld b, a
    push bc
    farcall BANK_14, Bank14_Entry_5525
    pop bc
    call .loc_5394
    cp $00
    jr z, .loc_5393
    inc b
    farcall BANK_14, Bank14_Entry_5503
.loc_5393:
    ret
.loc_5394:
    ld a, [$da33]
    cp $00
    jr z, .loc_53A3
    cp $01
    jr z, .loc_53AC
    cp $02
    jr z, .loc_53B5
.loc_53A3:
    ld a, [$da3d]
    cp $0b
    jr z, .loc_53C1
    jr .loc_53BE
.loc_53AC:
    ld a, [$da3d]
    cp $0b
    jr z, .loc_53C1
    jr .loc_53BE
.loc_53B5:
    ld a, [$da3d]
    cp $05
    jr z, .loc_53C1
    jr .loc_53BE
.loc_53BE:
    ld a, $01
    ret
.loc_53C1:
    xor a
    ret
RuntimeEntry_Bank32_53C3::
    ld a, [$da3d]
    cp $00
    jp z, .loc_53FA
    ld a, [$da33]
    cp $00
    jr z, .loc_53DA
    cp $01
    jr z, .loc_53DF
    cp $02
    jr z, .loc_53E4
.loc_53DA:
    ld hl, $d839
    jr .loc_53E9
.loc_53DF:
    ld hl, $d846
    jr .loc_53E9
.loc_53E4:
    ld hl, $d853
    jr .loc_53E9
.loc_53E9:
    ld a, [$da3d]
    dec a
    ld [$da3d], a
    ld c, a
    ld b, $00
    add hl, bc
    ld a, $00
    ld [hl], a
    call RuntimeEntry_Bank32_5350
.loc_53FA:
    ret
RuntimeEntry_Bank32_53FB::
    ld a, [$da3b]
    cp $00
    jr z, .loc_540E
    cp $02
    jr z, .loc_541A
    cp $03
    jr z, .loc_542E
    cp $01
    jr z, .loc_5475
.loc_540E:
    ld a, $02
    call Audio_PlaySFX
    call RuntimeEntry_Bank32_52CE
    call RuntimeEntry_Bank32_4E75
    ret
.loc_541A:
    ld a, $01
    call Audio_PlaySFX
    ld a, [$da34]
    cp $00
    jr z, .loc_5453
    cp $01
    jr z, .loc_5442
    cp $02
    jr z, .loc_5442
.loc_542E:
    ld a, $01
    call Audio_PlaySFX
    ld a, [$da34]
    cp $00
    jr z, .loc_5464
    cp $01
    jr z, .loc_5464
    cp $02
    jr z, .loc_5453
.loc_5442:
    ld a, $02
    call Audio_PlaySFX
    ld a, $00
    ld [$da34], a
    call RuntimeEntry_Bank32_4D4E
    call RuntimeEntry_Bank32_52B0
    ret
.loc_5453:
    ld a, $02
    call Audio_PlaySFX
    ld a, $01
    ld [$da34], a
    call RuntimeEntry_Bank32_4D4E
    call RuntimeEntry_Bank32_52B0
    ret
.loc_5464:
    ld a, $02
    call Audio_PlaySFX
    ld a, $02
    ld [$da34], a
    call RuntimeEntry_Bank32_4D4E
    call RuntimeEntry_Bank32_52B0
    ret
.loc_5475:
    ld a, [$da3d]
    cp $00
    jr z, .loc_549E
    ld a, $02
    call Audio_PlaySFX
    farcall BANK_27, Bank27_Entry_68CD
    ld a, [$cadd]
    cp $01
    jr z, .loc_548E
    jr .loc_5492
.loc_548E:
    ld a, $01
    jr .loc_5493
.loc_5492:
    xor a
.loc_5493:
    ld [$da40], a
    ld a, [$da33]
    farcall NetworkRuntime_4D89
    ret
.loc_549E:
    xor a
    ld [$da40], a
    ld a, SFX_ERROR
    call Audio_PlaySFX
    ret
RuntimeEntry_Bank32_54A8::
    ld a, [$da3d]
    ld b, a
    ld a, [$da33]
    cp $00
    jr z, .loc_54BB
    cp $01
    jr z, .loc_54C5
    cp $02
    jr z, .loc_54CF
.loc_54BB:
    ld a, $0c
    cp b
    jr z, .loc_5504
    ld bc, $0601
    jr .loc_54D9
.loc_54C5:
    ld a, $0c
    cp b
    jr z, .loc_5504
    ld bc, $0601
    jr .loc_54D9
.loc_54CF:
    ld a, $06
    cp b
    jr z, .loc_5504
    ld bc, $0c01
    jr .loc_54D9
.loc_54D9:
    ld a, [$da3d]
    add a, b
    ld b, a
    ld a, [$da3e]
    cp $08
    jp c, .loc_5504
    xor a
    ld [$da3e], a
    ld a, [$da3f]
    cp $00
    jp z, .loc_54F9
    farcall BANK_14, Bank14_Entry_5503
    xor a
    jr .loc_5501
.loc_54F9:
    farcall BANK_14, Bank14_Entry_5525
    ld a, $01
    jr .loc_5501
.loc_5501:
    ld [$da3f], a
.loc_5504:
    ld a, [$da3e]
    inc a
    ld [$da3e], a
    ret
RuntimeEntry_Bank32_550C::
    ld c, a
    ldh a, [$ff82]
    push af
    ld a, $07
    ldh [$ff82], a
    ldh [$ff70], a
    ld a, c
    ld [$da33], a
    ld a, b
    ld [$da3c], a
    call RuntimeEntry_Bank32_4FAC
    call FadeFromWhite8
.loc_5524:
    farcall MapMenuMessage_ServiceFrame
    call RuntimeEntry_Bank32_54A8
    ldh a, [$ff92]
    bit 6, a
    jr z, .loc_553B
    ld a, $01
    call Audio_PlaySFX
    call RuntimeEntry_Bank32_5292
    jr .loc_5524
.loc_553B:
    bit 7, a
    jr z, .loc_5549
    ld a, $01
    call Audio_PlaySFX
    call RuntimeEntry_Bank32_5275
    jr .loc_5524
.loc_5549:
    bit 5, a
    jr z, .loc_5557
    ld a, $01
    call Audio_PlaySFX
    call RuntimeEntry_Bank32_5233
    jr .loc_5524
.loc_5557:
    bit 4, a
    jr z, .loc_5565
    ld a, $01
    call Audio_PlaySFX
    call RuntimeEntry_Bank32_51F4
    jr .loc_5524
.loc_5565:
    bit 0, a
    jr z, .loc_5576
    call RuntimeEntry_Bank32_53FB
    ld a, [$da40]
    cp $01
    jp z, .loc_55D7
    jr .loc_5524
.loc_5576:
    bit 1, a
    jr z, .loc_5587
    ld a, SFX_CANCEL
    call Audio_PlaySFX
    call RuntimeEntry_Bank32_53C3
    call RuntimeEntry_Bank32_4E75
    jr .loc_5524
.loc_5587:
    bit 2, a
    jr z, .loc_55A5
    ld a, $01
    call Audio_PlaySFX
    ld a, [$da34]
    inc a
    cp $03
    jr nz, .loc_5599
    xor a
.loc_5599:
    ld [$da34], a
    call RuntimeEntry_Bank32_4D4E
    call RuntimeEntry_Bank32_52B0
    jp .loc_5524
.loc_55A5:
    bit 3, a
    jr z, .loc_55D4
    ld a, [$da3d]
    cp $00
    jr z, .loc_55B2
    jr .loc_55B9
.loc_55B2:
    ld a, SFX_ERROR
    call Audio_PlaySFX
    jr .loc_55D4
.loc_55B9:
    ld a, $02
    call Audio_PlaySFX
    farcall BANK_27, Bank27_Entry_68CD
    ld a, [$cadd]
    cp $01
    jr z, .loc_55CB
    jr .loc_55D4
.loc_55CB:
    ld a, [$da33]
    farcall NetworkRuntime_4D89
    jr .loc_55D7
.loc_55D4:
    jp .loc_5524
.loc_55D7:
    call FadeToWhite8
    call SpriteObject_DestroyAll
    pop af
    ldh [$ff82], a
    ldh [$ff70], a
    ret
    ; Source-owned structural bytes formerly data/mobile/structural/bank32_55e3_577c.dat
    db $04, $03, $f5, $0d, $c5, $0d, $87, $64, $ac, $6e, $87, $97, $af, $72, $64, $00
    db $04, $05, $c4, $0d, $e2, $c8, $8d, $80, $a4, $64, $7f, $af, $00, $04, $07, $c4
    db $0d, $e2, $c8, $8d, $74, $62, $6a, $62, $00, $9e, $a6, $64, $77, $00, $89, $9d
    db $66, $00, $76, $ab, $62, $6a, $af, $8d, $89, $9d, $66, $00, $61, $62, $64, $66
    db $68, $5f, $9d, $9e, $9f, $a0, $a1, $5f, $75, $77, $79, $7b, $7d, $00, $6a, $6c
    db $6e, $70, $72, $5f, $a3, $a5, $a7, $ad, $ae, $5f, $7f, $81, $84, $86, $88, $00
    db $74, $76, $78, $7a, $7c, $5f, $a8, $a9, $aa, $ab, $ac, $5f, $8f, $92, $95, $98
    db $9b, $00, $7e, $80, $83, $85, $87, $5f, $60, $63, $65, $67, $69, $5f, $90, $93
    db $96, $99, $9c, $00, $89, $8a, $8b, $8c, $8d, $5f, $82, $a2, $a4, $a6, $af, $5f
    db $00, $00, $00, $00, $00, $00, $8e, $91, $94, $97, $9a, $5f, $6b, $6d, $6f, $71
    db $73, $5f, $00, $00, $00, $00, $00, $00, $b1, $b3, $b5, $b7, $b9, $5f, $ed, $ee
    db $ef, $f0, $f1, $5f, $c5, $c7, $c9, $cb, $cd, $00, $ba, $bc, $be, $c0, $c2, $5f
    db $f3, $f5, $f7, $fd, $fe, $5f, $cf, $d1, $d4, $d6, $d8, $00, $c4, $c6, $c8, $ca
    db $cc, $5f, $f8, $f9, $fa, $fb, $fc, $5f, $df, $e2, $e5, $e8, $eb, $00, $ce, $d0
    db $d3, $d5, $d7, $5f, $b0, $b2, $b4, $b6, $b8, $5f, $e0, $e3, $e6, $e9, $ec, $00
    db $d9, $da, $db, $dc, $dd, $5f, $d2, $f2, $f4, $f6, $ff, $5f, $00, $00, $00, $00
    db $00, $00, $de, $e1, $e4, $e7, $ea, $5f, $bb, $bd, $bf, $c1, $c3, $5f, $00, $00
    db $00, $00, $00, $00, $11, $12, $13, $14, $15, $5f, $41, $42, $43, $44, $45, $5f
    db $30, $31, $32, $33, $34, $00, $16, $17, $18, $19, $1a, $5f, $46, $47, $48, $49
    db $4a, $5f, $35, $36, $37, $38, $39, $00, $1b, $1c, $1d, $1e, $1f, $5f, $4b, $4c
    db $4d, $4e, $4f, $5f, $0a, $0e, $0f, $3d, $3a, $00, $20, $21, $22, $23, $24, $5f
    db $50, $51, $52, $53, $54, $5f, $3c, $3e, $10, $2c, $2e, $00, $25, $26, $27, $28
    db $29, $5f, $55, $56, $57, $58, $59, $5f, $00, $00, $00, $00, $00, $00, $2a, $01
    db $3f, $0d, $0b, $5f, $5a, $03, $04, $05, $06, $5f, $00, $00, $00, $00, $00, $00
    db $05, $00, $0b, $00, $05, $01, $0b, $01, $05, $02, $0b, $02, $05, $03, $0b, $03
    db $05, $04, $0b, $04, $05, $05, $0b, $05, $ff, $ff
    assert @ == $577D

SECTION "Remaining ROM 32:7DFB-7FFF", ROMX[$7DFB], BANK[$32]
RemainingROM_Bank32_7DFB::
    ds $205, $ff
    assert @ == $8000

SECTION "Remaining ROM 33:7461-7FFF", ROMX[$7461], BANK[$33]
RemainingROM_Bank33_7461::
RuntimeEntry_Bank33_7461::
    ld [$c61a], a
    ld a, l
    ld [$c61b], a
    ld a, h
    ld [$c61c], a
    ld hl, $74a8
.loc_746F:
    ld a, [hl]
    cp $ff
    jr z, .loc_747F
    ld a, [$c61a]
    cp [hl]
    jr z, .loc_747F
    inc hl
    inc hl
    inc hl
    jr .loc_746F
.loc_747F:
    inc hl
    ld a, [hli]
    ld c, a
    ld a, [hl]
    ld h, a
    ld l, c
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld b, a
.loc_7489:
    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    and e
    cp $ff
    jr z, .loc_74A2
    ld a, [$c61b]
    cp e
    jr nz, .loc_749E
    ld a, [$c61c]
    cp d
    jr z, .loc_74A2
.loc_749E:
    inc bc
    inc bc
    jr .loc_7489
.loc_74A2:
    ld a, [bc]
    ld e, a
    inc bc
    ld a, [bc]
    ld d, a
    ret
    ; Source-owned structural data formerly data/campaign/structural/bank33_74a8_7fff.bin
    db $10, $ea, $74, $11, $f0, $74, $12, $f6, $74, $13, $fc, $74, $14, $02, $75, $15
    db $08, $75, $16, $1e, $75, $17, $24, $75, $20, $2a, $75, $21, $30, $75, $22, $36
    db $75, $23, $3c, $75, $24, $42, $75, $25, $48, $75, $26, $4e, $75, $30, $54, $75
    db $31, $9a, $75, $32, $b0, $75, $33, $f6, $75, $ff, $e4, $74, $e8, $74, $ff, $ff
    db $48, $76, $ee, $74, $ff, $ff, $68, $76, $f4, $74, $ff, $ff, $a8, $76, $fa, $74
    db $ff, $ff, $06, $77, $00, $75, $ff, $ff, $a8, $76, $06, $75, $ff, $ff, $37, $77
    db $14, $75, $00, $00, $01, $00, $02, $00, $03, $00, $ff, $ff, $75, $77, $75, $77
    db $75, $77, $75, $77, $48, $76, $22, $75, $ff, $ff, $1c, $78, $28, $75, $ff, $ff
    db $1c, $78, $2e, $75, $ff, $ff, $1c, $78, $34, $75, $ff, $ff, $1c, $78, $3a, $75
    db $ff, $ff, $7a, $78, $40, $75, $ff, $ff, $10, $79, $46, $75, $ff, $ff, $4f, $79
    db $4c, $75, $ff, $ff, $37, $77, $52, $75, $ff, $ff, $d6, $77, $78, $75, $00, $00
    db $21, $02, $21, $04, $50, $04, $51, $04, $52, $04, $00, $05, $01, $05, $02, $05
    db $03, $05, $04, $05, $50, $05, $51, $05, $53, $05, $52, $05, $54, $05, $ff, $ff
    db $1c, $78, $4f, $79, $4f, $79, $3a, $7a, $4f, $79, $4f, $79, $1c, $78, $1c, $78
    db $1c, $78, $1c, $78, $1c, $78, $3a, $7a, $3a, $7a, $3a, $7a, $4f, $79, $4f, $79
    db $4f, $79, $a6, $75, $00, $00, $02, $00, $03, $00, $04, $00, $ff, $ff, $1c, $78
    db $6d, $7a, $a9, $79, $1c, $78, $4f, $79, $d4, $75, $00, $00, $01, $03, $02, $03
    db $00, $04, $01, $04, $03, $04, $04, $04, $05, $04, $06, $04, $07, $04, $08, $04
    db $00, $05, $01, $05, $02, $05, $03, $05, $04, $05, $ff, $ff, $1c, $78, $1c, $78
    db $1c, $78, $1c, $78, $1c, $78, $b2, $7a, $b2, $7a, $1c, $78, $1c, $78, $1c, $78
    db $d6, $77, $4a, $7b, $1c, $78, $4a, $7b, $ed, $79, $4a, $7b, $4a, $7b, $20, $76
    db $02, $01, $03, $01, $04, $01, $05, $01, $06, $01, $01, $02, $02, $02, $03, $02
    db $04, $02, $05, $02, $06, $02, $99, $02, $01, $03, $01, $04, $02, $04, $03, $04
    db $04, $04, $05, $04, $06, $04, $ff, $ff, $8f, $7b, $c8, $7b, $19, $7b, $19, $7b
    db $12, $7c, $d9, $78, $1c, $78, $19, $7b, $1c, $78, $4a, $7b, $19, $7b, $8f, $7b
    db $4a, $7b, $4a, $7b, $4a, $7b, $4a, $7b, $4a, $7b, $4a, $7b, $4a, $7b, $4a, $7b
    db $c5, $e7, $79, $72, $63, $6c, $8d, $b4, $d7, $2d, $9b, $6d, $2e, $01, $bd, $c0
    db $ff, $cc, $76, $01, $65, $74, $62, $61, $8c, $6e, $68, $98, $6b, $62, $2e, $00
    db $d3, $ed, $b2, $d9, $b1, $e8, $f4, $c0, $8e, $01, $70, $98, $6c, $68, $6b, $6c
    db $6a, $7f, $8a, $73, $62, $7f, $6e, $8d, $2e, $01, $74, $88, $61, $72, $66, $62
    db $6e, $72, $82, $62, $6c, $ae, $60, $01, $92, $87, $8d, $79, $63, $64, $2c, $01
    db $6c, $af, $66, $88, $74, $6b, $6c, $6a, $8d, $9b, $68, $98, $6b, $62, $2e, $00
    db $9b, $8d, $8c, $8e, $63, $7f, $68, $66, $69, $87, $8a, $75, $62, $66, $2c, $01
    db $66, $62, $6e, $8d, $8e, $6a, $8d, $9b, $62, $89, $70, $82, $01, $72, $63, $6c
    db $8d, $9b, $67, $7f, $6e, $8d, $2e, $01, $6c, $9d, $87, $68, $7f, $af, $73, $66
    db $87, $01, $72, $63, $6c, $8d, $6c, $75, $65, $6c, $73, $68, $98, $6b, $62, $2e
    db $01, $68, $8c, $6c, $68, $7a, $01, $74, $88, $61, $72, $66, $62, $6e, $72, $82
    db $62, $6c, $ae, $60, $01, $92, $87, $8d, $68, $98, $6b, $62, $2e, $00, $66, $62
    db $6e, $8d, $8e, $6a, $8d, $9b, $62, $89, $70, $82, $01, $72, $63, $6c, $8d, $9b
    db $67, $7f, $6e, $8d, $2e, $01, $6c, $9d, $87, $68, $7f, $af, $73, $66, $87, $01
    db $72, $63, $6c, $8d, $6c, $75, $65, $6c, $73, $68, $98, $6b, $62, $2e, $00, $d3
    db $ed, $b2, $d9, $b1, $e8, $f4, $c0, $76, $01, $74, $63, $8b, $68, $6b, $8a, $70
    db $94, $ae, $63, $7e, $63, $8e, $01, $70, $98, $6c, $68, $61, $88, $7f, $6e, $8d
    db $2e, $01, $d3, $ed, $b2, $d9, $c4, $da, $2d, $c5, $2d, $9b, $01, $6c, $ae, $67
    db $74, $63, $8b, $68, $60, $6c, $73, $68, $98, $6b, $62, $2e, $00, $d3, $ed, $b2
    db $d9, $b1, $e8, $f4, $c0, $79, $b4, $d7, $2d, $9b, $6d, $2e, $01, $6c, $9d, $87
    db $68, $7f, $af, $73, $01, $72, $63, $6c, $8d, $6c, $75, $65, $6c, $73, $68, $98
    db $6b, $62, $2e, $01, $75, $65, $87, $75, $62, $9d, $61, $62, $7a, $2c, $01, $74
    db $88, $61, $72, $66, $62, $6e, $72, $82, $62, $6c, $ae, $60, $01, $92, $87, $8d
    db $79, $63, $64, $01, $d3, $ed, $b2, $d9, $bb, $f6, $2d, $c4, $be, $dd, $c0, $2d
    db $7d, $01, $65, $74, $62, $61, $8c, $6e, $68, $98, $6b, $62, $2e, $00, $c0, $b2
    db $d1, $b1, $b3, $c4, $76, $86, $88, $01, $72, $63, $6c, $8d, $8e, $6e, $72, $98
    db $8d, $6b, $8a, $7f, $6c, $70, $2e, $01, $72, $63, $6c, $8d, $6c, $75, $65, $6c
    db $73, $68, $98, $6b, $62, $2e, $01, $68, $8c, $6c, $68, $7a, $01, $74, $88, $61
    db $72, $66, $62, $6e, $72, $82, $62, $6c, $ae, $60, $01, $92, $87, $8d, $68, $98
    db $6b, $62, $2e, $00, $72, $63, $6c, $8d, $b4, $d7, $2d, $9b, $6d, $2e, $01, $6c
    db $9d, $87, $68, $7f, $af, $73, $66, $87, $01, $72, $63, $6c, $8d, $6c, $75, $65
    db $6c, $73, $68, $98, $6b, $62, $2e, $01, $75, $65, $87, $75, $62, $9d, $61, $62
    db $7a, $2c, $01, $74, $88, $61, $72, $66, $62, $6e, $72, $82, $62, $6c, $ae, $60
    db $01, $92, $87, $8d, $79, $63, $64, $01, $d3, $ed, $b2, $d9, $bb, $f6, $2d, $c4
    db $be, $dd, $c0, $2d, $7d, $01, $65, $74, $62, $61, $8c, $6e, $68, $98, $6b, $62
    db $2e, $00, $f2, $bd, $dc, $2d, $ec, $66, $db, $e0, $b2, $dd, $49, $44, $76, $01
    db $7f, $71, $8e, $62, $8e, $61, $88, $7f, $6d, $2e, $01, $f2, $bd, $dc, $2d, $ec
    db $60, $92, $66, $68, $76, $8d, $79, $63, $64, $2c, $01, $6c, $9d, $87, $68, $7f
    db $af, $73, $66, $87, $01, $72, $63, $6c, $8d, $6c, $75, $65, $6c, $73, $68, $98
    db $6b, $62, $2e, $01, $68, $8c, $6c, $68, $7a, $01, $74, $88, $61, $72, $66, $62
    db $6e, $72, $82, $62, $6c, $ae, $60, $01, $92, $87, $8d, $68, $98, $6b, $62, $2e
    db $00, $74, $63, $8b, $68, $6c, $ae, $79, $6c, $ae, $88, $8e, $01, $66, $8d, $88
    db $ae, $63, $6c, $73, $62, $75, $62, $86, $63, $9b, $6d, $2e, $01, $6c, $ae, $88
    db $8e, $66, $8d, $88, $ae, $63, $6d, $89, $7f, $9b, $01, $6c, $9d, $87, $68, $65
    db $7f, $71, $68, $98, $6b, $62, $2e, $00, $72, $63, $6c, $8d, $8e, $6e, $72, $98
    db $8d, $6b, $8a, $7f, $6c, $70, $2e, $01, $74, $88, $61, $72, $66, $62, $6e, $72
    db $82, $62, $6c, $ae, $60, $01, $92, $87, $8d, $79, $63, $64, $2c, $01, $6c, $9d
    db $87, $68, $7f, $af, $73, $66, $87, $01, $72, $63, $6c, $8d, $6c, $75, $65, $6c
    db $73, $68, $98, $6b, $62, $2e, $00, $66, $62, $6e, $8d, $8e, $6a, $8d, $9b, $62
    db $89, $66, $2c, $01, $bb, $2d, $ed, $79, $b4, $d7, $2d, $79, $70, $82, $01, $72
    db $63, $6c, $8d, $8e, $9b, $67, $7f, $6e, $8d, $2e, $01, $6c, $9d, $87, $68, $7f
    db $af, $73, $66, $87, $01, $72, $63, $6c, $8d, $6c, $75, $65, $6c, $73, $68, $98
    db $6b, $62, $2e, $01, $68, $8c, $6c, $68, $7a, $01, $74, $88, $61, $72, $66, $62
    db $6e, $72, $82, $62, $6c, $ae, $60, $01, $92, $87, $8d, $68, $98, $6b, $62, $2e
    db $00, $f2, $bd, $dc, $2d, $ec, $76, $7f, $71, $8e, $62, $8e, $61, $89, $66, $2c
    db $01, $bb, $2d, $ed, $79, $b4, $d7, $2d, $9b, $6d, $2e, $01, $f2, $bd, $dc, $2d
    db $ec, $60, $92, $66, $68, $76, $8d, $79, $63, $64, $2c, $01, $6c, $9d, $87, $68
    db $7f, $af, $73, $66, $87, $01, $72, $63, $6c, $8d, $6c, $75, $65, $6c, $73, $68
    db $98, $6b, $62, $2e, $00, $bb, $2d, $ed, $8e, $6a, $8d, $9b, $62, $89, $70, $82
    db $01, $72, $63, $6c, $8d, $9b, $67, $7f, $6e, $8d, $2e, $01, $6c, $9d, $87, $68
    db $7f, $af, $73, $66, $87, $01, $72, $63, $6c, $8d, $6c, $75, $65, $6c, $73, $68
    db $98, $6b, $62, $2e, $01, $68, $8c, $6c, $68, $7a, $01, $74, $88, $61, $72, $66
    db $62, $6e, $72, $82, $62, $6c, $ae, $60, $01, $92, $87, $8d, $68, $98, $6b, $62
    db $2e, $00, $61, $73, $6b, $67, $d2, $2d, $d9, $b1, $ec, $da, $bd, $76, $01, $7f
    db $71, $8e, $62, $8e, $61, $88, $7f, $6d, $2e, $01, $70, $98, $6c, $62, $d2, $2d
    db $d9, $b1, $ec, $da, $bd, $60, $01, $76, $ad, $63, $88, $ae, $68, $6c, $73, $68
    db $98, $6b, $62, $2e, $00, $d2, $2d, $d9, $b1, $ec, $da, $bd, $76, $01, $7f, $71
    db $8e, $62, $8e, $61, $88, $7f, $6d, $2e, $01, $74, $88, $61, $72, $66, $62, $6e
    db $72, $82, $62, $6c, $ae, $60, $01, $92, $87, $8d, $79, $63, $64, $2c, $01, $d3
    db $ed, $b2, $d9, $c4, $da, $2d, $c5, $2d, $9b, $01, $6c, $ae, $67, $74, $63, $8b
    db $68, $60, $6c, $73, $68, $98, $6b, $62, $2e, $00, $ba, $dd, $c3, $dd, $c2, $e8
    db $b3, $dd, $db, $2d, $ec, $8e, $01, $9b, $67, $7f, $6e, $8d, $2e, $01, $6c, $9d
    db $87, $68, $7f, $af, $73, $66, $87, $01, $72, $63, $6c, $8d, $6c, $75, $65, $6c
    db $73, $68, $98, $6b, $62, $2e, $01, $75, $65, $87, $75, $62, $9d, $61, $62, $7a
    db $2c, $01, $74, $88, $61, $72, $66, $62, $6e, $72, $82, $62, $6c, $ae, $60, $01
    db $92, $87, $8d, $79, $63, $64, $01, $d3, $ed, $b2, $d9, $bb, $f6, $2d, $c4, $be
    db $dd, $c0, $2d, $7d, $01, $65, $74, $62, $61, $8c, $6e, $68, $98, $6b, $62, $2e
    db $00, $ba, $dd, $c3, $dd, $c2, $e8, $b3, $dd, $db, $2d, $ec, $8e, $01, $9b, $67
    db $7f, $6e, $8d, $2e, $01, $68, $8c, $6c, $68, $7a, $01, $74, $88, $61, $72, $66
    db $62, $6e, $72, $82, $62, $6c, $ae, $60, $01, $92, $87, $8d, $68, $98, $6b, $62
    db $2e, $00, $bb, $2d, $ed, $79, $72, $63, $6c, $8d, $b4, $d7, $2d, $9b, $6d, $2e
    db $01, $6c, $9d, $87, $68, $7f, $af, $73, $66, $87, $01, $72, $63, $6c, $8d, $6c
    db $75, $65, $6c, $73, $68, $98, $6b, $62, $2e, $01, $68, $8c, $6c, $68, $7a, $01
    db $74, $88, $61, $72, $66, $62, $6e, $72, $82, $62, $6c, $ae, $60, $01, $92, $87
    db $8d, $68, $98, $6b, $62, $2e, $00, $65, $67, $ac, $68, $6b, $7f, $79, $72, $92
    db $63, $76, $86, $88, $2c, $01, $92, $88, $86, $63, $62, $70, $98, $69, $7f, $6e
    db $8d, $2e, $01, $68, $8c, $6c, $68, $7a, $01, $74, $88, $61, $72, $66, $62, $6e
    db $72, $82, $62, $6c, $ae, $60, $01, $92, $87, $8d, $68, $98, $6b, $62, $2e, $00
    db $92, $88, $86, $63, $88, $ae, $63, $67, $8d, $8e, $01, $94, $ae, $63, $91, $8d
    db $60, $6a, $64, $73, $62, $89, $70, $82, $2c, $01, $6a, $8d, $91, $72, $7a, $01
    db $92, $88, $86, $63, $62, $70, $98, $69, $7f, $6e, $8d, $2e, $01, $68, $8c, $6c
    db $68, $7a, $01, $74, $88, $61, $72, $66, $62, $6e, $72, $82, $62, $6c, $ae, $60
    db $01, $92, $87, $8d, $68, $98, $6b, $62, $2e, $00, $91, $8d, $93, $62, $d2, $dd
    db $c3, $c5, $dd, $bd, $71, $ad, $63, $79, $70, $82, $01, $92, $88, $86, $63, $62
    db $70, $98, $69, $7f, $6e, $8d, $2e, $01, $6c, $9d, $87, $68, $7f, $af, $73, $66
    db $87, $01, $65, $66, $69, $75, $65, $6c, $68, $98, $6b, $62, $2e, $01, $68, $8c
    db $6c, $68, $7a, $01, $74, $88, $61, $72, $66, $62, $6e, $72, $82, $62, $6c, $ae
    db $60, $01, $92, $87, $8d, $68, $98, $6b, $62, $2e, $00, $fa, $00, $cc, $fe, $00
    db $28, $10, $fe, $01, $28, $10, $fe, $02, $28, $10, $fe, $03, $28, $10, $fe, $04
    db $28, $10, $3e, $14, $18, $10, $3e, $1c, $18, $0c, $3e, $2c, $18, $08, $3e, $34
    db $18, $04, $3e, $3c, $18, $00, $f5, $47, $3e, $2c, $4f, $fa, $01, $cc, $cd, $ae
    db $2e, $f1, $47, $3e, $3c, $4f, $fa, $02, $cc, $cd, $ae, $2e, $c9, $01, $04, $01
    db $fa, $03, $cc, $cd, $ca, $31, $01, $04, $03, $fa, $05, $cc, $cd, $ca, $31, $01
    db $04, $05, $fa, $04, $cc, $cd, $ca, $31, $21, $ef, $7e, $cd, $6e, $33, $c9, $fa
    db $06, $cc, $06, $10, $cd, $95, $29, $4d, $fa, $07, $cc, $81, $ea, $03, $cc, $fa
    db $08, $cc, $ea, $05, $cc, $fa, $09, $cc, $06, $10, $cd, $95, $29, $4d, $fa, $0a
    db $cc, $81, $ea, $04, $cc, $c9, $fa, $00, $cc, $fe, $00, $28, $10, $fe, $01, $28
    db $1c, $fe, $02, $28, $28, $fe, $03, $28, $34, $fe, $04, $28, $40, $fa, $06, $cc
    db $3c, $fe, $0a, $28, $02, $18, $01, $af, $ea, $06, $cc, $18, $40, $fa, $07, $cc
    db $3c, $fe, $0a, $28, $02, $18, $01, $af, $ea, $07, $cc, $18, $30, $fa, $08, $cc
    db $3c, $fe, $0a, $28, $02, $18, $01, $af, $ea, $08, $cc, $18, $20, $fa, $09, $cc
    db $3c, $fe, $0a, $28, $02, $18, $01, $af, $ea, $09, $cc, $18, $10, $fa, $0a, $cc
    db $3c, $fe, $0a, $28, $02, $18, $01, $af, $ea, $0a, $cc, $18, $00, $cd, $c7, $7c
    db $c9, $fa, $00, $cc, $fe, $00, $28, $10, $fe, $01, $28, $1d, $fe, $02, $28, $2a
    db $fe, $03, $28, $37, $fe, $04, $28, $44, $fa, $06, $cc, $3d, $fe, $ff, $28, $02
    db $18, $02, $3e, $09, $ea, $06, $cc, $18, $44, $fa, $07, $cc, $3d, $fe, $ff, $28
    db $02, $18, $02, $3e, $09, $ea, $07, $cc, $18, $33, $fa, $08, $cc, $3d, $fe, $ff
    db $28, $02, $18, $02, $3e, $09, $ea, $08, $cc, $18, $22, $fa, $09, $cc, $3d, $fe
    db $ff, $28, $02, $18, $02, $3e, $09, $ea, $09, $cc, $18, $11, $fa, $0a, $cc, $3d
    db $fe, $ff, $28, $02, $18, $02, $3e, $09, $ea, $0a, $cc, $18, $00, $cd, $c7, $7c
    db $c9, $f0, $83, $f5, $3e, $00, $e0, $83, $e0, $4f, $af, $01, $07, $02, $11, $09
    db $10, $ef, $15, $d3, $6a, $f1, $e0, $83, $e0, $4f, $fa, $04, $cc, $6f, $fa, $05
    db $cc, $67, $fa, $03, $cc, $ef, $33, $61, $74, $cd, $4b, $2d, $c9, $fa, $32, $da
    db $cd, $5f, $2f, $cd, $56, $30, $01, $00, $00, $11, $12, $14, $ef, $10, $fa, $68
    db $f0, $83, $f5, $3e, $01, $e0, $83, $e0, $4f, $01, $01, $01, $11, $10, $12, $af
    db $ef, $15, $d3, $6a, $f1, $e0, $83, $e0, $4f, $21, $e0, $7e, $cd, $6e, $33, $af
    db $ea, $03, $cc, $ea, $04, $cc, $ea, $05, $cc, $af, $21, $06, $cc, $01, $05, $00
    db $cd, $79, $3b, $f0, $83, $f5, $3e, $20, $0e, $00, $06, $15, $11, $b4, $6f, $cd
    db $e8, $2d, $ea, $01, $cc, $3e, $20, $0e, $00, $06, $15, $11, $8a, $6f, $cd, $e8
    db $2d, $ea, $02, $cc, $cd, $63, $7c, $f1, $e0, $83, $e0, $4f, $cd, $a5, $7c, $ef
    db $22, $0d, $62, $f0, $92, $cb, $47, $28, $05, $cd, $c9, $7d, $18, $4d, $cb, $4f
    db $28, $02, $18, $4a, $cb, $77, $28, $08, $cd, $ee, $7c, $cd, $a5, $7c, $18, $3b
    db $cb, $7f, $28, $08, $cd, $59, $7d, $cd, $a5, $7c, $18, $2f, $cb, $6f, $28, $14
    db $fa, $00, $cc, $3d, $fe, $ff, $28, $02, $18, $02, $3e, $04, $ea, $00, $cc, $cd
    db $63, $7c, $18, $17, $cb, $67, $28, $13, $fa, $00, $cc, $3c, $fe, $05, $28, $02
    db $18, $01, $af, $ea, $00, $cc, $cd, $63, $7c, $18, $00, $c3, $67, $7e, $ef, $10
    db $08, $69, $fa, $01, $cc, $cd, $1f, $2e, $fa, $02, $cc, $cd, $1f, $2e, $fa, $32
    db $da, $cd, $45, $2f, $cd, $56, $30, $c9, $01, $01, $d3, $ed, $b2, $d9, $b4, $d7
    db $2d, $d2, $ff, $be, $2d, $e4, $00, $03, $04, $2d, $00
    ds $10d, $ff
    assert @ == $8000

SECTION "Remaining ROM 34:779F-7EEF", ROMX[$779F], BANK[$34]
RemainingROM_Bank34_779F::
    ds $751, $ff
    assert @ == $7EF0

SECTION "Remaining ROM 35:4000-7FFF", ROMX[$4000], BANK[$35]
RemainingROM_Bank35_4000::
    ds $4000, $ff
    assert @ == $8000

SECTION "Remaining ROM 36:4000-7FFF", ROMX[$4000], BANK[$36]
RemainingROM_Bank36_4000::
    ds $4000, $ff
    assert @ == $8000

SECTION "Remaining ROM 37:4000-7FFF", ROMX[$4000], BANK[$37]
RemainingROM_Bank37_4000::
    ds $4000, $ff
    assert @ == $8000

SECTION "Remaining ROM 38:4000-7FFF", ROMX[$4000], BANK[$38]
RemainingROM_Bank38_4000::
    ds $4000, $ff
    assert @ == $8000

SECTION "Remaining ROM 39:4000-7FFF", ROMX[$4000], BANK[$39]
RemainingROM_Bank39_4000::
    ds $4000, $ff
    assert @ == $8000

SECTION "Remaining ROM 3A:4000-7FFF", ROMX[$4000], BANK[$3A]
RemainingROM_Bank3A_4000::
    ds $4000, $ff
    assert @ == $8000

SECTION "Remaining ROM 3B:4000-7FFF", ROMX[$4000], BANK[$3B]
RemainingROM_Bank3B_4000::
    ds $4000, $ff
    assert @ == $8000

SECTION "Remaining ROM 3C:4000-7FFF", ROMX[$4000], BANK[$3C]
RemainingROM_Bank3C_4000::
    ds $4000, $ff
    assert @ == $8000

SECTION "Remaining ROM 3D:4000-7FFF", ROMX[$4000], BANK[$3D]
RemainingROM_Bank3D_4000::
    ds $4000, $ff
    assert @ == $8000


