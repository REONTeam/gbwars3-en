include "macros/macros.inc"

section "Music-to-Sound Bank Call", rom0[$3fe0]

; Call the sound driver in ROM bank $08 through HL, then resume execution in
; the primary music-engine bank ($03). This helper is used by the duplicated
; music-engine code when it needs the separate sound/SFX driver.
; hl = target routine in bank $08
Audio_CallSoundDriver::
    push af
    ld a, SOUND_DRIVER_ROM_BANK
    ldh [hROMBank], a
    ld [rROMB0], a
    pop af
    ld bc, .return
    push bc
    jp hl
.return
    ld a, MUSIC_ENGINE_PRIMARY_ROM_BANK
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

