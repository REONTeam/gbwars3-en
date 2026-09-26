# Map-control / active-force runtime (physical Bank $0D)

the project closes the previously unsourced `$0D:$6650-$670D` gap between the
player-control initializer and the active-force helpers. Together with the project,
`$0D:$6618-$6757` is now continuously source-owned.

## Runtime setup

`MapControl_InitializeRuntimeOnce` at `$6650` is entered from ROM0 `$2633`. It
selects WRAM bank 2, calls the still-unsourced `$0D:$5C42` helper, computes the
initial force-balance class, marks the runtime initialized, clears one runtime
state byte, and seeds a step counter with 4.

`MapControl_InitializePhaseRuntime` at `$6679` is independently entered from
ROM0 `$2638`. It clears two transient bytes, selects one of two four-byte phase
parameter records from `wMapPhaseNumber & 1`, and stages the selected values in
Bank-$0D map-control scratch. The exact meanings of the three non-side table
bytes remain deliberately conservative.

## Force-balance classification

`MapControl_ClassifyForceBalance` at `$66B1` calls
`UnitForceValue_CalcSideTotal` for the two 50-record side pools. The totals are
cached as little-endian HRAM words at `$FF99` and `$FF9B`, then compared against
2x/4x relative thresholds. The stored class at `$C9A0` is:

- `1`: side 0 exceeds side 1 by more than 4x
- `0`: side 0 exceeds side 1 by more than 2x
- `$FF`: neither side exceeds the other by more than 2x
- `2`: side 1 exceeds side 0 by more than 2x
- `3`: side 1 exceeds side 0 by more than 4x

The player-facing use of those class numbers is not named yet.

## ROM-locked ranges

- `$0D:$6618-$664F`: 56 bytes, SHA-1 `0fc4b2a0ffc4f8293f372b4a639827614aca3211`
- `$0D:$6650-$66B0`: 97 bytes, SHA-1 `5a37bef2b8ac7a790ad4f8056733564efbaa4f56`
- `$0D:$66B1-$670D`: 93 bytes, SHA-1 `e3c18e2572b5254041d6a96035b6067e4e73d9d2`
- `$0D:$670E-$6757`: 74 bytes, SHA-1 `83e054841691226dd03ca8b17ea88e9424b52510`

The next useful Bank `$0D` targets are the still-numeric setup helpers at
`$4B91`, `$5C42`, and `$6870`, plus callers that consume the `$C9A0` balance
class.
