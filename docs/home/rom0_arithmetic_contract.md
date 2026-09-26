# ROM0 arithmetic helper contract

The compact arithmetic cluster at ROM0 `$29AD-$2A81` is fully source-backed and byte-verified against the Japanese retail ROM. `AddAtoHL` remains in `engine/home/home_map.asm`; the other eight routines are emitted by `engine/home/home_arithmetic_core.asm`.

| Range | Symbol | Contract | Status |
| --- | --- | --- | --- |
| `$29AD-$29BB` | `Math_MultiplyHLBy100` | unsigned `HL *= 100` | **source-backed** |
| `$29BC-$29C2` | `AddAtoHL` | unsigned `HL += A` | **source-backed** |
| `$29C3-$29C9` | `Math_SubtractDEFromHL` | `HL -= DE` | **source-backed** |
| `$29CA-$29D7` | `Math_CompareHLToDE` | carry when `DE < HL`; equal clears A and sets Z | **source-backed** |
| `$29D8-$2A1C` | `Math_SignedMultiplyHLByDE` | signed 16-bit `HL *= DE`, result in HL | **source-backed** |
| `$2A1D-$2A20` | `Math_ZeroHL` | `HL = 0` | **source-backed** |
| `$2A21-$2A6F` | `Math_DivideDEByBC` | signed divide; quotient returned in `DE`, remainder in `BC` | **source-backed** |
| `$2A70-$2A78` | `Math_AdjustNegativeBCAndDecrementAtHL` | decrement sign-state byte and two's-complement BC | **source-backed** |
| `$2A79-$2A81` | `Math_AdjustNegativeDEAndDecrementAtHL` | decrement sign-state byte and two's-complement DE | **source-backed** |

## Signed multiply

`Math_SignedMultiplyHLByDE` returns zero immediately if either operand is zero. Otherwise it records the XOR of the operand signs, converts negative operands to magnitudes, performs a 16-step shift/add multiply, and reapplies the result sign to HL.

## Signed division

`Math_DivideDEByBC` preserves HL while using `$CAA8-$CAAB` as scratch. `$CAA8` tracks the operand-sign state, `$CAA9-$CAAA` hold the magnitude of the divisor, and `$CAAB` is the 17-step long-division counter. The quotient is returned in DE and the remainder in BC. When exactly one input operand was negative, both output pairs are two's-complemented by the internal `Math_NegateBC` / `Math_NegateDE` entries.

No divide-by-zero special case is added or inferred beyond the exact retail routine. Consumers should not assume behavior outside the contracts proven by existing callers.
