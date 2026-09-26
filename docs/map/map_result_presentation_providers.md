# Result presentation providers

The selected-map result presentation now reaches only named provider APIs through the shared result path. The provider layer is split by responsibility rather than by physical bank adjacency.

## Backgrounds and sequence dispatch

Bank `$1A` owns three background-loader variants at `$405B-$43D6`, the 17-byte descriptor copy helper at `$44C6-$44EA`, the nine-way `Presentation_RunSequenceByIndex` dispatcher at `$4541-$4579`, and the 28-entry background descriptor table at `$63E8-$65D7`. The sequence dispatcher selects fixed bodies at `$45D0/$46F5/$486F/$5063/$555A/$589E/$5913/$5DE8/$5E96`; those bodies remain the next connected semantic target.

## Shared presentation loop

Bank `$27:$4000-$40E5` owns the shared palette application, cancellable/non-cancellable frame waits, per-frame presentation servicing, and display reset. `Presentation_RunFrameServices` updates joypad state, ordinary sprites, the advanced-sprite scheduler, the Bank `$17` battle-place palette animators, and presentation scroll state each frame.

Bank `$31:$4113-$41BE` owns `Presentation_WaitWithAlternatingPalette`, which alternates the staged result palette while waiting and restores the requested final palette before return.

## Battle-place palette service

Bank `$17:$44A1-$45AF` owns `BattlePlace_LoadSharedGraphicsAndPalette`, the primary and secondary palette animators, and `BattlePlace_UpdatePaletteAnimations`. The two animation channels operate on independently staged palette pairs and are serviced by the Bank `$27` frame loop.

The older `BattlePlace_LoadGraphicsWindow` immediately before this range remains a separate source-fidelity item; this checkpoint does not alter its established custom-build bytes.

## Infrared-mode producer

Bank `$18:$5E65-$5F0A` is mnemonic as `Versus_RunStyleCountryController`. It is the readable producer of `wMapControlInfraredBattleMode`: style 0 writes local mode and style 1 writes infrared/remote mode. The controller uses `hJoyRepeat`, preserves the retail intermediate branch structure, commits the selection, and fades out without changing the custom-English result build.

## Verification

`make check-result-presentation-providers` compares all provider ranges against the retail reference and the linked output, checks the symbolic caller chain, rejects raw `$C630` engine accesses, and guards the display-reset path against substituting `SpriteObject_DestroyAll` for the required `SpriteObject_ResetAll`.
