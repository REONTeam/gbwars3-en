; Shared presentation scratch. These bytes are intentionally named by role,
; not by one gameplay subsystem: different presentation sequences reuse them
; for terrain classes, unit types, palette/side state, and result parameters.
DEF wPresentationParam0 EQU $c4a1
DEF wPresentationParam1 EQU $c4a2

; Bank $1A presentation sequence indexes. These names are producer/consumer
; backed by the action stagers. Sequence 0 is shared by completed property
; capture and the HQ-loss result path. Sequence 8 remains intentionally
; numeric until its selector/resource contract is stronger.
DEF PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_COMPLETE EQU $00
DEF PRESENTATION_SEQUENCE_HQ_LOSS                  EQU PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_COMPLETE
DEF PRESENTATION_SEQUENCE_PROPERTY_CAPTURE_PROGRESS EQU $01
DEF PRESENTATION_SEQUENCE_TERRAIN_TRANSFORMATION    EQU $02
DEF PRESENTATION_SEQUENCE_SUPPLY                    EQU $03
DEF PRESENTATION_SEQUENCE_LOAD                      EQU $04
DEF PRESENTATION_SEQUENCE_CARRIED_CHILD_MOVE        EQU $05
DEF PRESENTATION_SEQUENCE_CARRIED_CHILD_MOVE_SPECIAL_CARRIER EQU $06
DEF PRESENTATION_SEQUENCE_LOAD_SPECIAL_CARRIER      EQU $07
DEF PRESENTATION_SEQUENCE_8                         EQU $08

