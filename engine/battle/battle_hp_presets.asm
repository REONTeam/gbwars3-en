include "macros/macros.inc"
include "constants/unit_constants.inc"
include "constants/battle_scene_side_state.inc"

; Bank $02 producer-side battle scene HP preset/controller tranche.
; Displayed HP semantics are proven by the mirrored Bank $16 decrement-until-target consumers.

section "BattleHPPreset_EntryRedirect", romx[$4a12], bank[$02]
BattleHPPreset_EntryRedirect::
    db $c3, $68, $4b, $18, $fb ; $4A12
    assert @ == $4a17

section "BattleHPPreset_Controller", romx[$4a17], bank[$02]
BattleHPPreset_Controller::
    db $3e, $00, $ea, $0e, $c9, $ea, $0f, $c9, $ea, $10, $c9, $cd, $f3, $04, $cd, $ce ; $4A17
    db $34, $cd, $7c, $2d, $ef, $10, $a8, $68, $ef, $01, $00, $40, $cd, $18, $06, $cd ; $4A27
    db $02, $0f, $3e, $00, $ef, $15, $91, $66, $3e, $02, $06, $01, $ef, $31, $28, $76 ; $4A37
    db $3e, $03, $06, $00, $ef, $31, $28, $76, $cd, $a2, $05, $cd, $56, $30, $3e, $00 ; $4A47
    db $ef, $15, $91, $67, $f0, $92, $cb, $47, $28, $00, $cb, $4f, $28, $02, $18, $02 ; $4A57
    db $18, $e6, $c3, $17 ; $4A67
    assert @ == $4a6b

section "BattleHPPreset_WaitForSide1DisplayedHPFive", romx[$4a6b], bank[$02]
BattleHPPreset_WaitForSide1DisplayedHPFive::
    db $4a, $c9, $f0, $82, $f5, $3e, $04, $e0, $82, $e0, $70, $fa, $7e, $d3, $fe, $05 ; $4A6B
    db $20, $02, $18, $02, $18, $fe, $f1, $e0, $82, $e0, $70, $c9 ; $4A7B
    assert @ == $4a87

section "BattleHPPreset_FighterVsInfantry", romx[$4a87], bank[$02]
BattleHPPreset_FighterVsInfantry::
    db $f0, $82, $f5, $3e, $04, $e0, $82, $e0, $70, $3e, $1d, $ea, $77, $d3, $3e, $0a ; $4A87
    db $ea, $78, $d3, $3e, $0a, $ea, $79, $d3, $3e, $29, $ea, $7a, $d3, $3e, $04, $ea ; $4A97
    db $7b, $d3, $3e, $01, $ea, $7c, $d3, $3e, $01, $ea, $7d, $d3, $3e, $0a, $ea, $7e ; $4AA7
    db $d3, $3e, $00, $ea, $7f, $d3, $3e, $01, $ea, $80, $d3, $3e, $02, $ea, $81, $d3 ; $4AB7
    db $3e, $01, $ea, $82, $d3, $f1, $e0, $82, $e0, $70, $c9 ; $4AC7
    assert @ == $4ad2

section "BattleHPPreset_AttackPlaneVsFighter", romx[$4ad2], bank[$02]
BattleHPPreset_AttackPlaneVsFighter::
    db $f0, $82, $f5, $3e, $04, $e0, $82, $e0, $70, $3e, $20, $ea, $77, $d3, $3e, $0a ; $4AD2
    db $ea, $78, $d3, $3e, $0a, $ea, $79, $d3, $3e, $29, $ea, $7a, $d3, $3e, $12, $ea ; $4AE2
    db $7b, $d3, $3e, $0a, $ea, $7c, $d3, $3e, $2e, $ea, $7d, $d3, $3e, $03, $ea, $7e ; $4AF2
    db $d3, $3e, $00, $ea, $7f, $d3, $3e, $14, $ea, $80, $d3, $3e, $07, $ea, $81, $d3 ; $4B02
    db $3e, $14, $ea, $82, $d3, $f1, $e0, $82, $e0 ; $4B12
    assert @ == $4b1b

section "BattleHPPreset_AntiAirVsHelicopter", romx[$4b1b], bank[$02]
BattleHPPreset_AntiAirVsHelicopter::
    db $70, $c9, $f0, $82, $f5, $3e, $04, $e0, $82, $e0, $70, $3e, $11, $ea, $77, $d3 ; $4B1B
    db $3e, $0a, $ea, $78, $d3, $3e, $0a, $ea, $79, $d3, $3e, $09, $ea, $7a, $d3, $3e ; $4B2B
    db $03, $ea, $7b, $d3, $3e, $03, $ea, $7c, $d3, $3e, $2a, $ea, $7d, $d3, $3e, $0a ; $4B3B
    db $ea, $7e, $d3, $3e, $00, $ea, $7f, $d3, $3e, $14, $ea, $80, $d3, $3e, $03, $ea ; $4B4B
    db $81, $d3, $3e, $05, $ea, $82, $d3, $f1, $e0, $82, $e0, $70, $c9 ; $4B5B
    assert @ == $4b68

