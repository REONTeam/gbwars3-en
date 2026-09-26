include "macros/macros.inc"

DEF INTERRUPT_BUSY_VBLANK_F EQU 0
DEF INTERRUPT_BUSY_AUDIO_F EQU 2
DEF INTERRUPT_TRAMPOLINE_JP_OPCODE EQU $c3
DEF INTERRUPT_TRAMPOLINE_RETI_OPCODE EQU $d9

; Core ROM0 helpers. These routines are used throughout the game, so keeping
; them in source gives later disassembly work stable names instead of relying
; on address-only symbol stubs.

section "Reset Bootstrap", rom0[$02b1]

; Common soft-reset entry used by the joypad chord and the boot path after
; save validation. Reset interrupt/display banking state, rebuild the OAM DMA
; helper and RAM interrupt trampolines, then continue through the normal main
; initialization path.
SoftReset::
    di
    ld sp, $ffff
    xor a
    ldh [rIE], a
    ldh [rIF], a
    ldh [rSTAT], a

    ld a, 0
    call SwitchSRAMBank

    ld a, 0
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a

    call ResetRuntimeState
    call VBlankFIFO_Clear
    call Audio_Init
    call Timer_Init
    call InstallOAMDMA

    ld sp, $d000
    jp Main_Init

; Copy the ten-byte OAM DMA helper into HRAM $FF84-$FF8D.
InstallOAMDMA::
    ld c, LOW(hOAMDMA)
    ld b, 10
    ld hl, OAMDMACode
.loop
    ld a, [hli]
    ldh [c], a
    inc c
    dec b
    jr nz, .loop
    ret

; Executed from HRAM. Start DMA from $C400 and delay long enough for transfer.
OAMDMACode:
    ld a, HIGH(wShadowOAM)
    ldh [rDMA], a
    ld a, $28
.wait
    dec a
    jr nz, .wait
    ret

; Restore scroll/window/input state and default RAM interrupt handlers.
ResetRuntimeState::
    xor a
    ldh [hSCX], a
    ldh [rSCX], a
    ldh [hSCY], a
    ldh [rSCY], a
    ldh [hWX], a
    ldh [rWX], a
    ldh [hWY], a
    ldh [rWY], a

    xor a
    ldh [hVBlankCounter], a
    ldh [hJoyHeld], a
    ldh [hJoyPressed], a
    ldh [hJoyRepeat], a
    ldh [hJoyRepeatDelay], a
    ld a, 4
    ldh [hJoyRepeatRate], a

    xor a
    ld [wInterruptBusyFlags], a
    ld [wOAMDMAPending], a
    call DisableLCDStatInterrupt
    call InstallDefaultTimerInterrupt
    call InstallDefaultVBlankInterrupt
    call DisableJoypadInterrupt

    ld a, $43
    ld [wLCDC], a
    ldh [rLCDC], a
    ret

section "RAM Interrupt Vectors", rom0[$0335]

; The hardware interrupt vectors jump through four three-byte RAM trampolines.
; These helpers install JP hl or a one-byte RETI as appropriate.
SetLCDStatInterrupt::
    push de
    ld de, wLCDStatInterruptTrampoline
    ld a, INTERRUPT_TRAMPOLINE_JP_OPCODE
    ld [de], a
    inc de
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    pop de
    ret

DisableLCDStatInterrupt::
    ld a, INTERRUPT_TRAMPOLINE_RETI_OPCODE
    ld [wLCDStatInterruptTrampoline], a
    ret

SetTimerInterrupt::
    push de
    ld de, wTimerInterruptTrampoline
    ld a, INTERRUPT_TRAMPOLINE_JP_OPCODE
    ld [de], a
    inc de
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    pop de
    ret

InstallDefaultTimerInterrupt::
    ld hl, DefaultTimerInterrupt
    call SetTimerInterrupt
    ret

SetVBlankInterrupt::
    push de
    ld de, wVBlankInterruptTrampoline
    ld a, INTERRUPT_TRAMPOLINE_JP_OPCODE
    ld [de], a
    inc de
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    pop de
    ret

InstallDefaultVBlankInterrupt::
    ld hl, DefaultVBlankInterrupt
    call SetVBlankInterrupt
    ret

SetJoypadInterrupt::
    push de
    ld de, wJoypadInterruptTrampoline
    ld a, INTERRUPT_TRAMPOLINE_JP_OPCODE
    ld [de], a
    inc de
    ld a, l
    ld [de], a
    inc de
    ld a, h
    ld [de], a
    pop de
    ret

DisableJoypadInterrupt::
    ld a, INTERRUPT_TRAMPOLINE_RETI_OPCODE
    ld [wJoypadInterruptTrampoline], a
    ret

section "Mobile Timer Interrupt Selection", rom0[$038b]

; Select the VBlank path that owns the on-screen MM:SS frame timer. This mode
; installs its paired LCD STAT handler and disables the normal timer interrupt;
; audio servicing is performed once per VBlank by MobileVBlankInterrupt.
InstallMobileVBlankInterrupt::
    di
    ld hl, MobileVBlankInterrupt
    call SetVBlankInterrupt
    ld hl, MobileLCDStatInterrupt
    call SetLCDStatInterrupt
    call DisableTimerInterrupt
    ei
    ret

; Restore the standard VBlank/LCD STAT/timer arrangement after the timed mode.
RestoreDefaultDisplayInterrupts::
    di
    call InstallDefaultVBlankInterrupt
    call DisableLCDStatInterrupt
    call Timer_Init
    call EnableTimerInterrupt
    ei
    ret

section "VBlank Interrupt Selection", rom0[$03ac]

; Select the battle-screen VBlank service while interrupts are masked, then
; restore the CPU interrupt master enable state expected by callers.
InstallBattleVBlankInterrupt::
    di
    ld hl, BattleVBlankInterrupt
    call SetVBlankInterrupt
    ei
    ret

; Restore the standard/default VBlank service.
RestoreDefaultVBlankInterrupt::
    di
    call InstallDefaultVBlankInterrupt
    ei
    ret

section "Default Timer Interrupt", rom0[$03bb]

; Default timer interrupt. The hardware timer runs continuously, but the
; bank-4 audio driver is serviced once every four timer interrupts. Bit 2 of
; wInterruptBusyFlags prevents re-entering the audio update while it is already active.
DefaultTimerInterrupt::
    push af
    push bc
    push de
    push hl
    ei
    ld hl, hAudioUpdateDivider
    ld a, [hl]
    inc [hl]
    and AUDIO_UPDATE_DIVIDER_MASK
    jr nz, .done
    ld hl, wInterruptBusyFlags
    bit INTERRUPT_BUSY_AUDIO_F, [hl]
    jr nz, .done
    set INTERRUPT_BUSY_AUDIO_F, [hl]
    call Audio_Update
    ld hl, wInterruptBusyFlags
    res INTERRUPT_BUSY_AUDIO_F, [hl]
.done
    pop hl
    pop de
    pop bc
    pop af
    reti

; Configure the Game Boy timer modulo and clock exactly as retail does. The
; first TAC write leaves the timer disabled at the selected clock; the second
; enables it.
Timer_Init::
    ld a, $78
    ldh [rTMA], a
    ld a, TAC_16384_HZ
    ldh [rTAC], a
    ld a, TAC_ENABLE_16384_HZ
    ldh [rTAC], a
    ret

section "Default VBlank Interrupt", rom0[$03ec]

; Standard VBlank service used by the normal map/UI display path. The handler
; refuses to re-enter while bit 0 of wInterruptBusyFlags is set, then copies
; the software display-register mirrors to hardware, services palettes and
; pending OAM DMA, drains one deferred VBlank command, and runs the basic map
; tile update only when the FIFO was empty on entry.
DefaultVBlankInterrupt::
    push af
    push bc
    push de
    push hl
    ld hl, wInterruptBusyFlags
    bit INTERRUPT_BUSY_VBLANK_F, [hl]
    jr nz, .done

    set INTERRUPT_BUSY_VBLANK_F, [hl]
    ldh a, [hSCX]
    ldh [rSCX], a
    ldh a, [hSCY]
    ldh [rSCY], a
    ldh a, [hWX]
    ldh [rWX], a
    ldh a, [hWY]
    ldh [rWY], a
    ld a, [wLCDC]
    ldh [rLCDC], a
    call Vram_UpdatePalsVBlank

    ld a, [wOAMDMAPending]
    and a
    jr z, .skipOAMDMA
    call hOAMDMA
    xor a
    ld [wOAMDMAPending], a
.skipOAMDMA
    ld a, [hVBlankFIFO_Count]
    push af
    call VBlankFIFO_Process
    pop af
    and a
    jr nz, .skipMapUpdate
    call BasicMapTileUpdate
.skipMapUpdate
    ld hl, hVBlankCounter
    inc [hl]
    ld hl, wInterruptBusyFlags
    res INTERRUPT_BUSY_VBLANK_F, [hl]
.done
    pop hl
    pop de
    pop bc
    pop af
    reti

section "Battle VBlank Interrupt", rom0[$043a]

; Battle-screen VBlank variant. This is byte-for-byte the same service shape as
; DefaultVBlankInterrupt, except that an empty FIFO triggers the battle
; helicopter HP-graphics updater instead of the standard map-tile updater.
BattleVBlankInterrupt::
    push af
    push bc
    push de
    push hl
    ld hl, wInterruptBusyFlags
    bit INTERRUPT_BUSY_VBLANK_F, [hl]
    jr nz, .done

    set INTERRUPT_BUSY_VBLANK_F, [hl]
    ldh a, [hSCX]
    ldh [rSCX], a
    ldh a, [hSCY]
    ldh [rSCY], a
    ldh a, [hWX]
    ldh [rWX], a
    ldh a, [hWY]
    ldh [rWY], a
    ld a, [wLCDC]
    ldh [rLCDC], a
    call Vram_UpdatePalsVBlank

    ld a, [wOAMDMAPending]
    and a
    jr z, .skipOAMDMA
    call hOAMDMA
    xor a
    ld [wOAMDMAPending], a
.skipOAMDMA
    ld a, [hVBlankFIFO_Count]
    push af
    call VBlankFIFO_Process
    pop af
    and a
    jr nz, .skipBattleUpdate
    call BattleHelicopterHPGraphicsUpdate
.skipBattleUpdate
    ld hl, hVBlankCounter
    inc [hl]
    ld hl, wInterruptBusyFlags
    res INTERRUPT_BUSY_VBLANK_F, [hl]
.done
    pop hl
    pop de
    pop bc
    pop af
    reti

section "Mobile VBlank Interrupt", rom0[$0488]

; Mobile/network VBlank variant used while the MM:SS session timer is active.
; Unlike the default and battle handlers it always drains the deferred FIFO,
; advances the timer, then enables nested interrupts and services audio directly
; once per VBlank.
; The installer disables the normal timer IRQ while this handler is selected.
MobileVBlankInterrupt::
    push af
    push bc
    push de
    push hl
    ld hl, wInterruptBusyFlags
    bit INTERRUPT_BUSY_VBLANK_F, [hl]
    jr nz, .done

    set INTERRUPT_BUSY_VBLANK_F, [hl]
    ldh a, [hSCX]
    ldh [rSCX], a
    ldh a, [hSCY]
    ldh [rSCY], a
    ldh a, [hWX]
    ldh [rWX], a
    ldh a, [hWY]
    ldh [rWY], a
    ld a, [wLCDC]
    ldh [rLCDC], a
    call Vram_UpdatePalsVBlank

    ld a, [wOAMDMAPending]
    and a
    jr z, .skipOAMDMA
    call hOAMDMA
    xor a
    ld [wOAMDMAPending], a
.skipOAMDMA
    call VBlankFIFO_Process
    call MobileSessionTimer_Update
    ei
    call Audio_Update
    ld hl, hVBlankCounter
    inc [hl]
    ld hl, wInterruptBusyFlags
    res INTERRUPT_BUSY_VBLANK_F, [hl]
.done
    pop hl
    pop de
    pop bc
    pop af
    reti

section "Frame Timing", rom0[$04d2]

; Wait for the VBlank frame counter to change while the game's frame-wait
; guard is active. When the guard is clear, return immediately.
DelayFrame::
    push hl
    ld a, [wLCDC]
    bit LCDC_ENABLE_F, a
    jr z, .done
    ld hl, hVBlankCounter
    ld a, [hl]
.wait
    halt
    nop
    cp [hl]
    jr z, .wait
.done
    pop hl
    ret

; Enable the LCD if it is currently disabled.
LCD_Enable::
    ld a, [wLCDC]
    bit LCDC_ENABLE_F, a
    ret nz
    set LCDC_ENABLE_F, a
    ld [wLCDC], a
    ldh [rLCDC], a
    ret

; Disable the LCD while temporarily masking VBlank.
LCD_Disable::
    ldh a, [rLCDC]
    bit LCDC_ENABLE_F, a
    ret z
    ldh a, [rIE]
    ld [wInterruptEnableBackup], a
    res 0, a
    ldh [rIE], a
    ld a, [wLCDC]
    res LCDC_ENABLE_F, a
    ld [wLCDC], a
    ldh [rLCDC], a
    xor a
    ldh [rIF], a
    ld a, [wInterruptEnableBackup]
    ldh [rIE], a
    ret

; Enable or disable the LCD window layer in LCDC.
LCD_EnableWindow::
    ld a, [wLCDC]
    set LCDC_WINDOW_ENABLE_F, a
    ld [wLCDC], a
    ldh [rLCDC], a
    ret

LCD_DisableWindow::
    ld a, [wLCDC]
    res LCDC_WINDOW_ENABLE_F, a
    ld [wLCDC], a
    ldh [rLCDC], a
    ret

Interrupt_EnableVBlank::
    xor a
    ldh [rIF], a
    ldh a, [rIE]
    set 0, a
    ldh [rIE], a
    ret

Interrupt_DisableVBlank::
    ldh a, [rIE]
    res 0, a
    ldh [rIE], a
    ret

Interrupt_EnableLCDStatMode0::
    ldh a, [rSTAT]
    or $08
    ldh [rSTAT], a
    xor a
    ldh [rIF], a
    jr Interrupt_EnableLCDStat

Interrupt_DisableLCDStatMode0::
    ldh a, [rSTAT]
    and $f7
    ldh [rSTAT], a
    xor a
    ldh [rIF], a
    jr Interrupt_DisableLCDStat

Interrupt_EnableLCDStat::
    xor a
    ldh [rIF], a
    ldh a, [rIE]
    set 1, a
    ldh [rIE], a
    ret

Interrupt_DisableLCDStat::
    xor a
    ldh [rIF], a
    ldh a, [rIE]
    res 1, a
    ldh [rIE], a
    ret

assert @ == $0565

section "Timer Interrupt Control", rom0[$0565]

; Clear pending interrupt flags and enable the timer interrupt in IE.
EnableTimerInterrupt::
    xor a
    ldh [rIF], a
    ldh a, [rIE]
    set IE_TIMER_F, a
    ldh [rIE], a
    ret

; Clear pending interrupt flags and disable the timer interrupt in IE.
DisableTimerInterrupt::
    xor a
    ldh [rIF], a
    ldh a, [rIE]
    res IE_TIMER_F, a
    ldh [rIE], a
    ret

Interrupt_EnableJoypad::
    xor a
    ldh [rIF], a
    ldh a, [rIE]
    set 4, a
    ldh [rIE], a
    ret

Interrupt_DisableJoypad::
    xor a
    ldh [rIF], a
    ldh a, [rIE]
    res 4, a
    ldh [rIE], a
    ret

assert @ == $058d

section "SRAM Bank Switch", rom0[$058d]

; Select SRAM bank a and retain the active bank in HRAM.
SwitchSRAMBank::
    ldh [hSRAMBank], a
    ld [rRAMB], a
    ret

; Enable/disable external cartridge RAM while preserving A.
SRAM_Enable::
    push af
    ld a, $0a
    ld [rRAMG], a
    pop af
    ret

SRAM_Disable::
    push af
    xor a
    ld [rRAMG], a
    pop af
    ret

section "Joypad Input", rom0[$05a2]

; Advance one frame, poll the joypad, then apply directional key-repeat.
Joypad_Update::
    call DelayFrame
    call Joypad_Read
    call Joypad_ApplyRepeat
    ret

; Poll both halves of rP1 and update the held/newly-pressed button state.
; Button bits use the Game Boy P1 layout after inversion:
; low nibble = A, B, Select, Start; high nibble = Right, Left, Up, Down.
; A+B+Select+Start held together triggers the game's soft reset once the
; combination is no longer considered newly pressed.
Joypad_Read::
    ld a, P1F_GET_DPAD
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    cpl
    and JOYPAD_BUTTONS_MASK
    swap a
    ld b, a

    ld a, P1F_GET_BUTTONS
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    cpl
    and JOYPAD_BUTTONS_MASK
    or b
    ld c, a

    ldh a, [hJoyHeld]
    xor c
    and c
    ld b, a
    ldh [hJoyPressed], a
    ld a, c
    ldh [hJoyHeld], a

    cp JOYPAD_BUTTONS_MASK
    jr nz, .finish
    ldh a, [hJoyPressed]
    and JOYPAD_BUTTONS_MASK
    jr nz, .softReset
.finish
    ld a, P1F_GET_NONE
    ldh [rP1], a
    ret
.softReset
    jp SoftReset

; Produce the input state consumed by menus/gameplay. Face buttons only fire
; on their newly-pressed frame. Directions repeat after hJoyRepeatDelay frames,
; then at the interval held in hJoyRepeatRate.
Joypad_ApplyRepeat::
    ldh a, [hJoyHeld]
    and JOYPAD_DPAD_MASK
    jr z, .buttonsOnly

    ld hl, hJoyRepeatDelay
    ldh a, [hJoyPressed]
    and JOYPAD_DPAD_MASK
    jr z, .heldDirection
    ld [hl], 20
    jr .emit
.heldDirection
    dec [hl]
    jr nz, .buttonsOnly
    ldh a, [hJoyRepeatRate]
    ld [hl], a
.emit
    ldh a, [hJoyPressed]
    and JOYPAD_BUTTONS_MASK
    ld l, a
    ldh a, [hJoyHeld]
    and JOYPAD_DPAD_MASK
    or l
    ldh [hJoyRepeat], a
    ret
.buttonsOnly
    ldh a, [hJoyPressed]
    and JOYPAD_BUTTONS_MASK
    ldh [hJoyRepeat], a
    ret

section "Palette Defaults", rom0[$0618]

; Reset the palette upload state, restore all 16 BG/OBJ working palettes to
; their ROM defaults, then request a full hardware palette upload.
Vram_ResetPals::
    xor a
    ld [wPalsVBlankParam1], a
    ld [wPalsVBlankParam2], a
    ld [wPalsVBlankParam3], a
    ld hl, DefaultPalettes
    xor a
    ld b, 16
    call Vram_SetPals
    call Vram_ApplyPals
    ret

; Eight BG palettes followed by eight OBJ palettes.
; Each row is one four-color CGB palette in BGR555 format.
DefaultPalettes:
    dw $7fff, $0000, $7fff, $0000
    dw $7fff, $4210, $0000, $6318
    dw $7fff, $4210, $0000, $6318
    dw $7fff, $4210, $0000, $6318
    dw $7fff, $4210, $0000, $6318
    dw $7fff, $4210, $0000, $6318
    dw $7fff, $4210, $0000, $6318
    dw $7fff, $4210, $0000, $6318
    dw $7fff, $6980, $7fff, $7fff
    dw $0000, $01be, $4631, $7fff
    dw $0000, $01be, $4631, $7fff
    dw $0000, $01be, $4631, $7fff
    dw $0000, $01be, $4631, $7fff
    dw $0000, $01be, $4631, $7fff
    dw $0000, $01be, $4631, $7fff
    dw $0000, $01be, $4631, $7fff

; Restore BG palette 0 from the common palette stored in bank 1.
; This helper intentionally leaves the hardware upload to its caller.
Vram_SetDefaultBGPal::
    ld a, 0
    ld b, 1
    ld c, 1
    ld hl, $5118
    call Vram_SetFarPals
    ret

section "Palette Copy Routines", rom0[$06bc]

; Copy b palettes from hl to wPals, starting at palette a.
; a = destination palette index
; b = palette count
; hl = source
Vram_SetPals::
    push bc
    push de
    sla b
    sla b
    sla b
    add a
    add a
    add a
    ld de, wPals
    add e
    ld e, a
    ld a, d
    adc 0
    ld d, a
.loop
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, .loop
    pop de
    pop bc
    ret

; Copy b palettes from bank c:hl to wPals, starting at palette a.
; Restores the previous ROM bank before returning.
Vram_SetFarPals::
    push bc
    push de
    ld d, a
    ldh a, [hROMBank]
    push af
    ld a, c
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, d
    call Vram_SetPals
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    pop de
    pop bc
    ret

section "Palette Update", rom0[$06f2]

; Request a full BG + OBJ palette upload.
Vram_ApplyPals::
    xor a
    set 6, a
    set 5, a
    jr Vram_RequestPals

; Request a full BG palette upload.
Vram_ApplyBGPals::
    xor a
    set 6, a
    jr Vram_RequestPals

; Request a full OBJ palette upload.
Vram_ApplyOBJPals::
    xor a
    set 5, a
    jr Vram_RequestPals

; Request selected BG/OBJ palettes. B and C are bitmasks selecting palettes.
Vram_ApplySelectedPals::
    ld a, b
    ld [wPalsVBlankParam2], a
    ld a, c
    ld [wPalsVBlankParam3], a
    xor a
Vram_RequestPals:
    set 7, a
    ld [wPalsVBlankParam1], a
    ld a, [wLCDC]
    bit LCDC_ENABLE_F, a
    ret nz
    call Vram_UpdatePalsVBlank
    ret

; Service a pending palette request. A full request uploads all 8 BG and/or
; OBJ palettes; otherwise the two bitmasks select individual palettes.
Vram_UpdatePalsVBlank::
    ld a, [wPalsVBlankParam1]
    bit LCDC_ENABLE_F, a
    jr z, .done
    bit 6, a
    jr nz, .allBG
    bit 5, a
    jr nz, .allOBJ

    ld b, 8
    ld a, [wPalsVBlankParam2]
    ld c, a
.bgLoop
    rrc c
    jr nc, .nextBG
    push bc
    ld a, 8
    sub b
    ld b, 8
    call Vram_UploadPals
    pop bc
.nextBG
    dec b
    jr nz, .bgLoop

    ld b, 8
    ld a, [wPalsVBlankParam3]
    ld c, a
.objLoop
    rrc c
    jr nc, .nextOBJ
    push bc
    ld a, 16
    sub b
    ld b, 8
    call Vram_UploadPals
    pop bc
.nextOBJ
    dec b
    jr nz, .objLoop
    jr .clearRequest

.allBG
    xor a
    ld b, $40
    call Vram_UploadPals
    ld a, [wPalsVBlankParam1]
    res 6, a
    ld [wPalsVBlankParam1], a
    bit 5, a
    jr z, .clearRequest

.allOBJ
    ld a, 8
    ld b, $40
    call Vram_UploadPals
    ld a, [wPalsVBlankParam1]
    res 5, a
    ld [wPalsVBlankParam1], a
    jr .clearRequest

.clearRequest
    xor a
    ld [wPalsVBlankParam2], a
    ld [wPalsVBlankParam3], a
    ld [wPalsVBlankParam1], a
    ret
.done
    ret

; Upload b bytes from wPals beginning at palette a. Palette indices 0-7 map
; to BG palette RAM and 8-15 map to OBJ palette RAM.
Vram_UploadPals::
    add a
    add a
    add a
    ld e, a
    ld d, 0
    ld hl, wPals
    add hl, de
    ld c, LOW(rBGPI)
    bit 6, a
    jr z, .gotPort
    ld c, LOW(rOBPI)
.gotPort
    and $3f
    ld e, a
.loop
    ld a, e
    ldh [c], a
    inc c
.wait
    ldh a, [rSTAT]
    and STAT_BUSY_MASK
    jr nz, .wait
    ld a, [hl]
    ldh [c], a
    ldh a, [c]
    cp [hl]
    jr nz, .wait
    dec c
    inc e
    inc hl
    dec b
    jr nz, .loop
    ret

section "VRAM Tilemap Helpers", rom0[$0ed4]

; Return the BG tilemap address for coordinate (b, c).
; b = x coordinate
; c = y coordinate
; hl = $9800 + b + c * 32
Vram_TilemapCoord::
    ld a, c
    rlca
    swap a
    ld l, a
    and $0f
    add $98
    ld h, a
    ld a, $f0
    and l
    add b
    ld l, a
    ret

; Retail helper at $0EE4 retained with a literal behavior name until a caller
; proves the higher-level coordinate contract.
Vram_TilemapCoordAdd32ToY::
    ld a, c
    add $20
    ld c, a
    jr Vram_TilemapCoord

; Advance HL one BG-map column, wrapping the low five tile-X bits.
Vram_TilemapAdvanceColumnWrapped::
    push de
    ld a, l
    and $e0
    ld d, a
    ld a, l
    inc a
    and $1f
    or d
    ld l, a
    pop de
    ret

; Advance HL one BG-map row and wrap the address back into $9800-$9BFF.
Vram_TilemapAdvanceRowWrapped::
    push de
    ld de, $0020
    add hl, de
    ld a, h
    and $9b
    ld h, a
    pop de
    ret

    assert @ == $0f02

section "BG Tilemap Clear", rom0[$0f02]

; Clear the visible $9800-$9BFF BG tilemap in both CGB VRAM banks.
Vram_ClearBGTilemapBothBanks::
    ld a, 0
    ldh [hVRAMBank], a
    ldh [rVBK], a
    call Vram_ClearBGTilemapCurrentBank
    ld a, 1
    ldh [hVRAMBank], a
    ldh [rVBK], a

Vram_ClearBGTilemapCurrentBank::
    ld hl, $9800
    ld bc, $0400
    xor a
    call Memset
    ret

    assert @ == $0f1c

section "VRAM Byte Access", rom0[$0f1c]

; Write A to [HL] and increment HL. If the LCD is active, synchronize the
; actual write to a safe LCD mode first.
Vram_Put::
    push af
    ld a, [wLCDC]
    bit LCDC_ENABLE_F, a
    jr nz, .wait
    pop af
    ld [hli], a
    ret
.wait
    pop af
    call Vram_PutWaitBlank
    inc hl
    ret

; Write A to [HL], waiting until STAT mode bit 1 is clear before and after
; the access. Interrupts are briefly toggled while waiting, matching retail.
Vram_PutWaitBlank::
    push de
    ld e, a
.wait
    ei
    di
    ldh a, [rSTAT]
    and STAT_BUSY_MASK
    jr nz, .wait
    ld [hl], e
    ldh a, [rSTAT]
    and STAT_BUSY_MASK
    jr nz, .wait
    ei
    pop de
    ret

; Read [HL] into A and increment HL, synchronizing to a safe LCD mode when
; the LCD is active.
Vram_Get::
    ld a, [wLCDC]
    bit LCDC_ENABLE_F, a
    jr nz, .wait
    ld a, [hli]
    ret
.wait
    call Vram_GetWaitBlank
    inc hl
    ret

; Read [HL] into A using the same LCD-mode synchronization as writes.
Vram_GetWaitBlank::
    push de
.wait
    ei
    di
    ldh a, [rSTAT]
    and STAT_BUSY_MASK
    jr nz, .wait
    ld e, [hl]
    ldh a, [rSTAT]
    and STAT_BUSY_MASK
    jr nz, .wait
    ei
    ld a, e
    pop de
    ret

