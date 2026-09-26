include "macros/macros.inc"

; Shared sequential VRAM rectangle writer used by battle presentation.
section "Sequential VRAM Tile Rectangle", rom0[$39db]
Vram_DrawSequentialTileRectangle::
    ld a, b                  ; $39DB
    ld [$ccbc], a            ; $39DC
    ld a, c                  ; $39DF
    ld [$ccbd], a            ; $39E0
    ld a, l                  ; $39E3
    ld [$ccba], a            ; $39E4
    cp $00                   ; $39E7
    jr z, $39ed              ; $39E9
    jr $39f6                 ; $39EB
    xor a                    ; $39ED
    ld [$ccbe], a            ; $39EE
    ld [$ccbf], a            ; $39F1
    jr $39ff                 ; $39F4
    ld a, d                  ; $39F6
    dec a                    ; $39F7
    ld [$ccbe], a            ; $39F8
    xor a                    ; $39FB
    ld [$ccbf], a            ; $39FC
    ld a, d                  ; $39FF
    ld [$ccc0], a            ; $3A00
    ld a, e                  ; $3A03
    ld [$ccc1], a            ; $3A04
    ld a, h                  ; $3A07
    ld [$ccbb], a            ; $3A08
    ld a, [$ccc1]            ; $3A0B
    ld c, a                  ; $3A0E
    ld a, [$ccbf]            ; $3A0F
    cp c                     ; $3A12
    jp nc, $3a8e             ; $3A13
    ld a, [$ccbe]            ; $3A16
    ld c, a                  ; $3A19
    ld a, [$ccbc]            ; $3A1A
    add a, c                 ; $3A1D
    ld b, a                  ; $3A1E
    ld a, [$ccbf]            ; $3A1F
    ld c, a                  ; $3A22
    ld a, [$ccbd]            ; $3A23
    add a, c                 ; $3A26
    ld c, a                  ; $3A27
    call $0ed4               ; $3A28
    ldh a, [$ff83]           ; $3A2B
    push af                  ; $3A2D
    ld a, $00                ; $3A2E
    ldh [$ff83], a           ; $3A30
    ldh [$ff4f], a           ; $3A32
    ld a, [$ccbb]            ; $3A34
    call $0f1c               ; $3A37
    pop af                   ; $3A3A
    ldh [$ff83], a           ; $3A3B
    ldh [$ff4f], a           ; $3A3D
    ld a, [$ccbb]            ; $3A3F
    inc a                    ; $3A42
    ld [$ccbb], a            ; $3A43
    ld a, [$ccba]            ; $3A46
    cp $00                   ; $3A49
    jr z, $3a4f              ; $3A4B
    jr $3a6e                 ; $3A4D
    ld a, [$ccbe]            ; $3A4F
    inc a                    ; $3A52
    ld [$ccbe], a            ; $3A53
    ld a, [$ccc0]            ; $3A56
    ld c, a                  ; $3A59
    ld a, [$ccbe]            ; $3A5A
    cp c                     ; $3A5D
    jp c, $3a16              ; $3A5E
    xor a                    ; $3A61
    ld [$ccbe], a            ; $3A62
    ld a, [$ccbf]            ; $3A65
    inc a                    ; $3A68
    ld [$ccbf], a            ; $3A69
    jr $3a0b                 ; $3A6C
    ld a, [$ccbe]            ; $3A6E
    dec a                    ; $3A71
    ld [$ccbe], a            ; $3A72
    ld a, [$ccbe]            ; $3A75
    cp $ff                   ; $3A78
    jp nz, $3a16             ; $3A7A
    ld a, [$ccc0]            ; $3A7D
    dec a                    ; $3A80
    ld [$ccbe], a            ; $3A81
    ld a, [$ccbf]            ; $3A84
    inc a                    ; $3A87
    ld [$ccbf], a            ; $3A88
    jp $3a0b                 ; $3A8B
    assert @ == $3a8e
