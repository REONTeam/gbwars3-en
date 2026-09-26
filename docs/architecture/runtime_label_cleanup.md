# Runtime label cleanup

`engine/remaining_rom.asm` owns code/data that was promoted late in the standalone-ownership process. Its historical `RemainingCode_BankXX_YYYY` labels were useful during extraction but are not retained in the polished source.

## Current model

- **604 local labels** (`.loc_XXXX`) are control-flow targets whose definitions and all references remain inside the same RGBDS global scope.
- **257 neutral global entry anchors** (`RuntimeEntry_BankXX_YYYY`) are retained where a target is unreferenced statically, crosses a global scope, or otherwise may represent an indirect/callable entry.
- **0 `RemainingCode_*` labels** remain in active ASM/INC source.
- **0 `RuntimeEntry_*` anchors have cross-file consumers.** Public routines with proven contracts are represented by semantic labels elsewhere in the source.

This deliberately avoids speculative names. A `RuntimeEntry_*` symbol should be promoted only when callers, parameters, return values, state effects, or a data consumer prove a durable semantic contract.

## Why not localize every address?

Game Boy code frequently uses indirect calls/jumps and pointer tables. An address with no direct textual reference can still be a real entry point. The retained neutral globals therefore preserve navigability and future reverse-engineering safety without exposing them as project-wide APIs.
