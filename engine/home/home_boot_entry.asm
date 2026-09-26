include "macros/macros.inc"

; Cartridge entry reached from the header jump at $0101. The boot ROM leaves
; a hardware/model identifier in A; $11 selects the CGB path used by the
; Bank-$10 boot presentation provider.

section "Cartridge Boot Entry", rom0[$0291]

CartridgeBootEntry::
    di
    ld sp, $d000
    push af
    ld a, $10
    ldh [hROMBank], a
    ld [rROMB0], a
    pop af
    ld [wBootHardwareModel], a
    call Startup_RunHardwarePresentation
    call SRAM_CheckSignature
    and a
    jr z, .validated
    call SRAM_EraseAllAndReinitialize
    farcall $19, NetworkRegistration_ValidateOrInitializeSignature
.validated
    assert @ == $02b1
