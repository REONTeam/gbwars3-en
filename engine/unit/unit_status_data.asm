include "macros/macros.inc"

; Remaining fixed data/helper tail of the Bank $25 Unit Status screen.
; This closes the formerly overlay-owned gaps between the selected-unit renderer
; and the next unrelated Bank $25 feature at $44FD.

section "UnitStatus Rank Tiles", romx[$43b3], bank[$25]
UnitStatus_RankTileTable::
    db $8e, $00, $8d, $00, $8c, $00, $8b, $00, $9d, $00
    assert @ == $43bd

section "UnitStatus Layout Lookup", romx[$448c], bank[$25]
; A and B form a compact two-dimensional index: offset = A * 2 + B.
; The table's higher-level visual identities remain deliberately positional.
UnitStatus_GetLayoutValue::
    db $87, $80, $21, $99, $44, $85, $6f, $3e, $00, $8c, $67, $7e, $c9
UnitStatus_LayoutValueTable::
    db $01, $01, $02, $02, $03, $04, $06, $08, $08, $05, $08, $07, $09, $0a, $0b, $0b
    db $0a, $0a, $0c, $0c, $0d, $0e, $0e, $0e, $0f, $0d, $0f, $10, $10, $11, $12, $13
    db $13, $14, $14, $1d, $15, $16, $16, $16, $16, $17, $18, $16, $19, $19, $19, $1a
    db $84, $19, $1b, $1a, $1c, $1c, $1e, $1f, $1e, $1f, $1f, $20, $21, $22, $22, $23
    db $22, $23, $83, $22, $82, $24, $25, $26, $27, $25, $28, $28, $28, $29, $2a, $28
    db $2b, $2b, $2b, $2c, $82, $2b, $82, $81, $81, $80
    assert @ == $44f3
