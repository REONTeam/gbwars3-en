# Mobile Adapter SDK requests $1A-$26

the project owns physical Bank `$30:$4898-$4C9C`, continuing directly from the project request `$12-$18` tranche and ending exactly before request `$28` at `$4C9D`.

The dispatcher boundaries are authoritative because they come from the already source-owned 34-word Bank `$30:$4070` request table. Request `$1A` is a ten-byte alternate-state wrapper: it requires internal driver state `$03` and then joins request `$1C` at `$48AA`. Request `$1C` itself requires state `$04` and the same shared driver flag gate.

Requests `$1C`, `$20`, `$22`, `$24`, and `$26` all construct packets whose command byte is `$95`, i.e. the response-form value for on-wire Transfer Data (`$15 | $80`). Their payload geometry and internal completion states differ, so the project keeps their SDK-facing names numeric rather than guessing send/receive/acknowledgment names from the common wire command alone. Successful `$1C/$20/$22/$26` paths select internal states `$17/$18/$1D/$1B` respectively.

Request `$1E` is a separate validated caller-string/buffer path. It finishes by entering the project shared mode-selected packet builder with mode `1`; its exact higher-level SDK operation is not yet independently proven and remains numeric.

Request `$24` is the largest handler in this tranche. It stores caller pointer/count state in the Mobile workspace, has a second path when the driver transfer flag is already active, and performs chunk/continuation bookkeeping around a `$95` Transfer Data packet. The source intentionally describes this only as a dual-path transfer/continuation handler until later consumers prove direction and API semantics.

The next fixed dispatcher boundary is request `$28` at `$4C9D`. That request and the much larger `$2A/$2C/$2E` handlers are the next Mobile Adapter targets; these are expected to expose stronger TCP/DNS/connection semantics before the source converges on the exported `$56CC` serial service and `$58E4` LCD/timer service.
