include "macros/macros.inc"

; Bank $04 is the runtime music-engine bank selected by Audio_Init/Audio_Update.
; Retail banks $03-$07 contain the same engine bytes from $4000 through $580e;
; their bank-specific music data begins at $580f. sources the public
; frontend/init/update layer in bank $04 first, while leaving the identical
; copies in the other banks untouched until the shared engine is fully mapped.


; Per-channel note output state. $D9 primes the next event for a tied/legato
; frequency update: no envelope rewrite, hardware retrigger, or modulation reset.
DEF MUSIC_NOTE_STATE_IDLE      EQU $00
DEF MUSIC_NOTE_STATE_RETRIGGER EQU $01
DEF MUSIC_NOTE_STATE_ACTIVE    EQU $02
DEF MUSIC_NOTE_STATE_TIE       EQU $80

; Bit 7 marks the current track request as acknowledged/no pending load.
DEF MUSIC_TRACK_REQUEST_ACKNOWLEDGED EQU $80

section "Music Driver Duplicate Bank 07", romx[$4000], bank[$07]

AudioDriver_Init:
    jp MusicDriver_Init_Impl


AudioDriver_Update:
    jp MusicDriver_Update_Impl


; a = track ID ($00-$2C); invalid IDs are ignored.
MusicDriver_RequestTrack:
    jp MusicDriver_RequestTrack_Impl


; a = SFX ID; queues it only when its priority can replace the current request.
MusicDriver_RequestSFX:
    jp MusicDriver_RequestSFX_Impl


; a = low-nibble hardware-channel mute mask applied to NR51.
MusicDriver_SetRoutingMuteMask:
    jp MusicDriver_SetRoutingMuteMask_Impl


; Returns a = 1 while a music track is active/pending, otherwise 0.
MusicDriver_IsTrackActive:
    jp MusicDriver_IsTrackActive_Impl


; Returns a = 1 while an SFX is queued or active, otherwise 0.
MusicDriver_IsSFXActive:
    jp MusicDriver_IsSFXActive_Impl


; Toggles the music pause flag. Paused updates silence unprotected channels.
MusicDriver_TogglePause:
    jp MusicDriver_TogglePause_Impl


; a = volume 0-7; mirrors the value to both NR50 output-volume nibbles.
MusicDriver_SetMasterVolume:
    jp MusicDriver_SetMasterVolume_Impl


MusicDriver_SaveStateAndStopEntry:
MusicDriver_Entry09: ; compatibility alias
    jp MusicDriver_SaveStateAndStop


MusicDriver_RestoreStateAndResumeEntry:
MusicDriver_Entry0A: ; compatibility alias
    jp MusicDriver_RestoreStateAndResume


MusicDriver_RequestTrack_Impl:
    call MusicDriver_SelectWRAMBank7
    push hl
    ld hl, MusicDriver_TrackCount
    cp [hl]
    jr nc, .set_track_done

    ld [wMusicTrackRequest], a

.set_track_done:
    pop hl
    call MusicDriver_RestoreWRAMBank
    ret


MusicDriver_RequestSFX_Impl:
    call MusicDriver_SelectWRAMBank7
    push bc
    push hl
    ld b, $00
    ld c, a
    or a
    jr z, .accept_sfx_request

    ld hl, MusicDriver_SFXPriorityTable
    add hl, bc
    ld b, [hl]
    ld a, [wSFXRequestPriority]
    or a
    jr z, .accept_sfx_request

    cp b
    jr c, .finish_sfx_request

.accept_sfx_request:
    ld a, b
    ld [wSFXRequestPriority], a
    ld a, c
    ld [wSFXRequestID], a
    ld a, AUDIO_SFX_REQUEST_QUEUED
    ld [wSFXRequestState], a

.finish_sfx_request:
    pop hl
    pop bc
    call MusicDriver_RestoreWRAMBank
    ret


MusicDriver_SetRoutingMuteMask_Impl:
    call MusicDriver_SelectWRAMBank7
    ld [wMusicRoutingMuteMask], a
    call MusicDriver_RestoreWRAMBank
    ret


MusicDriver_IsTrackActive_Impl:
    call MusicDriver_SelectWRAMBank7
    ld a, [wMusicTrackRequest]
    cp MUSIC_TRACK_REQUEST_ACKNOWLEDGED
    ld a, $01
    jr nz, .track_active_result

    xor a

.track_active_result:
    call MusicDriver_RestoreWRAMBank
    ret


MusicDriver_IsSFXActive_Impl:
    call MusicDriver_SelectWRAMBank7
    ld a, [wSFXRequestState]
    or a
    ld a, $01
    jr nz, .sfx_active_result

    xor a

.sfx_active_result:
    call MusicDriver_RestoreWRAMBank
    ret


MusicDriver_TogglePause_Impl:
    call MusicDriver_SelectWRAMBank7
    ld a, [wMusicPaused]
    xor $01
    ld [wMusicPaused], a
    call MusicDriver_RestoreWRAMBank
    ret


MusicDriver_SetMasterVolume_Impl:
    call MusicDriver_SelectWRAMBank7
    push bc
    push af
    and $07
    ld b, a
    swap b
    or b
    ld [wMusicMasterVolume], a
    pop af
    pop bc
    call MusicDriver_RestoreWRAMBank
    ret


MusicDriver_Init_Impl:
    call MusicDriver_SelectWRAMBank7
    xor a
    ldh [rNR52], a
    ld a, $80
    ldh [rNR52], a
    ld a, $77
    ldh [rNR50], a
    ld a, $ff
    ldh [rNR51], a
    ld a, $03
    ld [wMusicDataBank], a
    ld a, $08
    ld [wSFXDataBank], a
    ld a, MUSIC_TRACK_REQUEST_ACKNOWLEDGED
    ld [wMusicTrackRequest], a
    swap a
    ld [wMusicPulse1Sweep], a
    ld a, $77
    ld [wMusicMasterVolume], a
    xor a
    ld [wSFXChannelMask], a
    ld [wSFXActive], a
    ld [wWavePatternReloadPending], a
    ld [wMusicNoiseSequenceActive], a
    ld [wMusicRoutingMuteMask], a
    ld [wMusicPaused], a
    ld [wSFXRequestID], a
    ld [wSFXRequestState], a
    ld [wMusicSnapshotRequest], a
    dec a
    ld [wMusicRoutingShadow], a
    ld de, $0001
    ld bc, $0000

.clear_channel_state_loop:
    ld hl, wMusicChannelActive
    add hl, bc
    ld [hl], d
    ld hl, wMusicChannelNoteState
    add hl, bc
    ld [hl], d
    ld hl, $c138
    add hl, bc
    ld [hl], d
    ld hl, wMusicChannelPitchTranspose
    add hl, bc
    ld [hl], d
    ld hl, wMusicChannelGateLength
    add hl, bc
    ld [hl], d
    ld hl, wMusicChannelFrequencyTableIndex
    add hl, bc
    ld [hl], d
    ld hl, $c170
    add hl, bc
    ld [hl], d
    inc c
    ld a, c
    cp $04
    jr nz, .clear_channel_state_loop

    ld hl, MusicDriver_LoopStateInitialPointers
    ld bc, wMusicChannelLoopStatePointers
    ld d, $08

.copy_default_state_loop:
    ld a, [hl+]
    ld [bc], a
    inc bc
    dec d
    jr nz, .copy_default_state_loop

    call MusicDriver_RestoreWRAMBank
    ret


MusicDriver_Update_Impl:
    call MusicDriver_SelectWRAMBank7ForUpdate
    call MusicDriver_UpdateHook
    call MusicDriver_ProcessPendingRequests
    ld hl, SoundDriver_Update
    call Audio_CallSoundDriver
    ld a, [wMusicDataBank]
    ldh [hROMBank], a
    ld [rROMB0], a
    ld a, [wMusicPaused]
    cp $00
    jr z, .update_channels

    call MusicDriver_SilenceUnprotectedChannels
    jr .update_common

.update_channels:
    call MusicDriver_UpdatePulse1Channel
    call MusicDriver_UpdatePulse2Channel
    call MusicDriver_UpdateWaveChannel
    call MusicDriver_UpdateNoiseChannel

.update_common:
    call MusicDriver_UpdateMixer
    call MusicDriver_CheckAllChannelsStopped
    ld a, [wMusicSnapshotRequest]
    or a
    jr z, .update_finish

    call MusicDriver_SaveState
    xor a
    ld [wMusicSnapshotRequest], a

.update_finish:
    call MusicDriver_RestoreWRAMBankForUpdate
    ret


MusicDriver_ProcessPendingRequests:
    ld a, [wMusicTrackRequest]
    rla
    jr c, .check_pending_sfx

    call MusicDriver_StopInactiveChannels
    ld a, [wMusicTrackRequest]
    call MusicDriver_LoadTrack
    ld a, [wMusicTrackRequest]
    or MUSIC_TRACK_REQUEST_ACKNOWLEDGED
    ld [wMusicTrackRequest], a

.check_pending_sfx:
    ld a, [wSFXRequestState]
    bit AUDIO_SFX_REQUEST_QUEUED_BIT, a
    jr z, .done

    ld a, [wSFXRequestID]
    ld hl, SoundDriver_PlaySFX
    call Audio_CallSoundDriver
    ld a, AUDIO_SFX_REQUEST_ACTIVE
    ld [wSFXRequestState], a

.done:
    ret


MusicDriver_StopInactiveChannels:
    ld a, [wSFXChannelMask]
    ld d, a
    xor a
    ld [wMusicChannelActive], a
    bit 0, d
    jr nz, .channel2

    ld a, $08
    ldh [rNR12], a
    swap a
    ldh [rNR14], a

.channel2:
    xor a
    ld [wMusicChannelActive + 1], a
    bit 1, d
    jr nz, .channel4

    ld a, $08
    ldh [rNR22], a
    swap a
    ldh [rNR24], a

.channel4:
    xor a
    ld [wMusicChannelActive + 3], a
    bit 3, d
    jr nz, .channel3

    ld a, $08
    ldh [rNR42], a
    swap a
    ldh [rNR44], a

.channel3:
    xor a
    ld [wMusicChannelActive + 2], a
    bit 2, d
    jr nz, .done

    ld a, $00
    ldh [rNR32], a

.done:
    ret


MusicDriver_LoadTrack:
    push af
    ld c, a
    ld b, $00
    ld hl, MusicDriver_TrackBankTable
    add hl, bc
    ld a, [hl]
    ld [wMusicDataBank], a
    ldh [hROMBank], a
    ld [rROMB0], a
    pop af
    add a
    ld c, a
    ld b, $00
    ld hl, MusicDriver_TrackHeaderPointers
    add hl, bc
    ld e, [hl]
    inc hl
    ld h, [hl]
    ld l, e
    ld e, [hl]
    inc hl
    ld b, h
    ld c, l
    rr e
    jr nc, .channel2

    ld a, [bc]
    inc bc
    ld [wMusicChannelStreamPointers], a
    ld [wMusicChannelSavedStreamPointers], a
    ld a, [bc]
    inc bc
    ld [wMusicChannelStreamPointers + 1], a
    ld [wMusicChannelSavedStreamPointers + 1], a
    ld a, $01
    ld [wMusicChannelDuration], a
    ld [wMusicChannelActive], a
    xor a
    ld [wMusicChannelNoteState], a
    ld [wMusicChannelFrequencyOffset], a
    ld [wMusicChannelGateLength], a
    ld [wMusicChannelModulationPeriod], a
    ld [wMusicChannelPitchTranspose], a
    ld [wMusicChannelFrequencyTableIndex], a
    ld [$c170], a
    ld [wMusicToneAlternateOutputEnabled], a
    ld a, [MusicDriver_LoopStateInitialPointers]
    ld [wMusicChannelLoopStatePointers], a
    ld a, [MusicDriver_LoopStateInitialPointers + 1]
    ld [wMusicChannelLoopStatePointers + 1], a
    ld a, $08
    ld [wMusicChannelOutputLevel], a
    ld [wMusicPulse1Sweep], a

.channel2:
    rr e
    jr nc, .channel3

    ld a, [bc]
    inc bc
    ld [wMusicChannelStreamPointers + 2], a
    ld [wMusicChannelSavedStreamPointers + 2], a
    ld a, [bc]
    inc bc
    ld [wMusicChannelStreamPointers + 3], a
    ld [wMusicChannelSavedStreamPointers + 3], a
    ld a, $01
    ld [wMusicChannelDuration + 1], a
    ld [wMusicChannelActive + 1], a
    xor a
    ld [wMusicChannelNoteState + 1], a
    ld [wMusicChannelFrequencyOffset + 1], a
    ld [wMusicChannelGateLength + 1], a
    ld [wMusicChannelModulationPeriod + 1], a
    ld [wMusicChannelPitchTranspose + 1], a
    ld [wMusicChannelFrequencyTableIndex + 1], a
    ld [$c171], a
    ld [wMusicToneAlternateOutputEnabled + 1], a
    ld a, [MusicDriver_LoopStateInitialPointers + 2]
    ld [wMusicChannelLoopStatePointers + 2], a
    ld a, [MusicDriver_LoopStateInitialPointers + 3]
    ld [wMusicChannelLoopStatePointers + 3], a
    ld a, $08
    ld [wMusicChannelOutputLevel + 1], a

.channel3:
    rr e
    jr nc, .channel4

    ld a, [bc]
    inc bc
    ld [wMusicChannelStreamPointers + 4], a
    ld [wMusicChannelSavedStreamPointers + 4], a
    ld a, [bc]
    inc bc
    ld [wMusicChannelStreamPointers + 5], a
    ld [wMusicChannelSavedStreamPointers + 5], a
    ld a, $01
    ld [wMusicChannelDuration + 2], a
    ld [wMusicChannelActive + 2], a
    xor a
    ld [wMusicChannelNoteState + 2], a
    ld [wMusicChannelFrequencyOffset + 2], a
    ld [wMusicChannelGateLength + 2], a
    ld [wMusicChannelModulationPeriod + 2], a
    ld [wMusicChannelPitchTranspose + 2], a
    ld [wMusicChannelFrequencyTableIndex + 2], a
    ld [$c172], a
    ld [wMusicToneAlternateOutputEnabled + 2], a
    ld a, [MusicDriver_LoopStateInitialPointers + 4]
    ld [wMusicChannelLoopStatePointers + 4], a
    ld a, [MusicDriver_LoopStateInitialPointers + 5]
    ld [wMusicChannelLoopStatePointers + 5], a
    ld a, $40
    ld [wMusicChannelOutputLevel + 2], a

.channel4:
    rr e
    jr nc, .finish

    ld a, [bc]
    inc bc
    ld [wMusicChannelStreamPointers + 6], a
    ld [wMusicChannelSavedStreamPointers + 6], a
    ld a, [bc]
    inc bc
    ld [wMusicChannelStreamPointers + 7], a
    ld [wMusicChannelSavedStreamPointers + 7], a
    ld a, $01
    ld [wMusicChannelDuration + 3], a
    ld [wMusicChannelActive + 3], a
    xor a
    ld [wMusicChannelNoteState + 3], a
    ld [wMusicChannelGateLength + 3], a
    ld [wMusicChannelModulationPeriod + 3], a
    ld [wMusicChannelPitchTranspose + 3], a
    ld [wMusicChannelFrequencyTableIndex + 3], a
    ld [$c173], a
    ld [wMusicNoiseClockShiftOffset], a
    ld a, [MusicDriver_LoopStateInitialPointers + 6]
    ld [wMusicChannelLoopStatePointers + 6], a
    ld a, [MusicDriver_LoopStateInitialPointers + 7]
    ld [wMusicChannelLoopStatePointers + 7], a
    ld a, $40
    ld [wMusicChannelOutputLevel + 3], a

.finish:
    xor a
    ld [wMusicSnapshotRequest], a
    ld [wMusicPaused], a
    ret


; Shared per-frame music-channel update frontends. These bytes are identical in
; retail banks $03-$07; bank $04 remains the canonical runtime copy for now.

MusicDriver_UpdateHook:
    ret


MusicDriver_UpdatePulse1Channel:
    ld a, [wMusicChannelActive]
    or a
    jp z, .inactive

    ld a, [wMusicChannelNoteCode]
    cp $00
    jr z, .tick_sequence

    ld a, [wMusicChannelGateCounter]
    dec a
    ld [wMusicChannelGateCounter], a
    jr nz, .tick_envelope

    ld a, [wMusicChannelDuration]
    cp $01
    jr z, .tick_envelope

    ld a, [wSFXChannelMask]
    bit 0, a
    jr nz, .tick_envelope

    xor a
    ld [wMusicPulseEnvelopeCounter], a
    ld hl, wMusicChannelOutputLevel
    jr .write_envelope

.tick_envelope:
    ld a, [wMusicPulseEnvelopeCounter]
    cp $00
    jr z, .tick_sequence

    dec a
    ld [wMusicPulseEnvelopeCounter], a
    jr nz, .tick_sequence

    ld a, [wSFXChannelMask]
    bit 0, a
    jr nz, .tick_sequence

    ld hl, wMusicPulsePrimaryEnvelope
    ld a, [wMusicToneAlternateOutputEnabled]
    cp $00
    jr z, .write_envelope

    ld a, [wMusicToneAlternateOutputPhase]
    cp $00
    jr nz, .write_envelope

    ld hl, wMusicPulseAlternateEnvelope

.write_envelope:
    ld a, [hl]
    ld hl, rNR12
    ld [hl+], a
    inc hl
    ld a, [wMusicToneFrequency + 1]
    or $80
    ld [hl], a

.tick_sequence:
    ld a, [wMusicChannelDuration]
    dec a
    ld [wMusicChannelDuration], a
    jr nz, .finish

    ld a, [wMusicChannelStreamPointers + 1]
    ld h, a
    ld a, [wMusicChannelStreamPointers]
    ld l, a
    ld bc, $0000
    call MusicDriver_ProcessCommand
    ld a, [wMusicChannelActive]
    or a
    jr z, .inactive

    call MusicDriver_CommitPulse1

.finish:
    ld a, $00
    call MusicDriver_ApplyFrequencyEffects
    ret

.inactive:
    ld a, [wSFXChannelMask]
    bit 0, a
    jr nz, .clear_duty

    ld a, $08
    ldh [rNR12], a
    swap a
    ldh [rNR14], a

.clear_duty:
    ldh a, [rNR11]
    and $c0
    ldh [rNR11], a
    ret


MusicDriver_UpdatePulse2Channel:
    ld a, [wMusicChannelActive + 1]
    or a
    jp z, .inactive

    ld a, [wMusicChannelNoteCode + 1]
    cp $00
    jr z, .tick_sequence

    ld a, [wMusicChannelGateCounter + 1]
    dec a
    ld [wMusicChannelGateCounter + 1], a
    jr nz, .tick_envelope

    ld a, [wMusicChannelDuration + 1]
    cp $01
    jr z, .tick_envelope

    ld a, [wSFXChannelMask]
    bit 1, a
    jr nz, .tick_envelope

    xor a
    ld [wMusicPulseEnvelopeCounter + 1], a
    ld hl, wMusicChannelOutputLevel + 1
    jr .write_envelope

.tick_envelope:
    ld a, [wMusicPulseEnvelopeCounter + 1]
    cp $00
    jr z, .tick_sequence

    dec a
    ld [wMusicPulseEnvelopeCounter + 1], a
    jr nz, .tick_sequence

    ld a, [wSFXChannelMask]
    bit 1, a
    jr nz, .tick_sequence

    ld hl, wMusicPulsePrimaryEnvelope + 1
    ld a, [wMusicToneAlternateOutputEnabled + 1]
    cp $00
    jr z, .write_envelope

    ld a, [wMusicToneAlternateOutputPhase + 1]
    cp $00
    jr nz, .write_envelope

    ld hl, wMusicPulseAlternateEnvelope + 1

.write_envelope:
    ld a, [hl]
    ld hl, rNR22
    ld [hl+], a
    inc hl
    ld a, [wMusicToneFrequency + 3]
    or $80
    ld [hl], a

.tick_sequence:
    ld a, [wMusicChannelDuration + 1]
    dec a
    ld [wMusicChannelDuration + 1], a
    jr nz, .finish

    ld a, [wMusicChannelStreamPointers + 3]
    ld h, a
    ld a, [wMusicChannelStreamPointers + 2]
    ld l, a
    ld bc, $0001
    call MusicDriver_ProcessCommand
    ld a, [wMusicChannelActive + 1]
    or a
    jr z, .inactive

    call MusicDriver_CommitPulse2

.finish:
    ld a, $01
    call MusicDriver_ApplyFrequencyEffects
    ret

.inactive:
    ld a, [wSFXChannelMask]
    bit 1, a
    jr nz, .done

    ld a, $08
    ldh [rNR22], a
    swap a
    ldh [rNR24], a

.done:
    ret


MusicDriver_UpdateWaveChannel:
    ld a, [wMusicChannelActive + 2]
    or a
    jr z, .inactive

    ld a, [wMusicChannelNoteCode + 2]
    cp $00
    jr z, .tick_sequence

    ld a, [wMusicChannelGateCounter + 2]
    dec a
    ld [wMusicChannelGateCounter + 2], a
    jr nz, .tick_sequence

    ld a, [wSFXChannelMask]
    bit 2, a
    jr nz, .tick_sequence

    ld a, [wMusicChannelDuration + 2]
    cp $01
    jr z, .tick_sequence

    ld a, [wMusicChannelOutputLevel + 2]
    ldh [rNR32], a

.tick_sequence:
    ld a, [wMusicChannelDuration + 2]
    dec a
    ld [wMusicChannelDuration + 2], a
    jr nz, .finish

    ld a, [wMusicChannelStreamPointers + 5]
    ld h, a
    ld a, [wMusicChannelStreamPointers + 4]
    ld l, a
    ld bc, $0002
    call MusicDriver_ProcessCommand
    ld a, [wMusicChannelActive + 2]
    or a
    jr z, .inactive

    call MusicDriver_CommitWave

.finish:
    ld a, $02
    call MusicDriver_ApplyFrequencyEffects
    ret

.inactive:
    ld a, [wSFXChannelMask]
    bit 2, a
    jr nz, .done

    ld a, $00
    ldh [rNR32], a
    ld a, $80
    ldh [rNR34], a

.done:
    ret


MusicDriver_UpdateNoiseChannel:
    ld a, [wMusicChannelActive + 3]
    or a
    jr z, .inactive

    ld a, [wMusicChannelDuration + 3]
    dec a
    ld [wMusicChannelDuration + 3], a
    jr nz, .tick_noise

    ld a, [wMusicChannelStreamPointers + 7]
    ld h, a
    ld a, [wMusicChannelStreamPointers + 6]
    ld l, a
    ld bc, $0003
    call MusicDriver_ProcessCommand
    ld a, [wMusicChannelActive + 3]
    or a
    jr z, .inactive

    call MusicDriver_CommitNoise
    jr .done

.tick_noise:
    ld a, [wMusicNoiseSequenceActive]
    or a
    jr z, .done

    call MusicDriver_StepNoise
    ret

.inactive:
    ld a, [wSFXChannelMask]
    bit 3, a
    jr nz, .done

    xor a
    ld [wMusicNoiseSequenceActive], a
    ld a, $08
    ldh [rNR42], a
    swap a
    ldh [rNR44], a

.done:
    ret

; Shared music command interpreter. Command bytes $d0-$ff dispatch through a
; 48-entry pointer table; bytes below $d0 are note/rest data handled inline.
; This runtime code is byte-identical in retail banks $03-$07.

MusicDriver_ProcessCommand:
    ld a, [hl+]
    push hl
    push af
    cp $d0
    jr c, .process_note_event
    sub $d0
    add a
    ld e, a
    ld d, $00
    ld hl, .command_table
    add hl, de
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld h, d
    ld l, e
    pop af
    jp hl
.command_table:
    dw .cmd_set_duration_multiplier ; $d0
    dw .cmd_set_octave ; $d1
    dw .cmd_set_octave ; $d2
    dw .cmd_set_octave ; $d3
    dw .cmd_set_octave ; $d4
    dw .cmd_set_octave ; $d5
    dw .cmd_set_octave ; $d6
    dw .cmd_octave_up ; $d7
    dw .cmd_octave_down ; $d8
    dw .cmd_tie_note ; $d9
    dw .cmd_end_channel ; $da
    dw .cmd_end_channel ; $db
    dw .cmd_set_channel_routing ; $dc
    dw .cmd_save_stream_position ; $dd
    dw .cmd_restore_stream_position ; $de
    dw .cmd_begin_counted_loop ; $df
    dw .cmd_repeat_counted_loop ; $e0
    dw .cmd_jump_stream ; $e1
    dw .cmd_call_stream ; $e2
    dw .cmd_return_stream ; $e3
    dw .cmd_set_frequency_offset ; $e4
    dw .cmd_set_duty ; $e5
    dw .cmd_set_primary_output_level ; $e6
    dw .cmd_set_wave_pattern ; $e7
    dw .cmd_set_gate_length ; $e8
    dw .cmd_set_output_level ; $e9
    dw .cmd_set_modulation_selector ; $ea
    dw .cmd_set_modulation_period ; $eb
    dw .cmd_set_pitch_transpose ; $ec
    dw .cmd_add_pitch_transpose ; $ed
    dw .cmd_ee ; $ee
    dw .cmd_ef ; $ef
    dw .cmd_apply_channel_preset ; $f0
    dw .cmd_set_alternate_output_level ; $f1
    dw .cmd_enable_alternate_output ; $f2
    dw .cmd_disable_alternate_output ; $f3
    dw .cmd_request_snapshot ; $f4
    dw .cmd_set_primary_envelope_state ; $f5
    dw .cmd_set_alternate_envelope_state ; $f6
    dw .cmd_end_channel ; $f7
    dw .cmd_end_channel ; $f8
    dw .cmd_end_channel ; $f9
    dw .cmd_end_channel ; $fa
    dw .cmd_end_channel ; $fb
    dw .cmd_end_channel ; $fc
    dw .cmd_end_channel ; $fd
    dw .cmd_end_channel ; $fe
    dw .cmd_end_channel ; $ff

.process_note_event:
    push af
    ld a, [hl]
    ld e, a
    ld hl, wMusicChannelNoteState
    add hl, bc
    ld a, [hl]
    cp MUSIC_NOTE_STATE_TIE
    jr z, .calculate_event_duration
    ld [hl], MUSIC_NOTE_STATE_RETRIGGER
    xor a
    ld hl, wMusicChannelModulationPosition
    add hl, bc
    ld [hl], a
    ld hl, wMusicChannelModulationCounter
    add hl, bc
    ld [hl], a
    inc [hl]
    ld hl, wMusicChannelModulationInitialSelector
    add hl, bc
    ld a, [hl]
    ld hl, wMusicChannelModulationSelector
    add hl, bc
    ld [hl], a
.calculate_event_duration:
    pop af
    push de
    ld hl, wMusicChannelDurationMultiplier
    add hl, bc
    ld d, [hl]
    and $0f
    inc a
    cp d
    jr nc, .duration_multiplier_ready
    ld e, a
    ld a, d
    ld d, e
.duration_multiplier_ready:
    ld e, a
.duration_multiply_loop:
    dec d
    jr z, .store_event_duration
    add e
    jr .duration_multiply_loop
.store_event_duration:
    ld hl, wMusicChannelDuration
    add hl, bc
    ld [hl], a
    pop de
    ld d, a
    ld a, e
    cp $d9
    ld a, d
    jr z, .store_gate_counter
    ld e, a
    ld hl, wMusicChannelGateLength
    add hl, bc
    ld a, [hl]
    cp $08
    ld d, a
    ld a, e
    jr z, .store_gate_counter
    push hl
    push bc
    ld b, $00
    ld c, a
    ld hl, $0000
.gate_scale_loop:
    add hl, bc
    dec d
    jr nz, .gate_scale_loop
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    ld a, l
    pop bc
    pop hl
.store_gate_counter:
    ld hl, wMusicChannelGateCounter
    add hl, bc
    ld [hl], a
    ld a, c
    cp AUDIO_CHANNEL_WAVE
    jr nc, .decode_note_code
    ld hl, wMusicToneAlternateOutputEnabled
    add hl, bc
    ld a, [hl]
    ld hl, wMusicPulsePrimaryEnvelopeDelay
    cp $00
    jr z, .load_pulse_envelope_delay
    ld hl, wMusicToneAlternateOutputPhase
    add hl, bc
    ld a, [hl]
    ld hl, wMusicPulsePrimaryEnvelopeDelay
    cp $00
    jr z, .load_pulse_envelope_delay
    ld hl, wMusicPulseAlternateEnvelopeDelay
.load_pulse_envelope_delay:
    add hl, bc
    ld a, [hl]
    ld hl, wMusicPulseEnvelopeCounter
    add hl, bc
    ld [hl], a
.decode_note_code:
    pop af
    and $f0
    ld hl, wMusicChannelNoteCode
    add hl, bc
    ld [hl], a
    or a
    jr nz, .dispatch_note_pitch
    jp .commit_stream_pointer
.dispatch_note_pitch:
    swap a
    dec a
    ld h, a
    ld a, $03
    cp c
    ld a, h
    jr z, .decode_noise_note
    jr .decode_tonal_note
.decode_noise_note:
    push af
    ld hl, wMusicChannelOctave
    add hl, bc
    ld a, [hl]
    ld d, a
    sla a
    add d
    sla a
    sla a
    sla a
    ld e, a
    pop af
    ld hl, MusicDriver_NoisePresetPointers
    add a
    ld d, c
    ld c, a
    add hl, bc
    ld c, e
    add hl, bc
    ld c, d
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]
    ld d, a
    ld a, [wMusicRoutingShadow]
    and $77
    or d
    ld [wMusicRoutingShadow], a
    ld de, wMusicNoiseRegisters
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [wMusicNoiseClockShiftOffset]
    ld b, a
    ld a, [hl]
    swap a
    and $0f
    bit 7, b
    jr z, .noise_shift_subtract
    add b
    cp $10
    jr c, .store_noise_polynomial
    ld a, $0f
    jr .store_noise_polynomial
.noise_shift_subtract:
    push af
    ld a, b
    xor $ff
    add $01
    ld b, a
    pop af
    sub b
    jr nc, .store_noise_polynomial
    ld a, $00
.store_noise_polynomial:
    swap a
    ld b, a
    ld a, [hl]
    and $0f
    or b
    ld [de], a
    inc hl
    inc de
    ld b, [hl]
    inc hl
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, b
    ld [de], a
    ld b, $00
    ld a, l
    ld d, h
    ld hl, wMusicNoiseSequencePointer
    ld [hl+], a
    ld [hl], d
    ld a, $01
    ld [wMusicNoiseSequenceActive], a
    jr .commit_stream_pointer
.decode_tonal_note:
    ld hl, wMusicToneFrequency
    add hl, bc
    add hl, bc
    push hl
    ld hl, wMusicChannelOctave
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, MusicDriver_OctaveFrequencyOffsets
    add hl, de
    add a
    ld e, [hl]
    add e
    ld hl, wMusicChannelPitchTranspose
    add hl, bc
    ld e, [hl]
    add e
    add e
    ld e, a
    ld hl, wMusicChannelFrequencyTableIndex
    add hl, bc
    ld [hl], e
    ld hl, MusicDriver_FrequencyTable
    add hl, de
    ld a, [hl+]
    ld e, a
    ld d, [hl]
    call MusicDriver_ApplySignedFrequencyOffset
    pop hl
    ld a, e
    ld [hl+], a
    ld [hl], d
.commit_stream_pointer:
    pop de
    ld hl, wMusicChannelStreamPointers
    add hl, bc
    add hl, bc
    ld [hl], e
    inc hl
    ld [hl], d
    ret

.cmd_set_duration_multiplier:
    pop hl
    ld a, [hl+]
    push hl
    ld hl, wMusicChannelDurationMultiplier
    add hl, bc
    ld [hl], a
    jp .continue
.cmd_set_octave:
    and $07
    dec a
    ld hl, wMusicChannelOctave
    add hl, bc
    push af
    ld a, c
    cp AUDIO_CHANNEL_WAVE
    jr nz, .store_octave
    pop af
    inc a
    ld [hl], a
    jp .continue
.store_octave:
    pop af
    ld [hl], a
    jp .continue
.cmd_octave_up:
    ld hl, wMusicChannelOctave
    add hl, bc
    inc [hl]
    jp .continue
.cmd_octave_down:
    ld hl, wMusicChannelOctave
    add hl, bc
    dec [hl]
    jp .continue
.cmd_tie_note:
    ld hl, wMusicChannelNoteState
    add hl, bc
    ld [hl], MUSIC_NOTE_STATE_TIE
    jp .continue
.cmd_set_channel_routing:
    pop hl
    ld a, [hl+]
    push hl
    push bc
    inc c
    ld e, $ee
.rotate_routing_bits:
    dec c
    jr z, .merge_routing_bits
    rlca
    rlc e
    jr .rotate_routing_bits
.merge_routing_bits:
    ld d, a
    ld hl, wMusicRoutingShadow
    ld a, [hl]
    and e
    or d
    ld [hl], a
    pop bc
    jp .continue
.cmd_save_stream_position:
    pop de
    push de
    dec de
    ld hl, wMusicChannelSavedStreamPointers
    add hl, bc
    add hl, bc
    ld [hl], e
    inc hl
    ld [hl], d
    jp .continue
.cmd_restore_stream_position:
    pop hl
    ld hl, wMusicChannelSavedStreamPointers
    add hl, bc
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp MusicDriver_ProcessCommand
.cmd_begin_counted_loop:
    pop de
    ld a, [de]
    inc de
    push af
    call .get_loop_stack_pointer
    ld [hl], e
    inc hl
    ld [hl], d
    inc hl
    pop af
    ld [hl], a
    inc hl
    push de
    call .save_loop_stack_pointer
    jp .continue
.cmd_repeat_counted_loop:
    call .get_loop_stack_pointer
    dec hl
    ld a, [hl]
    dec a
    jr z, .finish_counted_loop
    ld [hl-], a
    ld d, [hl]
    dec hl
    ld e, [hl]
    pop hl
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.finish_counted_loop:
    dec hl
    dec hl
    call .save_loop_stack_pointer
    jp .continue
.cmd_jump_stream:
    pop hl
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp MusicDriver_ProcessCommand
.cmd_call_stream:
    call .get_loop_stack_pointer
    pop de
    ld a, e
    ld [hl+], a
    ld a, d
    ld [hl+], a
    ld a, [de]
    ld b, a
    inc de
    ld a, [de]
    ld d, a
    ld e, b
    ld b, $00
    push de
    call .save_loop_stack_pointer
    jp .continue
.cmd_return_stream:
    pop de
    call .get_loop_stack_pointer
    dec hl
    ld a, [hl-]
    ld e, [hl]
    ld d, a
    inc de
    inc de
    push de
    call .save_loop_stack_pointer
    jp .continue
.cmd_set_frequency_offset:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicChannelFrequencyOffset
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_duty:
    pop de
    ld a, [de]
    and $c0
    inc de
    ld hl, wMusicChannelDuty
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_primary_output_level:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicTonePrimaryOutputLevel
    add hl, bc
    ld [hl], a
    xor a
    ld hl, wMusicPulsePrimaryEnvelopeDelay
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_wave_pattern:
    pop de
    ld a, [de]
    inc de
    ld [wMusicWavePatternIndex], a
    ld a, $01
    ld [wWavePatternReloadPending], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_gate_length:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicChannelGateLength
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_output_level:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicChannelOutputLevel
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_modulation_selector:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicChannelModulationSelector
    add hl, bc
    ld [hl], a
    ld hl, wMusicChannelModulationInitialSelector
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_modulation_period:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicChannelModulationPeriod
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_pitch_transpose:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicChannelPitchTranspose
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_add_pitch_transpose:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicChannelPitchTranspose
    add hl, bc
    add [hl]
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_ee:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicPulse1Sweep
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_ef:
    ld a, c
    cp AUDIO_CHANNEL_NOISE
    jp z, .cmd_set_noise_clock_shift_offset
    pop de
    ld a, [de]
    inc de
    push de
    ld e, a
    ld hl, wMusicTonePrimaryOutputLevel
    add hl, bc
    ld a, [hl]
    swap a
    and $0f
    bit 7, e
    jr z, .primary_output_subtract
    add e
    cp $10
    jr c, .store_primary_output
    ld a, $0f
    jr .store_primary_output
.primary_output_subtract:
    push af
    ld a, e
    xor $ff
    add $01
    ld e, a
    pop af
    sub e
    jr nc, .store_primary_output
    ld a, $00
.store_primary_output:
    swap a
    ld d, a
    ld a, [hl]
    and $0f
    or d
    ld [hl], a
    ld hl, wMusicToneAlternateOutputLevel
    add hl, bc
    ld a, [hl]
    swap a
    and $0f
    bit 7, e
    jr z, .alternate_output_subtract
    add e
    cp $10
    jr c, .store_alternate_output
    ld a, $0f
    jr .store_alternate_output
.alternate_output_subtract:
    push af
    ld a, e
    xor $ff
    add $01
    ld e, a
    pop af
    sub e
    jr nc, .store_alternate_output
    ld a, $00
.store_alternate_output:
    swap a
    ld d, a
    ld a, [hl]
    and $0f
    or d
    ld [hl], a
    ld hl, wMusicPulsePrimaryEnvelope
    add hl, bc
    ld a, [hl]
    swap a
    and $0f
    bit 7, e
    jr z, .primary_envelope_subtract
    add e
    cp $10
    jr c, .store_primary_envelope
    ld a, $0f
    jr .store_primary_envelope
.primary_envelope_subtract:
    push af
    ld a, e
    xor $ff
    add $01
    ld e, a
    pop af
    sub e
    jr nc, .store_primary_envelope
    ld a, $00
.store_primary_envelope:
    swap a
    ld d, a
    ld a, [hl]
    and $0f
    or d
    ld [hl], a
    ld hl, wMusicPulseAlternateEnvelope
    add hl, bc
    ld a, [hl]
    swap a
    and $0f
    bit 7, e
    jr z, .alternate_envelope_subtract
    add e
    cp $10
    jr c, .store_alternate_envelope
    ld a, $0f
    jr .store_alternate_envelope
.alternate_envelope_subtract:
    push af
    ld a, e
    xor $ff
    add $01
    ld e, a
    pop af
    sub e
    jr nc, .store_alternate_envelope
    ld a, $00
.store_alternate_envelope:
    swap a
    ld d, a
    ld a, [hl]
    and $0f
    or d
    ld [hl], a
    pop de
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_noise_clock_shift_offset:
    pop de
    ld a, [de]
    inc de
    ld [wMusicNoiseClockShiftOffset], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_apply_channel_preset:
    pop de
    ld a, [de]
    inc de
    ld hl, MusicDriver_ChannelPresetPointers
    push bc
    ld c, a
    add hl, bc
    add hl, bc
    pop bc
    push de
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld a, [de]
    inc de
    cp $00
    jr z, .preset_primary_output_done
    ld hl, wMusicTonePrimaryOutputLevel
    add hl, bc
    ld [hl], a
.preset_primary_output_done:
    ld a, [de]
    inc de
    cp $00
    jr z, .preset_primary_envelope_done
    ld hl, wMusicPulsePrimaryEnvelope
    add hl, bc
    ld [hl], a
.preset_primary_envelope_done:
    ld a, [de]
    inc de
    cp $ff
    jr z, .preset_envelope_delay_done
    ld hl, wMusicPulsePrimaryEnvelopeDelay
    add hl, bc
    ld [hl], a
.preset_envelope_delay_done:
    ld a, [de]
    inc de
    cp $ff
    jr z, .preset_duty_done
    ld hl, wMusicChannelDuty
    add hl, bc
    ld [hl], a
.preset_duty_done:
    ld a, [de]
    inc de
    cp $ff
    jr z, .preset_modulation_selector_done
    ld hl, wMusicChannelModulationSelector
    add hl, bc
    ld [hl], a
    ld hl, wMusicChannelModulationInitialSelector
    add hl, bc
    ld [hl], a
.preset_modulation_selector_done:
    ld a, [de]
    inc de
    cp $ff
    jr z, .preset_modulation_period_done
    ld hl, wMusicChannelModulationPeriod
    add hl, bc
    ld [hl], a
.preset_modulation_period_done:
    ld a, [de]
    cp $80
    jr z, .preset_frequency_offset_done
    ld hl, wMusicChannelFrequencyOffset
    add hl, bc
    ld [hl], a
.preset_frequency_offset_done:
    pop de
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_alternate_output_level:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicToneAlternateOutputLevel
    add hl, bc
    ld [hl], a
    ld a, $01
    ld hl, wMusicToneAlternateOutputEnabled
    add hl, bc
    ld [hl], a
    xor a
    ld hl, wMusicToneAlternateOutputPhase
    add hl, bc
    ld [hl], a
    xor a
    ld hl, wMusicPulseAlternateEnvelopeDelay
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_enable_alternate_output:
    ld a, $01
    ld hl, wMusicToneAlternateOutputEnabled
    add hl, bc
    ld [hl], a
    xor a
    ld hl, wMusicToneAlternateOutputPhase
    add hl, bc
    ld [hl], a
    jp .continue
.cmd_disable_alternate_output:
    xor a
    ld hl, wMusicToneAlternateOutputEnabled
    add hl, bc
    ld [hl], a
    jp .continue
.cmd_request_snapshot:
    ld a, $01
    ld hl, wMusicSnapshotRequest
    ld [hl], a
    jp .continue
.cmd_set_primary_envelope_state:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicTonePrimaryOutputLevel
    add hl, bc
    ld [hl], a
    ld a, [de]
    inc de
    ld hl, wMusicPulsePrimaryEnvelope
    add hl, bc
    ld [hl], a
    ld a, [de]
    inc de
    ld hl, wMusicPulsePrimaryEnvelopeDelay
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_set_alternate_envelope_state:
    pop de
    ld a, [de]
    inc de
    ld hl, wMusicToneAlternateOutputLevel
    add hl, bc
    ld [hl], a
    ld a, [de]
    inc de
    ld hl, wMusicPulseAlternateEnvelope
    add hl, bc
    ld [hl], a
    ld a, [de]
    inc de
    ld hl, wMusicPulseAlternateEnvelopeDelay
    add hl, bc
    ld [hl], a
    ld a, $01
    ld hl, wMusicToneAlternateOutputEnabled
    add hl, bc
    ld [hl], a
    xor a
    ld hl, wMusicToneAlternateOutputPhase
    add hl, bc
    ld [hl], a
    ld h, d
    ld l, e
    jp MusicDriver_ProcessCommand
.cmd_end_channel:
    ld hl, wMusicChannelActive
    add hl, bc
    ld [hl], $00
    pop hl
    ret

.get_loop_stack_pointer:
    ld hl, wMusicChannelLoopStatePointers
    add hl, bc
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ret

.save_loop_stack_pointer:
    ld d, h
    ld e, l
    ld hl, wMusicChannelLoopStatePointers
    add hl, bc
    add hl, bc
    ld [hl], e
    inc hl
    ld [hl], d
    ret

.continue:
    pop hl
    jp MusicDriver_ProcessCommand
MusicDriver_CommitPulse1:
    ld a, [wMusicChannelNoteCode]
    cp $00
    jr z, .silence_pulse1

    ld d, $00
    ld hl, wMusicChannelNoteState
    ld a, [hl]
    cp MUSIC_NOTE_STATE_TIE
    jr z, .commit_pulse1_frequency

    ld a, [wMusicTonePrimaryOutputLevel]
    ld d, a
    ld a, [wMusicToneAlternateOutputEnabled]
    cp $00
    jr z, .pulse1_output_level_selected

    ld a, [wMusicToneAlternateOutputLevel]
    ld e, a
    ld hl, wMusicToneAlternateOutputPhase
    ld a, [hl]
    push af
    inc a
    and $01
    ld [hl], a
    pop af
    and $01
    jr z, .pulse1_output_level_selected

    ld d, e

.pulse1_output_level_selected:
    ld a, [wSFXChannelMask]
    bit 0, a
    jr nz, .pulse1_done

    ld a, d
    ldh [rNR12], a
    ld d, $80

.commit_pulse1_frequency:
    ld hl, wMusicChannelNoteState
    ld [hl], MUSIC_NOTE_STATE_ACTIVE
    ld a, [wSFXChannelMask]
    bit 0, a
    jr nz, .pulse1_done

    ld a, [wMusicPulse1Sweep]
    ldh [rNR10], a
    ld a, [wMusicChannelDuty]
    ldh [rNR11], a
    ld a, [wMusicToneFrequency]
    ldh [rNR13], a
    ld a, [wMusicToneFrequency + 1]
    or d
    ldh [rNR14], a

.pulse1_done:
    ret

.silence_pulse1:
    ld hl, wMusicChannelNoteState
    ld [hl], MUSIC_NOTE_STATE_IDLE
    ld a, [wSFXChannelMask]
    bit 0, a
    jr nz, .pulse1_done

    ld hl, rNR12
    ld a, $08
    ld [hl+], a
    inc hl
    swap a
    ld [hl], a
    ret

MusicDriver_CommitPulse2:
    ld a, [wMusicChannelNoteCode + 1]
    cp $00
    jr z, .silence_pulse2

    ld d, $00
    ld hl, wMusicChannelNoteState + 1
    ld a, [hl]
    cp MUSIC_NOTE_STATE_TIE
    jr z, .commit_pulse2_frequency

    ld a, [wMusicTonePrimaryOutputLevel + 1]
    ld d, a
    ld a, [wMusicToneAlternateOutputEnabled + 1]
    cp $00
    jr z, .pulse2_output_level_selected

    ld a, [wMusicToneAlternateOutputLevel + 1]
    ld e, a
    ld hl, wMusicToneAlternateOutputPhase + 1
    ld a, [hl]
    push af
    inc a
    and $01
    ld [hl], a
    pop af
    and $01
    jr z, .pulse2_output_level_selected

    ld d, e

.pulse2_output_level_selected:
    ld a, [wSFXChannelMask]
    bit 1, a
    jr nz, .pulse2_done

    ld a, d
    ldh [rNR22], a
    ld d, $80

.commit_pulse2_frequency:
    ld hl, wMusicChannelNoteState + 1
    ld [hl], MUSIC_NOTE_STATE_ACTIVE
    ld a, [wSFXChannelMask]
    bit 1, a
    jr nz, .pulse2_done

    ld a, [wMusicChannelDuty + 1]
    ldh [rNR21], a
    ld a, [wMusicToneFrequency + 2]
    ldh [rNR23], a
    ld a, [wMusicToneFrequency + 3]
    or d
    ldh [rNR24], a

.pulse2_done:
    ret

.silence_pulse2:
    ld hl, wMusicChannelNoteState + 1
    ld [hl], MUSIC_NOTE_STATE_IDLE
    ld a, [wSFXChannelMask]
    bit 1, a
    jr nz, .pulse2_done

    ld hl, rNR22
    ld a, $08
    ld [hl+], a
    inc hl
    swap a
    ld [hl], a
    ret

MusicDriver_CommitWave:
    ld d, $00
    ld a, [wWavePatternReloadPending]
    or a
    jr z, .wave_pattern_ready

    xor a
    ldh [rNR30], a
    call MusicDriver_LoadWavePattern
    ld d, $80

.wave_pattern_ready:
    ld a, [wMusicChannelNoteCode + 2]
    cp $00
    jr z, .silence_wave

    ld hl, wMusicChannelNoteState + 2
    ld a, [hl]
    cp MUSIC_NOTE_STATE_TIE
    jr z, .commit_wave_frequency

    ld a, [wMusicTonePrimaryOutputLevel + 2]
    ld d, a
    ld a, [wMusicToneAlternateOutputEnabled + 2]
    cp $00
    jr z, .wave_output_level_selected

    ld a, [wMusicToneAlternateOutputLevel + 2]
    ld e, a
    ld hl, wMusicToneAlternateOutputPhase + 2
    ld a, [hl]
    push af
    inc a
    and $01
    ld [hl], a
    pop af
    and $01
    jr z, .wave_output_level_selected

    ld d, e

.wave_output_level_selected:
    ld a, [wSFXChannelMask]
    bit 2, a
    jr nz, .wave_done

    ld a, d
    ldh [rNR32], a
    xor a
    ldh [rNR30], a
    ld d, $80

.commit_wave_frequency:
    ld hl, wMusicChannelNoteState + 2
    ld [hl], MUSIC_NOTE_STATE_ACTIVE
    ld a, [wSFXChannelMask]
    bit 2, a
    jr nz, .wave_done

    xor a
    ldh [rNR31], a
    ld a, [wMusicToneFrequency + 4]
    ldh [rNR33], a
    ld a, $80
    ldh [rNR30], a
    ld a, [wMusicToneFrequency + 5]
    or d
    ldh [rNR34], a

.wave_done:
    ret

.silence_wave:
    ld hl, wMusicChannelNoteState + 2
    ld [hl], MUSIC_NOTE_STATE_IDLE
    ld a, [wSFXChannelMask]
    bit 2, a
    jr nz, .wave_done

    xor a
    ldh [rNR30], a
    ret

MusicDriver_LoadWavePattern:
    ld a, [wMusicWavePatternIndex]
    add a
    ld d, $00
    ld e, a
    ld hl, MusicDriver_WavePatternPointers
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld b, d
    ld de, $ff30

.copy_wave_byte:
    ld a, [hl+]
    ld [de], a
    inc de
    inc b
    ld a, b
    cp $10
    jr nz, .copy_wave_byte

    xor a
    ld [wWavePatternReloadPending], a
    ret

MusicDriver_CommitNoise:
    ld a, [wSFXChannelMask]
    bit 3, a
    jr nz, .noise_done

    ld a, [wMusicChannelNoteCode + 3]
    cp $00
    jr z, .silence_noise

    ld de, rNR41
    ld hl, wMusicNoiseRegisters
    ld a, [hl+]
    ld [de], a
    inc e
    ld a, [hl+]
    ld [de], a
    inc e
    ld a, [hl+]
    ld [de], a
    inc e
    ld a, [hl+]
    ld [de], a

.noise_done:
    ret

.silence_noise:
    xor a
    ld [wMusicNoiseSequenceActive], a
    ld hl, rNR42
    ld a, $08
    ld [hl+], a
    inc hl
    swap a
    ld [hl], a
    ret

MusicDriver_StepNoise:
    ld a, [wSFXChannelMask]
    bit 3, a
    jr z, .read_noise_sequence

    xor a
    ld [wMusicNoiseSequenceActive], a
    jr .noise_step_done

.read_noise_sequence:
    ld hl, wMusicNoiseSequencePointer
    ld a, [hl+]
    ld d, [hl]
    ld e, a
    ld a, [de]
    cp $ff
    jr nz, .write_noise_step

    jr MusicDriver_CommitNoise.silence_noise

.write_noise_step:
    ldh [rNR43], a
    inc de
    ld a, d
    ld [hl-], a
    ld [hl], e

.noise_step_done:
    ret

MusicDriver_ApplyFrequencyEffects:
    push af
    ld b, $00
    ld c, a
    call MusicDriver_ApplyPitchModulation
    pop af
    call MusicDriver_WriteFrequency
    ret

MusicDriver_UpdateMixer:
    ld a, [wMusicMasterVolume]
    ldh [rNR50], a
    ld a, [wSFXChannelMask]
    or a
    ld hl, wMusicRoutingShadow
    ld a, [hl+]
    jr z, .apply_routing_mute_mask

    ld a, [wSFXChannelMask]
    and $0f
    ld d, a
    swap d
    or d
    ld d, a
    xor $ff
    ld e, a
    ld a, [hl-]
    and d
    ld d, a
    ld a, [hl]
    and e
    or d

.apply_routing_mute_mask:
    ld d, a
    ld a, [wMusicRoutingMuteMask]
    xor $ff
    and $0f
    ld e, a
    swap e
    or e
    and d
    ldh [rNR51], a
    ret

MusicDriver_ApplyPitchModulation:
    ld hl, wMusicChannelModulationPeriod
    add hl, bc
    ld a, [hl]
    cp $00
    jr z, MusicDriver_ApplyPitchModulation_Step.use_base_frequency

    ld hl, wMusicChannelModulationCounter
    add hl, bc
    cp [hl]
    jr z, MusicDriver_ApplyPitchModulation_Step.step_modulation_sequence

    inc [hl]
    jr MusicDriver_ApplyPitchModulation_Step.use_base_frequency

MusicDriver_ApplyPitchModulation_Step:
.step_modulation_sequence:
    ld hl, wMusicChannelModulationSelector
    add hl, bc
    ld e, [hl]
    ld d, $00
    ld hl, MusicDriver_ModulationPointers
    add hl, de
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push hl
    ld hl, wMusicChannelModulationPosition
    add hl, bc
    ld d, $00
    ld e, [hl]
    inc [hl]
    pop hl
    add hl, de
    ld a, [hl+]
    cp $80
    jr z, .handle_modulation_loop

    cp $7f
    jr z, .handle_modulation_duty

    ld hl, wMusicToneFrequency
    add hl, bc
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    bit 7, a
    jr nz, .apply_negative_modulation

    add e
    ld e, a
    ld a, $00
    adc d
    and $07
    ld d, a
    ret

.apply_negative_modulation:
    xor $ff
    inc a
    push bc
    ld c, a
    ld a, e
    sub c
    ld e, a
    ld a, d
    sbc b
    and $07
    ld d, a
    pop bc
    ret

.handle_modulation_loop:
    push hl
    ld hl, wMusicChannelModulationPosition
    add hl, bc
    ld [hl], $00
    pop hl
    ld a, [hl]
    cp $80
    jr z, .step_modulation_sequence

    ld hl, wMusicChannelModulationSelector
    add hl, bc
    ld [hl], a
    jr .step_modulation_sequence

.use_base_frequency:
    ld hl, wMusicToneFrequency
    add hl, bc
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    ret

.handle_modulation_duty:
    ld a, c
    cp $00
    jr nz, .check_pulse2_duty

    ld a, [wSFXChannelMask]
    bit 0, a
    jr nz, .advance_after_duty

    ld de, rNR11
    ld a, [hl+]
    ld [de], a
    jr .advance_after_duty

.check_pulse2_duty:
    cp $01
    jr nz, .advance_after_duty

    ld a, [wSFXChannelMask]
    bit 0, a
    jr nz, .advance_after_duty

    ld de, rNR21
    ld a, [hl+]
    ld [de], a

.advance_after_duty:
    ld hl, wMusicChannelModulationPosition
    add hl, bc
    inc [hl]
    jp MusicDriver_ApplyPitchModulation_Step

MusicDriver_WriteFrequency:
    cp AUDIO_CHANNEL_PULSE1
    jr nz, .check_pulse2

    ld a, [wMusicChannelModulationPeriod]
    cp $00
    jr z, .frequency_write_done

    ld a, [wSFXChannelMask]
    bit 0, a
    jr nz, .frequency_write_done

    ld a, e
    ldh [rNR13], a
    ldh a, [rNR11]
    and $c0
    ldh [rNR11], a
    ld a, d
    and $3f
    ldh [rNR14], a
    ret

.check_pulse2:
    cp AUDIO_CHANNEL_PULSE2
    jr nz, .check_wave

    ld a, [wMusicChannelModulationPeriod + 1]
    cp $00
    jr z, .frequency_write_done

    ld a, [wSFXChannelMask]
    bit 1, a
    jr nz, .frequency_write_done

    ld a, e
    ldh [rNR23], a
    ldh a, [rNR21]
    and $c0
    ldh [rNR21], a
    ld a, d
    ldh [rNR24], a
    ret

.check_wave:
    cp AUDIO_CHANNEL_WAVE
    jr nz, .frequency_write_done

    ld a, [wMusicChannelModulationPeriod + 2]
    cp $00
    jr z, .frequency_write_done

    ld a, [wSFXChannelMask]
    bit 2, a
    jr nz, .frequency_write_done

    ld a, e
    ldh [rNR33], a
    xor a
    ldh [rNR31], a
    ld a, d
    ldh [rNR34], a

.frequency_write_done:
    ret

MusicDriver_ApplySignedFrequencyOffset:
    ld hl, wMusicChannelFrequencyOffset
    add hl, bc
    ld a, [hl]
    bit 7, a
    jr nz, .subtract_frequency_offset

    add e
    ld e, a
    ld a, d
    adc b
    ld d, a
    ret

.subtract_frequency_offset:
    xor $ff
    ld h, a
    ld a, e
    sub h
    ld e, a
    ld a, d
    sbc b
    ld d, a
    ret

MusicDriver_SilenceUnprotectedChannels:
    ld a, [wSFXChannelMask]
    ld d, a
    bit 0, d
    jr nz, .skip_pulse1_silence

    ld a, $08
    ldh [rNR12], a
    swap a
    ldh [rNR14], a

.skip_pulse1_silence:
    bit 1, d
    jr nz, .skip_pulse2_silence

    swap a
    ldh [rNR22], a
    swap a
    ldh [rNR24], a

.skip_pulse2_silence:
    bit 3, d
    jr nz, .skip_noise_silence

    swap a
    ldh [rNR42], a
    swap a
    ldh [rNR44], a

.skip_noise_silence:
    bit 2, d
    jr nz, .silence_done

    ld a, $00
    ldh [rNR32], a

.silence_done:
    ret

MusicDriver_CheckAllChannelsStopped:
    ld hl, wMusicChannelActive
    xor a
    add [hl]
    inc hl
    add [hl]
    inc hl
    add [hl]
    inc hl
    add [hl]
    or a
    ret nz

    ld a, $80
    ld [wMusicTrackRequest], a
    ret

MusicDriver_SaveStateAndStop:
    di
    call MusicDriver_SelectWRAMBank7
    call MusicDriver_SilenceUnprotectedChannels
    call MusicDriver_SaveState
    call MusicDriver_StopInactiveChannels
    call MusicDriver_RestoreWRAMBank
    ei
    ret

MusicDriver_RestoreStateAndResume:
    di
    call MusicDriver_SelectWRAMBank7
    call MusicDriver_SilenceUnprotectedChannels
    call MusicDriver_StopInactiveChannels
    call MusicDriver_RestoreState
    call MusicDriver_RestoreWRAMBank
    ei
    ret

MusicDriver_SaveState:
    ld a, [wMusicTrackRequest]
    ld [wMusicSnapshotTrackRequest], a
    ld a, [wMusicDataBank]
    ld [wMusicSnapshotDataBank], a
    ld a, [wMusicRoutingShadow]
    ld [wMusicSnapshotRoutingShadow], a
    ld hl, wMusicChannelDuty
    ld de, wMusicSnapshotChannelDuty
    ld a, $04
    call MusicDriver_CopyBytes
    ld a, [wMusicWavePatternIndex]
    ld [wMusicSnapshotWavePatternIndex], a
    ld a, [wWavePatternReloadPending]
    ld [wMusicSnapshotWaveReloadPending], a
    ld hl, wMusicChannelActive
    ld de, wMusicSnapshotChannelActive
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelNoteState
    ld de, wMusicSnapshotChannelNoteState
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelStreamPointers
    ld de, wMusicSnapshotChannelStreamPointers
    ld a, $08
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelSavedStreamPointers
    ld de, wMusicSnapshotChannelSavedStreamPointers
    ld a, $08
    call MusicDriver_CopyBytes
    ld a, [wMusicNoiseRegisters]
    ld [wMusicSnapshotNoiseRegisters], a
    ld a, [wMusicNoiseRegisters + 1]
    ld [wMusicSnapshotNoiseRegisters + 1], a
    ld hl, wMusicChannelOctave
    ld de, wMusicSnapshotChannelOctave
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, $c138
    ld de, $c21f
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelNoteCode
    ld de, wMusicSnapshotChannelNoteCode
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelDuration
    ld de, wMusicSnapshotChannelDuration
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelGateLength
    ld de, wMusicSnapshotChannelGateLength
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelGateCounter
    ld de, wMusicSnapshotChannelGateCounter
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelOutputLevel
    ld de, wMusicSnapshotChannelOutputLevel
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelPitchTranspose
    ld de, wMusicSnapshotChannelPitchTranspose
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelDurationMultiplier
    ld de, wMusicSnapshotChannelDurationMultiplier
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelModulationInitialSelector
    ld de, wMusicSnapshotChannelModulationInitialSelector
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelModulationPeriod
    ld de, wMusicSnapshotChannelModulationPeriod
    ld a, $04
    call MusicDriver_CopyBytes
    ld a, $00
    ld [wMusicChannelModulationPosition], a
    ld [wMusicChannelModulationPosition + 1], a
    ld [wMusicChannelModulationPosition + 2], a
    ld [wMusicChannelModulationPosition + 3], a
    ld hl, wMusicTonePrimaryOutputLevel
    ld de, wMusicSnapshotTonePrimaryOutputLevel
    ld a, $03
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelFrequencyOffset
    ld de, wMusicSnapshotChannelFrequencyOffset
    ld a, $03
    call MusicDriver_CopyBytes
    ld hl, wMusicNoiseSequencePointer
    ld de, wMusicSnapshotNoiseSequencePointer
    ld a, $02
    call MusicDriver_CopyBytes
    ld a, $00
    ld [wMusicSnapshotNoiseSequenceActive], a
    ld hl, wMusicChannelLoopStatePointers
    ld de, wMusicSnapshotChannelLoopStatePointers
    ld a, $08
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelLoopState
    ld de, wMusicSnapshotChannelLoopState
    ld a, $30
    call MusicDriver_CopyBytes
    ld hl, wMusicChannelFrequencyTableIndex
    ld de, wMusicSnapshotChannelFrequencyTableIndex
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, $c170
    ld de, $c255
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicToneAlternateOutputLevel
    ld de, wMusicSnapshotToneAlternateOutputLevel
    ld a, $03
    call MusicDriver_CopyBytes
    ld hl, wMusicToneAlternateOutputPhase
    ld de, wMusicSnapshotToneAlternateOutputPhase
    ld a, $03
    call MusicDriver_CopyBytes
    ld hl, wMusicToneAlternateOutputEnabled
    ld de, wMusicSnapshotToneAlternateOutputEnabled
    ld a, $03
    call MusicDriver_CopyBytes
    ld a, [wMusicPulse1Sweep]
    ld [wMusicSnapshotPulse1Sweep], a
    ld a, [wMusicNoiseClockShiftOffset]
    ld [wMusicSnapshotNoiseClockShiftOffset], a
    ld hl, wMusicPulsePrimaryEnvelope
    ld de, wMusicSnapshotPulseEnvelopeState
    ld a, $0a
    call MusicDriver_CopyBytes
    ret

MusicDriver_RestoreState:
    ld a, [wMusicSnapshotTrackRequest]
    ld [wMusicTrackRequest], a
    ld a, [wMusicSnapshotDataBank]
    ld [wMusicDataBank], a
    ld a, [wMusicSnapshotRoutingShadow]
    ld [wMusicRoutingShadow], a
    ld hl, wMusicSnapshotChannelDuty
    ld de, wMusicChannelDuty
    ld a, $04
    call MusicDriver_CopyBytes
    ld a, [wMusicSnapshotWavePatternIndex]
    ld [wMusicWavePatternIndex], a
    ld a, $01
    ld [wWavePatternReloadPending], a
    ld hl, wMusicSnapshotChannelActive
    ld de, wMusicChannelActive
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelNoteState
    ld de, wMusicChannelNoteState
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelStreamPointers
    ld de, wMusicChannelStreamPointers
    ld a, $08
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelSavedStreamPointers
    ld de, wMusicChannelSavedStreamPointers
    ld a, $08
    call MusicDriver_CopyBytes
    ld a, [wMusicSnapshotNoiseRegisters]
    ld [wMusicNoiseRegisters], a
    ld a, [wMusicSnapshotNoiseRegisters + 1]
    ld [wMusicNoiseRegisters + 1], a
    ld hl, wMusicSnapshotChannelOctave
    ld de, wMusicChannelOctave
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, $c21f
    ld de, $c138
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelNoteCode
    ld de, wMusicChannelNoteCode
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelDuration
    ld de, wMusicChannelDuration
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelGateLength
    ld de, wMusicChannelGateLength
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelGateCounter
    ld de, wMusicChannelGateCounter
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelOutputLevel
    ld de, wMusicChannelOutputLevel
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelPitchTranspose
    ld de, wMusicChannelPitchTranspose
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelDurationMultiplier
    ld de, wMusicChannelDurationMultiplier
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelModulationInitialSelector
    ld de, wMusicChannelModulationInitialSelector
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelModulationPeriod
    ld de, wMusicChannelModulationPeriod
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotTonePrimaryOutputLevel
    ld de, wMusicTonePrimaryOutputLevel
    ld a, $03
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelFrequencyOffset
    ld de, wMusicChannelFrequencyOffset
    ld a, $03
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotNoiseSequencePointer
    ld de, wMusicNoiseSequencePointer
    ld a, $02
    call MusicDriver_CopyBytes
    ld a, [wMusicSnapshotNoiseSequenceActive]
    ld [wMusicNoiseSequenceActive], a
    ld hl, wMusicSnapshotChannelLoopStatePointers
    ld de, wMusicChannelLoopStatePointers
    ld a, $08
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelLoopState
    ld de, wMusicChannelLoopState
    ld a, $30
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotChannelFrequencyTableIndex
    ld de, wMusicChannelFrequencyTableIndex
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, $c255
    ld de, $c170
    ld a, $04
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotToneAlternateOutputLevel
    ld de, wMusicToneAlternateOutputLevel
    ld a, $03
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotToneAlternateOutputPhase
    ld de, wMusicToneAlternateOutputPhase
    ld a, $03
    call MusicDriver_CopyBytes
    ld hl, wMusicSnapshotToneAlternateOutputEnabled
    ld de, wMusicToneAlternateOutputEnabled
    ld a, $03
    call MusicDriver_CopyBytes
    ld a, [wMusicSnapshotPulse1Sweep]
    ld [wMusicPulse1Sweep], a
    ld a, [wMusicSnapshotNoiseClockShiftOffset]
    ld [wMusicNoiseClockShiftOffset], a
    ld hl, wMusicSnapshotPulseEnvelopeState
    ld de, wMusicPulsePrimaryEnvelope
    ld a, $0a
    call MusicDriver_CopyBytes
    ret

MusicDriver_CopyBytes:
    ld c, a

.copy_loop:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, .copy_loop

    ret

MusicDriver_SelectWRAMBank7:
    push af
    ldh a, [rSVBK]
    push af
    ld a, $07
    ldh [rSVBK], a
    pop af
    ld [wMusicSavedWRAMBank], a
    pop af
    ret

MusicDriver_RestoreWRAMBank:
    push af
    ld a, [wMusicSavedWRAMBank]
    ldh [rSVBK], a
    pop af
    ret

MusicDriver_SelectWRAMBank7ForUpdate:
    push af
    ldh a, [rSVBK]
    push af
    ld a, $07
    ldh [rSVBK], a
    pop af
    ld [wMusicUpdateSavedWRAMBank], a
    pop af
    ret

MusicDriver_RestoreWRAMBankForUpdate:
    push af
    ld a, [wMusicUpdateSavedWRAMBank]
    ldh [rSVBK], a
    pop af
    ret

; Shared music-driver data. Retail banks $03-$07 contain identical bytes here.
; Numeric names are retained where higher-level musical semantics are not yet proven.

; Initial write pointers for four 12-byte per-channel loop-state stacks.
; Loop commands use three-byte records (stream pointer + repeat/control byte),
; allowing up to four records per channel without changing the retail layout.
MusicDriver_LoopStateInitialPointers:
    dw wMusicChannelLoopState, wMusicChannelLoopState + $0c, wMusicChannelLoopState + $18, wMusicChannelLoopState + $24

MusicDriver_OctaveFrequencyOffsets:
    db $00, $18, $30, $48, $60, $78, $90, $a8

MusicDriver_FrequencyTable:
    dw $002c, $009c, $0106, $016b, $01c9, $0222, $0278, $02c6
    dw $0312, $0358, $039b, $03da, $0416, $044e, $0483, $04b5
    dw $04e5, $0511, $053c, $0563, $0589, $05ac, $05cd, $05ed
    dw $060b, $0628, $0642, $065b, $0672, $0689, $069e, $06b2
    dw $06c4, $06d6, $06e7, $06f6, $0705, $0714, $0721, $072d
    dw $0739, $0744, $074f, $0759, $0762, $076b, $0773, $077b
    dw $0783, $078a, $0790, $0797, $079d, $07a2, $07a7, $07ac
    dw $07b1, $07b6, $07ba, $07be, $07c1, $07c5, $07c8, $07cb
    dw $07ce, $07d1, $07d4, $07d6, $07d9, $07db, $07dd, $07df
    dw $07e1, $07e3, $07e4, $07e5, $07e7, $07e8, $07ea, $07eb
    dw $07ec, $07ed, $07ee, $07ef, $07f0

MusicDriver_WavePatternPointers:
    dw MusicDriver_WavePattern_00, MusicDriver_WavePattern_01, MusicDriver_WavePattern_02, MusicDriver_WavePattern_03, MusicDriver_WavePattern_04
    dw MusicDriver_WavePattern_05, MusicDriver_WavePattern_06, MusicDriver_WavePattern_07, MusicDriver_WavePattern_08, MusicDriver_WavePattern_09
    dw MusicDriver_WavePattern_0A, MusicDriver_WavePattern_0B, MusicDriver_WavePattern_0C, MusicDriver_WavePattern_0D, MusicDriver_WavePattern_0E
    dw MusicDriver_WavePattern_0F, MusicDriver_WavePattern_10, MusicDriver_WavePattern_11, MusicDriver_WavePattern_12, MusicDriver_WavePattern_13

MusicDriver_WavePattern_00:
    db $79, $bd, $ff, $ff, $ff, $ff, $fd, $b9, $75, $31, $00, $00, $00, $00, $01, $35

MusicDriver_WavePattern_01:
    db $46, $8a, $cc, $cc, $cc, $cc, $ca, $86, $42, $11, $00, $00, $00, $00, $01, $12

MusicDriver_WavePattern_02:
    db $7a, $df, $ff, $da, $74, $10, $00, $14, $7a, $df, $ff, $da, $74, $10, $00, $14

MusicDriver_WavePattern_03:
    db $01, $12, $23, $34, $45, $56, $67, $77, $88, $99, $aa, $bb, $cc, $dd, $ee, $ff

MusicDriver_WavePattern_04:
    db $12, $23, $33, $44, $55, $66, $77, $77, $78, $89, $9a, $ab, $bb, $cc, $dd, $ee

MusicDriver_WavePattern_05:
    db $00, $12, $22, $33, $44, $55, $66, $66, $67, $78, $89, $9a, $aa, $bb, $cc, $dd

MusicDriver_WavePattern_06:
    db $00, $12, $12, $22, $33, $44, $55, $55, $57, $68, $79, $8a, $99, $aa, $bb, $cc

MusicDriver_WavePattern_07:
    db $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $00, $00, $00, $00, $00, $00, $00, $00

MusicDriver_WavePattern_08:
    db $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $00, $00, $00, $00, $00, $00, $00, $00

MusicDriver_WavePattern_09:
    db $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $00, $00, $00, $00, $00, $00, $00, $00

MusicDriver_WavePattern_0A:
    db $ee, $ee, $ee, $ee, $ee, $ee, $ed, $cb, $21, $00, $00, $00, $00, $00, $00, $00

MusicDriver_WavePattern_0B:
    db $cc, $cc, $cc, $cc, $bc, $cc, $bc, $cc, $c0, $00, $00, $00, $00, $00, $00, $0b

MusicDriver_WavePattern_0C:
    db $99, $99, $99, $99, $99, $99, $99, $99, $00, $00, $00, $00, $00, $00, $00, $00

MusicDriver_WavePattern_0D:
    db $00, $ff, $00, $ff, $66, $aa, $66, $aa, $66, $aa, $66, $aa, $00, $ff, $00, $ff

MusicDriver_WavePattern_0E:
    db $77, $dd, $77, $dd, $00, $00, $00, $00, $00, $00, $00, $00, $dd, $77, $dd, $77

MusicDriver_WavePattern_0F:
    db $78, $78, $78, $78, $78, $78, $78, $78, $00, $00, $00, $00, $00, $00, $00, $00

MusicDriver_WavePattern_10:
    db $00, $05, $16, $2f, $4c, $69, $82, $93, $99, $93, $82, $69, $4c, $2f, $16, $05

MusicDriver_WavePattern_11:
    db $68, $68, $68, $68, $68, $68, $68, $68, $00, $00, $00, $00, $00, $00, $00, $00

MusicDriver_WavePattern_12:
    db $66, $cc, $66, $cc, $00, $00, $00, $00, $00, $00, $00, $00, $cc, $66, $cc, $66

MusicDriver_WavePattern_13:
    db $48, $48, $48, $48, $48, $48, $48, $48, $00, $00, $00, $00, $00, $00, $00, $00

MusicDriver_NoisePresetPointers:
    dw MusicDriver_NoisePreset_00, MusicDriver_NoisePreset_01, MusicDriver_NoisePreset_02, MusicDriver_NoisePreset_03, MusicDriver_NoisePreset_04
    dw MusicDriver_NoisePreset_05, MusicDriver_NoisePreset_06, MusicDriver_NoisePreset_07, MusicDriver_NoisePreset_08, MusicDriver_NoisePreset_09
    dw MusicDriver_NoisePreset_0A, MusicDriver_NoisePreset_0B, MusicDriver_NoisePreset_0C, MusicDriver_NoisePreset_0D, MusicDriver_NoisePreset_0E

MusicDriver_NoisePresetDataStart:
    db $00, $ed, $02, $c0, $46, $63, $ff

MusicDriver_NoisePreset_00:
    db $88, $0a, $91, $80, $27, $ff

MusicDriver_NoisePreset_07:
    db $88, $00, $55, $80, $03, $01, $ff

MusicDriver_NoisePreset_04:
    db $88, $00, $95, $80, $04, $02, $ff

MusicDriver_NoisePreset_05:
    db $88, $00, $95, $80, $03, $01, $ff

MusicDriver_NoisePreset_02:
    db $88, $00, $45, $80, $04, $02, $ff

MusicDriver_NoisePreset_06:
    db $88, $32, $b1, $c0, $02, $01, $01, $01, $ff

MusicDriver_NoisePreset_08:
    db $88, $00, $84, $80, $04, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $ff

MusicDriver_NoisePreset_0B:
    db $88, $00, $c4, $80, $05, $03, $03, $03, $03, $03, $03, $03, $03, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01
    db $01, $01, $01, $ff

MusicDriver_NoisePreset_09:
    db $88, $1e, $a1, $80, $25, $25, $25, $25, $25, $25, $25, $25, $25, $25, $25, $25
    db $ff

MusicDriver_NoisePreset_01:
    db $88, $2e, $f1, $80, $60, $ff

MusicDriver_NoisePreset_0A:
    db $88, $32, $71, $c0, $33, $33, $33, $ff

MusicDriver_NoisePreset_03:
    db $88, $1e, $91, $c0, $12, $12, $12, $12, $12, $12, $ff

MusicDriver_NoisePreset_0C:
    db $88, $1e, $91, $80, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23
    db $ff

MusicDriver_NoisePreset_0D:
    db $88, $00, $71, $80, $43, $43, $43, $43, $ff

MusicDriver_NoisePreset_0E:
    db $88, $32, $a1, $c0, $36, $47, $ff

MusicDriver_ModulationPointers:
    dw MusicDriver_ModulationSequence_00, MusicDriver_ModulationSequence_01, MusicDriver_ModulationSequence_02, MusicDriver_ModulationSequence_03, MusicDriver_ModulationSequence_04, MusicDriver_ModulationSequence_05, MusicDriver_ModulationSequence_06


MusicDriver_ModulationSequence_00:
    db $00, $80, $80

MusicDriver_ModulationSequence_01:
    db $01, $02, $01, $00, $ff, $fe, $ff, $00, $80, $80

MusicDriver_ModulationSequence_02:
    db $01, $02, $02, $01, $00, $00, $ff, $fe, $fe, $ff, $00, $00, $80, $80

MusicDriver_ModulationSequence_03:
    db $01, $01, $00, $00, $00, $ff, $ff, $00, $00, $00, $80, $80

MusicDriver_ModulationSequence_04:
    db $01, $00, $00, $00, $00, $00, $ff, $00, $00, $00, $00, $00, $80, $80

MusicDriver_ModulationSequence_05:
    db $01, $02, $04, $03, $01, $00, $ff, $fe, $fc, $fd, $ff, $00, $80, $80

MusicDriver_ModulationSequence_06:
    db $01, $03, $04, $06, $04, $03, $01, $00, $ff, $fd, $fc, $fa, $fc, $fd, $ff, $00
    db $80, $80

MusicDriver_ChannelPresetPointers:
    dw MusicDriver_ChannelPreset_00, MusicDriver_ChannelPreset_01, MusicDriver_ChannelPreset_02, MusicDriver_ChannelPreset_03, MusicDriver_ChannelPreset_04
    dw MusicDriver_ChannelPreset_05, MusicDriver_ChannelPreset_06, MusicDriver_ChannelPreset_07, MusicDriver_ChannelPreset_08, MusicDriver_ChannelPreset_09
    dw MusicDriver_ChannelPreset_0A, MusicDriver_ChannelPreset_0B, MusicDriver_ChannelPreset_0C, MusicDriver_ChannelPreset_0D, MusicDriver_ChannelPreset_0E
    dw MusicDriver_ChannelPreset_0F, MusicDriver_ChannelPreset_10, MusicDriver_ChannelPreset_11, MusicDriver_ChannelPreset_12, MusicDriver_ChannelPreset_13
    dw MusicDriver_ChannelPreset_14, MusicDriver_ChannelPreset_15, MusicDriver_ChannelPreset_16, MusicDriver_ChannelPreset_17, MusicDriver_ChannelPreset_18
    dw MusicDriver_ChannelPreset_19, MusicDriver_ChannelPreset_1A, MusicDriver_ChannelPreset_1B, MusicDriver_ChannelPreset_1C, MusicDriver_ChannelPreset_1D
    dw MusicDriver_ChannelPreset_1E, MusicDriver_ChannelPreset_1F, MusicDriver_ChannelPreset_20, MusicDriver_ChannelPreset_21, MusicDriver_ChannelPreset_22

MusicDriver_ChannelPreset_00:
    db $90, $ff, $00, $00, $01, $0f, $00

MusicDriver_ChannelPreset_01:
    db $80, $ff, $00, $40, $01, $0f, $00

MusicDriver_ChannelPreset_02:
    db $70, $ff, $00, $80, $01, $0f, $00

MusicDriver_ChannelPreset_03:
    db $80, $ff, $00, $00, $01, $0f, $00

MusicDriver_ChannelPreset_04:
    db $50, $ff, $00, $00, $01, $0f, $00

MusicDriver_ChannelPreset_05:
    db $52, $ff, $00, $80, $01, $0f, $00

MusicDriver_ChannelPreset_06:
    db $72, $ff, $00, $80, $01, $0f, $00

MusicDriver_ChannelPreset_07:
    db $f0, $ff, $00, $40, $01, $0f, $00

MusicDriver_ChannelPreset_08:
    db $7f, $80, $02, $00, $01, $12, $00

MusicDriver_ChannelPreset_09:
    db $4f, $6a, $01, $80, $01, $0f, $00

MusicDriver_ChannelPreset_0A:
    db $b2, $78, $01, $80, $01, $0f, $00

MusicDriver_ChannelPreset_0B:
    db $4f, $6a, $01, $40, $01, $0f, $00

MusicDriver_ChannelPreset_0C:
    db $93, $5a, $02, $00, $01, $12, $00

MusicDriver_ChannelPreset_0D:
    db $80, $50, $00, $00, $01, $12, $00

MusicDriver_ChannelPreset_0E:
    db $48, $70, $03, $40, $02, $0f, $00

MusicDriver_ChannelPreset_0F:
    db $f1, $80, $01, $00, $01, $12, $00

MusicDriver_ChannelPreset_10:
    db $a2, $78, $01, $80, $01, $0f, $01

MusicDriver_ChannelPreset_11:
    db $59, $80, $03, $80, $03, $12, $00

MusicDriver_ChannelPreset_12:
    db $91, $54, $02, $00, $01, $12, $00

MusicDriver_ChannelPreset_13:
    db $32, $ff, $00, $80, $01, $0f, $00

MusicDriver_ChannelPreset_14:
    db $22, $ff, $00, $80, $01, $0f, $00

MusicDriver_ChannelPreset_15:
    db $12, $ff, $00, $80, $01, $0f, $00

MusicDriver_ChannelPreset_16:
    db $80, $ff, $00, $40, $01, $12, $00

MusicDriver_ChannelPreset_17:
    db $70, $3a, $03, $40, $01, $0f, $00

MusicDriver_ChannelPreset_18:
    db $38, $50, $01, $80, $01, $0f, $00

MusicDriver_ChannelPreset_19:
    db $7f, $80, $01, $00, $01, $12, $00

MusicDriver_ChannelPreset_1A:
    db $70, $ff, $00, $40, $01, $12, $00

MusicDriver_ChannelPreset_1B:
    db $3a, $60, $03, $40, $01, $0f, $00

MusicDriver_ChannelPreset_1C:
    db $69, $80, $03, $40, $03, $12, $00

MusicDriver_ChannelPreset_1D:
    db $5f, $60, $02, $00, $01, $12, $00

MusicDriver_ChannelPreset_1E:
    db $6a, $60, $01, $80, $01, $0f, $00

MusicDriver_ChannelPreset_1F:
    db $6a, $a0, $03, $40, $05, $0f, $00

MusicDriver_ChannelPreset_20:
    db $d1, $80, $01, $40, $05, $0f, $00

MusicDriver_ChannelPreset_21:
    db $48, $50, $03, $40, $02, $0f, $00

MusicDriver_ChannelPreset_22:
    db $71, $50, $01, $00, $01, $12, $00

MusicDriver_SFXPriorityTable:
    db $00, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a
    db $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a
    db $47, $48, $46, $45, $44, $43, $49, $32, $33, $34, $37, $35, $36, $09, $39
    db $38, $3a, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $15, $1e, $1e
    db $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e
    db $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e
    db $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $3f
    db $40, $3e, $3d, $3c, $42, $41, $29, $2a, $2b, $2e, $2c, $2d, $09, $30, $2f
    db $31, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $14, $14

MusicDriver_TrackCount:
    db $2d

MusicDriver_TrackBankTable:
    db $03, $07, $03, $03, $03, $03, $03, $06, $3e, $04, $04, $3f, $05, $05, $3f
    db $05, $06, $04, $06, $07, $07, $07, $04, $3e, $3e, $3e, $3e, $3e, $3e, $06
    db $06, $07, $03, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $03, $3f, $03

MusicDriver_TrackHeaderPointers:
    dw MusicDriver_TrackHeader_00, MusicDriver_TrackHeader_01, MusicDriver_TrackHeader_02, MusicDriver_TrackHeader_03, MusicDriver_TrackHeader_04
    dw MusicDriver_TrackHeader_05, MusicDriver_TrackHeader_06, MusicDriver_TrackHeader_07, MusicDriver_TrackHeader_08, MusicDriver_TrackHeader_09
    dw MusicDriver_TrackHeader_0A, MusicDriver_TrackHeader_0B, MusicDriver_TrackHeader_0C, MusicDriver_TrackHeader_0D, MusicDriver_TrackHeader_0E
    dw MusicDriver_TrackHeader_0F, MusicDriver_TrackHeader_10, MusicDriver_TrackHeader_11, MusicDriver_TrackHeader_12, MusicDriver_TrackHeader_13
    dw MusicDriver_TrackHeader_14, MusicDriver_TrackHeader_15, MusicDriver_TrackHeader_16, MusicDriver_TrackHeader_17, MusicDriver_TrackHeader_18
    dw MusicDriver_TrackHeader_19, MusicDriver_TrackHeader_1A, MusicDriver_TrackHeader_1B, MusicDriver_TrackHeader_1C, MusicDriver_TrackHeader_1D
    dw MusicDriver_TrackHeader_1E, MusicDriver_TrackHeader_1F, MusicDriver_TrackHeader_20, MusicDriver_TrackHeader_21, MusicDriver_TrackHeader_22
    dw MusicDriver_TrackHeader_23, MusicDriver_TrackHeader_24, MusicDriver_TrackHeader_25, MusicDriver_TrackHeader_26, MusicDriver_TrackHeader_27
    dw MusicDriver_TrackHeader_28, MusicDriver_TrackHeader_29, MusicDriver_TrackHeader_20, MusicDriver_TrackHeader_2A, MusicDriver_TrackHeader_20


MusicDriver_TrackHeader_00:
    db $00

MusicDriver_TrackHeader_20:
    db $01
    dw MusicTrack_20_Ch1
    ds 6, $00

MusicDriver_TrackHeader_01:
    db $0f
    dw MusicTrack_01_Ch1, MusicTrack_01_Ch2, MusicTrack_01_Ch3, MusicTrack_01_Ch4

MusicDriver_TrackHeader_02:
    db $0f
    dw MusicTrack_02_Ch1, MusicTrack_02_Ch2, MusicTrack_02_Ch3, MusicTrack_02_Ch4

MusicDriver_TrackHeader_03:
    db $0f
    dw MusicTrack_03_Ch1, MusicTrack_03_Ch2, MusicTrack_03_Ch3, MusicTrack_03_Ch4

MusicDriver_TrackHeader_04:
    db $0f
    dw MusicTrack_04_Ch1, MusicTrack_04_Ch2, MusicTrack_04_Ch3, MusicTrack_04_Ch4

MusicDriver_TrackHeader_05:
    db $0f
    dw MusicTrack_05_Ch1, MusicTrack_05_Ch2, MusicTrack_05_Ch3, MusicTrack_05_Ch4

MusicDriver_TrackHeader_06:
    db $0f
    dw MusicTrack_06_Ch1, MusicTrack_06_Ch2, MusicTrack_06_Ch3, MusicTrack_06_Ch4

MusicDriver_TrackHeader_07:
    db $0f
    dw MusicTrack_07_Ch1, MusicTrack_07_Ch2, MusicTrack_07_Ch3, MusicTrack_07_Ch4

MusicDriver_TrackHeader_08:
    db $0f
    dw MusicTrack_08_Ch1, MusicTrack_08_Ch2, MusicTrack_08_Ch3, MusicTrack_08_Ch4

MusicDriver_TrackHeader_09:
    db $0f
    dw MusicTrack_09_Ch1, MusicTrack_09_Ch2, MusicTrack_09_Ch3, MusicTrack_09_Ch4

MusicDriver_TrackHeader_0A:
    db $0f
    dw MusicTrack_0A_Ch1, MusicTrack_0A_Ch2, MusicTrack_0A_Ch3, MusicTrack_0A_Ch4

MusicDriver_TrackHeader_0B:
    db $0f
    dw MusicTrack_0B_Ch1, MusicTrack_0B_Ch2, MusicTrack_0B_Ch3, MusicTrack_0B_Ch4

MusicDriver_TrackHeader_0C:
    db $0f
    dw MusicTrack_0C_Ch1, MusicTrack_0C_Ch2, MusicTrack_0C_Ch3, MusicTrack_0C_Ch4

MusicDriver_TrackHeader_0D:
    db $0f
    dw MusicTrack_0D_Ch1, MusicTrack_0D_Ch2, MusicTrack_0D_Ch3, MusicTrack_0D_Ch4

MusicDriver_TrackHeader_0E:
    db $0f
    dw MusicTrack_0E_Ch1, MusicTrack_0E_Ch2, MusicTrack_0E_Ch3, MusicTrack_0E_Ch4

MusicDriver_TrackHeader_0F:
    db $0f
    dw MusicTrack_0F_Ch1, MusicTrack_0F_Ch2, MusicTrack_0F_Ch3, MusicTrack_0F_Ch4

MusicDriver_TrackHeader_10:
    db $0f
    dw MusicTrack_10_Ch1, MusicTrack_10_Ch2, MusicTrack_10_Ch3, MusicTrack_10_Ch4

MusicDriver_TrackHeader_11:
    db $0f
    dw MusicTrack_11_Ch1, MusicTrack_11_Ch2, MusicTrack_11_Ch3, MusicTrack_11_Ch4

MusicDriver_TrackHeader_12:
    db $0f
    dw MusicTrack_12_Ch1, MusicTrack_12_Ch2, MusicTrack_12_Ch3, MusicTrack_12_Ch4

MusicDriver_TrackHeader_13:
    db $0f
    dw MusicTrack_13_Ch1, MusicTrack_13_Ch2, MusicTrack_13_Ch3, MusicTrack_13_Ch4

MusicDriver_TrackHeader_14:
    db $0f
    dw MusicTrack_14_Ch1, MusicTrack_14_Ch2, MusicTrack_14_Ch3, MusicTrack_14_Ch4

MusicDriver_TrackHeader_15:
    db $0f
    dw MusicTrack_15_Ch1, MusicTrack_15_Ch2, MusicTrack_15_Ch3, MusicTrack_15_Ch4

MusicDriver_TrackHeader_16:
    db $0f
    dw MusicTrack_16_Ch1, MusicTrack_16_Ch2, MusicTrack_16_Ch3, MusicTrack_16_Ch4

MusicDriver_TrackHeader_17:
    db $0f
    dw MusicTrack_17_Ch1, MusicTrack_17_Ch2, MusicTrack_17_Ch3, MusicTrack_17_Ch4

MusicDriver_TrackHeader_18:
    db $0f
    dw MusicTrack_18_Ch1, MusicTrack_18_Ch2, MusicTrack_18_Ch3, MusicTrack_18_Ch4

MusicDriver_TrackHeader_19:
    db $0f
    dw MusicTrack_19_Ch1, MusicTrack_19_Ch2, MusicTrack_19_Ch3, MusicTrack_19_Ch4

MusicDriver_TrackHeader_1A:
    db $0f
    dw MusicTrack_1A_Ch1, MusicTrack_1A_Ch2, MusicTrack_1A_Ch3, MusicTrack_1A_Ch4

MusicDriver_TrackHeader_1B:
    db $0f
    dw MusicTrack_1B_Ch1, MusicTrack_1B_Ch2, MusicTrack_1B_Ch3, MusicTrack_1B_Ch4

MusicDriver_TrackHeader_1C:
    db $0f
    dw MusicTrack_1C_Ch1, MusicTrack_1C_Ch2, MusicTrack_1C_Ch3, MusicTrack_1C_Ch4

MusicDriver_TrackHeader_1D:
    db $0f
    dw MusicTrack_1D_Ch1, MusicTrack_1D_Ch2, MusicTrack_1D_Ch3, MusicTrack_1D_Ch4

MusicDriver_TrackHeader_1E:
    db $0f
    dw MusicTrack_1E_Ch1, MusicTrack_1E_Ch2, MusicTrack_1E_Ch3, MusicTrack_1E_Ch4

MusicDriver_TrackHeader_1F:
    db $0f
    dw MusicTrack_1F_Ch1, MusicTrack_1F_Ch2, MusicTrack_1F_Ch3, MusicTrack_1F_Ch4

MusicDriver_TrackHeader_21:
    db $0f
    dw MusicTrack_21_Ch1, MusicTrack_21_Ch2, MusicTrack_21_Ch3, MusicTrack_21_Ch4

MusicDriver_TrackHeader_22:
    db $0f
    dw MusicTrack_22_Ch1, MusicTrack_22_Ch2, MusicTrack_22_Ch3, MusicTrack_22_Ch4

MusicDriver_TrackHeader_23:
    db $0f
    dw MusicTrack_23_Ch1, MusicTrack_23_Ch2, MusicTrack_23_Ch3, MusicTrack_23_Ch4

MusicDriver_TrackHeader_24:
    db $0f
    dw MusicTrack_24_Ch1, MusicTrack_24_Ch2, MusicTrack_24_Ch3, MusicTrack_24_Ch4

MusicDriver_TrackHeader_25:
    db $0f
    dw MusicTrack_25_Ch1, MusicTrack_25_Ch2, MusicTrack_25_Ch3, MusicTrack_25_Ch4

MusicDriver_TrackHeader_26:
    db $0f
    dw MusicTrack_26_Ch1, MusicTrack_26_Ch2, MusicTrack_26_Ch3, MusicTrack_26_Ch4

MusicDriver_TrackHeader_27:
    db $0f
    dw MusicTrack_27_Ch1, MusicTrack_27_Ch2, MusicTrack_27_Ch3, MusicTrack_27_Ch4

MusicDriver_TrackHeader_28:
    db $0f
    dw MusicTrack_28_Ch1, MusicTrack_28_Ch2, MusicTrack_28_Ch3, MusicTrack_28_Ch4

MusicDriver_TrackHeader_29:
    db $0f
    dw MusicTrack_29_Ch1, MusicTrack_29_Ch2, MusicTrack_29_Ch3, MusicTrack_29_Ch4

MusicDriver_TrackHeader_2A:
    db $0f
    dw MusicTrack_2B_Ch1, MusicTrack_2B_Ch2, MusicTrack_2B_Ch3, MusicTrack_2B_Ch4

; These four bytes are identical in the duplicated engine banks and also form
; valid stream prefixes in multiple bank-specific layouts. In canonical bank $04
; they are the first two commands of Track $09 Ch2; in bank $03 the same bytes
; prefix MusicTrack_20_Ch1. Keep the shared location explicit rather than
; duplicating or relocating the bytes.
MusicDriver_SharedBoundaryPrefix:
MusicTrack_09_Ch2:
MusicTrack_1E_Ch2:
MusicTrack_13_Ch2:
    music_duration_multiplier $01
    music_channel_routing $11

; Bank $04 Track $09. Ch2 begins at $580B inside the four-byte shared
; boundary prefix above; this section continues that stream at $580F, then
; follows the remaining retail physical stream order.

    assert @ == $580f
