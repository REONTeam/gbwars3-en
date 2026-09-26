# Mobile Adapter response parser / protocol-state support (the project)

the project owns physical Bank `$30:$6B21-$6E55`, immediately after the project network-client runtime and immediately before the independently reached `$6E56` state body.

## Numeric response-field parser

`MobileAdapter_ParseNumericResponseField` at `$6B21` preserves the shared `$D072-$D074` scratch, attempts up to three ASCII decimal digits through `$6B70`, then restores the scratch before returning. `$6B70` accepts only ASCII `0`-`9`, masks the digit to its low nibble, writes it through `DE`, advances the output pointer and decrements the remaining-digit count; non-decimal input returns with carry set. The higher-level meaning of every parsed field remains deliberately neutral because callers use the results for several mail/web response formats.

## Response and transfer state support

The `$6B81-$6D42` family is source-owned as response-state / transfer-buffer support. It consumes the rolling response-window helpers from the project, calls the 24-bit decimal parser at `$6ABC`, updates the shared transfer descriptors at `$D027+`, and routes completion/error handling through the existing `$67D5/$68E3/$6A52` helpers. Names remain address-oriented where the exact SMTP/POP3/HTTP state cannot yet be proven from both producer and consumer behavior.

`MobileAdapter_ReturnNetworkResultCode4` at `$6D30` is an independently reached helper that returns the same two-byte result code `$0004` through the shared network-result path.

## Protocol state dispatcher

`MobileAdapter_NetworkProtocolStateDispatcher` at `$6D43` is one of the direct targets already exposed by the project `$61AE+` protocol-state pointer table. It selects several downstream state families, including the still-unsourced `$6E56`, `$7349` and `$73B8` bodies. The adjacent gate at `$6D5D` tests the current command/state plus the `$D18B` mode bytes before allowing or resetting network state.

`MobileAdapter_StartTransferDataTemplateTransaction` at `$6D97` copies the already-named Transfer Data packet template at `$6072`, appends the current adapter/channel byte and enters the shared packet finalization/transaction machinery. This is enough to name the packet operation without asserting a narrower SMTP/POP3/HTTP public API role.

## Boundary

The span ends at `$6E55`. `$6E56` is independently selected by the `$6D43` dispatcher and is the next exact source boundary for the project.
