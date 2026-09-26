include "macros/macros.inc"

DEF hMapSaveMedalWindowX EQU $ffcc
DEF hMapSaveMedalLCDPhase EQU $ffcd

; LCD-STAT service for the SAVE medal-detail view. It alternates two LYC/window
; phases so the medal grid and detail strip can use distinct window positions.
section "Map Save Medal Detail LCD STAT Service", rom0[$377c]
MapSave_MedalDetailLCDStatInterrupt::
    push af
    push hl
    ld hl, rSTAT
    ldh a, [hMapSaveMedalWindowX]
.wait_hblank
    bit 1, [hl]
    jr nz, .wait_hblank
    ldh [rWX], a
    push bc
    push de
    ldh a, [hMapSaveMedalLCDPhase]
    inc a
    ldh [hMapSaveMedalLCDPhase], a
    bit 0, a
    jr nz, .lower_phase
    ld a, $07
    ldh [hWX], a
    ld a, $17
    ldh [rLYC], a
    jr .phase_ready
.lower_phase
    ld a, $ff
    ldh [hWX], a
    ld a, $60
    ldh [rLYC], a
.phase_ready
    ld hl, rSTAT
    set 6, [hl]
    call MapSave_UpdateMedalDetailWindowX
    pop de
    pop bc
    pop hl
    pop af
    reti

MapSave_UpdateMedalDetailWindowX::
    ldh a, [hMapSaveMedalLCDPhase]
    bit 0, a
    jr z, .hidden
    ld a, $07
    jr .store
.hidden
    ld a, $ff
.store
    ldh [hMapSaveMedalWindowX], a
    ret

    assert @ == $37c2
