include "constants/hardware.inc"

; Bank-aware Campaign briefing byte reader.
;
; The Bank $25 pointer tables remain the canonical historical address map. On
; the first byte of any Campaign message, this helper consults the matching
; Bank $34 relocation-table entry. Zero means keep reading the Bank $33 stream;
; nonzero replaces $C025/$C026 with the Bank $34 address and reads the entire
; message there. The decision is cached for the lifetime of the current viewer.
;
; wMapBriefingTextBankState is lifetime-scoped to this viewer:
;   0 = relocation directory has not yet been checked
;   1 = Bank $34 relocated message is active
;   2 = historical Bank $33 message is active
;
; This lives in retail $FF padding confirmed by the fixed-bank ownership audit.
section "Campaign Briefing Banked Reader", rom0[$3bf1]
CampaignBriefing_ReadByte::
    ldh a, [hROMBank]
    push af

    ld a, [wMapBriefingTextBankState]
    and a
    jr z, .resolve_bank
    dec a
    jr z, .read_bank34
    jr .read_bank33

.resolve_bank
    ; The relocation directory itself lives in Bank $34.
    ld a, $34
    call .select_bank

    ld a, [wMapBriefingGroup]
    and a
    jr z, .pre_map
    cp $02
    jr z, .result_a
    cp $03
    jr z, .result_b
    jr .choose_bank33

.pre_map
    ld hl, CampaignBriefing_PreMapRelocationTable
    jr .lookup
.result_a
    ld hl, CampaignBriefing_ResultARelocationTable
    jr .lookup
.result_b
    ld hl, CampaignBriefing_ResultBRelocationTable

.lookup
    ld a, [wMapBriefingMapIndex]
    add a
    ld c, a
    ld b, $00
    add hl, bc
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a
    or e
    jr z, .choose_bank33

    ld a, e
    ld [$c025], a
    ld a, d
    ld [$c026], a
    ld a, $01
    ld [wMapBriefingTextBankState], a
    jr .read_bank34

.choose_bank33
    ld a, $02
    ld [wMapBriefingTextBankState], a

.read_bank33
    ld a, $33
    call .select_bank
    call BankedText_ReadByteAndAdvance
    jr .restore

.read_bank34
    ld a, $34
    call .select_bank
    call BankedText_ReadByteAndAdvance

.restore
    ld b, a
    pop af
    call .select_bank
    ld a, b
    ret

.select_bank
    ldh [hROMBank], a
    ld [rROMB0], a
    ret

    assert @ <= $3e00
