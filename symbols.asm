include "constants/unit_constants.inc"
macro sym
    if \2 < $4000 && \1 == 0
        section "\3", rom0[\2]
    elif \2 < $8000
        section "\3", romx[\2], bank[\1]
    elif \2 < $a000
        section "\3", vram[\2], bank[\1]
    elif \2 < $c000
        section "\3", sram[\2], bank[\1]
    elif \2 < $d000 && \1 == 0
        section "\3", wram0[\2]
    elif \2 < $e000
        section "\3", wramx[\2], bank[\1]
    else
        section "\3", hram[\2]
    endc
\3::
endm

; Places text at a specific coordinate in the tilemap inmediately
; This function interprets newlines in the main charmap
; b = x coord, c = y coord, hl = text location

; Places text at a specific coordinate in the tilemap
; Uses the VBlank FIFO to delay blitting until vblank
; b = x coord, c = y coord, hl = text location

; Places text at a coordinate embedded in the data, using the coord_text macro
; Uses the VBlank FIFO to delay blitting until vblank
; hl = data location

; Writes a byte to the VBlank FIFO, to be later picked up during VBlank
; This function waits until there's enough space available
; a = byte to write

; Copies b bytes from hl into de in vram
; b = count, de = destination, hl = source

; Processes the next command in the VBlank FIFO

; Calls function in a different bank
; Operates on the three bytes following the "rst $28": bank, addr lo, addr hi

; Primary status byte exposed by the Mobile Adapter library in WRAM bank 7.
    sym $07, $d021, wMobileAdapterStatus

; Draws a single tile with attributes at $dc6d and increments the address
; a = tile, b = attributes, hl = address

; Clears a horizontal line in the name confirmation dialog

; Saved IE value used while LCD_Disable temporarily masks VBlank.
    sym $00, $c000, wInterruptEnableBackup

; Shared interrupt re-entry/busy flags. Bit 0 guards VBlank; bit 2 guards audio.
    sym $00, $c001, wInterruptBusyFlags

; Three-byte RAM interrupt trampolines used by the hardware vectors.
    sym $00, $c002, wLCDStatInterruptTrampoline
    sym $00, $c005, wTimerInterruptTrampoline
    sym $00, $c008, wVBlankInterruptTrampoline
    sym $00, $c00b, wJoypadInterruptTrampoline

; Set when sprite/OAM staging requires the HRAM DMA helper to run in VBlank.
    sym $00, $c00e, wOAMDMAPending

; Software mirror of LCDC committed by the sourced display/VBlank paths.
    sym $00, $c00f, wLCDC

; Hardware/model identifier supplied in A by the Game Boy boot ROM.
; $11 selects the CGB-specific startup presentation path.
    sym $00, $c010, wBootHardwareModel

; 160-byte shadow OAM source copied to FE00-FE9F by the HRAM DMA helper.
    sym $00, $c400, wShadowOAM

; 256-byte VBlank FIFO buffer.
    sym $00, $c300, wVBlankFIFO

; 16-bit pseudo-random seed advanced by Random_Advance.
    sym $00, $caac, wRandomSeed

; Map-menu action/cursor state used by the sourced bank-$13 menu code.
EXPORT DEF wMapMenuActionIndex EQU $dc36
EXPORT DEF wMapMenuCursorX EQU $dc38
EXPORT DEF wMapMenuCursorY EQU $dc39
EXPORT DEF wMapMenuAlternateActionIndex EQU $dc4d
EXPORT DEF wMapMenuCopyDestinationSlot EQU $dc30
EXPORT DEF wMapMenuConfirmChoice EQU $dc4e

; Per-map flag bitfields consumed by the Bank-$28 selection runtime.
; Their exact bit semantics remain unnamed, but their family ownership and
; required lengths are proven by the selector index ranges.
    sym $00, $c68d, wBeginnerMapFlags
    sym $00, $c68f, wCampaignMapFlags
    sym $00, $c695, wStandardMapFlags
    sym $00, $c69d, wCampaignMapSecondaryFlags

; Selected map-record state used by the Bank-$28 selector and ROM0 loader.
; wMapRecordFarPointer is bank + little-endian ROMX address. The 46-byte
; buffer contains header, display name, four map fields, width and height.
    sym $00, $ca1a, wMapRecordFarPointer
    sym $00, $ca1d, wMapRecordFlags
    sym $00, $ca1e, wMapRecordCategory
    sym $00, $ca1f, wMapRecordIndex
    sym $00, $ca21, wMapRecordBuffer
    ; Header byte $04: 8-bit additive checksum of the complete map body.
    sym $00, $ca25, wMapRecordChecksum
    ; Header byte $1F is zero in every retail record and has no direct retail
    ; consumer. Reserved by as the ninth-character sidecar.
    sym $00, $ca40, wMapRecordNameExtra
    sym $00, $ca41, wMapRecordName
    sym $00, $ca49, wMapRecordFields
    ; Four positional map parameters. Individual gameplay meanings remain
    ; deliberately unnamed pending sourced readers/writers.
    sym $00, $ca49, wMapRecordParameter0
    sym $00, $ca4a, wMapRecordParameter1
    sym $00, $ca4b, wMapRecordParameter2
    sym $00, $ca4c, wMapRecordParameter3
    sym $00, $ca4d, wMapRecordWidth
    sym $00, $ca4e, wMapRecordHeight

; Map Editor's in-memory record prefix. This mirrors the loaded map prefix:
; 32-byte header, name, four fields, width, and height. In retail the name is
; eight bytes, so the four fields begin immediately at $C8AD.
    sym $00, $c885, wEditorMapRecordBuffer
    ; Editor mirror of map header byte $04. SRAM serialization recomputes it.
    sym $00, $c889, wEditorMapRecordChecksum
    ; Mirrors wMapRecordNameExtra inside the editor-owned 32-byte header.
    sym $00, $c8a4, wEditorMapNameExtra
    sym $00, $c8a5, wEditorMapName
    sym $00, $c8ad, wEditorMapRecordFields
    sym $00, $c8ad, wEditorMapRecordParameter0
    sym $00, $c8ae, wEditorMapRecordParameter1
    sym $00, $c8af, wEditorMapRecordParameter2
    sym $00, $c8b0, wEditorMapRecordParameter3
    sym $00, $c8b1, wEditorMapRecordWidth
    sym $00, $c8b2, wEditorMapRecordHeight
    sym $00, $c8b3, wEditorMapFooter

; Map-name editing/caching buffers. keeps the retail base buffers
; in place and uses their former terminator byte as character 9 where possible;
; the following live byte is borrowed as a terminator only while rendering.
    sym $00, $cc2f, wTextInputBuffer
    ; Mode 2 reuses the retail terminator byte as character 9. $CC38 is
    ; temporarily zeroed only while rendering, then restored.
    sym $00, $cc37, wTextInputMapNameExtra
    sym $00, $cc65, wEditorMapNameDisplayScratch
    sym $00, $cc6d, wEditorMapNameDisplayExtra
    ; Scratch accumulator used while serializing a map-body checksum.
    sym $00, $cc88, wMapChecksumScratch
    sym $00, $cc89, wMapNameCache
    ; Cache byte 8 is character 9; the following index byte is temporarily
    ; zeroed during TextPut so it doubles as the terminator.
    sym $00, $cc91, wMapNameCacheExtra
    sym $00, $cc92, wMapNameCacheIndex

; Scratch owned by the blocking Bank $15 sprite exit-transition helpers.
; Each helper snapshots one sprite ID and its original perpendicular coordinate
; while advancing the other coordinate ten pixels per frame.
    sym $00, $cc9d, wSpriteTransitionRightObject
    sym $00, $cc9e, wSpriteTransitionRightX
    sym $00, $cc9f, wSpriteTransitionRightY
    sym $00, $cca0, wSpriteTransitionDownObject
    sym $00, $cca1, wSpriteTransitionDownX
    sym $00, $cca2, wSpriteTransitionDownY

; Destination-tile selector remembered by Gfx_UpdateCommonAnimatedTile and
; replayed by blocking presentation loops so the common UI keeps animating.
    sym $00, $cca8, wCommonAnimatedTileDestination

; 9-character map-name render scratch. The final byte in each layout is an
; independently live byte that the custom renderer saves, zeroes, and restores.
    sym $00, $cc6e, wEditorMapNameDisplayBorrowedTerminator
EXPORT DEF wMapMenuMapNameScratch EQU $dc3b
EXPORT DEF wMapMenuMapNameScratchExtra EQU $dc43
EXPORT DEF wMapMenuDownloadMapNumber EQU $dc44
EXPORT DEF wMapMenuMapNameScratchBorrowedTerminator EQU wMapMenuDownloadMapNumber
    sym $04, $db5a, wUnitStatusMapNameScratch
    sym $04, $db62, wUnitStatusMapNameScratchExtra
    sym $04, $db63, wUnitStatusMapNameScratchBorrowedTerminator

; Shared bank/address used by the common map-body loader. The pointer may
; reference either ROMX or SRAM depending on its high byte.
    sym $00, $c87e, wMapDataBank
    sym $00, $c87f, wMapDataPointer

; MM:SS session timer used by the Mobile Adapter VBlank mode.
    sym $00, $cad2, wMobileTimerFrames
    sym $00, $cad3, wMobileTimerSeconds
    sym $00, $cad4, wMobileTimerMinutes


; Shared music/SFX request state in WRAM bank 7.
; Track IDs below $2D are queued through MusicDriver_RequestTrack; bit 7 marks the
; current request as installed. The SFX request state is 2 while queued, 1 after
; dispatch to bank $08, and returns to 0 when SoundDriver_Stop finishes the SFX.
; The routing/wave fields below are shared by the music and SFX engines: SFX
; channel ownership protects hardware channels from music writes, while the
; wave-reload flag makes music restore its selected wave after either engine
; changes the wave-RAM contents.
    sym $00, $c100, wMusicSavedWRAMBank
    sym $00, $c101, wMusicUpdateSavedWRAMBank
    sym $00, $c102, wMusicTrackRequest
    sym $00, $c103, wMusicDataBank
    sym $00, $c104, wSFXRequestID
    sym $00, $c105, wSFXRequestState
    sym $00, $c106, wSFXRequestPriority
    sym $00, $c107, wSFXDataBank
    sym $00, $c108, wMusicRoutingShadow
    sym $00, $c109, wSFXRoutingShadow
    sym $00, $c10a, wMusicChannelDuty
    sym $00, $c10e, wMusicWavePatternIndex
    sym $00, $c10f, wWavePatternReloadPending
    sym $00, $c110, wSFXChannelMask
    sym $00, $c111, wMusicSnapshotRequest
    sym $00, $c112, wMusicChannelActive
    sym $00, $c116, wMusicChannelNoteState
    sym $00, $c11a, wMusicChannelStreamPointers
    sym $00, $c122, wMusicChannelSavedStreamPointers
    sym $00, $c12a, wMusicToneFrequency
    sym $00, $c130, wMusicNoiseRegisters
    sym $00, $c134, wMusicChannelOctave
    sym $00, $c13c, wMusicChannelNoteCode
    sym $00, $c140, wMusicChannelDuration
    sym $00, $c144, wMusicChannelGateLength
    sym $00, $c148, wMusicChannelGateCounter
    sym $00, $c14c, wMusicChannelOutputLevel
    sym $00, $c150, wMusicChannelPitchTranspose
    sym $00, $c154, wMusicChannelDurationMultiplier
    sym $00, $c158, wMusicChannelModulationSelector
    sym $00, $c15c, wMusicChannelModulationInitialSelector
    sym $00, $c160, wMusicChannelModulationPosition
    sym $00, $c164, wMusicChannelModulationPeriod
    sym $00, $c168, wMusicChannelModulationCounter
    sym $00, $c16c, wMusicChannelFrequencyTableIndex
    sym $00, $c174, wMusicTonePrimaryOutputLevel
    sym $00, $c177, wMusicChannelFrequencyOffset
    sym $00, $c17a, wMusicToneAlternateOutputLevel
    sym $00, $c17d, wMusicToneAlternateOutputPhase
    sym $00, $c180, wMusicToneAlternateOutputEnabled
    sym $00, $c183, wMusicPulse1Sweep
    sym $00, $c184, wMusicPulsePrimaryEnvelope
    sym $00, $c186, wMusicPulsePrimaryEnvelopeDelay
    sym $00, $c188, wMusicPulseAlternateEnvelope
    sym $00, $c18a, wMusicPulseAlternateEnvelopeDelay
    sym $00, $c18c, wMusicPulseEnvelopeCounter
    sym $00, $c18e, wMusicNoiseSequencePointer
    sym $00, $c190, wMusicNoiseSequenceActive
    sym $00, $c191, wMusicNoiseClockShiftOffset
    sym $00, $c192, wMusicRoutingMuteMask
    sym $00, $c193, wMusicMasterVolume
    sym $00, $c194, wMusicPaused
    sym $00, $c195, wMusicChannelLoopStatePointers
    sym $00, $c19d, wMusicChannelLoopState
    sym $00, $c1cd, wSFXChannelTrigger
    sym $00, $c1d1, wSFXChannelPitchDelta
    sym $00, $c1d5, wSFXChannelDelay
    sym $00, $c1d9, wSFXChannelFrequency
    sym $00, $c1e1, wSFXChannelLoopCount
    sym $00, $c1e5, wSFXChannelLoopPointers
    sym $00, $c1ed, wSFXChannelStreamPointers
    sym $00, $c1f5, wSFXActive
    sym $00, $c1f6, wSFXChannelMaskWork
    sym $00, $c1f7, wSFXUpdateMask

; Music-driver suspend/resume snapshot stored in WRAM bank 7.
; SaveState and RestoreState define this layout directly. Two four-byte source
; fields mirrored at $c21f and $c255 remain unnamed because their live meanings
; at $c138 and $c170 are still only initialized/snapshotted in sourced code.
    sym $00, $c1f8, wMusicSnapshotTrackRequest
    sym $00, $c1f9, wMusicSnapshotDataBank
    sym $00, $c1fa, wMusicSnapshotRoutingShadow
    sym $00, $c1fb, wMusicSnapshotChannelDuty
    sym $00, $c1ff, wMusicSnapshotWavePatternIndex
    sym $00, $c200, wMusicSnapshotWaveReloadPending
    sym $00, $c201, wMusicSnapshotChannelActive
    sym $00, $c205, wMusicSnapshotChannelNoteState
    sym $00, $c209, wMusicSnapshotChannelStreamPointers
    sym $00, $c211, wMusicSnapshotChannelSavedStreamPointers
    sym $00, $c219, wMusicSnapshotNoiseRegisters
    sym $00, $c21b, wMusicSnapshotChannelOctave
    sym $00, $c223, wMusicSnapshotChannelNoteCode
    sym $00, $c227, wMusicSnapshotChannelDuration
    sym $00, $c22b, wMusicSnapshotChannelGateLength
    sym $00, $c22f, wMusicSnapshotChannelGateCounter
    sym $00, $c233, wMusicSnapshotChannelOutputLevel
    sym $00, $c237, wMusicSnapshotChannelPitchTranspose
    sym $00, $c23b, wMusicSnapshotChannelDurationMultiplier
    sym $00, $c23f, wMusicSnapshotChannelModulationInitialSelector
    sym $00, $c243, wMusicSnapshotChannelModulationPeriod
    sym $00, $c247, wMusicSnapshotTonePrimaryOutputLevel
    sym $00, $c24a, wMusicSnapshotChannelFrequencyOffset
    sym $00, $c24d, wMusicSnapshotNoiseSequencePointer
    sym $00, $c24f, wMusicSnapshotNoiseSequenceActive
    sym $00, $c250, wMusicSnapshotNoiseClockShiftOffset
    sym $00, $c251, wMusicSnapshotChannelFrequencyTableIndex
    sym $00, $c259, wMusicSnapshotToneAlternateOutputLevel
    sym $00, $c25c, wMusicSnapshotToneAlternateOutputPhase
    sym $00, $c25f, wMusicSnapshotToneAlternateOutputEnabled
    sym $00, $c262, wMusicSnapshotPulse1Sweep
    sym $00, $c263, wMusicSnapshotPulseEnvelopeState
    sym $00, $c26d, wMusicSnapshotChannelLoopStatePointers
    sym $00, $c275, wMusicSnapshotChannelLoopState

; Shared decimal-rendering scratch used by the Bank $0B number renderers.
    sym $00, $cc45, wNumberRenderLeadingState
    sym $00, $cc46, wNumberRenderBuffer

; Per-side live unit counts. $CD09 is side 0 and $CD0A is side 1; Bank $12
; initial-unit placement indexes this two-byte array by encoded unit side bit 0.
    sym $00, $cd09, wUnitCountBySide
    sym $00, $c8b3, wUnitBuiltCountSide0
    sym $00, $c8b5, wUnitBuiltCountSide1
    sym $00, $c8b7, wUnitLostCountSide0
    sym $00, $c8b9, wUnitLostCountSide1
    sym $00, $c989, wMapGridWidth
    sym $00, $c98b, wMapViewportOriginX
    sym $00, $c98c, wMapViewportOriginY
    sym $00, $c98d, wMapCursorSpriteObjectId
    sym $00, $c98e, wMapCursorSpriteVariant
    sym $00, $c98f, wMapCursorOffsetX
    sym $00, $c990, wMapCursorOffsetY
    sym $00, $ca94, wMapControlWinningSide
    sym $00, $ca95, wMapControlResolutionType
    sym $00, $ca98, wMapControlSeenLiveUnitsFlags

; Move-selection status-overlay workspace. CA9A is the static overlay sprite
; object ID, CA9B-CA9E are the two created HP/fuel digit-object pairs, and
; CA9F/CAA0 are the snapshotted UnitRecord HP/fuel values displayed by them.
    sym $00, $ca9a, wUnitMoveStatusOverlayResource
    sym $00, $ca9b, wUnitMoveStatusHPDigitResources
    sym $00, $ca9d, wUnitMoveStatusFuelDigitResources
    sym $00, $ca9f, wUnitMoveStatusHP
    sym $00, $caa0, wUnitMoveStatusFuel
    sym $00, $caa1, wMetatileAttributeScratch

; Map-economy income scan scratch. CAA5 stages the first byte of the current
; three-byte WRAM-bank-1 analysis record; CAA6-CAA7 hold the 16-bit running
; sum for the selected property-tile set.
    sym $00, $caa5, wMapEconomyAnalysisRecordValue
    sym $00, $caa6, wMapEconomyAnalysisTotal

; ROM0 signed-division scratch. The divisor is stored little-endian at CAA9,
; CAAB is the 17-step long-division counter, and CAA8 tracks operand signs.
    sym $00, $caa8, wMathDivisionSignState
    sym $00, $caa9, wMathDivisionDivisor
    sym $00, $caab, wMathDivisionBitCount
    sym $00, $c98a, wMapGridHeight

; AI action/transport scratch. These are lifetime-scoped map-action
; fields shared by the Bank $0D dispatcher and Bank $0B load executor.
    sym $00, $c5ec, wMapAIActionCode
    sym $00, $c5ed, wMapAIActionX
    sym $00, $c5ee, wMapAIActionY
    sym $00, $c991, wMapActionTargetX
    sym $00, $c992, wMapActionTargetY
    sym $00, $c9d1, wUnitLoadTargetTypeSide
    sym $00, $c9d2, wUnitLoadTargetIndex
    sym $00, $c9d3, wCarriedChildSelectionIndex
    sym $00, $c9d8, wMapAIActiveUnitIndex
    sym $00, $c9e6, wUnitRankChangeTrackedIndex
    sym $00, $c9e7, wUnitRankChangeTrackedRank
    sym $00, $c9e8, wUnitSideExperienceRankTable

; Property purchase-choice scratch: count byte plus exactly 15 unit-type IDs.
    sym $00, $cd0b, wBuyableUnitCount
    sym $00, $cd0c, wBuyableUnitList

    sym $00, $cd33, wCarriedUnitListCount
    sym $00, $cd34, wCarriedUnitList
    sym $00, $cd3a, wAdjacentSupplyUnitCount
    sym $00, $cd3b, wAdjacentSupplyUnitList
    sym $00, $cd41, wUnitQuerySubjectIndex
    sym $00, $cd42, wUnitQuerySubjectTypeSide
    sym $00, $cd28, wUnitNameBuffer
    sym $00, $cd43, wMovementCostByMapTile
    sym $00, $ccdd, wUnitRecordScratch


; Advanced-sprite scheduler staging state (Bank $17).
    sym $00, $c4c7, wAdvancedSpriteProcessedCount
    sym $00, $c4c8, wAdvancedSpriteX
    sym $00, $c4ca, wAdvancedSpriteY
    sym $00, $c4cc, wAdvancedSpriteVelocityX
    sym $00, $c4ce, wAdvancedSpriteVelocityY
    sym $00, $c4d0, wAdvancedSpriteSlot
    sym $00, $c4d1, wAdvancedSpriteDelay
    sym $00, $c4d3, wAdvancedSpriteDuration
    sym $00, $c4d5, wAdvancedSpriteCallback
    sym $00, $c4d7, wAdvancedSpriteCallbackBank
    sym $00, $c4d8, wAdvancedSpriteUser0
    sym $00, $c4d9, wAdvancedSpriteUser1
    sym $00, $c4da, wAdvancedSpriteHideWhileActive
    sym $00, $c4de, wAdvancedSpritePendingCount
    sym $04, $d3ac, wAdvancedSpriteRecords
    sym $04, $db2c, wAdvancedSpriteCount
    sym $04, $db2d, wAdvancedSpriteIndex
    sym $04, $db2e, wAdvancedSpriteSpawnX
    sym $04, $db2f, wAdvancedSpriteSpawnY

; Current track shadow maintained by the fixed-bank audio front-end.
    sym $00, $cc87, wCurrentMusic

; Current screen palettes
    sym $00, $c4e0, wPals

; Fade/palette interpolation state.
    sym $00, $c520, wFadeOBJPaletteColor0Cache

; Palette upload parameters and shared fade state.
    sym $00, $c560, wPalsVBlankParam1
    sym $00, $c561, wPalsVBlankParam2
    sym $00, $c562, wPalsVBlankParam3
    sym $00, $c563, wFadeActive
    sym $00, $c564, wFadeStepsRemaining
    sym $00, $c565, wFadeComponentScratch
    sym $00, $c566, wFadeComponentCarryScratch
    sym $00, $c567, wFadeTargetPals

; Currently selected switchable ROM bank.
    sym $00, $ff80, hROMBank

; Software mirrors of the currently selected SRAM and WRAM banks.
    sym $00, $ff81, hSRAMBank
    sym $00, $ff82, hWRAMBank

; Software mirror of the currently selected CGB VRAM bank.
    sym $00, $ff83, hVRAMBank

; Incremented by the VBlank handler once per rendered frame.
    sym $00, $ff8e, hVBlankCounter

; Free-running timer-interrupt divider; audio is serviced every fourth tick.
    sym $00, $ff8f, hAudioUpdateDivider

; Software mirrors copied into hardware display registers each VBlank.
    sym $00, $ff95, hSCX
    sym $00, $ff96, hSCY
    sym $00, $ff97, hWX
    sym $00, $ff98, hWY

; HRAM OAM DMA routine installed by InstallOAMDMA during reset.
    sym $00, $ff84, hOAMDMA

; Joypad state used by the ROM0 input helpers.
    sym $00, $ff90, hJoyHeld
    sym $00, $ff91, hJoyPressed
    sym $00, $ff92, hJoyRepeat
    sym $00, $ff93, hJoyRepeatDelay
    sym $00, $ff94, hJoyRepeatRate



; Bank-$1A sprite lookup/graphics staging state.
    sym $00, $c4a0, wSpritePaletteVariant
    sym $00, $c4a3, wFarCopySourceBank
    sym $04, $d30f, wSpriteGroupGraphicsPointer
    sym $04, $d311, wSpriteGroupPalette0Pointer
    sym $04, $d313, wSpriteGroupPalette1Pointer
    sym $04, $d315, wSpriteGroupGraphicsSize
    sym $04, $d317, wSpriteGroupBank
    sym $04, $d318, wSpriteAnimationPointerScratch
    sym $04, $d31a, wSpriteAnimationBankScratch
    sym $04, $d33c, wUnitSpriteAnimationID
    sym $04, $d33d, wPresentationUnitAnimationIDScratch

; Fixed-bank sprite-object engine state. Objects live in WRAM bank 4 as
; 40 x 16-byte records, with a key table and linked ordering tables.
    sym $04, $d000, wSpriteObjects
    sym $04, $d280, wSpriteSlotKeys
    sym $04, $d2a8, wSpriteOrderPrefix
    sym $04, $d2aa, wSpriteNextSlots
    sym $04, $d2d2, wSpriteListHead
    sym $04, $d2d4, wSpritePrevSlots
    sym $04, $d2fc, wSpritePrevSentinels

; Sprite-engine HRAM scratch/state.
    sym $00, $ffb7, hSpriteCount
    sym $00, $ffb8, hSpriteAllocatedSlot
    sym $00, $ffb9, hSpriteCurrentSlot
    sym $00, $ffba, hSpriteCreateKey
    sym $00, $ffbb, hOAMEntriesFree
    sym $00, $ffbc, hPreviousOAMEntriesFree
    sym $00, $ffbd, hShadowOAMOffset
    sym $00, $ffbe, hSpriteFlags
    sym $00, $ffbf, hSpriteBaseY
    sym $00, $ffc0, hSpriteBaseX
    sym $00, $ffc1, hSpriteAttributes
    sym $00, $ffc2, hSpriteBaseTile
    sym $00, $ffc3, hSpritePieceY
    sym $00, $ffc4, hSpritePieceX
    sym $00, $ffc5, hSpritePieceTile
    sym $00, $ffc6, hSpritePieceAttributes
    sym $00, $ffc7, hSpritePiecesRemaining

; Head and tail pointers for the VBlank FIFO
    sym $00, $ffc8, hVBlankFIFO_Head
    sym $00, $ffc9, hVBlankFIFO_Tail
    sym $00, $ffca, hVBlankFIFO_Count  ; Amount of commands in the fifo
    sym $00, $ffcb, hVBlankFIFO_Bank  ; Bank to copy data to

; Map-screen incremental redraw state used by BasicMapTileUpdate.
    sym $00, $ffac, hMapTileUpdateFlags
    sym $00, $ffad, hMapTileUpdateX
    sym $00, $ffae, hMapTileUpdateY
    sym $00, $ffaf, hMapTileUpdateCount

; Target scanline used while the map/action UI animates the window boundary.
    sym $00, $ffb0, hLCDScanlineTarget

; Gameplay-map terrain animation state. Bit 0 enables periodic updates;
; the timer runs through a 90-frame, three-phase cycle.
    sym $00, $ffb1, hMapAnimationFlags
    sym $00, $ffb2, hMapAnimationTimer

; Active game mode used by map setup/save/menu paths.
EXPORT DEF wActiveGameMode EQU $c62f
EXPORT DEF wTwoChoicePromptState EQU $dc69
EXPORT DEF wMapControlForceStateMode EQU $c686
EXPORT DEF wUnitPurchaseAllowedListSelector EQU $c6a3

    sym $00, $c4ad, wBattleUnitSide
    sym $00, $c4ae, wBattleUnitSideAlt
    sym $00, $c4b3, wBattlePlaceRowSide0
    sym $00, $c4b4, wBattlePlaceRowSide1
    sym $00, $c4db, wBattleSceneResourceIndex
EXPORT DEF wAdvancedSpriteActivationSfx EQU wBattleSceneResourceIndex
EXPORT DEF wBattlePlacePointerVariant EQU $db30

; Reserve-unit compact state. Bank $12:$47CE stores/restores 50 x 4-byte
; entries corresponding to side-0 live-unit slots.

; Bank $12 purchase/promotion runtime is source-backed in engine/unit/unit_setup.asm.

; ROM0 arithmetic cluster $29AD-$2A81 is source-backed in home_arithmetic_core.asm
; and AddAtoHL in home_map.asm.

; Bank $12 weapon/unit-list staging immediately following the sourced reserve
; routines. These are symbol-only overlay anchors until baserom.gbc is restored.

; Bank $0B post-action map-control continuation. source-backs $6D18-$6D68;

; Bank $0C battle Cover/rank/multiplier/stat-scaling core through $4A25 is
; source-backed in engine/battle/battle_combat_runtime.asm. The following HP/order/EXP
; routines remain overlay anchors pending the next byte-authoritative tranche.

; Physical Bank $0D map-control / active-force helpers are source-backed in
; engine/map/ai/map_control_force.asm. corrects the older Bank $14 attribution.

; Shared RAM used by the overlay-owned weapon summary and unit-list staging
; paths above. $CD28 is the already-named shared name buffer.
EXPORT DEF wUnitWeaponSummaryBuffer EQU $cced
EXPORT DEF wUnitWeaponSummary0 EQU wUnitWeaponSummaryBuffer
EXPORT DEF wUnitWeaponSummary0Name EQU wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_NAME_SIZE * 0
EXPORT DEF wUnitWeaponSummary0WeaponID EQU wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_WEAPON_ID_OFFSET
EXPORT DEF wUnitWeaponSummary0CurrentAmmo EQU wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_CURRENT_AMMO_OFFSET
EXPORT DEF wUnitWeaponSummary0MinRange EQU wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_MIN_RANGE_OFFSET
EXPORT DEF wUnitWeaponSummary0MaxRange EQU wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_MAX_RANGE_OFFSET
EXPORT DEF wUnitWeaponSummary0MaxAmmo EQU wUnitWeaponSummary0 + UNIT_WEAPON_SUMMARY_MAX_AMMO_OFFSET
EXPORT DEF wUnitWeaponSummary1 EQU wUnitWeaponSummaryBuffer + UNIT_WEAPON_SUMMARY_SLOT1_OFFSET
EXPORT DEF wUnitWeaponSummary1Name EQU wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_NAME_SIZE * 0
EXPORT DEF wUnitWeaponSummary1WeaponID EQU wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_WEAPON_ID_OFFSET
EXPORT DEF wUnitWeaponSummary1CurrentAmmo EQU wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_CURRENT_AMMO_OFFSET
EXPORT DEF wUnitWeaponSummary1MinRange EQU wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_MIN_RANGE_OFFSET
EXPORT DEF wUnitWeaponSummary1MaxRange EQU wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_MAX_RANGE_OFFSET
EXPORT DEF wUnitWeaponSummary1MaxAmmo EQU wUnitWeaponSummary1 + UNIT_WEAPON_SUMMARY_MAX_AMMO_OFFSET
EXPORT DEF wUnitListScratch EQU $d640
EXPORT DEF wReserveUnitList EQU $c6a8

; typed bounds for the Bank $12 temporary unit-list workspace.
EXPORT DEF wUnitListScratchFirst EQU wUnitListScratch
EXPORT DEF wUnitListScratchLast EQU wUnitListScratch + UNIT_LIST_SCRATCH_LAST_RECORD_OFFSET
EXPORT DEF wUnitListScratchEnd EQU wUnitListScratch + UNIT_LIST_SCRATCH_SIZE

; shared map-action effect sprite slot scratch.
EXPORT DEF wMapEffectSpriteObjectId EQU $c998

; battle-stat RAM workspace. The field identities and address geometry
; are reference-backed and intentionally do not claim the overlay-owned Bank $13
; producer/consumer instruction bytes.
EXPORT DEF wBattleAttackerUnitID EQU $dbc8
EXPORT DEF wBattleDefenderUnitID EQU $dbc9

EXPORT DEF wBattleAttackerStats EQU $dbca
EXPORT DEF wBattleAttackerUnitType EQU wBattleAttackerStats + BATTLE_STATS_UNIT_TYPE_OFFSET
EXPORT DEF wBattleAttackerOldHP EQU wBattleAttackerStats + BATTLE_STATS_OLD_HP_OFFSET
EXPORT DEF wBattleAttackerNewHPA EQU wBattleAttackerStats + BATTLE_STATS_NEW_HP_A_OFFSET
EXPORT DEF wBattleAttackerTerrain EQU wBattleAttackerStats + BATTLE_STATS_TERRAIN_OFFSET
EXPORT DEF wBattleAttackerUsedWeapon EQU wBattleAttackerStats + BATTLE_STATS_USED_WEAPON_OFFSET
EXPORT DEF wBattleAttackerFocus EQU wBattleAttackerStats + BATTLE_STATS_FOCUS_OFFSET
EXPORT DEF wBattleAttackerX EQU wBattleAttackerStats + BATTLE_STATS_X_OFFSET
EXPORT DEF wBattleAttackerY EQU wBattleAttackerStats + BATTLE_STATS_Y_OFFSET
EXPORT DEF wBattleAttackerUnitFamily EQU wBattleAttackerStats + BATTLE_STATS_UNIT_FAMILY_OFFSET
EXPORT DEF wBattleAttackerNewHPB EQU wBattleAttackerStats + BATTLE_STATS_NEW_HP_B_OFFSET
EXPORT DEF wBattleAttackerAttack EQU wBattleAttackerStats + BATTLE_STATS_ATTACK_OFFSET
EXPORT DEF wBattleAttackerDefense EQU wBattleAttackerStats + BATTLE_STATS_DEFENSE_OFFSET
EXPORT DEF wBattleAttackerCover EQU wBattleAttackerStats + BATTLE_STATS_COVER_OFFSET
EXPORT DEF wBattleAttackerRankValue EQU wBattleAttackerStats + BATTLE_STATS_RANK_VALUE_OFFSET
EXPORT DEF wBattleAttackerFlank EQU wBattleAttackerStats + BATTLE_STATS_FLANK_OFFSET
EXPORT DEF wBattleAttackerSupport EQU wBattleAttackerStats + BATTLE_STATS_SUPPORT_OFFSET
EXPORT DEF wBattleAttackerTotalAttack EQU wBattleAttackerStats + BATTLE_STATS_TOTAL_ATTACK_OFFSET
EXPORT DEF wBattleAttackerTotalDefense EQU wBattleAttackerStats + BATTLE_STATS_TOTAL_DEFENSE_OFFSET
EXPORT DEF wBattleAttackerWeaponChoice EQU wBattleAttackerStats + BATTLE_STATS_WEAPON_CHOICE_OFFSET

EXPORT DEF wBattleDefenderStats EQU wBattleAttackerStats + BATTLE_STATS_PARTICIPANT_RECORD_SIZE
EXPORT DEF wBattleDefenderUnitType EQU wBattleDefenderStats + BATTLE_STATS_UNIT_TYPE_OFFSET
EXPORT DEF wBattleDefenderOldHP EQU wBattleDefenderStats + BATTLE_STATS_OLD_HP_OFFSET
EXPORT DEF wBattleDefenderNewHPA EQU wBattleDefenderStats + BATTLE_STATS_NEW_HP_A_OFFSET
EXPORT DEF wBattleDefenderTerrain EQU wBattleDefenderStats + BATTLE_STATS_TERRAIN_OFFSET
EXPORT DEF wBattleDefenderUsedWeapon EQU wBattleDefenderStats + BATTLE_STATS_USED_WEAPON_OFFSET
EXPORT DEF wBattleDefenderFocus EQU wBattleDefenderStats + BATTLE_STATS_FOCUS_OFFSET
EXPORT DEF wBattleDefenderX EQU wBattleDefenderStats + BATTLE_STATS_X_OFFSET
EXPORT DEF wBattleDefenderY EQU wBattleDefenderStats + BATTLE_STATS_Y_OFFSET
EXPORT DEF wBattleDefenderUnitFamily EQU wBattleDefenderStats + BATTLE_STATS_UNIT_FAMILY_OFFSET
EXPORT DEF wBattleDefenderNewHPB EQU wBattleDefenderStats + BATTLE_STATS_NEW_HP_B_OFFSET
EXPORT DEF wBattleDefenderAttack EQU wBattleDefenderStats + BATTLE_STATS_ATTACK_OFFSET
EXPORT DEF wBattleDefenderDefense EQU wBattleDefenderStats + BATTLE_STATS_DEFENSE_OFFSET
EXPORT DEF wBattleDefenderCover EQU wBattleDefenderStats + BATTLE_STATS_COVER_OFFSET
EXPORT DEF wBattleDefenderRankValue EQU wBattleDefenderStats + BATTLE_STATS_RANK_VALUE_OFFSET
EXPORT DEF wBattleDefenderFlank EQU wBattleDefenderStats + BATTLE_STATS_FLANK_OFFSET
EXPORT DEF wBattleDefenderSupport EQU wBattleDefenderStats + BATTLE_STATS_SUPPORT_OFFSET
EXPORT DEF wBattleDefenderTotalAttack EQU wBattleDefenderStats + BATTLE_STATS_TOTAL_ATTACK_OFFSET
EXPORT DEF wBattleDefenderTotalDefense EQU wBattleDefenderStats + BATTLE_STATS_TOTAL_DEFENSE_OFFSET
EXPORT DEF wBattleDefenderWeaponChoice EQU wBattleDefenderStats + BATTLE_STATS_WEAPON_CHOICE_OFFSET

; transient battle-calculation scratch. These bytes are reused by
; different helpers, so aliases describe their lifetime-specific roles.
EXPORT DEF wBattleSupportTargetUnitID EQU $c941
EXPORT DEF wBattleWeaponRangeScratch EQU $c942
EXPORT DEF wBattleContextUnitID EQU $c943
EXPORT DEF wBattleFlankDirectionMask EQU $c944
EXPORT DEF wBattleSupportAccumulator EQU $c944

; Unit Status HP-transfer lifetime. These aliases intentionally share
; the same physical bytes as the battle scratch above; they are valid only
; while the Bank $0B/$25 HP-transfer action is active.
EXPORT DEF wUnitTransferTargetUnitID EQU $c941
EXPORT DEF wUnitTransferSourceHP EQU $c942
EXPORT DEF wUnitTransferTargetHP EQU $c943
EXPORT DEF wUnitTransferMaxHP EQU $c944

EXPORT DEF wBattleOtherX EQU $dbf4
EXPORT DEF wBattleOtherY EQU $dbf5
EXPORT DEF wBattleStatsWorkspaceEnd EQU $dbf6
EXPORT DEF wBattleDistance EQU $dbf6
EXPORT DEF wBattleAttackOrderState EQU $dbf6

; campaign medal/statistics runtime. The older Bank $18 anchors were a
; DataCrystal block-number attribution error; the executable labels now live in
; engine/campaign/campaign_medal_statistics_runtime.asm at physical Bank $11.

EXPORT DEF wCampaignDestroyedLiteLand EQU $c770
EXPORT DEF wCampaignDestroyedArmor EQU $c772
EXPORT DEF wCampaignDestroyedAir EQU $c774
EXPORT DEF wCampaignDestroyedShip EQU $c776
EXPORT DEF wCampaignCapturedProperties EQU $c778
EXPORT DEF wCampaignDevelopedProperties EQU $c77a
EXPORT DEF wCampaignDeclinedYields EQU $c77c
EXPORT DEF wCampaignProcuredUnitFlags EQU $c77d
EXPORT DEF wCampaignMapClearCounts EQU $c784
EXPORT DEF wCampaignProcuredUnitFlagsEnd EQU $c784
EXPORT DEF wCampaignMapClearCountsEnd EQU $c7b1
EXPORT DEF wCampaignStatisticsEnd EQU $c7b1

; map control / phase / economy workspace. These RAM identities and
; the two setup entry-point ranges are reference-backed contracts only; no new
; overlay-owned ROM bytes are claimed without baserom.gbc.
EXPORT DEF wMapSide0Control EQU $c631
EXPORT DEF wMapSide1Control EQU $c632
EXPORT DEF wMapPhaseNumber EQU $c633
EXPORT DEF wMapSide0Gold EQU $c634
EXPORT DEF wMapSide1Gold EQU $c637
EXPORT DEF wMapSide0Materials EQU $c63a
EXPORT DEF wMapSide1Materials EQU $c63c
EXPORT DEF wMapSide0GoldIncomeDiv10 EQU $c63e
EXPORT DEF wMapSide1GoldIncomeDiv10 EQU $c640
EXPORT DEF wMapSide0MaterialsIncome EQU $c642
EXPORT DEF wMapSide1MaterialsIncome EQU $c644
EXPORT DEF wMapSide0HQCoordinates EQU $c646
EXPORT DEF wMapSide1HQCoordinates EQU $c648
EXPORT DEF wMapTileCountsById EQU $c64a
EXPORT DEF wMapSide0HQTileCount EQU $c64b
EXPORT DEF wMapSide1HQTileCount EQU $c656
EXPORT DEF wMapControlEconomyEnd EQU wMapTileCountsById ; compatibility alias for the end of the preceding economy block

; map-control phase-analysis workspace (WRAM bank 2 lifetime).
; These coordinates/flags are valid only while MapControl_RefreshPhaseState and
; its analysis/search helpers are active. proves the first pair is a
; river cell encountered while backtracking a shortest DUMMY-profile route from
; the opposing HQ toward the current HQ. The older ReferenceCell aliases remain
; for compatibility with older tooling.
EXPORT DEF wMapControlRouteRiverX EQU $de9a
EXPORT DEF wMapControlRouteRiverY EQU $de9b
EXPORT DEF wMapControlReferenceCellX EQU wMapControlRouteRiverX ; compatibility alias
EXPORT DEF wMapControlReferenceCellY EQU wMapControlRouteRiverY ; compatibility alias
EXPORT DEF wMapControlTransportPortX EQU $de9c
EXPORT DEF wMapControlTransportPortY EQU $de9d
EXPORT DEF wMapControlPortCandidateX EQU wMapControlTransportPortX ; compatibility alias
EXPORT DEF wMapControlPortCandidateY EQU wMapControlTransportPortY ; compatibility alias
EXPORT DEF wMapControlPrimaryCandidateX EQU wMapControlTransportPortX ; compatibility alias
EXPORT DEF wMapControlPrimaryCandidateY EQU wMapControlTransportPortY ; compatibility alias
EXPORT DEF wMapControlTransportApproachX EQU $de9e
EXPORT DEF wMapControlTransportApproachY EQU $de9f
EXPORT DEF wMapControlOpposingHQRegionCandidateX EQU wMapControlTransportApproachX ; compatibility alias
EXPORT DEF wMapControlOpposingHQRegionCandidateY EQU wMapControlTransportApproachY ; compatibility alias
EXPORT DEF wMapControlSecondaryCandidateX EQU wMapControlTransportApproachX ; compatibility alias
EXPORT DEF wMapControlSecondaryCandidateY EQU wMapControlTransportApproachY ; compatibility alias
EXPORT DEF wMapControlPhaseAnalysisFlags EQU $dea0

; Persisted property-state records in WRAM bank 1. $DD80 is the active record
; count; $DD81 contains 100 three-byte {state, X, Y} entries through $DEAC.
; The same CPU addresses are reused for unrelated AI arrays in WRAM bank 2.
EXPORT DEF wMapPropertyStateRecordCount EQU $dd80
EXPORT DEF wMapPropertyStateRecords EQU $dd81
EXPORT DEF wMapPropertyStateRecordsEnd EQU $dead
EXPORT DEF wMapEconomyAnalysisRecords EQU wMapPropertyStateRecords ; compatibility alias
EXPORT DEF wMapEconomyAnalysisRecordsEnd EQU wMapPropertyStateRecordsEnd ; compatibility alias

; Bank $0D AI procurement-planning scratch (WRAM bank 2 lifetime).
; The two 52-byte arrays cover every real UnitData type (0-51); DUMMY (52) is
; excluded. The packed output immediately follows its count and occupies exactly
; 52 type/count pairs through $DE55.
EXPORT DEF wMapAIActiveUnitCountsByType EQU $dd81
EXPORT DEF wMapAIDesiredUnitCountsByType EQU $ddb5
EXPORT DEF wMapAIDesiredUnitCountsEnd EQU $dde9
EXPORT DEF wMapAICategoryThreshold0 EQU $dde9
EXPORT DEF wMapAICategoryThreshold1 EQU $ddea
EXPORT DEF wMapAICategoryThreshold2 EQU $ddeb
EXPORT DEF wMapAICategoryThreshold3 EQU $ddec
EXPORT DEF wMapAIProcurementEntryCount EQU $dded
EXPORT DEF wMapAIProcurementEntries EQU $ddee
EXPORT DEF wMapAIProcurementEntriesEnd EQU $de56
EXPORT DEF wMapAICompositionFlags EQU $de56
EXPORT DEF wMapAISecondaryUnitCountsByType EQU $de57

    sym $12, $411b, MapEconomy_InitializeStartingResources
    sym $12, $415f, MapEconomy_StoreStartingGold
    sym $12, $416d, MapEconomy_StoreStartingMaterials

; Infrared feature controller lifetime aliases ($C61A-$C622).
; This scratch range is reused by later Bank $25/$33 features; these names are
; valid while the ROM0 infrared controller is active and do not claim global
; ownership of the underlying WRAM bytes.
EXPORT DEF wInfraredControllerState EQU $c61a
EXPORT DEF wInfraredSessionSelector EQU $c61b
EXPORT DEF wInfraredPeerCompareByte EQU $c61c
EXPORT DEF wInfraredTransferDirection EQU $c61d
EXPORT DEF wInfraredTransferBufferAddress EQU $c61e
EXPORT DEF wInfraredTransferLengthLo EQU $c620
EXPORT DEF wInfraredTransferLengthHi EQU $c621
EXPORT DEF wInfraredTransferBufferBank EQU $c622

; Bank $25 Unit Status selection-controller lifetime aliases.
; These overlap the infrared-controller scratch only by physical address.
EXPORT DEF wUnitStatusCursorSpriteIndex EQU $c61a
EXPORT DEF wUnitStatusInitialSelectionValue EQU $c622

; Bank $25 Unit Status lifetime aliases over the same shared scratch window.
; These names must not be used as global ownership claims outside Unit Status.
EXPORT DEF wUnitStatusTypeSide EQU $c61b
EXPORT DEF wUnitStatusHP EQU $c61c
EXPORT DEF wUnitStatusFuel EQU $c61d
EXPORT DEF wUnitStatusRank EQU $c61e
EXPORT DEF wUnitStatusPaneSide EQU $c61f
EXPORT DEF wUnitStatusPaneXOffset EQU $c620
; Compatibility alias from the initial Bank $25 lifetime audit.
EXPORT DEF wUnitStatusPaneRowBase EQU wUnitStatusPaneXOffset
EXPORT DEF wUnitStatusSelectedUnitIndex EQU $c621
EXPORT DEF wUnitStatusCursorSpriteID EQU $c61a
EXPORT DEF wUnitStatusInitialLeftValue EQU $c622

; Bank $25 Campaign map-selector lifetime aliases over the same shared scratch.
; These names are valid only while the 45-map Campaign selector is active.
EXPORT DEF wCampaignMapSelectPage EQU $c61a
EXPORT DEF wCampaignMapSelectMapIndexScratch EQU $c61b
EXPORT DEF wCampaignMapSelectCellScratch EQU $c61c
EXPORT DEF wCampaignMapSelectCursorSpriteID EQU $c61d
EXPORT DEF wCampaignMapSelectConfirmEnabled EQU $c61e
EXPORT DEF wCampaignMapSelectRow EQU $c61f
EXPORT DEF wCampaignMapSelectColumn EQU $c620
EXPORT DEF wCampaignMapSelectEntryMapIndex EQU $c621

; Bank $25 map/tutorial briefing-viewer lifetime aliases. These overlap the
; infrared, Unit Status, and Campaign-selector scratch only by physical address.

; Bank $25 map briefing/message viewer lifetime aliases over shared WRAM.
; These names apply only while the briefing viewer is active.
EXPORT DEF wMapBriefingGroup EQU $c61a
EXPORT DEF wMapBriefingInputState EQU $c61b
EXPORT DEF wMapBriefingTextBankState EQU $c61c
EXPORT DEF wMapBriefingIntroBankState EQU wMapBriefingTextBankState ; compatibility alias
EXPORT DEF wMapBriefingIntroExtensionActive EQU wMapBriefingTextBankState ; compatibility alias
EXPORT DEF wMapBriefingDisplayVariant EQU $c61d
EXPORT DEF wMapBriefingMapIndex EQU $c622

EXPORT DEF MAP_BRIEFING_GROUP_CAMPAIGN_PRE EQU 0
EXPORT DEF MAP_BRIEFING_GROUP_BEGINNER EQU 1
EXPORT DEF MAP_BRIEFING_GROUP_CAMPAIGN_RESULT_A EQU 2
EXPORT DEF MAP_BRIEFING_GROUP_CAMPAIGN_RESULT_B EQU 3



