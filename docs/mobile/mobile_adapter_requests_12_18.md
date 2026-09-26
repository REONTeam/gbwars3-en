# Mobile Adapter requests $12-$18 (the project)

the project source-backs physical Bank `$30:$45DC-$4897` (700 bytes), immediately following the project and ending before request `$1A` at `$4898`.

## Boundaries

- `$45DC` - `MobileAdapter_RequestHandler12`
- `$4614` - `MobileAdapter_BuildModeSelectedControlPacket`
- `$46C0` - `MobileAdapter_PrepareConfigurationBuffer`
- `$46EE` - `MobileAdapter_RequestHandler14_ReadConfigurationData`
- `$4756` - `MobileAdapter_RequestHandler16`
- `$47FE` - `MobileAdapter_RequestHandler18`

Request `$14` has a behavior-backed protocol identity: its successful path selects mode 0 in the shared packet builder, and mode 0 emits on-wire command `$19`, `MOBILE_COMMAND_READ_CONFIGURATION_DATA`. Requests `$16` and `$18` both build packets using response-form command `$95` (`MOBILE_COMMAND_TRANSFER_DATA | $80`), but this does not by itself prove whether the SDK-facing requests should be called send, receive, acknowledge, or another higher-level transfer operation. They therefore remain numeric.

Request `$12` also remains numeric. It arms driver state `$0D` and enters the common active-request path, but the present tranche does not yet provide enough packet/state evidence for a stable game-facing name.

The shared `$4614` helper is named only for mechanically observed behavior: it selects among multiple control-packet construction modes. Mode 0 uses command `$19`; mode 1 uses command `$6E` (`ERROR`); mode 2 enters the `$46C0` configuration-buffer preparation path.

As with the preceding Mobile source work, the Japanese retail ROM is verification-only. Existing custom English content is not replaced or reconstructed from retail Japanese payloads.
