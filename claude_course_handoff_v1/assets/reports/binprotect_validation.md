# BinProtect showcase v1 validation

## Outcome

BinProtect structurally applied Linear, MBA, opaque predicates, and CFF to both MSVC O0 and O2 x64 PEs and returned exit code 0 for all eight invocations. It did **not** produce a semantically valid protected executable in any condition. Seven protected PEs terminated with access violation `0xC0000005`; opaque O2 remained running without output and was killed by the harness after 15 seconds. All protected stdout/stderr files are empty. The two clean inputs both printed all six expected values plus `SHOWCASE PASS` and exited 0.

The experiment therefore answers two different questions:

- Structural implementation: all four transformations are plainly visible in the retained output PEs.
- Windows x64 compatibility of this build on the full showcase: 0/8 protected outputs passed, so none is eligible for a runnable course corpus in its current form.

No BinProtect source was modified, virtualization was never enabled, no passes were combined, endpoint security was not weakened, and no deobfuscation was attempted. The frozen source remains SHA-256 `39FEF0BB2A9742870F3D6F7CC864F7CFFA129136F6D2A59C4FB37F25906B99D2`.

## Identity

| Item | Verified value |
|---|---|
| Project | `noahware/binprotect` checkout |
| Source | `E:\Workspace\seeing_through_obfuscation\third_party\obfuscators\binprotect` |
| Commit | `067c2db79196e4809685e9af1862fd3222a41d80` |
| Source state | Clean (`git status --short` empty; a per-command `safe.directory` override was used, without changing global Git configuration) |
| Executable | `E:\Workspace\seeing_through_obfuscation\builds\binprotect\Release\binprotect.exe` |
| `--version` | `1.0` |
| Executable SHA-256 | `1DDEF88C79BE8756BD2AADD0FD5C7D0F63F24C7C3321D00B8A5C2C459F4CC805` |

The existing verified binary was used; no rebuild was necessary. Exact help/version output, Git identity/status, source-code excerpts with line numbers, and their hashes are retained under `results/binprotect_showcase_v1/identity/`.

## CLI and defaults

`binprotect --help` reports positional `binary-path`, optional positional `symbol-path`, output aliases `--out`, `--out-path`, and `--out-binary-path`, plus `--cff`, `--vm`, `--opa`, `--lin`, and `--mba`. Source inspection establishes the actual defaults:

| Setting | CLI aliases | Default | Meaning in this experiment |
|---|---|---:|---|
| CFF | `--cff`, `--control-flow-flattening` | 1 | Global function-level CFF loop |
| VM | `--vm`, `--virtual-machine` | 1 | Virtualizes blocks created by opaque processing; explicitly 0 everywhere here |
| Opaque | `--opa`, `--opaque`, `--opaque-predicate(s)` | 1 | Global eligible-basic-block opaque pass |
| Linear | `--lin`, `--linear-substitution` | 1 | Global eligible-basic-block operand substitution |
| MBA | `--mba`, `--mixed-boolean-arithmetic` | 2 | Number of global MBA passes; 1 only in the isolated MBA lane |
| Output | `--out` aliases | empty | Empty means `output.exe`; every run supplied an explicit path |

There is no function selector and no seed option. Every controlled invocation explicitly set all five transformation values. The exact commands are retained beside each result. Their isolated flag vectors were:

| Condition | Explicit vector (`cff vm opa lin mba`) |
|---|---|
| Linear | `0 0 0 1 0` |
| MBA | `0 0 0 0 1` |
| Opaque | `0 0 1 0 0` |
| CFF | `1 0 0 0 0` |

The supplied full PDB was the second positional argument. For example, Linear O0 used:

```text
E:\Workspace\seeing_through_obfuscation\builds\binprotect\Release\binprotect.exe E:\Workspace\seeing_through_obfuscation\results\binprotect_showcase_v1\inputs\o0\showcase.exe E:\Workspace\seeing_through_obfuscation\results\binprotect_showcase_v1\inputs\o0\showcase.pdb --out E:\Workspace\seeing_through_obfuscation\results\binprotect_showcase_v1\linear\o0\showcase_protected.exe --cff 0 --vm 0 --opa 0 --lin 1 --mba 0
```

## Randomness and reproducibility

`ext/binwrite/util/random.hpp` creates a thread-local `std::random_device` and seeds a thread-local `std::mt19937_64` from it. Integral selection, random Boolean choices, template selection, register selection, and shuffling share that generator. The CLI exposes no seed and there is no fixed-seed path.

Two fresh-process Linear O0 repeats produced different hashes:

| Repeat | SHA-256 | Runtime |
|---:|---|---|
| 1 | `8E6C6372AF7EB91DD59AF96DB2802FDCB3071CE6848DC83A5D1CD62B7608524F` | `0xC0000005` |
| 2 | `F93FFD599EBA599BD030EFCBA236A3CCF8E31FE6811A70EA2450906A1C263D83` | `0xC0000005` |

Outputs are therefore non-deterministic and cannot be reproduced byte-for-byte from a recorded user seed. Retained binaries and hashes are the authoritative specimens.

## Symbol, PDB, MAP, and scope behavior

The matching full PDB materially benefits discovery and exception handling. `main.cpp` first tries PDB parsing, then MAP parsing; if neither succeeds, it warns and disables exception-directory support. With the supplied PDB, the logs show successful MSVC scope/`FuncInfo` parsing and exception processing.

BinProtect then iterates all discovered functions for CFF and snapshots all eligible basic blocks for Opaque, Linear, and MBA. The target-function names in this report are measurement scopes, not pass-selection scopes. Runtime/CRT code discovered in the statically linked PE is also in scope.

Before recompilation the tool calls `pe.clear_symbol_rvas()`. It does not write a new PDB or MAP. The original PDB/MAP is retained only as pre-protection evidence; it must not be loaded as if it described post-protection addresses. The output export directory still contains all nine exported showcase names, which permits recovery of the post-protection RVAs used here.

## Clean MSVC inputs

Both builds used MSVC x64 19.51.36248 (`cl.exe` SHA-256 `DC8426B8760D92CF757DF3D10B9F0244A95B454FF43194A58161568A0EC70D53`) in the Visual Studio 2026 developer environment. Both link commands used `/MACHINE:X64 /DEBUG:FULL /PDB /MAP /INCREMENTAL:NO /OPT:NOREF /OPT:NOICF /Brepro`. Compile flags common to both were `/TC /c /Zi /FS /Oy- /FAsc`; only the optimization selection differed:

- O0: `/Od /Ob0`
- O2: `/O2`

| Input | PE SHA-256 | Size | Runtime | Key target baseline |
|---|---|---:|---|---|
| O0 | `824BE8811E8E4053D5BD866241364ED4BF7B863702B0DCE5B824950DB34C4D6B` | 556,032 | pass, exit 0 | SUB 249 instructions; BCF 11 blocks/14 edges; FLA 19 blocks/24 edges |
| O2 | `62B91D8FDACB175FB5BB8AFFE7557338A5BFE6623930ED8BC78EC580E0C631C6` | 555,008 | pass, exit 0 | SUB 106 instructions; BCF 3 blocks/3 edges; FLA 7 blocks/6 edges |

Both actual `demo_substitution` inputs retain 8 immediate XOR `0x12345678`, 8 ADD `0x1337`, and 8 SUB `0x1111` machine sites. O2 is not assumed to match source in general; this count comes from its retained PE disassembly.

## Matrix result

Metrics use exact post-link/post-protection `llvm-objdump` disassembly. Function ranges use the matching PE exception-directory `RUNTIME_FUNCTION` begin/end addresses where present, checked against exports and clean MAP boundaries. Leaf targets without unwind records use adjacent export/MAP boundaries with trailing alignment removed. The boundary and evidence source are recorded in every metrics JSON. Using only the next exported label would incorrectly include `main` and `printf` in O2 `demo_substitution`: the correct clean function is RVA `0x1430..0x15E7` (end exclusive), 106 instructions and 439 bytes. Its Linear output is `0x1995..0x23C8`, and its MBA output is `0x181F..0x1CCC`.

Block leaders are function entry, in-range direct branch targets, and instructions after branches, returns, or traps. CFG edges count internal direct/fallthrough edges; external and unresolved transfers are separate fields. `int3` is a terminator, with no ordinary fallthrough. These are static syntactic counts, including the generated bogus code within the range, not a proof of reachability. Opaque O0 has three additional external branch edges from its generated code. Growth ratios compare each protected target with the matching clean optimization level; zero-denominator edge ratios are null.

| Pass/input | Protect | Runtime | Target instructions | Blocks / edges | Cond / uncond / indirect branches | Target bytes | Growth: instructions / blocks / bytes | Whole PE |
|---|---:|---|---:|---:|---:|---:|---:|---:|
| Linear O0 | 0 | AV `0xC0000005` | 249 | 1 / 0 | 0 / 0 / 0 | 1,015 | 1.00× / 1.00× / 1.00× | 942,080 (1.69×) |
| Linear O2 | 0 | AV `0xC0000005` | 943 | 1 / 0 | 0 / 0 / 0 | 2,611 | 8.90× / 1.00× / 5.95× | 933,888 (1.68×) |
| MBA O0 | 0 | AV `0xC0000005` | 249 | 1 / 0 | 0 / 0 / 0 | 1,015 | 1.00× / 1.00× / 1.00× | 724,992 (1.30×) |
| MBA O2 | 0 | AV `0xC0000005` | 381 | 1 / 0 | 0 / 0 / 0 | 1,197 | 3.59× / 1.00× / 2.73× | 724,992 (1.31×) |
| Opaque O0 | 0 | AV `0xC0000005` | 496 | 36 / 49 | 18 / 10 / 0 | 1,678 | 12.72× / 3.27× / 11.82× | 2,162,688 (3.89×) |
| Opaque O2 | 0 | timeout, 15 s | 141 | 10 / 12 | 4 / 2 / 0 | 486 | 7.42× / 3.33× / 5.79× | 2,146,304 (3.87×) |
| CFF O0 | 0 | AV `0xC0000005` | 275 | 81 / 105 | 26 / 53 / 0 | 944 | 4.10× / 4.26× / 4.21× | 1,437,696 (2.59×) |
| CFF O2 | 0 | AV `0xC0000005` | 109 | 28 / 33 | 10 / 13 / 0 | 454 | 2.27× / 4.00× / 2.17× | 1,429,504 (2.58×) |

All eight outputs remain validly inspectable `COFF-x86-64 / IMAGE_FILE_MACHINE_AMD64` PEs. “Protect 0” means the tool reported success and emitted the file; it does not mean runtime success.

## Linear substitution

The implementation walks instructions starting at index 1 in every eligible block. For the first immediate or memory operand it selects an unused register, saves the register and flags, represents the operand as two random values whose subtraction reconstructs it, executes the rewritten instruction through the temporary, and restores state. Memory displacements receive the analogous base-plus-random-minus-random treatment.

Target coverage is sharply optimization-dependent:

| Input | Actual target sites before | Eligible after frame-conflict screening | Target sites rewritten | Original target constants after | Concrete diversity |
|---|---:|---:|---:|---:|---|
| O0 | 8 XOR + 8 ADD + 8 SUB | 0 | 0/24 | all 24 remain | none in target |
| O2 | 8 XOR + 8 ADD + 8 SUB | 24 | 24/24 | 0 | one semantic template, 24 distinct observed random pairs |

Source inspection explains the O0 exclusion: `ext/binwrite/binary/pe/pe_frame_pointer_scan.cpp:280` declares a rewrite conflict for a memory operand with RSP base and an index register. The O0 target contains many such operands, for example `movl %eax,(%rsp,%rcx)` at input VA `0x140001089`. `pe_frame_pointer.cpp` responds by marking the function's blocks to skip; `main.cpp` skips those blocks before either Linear or MBA. O2 uses fixed stack displacements instead and does not meet that conflict condition. This is static source/assembly evidence; the tool does not emit a per-function skip log.

The whole O0 PE still grows 69%, and logs show attempted substitutions elsewhere. O2 also rewrites many address/displacement operands, producing 95 pushfq/popfq scaffolds and 8.90× target instruction growth. All 24 intended immediate sites were recognized by the complete save/materialize/subtract/restore/use scaffold, and each random pair was checked to reconstruct the expected 32-bit constant. The individual addresses and pairs are recorded in `linear/o2/metrics.json`.

The structural template is highly recognizable and diversified mainly by scratch registers and random constants, not by different algebraic identities. The output crashes in both optimization lanes.

## MBA

The MBA pass also starts at instruction index 1 per basic block. It recognizes ADD, SUB, AND, OR, and XOR and randomly selects a source-coded identity. Available template counts are ADD 3, SUB 3, AND 2, OR 2, and XOR 1; flag emulation may add more code when a later instruction depends on flags.

| Input | Target coverage | Target instructions / bytes | Observed target template diversity | Constant behavior |
|---|---:|---:|---|---|
| O0 | 0/24 | 249 / 1,015 (unchanged) | none | all 24 native immediates remain |
| O2 | 24/24 | 381 / 1,197 | XOR 1; ADD 3; SUB 3 | constants remain recognizable and are repeated inside identities |

The O2 XOR identity is `(x | y) - (x & y)`. The three observed ADD signatures correspond to AND/OR/add, AND/XOR/shift/add, and XOR/OR/shift/sub forms. The three SUB signatures use combinations of XOR, NOT, AND, shift, and subtraction. Repeated identical source operations therefore receive varying encodings for ADD and SUB, but XOR has only one available identity. No optimizer runs after BinProtect, so all inserted machine sequences remain present in the PE. Nevertheless, both outputs crash.

The eight ADD sites use those three forms 3/3/2 times. The SUB signatures NOT/AND/shift/XOR/sub, NOT/NOT/AND/AND/sub, and XOR/NOT/AND/shift/sub occur 2/4/2 times. Across the corrected O2 target, MBA introduces 33 AND, 20 OR, 12 NOT, and 9 shift instructions (all absent in the clean target). The three intended constants occur as immediates 24/22/18 times in the output, versus 8/8/8 in the input. The O0 skip uses the same RSP-index conflict path as Linear.

## Opaque predicates

For each eligible original block, source inspection shows that BinProtect:

1. copies the block;
2. replaces visible operands in the copy with randomly selected operands collected from that block;
3. generates three random register values and raises them to a random power from 3 through 7;
4. compares a Fermat-style `x^n + y^n` relation with `z^n`;
5. XORs saved ZF (`0x40`) once or twice depending on randomized physical ordering, intending to route to the real block;
6. retains the shuffled copy as a bogus successor.

This source provenance is the basis for calling the copied successors intended bogus blocks. It is not a proof that the predicate is opaque for every machine state: the generated arithmetic wraps at 64 bits, so the integer Fermat theorem alone would not establish that claim. No symbolic deobfuscation or universal predicate proof was attempted here.

| Input | Clean blocks/edges | Protected blocks/edges | Predicates / shuffled copies | Cond branches | Instructions / bytes |
|---|---:|---:|---:|---:|---:|
| O0 | 11 / 14 | 36 / 49 | 11 / 11 | 4→18 | 39→496 / 142→1,678 |
| O2 | 3 / 3 | 10 / 12 | 3 / 3 | 1→4 | 19→141 / 84→486 |

The template is fixed in broad shape but randomized in registers, constants, exponent, block ordering, and operand shuffling. O0 starts from more blocks and gets more absolute expansion; normalized block growth is almost identical (3.27× vs 3.33×). Opaque O0 access-violates; opaque O2 is the only non-terminating case.

## Control-flow flattening

CFF assigns a unique random 16-bit ID to every collected block, chooses a random register family for the state, shuffles the block list, and inserts a dispatcher composed of a linear chain:

```text
cmp state_id, state_register
jnz next_comparison
pop state_register
popfq
jmp semantic_block
```

If no ID matches, the chain reaches `int3`. Transition stubs save flags/state, load the next ID, and direct-jump back to the dispatcher anchor. This is not a switch, jump table, or indirect-branch dispatcher: both targets contain zero indirect branches.

| Input | Clean blocks/edges | Protected blocks/edges | Dispatcher compare sites | Branches cond/uncond | Instructions / bytes |
|---|---:|---:|---:|---:|---:|
| O0 | 19 / 24 | 81 / 105 | 20 | 26 / 53 | 67→275 / 224→944 |
| O2 | 7 / 6 | 28 / 33 | 7 | 10 / 13 | 48→109 / 209→454 |

Semantic regions remain visible after the comparison chain and state-loading stubs, making this output manually recognizable but structurally much noisier. O2's optimized source structure supplies fewer blocks, so it yields a far smaller dispatcher in absolute terms, while normalized block growth remains about 4× in both lanes. Both outputs access-violate.

## O0 versus O2

The result is not the simple expectation that an unoptimized input always gives BinProtect more to transform:

- Linear and MBA have **zero measured target coverage at O0 and full 24/24 coverage at O2**. O0's indexed stack operands trigger the frame-rewrite conflict/whole-function skip path; O2's fixed stack displacements permit transformation.
- Opaque expands O0 much more in absolute instructions because O0 exposes 11 target blocks rather than 3, but normalized block growth is nearly the same.
- CFF similarly mirrors input CFG size: O0 gets a 20-entry comparison chain; O2 gets 7. O0 is 4.10× clean instructions versus O2's 2.27×, but both are about 4× the clean block count.
- Runtime correctness does not improve with either optimization level. The one mode difference is opaque: O0 crashes, O2 hangs.

Optimization level must therefore remain a first-class treatment variable even for a post-link obfuscator. It changes both the source machine representation seen by BinProtect and the pass's coverage.

## Runtime failure and Windows limitations

The exact isolated culprit conditions are established: every pass independently produces a failing PE on both inputs. The common access-violation status is `-1073741819`/`0xC0000005`; opaque O2 times out. No protected process printed any showcase line, so the built-in semantic checks were never observed.

No debugger crash trace was collected, so the exact faulting instruction remains unlocalized. The retained evidence does support a narrower diagnosis:

- PDB/exception parsing did run, so this is not the no-symbol fallback.
- Every pass is global and rewrites far beyond the selected measurement function.
- Before transformation, the disassembler reports hundreds of CFG-recovery errors: O0 repeatedly reports 137 missing targets and 96 missing fallthrough blocks; O2 reports 141 and 90, plus individual unresolved conditional-jump references. Linear adds over 600 unsupported-instruction substitution errors.
- The failures span all four pass implementations, which is consistent with a shared full-image discovery/recompile limitation or global rewriting of CRT/startup code. It does not prove one exact root cause.

No endpoint-security rejection occurred. The harness started all eight outputs normally; the failures were process runtime failures. The runner's 15-second timeout prevents the opaque O2 hang from stalling validation.

This experiment does not patch the suspected defect, as requested. Proposed follow-up engineering work is to collect a debugger crash trace and compare an explicitly all-disabled rewrite control before changing discovery/recompilation logic. A function/RVA allowlist could later isolate target code from runtime code, but was neither added nor tested here.

## Comparison with OLLVM, Hikari, Polaris, and Tigress

- Arithmetic: OLLVM/Hikari/Polaris SUB and Polaris MBA operate before instruction selection; later optimization can canonicalize or remove much of the inserted structure. Tigress emits source expressions that MSVC later optimizes. BinProtect O2 Linear/MBA leaves every emitted scaffold or identity in final machine code because no compiler pass follows it. That gives strong structural persistence, but not semantic validity.
- Opaque control flow: OLLVM and Polaris clone IR regions behind algebraic predicates; Hikari's literal-true guards largely fold away; Tigress uses source-visible runtime opaque state. BinProtect clones machine blocks and corrupts operands in the bogus copy behind a randomized Fermat-style predicate. It produces substantial machine expansion, but its output fails.
- Flattening: OLLVM, Hikari, Polaris, and Tigress use state dispatch that begins as an LLVM/source `switch` and may lower to switches, indirect jumps, or direct comparison networks. BinProtect directly constructs a machine-level linear `cmp/jnz` chain with direct jumps and a trap, so it has no indirect dispatch even before any optimizer.
- Reproducibility: controlled LLVM-family passes are often fixed-seed or empirically deterministic; Tigress accepts a seed though complete generated files may still vary; this BinProtect build has no seed control and is demonstrably non-deterministic.

## Dataset recommendation

Do not include any of these eight BinProtect outputs as a runnable controlled-corpus condition. The runtime failure is disqualifying even though the structures are analytically useful.

Retain four static/manual case studies:

- opaque O0, for the clearest machine-level cloned-block/predicate construction;
- CFF O0, for the largest comparison-chain dispatcher;
- MBA O2, for complete 24-site coverage and 1/3/3 XOR/ADD/SUB template diversity;
- Linear O2, for complete target coverage and 24 distinct random constant pairs.

Also retain Linear O0 and MBA O0 as negative coverage controls. If a later upstream fix or strictly scoped function allowlist yields semantically valid outputs, rerun the same matrix rather than promoting the current PEs.

## Evidence map

- Root: `results\binprotect_showcase_v1\`
- Manual selection: `MANUAL_ANALYSIS_INDEX.md`
- Repeatable build/protection runner: `run_binprotect_matrix.ps1`
- Metrics analyzer: `analyze_binprotect.py`
- Identity capture and retained-artifact verifier: `finalize_evidence.py`
- Identity/CLI/source provenance: `identity/identity.json`, `identity/help_stdout.txt`, `identity/source_evidence.json`
- Condition-level inventory: `summaries\all_builds.{csv,json}`
- Target metrics: `summaries\binprotect_metrics.{csv,json}`
- CFG-focused metrics: `summaries\cfg_metrics.{csv,json}`
- Raw execution records: `summaries\raw_records.json`
- Reproducibility: `reproducibility\linear_o0_repeats.{csv,json}`
- Final checks and retained-file hashes: `summaries/evidence_audit.json`, `summaries/artifact_manifest.json`

Every condition directory contains commands, logs, PE inspection, exports, full disassembly, extracted target disassembly, runtime evidence, metrics, and metadata. The original PDB/MAP is referenced and retained with its clean input rather than duplicated into every directory.

The final audit verified all ten primary PE hashes and AMD64 headers, all eight explicit single-pass flag vectors, both repetition hashes, all 14 target metric records, and exact complete stdout/exit status for both clean inputs. `src/showcase.c` still matches the freeze hash, and the BinProtect checkout is clean. Arithmetic boundary correction and the `int3` terminator correction affect analysis files only; no retained protected PE was regenerated.
