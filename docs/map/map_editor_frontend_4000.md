# Bank $0F Map Editor frontend ($4000-$40EA)

the project source-backs the complete 235-byte editor/save frontend immediately before `MapEditor_InitNewMapRecord` at `$40EB`.

The clean entry structure is `$4000`, `$403D`, `$404E`, `$405F`, `$4069`, `$4073`, `$4080`, and `$40B4`. A key boundary correction is `$405F`: the byte at `$405F` is `PUSH BC`, so the earlier `$4060` handoff was one byte inside the wrapper.

`MapEditor_OpenSelectedRecord` caches the incoming selector at `$CA4F`, resets the shared editor working state, checks bit 1 of `$CA1D`, and either initializes a fresh record through `$40EB` or follows the existing-record load path. The `$4080` family stages a 0x35-byte record image at `$CA1A`, calls `MapMenu_RunContinueFromSavePrompt` (`$13:$54C0`), and treats return value 1 as the accepted continuation path before calling `$13:$5938`.

External entry evidence: `$0F:$4000` is farcalled from `$13:$5199`; `$4069` is farcalled from `$18:$5C70/$5CA0`; `$4073` is farcalled from `$18:$5C82`. Exact user-facing meanings of the numeric type-4/type-5 selectors remain intentionally neutral until the Bank `$18` caller family is source-owned.
