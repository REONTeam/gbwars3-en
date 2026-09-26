include "macros/macros.inc"

; Late music banks $3E/$3F.
; Channel streams are readable RGBDS music source; only the neutral pre-stream bank prefixes remain binary data.

; Banks $3E/$3F reuse the sourced music-driver core through $580A.
; Their stream source begins at $580B below.

INCLUDE "audio/music/bank3e/musictrack_08.asm"
INCLUDE "audio/music/bank3e/musictrack_17.asm"
INCLUDE "audio/music/bank3e/musictrack_18.asm"
INCLUDE "audio/music/bank3e/musictrack_19.asm"
INCLUDE "audio/music/bank3e/musictrack_1a.asm"
INCLUDE "audio/music/bank3e/musictrack_1b.asm"
INCLUDE "audio/music/bank3e/musictrack_1c.asm"
INCLUDE "audio/music/bank3f/musictrack_0b.asm"
INCLUDE "audio/music/bank3f/musictrack_0e.asm"
INCLUDE "audio/music/bank3f/musictrack_21.asm"
INCLUDE "audio/music/bank3f/musictrack_22.asm"
INCLUDE "audio/music/bank3f/musictrack_23.asm"
INCLUDE "audio/music/bank3f/musictrack_24.asm"
INCLUDE "audio/music/bank3f/musictrack_25.asm"
INCLUDE "audio/music/bank3f/musictrack_26.asm"
INCLUDE "audio/music/bank3f/musictrack_27.asm"
INCLUDE "audio/music/bank3f/musictrack_28.asm"
INCLUDE "audio/music/bank3f/musictrack_29.asm"
INCLUDE "audio/music/bank3f/musictrack_2b.asm"
