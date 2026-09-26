include "constants/hardware.inc"
include "constants/audio_constants.inc"
include "constants/bank_constants.inc"
include "constants/map_constants.inc"

macro text
    db \1
endm

macro line
    db "[LF]"
    db \1
endm

macro skip
    rept \1
        db "[LF]"
    endr
endm

macro done
    db "[ED]"
endm

macro coord
    db \1, \2
endm

macro coord_text
    coord \1, \2
    text \3
    done
endm

macro news
    db \1
    done
    done
endm

macro section_end
    if @ > \1
        def slack = @ - \1
        fail "Section grew too big! slack = {slack}"
    endc
    ds \1 - @
endm

macro farcall
    rst $28
    if _NARG >= 2
        db \1
        shift
    else
        db bank(\1)
    endc
    dw \1
endm

; Three-byte banked callback record used by dispatch tables. With one argument
; the bank is derived from the target label; two arguments permit a proven
; alternate entry address that does not have a public label.
macro banked_callback
    if _NARG == 1
        db bank(\1)
        dw \1
    else
        db \1
        dw \2
    endc
endm

macro lb
    ld \1, \2 << 8 | \3
endm

; Map records use a fixed 32-byte header. The second word stores the
; byte length of the following body, including its final $ff terminator.
; Header byte $04 is the 8-bit additive checksum of the complete body.
; Existing English ROM-map name patches retain their retail checksum byte
; for byte compatibility, so translated static records may not self-match.
macro map_record_header
    db MAP_RECORD_HEADER_SIZE, 0
    dw \2 - \1
    db \3 ; additive body checksum (sum(body) & $ff)
    ; Bytes $05-$1E are reserved zeroes. Header byte $1F is the optional
    ; ninth map-name sidecar. Existing three-argument records remain legacy
    ; compatible and emit zero here. A fourth argument emits character 9.
    ds 26, 0
    if _NARG >= 4
        db \4
    else
        db 0
    endc
endm


; Emit the four positional scenario parameters between the map name and
; dimensions. Their individual gameplay meanings are intentionally left
; unnamed until their readers/writers are sourced.
macro map_record_parameters
    assert _NARG == MAP_RECORD_FIELD_COUNT
    db \1, \2, \3, \4
endm


; Emit one map-body initial-unit tuple. The retail format stores X, Y, then
; an encoded unit/side byte: (UnitData index << 1) | side bit.
macro map_initial_unit
    assert \3 >= 0 && \3 < UNIT_DATA_COUNT
    assert \4 == UNIT_SIDE_0 || \4 == UNIT_SIDE_1
    db \1, \2, (\3 << 1) | \4
endm

; Sound-effect stream commands (bank $08/$09 SFX VM).
; The command byte uses its high nibble as the opcode.
macro sfx_frequency
    db (\1) & $0f, \2
endm

macro sfx_envelope
    db $10, \1
endm

macro sfx_duty
    db $20 | ((\1) & $0f)
endm

macro sfx_loop_start
    db $30, \1
endm

macro sfx_loop_repeat
    db $40
endm

macro sfx_pitch_delta
    db $50, \1
endm

macro sfx_wait
    db $60, \1
endm

macro sfx_wave
    db $70 | ((\1) & $0f)
endm

macro sfx_routing
    db $80, \1
endm

macro sfx_sweep
    db $90, \1
endm

macro sfx_nop
    db ((\1) & $0f) << 4
endm

macro sfx_end
    db $f0
endm

; Semantic music-event vocabulary for the shared music VM.
; Pitch nibble 0 is a rest; 1-12 are chromatic C through B.
DEF MUSIC_NOTE_C  EQU 1
DEF MUSIC_NOTE_CS EQU 2
DEF MUSIC_NOTE_D  EQU 3
DEF MUSIC_NOTE_DS EQU 4
DEF MUSIC_NOTE_E  EQU 5
DEF MUSIC_NOTE_F  EQU 6
DEF MUSIC_NOTE_FS EQU 7
DEF MUSIC_NOTE_G  EQU 8
DEF MUSIC_NOTE_GS EQU 9
DEF MUSIC_NOTE_A  EQU 10
DEF MUSIC_NOTE_AS EQU 11
DEF MUSIC_NOTE_B  EQU 12

macro music_note
    assert (\1) >= MUSIC_NOTE_C && (\1) <= MUSIC_NOTE_B
    assert (\2) >= 1 && (\2) <= 16
    db ((\1) << 4) | ((\2) - 1)
endm

macro music_rest
    assert (\1) >= 1 && (\1) <= 16
    db (\1) - 1
endm

macro music_duration_multiplier
    db $d0, \1
endm

macro music_octave
    assert (\1) >= 1 && (\1) <= 6
    db $d0 + (\1)
endm

macro music_octave_up
    db $d7
endm
macro music_octave_down
    db $d8
endm
macro music_tie
    db $d9
endm
macro music_channel_routing
    db $dc, \1
endm
macro music_loop_point
    db $dd
endm
macro music_loop
    db $de
endm
macro music_counted_loop_start
    db $df, \1
endm
macro music_counted_loop_repeat
    db $e0
endm
macro music_jump
    db $e1
    dw \1
endm
macro music_call
    db $e2
    dw \1
endm
macro music_return
    db $e3
endm
macro music_frequency_offset
    db $e4, \1
endm
macro music_duty
    db $e5, \1
endm
macro music_primary_output_level
    db $e6, \1
endm
macro music_wave_pattern
    db $e7, \1
endm
macro music_gate_length
    db $e8, \1
endm
macro music_output_level
    db $e9, \1
endm
macro music_modulation_selector
    db $ea, \1
endm
macro music_modulation_period
    db $eb, \1
endm
macro music_pitch_transpose
    db $ec, \1
endm
macro music_add_pitch_transpose
    db $ed, \1
endm
macro music_sweep
    db $ee, \1
endm
; $EF adjusts pulse output/envelope levels; on noise it adjusts clock shift.
macro music_channel_effect
    db $ef, \1
endm
macro music_channel_preset
    db $f0, \1
endm
macro music_alternate_output_level
    db $f1, \1
endm
macro music_enable_alternate_output
    db $f2
endm
macro music_disable_alternate_output
    db $f3
endm
macro music_request_snapshot
    db $f4
endm
macro music_primary_envelope
    db $f5, \1, \2, \3
endm
macro music_alternate_envelope
    db $f6, \1, \2, \3
endm
macro music_end_channel
    db \1
endm

; Legacy numeric music-event macros removed after semantic stream conversion.
; One 16x16 map cell is four 8x8 BG tiles. Each quadrant stores a tile ID
; followed by its CGB BG attribute byte: TL, TR, BL, BR.
macro map_metatile
    db \1, \2, \3, \4, \5, \6, \7, \8
endm

