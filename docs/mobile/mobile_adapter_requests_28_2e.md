# Mobile Adapter requests $28-$2E (the project)

the project owns physical Bank `$30:$4C9D-$548E` (2,034 retail bytes), continuing directly from the project and ending exactly before the fixed request `$3A` entry at `$548F`.

The dispatcher boundaries are now symbolic for request `$28` at `$4C9D`, `$2A` at `$4DDC`, `$2C` at `$51FD`, and `$2E` at `$5405`. The source remains byte-row exact where the higher-level SDK contract is not yet proven.

Request `$28` is structurally another large pointer/count transfer continuation path. It emits `$95` (`MOBILE_COMMAND_TRANSFER_DATA | $80`) and advances through internal state `$1C`, closely paralleling the project `$24` continuation machinery. The exact public send/receive direction is still not named.

Request `$2A` is the strongest network-facing handler in this tranche. Its body contains the retail Mobile service endpoint strings `http://gameboy.datacenter.ne.jp/cgb/download`, `gameboy.datacenter.ne.jp/cgb/upload`, `gameboy.datacenter.ne.jp/cgb/utility`, and `gameboy.datacenter.ne.jp/cgb/ranking`. It also emits `$A3`, the response-form of `MOBILE_COMMAND_OPEN_TCP_CONNECTION` (`$23 | $80`), and later `$95`, the response-form of Transfer Data. This proves a web/TCP state-machine role, but not a narrow one-command SDK API name, so the request label remains numeric.

Requests `$2C` and `$2E` are now source-owned as well. `$2C` is a large parameter/parser continuation sharing the `$2A` web/TCP machinery; `$2E` is a compact driver-state/control handler. Their exact public API identities remain intentionally conservative.

The next source boundary is request `$3A` at `$548F`, followed immediately by internal/request entries `$42=$5543`, `$32=$5544`, `$34=$5599`, `$3C=$5617`, and `$36=$5634`, with the exported serial service at `$56CC`. The remaining work is to close this residual dispatcher-handler tail and converge directly on the serial core.
