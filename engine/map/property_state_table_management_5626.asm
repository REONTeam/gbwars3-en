include "macros/macros.inc"

DEF PROPERTY_STATE_RECORD_CAPACITY EQU 100
DEF PROPERTY_STATE_RECORD_SIZE     EQU 3

; Property-state table lifecycle for WRAM bank 1.  The persisted table contains
; up to 100 three-byte {state, X, Y} records at wMapPropertyStateRecords, with
; wMapPropertyStateRecordCount tracking the active entries used by construction
; and map setup.
;
; The rebuild path walks every active map cell, maps raw tile IDs through
; Terrain_GetNameIndex, and creates records only for classes below $0C.  New
; records receive the class-specific base state from the table at $5984.

section "Property State Table Management", romx[$5626], bank[$0c]

; Rebuild the WRAM1 property-state records from the active map grid.
PropertyState_RebuildRecordsFromMap::
    push bc
    push de
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    xor a
    ld [wMapPropertyStateRecordCount], a
    ld a, $ff
    ld hl, wMapPropertyStateRecords
    ld bc, PROPERTY_STATE_RECORD_CAPACITY * PROPERTY_STATE_RECORD_SIZE
    call Memset

    ; Retail primes the first slot with $FE bytes before scanning.  The first
    ; accepted cell overwrites it; preserve this exact empty-map behavior.
    ld a, $fe
    ld [hli], a
    ld [hli], a
    ld [hli], a

    ld c, $00
.row_loop
    ld b, $00
.cell_loop
    call MapGridCoord
    ld a, [hl]
    and $3f
    farcall $0b, Terrain_GetNameIndex
    cp $0c
    jr nc, .next_cell

    push af
    ld a, [wMapPropertyStateRecordCount]
    ld e, a
    pop af
    call PropertyState_InitializeRecordFromTerrainClass
    ld hl, wMapPropertyStateRecordCount
    inc [hl]

.next_cell
    inc b
    ld a, [wMapGridWidth]
    cp b
    jr nz, .cell_loop
    inc c
    ld a, [wMapGridHeight]
    cp c
    jr nz, .row_loop

    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    pop bc
    ret

    assert @ == $567c

; A = terrain-name class, E = record index, B/C = map coordinates.
; Initialize one record with the class-specific base state.
PropertyState_InitializeRecordFromTerrainClass::
    push de
    push hl
    ld d, $00
    add a, a
    ld hl, PropertyState_BaseAndMaximumByTerrainClass
    call AddAtoHL
    ld a, [hl]
    push af
    ld hl, wMapPropertyStateRecords
    add hl, de
    add hl, de
    add hl, de
    pop af
    ld [hli], a
    ld [hl], b
    inc hl
    ld [hl], c
    pop hl
    pop de
    ret

    assert @ == $5697

; B/C = map coordinates.  Allocate the first unused WRAM1 record, update the
; raw-tile histogram, initialize the state from the cell's terrain class, and
; rebuild income.  If all 100 slots are occupied, return without modifying it.
PropertyState_AddRecordAtCoordinates::
    push de
    push hl
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    ld hl, wMapPropertyStateRecords
    ld e, $00
.find_free
    ld a, [hli]
    cp $ff
    jr z, .found
    inc hl
    inc hl
    inc e
    ld a, e
    cp PROPERTY_STATE_RECORD_CAPACITY
    jr nz, .find_free
    jr .restore_bank

.found
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    farcall $0b, MapGrid_IncrementTileCount
    farcall $0b, Terrain_GetNameIndex
    call PropertyState_InitializeRecordFromTerrainClass
    farcall $0b, MapEconomy_RecalculateIncome
    ld hl, wMapPropertyStateRecordCount
    inc [hl]

.restore_bank
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    ret

    assert @ == $56d5

; B/C = map coordinates.  Remove the matching record when present, decrement
; the raw-tile histogram for the cell, rebuild income, and decrement the active
; record count.  Retail copies A to D on entry but never consumes that value.
PropertyState_RemoveRecordAtCoordinates::
    push de
    push hl
    ld d, a
    ldh a, [hWRAMBank]
    push af
    ld a, $01
    ldh [hWRAMBank], a
    ldh [rSVBK], a

    call PropertyState_FindRecordAtCoordinates
    cp $ff
    jr z, .restore_bank
    ld a, $ff
    ld [hli], a
    ld [hli], a
    ld [hli], a
    farcall $0b, MapTile_GetBaseIdAtCoordinates
    farcall $0b, MapGrid_DecrementTileCount
    farcall $0b, MapEconomy_RecalculateIncome
    ld hl, wMapPropertyStateRecordCount
    dec [hl]

.restore_bank
    pop af
    ldh [hWRAMBank], a
    ldh [rSVBK], a
    pop hl
    pop de
    ret

    assert @ == $5705

; Sum raw-tile histogram entries $00-$1F.  Those IDs are the property/building
; family below the natural terrain range beginning at $20.  The Map Editor uses
; this result to enforce its retail 100-building/property limit.
MapGrid_CountPropertyTiles::
    push bc
    push hl
    ld b, $00
    ld c, $00
    ld hl, wMapTileCountsById
.loop
    ld a, [hli]
    add b
    ld b, a
    inc c
    ld a, c
    cp MAP_TERRAIN_PLAIN
    jr nz, .loop
    ld a, b
    pop hl
    pop bc
    ret

    assert @ == $571b
