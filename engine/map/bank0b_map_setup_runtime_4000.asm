include "macros/macros.inc"

; Early Bank $0B map/setup runtime.
; Executable regions are mnemonic; the $4078-$4087 resource table remains data.

section "Bank $0B map/setup frontend", romx[$4000], bank[$0b]
Bank0B_MapSetupFrontend4000::
    farcall $01, MapGraphics_LoadGameplayAssets
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    call $4621
    farcall $0c, MapActionEffect_LoadGraphics
    call Bank0B_MapSetup_403E
    call Bank0B_MapSetup_4057
    call $06f2
    farcall $10, UIWindowStack_Init
    ld a, $ab
    farcall $10, UIWindowStack_SetBorderTile
    xor a
    farcall $10, UIWindowStack_SetAttributes
    xor a
    ld [$ffcb], a
    call $2e67
    call $4634
    call MapSetup_ResetRuntimeScratchToFF
    call MapPresentation_ResetTileUpdateAndAnimationState
    ld a, $02
    ldh [$ff94], a
    ret
Bank0B_MapSetup_403E:
    ld a, $00
    ld b, $01
    ld c, $01
    ld hl, $5118
    call $06d9
    ld a, $01
    ld b, $06
    ld c, $01
    ld hl, $5868
    call $06d9
    ret
Bank0B_MapSetup_4057:
    ld a, $08
    ld b, $01
    ld c, $01
    ld hl, $5118
    call $06d9
    ld a, $09
    ld b, $01
    ld hl, $4078
    call $06bc
    ld a, $0a
    ld b, $03
    ld hl, $1c54
    call $06bc
    ret
    assert @ == $4078

section "Bank $0B map/setup resource table", romx[$4078], bank[$0b]
Bank0B_MapSetupResourceTable4078::
    db $ff, $7f, $1b, $00, $ff, $7f, $9f, $41
    db $00, $00, $80, $69, $ff, $7f, $c0, $72
    assert @ == $4088

section "Selected-map setup runtime", romx[$4088], bank[$0b]
MapRuntime_PrepareSelectedMapState::
    ld de, $ca1a
    ld hl, $c87e
    ld bc, $0035
    call Memcpy
    farcall $12, UnitRecords_ClearAllAndCounts
    call $1614
    call Bank0B_MapSetup_41F3
    farcall $0c, PropertyState_RebuildRecordsFromMap
    call MapGrid_RebuildTileCountsAndHQCoordinates
    call $7c2f
    call Bank0B_MapSetup_411B
    xor a
    ld [$c633], a
    ld a, [$c633]
    and $01
    add a, a
    ld hl, wMapSide0HQCoordinates
    call $29bc
    ld a, [hli]
    ld b, a
    ld c, [hl]
    call $7acb
    ld a, $00
    ld [$c997], a
    ld hl, $c8b3
    ld bc, $0008
    xor a
    call $3b79
    call MapControl_StageForceStateModeFromGameMode
    farcall $11, CampaignStats_ClearProcuredFlag36
    farcall $11, CampaignStats_ClearProcuredFlag35
    call Bank0B_MapSetup_40E3
    farcall $11, CampaignStats_RunSetupDispatcher
    ret
Bank0B_MapSetup_40E3:
    ld a, [$c62f]
    cp $01
    ret nz
    farcall $12, ReserveUnits_RestoreSide0
    ret
Bank0B_MapSetup_40EE::
    push af
    ld de, $ca1a
    ld hl, $c87e
    ld bc, $0035
    call Memcpy
    pop af
    farcall $13, MapSRAM_DeserializeSlot
    call Bank0B_MapSetup_41F3
    call MapGrid_RebuildTileCountsAndHQCoordinates
    call $7c2f
    ld a, $01
    ld [$c997], a
    ld de, $c87e
    ld hl, $ca1a
    ld bc, $0035
    call Memcpy
    ret
Bank0B_MapSetup_411B:
    xor a
    ld [$c634], a
    ld [$c635], a
    ld [$c636], a
    ld [$c637], a
    ld [$c638], a
    ld [$c639], a
    ld [$c63a], a
    ld [$c63b], a
    ld [$c63c], a
    ld [$c63d], a
    ld [$c633], a
    ld a, [$c8ad]
    ld e, a
    call Bank0B_MapSetup_415F
    ld a, [$c8af]
    ld e, a
    call Bank0B_MapSetup_416D
    ld a, $01
    ld [$c633], a
    ld a, [$c8ae]
    ld e, a
    call Bank0B_MapSetup_415F
    ld a, [$c8b0]
    ld e, a
    call Bank0B_MapSetup_416D
    ret
Bank0B_MapSetup_415F:
    ld d, $00
    ld bc, $03e8
Bank0B_MapSetup_4164:
    call $7b6f
    dec bc
    ld a, b
    or c
    jr nz, Bank0B_MapSetup_4164
    ret
Bank0B_MapSetup_416D:
    ld d, $00
    ld c, $0a
Bank0B_MapSetup_4171:
    call $7bec
    dec c
    jr nz, Bank0B_MapSetup_4171
    ret
    assert @ == $4178

section "Shared map/editor setup runtime", romx[$4178], bank[$0b]
; Re-scan every active map cell, rebuilding the 52-entry raw-tile count table and
; caching the coordinates of the two HQ tiles ($01/$0C).
MapGrid_RebuildTileCountsAndHQCoordinates::
MapSetup_Runtime4178:: ; compatibility alias
    push bc
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, $ff
    ld [wMapSide0HQCoordinates], a
    ld [wMapSide0HQCoordinates + 1], a
    ld [wMapSide1HQCoordinates], a
    ld [wMapSide1HQCoordinates + 1], a
    ld hl, wMapTileCountsById
    ld bc, $0034
    xor a
    call $3b79
    ld c, $00
Bank0B_MapSetup_419D:
    ld b, $00
    call $15f8
Bank0B_MapSetup_41A2:
    ld a, [hli]
    and $3f
    call MapGrid_RecordSetupTile
    inc b
    ld a, [wMapGridWidth]
    cp b
    jr nz, Bank0B_MapSetup_41A2
    inc c
    ld a, [wMapGridHeight]
    cp c
    jr nz, Bank0B_MapSetup_419D
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop bc
    ret
; A = raw map tile ID masked to six bits, B/C = map coordinates.
MapGrid_RecordSetupTile:
    push af
    push hl
    call MapGrid_IncrementTileCount
    cp MAP_TILE_SIDE0_HQ
    jr z, Bank0B_MapSetup_41CD
    cp MAP_TILE_SIDE1_HQ
    jr z, Bank0B_MapSetup_41D2
    jr Bank0B_MapSetup_41D8
Bank0B_MapSetup_41CD:
    ld hl, wMapSide0HQCoordinates
    jr Bank0B_MapSetup_41D5
Bank0B_MapSetup_41D2:
    ld hl, wMapSide1HQCoordinates
Bank0B_MapSetup_41D5:
    ld [hl], b
    inc hl
    ld [hl], c
Bank0B_MapSetup_41D8:
    pop hl
    pop af
    ret
; Increment the count for raw tile ID A.
MapGrid_IncrementTileCount::
    push af
    push hl
    ld hl, wMapTileCountsById
    call $29bc
    inc [hl]
    pop hl
    pop af
    ret
; Decrement the count for raw tile ID A. Used by later terrain mutation paths.
MapGrid_DecrementTileCount::
    push af
    push hl
    ld hl, wMapTileCountsById
    call $29bc
    dec [hl]
    pop hl
    pop af
    ret
Bank0B_MapSetup_41F3::
    ldh a, [hWRAMBank]
    push af
    xor a
    ld [wUnitCountBySide], a
    ld [wUnitCountBySide + 1], a
    ld d, $00
Bank0B_MapSetup_41FF:
    ld a, d
    ld c, $00
    farcall $12, UnitRecord_GetByte
    and a
    jr z, Bank0B_MapSetup_426B
    ld [$c940], a
    call UnitCount_IncrementForRecordIndex
    ld a, d
    ld c, $03
    farcall $12, UnitRecord_GetByte
    bit 0, a
    jr nz, Bank0B_MapSetup_426B
    ld a, d
    ld c, $01
    farcall $12, UnitRecord_GetByte
    ld [$c941], a
    ld a, d
    ld c, $02
    farcall $12, UnitRecord_GetByte
    ld [$c942], a
    ld a, [$c941]
    ld b, a
    ld a, [$c942]
    ld c, a
    ld a, [$c940]
    call $4798
    ld a, d
    ld c, $03
    farcall $12, UnitRecord_GetByte
    bit 7, a
    jr z, Bank0B_MapSetup_4254
    ld a, [$c941]
    ld b, a
    ld a, [$c942]
    ld c, a
    ld a, $02
    call $479c
Bank0B_MapSetup_4254:
    ld a, d
    ld c, $05
    farcall $12, UnitRecord_GetByte
    and a
    jr z, Bank0B_MapSetup_426B
    ld a, [$c941]
    ld b, a
    ld a, [$c942]
    ld c, a
    ld a, $01
    call $479c
Bank0B_MapSetup_426B:
    inc d
    ld a, d
    cp $64
    jr nz, Bank0B_MapSetup_41FF
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
; D = unit-record index. Records 0-49 belong to side 0; 50-99 to side 1.
UnitCount_IncrementForRecordIndex:
    ld hl, wUnitCountBySide
    ld a, d
    cp $32
    jr c, Bank0B_MapSetup_4280
    inc hl
Bank0B_MapSetup_4280:
    inc [hl]
    ret
; Clear queued map-tile updates and terrain-animation state.
MapPresentation_ResetTileUpdateAndAnimationState::
    xor a
    ldh [$ffac], a
    ldh [$ffb1], a
    ldh [$ffb2], a
    ret
Bank0B_MapSetup_428A::
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    call Bank0B_MapSetup_42B8
    ld e, $09
    ld a, [$c98c]
    ld c, a
Bank0B_MapSetup_4298:
    ld a, [$c98b]
    ld b, a
    ld d, $0a
    ld a, c
    and $01
    jr z, Bank0B_MapSetup_42A5
    dec b
    inc d
Bank0B_MapSetup_42A5:
    call Bank0B_MapSetup_43D1
    inc b
    dec d
    jr nz, Bank0B_MapSetup_42A5
    inc c
    dec e
    jr nz, Bank0B_MapSetup_4298
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret
Bank0B_MapSetup_42B8:
    ld a, [$c98b]
    and $0f
    swap a
    ldh [$ff95], a
    ld a, [$c98c]
    and $0f
    swap a
    ldh [$ff96], a
    call $05a2
    ret
Bank0B_MapSetup_42CE:
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    call Bank0B_MapSetup_42B8
    ld e, $09
    ld a, [$c98c]
    ld c, a
Bank0B_MapSetup_42DC:
    ld a, [$c98b]
    ld b, a
    ld d, $0a
    ld a, c
    and $01
    jr z, Bank0B_MapSetup_42E9
    dec b
    inc d
Bank0B_MapSetup_42E9:
    push bc
    call $15f8
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, [hl]
    and $3f
    call Bank0B_MapSetup_444D
    pop bc
    inc b
    dec d
    jr nz, Bank0B_MapSetup_42E9
    inc c
    dec e
    jr nz, Bank0B_MapSetup_42DC
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret
Bank0B_MapSetup_430A:
    jp Bank0B_MapSetup_430D
Bank0B_MapSetup_430D:
    push bc
    push de
    ldh a, [hWRAMBank]
    push af
    ld a, $07
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld a, $ff
    ld hl, $d000
    ld bc, $0d80
    call $3b79
    call Bank0B_MapSetup_42B8
    ld hl, $ffa3
    ld de, $435e
    call $08c0
    ld de, $436a
    call $08c0
    ld de, $437c
    call $08c0
    ld de, $43a1
    call $08c0
    xor a
    ldh [$ff9a], a
    ld a, [$c633]
    and $01
    add a, a
    ld hl, wMapSide0HQCoordinates
    call $29bc
    ld a, [hli]
    ld b, a
    ld c, [hl]
    call $0850
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop de
    pop bc
    ret
Bank0B_MapSetup_435E:
    xor a
    ldh [$ff99], a
    call $08c5
    ld d, $00
    call Bank0B_MapSetup_43A1
    ret
Bank0B_MapSetup_436A:
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $d0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    ld a, [hl]
    ldh [$ff99], a
    ret
Bank0B_MapSetup_437C:
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $d0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    ld a, [hl]
    cp $ff
    jr nz, Bank0B_MapSetup_439D
    call Bank0B_MapSetup_44C6
    and a
    jr nz, Bank0B_MapSetup_439D
    ldh a, [$ff99]
    inc a
    ld d, a
    ld h, $00
    jr Bank0B_MapSetup_439F
Bank0B_MapSetup_439D:
    ld h, $01
Bank0B_MapSetup_439F:
    ld a, h
    ret
Bank0B_MapSetup_43A1:
    ld a, c
    rrca
    rrca
    ld l, a
    and $0f
    add a, $d0
    ld h, a
    ld a, l
    and $f0
    add a, b
    ld l, a
    ld [hl], d
    ldh a, [$ff9a]
    cp d
    jr z, Bank0B_MapSetup_43CD
    ld a, d
    ldh [$ff9a], a
    push bc
    push de
    ld a, $01
    call $3844
    call $05a2
    call $05a2
    call $05a2
    call $05a2
    pop de
    pop bc
Bank0B_MapSetup_43CD:
    call Bank0B_MapSetup_43D1
    ret
Bank0B_MapSetup_43D1::
    ldh a, [hWRAMBank]
    push af
    push de
    ld a, b
    cp $ff
    jr z, Bank0B_MapSetup_43E0
    call Bank0B_MapSetup_44C6
    and a
    jr nz, Bank0B_MapSetup_4406
Bank0B_MapSetup_43E0:
    call $15f8
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld d, [hl]
    ld a, $02
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ld e, [hl]
    bit 7, e
    jr nz, Bank0B_MapSetup_441A
    ld a, d
    and $c0
    jr nz, Bank0B_MapSetup_440D
    ld a, e
    and a
    jr nz, Bank0B_MapSetup_4401
    ld a, d
    jr Bank0B_MapSetup_4403
Bank0B_MapSetup_4401:
    add a, $34
Bank0B_MapSetup_4403:
    call Bank0B_MapSetup_444D
Bank0B_MapSetup_4406:
    pop de
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
Bank0B_MapSetup_440D:
    ld a, e
    and a
    jr nz, Bank0B_MapSetup_4416
    ld a, d
    and $3f
    jr Bank0B_MapSetup_4428
Bank0B_MapSetup_4416:
    add a, $34
    jr Bank0B_MapSetup_4428
Bank0B_MapSetup_441A:
    ld a, e
    and $7f
    jr nz, Bank0B_MapSetup_4424
    ld a, d
    and $3f
    jr Bank0B_MapSetup_4426
Bank0B_MapSetup_4424:
    add a, $34
Bank0B_MapSetup_4426:
    ld d, $00
Bank0B_MapSetup_4428:
    call Bank0B_MapSetup_444D
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, d
    rlca
    rlca
    and $03
    add a, $b4
    call $0f2d
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, $00
    call $0f2d
    pop de
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
Bank0B_MapSetup_444D::
    push bc
    push de
    ld e, a
    call $15dd
    push hl
    ld h, $00
    ld l, e
    add hl, hl
    add hl, hl
    add hl, hl
    ld de, $1c6c
    add hl, de
    ld b, h
    ld c, l
    pop hl
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [bc]
    inc bc
    call $0f2d
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [bc]
    inc bc
    call $0f2d
    push hl
    call $0eea
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [bc]
    inc bc
    call $0f2d
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [bc]
    inc bc
    call $0f2d
    pop hl
    call $0ef7
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [bc]
    inc bc
    call $0f2d
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [bc]
    inc bc
    call $0f2d
    call $0eea
    ld a, $00
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [bc]
    inc bc
    call $0f2d
    ld a, $01
    ldh [$ff83], a
    ldh [$ff4f], a
    ld a, [bc]
    call $0f2d
    pop de
    pop bc
    ret
Bank0B_MapSetup_44C6::
    push bc
    push de
    push hl
    ld a, c
    and $01
    ld e, a
    ld hl, $c98b
    ld a, b
    add a, e
    cp [hl]
    jr c, Bank0B_MapSetup_44EF
    ld a, [$c98b]
    add a, $09
    cp b
    jr c, Bank0B_MapSetup_44EF
    ld hl, $c98c
    ld a, c
    cp [hl]
    jr c, Bank0B_MapSetup_44EF
    ld a, [$c98c]
    add a, $08
    cp c
    jr c, Bank0B_MapSetup_44EF
    xor a
    jr Bank0B_MapSetup_44F1
Bank0B_MapSetup_44EF:
    ld a, $01
Bank0B_MapSetup_44F1:
    pop hl
    pop de
    pop bc
    ret
Bank0B_MapSetup_44F5::
    push bc
    push de
    push hl
    ld a, c
    and $01
    ld e, a
    ld hl, $c98b
    ld a, b
    cp [hl]
    jr c, Bank0B_MapSetup_451E
    ld a, [$c98b]
    add a, $09
    sub e
    cp b
    jr c, Bank0B_MapSetup_451E
    ld hl, $c98c
    ld a, c
    cp [hl]
    jr c, Bank0B_MapSetup_451E
    ld a, [$c98c]
    add a, $08
    cp c
    jr c, Bank0B_MapSetup_451E
    xor a
    jr Bank0B_MapSetup_4520
Bank0B_MapSetup_451E:
    ld a, $01
Bank0B_MapSetup_4520:
    pop hl
    pop de
    pop bc
    ret
    assert @ == $4524

section "Map-grid working-state reset/setup", romx[$4524], bank[$0b]
MapGrid_ResetWorkingState::
    ldh a, [hWRAMBank]
    push af
    push bc
    push hl
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld hl, $d000
    ld bc, $0d80
    call $3b79
    ld a, $02
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    xor a
    ld hl, $d000
    ld bc, $0d80
    call $3b79
    pop hl
    pop bc
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    ret
    assert @ == $4551

