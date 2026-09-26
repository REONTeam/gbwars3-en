include "macros/macros.inc"

section "Mobile Adapter Interrupt Bridges", rom0[$0f7a]

; Serial interrupt bridge used by the Mobile Adapter driver. The driver state
; lives in WRAM bank 7 and its implementation lives in ROM bank $30.
MobileSerialInterrupt::
    push af
    ldh a, [hWRAMBank]
    push af
    ld a, MOBILE_ADAPTER_WRAM_BANK
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ldh a, [hROMBank]
    push af
    ld a, MOBILE_ADAPTER_ROM_BANK
    ldh [hROMBank], a
    ld [rROMB0], a
    call MobileAdapter_SerialService
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop af
    reti

; LCD STAT interrupt bridge paired with MobileVBlankInterrupt.
MobileLCDStatInterrupt::
    push af
    ldh a, [hWRAMBank]
    push af
    ld a, MOBILE_ADAPTER_WRAM_BANK
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ldh a, [hROMBank]
    push af
    ld a, MOBILE_ADAPTER_ROM_BANK
    ldh [hROMBank], a
    ld [rROMB0], a
    call MobileAdapter_LCDStatService
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop af
    reti

section "Mobile Adapter Status Access", rom0[$108c]

; Read the primary Mobile Adapter status byte from its WRAM-bank-7 state.
; Preserves HL and restores the caller's WRAM bank.
Mobile_GetStatusFlags::
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, MOBILE_ADAPTER_WRAM_BANK
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call Mobile_GetStatusPointer
    ld l, [hl]
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, l
    pop hl
    ret

; Return HL = pointer to the Mobile Adapter status structure. The pointer is
; stored in the fixed-bank API table at $3E0C; retail temporarily selects ROM
; bank $30 while reading it because the same helper is part of the bank-30
; Mobile Adapter ABI.
Mobile_GetStatusPointer::
    ldh a, [hROMBank]
    push af
    ld a, MOBILE_ADAPTER_ROM_BANK
    ldh [hROMBank], a
    ld [rROMB0], a
    ld hl, MobileAdapter_StatusPointer
    ld a, [hli]
    ld h, [hl]
    ld l, a
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

section "Random Number Generator", rom0[$2960]

; Advance the 16-bit pseudo-random seed using seed = seed * 5 + 1.
; This small LCG step is called once per mobile-session timer update.
Random_Advance::
    push hl
    push bc
    ld a, [wRandomSeed]
    ld l, a
    ld c, a
    ld a, [wRandomSeed + 1]
    ld h, a
    ld b, a
    add hl, hl
    add hl, hl
    add hl, bc
    ld bc, 1
    add hl, bc
    ld a, l
    ld [wRandomSeed], a
    ld a, h
    ld [wRandomSeed + 1], a
    pop bc
    pop hl
    ret

section "Mobile Session Timer", rom0[$2a83]

; Clear the mobile-session MM:SS timer and its 0-59 frame subcounter.
MobileSessionTimer_Reset::
    xor a
    ld [wMobileTimerFrames], a
    ld [wMobileTimerSeconds], a
    ld [wMobileTimerMinutes], a
    ret

; Advance the session timer when the mobile status byte reports bit 4 set.
; Frames and seconds roll over at 60; minutes saturate at 99:59.
MobileSessionTimer_Update::
    call Random_Advance
    call Mobile_GetStatusFlags
    bit 4, a
    jr z, .done

    ld a, [wMobileTimerMinutes]
    cp 99
    jr nz, .advance
    ld a, [wMobileTimerSeconds]
    cp 59
    jr z, .done
.advance
    ld a, [wMobileTimerFrames]
    inc a
    ld [wMobileTimerFrames], a
    cp 60
    jr nz, .done

    xor a
    ld [wMobileTimerFrames], a
    ld a, [wMobileTimerSeconds]
    inc a
    ld [wMobileTimerSeconds], a
    cp 60
    jr nz, .done

    xor a
    ld [wMobileTimerSeconds], a
    ld a, [wMobileTimerMinutes]
    inc a
    ld [wMobileTimerMinutes], a
.done
    ret

; Draw MM:SS at row 4, columns 8-12. DrawNumberFixedWidth is the fixed-width number
; renderer already used elsewhere; TextPut writes the literal separator.
MobileSessionTimer_Draw::
    ld a, [wMobileTimerMinutes]
    ld bc, $0804
    ld d, 2
    call DrawNumberFixedWidth
    ld hl, MobileSessionTimerSeparatorText
    ld bc, $0a04
    call TextPut
    ld a, [wMobileTimerSeconds]
    ld bc, $0b04
    ld d, 2
    call DrawNumberFixedWidth
    ret

MobileSessionTimerSeparatorText:
    db $3a, 0 ; ":" + terminator

