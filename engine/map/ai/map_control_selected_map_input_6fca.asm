include "macros/macros.inc"

; selected-map input/runtime family.
; The public $6FCA entry is the state-$03 handler used by the selected-map
; controller. It dispatches held/pressed input, mode-specific actions, and
; previous/next map-unit candidate selection. The connected internal helpers
; are only reached from this family. $717D is independently called from the
; separate $7226 state path and remains the next hard ownership boundary.

section "Bank $0B Selected Map Input Runtime", romx[$6fca], bank[$0b]
MapControl_RunSelectedMapInputRuntime::
    ldh a, [$ff90]
    bit 6, a
    jr nz, $6fe9
    bit 7, a
    jr nz, $6fe9
    bit 2, a
    jr nz, $6fed
    ld a, [$ca91]
    bit 1, a
    jr nz, $7006
    bit 5, a
    jr nz, $7011
    bit 4, a
    jr nz, $7016
    jr $702b
    call $706e
    ret
    call $2164
    call $07b4
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    call $4770
    farcall UnitReference_OpenTerrainDetailByDescriptorIndex
    call $69e6
    ret
    ld a, [$c62f]
    cp $03
    jr nc, $702b
    call $702c
    ret
    call $7085
    jr $7019
    call $70ce
    cp $ff
    jr z, $702b
    ld a, [$ca99]
    ld c, $01
    farcall UnitRecord_GetWord
    ld b, e
    ld c, d
    call $7b01
    ret
MapControl_RunModeSpecificInputAction::
    call $2164
    call $07b4
    ld a, [$c62f]
    cp $00
    jr z, $703f
    cp $01
    jr z, $704d
    jr $705b
    ld a, [$c883]
    farcall MapRecord_SelectBeginner
    ld b, $01
    ld a, [$c883]
    jr $7066
    ld a, [$c883]
    farcall MapRecord_SelectCampaign
    ld b, $00
    ld a, [$c883]
    jr $7066
    ld a, [$c883]
    farcall MapRecord_SelectStandard
    ld a, $10
    ld b, $01
    farcall MapBriefing_OpenInGame
    call $69e6
    ret
MapControl_WaitForHeldInputRelease::
    call $42ce
    call $4654
    call $74fa
    ldh a, [$ff90]
    bit 3, a
    jr z, $7081
    and $c0
    jr nz, $7074
    call $428a
    ret
MapControl_SelectPreviousMapCandidate::
    push bc
    push de
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    call $4792
    and a
    jr z, $70ba
    call $7d24
    jr nz, $70ba
    push bc
    ld a, [$ca99]
    ld c, $01
    farcall UnitRecord_GetWord
    pop bc
    ld a, b
    cp e
    jr nz, $70b3
    ld a, c
    cp d
    jr nz, $70b3
    ld a, [$ca99]
    ld b, a
    jr $70c5
    farcall UnitRecord_FindPrimaryAtCoordinates
    ld b, a
    jr $70c5
    ld b, $31
    ld a, [$c633]
    and $01
    jr z, $70c5
    ld b, $63
    ld a, b
    ld b, $ff
    call $7117
    pop de
    pop bc
    ret
MapControl_SelectNextMapCandidate::
    push bc
    push de
    ld a, [$c991]
    ld b, a
    ld a, [$c992]
    ld c, a
    call $4792
    and a
    jr z, $7103
    call $7d24
    jr nz, $7103
    push bc
    ld a, [$ca99]
    ld c, $01
    farcall UnitRecord_GetWord
    pop bc
    ld a, b
    cp e
    jr nz, $70fc
    ld a, c
    cp d
    jr nz, $70fc
    ld a, [$ca99]
    ld b, a
    jr $710e
    farcall UnitRecord_FindPrimaryAtCoordinates
    ld b, a
    jr $710e
    ld b, $31
    ld a, [$c633]
    and $01
    jr z, $710e
    ld b, $63
    ld a, b
    ld b, $01
    call $7117
    pop de
    pop bc
    ret
MapControl_UpdateCandidateIndex::
    push bc
    push de
    ld [$ca99], a
    ld c, a
    ld d, $00
    cp $32
    jr c, $7125
    ld d, $32
    ld a, d
    add a, $32
    ld e, a
    jr $7143
    ld a, [$ca99]
    farcall UnitRecord_CopyToScratch
    ld a, [$ccdd]
    and a
    jr z, $7143
    ld a, [$cce0]
    bit 1, a
    jr nz, $7143
    bit 7, a
    jr z, $7150
    call $7153
    ld a, [$ca99]
    cp c
    jr z, $714e
    jr $712b
    ld a, $ff
    pop de
    pop bc
    ret
    ld a, [$ca99]
    add a, b
    ld [$ca99], a
    ld a, b
    cp $ff
    jr z, $7166
    ld a, [$ca99]
    cp e
    jr z, $7172
    ret
    ld a, [$ca99]
    cp $ff
    jr z, $7177
    cp $31
    jr z, $7177
    ret
    ld a, d
    ld [$ca99], a
    ret
    ld a, e
    dec a
    ld [$ca99], a
    ret
    assert @ == $717d
