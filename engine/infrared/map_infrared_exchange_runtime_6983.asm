include "macros/macros.inc"

; Map/Versus infrared state-exchange layer. This Bank-$0C frontend prepares the
; ROM0 infrared controller scratch ABI, serializes/deserializes selected-map
; state through a 4 KiB WRAM7 transfer buffer, and alternates send/receive
; ownership during an infrared battle.

DEF wSelectedMapCommandGateState EQU $c9b5
DEF wInfraredMapRefreshPending   EQU $c997

section "Map Infrared Exchange Runtime", romx[$6983], bank[$0c]

; Initialize the selected-map command gate from the current phase side and mark
; the selected map as an infrared battle.
MapInfrared_InitializeBattleState::
    push bc
    ld a, [wMapPhaseNumber]
    and $01
    jr nz, .side1
    ld a, $00
    ld [wSelectedMapCommandGateState], a
    jr .set_mode
.side1
    ld a, $01
    ld [wSelectedMapCommandGateState], a
.set_mode
    ld a, $01
    ld [wMapControlInfraredBattleMode], a
    pop bc
    ret

; A = initial transfer owner (0 send-first, 1 receive-first).
; Returns A=1 on a completed initial exchange and A=0 on failure/cancel, matching
; the Versus selection callers' existing retry convention.
MapInfrared_RunInitialStateExchange::
    ld [wSelectedMapCommandGateState], a
    call Audio_StopMusic
    ld a, [wSelectedMapCommandGateState]
    cp $01
    jr z, .receive_first
    call MapInfrared_SendInitialState
    and a
    jr z, .success
    jr .failure
.receive_first
    call MapInfrared_ReceiveInitialState
    and a
    jr z, .success
.failure
    xor a
    jr .fade
.success
    ld a, $01
.fade
    push af
    call FadeToWhite8
    pop af
    ret

; Exchange one turn-state payload according to the current gate owner, then
; toggle the owner only when the transfer succeeds. Returns 0 on success, 1 on
; failure. END/RECV selected-map commands use this directly.
MapInfrared_ExchangeTurnState::
    call Audio_StopMusic
    call FadeToWhite8
    ld a, [wSelectedMapCommandGateState]
    and a
    jr nz, .receive
    call MapInfrared_SendTurnState
    and a
    jr z, .failure
    jr .toggle
.receive
    call MapInfrared_ReceiveTurnState
    and a
    jr z, .failure
.toggle
    ld a, [wSelectedMapCommandGateState]
    xor $01
    ld [wSelectedMapCommandGateState], a
    xor a
    jr .finish
.failure
    ld a, $01
.finish
    push af
    call FadeToWhite8
    pop af
    ret

MapInfrared_SendInitialState::
    call MapInfrared_SerializeActiveMapToTransferBuffer
    call MapInfrared_Prepare4KiBTransfer
    ld a, $00
    ld [wInfraredPeerCompareByte], a
    ld a, $00
    ld [wInfraredTransferDirection], a
    farcall $18, InfraredController_Run
    ret

MapInfrared_ReceiveInitialState::
    call MapInfrared_Prepare4KiBTransfer
    ld a, $00
    ld [wInfraredPeerCompareByte], a
    ld a, $01
    ld [wInfraredTransferDirection], a
    farcall $18, InfraredController_Run
    and a
    jr z, .done
    call MapInfrared_DeserializeTransferBufferToActiveMap
    ld hl, wMapPhaseNumber
    inc [hl]
    ld hl, wMapSide1HQCoordinates
    ld a, [hli]
    ld b, a
    ld c, [hl]
    farcall $0b, MapViewport_CenterOnCoordinates
    ld a, $01
    ld [wInfraredMapRefreshPending], a
    ld a, $01
.done
    ret

MapInfrared_SendTurnState::
    call MapInfrared_SerializeActiveMapToTransferBuffer
    call MapInfrared_Prepare4KiBTransfer
    ld a, $01
    ld [wInfraredPeerCompareByte], a
    ld a, $00
    ld [wInfraredTransferDirection], a
    farcall $18, InfraredController_Run
    ret

MapInfrared_ReceiveTurnState::
    call MapInfrared_Prepare4KiBTransfer
    ld a, $01
    ld [wInfraredPeerCompareByte], a
    ld a, $01
    ld [wInfraredTransferDirection], a
    farcall $18, InfraredController_Run
    and a
    jr z, .done
    call MapInfrared_DeserializeTransferBufferToActiveMap
    ld a, $01
.done
    ret

; Configure the ROM0 infrared controller for a 4 KiB WRAM-bank-7 buffer at
; $D000. Direction/peer-compare fields are filled by the caller.
MapInfrared_Prepare4KiBTransfer::
    ld a, $00
    ld [wInfraredTransferBufferAddress], a
    ld a, $d0
    ld [wInfraredTransferBufferAddress + 1], a
    ld a, $07
    ld [wInfraredTransferBufferBank], a
    ld a, $00
    ld [wInfraredTransferLengthLo], a
    ld a, $10
    ld [wInfraredTransferLengthHi], a
    ret

; Serialize the active map into SRAM bank $0D, then copy its 4 KiB transfer
; image into WRAM7:$D000 for the infrared controller.
MapInfrared_SerializeActiveMapToTransferBuffer::
    push bc
    push de
    call SRAM_Enable
    ld a, $0d
    call SwitchSRAMBank
    ld hl, $a000
    farcall $13, MapSRAM_SerializeAtBase
    call SRAM_Enable
    ldh a, [hWRAMBank]
    push af
    ld a, $07
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, $a000
    ld hl, $d000
    ld bc, $1000
    call Memcpy
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    call SRAM_Disable
    pop de
    pop bc
    ret

; Copy WRAM7:$D000 into SRAM bank $0D, deserialize the transferred map into the
; active map state, then rebuild the map's derived counts/economy state.
MapInfrared_DeserializeTransferBufferToActiveMap::
    push bc
    push de
    call SRAM_Enable
    ld a, $0d
    call SwitchSRAMBank
    ldh a, [hWRAMBank]
    push af
    ld a, $07
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld de, $d000
    ld hl, $a000
    ld bc, $1000
    call Memcpy
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, $0d
    ld [wMapDataBank], a
    ld hl, $a524
    ld a, l
    ld [wMapDataPointer], a
    ld a, h
    ld [wMapDataPointer + 1], a
    call SRAM_Enable
    ld hl, $a000
    farcall $13, MapSRAM_DeserializeAtBase
    call SRAM_Disable
    farcall $0b, Bank0B_MapSetup_41F3
    farcall $0b, MapGrid_RebuildTileCountsAndHQCoordinates
    farcall $0b, MapEconomy_RecalculateIncome
    pop de
    pop bc
    ret

; Send a selected saved-map slot over infrared. The caller has selected the
; source slot in the ordinary Map SRAM frontend.
MapInfrared_SendSelectedMap::
    ld b, $07
    farcall $13, MapSRAM_LoadSlotToWRAMBank
    call MapInfrared_Prepare4KiBTransfer
    ld a, $02
    ld [wInfraredPeerCompareByte], a
    ld a, $00
    ld [wInfraredTransferDirection], a
    farcall $18, InfraredController_Run
    and a
    jr z, .failure
    xor a
    jr .done
.failure
    ld a, $01
.done
    ret

; A = destination saved-map slot. Receive a selected map into WRAM7 and commit
; it to that slot on successful transfer. Returns 0 on success, 1 on failure.
MapInfrared_ReceiveSelectedMap::
    ld c, a
    push bc
    call MapInfrared_Prepare4KiBTransfer
    ld a, $02
    ld [wInfraredPeerCompareByte], a
    ld a, $01
    ld [wInfraredTransferDirection], a
    farcall $18, InfraredController_Run
    pop bc
    and a
    jr z, .failure
    ld a, c
    ld b, $07
    farcall $13, MapSRAM_SaveSlotFromWRAMBank
    xor a
    jr .done
.failure
    ld a, $01
.done
    ret

    assert @ == $6b44
