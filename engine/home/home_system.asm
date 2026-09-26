include "macros/macros.inc"

section "VBlank FIFO Reset", rom0[$34ce]

; Empty the deferred VBlank command queue.
VBlankFIFO_Clear::
    xor a
    ldh [hVBlankFIFO_Head], a
    ldh [hVBlankFIFO_Tail], a
    ldh [hVBlankFIFO_Count], a
    ldh [hVBlankFIFO_Bank], a
    ret

section "VBlank FIFO Wait", rom0[$352e]

; Wait until the deferred VBlank FIFO head catches the tail.
VBlankFIFO_WaitEmpty::
    ldh a, [hVBlankFIFO_Tail]
    ld b, a
.wait
    ldh a, [hVBlankFIFO_Head]
    cp b
    jr nz, .wait
    ret

section "Audio Driver Bridge", rom0[$37e9]

; Initialize the bank-4 audio driver while preserving the caller's active ROM
; bank, then clear the fixed-bank current-music shadow.
Audio_Init::
    ldh a, [hROMBank]
    push af
    ld a, AUDIO_DRIVER_ROM_BANK
    ldh [hROMBank], a
    ld [rROMB0], a
    call AudioDriver_Init
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    xor a
    ld [wCurrentMusic], a
    ret

; Service the bank-4 audio engine from the fixed-bank timer interrupt.
Audio_Update::
    ldh a, [hROMBank]
    push af
    ld a, AUDIO_DRIVER_ROM_BANK
    ldh [hROMBank], a
    ld [rROMB0], a
    call AudioDriver_Update
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret


section "Music Frontend", rom0[$3815]

; A=0 is the common stop/silence music request.
Audio_StopMusic::
    xor a

; Request music ID A. Re-requesting the active track returns without restart.
Audio_PlayMusic::
    push bc
    ld b, a
    call Audio_IsTrackActive
    and a
    jr z, .start
    ld a, [wCurrentMusic]
    cp b
    jr z, .done
.start
    ld a, b
    ld [wCurrentMusic], a
    push bc
    ld b, a
    ldh a, [hROMBank]
    push af
    ld a, AUDIO_DRIVER_ROM_BANK
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    call MusicDriver_RequestTrack
    ld b, a
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    pop bc
.done
    pop bc
    ret

assert @ == $3843

section "SFX Stop Frontend", rom0[$3843]

Audio_StopSFX::
    xor a

assert @ == $3844

section "Bank 04 Fixed-Bank Call Bridges", rom0[$3844]

; Fixed-bank audio bridges. Bank $04 is the already-source-backed music driver.
; These wrappers preserve the caller's active ROM bank while invoking the
; corresponding music-driver frontend entry. Compatibility labels retain the
; old mechanical names without keeping raw Bank-$04 addresses.
Audio_PlaySFX::
Audio_RequestSFX::
Bank04_Call4009:: ; compatibility alias
    push bc
    ld b, a
    ldh a, [hROMBank]
    push af
    ld a, $04
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    call MusicDriver_RequestSFX
    ld b, a
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    pop bc
    ret

Audio_IsMusicPlaying::
Audio_IsTrackActive::
Bank04_Call400F:: ; compatibility alias
    push bc
    ld b, a
    ldh a, [hROMBank]
    push af
    ld a, $04
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    call MusicDriver_IsTrackActive
    ld b, a
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    pop bc
    ret

Audio_IsSFXActive::
Bank04_Call4012:: ; compatibility alias
    push bc
    ld b, a
    ldh a, [hROMBank]
    push af
    ld a, $04
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    call MusicDriver_IsSFXActive
    ld b, a
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    pop bc
    ret

Audio_SetMasterVolume::
Bank04_Call4018:: ; compatibility alias
    push bc
    ld b, a
    ldh a, [hROMBank]
    push af
    ld a, $04
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    call MusicDriver_SetMasterVolume
    ld b, a
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, b
    pop bc
    ret

Audio_SaveStateAndStop::
Bank04_Call401B:: ; compatibility alias
    ldh a, [hROMBank]
    push af
    ld a, $04
    ldh [hROMBank], a
    ld [rROMB0], a
    call MusicDriver_SaveStateAndStopEntry
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

Audio_RestoreStateAndResume::
Bank04_Call401E:: ; compatibility alias
    ldh a, [hROMBank]
    push af
    ld a, $04
    ldh [hROMBank], a
    ld [rROMB0], a
    call MusicDriver_RestoreStateAndResumeEntry
    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

; Bank-0 SRAM metadata addresses selected by MapSRAM_SerializeSlot. The table
; is kept structural: the consumer proves these are 16-bit SRAM addresses,
; but not a stable player-facing identity for every entry.
MapSRAM_MetadataAddressTable::
    dw $a080, $a280, $a480, $a680, $a880, $aa80
    dw $a001, $b001, $a002, $a006, $b006, $b002
    dw $a003, $b003, $a006, $b006, $a004, $b004
    dw $a005, $a006, $b006, $b005, $b005, $b005
    dw $b005, $b005, $a006, $a006, $a006, $a006
    dw $a006, $b006, $b006, $b006, $b006, $b006

    assert @ == $391c

section "Memory Copy", rom0[$3b50]

; Copy bc bytes from de to hl.
; bc = length
; de = source
; hl = destination
Memcpy::
.loop
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .loop
    ret

section "Memory Access Helpers", rom0[$3b59]

; Copy bc bytes from de to hl while avoiding LCD modes 2/3 when the game's
; LCD-access guard is active. If the guard is clear, fall through to the
; ordinary byte-copy loop above. The routine exits with interrupts enabled
; on the guarded path, matching the retail ROM.
; bc = length
; de = source
; hl = destination
MemcpyWaitLCD::
    ld a, [wLCDC]
    bit LCDC_ENABLE_F, a
    jr z, Memcpy
.wait
    ei
    di
    ldh a, [rSTAT]
    and STAT_BUSY_MASK
    jr nz, .wait
    ld a, [de]
    ld [hl], a
    ldh a, [rSTAT]
    and STAT_BUSY_MASK
    jr nz, .wait
    ei
    inc de
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .wait
    ret

; Fill bc bytes starting at hl with a.
; a = fill byte
; bc = length
; hl = destination
Memset::
    push de
    ld d, a
.loop
    ld [hl], d
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .loop
    pop de
    ret

; LCD-synchronized form of Memset. When the LCD-access guard is clear, jump
; directly into Memset's byte loop after preserving DE and the fill byte.
; The guarded path waits until STAT mode bit 1 is clear before each write.
; a = fill byte
; bc = length
; hl = destination
MemsetWaitLCD::
    push de
    ld d, a
    ld a, [wLCDC]
    bit LCDC_ENABLE_F, a
    jr z, Memset.loop
.wait
    ei
    di
    ldh a, [rSTAT]
    and STAT_BUSY_MASK
    jr nz, .wait
    ld [hl], d
    ldh a, [rSTAT]
    and STAT_BUSY_MASK
    jr nz, .wait
    ei
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .wait
    pop de
    ret

; Fill bc little-endian words starting at hl with de.
; bc = word count
; de = repeated word
; hl = destination
FillWords::
.loop
    ld [hl], e
    inc hl
    ld [hl], d
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .loop
    ret

section "Frame and Erase-Prompt Helpers", rom0[$3baf]

; Advance A frames while continuing to poll input and refresh sprite state.
; a = frame count
AdvanceFrames::
.loop
    push af
    call Joypad_Update
    call Sprite_Update
    pop af
    dec a
    jr nz, .loop
    ret

; Load the VRAM tile graphics used by the manual absolute-erasure prompt.
; The original routine explicitly selects VRAM bank 0, temporarily switches
; ROM banks for each source block, then restores the caller's ROM bank.
LoadAbsoluteEraseGraphics::
    ld a, $00
    ldh [hVRAMBank], a
    ldh [rVBK], a

    ldh a, [hROMBank]
    push af

    ld a, $01
    ldh [hROMBank], a
    ld [rROMB0], a
    ld de, $5180
    ld hl, $9010
    ld bc, $0030
    call Memcpy

    ld a, $15
    ldh [hROMBank], a
    ld [rROMB0], a
    ld de, $6c3a
    ld hl, $9040
    ld bc, $0060
    call Memcpy

    pop af
    ldh [hROMBank], a
    ld [rROMB0], a
    ret


section "Word Table Pointer Helper", rom0[$3a93]

; A = zero-based entry index, HL = table of little-endian 16-bit pointers.
; Returns HL = pointer stored at table[A].
WordTable_Get::
    add a
    add l
    ld l, a
    ld a, h
    adc 0
    ld h, a
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret

    assert @ == $3a9e
