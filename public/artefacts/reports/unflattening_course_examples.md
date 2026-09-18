# Four unflattening examples for manual analysis

These are selections from the completed experiment, not changes to the course design. Full methodology and limitations: [validation report](E:/Workspace/seeing_through_obfuscation/docs/unflattening_validation.md).

Open SVGs at a readable zoom; the large machine graphs are intentionally retained at full detail. The compact topology comparisons show counts/addresses, while individual CFGs show instructions. Metrics exclude unreachable patch filler. **Do not load an original PDB into a rewritten binary:** internal addresses moved even though the function export did not.

## 1. OLLVM-16 FLA O0 — positive control

Target entry: `0x140001440`. State: DWORD `[RSP+8]`. Predispatcher: `0x1400017D2`; dispatcher: `0x140001463`.

Start with [clean CFG](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/ollvm16/o0/clean_cfg.svg), [flattened CFG](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/ollvm16/o0/before_cfg.svg), and [rewritten CFG](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/ollvm16/o0/after_cfg.svg). A [topology comparison](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/ollvm16/o0/course_comparison.svg) places all three together.

Follow the initial source parity test. Region/state `0x51837FD6` leads to `0xA0385473` (add `0x1111`) or `0x2416DE21` (XOR `0x2222`). Both reach `0x03AD94FD`, which initializes the loop counter. The symbolic trace at old block `0x1400015E8` records `CC_EQ(zf)?(loc_key_67,loc_key_66)`. The rewritten machine code expresses the choice directly: JNZ at `0x140001478` reaches the odd branch at `0x14000160E`, while fallthrough reaches the even branch at `0x14000147E`.

Result: **60 → 17 blocks**, 25/25 reference successor pairs recovered, all six outputs correct. Dead state writes remain; trace why they no longer control execution.

[Working rewritten PE](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/ollvm16/o0/stock_rewritten.exe) · [runtime evidence](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/ollvm16/o0/output_runtime_stdout.txt) · [region/IR/PE mapping](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/ollvm16/o0/provenance_region_map.json) · [symbolic trace](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/ollvm16/o0/instrumentation.json).

## 2. Hikari FLA O0 — transfer within related implementations

Target entry: `0x140001440`. State: DWORD `[RSP+8]`. Predispatcher: `0x14000181A`; dispatcher: `0x140001463`.

Compare [clean](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/hikari/o0/clean_cfg.svg), [flattened](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/hikari/o0/before_cfg.svg), and [rewritten](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/hikari/o0/after_cfg.svg) CFGs, or use the [topology comparison](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/hikari/o0/course_comparison.svg).

The initial branch region is state `2516078743`. Its two recovered successors are `1926478384` (odd add) and `1041077995` (even XOR); both lead to loop initialization region `443419611`. The old block `0x140001610` produces the symbolic `CC_EQ(zf)` choice. Check the retained IR conditions and concrete instructions, not merely the state constants.

Result: **66 → 20 blocks**, 28/28 reference successor pairs, correct executable. Extra lowered-switch tests/state relays explain why its graph differs from OLLVM's without implying wrong semantics.

[Working rewritten PE](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/hikari/o0/stock_rewritten.exe) · [runtime evidence](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/hikari/o0/output_runtime_stdout.txt) · [region/IR/PE mapping](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/hikari/o0/provenance_region_map.json) · [symbolic trace](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/hikari/o0/instrumentation.json).

Contrast with Hikari O2: stock fails before symbolic recovery. This is a useful reminder that related lineage does not guarantee optimization-independent compatibility.

## 3. Polaris FLA O0 — a cleaner graph can be incorrect

Target entry: `0x1400012D0`. State: DWORD `[RSP+0xC]`. Predispatcher: `0x1400015F1`; dispatcher: `0x1400012F3`.

Compare [clean](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/polaris/o0/clean_cfg.svg), [flattened](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/polaris/o0/before_cfg.svg), and the **[incorrect rewritten CFG](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/polaris/o0/after_cfg.svg)**. The [topology comparison](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/polaris/o0/course_comparison.svg) colors the wrong output red.

Inspect the legitimate switch in retained IR `%47`. Its four region successors are `25906`, `1323`, `2240`, and `32278`; each case then reaches final-XOR region `590`. The stock trace instead groups four case bodies under incoming state `31891` and reports `31891 → 590`. This is not a correct substitute for preserving which case executes.

In the rewritten bytes, block `0x140001348` falls through all four operations: XOR `0x22222222`, SUB `0x3333`, ADD `0x4444`, ADD `0x11111111`, then final XOR. There is no remaining four-way choice.

Result: **56 → 10 blocks, but invalid semantics**. FLA is `F9CD8332`, expected `DBEFFCE7`; exit 1. Only 14/22 reference successor pairs are correct, with one false pair. This is the strongest example against using visual simplification or PE validity alone as a success criterion.

[Runtime failure](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/polaris/o0/output_runtime_stdout.txt) · [exact rewritten instructions](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/polaris/o0/after_cfg.txt) · [ground-truth regions](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/polaris/o0/provenance_region_map.json) · [incorrect grouping trace](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/polaris/o0/instrumentation.json).

The failed PE remains in that evidence directory. Do not distribute it as a successful deobfuscation result.

## 4. Tigress Flatten O0 / MSVC — discovery blocks transfer

Target entry: `0x140001020`. State: QWORD `[RSP+0x10]` after stack allocation. Dispatch uses 21 RVA table entries beginning at RVA `0x1260`; the indirect jump is at `0x14000107F`.

Compare the [clean reference](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/tigress/o0/clean_cfg.svg), [complete table-aware reference CFG](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/tigress/o0/reference_complete_cfg.svg), and [stock's incomplete discovery CFG](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/tigress/o0/before_cfg.svg). The complete graph is independent reference evidence, not an assisted stock success.

Use the [verified jump table](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/tigress/o0/verified_jump_table.json) to locate state 7's parity test at `0x1400011FD`. The generated C/PE selects state 12 (odd add, `0x1400010AC`) or state 4 (even XOR, `0x140001081`). Both update to state 8 (loop initialization). This reference successor example is **not recovered by stock symbolic execution**, because stock never invokes recovery.

Actual reference: **38 blocks**. Stock discovery: **6 blocks**, score 0.8333, rejected. There is no rewritten CFG or output runtime to show. The separately labeled score-only adapter also fails, demonstrating that lowering the threshold does not repair discovery/classification.

[Original successful runtime](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/tigress/o0/input_runtime_stdout.txt) · [source/PE region mapping](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/tigress/o0/provenance_region_map.json) · [stock CLI evidence](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/tigress/o0/stock_result.json) · [assisted failure](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/assisted_transfer/tigress_o0_bounded/instrumentation.json).

## Keep the secondary stress case separate

BinProtect is **STATIC ONLY / SEMANTICALLY INVALID PROTECTED PE**. It is not one of these four runnable-family examples, was never executed in this phase, and has no repaired output. Consult the validation report for its distinct graph-head/state-identification failures.
