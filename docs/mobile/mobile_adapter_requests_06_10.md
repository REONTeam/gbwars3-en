# Mobile Adapter requests $06-$10

the project sources Bank $30:$43AB-$45DB, the Mobile Adapter SDK request cluster immediately following the project request $00/$02/$04 group.

## Dispatch IDs versus wire commands

The Bank $30 dispatcher consumes an even-valued SDK request index. These values are not the Mobile Adapter serial-protocol command IDs. For example, request $06 builds packet traffic using the protocol's Dial Telephone ($12) and ISP Login ($21) commands.

The shared protocol command constants now live in `constants/mobile_adapter_constants.inc`.

## Proven request roles

- `$06` (`MobileAdapter_RequestHandler06_ISPLogin`) validates the caller's zero-terminated login/telephone strings, prepares the Dial Telephone packet, builds the ISP Login packet payload, starts the shared transfer path, and marks the request active.
- `$08` (`MobileAdapter_RequestHandler08_DialTelephone`) validates a telephone-number string and prepares a standalone Dial Telephone transaction.
- `$0A` (`MobileAdapter_RequestHandler0A_Disconnect`) is the connection-teardown state machine. One branch emits command `$A2`, i.e. ISP Logout `$22 | $80`; another emits `$95`, i.e. Transfer Data `$15 | $80`, before entering the common completion state.
- `$0C`, `$0E`, and `$10` are thin wrappers that select internal states `$25`, `$26`, and `$27` and enter `MobileAdapter_BeginStateRequest`. Their higher-level game-facing names remain deliberately unresolved.

## Shared helpers

- `$4431` marks the request-active bit.
- `$4484` builds the Dial Telephone packet.
- `$44AF` starts the SDK idle/serial transfer path used by the newly sourced connection handlers and by the earlier request `$02/$04/$38` setup paths.
- `$4595` performs the common state-request initialization used by requests `$0C/$0E/$10`.

All addresses and bytes are locked against the Japanese retail ROM; SDK/reference source is used only to corroborate naming and protocol terminology.
