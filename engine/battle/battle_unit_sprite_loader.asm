include "macros/macros.inc"

; Shared battle-unit sprite descriptor/pixel loader.
section "Battle Unit Sprite Descriptor Loader", romx[$454b], bank[$16]

BattleUnit_LoadSpriteDescriptorAndPixels::
    push af                  ; $454B
    cp $00                   ; $454C
    jr z, $4552              ; $454E
    jr $4556                 ; $4550
    ld a, b                  ; $4552
    ld [$c4b7], a            ; $4553
    ld a, b                  ; $4556
    ld [$c4b8], a            ; $4557
    pop af                   ; $455A
    push af                  ; $455B
    ld a, b                  ; $455C
    ld b, $05                ; $455D
    call $2995               ; $455F
    ld bc, $5444             ; $4562
    add hl, bc               ; $4565
    push hl                  ; $4566
    ld a, [hli]              ; $4567
    ld c, a                  ; $4568
    ld a, [hli]              ; $4569
    ld b, a                  ; $456A
    ld a, [hli]              ; $456B
    push hl                  ; $456C
    push bc                  ; $456D
    ld b, $10                ; $456E
    call $2995               ; $4570
    pop bc                   ; $4573
    add hl, bc               ; $4574
    ld a, h                  ; $4575
    ld [$d36c], a            ; $4576
    ld a, l                  ; $4579
    ld [$d36d], a            ; $457A
    pop hl                   ; $457D
    ld a, [hli]              ; $457E
    ld [$d36e], a            ; $457F
    ld a, [hl]               ; $4582
    ld [$d36f], a            ; $4583
    ld a, [$d36f]            ; $4586
    ld b, a                  ; $4589
    ld a, [$d36e]            ; $458A
    call $2995               ; $458D
    ld a, l                  ; $4590
    ld b, $10                ; $4591
    call $2995               ; $4593
    ld a, h                  ; $4596
    ld [$d370], a            ; $4597
    ld a, l                  ; $459A
    ld [$d371], a            ; $459B
    ld a, [$d36c]            ; $459E
    ld d, a                  ; $45A1
    ld a, [$d36d]            ; $45A2
    ld e, a                  ; $45A5
    ld a, [$d370]            ; $45A6
    ld b, a                  ; $45A9
    ld a, [$d371]            ; $45AA
    ld c, a                  ; $45AD
    pop hl                   ; $45AE
    pop af                   ; $45AF
    cp $00                   ; $45B0
    jr z, $45b6              ; $45B2
    jr $45e3                 ; $45B4
    ld a, [$d36e]            ; $45B6
    ld [$c4b9], a            ; $45B9
    ld a, [$d36f]            ; $45BC
    ld [$c4ba], a            ; $45BF
    ld hl, $9010             ; $45C2
    call $3b59               ; $45C5
    ld a, [$c4b7]            ; $45C8
    call $451a               ; $45CB
    jr c, $45dd              ; $45CE
    ld hl, $8ec0             ; $45D0
    call $3b59               ; $45D3
    ld a, $01                ; $45D6
    ld [$d340], a            ; $45D8
    jr $460e                 ; $45DB
    xor a                    ; $45DD
    ld [$d340], a            ; $45DE
    jr $460e                 ; $45E1
    ld a, [$d36e]            ; $45E3
    ld [$c4bb], a            ; $45E6
    ld a, [$d36f]            ; $45E9
    ld [$c4bc], a            ; $45EC
    ld hl, $92b0             ; $45EF
    call $3b59               ; $45F2
    ld a, [$c4b8]            ; $45F5
    call $451a               ; $45F8
    jr c, $460a              ; $45FB
    ld hl, $8f20             ; $45FD
    call $3b59               ; $4600
    ld a, $01                ; $4603
    ld [$d341], a            ; $4605
    jr $460e                 ; $4608
    xor a                    ; $460A
    ld [$d341], a            ; $460B
    assert @ == $460e
