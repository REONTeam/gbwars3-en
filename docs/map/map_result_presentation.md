# Map result presentation

The selected-map resolution path now has a source-backed presentation layer across Banks `$1A` and `$27`.

## Resolution-specific Bank `$1A` services

`MapControl_PresentTransitionResult` selects one of three Bank `$1A` entries after `wMapControlWinningSide` and `wMapControlResolutionType` have been staged:

- `MapResult_PresentHQLoss` at `$1A:$6089-$60A3` handles the HQ-loss presentation path.
- `MapResult_PresentForceDefeat` at `$1A:$60A4-$6262` handles the force-defeat presentation path.
- `MapResult_PresentTurnLimitOrYield` at `$1A:$6263-$637F` is shared by Yield/Interrupt and turn-limit resolution.

The larger two services reset the advanced-sprite scheduler, configure side/palette state, install result graphics and animation pointers, run timed sprite effects and SFX, and fade back out. Their lower-level provider calls are now source-backed rather than raw addresses:

- Bank `$1A:$405B-$43D6` owns three closely related `CampaignBackground_Load*` variants using the same 17-byte background descriptor format.
- Bank `$1A:$44C6-$44EA` owns `CampaignBackground_CopyDescriptor`; `$63E8-$65D7` owns the 28 background descriptors and default-attribute tail.
- Bank `$1A:$4541-$4579` owns `Presentation_RunSequenceByIndex`, whose fixed nine-entry table selects the presentation bodies at `$45D0/$46F5/$486F/$5063/$555A/$589E/$5913/$5DE8/$5E96`.
- Bank `$27:$4000-$40E5` owns `Presentation_ApplyBackgroundPalette`, the cancellable and ordinary frame waits, `Presentation_RunFrameServices`, and `Presentation_ResetDisplayState`.
- Bank `$31:$4113-$41BE` owns `Presentation_WaitWithAlternatingPalette`.
- Bank `$17:$44A1-$45AF` owns the shared battle-place graphics/palette setup plus the two palette animators serviced once per presentation frame.

The nine Bank `$1A` sequence bodies remain the next deeper presentation target; they should be named only as their own callers/resources close their contracts.

## Bank `$27` side-result controller

Bank `$27:$5267-$5565` is a connected result-screen subsystem rather than save/persistence logic. Its source-backed helpers provide:

- cancel-aware frame waits using A/B/Start;
- randomized entry ordering and lookup;
- per-entry drawing and animation;
- primary/secondary result-screen setup;
- perspective-specific and side-specific layout configuration;
- side-dependent result SFX;
- fade/teardown handling.

`MapResult_PresentSideOutcome` at `$54E7` is the public entry used by `MapControl_FinalizeTransitionResult`. It receives the perspective/result-side selector in `A` and a zero-based side index in `B`, stages both in WRAM bank 4, performs two ordered presentation phases, and permits cancellation before fading out.

The screen setup intentionally calls `SpriteObject_ResetAll` at ROM0 `$2D7C`; this is stronger than `SpriteObject_DestroyAll` and is required for byte-exact reconstruction.

## Infrared/remote battle mode

`wMapControlInfraredBattleMode` (`$C630`) is the common selected-map communication-mode state. The mnemonic `Versus_RunStyleCountryController` at Bank `$18:$5E65-$5F0A` is its readable producer: the first style choice writes `0` for ordinary local battle and the second writes `1` for the infrared/remote style. Consumers use the same value to switch Yield to Interrupt, alter selected-map command availability and suspend/menu presentation, and gate the opponent-cancel result flow.

## Verification

The source-backed ranges match the Japanese retail ROM exactly:

- Bank `$1A:$6089-$60A3`: 27 bytes, SHA-1 `0b783f28457b34279532f922480fcd99c5eb1a7b`
- Bank `$1A:$60A4-$6262`: 447 bytes, SHA-1 `1c97925f850b99f35467e48305daecddff2687c9`
- Bank `$1A:$6263-$637F`: 285 bytes, SHA-1 `92400dd2a6da21b91fcaf429a03c6e755c5a34f1`
- Bank `$27:$5267-$5565`: 767 bytes, SHA-1 `37bd7fe34ce616e2d0399e18c3ab6ce26bd3c6b6`

`make check-map-result-presentation-runtime` verifies those public-result fingerprints and the symbolic integration from the Bank `$0B` dispatcher/finalizer. `make check-result-presentation-providers` additionally verifies the provider ranges, the battle-place palette updater, the infrared-mode producer/consumers, and guards the required `SpriteObject_ResetAll` reset semantics.
