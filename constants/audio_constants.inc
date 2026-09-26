; Shared logical constants for the music and SFX engines.

; Game Boy hardware audio-channel indices used by both drivers.
DEF AUDIO_CHANNEL_PULSE1 EQU $00
DEF AUDIO_CHANNEL_PULSE2 EQU $01
DEF AUDIO_CHANNEL_WAVE   EQU $02
DEF AUDIO_CHANNEL_NOISE  EQU $03
DEF AUDIO_CHANNEL_COUNT  EQU $04

; SFX request-state protocol shared by the music frontend and bank-$08 driver.
DEF AUDIO_SFX_REQUEST_IDLE       EQU $00
DEF AUDIO_SFX_REQUEST_ACTIVE     EQU $01
DEF AUDIO_SFX_REQUEST_QUEUED     EQU $02
DEF AUDIO_SFX_REQUEST_QUEUED_BIT EQU 1

; Default music-engine update cadence: service audio once every four timer interrupts.
DEF AUDIO_UPDATE_DIVIDER_MASK EQU $03

; Common UI/gameplay sound-effect request IDs established from repeated callers.
DEF SFX_ERROR       EQU $03 ; invalid/unavailable action
DEF SFX_CURSOR_MOVE EQU $09 ; selection/cursor movement
DEF SFX_CONFIRM     EQU $0a ; accept/commit action
DEF SFX_CANCEL      EQU $0c ; cancel/back action

; Action/presentation SFX IDs with one-to-one semantics proven by their callers.
DEF SFX_UNIT_DELETE        EQU $05
DEF SFX_UNIT_LIST_DELETE   EQU $06
DEF SFX_MEDAL_DETAIL       EQU $07
DEF SFX_UNIT_CREATE        EQU $08
DEF SFX_END_TURN           EQU $0d
DEF SFX_PROPERTY_CAPTURE   EQU $11
DEF SFX_WAIT_ACTION        EQU $12
DEF SFX_DEVELOP_PROPERTY   EQU $13
DEF SFX_ACTION_EXECUTE     EQU $14
DEF SFX_TRANSPORT_LOAD     EQU $15
DEF SFX_SUPPLY             EQU $17
DEF SFX_TITLE_START        EQU $1c
DEF SFX_SPRITE_EXIT        EQU $21
