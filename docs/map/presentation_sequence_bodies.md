# Bank $1A presentation sequence bodies

`Presentation_RunSequenceByIndex` dispatches through nine fixed Bank `$1A` entries. The complete physical runtime from `$45D0-$6088` is now source-owned in `engine/ui/presentation_sequence_bodies.asm`.

The range contains 2,758 executable instructions occupying 6,796 bytes. The only non-executable island is `$46C8-$46F4`, a 45-byte lookup block used by the first two sequences: one 9-byte table and two 9-word tables. The range SHA-1 in the Japanese retail ROM is `97fbde9a70355f67af32699d0cf7a793c76caf2d`.

The public dispatcher entries are `$45D0`, `$46F5`, `$486F`, `$5063`, `$555A`, `$589E`, `$5913`, `$5DE8`, and `$5E96`. The action-side stagers now prove the identities of indexes 0-7: property-capture complete/HQ loss, property-capture progress, terrain transformation, SUPPLY, LOAD, carried-child MOVE, special-carrier carried-child MOVE, and special-carrier LOAD. Index 8 remains `PresentationSequence_8` because its selector still lacks a stronger gameplay/resource identity.

Index 0 deliberately has both `PresentationSequence_PropertyCaptureComplete` and `PresentationSequence_HQLoss` at `$45D0`. This is one shared retail presentation: action-side CAPTURE chooses it when the acting unit's HP is sufficient to complete the property capture, while map resolution reuses the same sequence for HQ loss. The incomplete-capture branch selects `$46F5`, now `PresentationSequence_PropertyCaptureProgress`.

The shared lookup helpers at `$468C-$46F4` are named `PropertyPresentation_*` because they are used by both property-capture sequences rather than belonging only to numeric sequence 0.

Many routines inside the range are advanced-sprite callbacks and therefore have no ordinary direct `call` instruction. Their addresses are staged through `wAdvancedSpriteCallback`; the source now uses `HIGH()/LOW()` label references for same-bank callbacks so these relationships remain visible to the linker and reader.

WRAM-bank-4 `$D33D` is now `wPresentationUnitAnimationIDScratch`. SUPPLY initializes it from `wUnitSpriteAnimationID`, and the staged callback advances it before looking up the next animation pointer. The name intentionally describes this presentation-local lifetime rather than assigning a broader unit-record meaning.

`make check-presentation-sequence-bodies` verifies the exact linked range, public entry placement, lookup-table ownership, symbolic dispatcher targets, instruction count, and established custom-English ROM hash.

## Connected providers

`PresentationUnitSprite_LoadDefinition` at Bank `$1A:$45A5` mirrors the ordinary unit-sprite loader but indexes a separate 52-record presentation table at `$6380-$63E7`. Each record remains the proven two-byte graphics-group/animation-ID format; the higher-level meaning of each alternate entry stays conservative.

`Presentation_WaitWithAlternatingPaletteSlow` at Bank `$31:$4067-$4112` has the same frame/input/final-palette contract as `Presentation_WaitWithAlternatingPalette` at `$4113`, but switches the staged palette every ten frames instead of five. The two routines differ by exactly one retail byte (`$0A` versus `$05`).
