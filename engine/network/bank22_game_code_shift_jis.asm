include "macros/macros.inc"

; Game text-code <-> Shift-JIS helpers.  The 256-entry table stores each
; game's one-byte text code as a little-endian Shift-JIS word.  A zero high
; byte denotes a single-byte Shift-JIS/ASCII value.
section "Bank22 Game Code Shift-JIS Runtime", romx[$626d], bank[$22]

; A = game text code. Returns the table word in BC as {low byte, high byte}.
; For a two-byte Shift-JIS character, B is the trailing byte and C the lead.
Text_GetShiftJISForGameCode::
    push hl
    ld b, $02
    call MultiplyAByB
    ld b, h
    ld c, l
    ld hl, Text_GameCodeToShiftJISTable
    add hl, bc
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    pop hl
    ret

    assert @ == $627f

; BC = Shift-JIS bytes in stream order (B = lead, C = trail).
; Returns the matching one-byte game text code in A with carry clear.  If no
; table entry matches, returns the game's fallback code $0A with carry set.
Text_FindGameCodeForShiftJIS::
    push hl
    ld e, b
    ld d, c
    xor a
.loop
    push af
    push de
    ld b, $02
    call MultiplyAByB
    ld bc, Text_GameCodeToShiftJISTable
    add hl, bc
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    ld h, b
    ld l, c
    pop de
    call Math_CompareHLToDE
    jr z, .found
    pop af
    inc a
    cp $00
    jr nz, .loop
    pop hl
    ld a, $0a
    scf
    ret
.found
    pop af
    pop hl
    scf
    ccf
    ret

    assert @ == $62aa

; Convert a zero-terminated game-code string at HL to Shift-JIS at DE.
; The destination workspace is cleared first (the retail caller contract uses
; $DC10, length $02D0), then the encoded byte count is tracked at $DF02/$DF03.
Text_ConvertGameCodeToShiftJISStream::
    ld a, h
    ld [$df04], a
    ld a, l
    ld [$df05], a
    ld a, d
    ld [$df00], a
    ld a, e
    ld [$df01], a
    xor a
    ld [$df06], a
    ld [$df07], a
    ld [$df02], a
    ld [$df03], a
    ld hl, $dc10
    ld bc, $02d0
    xor a
    call Memset

    ld a, [$df04]
    ld h, a
    ld a, [$df05]
    ld l, a
.loop
    ld a, [hli]
    cp $00
    jr z, .done
    farcall Text_GetShiftJISForGameCode
    push hl
    call Text_AppendShiftJISCode
    pop hl
    jr .loop
.done
    ret

    assert @ == $62ea

; Append BC from Text_GetShiftJISForGameCode to the output base at
; $DF00/$DF01 using the 16-bit byte offset at $DF02/$DF03.  Two-byte entries
; are emitted in Shift-JIS stream order (C then B); single-byte entries emit B.
Text_AppendShiftJISCode:
    push bc
    ld a, c
    cp $00
    jr z, .single_byte

    ld a, [$df00]
    ld h, a
    ld a, [$df01]
    ld l, a
    ld a, [$df02]
    ld b, a
    ld a, [$df03]
    ld c, a
    add hl, bc
    pop bc
    push bc
    ld a, c
    ld [hl], a
    ld a, [$df02]
    ld b, a
    ld a, [$df03]
    ld c, a
    inc bc
    ld a, b
    ld [$df02], a
    ld a, c
    ld [$df03], a

    ld a, [$df00]
    ld h, a
    ld a, [$df01]
    ld l, a
    ld a, [$df02]
    ld b, a
    ld a, [$df03]
    ld c, a
    add hl, bc
    pop bc
    ld a, b
    ld [hl], a
    ld a, [$df02]
    ld b, a
    ld a, [$df03]
    ld c, a
    inc bc
    ld a, b
    ld [$df02], a
    ld a, c
    ld [$df03], a
    ret

.single_byte
    ld a, [$df00]
    ld h, a
    ld a, [$df01]
    ld l, a
    ld a, [$df02]
    ld b, a
    ld a, [$df03]
    ld c, a
    add hl, bc
    pop bc
    ld a, b
    ld [hl], a
    ld a, [$df02]
    ld b, a
    ld a, [$df03]
    ld c, a
    inc bc
    ld a, b
    ld [$df02], a
    ld a, c
    ld [$df03], a
    ret

    assert @ == $6362

section "Game Code to Shift-JIS Table", romx[$7514], bank[$22]

Text_GameCodeToShiftJISTable::
    dw $0000, $0021, $0022, $0023, $0024, $0025, $0026, $0027
    dw $0028, $0029, $002a, $002b, $002c, $002d, $002e, $002f
    dw $0040, $0041, $0042, $0043, $0044, $0045, $0046, $0047
    dw $0048, $0049, $004a, $004b, $004c, $004d, $004e, $004f
    dw $0050, $0051, $0052, $0053, $0054, $0055, $0056, $0057
    dw $0058, $0059, $005a, $005b, $005c, $005d, $005e, $005f
    dw $0030, $0031, $0032, $0033, $0034, $0035, $0036, $0037
    dw $0038, $0039, $003a, $003b, $003c, $003d, $003e, $003f
    dw $0060, $0061, $0062, $0063, $0064, $0065, $0066, $0067
    dw $0068, $0069, $006a, $006b, $006c, $006d, $006e, $006f
    dw $0070, $0071, $0072, $0073, $0074, $0075, $0076, $0077
    dw $0078, $0079, $007a, $007b, $007c, $007d, $007e, $0020
    dw $829f, $82a0, $82a2, $82a1, $82a4, $82a3, $82a6, $82a5
    dw $82a8, $82a7, $82a9, $82aa, $82ab, $82ac, $82ad, $82ae
    dw $82af, $82b0, $82b1, $82b2, $82b3, $82b4, $82b5, $82b6
    dw $82b7, $82b8, $82b9, $82ba, $82bb, $82bc, $82bd, $82be
    dw $82bf, $82c0, $82c1, $82c2, $82c3, $82c4, $82c5, $82c6
    dw $82c7, $82c8, $82c9, $82ca, $82cb, $82cc, $82cd, $82ce
    dw $82cf, $82d0, $82d1, $82d2, $82d3, $82d4, $82d5, $82d6
    dw $82d7, $82d8, $82d9, $82da, $82db, $82dc, $82dd, $82de
    dw $82df, $82e0, $82e1, $82e2, $82e3, $82e4, $82e5, $82e6
    dw $82e7, $82e8, $82e9, $82ea, $82eb, $82ed, $82f0, $82f1
    dw $8340, $8341, $8342, $8343, $8344, $8345, $8346, $8347
    dw $8348, $8349, $834a, $834b, $834c, $834d, $834e, $834f
    dw $8350, $8351, $8352, $8353, $8354, $8355, $8356, $8357
    dw $8358, $8359, $835a, $835b, $835c, $835d, $835e, $835f
    dw $8360, $8361, $8362, $8363, $8364, $8365, $8366, $8367
    dw $8368, $8369, $836a, $836b, $836c, $836d, $836e, $836f
    dw $8370, $8371, $8372, $8373, $8374, $8375, $8376, $8377
    dw $8378, $8379, $837a, $837b, $837c, $837d, $837e, $8380
    dw $8381, $8382, $8383, $8384, $8385, $8386, $8387, $8388
    dw $8389, $838a, $838b, $838c, $838d, $838f, $8392, $8393

    assert @ == $7714
