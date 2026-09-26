# Sound-effect semantic IDs

The SFX engine accepts an 8-bit request ID through `Audio_PlaySFX` / `Audio_RequestSFX`.
The stream VM itself is fully disassembled in `audio/sound_driver.asm`; individual
streams live in `audio/sound_data_bank08.asm` and `audio/sound_data_bank09.asm`.

This document records only IDs whose gameplay role is demonstrated by repeated or
one-to-one callers. IDs used only by opaque presentation choreography remain numeric
until their behavior can be named without guessing.

## Shared UI/action IDs

| ID | Constant | Proven use |
| ---: | --- | --- |
| `$03` | `SFX_ERROR` | invalid/unavailable action feedback |
| `$09` | `SFX_CURSOR_MOVE` | cursor/selection movement |
| `$0A` | `SFX_CONFIRM` | accept/commit action |
| `$0C` | `SFX_CANCEL` | cancel/back action |

## Action-specific IDs

| ID | Constant | Proven caller contract |
| ---: | --- | --- |
| `$05` | `SFX_UNIT_DELETE` | DELETE action completion |
| `$06` | `SFX_UNIT_LIST_DELETE` | Unit List delete presentation |
| `$07` | `SFX_MEDAL_DETAIL` | medal-detail presentation |
| `$08` | `SFX_UNIT_CREATE` | unit creation confirmation |
| `$0D` | `SFX_END_TURN` | end-command transition |
| `$11` | `SFX_PROPERTY_CAPTURE` | property capture completion |
| `$12` | `SFX_WAIT_ACTION` | WAIT action completion |
| `$13` | `SFX_DEVELOP_PROPERTY` | completed property development |
| `$14` | `SFX_ACTION_EXECUTE` | shared action-executor presentation |
| `$15` | `SFX_TRANSPORT_LOAD` | transport load action |
| `$17` | `SFX_SUPPLY` | SUPPLY action completion |
| `$1C` | `SFX_TITLE_START` | accepted title-screen input |
| `$21` | `SFX_SPRITE_EXIT` | shared off-screen sprite transition |

The corresponding Bank `$08` stream entries expose semantic aliases while retaining
numeric compatibility labels. This keeps pointer-table/source navigation readable
without claiming an acoustic description (for example, "click" or "explosion") that
has not been verified from runtime playback.

## Intentionally numeric effects

IDs used only inside specialized presentation sequences remain numeric. Their caller
may prove *where* they are used without proving a stable effect identity. They should
be renamed only after either a unique gameplay contract or runtime listening/testing
establishes a durable name.
