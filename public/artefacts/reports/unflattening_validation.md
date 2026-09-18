# Control-flow unflattening transfer validation

Completed 2026-09-18. This is a bounded study of the existing frozen showcase, not a new corpus or a course-design revision.

**Main result:** stock ollvm-unflattener v2.0 successfully rewrites OLLVM-16 FLA O0 and Hikari FLA O0. Polaris O0 is recognized but rewritten incorrectly. All four O2 cases fail before meaningful successor recovery. Tigress's initial indirect-dispatch CFG is incomplete. These outcomes distinguish recognition, recovery, and executable correctness.

All experiment files are under [results/deobfuscation/unflattening](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening). Start with [stock results](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/stock_results.csv), [edge scores](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/semantic_edge_scores.csv), and the [course examples](E:/Workspace/seeing_through_obfuscation/docs/unflattening_course_examples.md).

## 1. Tool identity and experimental order

| Item | Verified value |
|---|---|
| Checkout | `E:\Workspace\seeing_through_obfuscation\third_party\deobfuscators\ollvm-unflattener` |
| Commit | `d0062012b66ab2c845207c733216900d5e99f0a9` |
| Branch / tag | `master`; local `v2.0` points exactly at HEAD |
| Commit date / subject | 2025-04-16; “Add keystone requirement” |
| License | Apache-2.0 |
| Checkout changes | None; no update, checkout, recognizer patch, or new cache files |
| Documented support | Python 3.10+; Windows/Linux; x86 and x64 |
| Source format support | PE and ELF; reassembler explicitly supports x86_32/x86_64 |

The [identity logs](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/environment/upstream_head_stdout.txt) and source-file hash manifest preserve the observed local checkout, rather than assuming a version from the inventory. Upstream documentation: [ollvm-unflattener at the tested commit](https://github.com/cdong1012/ollvm-unflattener/tree/d0062012b66ab2c845207c733216900d5e99f0a9).

Order: independent environment → untouched upstream sample → clean/source ground truth → untouched OLLVM O0 control → untouched Hikari/Polaris/Tigress O0 → passive O0 diagnostics → untouched O2 cases and diagnostics → independent edge comparison → BinProtect static-only stock test → preserved stock tables/hash manifest → one generic assisted experiment. The diagnostic script uses Python tracing to observe upstream locals/returns; it does not change stock return values. Only explicitly labeled assisted invocations replace the score.

## 2. Independent environment

Environment: `E:\Workspace\seeing_through_obfuscation\.venvs\unflattener` (inside the workspace).

| Component | Actual installation |
|---|---|
| Python | 3.11.4, Anaconda AMD64; base `D:\Programs\anaconda3_11\python.exe` |
| Miasm | PyPI `0.1.5`, built as a pure-Python wheel; no Git revision encoded in this distribution |
| Keystone engine | `0.9.2`, Windows AMD64 wheel |
| Graphviz Python package | `0.21` |
| Transitive dependencies | `future==1.0.0`, `pyparsing==2.4.7` |
| Installer/build metadata | `pip==23.1.2`, `setuptools==65.5.0`; full `pip inspect` retained |
| Native Graphviz | `16.1.0 (20260904.0139)`, project-local portable Windows distribution |

The exact upstream requirements are unversioned `miasm`, `graphviz`, and `keystone-engine`. Installation used those requirements unchanged; it did not copy the msynth environment or force its Git-pinned Miasm. Both environments happen to report Miasm 0.1.5, but msynth retains Git revision `24a64bb30a181d60fe9572293c1b2fa597b2d0c9`, whereas this environment resolved the PyPI release.

The first pip attempt failed writing the ordinary user cache. A workspace-local cache/TEMP and the existing VS developer environment allowed installation. No global Python packages were changed. The generated Miasm wheel SHA-256 is `DFD66E772C72817B1F403B3C3E5B3CFDE3C4C40E4DE3D6FC7C09BD15680308DC`.

No native `dot.exe` was found on PATH or in the searched existing installations. Stock CLI execution does not call its graph-rendering method, so Graphviz was not needed for the sanity gate. For the requested CFG evidence, the official [portable Graphviz package](https://graphviz.org/download/) was downloaded and verified against its published checksum. It was extracted only under the experiment directory; no system PATH change or global installer was used.

Native executable: `E:\Workspace\seeing_through_obfuscation\results\deobfuscation\unflattening\environment\graphviz\Graphviz-16.1.0-win64\bin\dot.exe`.

ZIP SHA-256: `733E49626C492242EB8DCA30EA627B6EAD20710E207998C7933B4909D92D6ABC`. `dot.exe` SHA-256: `97193DC802C145B6152CECC287E84E459160839964D9340F4F10B93D96087601`. Download URL, checksum, package inventory, build/install output and version checks are retained in [environment](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/environment).

## 3. Algorithm and exact CLI

The unchanged CLI is:

```text
python unflattener -i <input PE/ELF> -o <output> -t <hexadecimal VA> [-a]
```

`-a`/`--all` follows calls. It was never used here. `-t` is a virtual address, not an RVA or a file offset. Every invocation's complete argv, command string, working directory, elapsed time, stdout, stderr, and exit status is retained as `stock_cli_*` in its case directory.

Major source stages:

1. Miasm detects the container/architecture and recursively disassembles the target. Call-aware lifting creates an IR CFG. This initial discovery does not resolve our Tigress jump tables.
2. `calc_flattening_score` searches predecessor-free graph heads, skips call-split head blocks, then finds dominator regions with a back-edge. The maximum dominated-node fraction must reach **0.9**.
3. The highest-in-degree machine block is assumed to be a **predispatcher**. Its first successor is assumed to be the dispatcher. These are layout assumptions, not semantic identification.
4. Predispatcher parents and terminal blocks become candidate real blocks. Backward walks accommodate call splitting, but stop only on `JZ`, `JNZ`, or `JMP`; several `[0]` predecessor accesses are unguarded and walks have no visited set.
5. The state expression is simply operand **two of the dispatcher's first instruction**. This fits `MOV EAX,[state]`, but not a comparison where operand two is an immediate.
6. Miasm symbolically traverses the function and concrete dispatcher states. A visited-block rule limits repeated processing. CMOV paths with an earlier CMP/TEST in the same block are deliberately split into both alternatives, even if symbolic evaluation has concretized one. Ordinary conditional branches are also explored, but the later state grouping is not a general arbitrary-CFG representation.
7. Observations populate state→blocks and state→successors maps. Prologue blocks use synthetic state 0. Blocks outside the selected groups are removed.
8. Keystone reassembles/reorders retained blocks, drops their terminal dispatcher jumps, replaces a CMOV with a corresponding conditional jump, and stitches successor groups. Branch slots reserve six bytes. Selected x64 RIP-relative memory operands and direct calls receive relocation handling.
9. `apply_patches` copies the PE, fills the surviving-block interval's hull with `CC`, then writes the compacted body at its original entry. It does not add sections or regenerate exports, unwind records, or debug metadata. There is no general patch-size/metadata repair framework.

Calls are not executed natively by the analyzer. The call-aware symbolic handling restores SP/BP across calls and can queue internal call targets when requested. The showcase target itself has no calls; the upstream sanity sample exercises calls. The source also imports initial register symbols from the PPC register module despite the x86 analysis; this was not changed, and is not established as the cause of any failure here.

**CLI trap:** its broad exception handler can log failure and still return exit 0. All nine corpus/static CLI invocations returned 0, including failures. Output existence, correct edges, and runtime are separate checks.

## 4. Mandatory upstream sanity gate

The included benign Windows x64 `samples/win64/CFF_win64.exe` was copied into [sanity](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/sanity). Its included C source prints a ten-iteration loop and parity messages. COFF symbols identify `_Z15target_functioni` at **VA `0x4015B0`**, image base `0x400000`.

Exact stock command:

```text
E:\Workspace\seeing_through_obfuscation\.venvs\unflattener\Scripts\python.exe -B E:\Workspace\seeing_through_obfuscation\third_party\deobfuscators\ollvm-unflattener\unflattener -i E:\Workspace\seeing_through_obfuscation\results\deobfuscation\unflattening\sanity\CFF_win64.exe -o E:\Workspace\seeing_through_obfuscation\results\deobfuscation\unflattening\sanity\stock_rewritten.exe -t 0x4015b0
```

Input SHA-256: `32CD0728E2986816D9F29A9D64B88633276650BA111E97DA0E4FB71F649770CA`.

Output SHA-256: `723CC8719D099EA601289AD8F490D645F109A2C29BCE91F3AB66591FCD5343F1`.

Both are 54,986-byte x64 PEs. The new output differs from the input, executes successfully, and exactly matches the original stdout/stderr with exit 0. The expected ten-iteration completion message is present. Input/output binaries, PE inspections, hashes, target bytes, disassemblies, CFG JSON/DOT/SVG, and runtime logs are retained. [gate.json](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/sanity/gate.json) passed before any corpus deobfuscation.

## 5. Corpus selection and clean/source ground truth

No specimen was rebuilt. [selections.json](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/stock_transfer/selections.json) records exact original executable paths/hashes, same-family clean paths/hashes, VA/RVA/range, and CFG metrics. Each case also retains the complete original build metadata: compiler path/version/hash, flags, IR/assembly/source paths, seed/configuration, and commands.

All primary PEs use image base `0x140000000`. Their target ranges are exact PE `RUNTIME_FUNCTION` bounds, end exclusive:

| Family | Opt | demo_flattening VA | End VA | Flattening configuration |
|---|---|---|---|---|
| OLLVM-16 | O0 | `0x140001440` | `0x1400017D7` | `-mllvm -fla -mllvm -aesSeed=00112233445566778899AABBCCDDEEFF` |
| Hikari | O0 | `0x140001440` | `0x14000181F` | `-mllvm -enable-cffobf -mllvm -aesSeed=123456` |
| Polaris | O0 | `0x1400012D0` | `0x1400015F6` | `-mllvm -passes=fla -mllvm -rng-seed=123456` |
| Tigress/MSVC | O0 | `0x140001020` | `0x1400012B4` | `Flatten`, target-only, switch dispatch, seed 424242; `/Od /Ob0` |
| OLLVM-16 | O2 | `0x140001300` | `0x1400015EB` | Same retained FLA configuration |
| Hikari | O2 | `0x1400012E0` | `0x1400015BE` | Same retained FLA configuration |
| Polaris | O2 | `0x1400011C0` | `0x140001318` | Same retained FLA configuration |
| Tigress/MSVC | O2 | `0x140001400` | `0x1400015AC` | Same generated C; existing MSVC O2 build |

Tigress generation used `--Environment=x86_64:Windows:Msvc:0.0 --Seed=424242 --Transform=Flatten --Functions=demo_flattening --FlattenDispatch=switch`. The full retained generation command and generated C provenance remain in the original matrix; no regeneration was performed.

The frozen source graph is initial parity if/else → four-iteration loop with a value-bit conditional → four-outcome switch → reconvergence → XOR `0xCAFEBABE`. [Ground truth](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/stock_transfer/ground_truth) retains the source excerpt, source-region graph, and expected six outputs.

Clean O0 functions have unwind bounds. The four clean O2 leaf functions do not: their bounds are the export entry through the last reachable RET, cross-checked against the next export and decoded NOP/INT3 alignment. Separate `clean_leaf_boundary_audit.json` files record this. Tigress unwind ranges include embedded jump-table data; **linear disassembly of those data is not counted as code**.

## 6. Stock results: recognition, recovery, executable

| Family / opt | Score gate | Correct successor pairs | Rewritten PE | Runtime | Classification / stopping point |
|---|---:|---:|---|---|---|
| OLLVM O0 | 0.9833, pass | 25/25; 0 false | Yes | All six correct; exit 0 | FULL STOCK SUCCESS |
| Hikari O0 | 0.9848, pass | 28/28; 0 false | Yes | All six correct; exit 0 | FULL STOCK SUCCESS |
| Polaris O0 | 0.9821, pass | 14/22; 1 false | Yes | Wrong FLA; exit 1 | SYMBOLIC RECOVERY FAILURE, propagated into incorrect rewrite |
| Tigress O0 | 0.8333, reject | 0/22 | No | N/A | DETECTION/HEURISTIC FAILURE; missing jump-table edges |
| OLLVM O2 | 0.9800, pass | 0/25 | No | N/A | DETECTION/HEURISTIC FAILURE; block-classification IndexError |
| Hikari O2 | 0.9796, pass | 0/28 | No | N/A | Same layout failure before state recovery |
| Polaris O2 | 0.9444, pass | 0/9 | No | N/A | Same layout failure before state recovery |
| Tigress O2 | 0.6667, reject | 0/22 | No | N/A | DETECTION/HEURISTIC FAILURE; missing jump-table edges |

The score is a detection heuristic, **not** evidence of a correctly identified dispatcher. The O2 LLVM-family cases pass the numerical gate but fail structural identification. BinProtect is excluded from this runnable table and success denominator.

### OLLVM control and Hikari transfer

OLLVM O0 state is `@32[RSP+0x8]`, selected dispatcher `0x140001463`, predispatcher `0x1400017D2`. Hikari O0 uses the same stack-state shape, dispatcher `0x140001463`, predispatcher `0x14000181A`. The selected structural roles agree with the PE/IR evidence.

Both outputs bypass the original dispatch machinery with direct semantic control flow. State stores and some state-related register moves remain, but no longer select control flow. Removal of those dead instructions is not claimed.

The exact OLLVM executable is [stock_rewritten.exe](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/ollvm16/o0/stock_rewritten.exe), SHA-256 `FCF8827FF1E7A3B81FB6F0E005FF9BB0342F79C6785AC802DF0639C8C2F90E9B`.

The exact Hikari executable is [stock_rewritten.exe](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/hikari/o0/stock_rewritten.exe), SHA-256 `74FAC943439AA2616BA2D1288DEB21D579D7E9A01B3B7E574B560753A7256320`.

### Polaris: why the apparently cleaner output is wrong

State `@32[RSP+0xC]`, dispatcher `0x1400012F3`, and predispatcher `0x1400015F1` are identified. However, retained IR block `%47` still contains the legitimate four-outcome switch. Its case operations are reached directly without updating the flattening state first.

The stock engine groups the four mutually exclusive machine case bodies under incoming state **31891 (`0x7C93`)**, in this observed order: case 1 at `0x140001595`, case 2 at `0x1400015AF`, default at `0x1400015C9`, case 0 at `0x14000157B`. It reports `31891 → 590` and loses the direct switch-to-case distinctions. The rewriter concatenates the four grouped bodies.

Consequently the rewritten function executes XOR `0x22222222`, subtract `0x3333`, add `0x4444`, and add `0x11111111` sequentially. Its FLA result is **`F9CD8332` instead of `DBEFFCE7`**. The other five showcase values are unchanged. This is not an “analysis succeeded, assembler failed” result: the grouping/recovered successor model is already wrong before reassembly. The output is a valid, runnable PE but an invalid deobfuscation result.

The invalid output is retained only as failure evidence under [Polaris O0](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/polaris/o0); it must not be presented as a successful course binary. SHA-256: `B5128151069B2F3CC34BBC3E2E63FE1C82040F3C82F95FDE3D77292A5ADD93EA`.

## 7. CFG measurements and O0 versus O2

Numbers below are **blocks / directed edges / machine instructions**. Recursive CFG metrics exclude unreachable `CC` filler and embedded data; calls split Miasm blocks. NOPs actually reached in the rewritten CFG are included. Full branch/indirect counts are in [cfg_metrics.csv](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/cfg_metrics.csv).

| Family / opt | Clean | Obfuscated reference | Stock rewritten |
|---|---|---|---|
| OLLVM O0 | 21 / 26 / 68 | 60 / 78 / 190 | 17 / 22 / 111 |
| Hikari O0 | 21 / 26 / 68 | 66 / 86 / 202 | 20 / 26 / 118 |
| Polaris O0 | 21 / 26 / 68 | 56 / 74 / 165 | 10 / 12 / 82 — **incorrect** |
| Tigress O0 | 19 / 24 / 67 | 38 / 61 / 120 | None |
| OLLVM O2 | 7 / 6 / 45 | 50 / 79 / 132 | None |
| Hikari O2 | 7 / 6 / 45 | 49 / 76 / 155 | None |
| Polaris O2 | 7 / 6 / 45 | 18 / 27 / 74 | None |
| Tigress O2 | 7 / 6 / 48 | 25 / 44 / 83 | None |

The Tigress reference CFGs include independently verified jump-table edges. Stock initial discovery sees only **6 / 6 / 22** at O0 and **3 / 3 / 16** at O2. These incomplete views are separately retained, never substituted into the stock tool or silently reported as the full function.

Optimization effect:

- **OLLVM/Hikari:** success at O0 becomes recognizer failure at O2. Optimization removes the separate one-successor predispatcher layout. The highest-in-degree block is now the actual dispatcher with two successors and the function entry among its parents. `find_backbone_blocks` indexes the entry's nonexistent predecessor, raising `IndexError` at upstream line 200. Symbolic recovery is not reached. Actual O2 state storage is R9D for OLLVM and ECX copied to EBP for Hikari.
- **Polaris:** O2 has already if-converted the initial branch and unrolled the loop; retained IR leaves six flattening regions around the final switch. This smaller CFG still triggers the same classifier error. Actual state is `[RSP+4]`, read into R9D. Fewer blocks do not make the stock recognizer compatible.
- **Tigress:** the jump table persists; state moves from 64-bit stack storage to RDX. The stock discovery/score problem remains. This does not establish that symbolic execution itself cannot handle the optimized semantics.

Graph equality with clean compiler output is neither expected nor required. OLLVM's rewritten graph has fewer blocks than its clean reference because linear semantic regions can be merged; it still retains more instructions due to dead state operations and branch padding.

## 8. Semantic-edge ground truth and precision/recall

[semantic_ground_truth.py](E:/Workspace/seeing_through_obfuscation/scripts/deobfuscation/unflattening/semantic_ground_truth.py) derives reference successors independently from retained IR/C, before consulting the recovery maps. It follows state stores, constant/SSA-select choices, incoming PHI values, direct branches, and nested switches. Tigress uses generated C cases/state updates with source `#line` provenance. The canonical source supplies the operation/region meaning.

[map_regions.py](E:/Workspace/seeing_through_obfuscation/scripts/deobfuscation/unflattening/map_regions.py) cross-checks region entry routes against PE equality-test edges or the verified jump table. Every retained IR/C case region has a corresponding PE dispatch entry candidate. Full IR/source bodies and machine-block instructions are retained for review in each `provenance_region_map.json`; constants are join keys, not sufficient semantic evidence by themselves.

**Unit:** directed region-successor pairs, including a synthetic entry 0. These are not raw machine edges. A region is identified by its retained dispatcher case identifier; for Polaris, a direct semantic case entry can occur without assigning that identifier to the runtime state. This distinction is exactly where stock grouping loses information. Structurally present lowered-switch arms are retained; the metric does not claim path-feasibility solving.

| Case | True pairs | TP | FP | Unresolved | Precision | Recall |
|---|---:|---:|---:|---:|---:|---:|
| OLLVM O0 | 25 | 25 | 0 | 0 | 100% | 100% |
| Hikari O0 | 28 | 28 | 0 | 0 | 100% | 100% |
| Polaris O0 | 22 | 14 | 1 | 8 | 93.33% | 63.64% |
| Tigress O0 | 22 | 0 | 0 | 22 | Undefined | 0% |
| OLLVM O2 | 25 | 0 | 0 | 25 | Undefined | 0% |
| Hikari O2 | 28 | 0 | 0 | 28 | Undefined | 0% |
| Polaris O2 | 9 | 0 | 0 | 9 | Undefined | 0% |
| Tigress O2 | 22 | 0 | 0 | 22 | Undefined | 0% |

Precision is undefined when no pairs are recovered, not 100%. Region-pair agreement does not prove branch polarity, arithmetic equivalence, or correctness for every input. Runtime checks and direct assembly review provide separate evidence. [semantic_edges.csv](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/semantic_edges.csv) lists every TP/FP/unresolved pair with evidence paths.

## 9. Rewrite and Windows PE validation

Every produced primary-corpus output was parsed as PE32+/AMD64, disassembled from its exact bytes, and executed. The required outputs are:

```text
SUB      = 08080000
BCF      = 6665BBBC
FLA      = DBEFFCE7
CALLS    = 12345F05
DATA     = 57977293
COMBINED = EEBB6D71
SHOWCASE PASS
```

OLLVM and Hikari match all six plus exit 0. Polaris reports one mismatch and exits 1. All eight untouched input specimens were also run and matched the expected values.

For all three rewritten corpus PEs, file size, headers/sections, exports, unwind records, and every byte **outside the original target interval** remain unchanged. The rewrite is whole-function compaction within that interval, not a new section. Entry/export addresses stay stable, but internal instruction addresses change. Original dispatcher instructions are absent from the reachable rewritten CFG; stale bytes or `CC` padding elsewhere in the interval are not counted as live code.

**Debugging warning:** do not load the original PDB against a rewritten body. The unchanged PE debug record may still reference it, but internal line/address mappings are stale. Disable automatic use of that PDB. The unchanged unwind directory is recorded, not certified: exception unwinding, asynchronous stack walking, relocation-sensitive corner cases, and all input values were not exhaustively validated.

No deobfuscator seed option is provided. A second, passively traced stock invocation generated a patch byte-identical to each of the three CLI-produced bodies. This is local repeatability evidence, not a cross-version/platform determinism guarantee. Existing obfuscation seeds are provenance only; binaries were not regenerated.

## 10. Tigress-specific findings

The generated C retains a 64-bit `next` state, `while (1)`, and `switch(next)`. MSVC lowers this to a range check on `state-1`, a table of 21 **32-bit RVAs**, base addition, and an indirect jump. Valid source states occupy 16 table entries; unused entries route back to the dispatch loop.

- O0 table: RVA `0x1260`; indirect jump VA `0x14000107F`; state `[RSP+0x10]` after the stack allocation.
- O2 table: RVA `0x1558`; indirect jump VA `0x140001445`; state RDX.

The read-only reference reconstruction decodes all 21 entries with their observed bounds and excludes the table bytes from instruction counts. It is **not** input to stock or assisted recovery. The platform-fix initialization store is visible but does not explain the missing table edges.

Additional downstream challenges remain: O0 conditional updates use branch-separated stores rather than uniformly CMOV-selected state constants; the legitimate switch has four successors. O2 also includes arithmetic state selection and a BT/CMOV condition, while upstream's special CMOV handling searches for CMP/TEST in the same block. The present stock failure occurs earlier; these observations must not be mislabeled as measured symbolic failures.

## 11. Implementation assumptions

Full per-case values are in [transfer_assumptions.csv](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/transfer_assumptions.csv).

| Assumption | Evidence from this study |
|---|---|
| Initial CFG discovery contains the dispatcher targets | True for LLVM-family cases; false for both Tigress jump tables |
| Score has a usable predecessor-free head | False for the invalid BinProtect CFG; its entry has an incoming back-edge |
| Highest-in-degree block is a separate one-successor predispatcher | Fits the three LLVM-family O0 layouts; false at O2 |
| Every selected predispatcher parent itself has a predecessor | Entry violates this at O2; unguarded indexing fails |
| Dispatcher's first instruction operand two is the state | Fits O0 MOV-from-stack; would select an immediate in several other layouts |
| A state group describes a linear semantic path | False for Polaris O0's surviving legitimate switch |
| Conditional grouping can be rewritten with one CMOV-derived binary choice | Fits tested OLLVM/Hikari O0; not a general multiway-branch solution |
| Reassembly alone establishes successful deobfuscation | Refuted by Polaris's valid but wrong PE |

## 12. One bounded generic assisted experiment

After stock tables and the stock hash manifest were preserved, one generic adapter replaced only the flattening score with 1.0. No family-specific state constants, dispatcher signatures, jump-table recovery, or successor logic was injected. It was applied to the score-rejected Tigress O0/O2 cases and then reused on BinProtect static-only.

| Case | Assisted result |
|---|---|
| Tigress O0 | Proceeds past score, then entry-predecessor `IndexError`; no state recovery or patch |
| Tigress O2 | Repeated predecessor walk; stopped by 15-second diagnostic watchdog; no patch |
| BinProtect static-only | Chooses immediate `0x8444` as the supposed state; nonsensical grouping, then Keystone missing-symbol error; no patch |

An initial unbounded Tigress O2 diagnostic attempt was interrupted; the reported repeat has both a Python watchdog and an external timeout. These are **assisted failures**, not changed stock results. No assisted PE was created or executed. The adapter did not improve validated successor recovery. [Assisted results](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/assisted_results.json) retain the failures and observed candidate state separately from valid state identification.

This only rules out “the numerical threshold is the sole obstacle.” It does not show that the symbolic core fundamentally cannot transfer after better CFG/state identification. More extensive adapters were deliberately not attempted.

## 13. BinProtect static-only stress case

**STATIC ONLY / SEMANTICALLY INVALID PROTECTED PE. NEVER EXECUTED IN THIS PHASE.**

Input: `E:\Workspace\seeing_through_obfuscation\results\binprotect_showcase_v1\cff\o0\showcase_protected.exe`.

SHA-256: `5BD0F323072218DE9638C0BF1C49F7DE76BD2222B465D15C169C13224E837F01`. Target VA `0x1400016B9`, recorded unwind range through `0x140001A69`. Static CFG: 81 blocks, 106 edges, 275 instructions, 26 conditional branches, 53 JMP instructions, no indirect jump.

The dispatcher is a linear `CMP EAX,imm16` / `JNZ` chain, with register/flags preservation, direct case jumps, state-update stubs, and an unmatched-state `INT3`. Stock score is **0.0**, not merely just below 0.9: a decoded edge from `0x140001813` jumps into the function entry, and the reachable graph has no predecessor-free head for the scoring loop. Thus no stock rewrite is attempted.

The same score-only adapter reaches deeper but mistakes the comparison literal `0x8444` for the state. It groups unrelated blocks under that constant and reaches a Keystone missing-symbol failure. The two recorded successor pairs are unvalidated artifacts of incorrect state selection, not successful semantic recovery. No output PE or repair claim is made; precision/recall and runtime are not scored for this invalid input. See [binprotect_static](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/binprotect_static).

## 14. RPISEC methodology comparison

Only public source was inspected/archived; no Binary Ninja plugin was installed or executed. Reference commit: `3f13f4f3c16dfe57f58f3c280ba2a3c341bc2d87`, MIT license. Its [README](https://github.com/RPISEC/llvm-deobfuscator/blob/3f13f4f3c16dfe57f58f3c280ba2a3c341bc2d87/README.md) starts from a user-selected state definition and uses Binary Ninja SSA.

In [deflatten.py](https://github.com/RPISEC/llvm-deobfuscator/blob/3f13f4f3c16dfe57f58f3c280ba2a3c341bc2d87/deflatten.py), state uses locate comparison blocks; definitions identify original blocks; PHI versions resolve two-way state choices. SSA definition traversal also identifies state-related instructions to remove. It patches links within original block locations, unlike this tool's global body reordering.

**Inference, not a measured result:** def/use tracking is a promising way around O2 register copies and the fragile first-instruction/high-in-degree rules. It does not automatically fix indirect CFG discovery, Polaris's surviving multiway semantic switch, or Windows rewrite metadata. The inspected plugin itself assumes comparison-based dispatch, two-way PHIs, CMOV-derived conditions, and specific outgoing-edge ordering. It is not evidence of universal transfer or a ready modern Windows solution.

## 15. Evidence and reproducibility map

The requested paired CSV/JSON outputs exist:

- [stock_results](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/stock_results.json): identity/hash/target, recognition, recovered edges, rewrite/runtime, before/after/clean metrics.
- [cfg_metrics](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/cfg_metrics.json): complete versus incomplete CFG scope, branch counts and exact PE hashes.
- [semantic_edges](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/semantic_edges.json): individual TP/FP/unresolved pairs and provenance.
- [transfer_assumptions](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/transfer_assumptions.json): selected structural roles, state expressions, and violated assumptions.

Additional edge-score, assisted-result, course-example, source/hash, runtime and audit records make the summaries auditable. Project-owned scripts are under [scripts/deobfuscation/unflattening](E:/Workspace/seeing_through_obfuscation/scripts/deobfuscation/unflattening). The raw CLI artifacts are preserved by [stock manifest](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/stock_transfer/preserved_stock_manifest.json); stock execution helpers refuse to overwrite existing outputs/results.

## 16. Limitations and preservation

The two successful runtime tests exercise the frozen showcase's canonical inputs, not every uint32 input. Edge sets do not prove predicate polarity or all-path semantics. Only one retained specimen per family/optimization was tested, with one tool/dependency configuration. No ELF, x86-32, exception-path, ASLR-relocation stress, multiple-function `--all`, or broader ABI validation was added.

Tigress completeness is a read-only, manually verified reference reconstruction; stock sees fewer nodes. BinProtect is already invalid and cannot be used as evidence of failed runnable semantic equivalence. A correct-looking graph or a successful exit from the Python CLI is never sufficient for success.

The [evidence audit](E:/Workspace/seeing_through_obfuscation/results/deobfuscation/unflattening/summaries/evidence_audit.json) verifies frozen source/version hashes, selected original binaries and provenance, upstream file hashes/clean status, preserved stock evidence, unchanged bytes outside rewritten targets, the separate msynth revision/oracle, and rendered artifacts. The frozen showcase remains `39FEF0BB2A9742870F3D6F7CC864F7CFFA129136F6D2A59C4FB37F25906B99D2`; the complex probe remains `026AA69530C711ACC856C62A21852ABC0F536D7784717C9EBDC48252BCA47F37`. No earlier evidence, source, toolchain, or course design was modified.

## 17. Implications and next phase

The strongest positive transfer evidence is **Hikari O0**, unchanged stock success with complete reference-edge recovery and a functioning PE. The strongest counterexamples are **Polaris O0**, where recognized structure yields a wrong executable, and **OLLVM O2**, where the intended family fails before symbolic recovery. Family lineage alone is less predictive than concrete machine layout and state/branch representation.

The four course examples are OLLVM O0 (positive control), Hikari O0 (lineage transfer), Polaris O0 (a smaller CFG can be wrong), and Tigress O0 (same source semantics, different discovery requirements). Their full CFGs, clean references, state explanations, successor examples, and available runtime evidence are linked in the companion guide.

**Recommended next phase: further bounded unflattening work**, beginning with optimization-robust state/dispatcher identification and multiway semantic-region preservation. Preserve these stock baselines. A future comparison can test SSA-assisted identification without claiming that identification alone fixes rewriting. Opaque-predicate solving and Mergen/lifting should wait for an explicit new task; neither was started here.
