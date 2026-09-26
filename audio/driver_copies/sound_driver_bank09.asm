include "macros/macros.inc"

section "Sound Driver Entry and SFX Start [Bank09 Copy]", romx[$4000], bank[$09]

; Fixed entry used by the music engine through Audio_CallSoundDriver.
; a = sound-effect ID ($00-$86)
SoundDriver_PlaySFX:
; Legacy name retained as a zero-byte compatibility alias.
SoundDriver_Init:
    jp SoundDriver_PlaySFX_Impl

; Per-frame SFX sequencer entry. Its implementation remains a later target.
SoundDriver_Update:
    jp SoundDriver_Update_Impl

; Start a sound effect and assign its streams to the participating hardware
; channels. A definition contains a data bank, a four-bit channel mask, then
; one 16-bit stream pointer for each set channel bit (channels 1-4 in order).
SoundDriver_PlaySFX_Impl:
    ld hl, SoundEffectCount
    cp [hl]
    jp nc, .return

    ld c, a
    ld b, $00
    ld l, c
    ld h, b
    add hl, bc
    ld c, l
    ld b, h

    ; If another SFX is active, silence only the hardware channels it owned.
    ld a, [wSFXActive]
    or a
    jr z, .install_definition

    ld a, [wSFXChannelMask]
    rrca
    ld [wSFXChannelMask], a
    jr nc, .check_previous_pulse2
    ld a, $08
    ldh [rNR10], a
    ldh [rNR12], a
    swap a
    ldh [rNR14], a
.check_previous_pulse2
    ld a, [wSFXChannelMask]
    rrca
    ld [wSFXChannelMask], a
    jr nc, .check_previous_wave
    ld a, $08
    ldh [rNR22], a
    swap a
    ldh [rNR24], a
.check_previous_wave
    ld a, [wSFXChannelMask]
    rrca
    ld [wSFXChannelMask], a
    jr nc, .check_previous_noise
    ld a, $00
    ldh [rNR32], a
.check_previous_noise
    ld a, [wSFXChannelMask]
    rrca
    jr nc, .install_definition
    ld a, $08
    ldh [rNR42], a
    swap a
    ldh [rNR44], a

.install_definition
    ld a, $01
    ld [wSFXActive], a

    ld hl, SoundEffectPointerTable
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a

    ld a, [hl+]
    ld [wSFXDataBank], a
    ld a, [hl+]
    ld [wSFXChannelMask], a
    ld [wSFXChannelMaskWork], a

    ld de, wSFXChannelStreamPointers
    ld c, $00
    ld b, $00
.install_channel_loop
    ld a, [wSFXChannelMaskWork]
    rrca
    ld [wSFXChannelMaskWork], a
    jr nc, .skip_unused_channel

    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    inc de

    push hl
    ld a, c
    cp AUDIO_CHANNEL_PULSE1
    jr nz, .reset_channel_state
    ld a, $08
    ldh [rNR10], a
.reset_channel_state
    ld hl, wSFXChannelPitchDelta
    add hl, bc
    ld [hl], $00
    ld hl, wSFXChannelDelay
    add hl, bc
    ld [hl], $01
    pop hl
    jr .next_install_channel

.skip_unused_channel
    inc de
    inc de
.next_install_channel
    inc c
    ld a, AUDIO_CHANNEL_COUNT
    cp c
    jr nz, .install_channel_loop
.return
    ret


; Per-frame sound-effect sequencer. The active-channel mask selects which of
; the four hardware channels are serviced. Each participating channel has a
; countdown; when it reaches zero, commands are consumed until a wait or end
; command yields back to the frame loop.
SoundDriver_Update_Impl:
    ld a, [wSFXDataBank]
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, [wSFXChannelMask]
    or a
    jr nz, .service_active_channels
    call SoundDriver_Stop
    ret

.service_active_channels
    xor a
    ld b, a
    ld c, a
    ld a, [wSFXChannelMask]
    ld [wSFXUpdateMask], a
.update_channel_loop
    ld hl, wSFXUpdateMask
    ld a, [hl]
    rrca
    ld [hl], a
    jr nc, .next_update_channel

    ld hl, wSFXChannelDelay
    add hl, bc
    ld a, [hl]
    dec a
    jr z, .run_expired_stream
    ld [hl], a
    call SoundDriver_ApplyPitchDelta
    jr .next_update_channel

.run_expired_stream
    ld hl, wSFXChannelStreamPointers
    add hl, bc
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call SoundDriver_RunCommand

.next_update_channel
    inc c
    ld a, c
    cp AUDIO_CHANNEL_COUNT
    jr nz, .update_channel_loop
    ret

; Commands use the high nibble as a 0-15 opcode and leave the low nibble in A
; for compact inline arguments. The stream pointer after the command byte is
; pushed so handlers can either consume operands and continue immediately, or
; save the pointer and return to the per-frame loop.
SoundDriver_RunCommand:
.loop
    ld a, [hl]
    and $f0
    swap a
    add a
    ld e, a
    ld d, $00
    ld a, [hl+]
    push hl
    and $0f
    ld hl, SoundDriverCommandTable
    add hl, de
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld h, d
    ld l, e
    jp hl

SoundDriverCommandTable:
    dw SoundCommand_Frequency
    dw SoundCommand_Envelope
    dw SoundCommand_DutyLength
    dw SoundCommand_LoopStart
    dw SoundCommand_LoopRepeat
    dw SoundCommand_PitchDelta
    dw SoundCommand_Wait
    dw SoundCommand_WavePattern
    dw SoundCommand_ChannelRouting
    dw SoundCommand_Sweep
    dw SoundCommand_Nop
    dw SoundCommand_Nop
    dw SoundCommand_Nop
    dw SoundCommand_Nop
    dw SoundCommand_Nop
    dw SoundCommand_End

SoundCommand_Nop:
    jp SoundDriver_RunCommand.loop

; Opcode $0: low nibble = high frequency bits, next byte = low frequency byte.
SoundCommand_Frequency:
    ld d, a
    pop hl
    ld a, [hl+]
    ld e, a
    push hl
    ld hl, wSFXChannelFrequency
    add hl, bc
    add hl, bc
    push bc
    ld b, [hl]
    ld [hl], e
    inc hl
    ld [hl], d
    ld a, c
    cp AUDIO_CHANNEL_NOISE
    jr nz, .trigger
    ld a, b
    xor e
    and $08
    swap a
    ld d, a
.trigger
    pop bc
    ld hl, wSFXChannelTrigger
    add hl, bc
    ld a, [hl]
    ld [hl], $00
    or d
    ld d, a
    ld hl, rNR11
    ld a, c
    add a
    add a
    add c
    add l
    ld l, a
    ld a, [hl]
    and $c0
    ld [hl+], a
    inc hl
    ld a, e
    ld [hl+], a
    ld [hl], d
    pop de

SoundDriver_SaveStreamPointer:
    ld hl, wSFXChannelStreamPointers
    add hl, bc
    add hl, bc
    ld [hl], e
    inc hl
    ld [hl], d
    ret

; Opcode $1: next byte = hardware envelope register value.
SoundCommand_Envelope:
    ld hl, wSFXChannelTrigger
    add hl, bc
    ld a, $80
    ld [hl], a
    pop hl
    ld a, [hl+]
    ld e, a
    push hl
    ld hl, rNR12
    ld a, c
    add a
    add a
    add c
    add l
    ld l, a
    ld [hl], e
    pop hl
    jp SoundDriver_RunCommand.loop

; Opcode $2: low nibble is moved to the upper nibble of the channel's
; duty/length register.
SoundCommand_DutyLength:
    swap a
    ld e, a
    ld hl, rNR11
    ld a, c
    add a
    add a
    add c
    add l
    ld l, a
    ld [hl], e
    pop hl
    jp SoundDriver_RunCommand.loop

; Opcode $3: next byte = repeat count; remember the following stream address.
SoundCommand_LoopStart:
    ld hl, wSFXChannelLoopPointers
    add hl, bc
    add hl, bc
    pop de
    ld a, [de]
    inc de
    ld [hl], e
    inc hl
    ld [hl], d
    ld hl, wSFXChannelLoopCount
    add hl, bc
    ld [hl], a
    ld l, e
    ld h, d
    jp SoundDriver_RunCommand.loop

; Opcode $4: repeat from the saved loop pointer while the counter is nonzero.
SoundCommand_LoopRepeat:
    ld hl, wSFXChannelLoopCount
    add hl, bc
    ld a, [hl]
    dec a
    jr z, .done
    ld [hl], a
    ld hl, wSFXChannelLoopPointers
    add hl, bc
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    pop de
    jp SoundDriver_RunCommand.loop
.done
    pop hl
    jp SoundDriver_RunCommand.loop

; Opcode $5: next byte = signed per-frame pitch delta.
SoundCommand_PitchDelta:
    ld hl, wSFXChannelPitchDelta
    add hl, bc
    ld e, l
    ld d, h
    pop hl
    ld a, [hl+]
    ld [de], a
    jp SoundDriver_RunCommand.loop

; Opcode $6: apply the current pitch delta, then store the next-byte delay and
; yield until a later SoundDriver_Update call.
SoundCommand_Wait:
    ld a, c
    cp AUDIO_CHANNEL_NOISE
    jr nz, .tone
    call SoundDriver_ApplyNoisePitchDelta
    jr .storeDelay
.tone
    call SoundDriver_ApplyPitchDelta
.storeDelay
    ld hl, wSFXChannelDelay
    add hl, bc
    ld e, l
    ld d, h
    pop hl
    ld a, [hl+]
    ld [de], a
    ld e, l
    ld d, h
    jp SoundDriver_SaveStreamPointer

; Apply signed pitch delta to pulse/wave channels and write the resulting
; frequency back to the hardware channel registers.
SoundDriver_ApplyPitchDelta:
    ld hl, wSFXChannelPitchDelta
    add hl, bc
    ld a, [hl]
    or a
    jr z, .done
    ld hl, wSFXChannelFrequency
    add hl, bc
    add hl, bc
    bit 7, a
    jr z, .positive
    xor $ff
    inc a
    ld d, a
    ld a, [hl]
    sub d
    ld [hl+], a
    ld e, a
    ld a, [hl]
    sbc b
    jr .writeHigh
.positive
    ld d, a
    ld a, [hl]
    add d
    ld [hl+], a
    ld e, a
    ld a, [hl]
    adc b
.writeHigh
    ld [hl], a
    ld hl, wSFXChannelTrigger
    add hl, bc
    ld d, [hl]
    ld [hl], $00
    or d
    ld d, a
    ld hl, rNR11
    ld a, c
    add a
    add a
    add c
    add l
    ld l, a
    ld a, [hl]
    and $c0
    ld [hl+], a
    inc hl
    ld a, e
    ld [hl+], a
    ld [hl], d
.done
    ret

; Noise channel pitch is a single byte; bit 3 crossing contributes to the
; trigger value in the same way as the retail driver.
SoundDriver_ApplyNoisePitchDelta:
    ld hl, wSFXChannelPitchDelta + 3
    ld a, [hl]
    or a
    jr z, .done
    ld hl, wSFXChannelFrequency + 6
    bit 7, a
    jr z, .positive
    xor $ff
    inc a
    ld d, a
    ld e, [hl]
    ld a, e
    sub d
    ld [hl], a
    jr .updated
.positive
    ld d, a
    ld e, [hl]
    ld a, e
    add d
    ld [hl], a
.updated
    ld d, a
    xor e
    and $08
    swap a
    ld hl, wSFXChannelTrigger + 3
    ld e, [hl]
    ld [hl], $00
    or e
    ld e, a
    ld hl, rNR41
    xor a
    ld [hl+], a
    inc hl
    ld a, d
    ld [hl+], a
    ld [hl], e
.done
    ret

; Opcode $7: low nibble selects one of the 16-byte wave patterns.
SoundCommand_WavePattern:
    add a
    ld d, $00
    ld e, a
    ld hl, SoundDriverWavePointerTable
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, $00
    ldh [rNR30], a ; disable wave channel while updating wave RAM
    ld b, d
    ld de, $ff30
.copyWave
    ld a, [hl+]
    ld [de], a
    inc de
    inc b
    ld a, b
    cp $10
    jr nz, .copyWave
    ld a, $01
    ld [wWavePatternReloadPending], a
    ld a, $80
    ldh [rNR30], a ; re-enable wave channel
    ld b, $00
    pop hl
    jp SoundDriver_RunCommand.loop

; Opcode $8: next byte updates the two routing bits belonging to this channel.
SoundCommand_ChannelRouting:
    pop hl
    ld a, [hl+]
    push hl
    push bc
    inc c
    ld e, $ee
.rotateMask
    dec c
    jr z, .merge
    rlca
    rlc e
    jr .rotateMask
.merge
    ld d, a
    ld hl, wSFXRoutingShadow
    ld a, [hl]
    and e
    or d
    ld [hl], a
    pop bc
    pop hl
    jp SoundDriver_RunCommand.loop

; Opcode $9: next byte is written directly to pulse channel 1 sweep (NR10).
SoundCommand_Sweep:
    pop hl
    ld a, [hl+]
    ldh [rNR10], a
    jp SoundDriver_RunCommand.loop

; Opcode $F: stop this channel, clear it from the active mask, and silence its
; envelope/trigger registers. This yields from the interpreter.
SoundCommand_End:
    ld e, c
    inc e
    ld a, $7f
.makeMask
    rlca
    dec e
    jr nz, .makeMask
    ld e, a
    ld a, [wSFXChannelMask]
    and e
    ld [wSFXChannelMask], a
    ld a, c
    rlca
    rlca
    add c
    ld e, a
    ld d, b
    ld hl, rNR12
    add hl, de
    ld a, $08
    ld [hl+], a
    inc hl
    swap a
    ld [hl], a
    pop hl
    ret

SoundDriver_Stop:
    xor a ; AUDIO_SFX_REQUEST_IDLE
    ld [wSFXActive], a
    ld [wSFXRequestPriority], a
    ld [wSFXRequestState], a
    ret

section "Sound Effect Pointer Table [Bank09 Copy]", romx[$42d6], bank[$09]
; Valid SFX IDs are $00-$86. Definitions are now explicit source below.
SoundEffectCount:
    db $87

SoundEffectPointerTable:
    dw SoundEffectDef_00, SoundEffectDef_01, SoundEffectDef_02, SoundEffectDef_03, SoundEffectDef_04, SoundEffectDef_05, SoundEffectDef_06, SoundEffectDef_07
    dw SoundEffectDef_08, SoundEffectDef_09, SoundEffectDef_0A, SoundEffectDef_0B, SoundEffectDef_0C, SoundEffectDef_0D, SoundEffectDef_0E, SoundEffectDef_0F
    dw SoundEffectDef_10, SoundEffectDef_11, SoundEffectDef_12, SoundEffectDef_13, SoundEffectDef_14, SoundEffectDef_15, SoundEffectDef_16, SoundEffectDef_17
    dw SoundEffectDef_18, SoundEffectDef_19, SoundEffectDef_1A, SoundEffectDef_1B, SoundEffectDef_1C, SoundEffectDef_1D, SoundEffectDef_1E, SoundEffectDef_1F
    dw SoundEffectDef_20, SoundEffectDef_21, SoundEffectDef_22, SoundEffectDef_23, SoundEffectDef_24, SoundEffectDef_25, SoundEffectDef_26, SoundEffectDef_27
    dw SoundEffectDef_28, SoundEffectDef_29, SoundEffectDef_2A, SoundEffectDef_2B, SoundEffectDef_2C, SoundEffectDef_2D, SoundEffectDef_2E, SoundEffectDef_2F
    dw SoundEffectDef_30, SoundEffectDef_31, SoundEffectDef_32, SoundEffectDef_33, SoundEffectDef_34, SoundEffectDef_35, SoundEffectDef_36, SoundEffectDef_37
    dw SoundEffectDef_38, SoundEffectDef_39, SoundEffectDef_3A, SoundEffectDef_3B, SoundEffectDef_3C, SoundEffectDef_3D, SoundEffectDef_3E, SoundEffectDef_3F
    dw SoundEffectDef_40, SoundEffectDef_41, SoundEffectDef_42, SoundEffectDef_43, SoundEffectDef_44, SoundEffectDef_45, SoundEffectDef_46, SoundEffectDef_47
    dw SoundEffectDef_48, SoundEffectDef_49, SoundEffectDef_4A, SoundEffectDef_4B, SoundEffectDef_4C, SoundEffectDef_4D, SoundEffectDef_4E, SoundEffectDef_4F
    dw SoundEffectDef_50, SoundEffectDef_51, SoundEffectDef_52, SoundEffectDef_53, SoundEffectDef_54, SoundEffectDef_55, SoundEffectDef_56, SoundEffectDef_57
    dw SoundEffectDef_58, SoundEffectDef_59, SoundEffectDef_5A, SoundEffectDef_5B, SoundEffectDef_5C, SoundEffectDef_5D, SoundEffectDef_5E, SoundEffectDef_5F
    dw SoundEffectDef_60, SoundEffectDef_61, SoundEffectDef_62, SoundEffectDef_63, SoundEffectDef_64, SoundEffectDef_65, SoundEffectDef_66, SoundEffectDef_67
    dw SoundEffectDef_68, SoundEffectDef_69, SoundEffectDef_6A, SoundEffectDef_6B, SoundEffectDef_6C, SoundEffectDef_6D, SoundEffectDef_6E, SoundEffectDef_6F
    dw SoundEffectDef_70, SoundEffectDef_71, SoundEffectDef_72, SoundEffectDef_73, SoundEffectDef_74, SoundEffectDef_75, SoundEffectDef_76, SoundEffectDef_77
    dw SoundEffectDef_78, SoundEffectDef_79, SoundEffectDef_7A, SoundEffectDef_7B, SoundEffectDef_7C, SoundEffectDef_7D, SoundEffectDef_7E, SoundEffectDef_7F
    dw SoundEffectDef_80, SoundEffectDef_81, SoundEffectDef_82, SoundEffectDef_83, SoundEffectDef_84, SoundEffectDef_85, SoundEffectDef_86

section "Sound Effect Definitions [Bank09 Copy]", romx[$43e5], bank[$09]

; Two structurally valid definitions precede ID $00 but are not referenced by
; SoundEffectPointerTable. Preserve them explicitly rather than treating them as padding.
SoundEffectDef_Unindexed_Bank08:
    db $08, $01
    dw SoundEffectStream_Unindexed_Bank08_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_Unindexed_Bank09:
    db $09, $01
    dw SoundEffectStream_Unindexed_Bank09_Ch1 ; channel 1 stream, bank $09

; Definition format: data bank, 4-bit channel mask, then one stream pointer
; for each participating channel in channel order (pulse1, pulse2, wave, noise).
SoundEffectDef_00: ; $43ED
    db $08, $00

SoundEffectDef_01: ; $43EF
    db $08, $01
    dw SoundEffectStream_01_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_02: ; $43F3
    db $08, $01
    dw SoundEffectStream_02_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_03: ; $43F7
    db $08, $01
    dw SoundEffectStream_03_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_04: ; $43FB
    db $08, $01
    dw SoundEffectStream_04_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_05: ; $43FF
    db $08, $03
    dw SoundEffectStream_05_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_05_Ch2 ; channel 2 stream, bank $08

SoundEffectDef_06: ; $4405
    db $08, $01
    dw SoundEffectStream_06_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_07: ; $4409
    db $08, $01
    dw SoundEffectStream_07_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_08: ; $440D
    db $08, $01
    dw SoundEffectStream_08_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_09: ; $4411
    db $08, $01
    dw SoundEffectStream_09_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_0A: ; $4415
    db $08, $01
    dw SoundEffectStream_0A_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_0B: ; $4419
    db $08, $01
    dw SoundEffectStream_0B_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_0C: ; $441D
    db $08, $01
    dw SoundEffectStream_0C_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_0D: ; $4421
    db $08, $01
    dw SoundEffectStream_0D_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_0E: ; $4425
    db $08, $01
    dw SoundEffectStream_0E_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_0F: ; $4429
    db $08, $01
    dw SoundEffectStream_0F_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_10: ; $442D
    db $08, $09
    dw SoundEffectStream_10_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_10_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_11: ; $4433
    db $08, $01
    dw SoundEffectStream_11_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_12: ; $4437
    db $08, $01
    dw SoundEffectStream_12_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_13: ; $443B
    db $08, $01
    dw SoundEffectStream_13_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_14: ; $443F
    db $08, $01
    dw SoundEffectStream_14_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_15: ; $4443
    db $08, $01
    dw SoundEffectStream_15_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_16: ; $4447
    db $08, $01
    dw SoundEffectStream_16_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_17: ; $444B
    db $08, $01
    dw SoundEffectStream_17_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_18: ; $444F
    db $08, $09
    dw SoundEffectStream_18_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_18_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_19: ; $4455
    db $08, $01
    dw SoundEffectStream_19_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_1A: ; $4459
    db $08, $01
    dw SoundEffectStream_1A_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_1B: ; $445D
    db $08, $01
    dw SoundEffectStream_1B_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_1C: ; $4461
    db $08, $01
    dw SoundEffectStream_1C_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_1D: ; $4465
    db $08, $09
    dw SoundEffectStream_1D_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_1D_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_1E: ; $446B
    db $08, $08
    dw SoundEffectStream_1E_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_1F: ; $446F
    db $08, $09
    dw SoundEffectStream_1F_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_1F_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_20: ; $4475
    db $08, $09
    dw SoundEffectStream_20_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_20_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_21: ; $447B
    db $08, $09
    dw SoundEffectStream_21_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_21_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_22: ; $4481
    db $08, $09
    dw SoundEffectStream_22_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_22_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_23: ; $4487
    db $08, $01
    dw SoundEffectStream_23_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_24: ; $448B
    db $08, $09
    dw SoundEffectStream_24_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_24_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_25: ; $4491
    db $08, $08
    dw SoundEffectStream_25_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_26: ; $4495
    db $08, $09
    dw SoundEffectStream_26_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_26_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_27: ; $449B
    db $08, $09
    dw SoundEffectStream_27_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_27_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_28: ; $44A1
    db $08, $08
    dw SoundEffectStream_28_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_29: ; $44A5
    db $08, $09
    dw SoundEffectStream_29_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_29_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_2A: ; $44AB
    db $08, $09
    dw SoundEffectStream_2A_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_2A_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_2B: ; $44B1
    db $08, $09
    dw SoundEffectStream_2B_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_2B_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_2C: ; $44B7
    db $08, $09
    dw SoundEffectStream_2C_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_2C_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_2D: ; $44BD
    db $08, $09
    dw SoundEffectStream_2D_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_2D_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_2E: ; $44C3
    db $08, $08
    dw SoundEffectStream_2E_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_2F: ; $44C7
    db $08, $01
    dw SoundEffectStream_2F_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_30: ; $44CB
    db $08, $01
    dw SoundEffectStream_30_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_31: ; $44CF
    db $08, $01
    dw SoundEffectStream_31_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_32: ; $44D3
    db $08, $01
    dw SoundEffectStream_32_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_33: ; $44D7
    db $08, $01
    dw SoundEffectStream_33_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_34: ; $44DB
    db $08, $01
    dw SoundEffectStream_34_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_35: ; $44DF
    db $08, $01
    dw SoundEffectStream_35_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_36: ; $44E3
    db $08, $01
    dw SoundEffectStream_36_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_37: ; $44E7
    db $08, $01
    dw SoundEffectStream_37_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_38: ; $44EB
    db $08, $09
    dw SoundEffectStream_38_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_38_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_39: ; $44F1
    db $08, $08
    dw SoundEffectStream_39_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_3A: ; $44F5
    db $08, $08
    dw SoundEffectStream_3A_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_3B: ; $44F9
    db $08, $08
    dw SoundEffectStream_3B_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_3C: ; $44FD
    db $08, $08
    dw SoundEffectStream_3C_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_3D: ; $4501
    db $08, $08
    dw SoundEffectStream_3D_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_3E: ; $4505
    db $08, $01
    dw SoundEffectStream_3E_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_3F: ; $4509
    db $08, $09
    dw SoundEffectStream_3F_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_3F_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_40: ; $450F
    db $08, $08
    dw SoundEffectStream_40_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_41: ; $4513
    db $08, $01
    dw SoundEffectStream_41_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_42: ; $4517
    db $08, $09
    dw SoundEffectStream_42_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_42_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_43: ; $451D
    db $08, $08
    dw SoundEffectStream_43_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_44: ; $4521
    db $08, $08
    dw SoundEffectStream_44_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_45: ; $4525
    db $08, $01
    dw SoundEffectStream_45_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_46: ; $4529
    db $09, $08
    dw SoundEffectStream_46_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_47: ; $452D
    db $09, $08
    dw SoundEffectStream_47_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_48: ; $4531
    db $09, $08
    dw SoundEffectStream_48_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_49: ; $4535
    db $09, $01
    dw SoundEffectStream_49_Ch1 ; channel 1 stream, bank $09

SoundEffectDef_4A: ; $4539
    db $09, $09
    dw SoundEffectStream_4A_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_4A_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_4B: ; $453F
    db $09, $08
    dw SoundEffectStream_4B_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_4C: ; $4543
    db $09, $08
    dw SoundEffectStream_4C_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_4D: ; $4547
    db $09, $01
    dw SoundEffectStream_4D_Ch1 ; channel 1 stream, bank $09

SoundEffectDef_4E: ; $454B
    db $09, $09
    dw SoundEffectStream_4E_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_4E_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_4F: ; $4551
    db $09, $01
    dw SoundEffectStream_4F_Ch1 ; channel 1 stream, bank $09

SoundEffectDef_50: ; $4555
    db $09, $08
    dw SoundEffectStream_50_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_51: ; $4559
    db $09, $01
    dw SoundEffectStream_51_Ch1 ; channel 1 stream, bank $09

SoundEffectDef_52: ; $455D
    db $09, $09
    dw SoundEffectStream_52_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_52_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_53: ; $4563
    db $09, $08
    dw SoundEffectStream_53_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_54: ; $4567
    db $09, $08
    dw SoundEffectStream_54_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_55: ; $456B
    db $09, $08
    dw SoundEffectStream_55_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_56: ; $456F
    db $09, $01
    dw SoundEffectStream_56_Ch1 ; channel 1 stream, bank $09

SoundEffectDef_57: ; $4573
    db $09, $09
    dw SoundEffectStream_57_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_57_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_58: ; $4579
    db $09, $08
    dw SoundEffectStream_58_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_59: ; $457D
    db $09, $08
    dw SoundEffectStream_59_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_5A: ; $4581
    db $09, $01
    dw SoundEffectStream_5A_Ch1 ; channel 1 stream, bank $09

SoundEffectDef_5B: ; $4585
    db $09, $03
    dw SoundEffectStream_5B_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_5B_Ch2 ; channel 2 stream, bank $09

SoundEffectDef_5C: ; $458B
    db $09, $09
    dw SoundEffectStream_5C_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_5C_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_5D: ; $4591
    db $09, $08
    dw SoundEffectStream_5D_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_5E: ; $4595
    db $09, $09
    dw SoundEffectStream_5E_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_5E_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_5F: ; $459B
    db $09, $08
    dw SoundEffectStream_5F_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_60: ; $459F
    db $09, $09
    dw SoundEffectStream_60_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_60_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_61: ; $45A5
    db $09, $09
    dw SoundEffectStream_61_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_61_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_62: ; $45AB
    db $09, $03
    dw SoundEffectStream_62_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_62_Ch2 ; channel 2 stream, bank $09

SoundEffectDef_63: ; $45B1
    db $09, $01
    dw SoundEffectStream_63_Ch1 ; channel 1 stream, bank $09

SoundEffectDef_64: ; $45B5
    db $09, $09
    dw SoundEffectStream_64_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_64_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_65: ; $45BB
    db $09, $09
    dw SoundEffectStream_65_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_65_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_66: ; $45C1
    db $09, $08
    dw SoundEffectStream_66_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_67: ; $45C5
    db $09, $08
    dw SoundEffectStream_67_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_68: ; $45C9
    db $08, $08
    dw SoundEffectStream_1E_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_69: ; $45CD
    db $08, $09
    dw SoundEffectStream_1F_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_1F_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_6A: ; $45D3
    db $08, $09
    dw SoundEffectStream_20_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_20_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_6B: ; $45D9
    db $08, $09
    dw SoundEffectStream_21_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_21_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_6C: ; $45DF
    db $08, $09
    dw SoundEffectStream_22_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_22_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_6D: ; $45E5
    db $08, $01
    dw SoundEffectStream_23_Ch1 ; channel 1 stream, bank $08

SoundEffectDef_6E: ; $45E9
    db $08, $09
    dw SoundEffectStream_24_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_24_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_6F: ; $45EF
    db $08, $08
    dw SoundEffectStream_25_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_70: ; $45F3
    db $08, $09
    dw SoundEffectStream_26_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_26_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_71: ; $45F9
    db $08, $09
    dw SoundEffectStream_27_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_27_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_72: ; $45FF
    db $08, $08
    dw SoundEffectStream_28_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_73: ; $4603
    db $08, $09
    dw SoundEffectStream_29_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_29_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_74: ; $4609
    db $08, $09
    dw SoundEffectStream_2A_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_2A_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_75: ; $460F
    db $08, $09
    dw SoundEffectStream_2B_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_2B_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_76: ; $4615
    db $08, $09
    dw SoundEffectStream_2C_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_2C_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_77: ; $461B
    db $08, $09
    dw SoundEffectStream_2D_Ch1 ; channel 1 stream, bank $08
    dw SoundEffectStream_2D_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_78: ; $4621
    db $08, $08
    dw SoundEffectStream_2E_Ch4 ; channel 4 stream, bank $08

SoundEffectDef_79: ; $4625
    db $09, $08
    dw SoundEffectStream_79_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_7A: ; $4629
    db $09, $09
    dw SoundEffectStream_7A_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_7A_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_7B: ; $462F
    db $09, $09
    dw SoundEffectStream_7B_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_7B_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_7C: ; $4635
    db $09, $08
    dw SoundEffectStream_7C_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_7D: ; $4639
    db $09, $01
    dw SoundEffectStream_7D_Ch1 ; channel 1 stream, bank $09

SoundEffectDef_7E: ; $463D
    db $09, $01
    dw SoundEffectStream_7E_Ch1 ; channel 1 stream, bank $09

SoundEffectDef_7F: ; $4641
    db $09, $08
    dw SoundEffectStream_7F_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_80: ; $4645
    db $09, $08
    dw SoundEffectStream_80_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_81: ; $4649
    db $09, $09
    dw SoundEffectStream_81_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_81_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_82: ; $464F
    db $09, $09
    dw SoundEffectStream_82_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_82_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_83: ; $4655
    db $09, $08
    dw SoundEffectStream_83_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_84: ; $4659
    db $09, $09
    dw SoundEffectStream_84_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_84_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_85: ; $465F
    db $09, $09
    dw SoundEffectStream_85_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_85_Ch4 ; channel 4 stream, bank $09

SoundEffectDef_86: ; $4665
    db $09, $09
    dw SoundEffectStream_86_Ch1 ; channel 1 stream, bank $09
    dw SoundEffectStream_86_Ch4 ; channel 4 stream, bank $09

section "Sound Effect Wave Patterns [Bank09 Copy]", romx[$466b], bank[$09]

SoundDriverWavePointerTable:
    dw SoundWavePattern_00, SoundWavePattern_01, SoundWavePattern_02, SoundWavePattern_03, SoundWavePattern_04
    dw SoundWavePattern_05, SoundWavePattern_06, SoundWavePattern_07, SoundWavePattern_08, SoundWavePattern_09
    dw SoundWavePattern_10, SoundWavePattern_11, SoundWavePattern_12, SoundWavePattern_13, SoundWavePattern_14
    dw SoundWavePattern_15, SoundWavePattern_16, SoundWavePattern_17, SoundWavePattern_18, SoundWavePattern_19

SoundWavePattern_00: ; $4693
    db $79, $bd, $ff, $ff, $ff, $ff, $fd, $b9, $75, $31, $00, $00, $00, $00, $01, $35

SoundWavePattern_01: ; $46A3
    db $46, $8a, $cc, $cc, $cc, $cc, $ca, $86, $42, $11, $00, $00, $00, $00, $01, $12

SoundWavePattern_02: ; $46B3
    db $7a, $df, $ff, $da, $74, $10, $00, $14, $7a, $df, $ff, $da, $74, $10, $00, $14

SoundWavePattern_03: ; $46C3
    db $01, $12, $23, $34, $45, $56, $67, $77, $88, $99, $aa, $bb, $cc, $dd, $ee, $ff

SoundWavePattern_04: ; $46D3
    db $12, $23, $33, $44, $55, $66, $77, $77, $78, $89, $9a, $ab, $bb, $cc, $dd, $ee

SoundWavePattern_05: ; $46E3
    db $00, $12, $22, $33, $44, $55, $66, $66, $67, $78, $89, $9a, $aa, $bb, $cc, $dd

SoundWavePattern_06: ; $46F3
    db $00, $12, $12, $22, $33, $44, $55, $55, $57, $68, $79, $8a, $99, $aa, $bb, $cc

SoundWavePattern_07: ; $4703
    db $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $00, $00, $00, $00, $00, $00, $00, $00

SoundWavePattern_08: ; $4713
    db $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $00, $00, $00, $00, $00, $00, $00, $00

SoundWavePattern_09: ; $4723
    db $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $00, $00, $00, $00, $00, $00, $00, $00

SoundWavePattern_10: ; $4733
    db $ee, $ee, $ee, $ee, $ee, $ee, $ed, $cb, $21, $00, $00, $00, $00, $00, $00, $00

SoundWavePattern_11: ; $4743
    db $cc, $cc, $cc, $cc, $bc, $cc, $bc, $cc, $c0, $00, $00, $00, $00, $00, $00, $0b

SoundWavePattern_12: ; $4753
    db $99, $99, $99, $99, $99, $99, $99, $99, $00, $00, $00, $00, $00, $00, $00, $00

SoundWavePattern_13: ; $4763
    db $00, $ff, $00, $ff, $66, $aa, $66, $aa, $66, $aa, $66, $aa, $00, $ff, $00, $ff

SoundWavePattern_14: ; $4773
    db $77, $dd, $77, $dd, $00, $00, $00, $00, $00, $00, $00, $00, $dd, $77, $dd, $77

SoundWavePattern_15: ; $4783
    db $78, $78, $78, $78, $78, $78, $78, $78, $00, $00, $00, $00, $00, $00, $00, $00

SoundWavePattern_16: ; $4793
    db $00, $05, $16, $2f, $4c, $69, $82, $93, $99, $93, $82, $69, $4c, $2f, $16, $05

SoundWavePattern_17: ; $47A3
    db $68, $68, $68, $68, $68, $68, $68, $68, $00, $00, $00, $00, $00, $00, $00, $00

SoundWavePattern_18: ; $47B3
    db $66, $cc, $66, $cc, $00, $00, $00, $00, $00, $00, $00, $00, $cc, $66, $cc, $66

SoundWavePattern_19: ; $47C3
    db $48, $48, $48, $48, $48, $48, $48, $48, $00, $00, $00, $00, $00, $00, $00, $00


    assert @ == $47d3
