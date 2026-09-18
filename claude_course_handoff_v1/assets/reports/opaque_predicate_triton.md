# Opaque-predicate deobfuscation with Triton DBA

Study completed 2026-09-18 on Windows x64. Target: `demo_bogus_control_flow` in the retained canonical showcase. This is an analysis and read-only CFG projection, **not binary rewriting**.

## 1. Outcome

One actual-byte DSE/SMT harness proved all 22 OLLVM-16 O0 gates and all 16 Polaris O0 gates without vendor templates. Hikari O0 contained no surviving injected conditional gates: its four extant Jccs were genuine. Tigress's three gates required runtime initialization; replaying its actual `main` initialization made all three one-sided while x/y remained symbolic. No genuine branch was classified opaque.

BinProtect is **STATIC ONLY / SEMANTICALLY INVALID PROTECTED PE / DO NOT EXECUTE**. Its 11 isolated intended gates yielded four local one-sided results, four SAT/SAT counterexamples, and three timeouts. None validates the protected PE as a program.

The frozen source remains SHA-256 `39FEF0BB2A9742870F3D6F7CC864F7CFFA129136F6D2A59C4FB37F25906B99D2`. No source, original PE, obfuscator toolchain, prior msynth/unflattener environment or prior study evidence was modified. No corpus rebuild, Mergen work, virtualization work, executable patching or BinProtect repair was performed.

## 2. Framework identity and installation

This is [Jonathan Salwan's Triton dynamic binary analysis library](https://github.com/JonathanSalwan/Triton), installed from the official [`triton-library` distribution](https://pypi.org/project/triton-library/1.0.0rc4/). The unrelated GPU package `triton` was not installed. The DBA binding itself imports as `triton`.

| Item | Recorded value |
|---|---|
| Distribution | `triton-library==1.0.0rc4` |
| Wheel | `triton_library-1.0.0rc4-cp311-cp311-win_amd64.whl` |
| Wheel SHA-256 | `F1BDFB91116AFA83E0A2A24618797117F691BF7AE5B1E117193DC05815FCF905` |
| Environment | `E:\Workspace\seeing_through_obfuscation\.venvs\triton_dba` |
| Python | Anaconda CPython 3.11.4, Windows AMD64; base `D:\Programs\anaconda3_11\python.exe` |
| Binding version | `VERSION.MAJOR=1`, `MINOR=0`, `BUILD=1591` |
| Binding | `.venvs/triton_dba/Lib/site-packages/triton.cp311-win_amd64.pyd` |
| Binding SHA-256 | `8D4E78030B9FC82EA238A50D1D200BAED3960525972259F980BD0470A845D35E` |
| Solver used | Bundled Z3 `4.12.2.0`, explicitly selected |
| Wheel interfaces | Z3, Bitwuzla and LLVM compiled in; only Z3 used |
| Wheel architectures exposed | X86, X86_64, ARM32, AARCH64; only X86_64 tested |
| Upstream HEAD inspected | `bc84cf745e99768e07d51dcd734eba35c59f1b3e` |

The checked upstream commit is **not claimed to be the wheel's build commit**. The installed identity is the exact package, build number and wheel/binding hashes. Current upstream also advertises RISC-V, which is not exposed by this wheel's `ARCH` enumeration. The inspected release supplies Windows CPython wheels for 3.8 through 3.14; this experiment tests only 3.11.

Installation used a project-local wheel download verified against PyPI's SHA-256, then `pip install --no-index <exact wheel>`. No dependency packages were required. No source build, CMake configuration or vcpkg fallback was needed; optional LLVM was neither enabled by us nor invoked. The wheel happens to include that interface already. Exact acquisition/install commands, upstream references, wheel and complete installed-file hashes are in [environment](../results/deobfuscation/opaque_triton/environment/).

## 3. Sanity and prior-method review

The [sanity evidence](../results/deobfuscation/opaque_triton/sanity/sanity.json) creates `TritonContext(ARCH.X86_64)`, symbolizes EAX as 32 bits, processes actual bytes for XOR, ADD and MOV, extracts the ECX AST, and solves ECX=`0xDEAD`. The model `input32=52370` reproduces `0xDEAD` in a fresh concrete Triton context. A contradictory query returns explicit UNSAT.

[X-Tunnel-Opaque-Predicates](https://github.com/JonathanSalwan/X-Tunnel-Opaque-Predicates) was reviewed at `092a59d83be9963dc6a3eee011c5da6d4e0620fd` before harness construction. Its function script analyzes bounded basic-block instruction sequences with symbolic state and tests the inverted path predicate. We reused the general ideas of instruction semantics, bounded exploration and inversion—not signatures, malware samples, byte patterns, or IDA integration. Our experiment adds function-entry exploration, explicit solver statuses, independent provenance, prefix-aware aggregation and native model checks.

The official [small emulator example](https://github.com/JonathanSalwan/Triton/blob/bc84cf745e99768e07d51dcd734eba35c59f1b3e/src/examples/python/small_x86-64_symbolic_emulator.py) informed the mapped-memory/stack loop and narrowly bounded runtime summaries. The [context API](https://triton-library.github.io/documentation/doxygen/py_TritonContext_page.html) documents path predicates and status-returning solver calls. Installed-wheel behavior was tested rather than assumed identical to current documentation.

## 4. Exact artifact inventory and independent ground truth

[Compact inventory](../results/deobfuscation/opaque_triton/inventory/compact_inventory.json) records each original PE path, SHA-256, image base, function VA/RVA and end, compiler/configuration and clean counterpart. The fuller [case inventory](../results/deobfuscation/opaque_triton/inventory/cases.json) retains original compiler versions/hashes, seed/pass arguments and IR/assembly metadata.

All selected PEs use preferred image base `0x140000000`. O0 boundaries are:

| Case | Target VA | End VA, exclusive | Conditional branches |
|---|---:|---:|---:|
| OLLVM-16 BCF | `0x140001630` | `0x140001CB4` | 26 |
| Hikari BCF | `0x140001460` | `0x140001680` | 4 |
| Polaris BCF | `0x140001210` | `0x140001667` | 20 |
| Tigress AddOpaque | `0x140001110` | `0x1400012B0` | 7 |
| BinProtect Opaque — STATIC ONLY, SEMANTICALLY INVALID, DO NOT EXECUTE | `0x1400015F1` | `0x140001C7F` | 18 |

The project-owned PE parser was adapted from the existing inspection helper. It reads exact `RUNTIME_FUNCTION` ranges and follows chained unwind records. In particular, Tigress O2 spans three chained ranges: `0x10E0–0x1133`, `0x1133–0x11C5`, and `0x11C5–0x11FD`. Treating only the first range as the function would miss four Jccs. Optimized leaf functions without unwind entries use recursive instruction reachability through returns, not the next export. Dead clone bytes inside recorded ranges are included in the static inventory.

The [ground-truth CSV](../results/deobfuscation/opaque_triton/summaries/branch_ground_truth.csv) and [JSON](../results/deobfuscation/opaque_triton/summaries/branch_ground_truth.json) label 100 conditional branches across treatments and matching baselines. Labels and provenance hashes were [frozen before target solving](../results/deobfuscation/opaque_triton/ground_truth/freeze.json).

Labels come from source/clean dataflow, retained obfuscated IR and compiler-assembly correspondence, Tigress generated C at lines 10255–10319, and BinProtect's pass-construction source. They are never generated from the solver's answers. OLLVM/Polaris clone destinations and inserted global predicates distinguish gates from source branches. Hikari's mixed-pointer textual IR is read only as provenance, never reparsed. BinProtect's operand-shuffled clone internal branches are labeled separately from its intended gates; “intended opaque” is not a mathematical guarantee under modular arithmetic.

## 5. Loader, state model and bounded DSE

Implementation: [scripts/deobfuscation/opaque_triton](../scripts/deobfuscation/opaque_triton/). It maps readable/executable sections, initializes an aligned Windows x64 synthetic stack and return sentinel, sets RIP to the exact export, and symbolizes **only the low 32 bits** of ECX and EDX as x/y. Upper argument halves are initially zero. A small synthetic TEB records valid stack bounds so the actual `__chkstk` bytes execute in Triton; the call is not skipped.

The generic state model symbolizes first reads from writable PE data, with an arbitrary representative concrete seed of 1. Those values remain unconstrained symbols, not assumed initialization facts. Repeated reads share state; stores are tracked. Read-only PE data remains concrete. Symbolic effective addresses or unsupported/unmapped state stop that path explicitly. They are not silently replaced with concrete addresses. This limitation matters for Tigress's entropy-indexed arrays.

The same `dse.py` handles all runnable families. Triton processes the original x64 bytes; the harness contains no manually translated ISA equations or algebraic predicate recognizers. Limits are 128 runs, 5,000 instructions/run, and 1,500 ms/query. AST optimization, constant folding and aligned memory are enabled. Z3 solver states SAT, UNSAT, TIMEOUT, UNKNOWN and OUTOFMEM remain distinct in evidence.

For each encountered Jcc under prefix P, both `P AND C` and `P AND NOT C` are solved. C means **machine branch taken**, not necessarily “source if true.” SAT models seed alternative executions; completed prefix/outcome pairs are tracked. Complete means no outstanding feasible prefix, no queued work, no truncated run and no inconclusive required query. Non-target stack-probe paths are concrete in this state model.

Aggregates require complete predecessor exploration before issuing `PROVEN ALWAYS-TRUE/FALSE`. Additional prefix-free condition queries guard against merely path-relative implications. Both feasible outcomes across valid contexts produce `GENUINE / TWO-SIDED`; this classification describes feasibility and does not override the independent provenance label. Incomplete one-sided evidence stays UNKNOWN. Unvisited branches stay UNREACHED.

## 6. Clean negative-control gate and native checks

All four same-family clean O0 baselines were explored. Each yields 12 feasible source paths rather than 16: `x==0x1337` implies `(x&0xFF)==0x37`.

| Genuine source condition | True | False | Aggregate |
|---|---|---|---|
| `x == 0x1337` | SAT | SAT | Two-sided |
| `y > 0x12340000` | SAT | SAT | Two-sided |
| `(x & 0xFF) == 0x37` | SAT | SAT | Two-sided across reachable prefixes |
| `(y & 1) == 0` | SAT | SAT | Two-sided |

The low-byte condition is one-sided under the particular earlier prefix `x==0x1337`, but not globally opaque. Its alternate contexts retain the false outcome. This is a deliberate false-positive check.

Retained SAT inputs were called through the original exported clean machine function using a small Windows native driver. It maps the unmodified PE without invoking its loader entry point and compares native results with the frozen source's uint32 behavior. The same approach validated model inputs against runnable treatments. Tigress receives only the emulated-main writable-data snapshot in the private process mapping; code pages and files are unchanged. Separately, all eight runnable full showcase executables printed `SHOWCASE PASS` and exited 0. Native treatment target checks total 187 input/case pairs; every one matches. See [native verification](../results/deobfuscation/opaque_triton/summaries/native_verification/).

## 7. O0 family results

| Lane | Reached / Jccs | Known injected gates | Proved | Genuine two-sided | Incomplete/unreached |
|---|---:|---:|---:|---:|---|
| OLLVM-16 generic | 26/26 | 22 | 22/22 | 4/4 | None |
| Hikari generic | 4/4 | 0 | N/A | 4/4 | No extant gate to detect |
| Polaris generic | 20/20 | 16 | 16/16 | 4/4 | None |
| Tigress generic | 5/7 | 3 | 0/3 | 4/4 | Two array gates unreached; pointer gate SAT/SAT |
| Tigress initialized | 7/7 | 3 | 3/3 | 4/4 | None within imported state |

OLLVM and Polaris gates all have machine-taken SAT and fall-through UNSAT. Their generic writable globals were symbolic, so these are not observations caused by loading zeros from the file. Polaris uses different per-site globals/instruction ordering and `x*(x+1)` versus OLLVM O0's `x*(x-1)` construction. The unchanged solver pipeline handles both. However, these remain related parity identities: this is cross-implementation evidence, not proof of arbitrary opaque-predicate generality.

Hikari's IR contains injected constant `icmp eq 1,1` predicates. Backend lowering removes the injected Jccs, even at O0, while dead clone bytes remain. Therefore its proof rate is N/A, not 0%, and it supplies four useful genuine negative controls rather than positive detections.

## 8. Tigress: generic versus initialized state

Generic execution stops at the first symbolic indexed array read on paths entering the low-byte arm. Other inputs bypass that arm and reach the later pointer comparison. Its two independent symbolic globals allow SAT/SAT. The result is **STATE INITIALIZATION LIMITATION**, not solver failure; no Tigress array constants were initially supplied.

Preferred assisted method **A** succeeded. `initialize.py` emulates retained `main` machine bytes until entry to the target: 763 trace entries at O0 and 219 at O2. Only `malloc` is summarized as successful fresh aligned allocation (three allocations). Array contents, entropy and pointer relations all come from executing the initializer bytes, not branch-specific assignments. The writable image/heap snapshot is retained, then x/y are re-symbolized at function entry.

The initialized O0 array JNEs at `0x1400011ED` and `0x140001266` are always not taken; the pointer JE at `0x14000128C` is always taken. The pointer gate changes from SAT/SAT to one-sided; the two array gates change from unreached to provable. All genuine branches remain two-sided. These are proofs for the captured initialized state and arbitrary uint32 x/y, **not universal proofs over arbitrary initialization, entropy, heap layouts or later global mutations**.

All seven initialized predicates are extracted, but only four contain symbolic variables after constant folding. The three known-state gates are concrete AST proofs. This is not failed symbolization and should not be confused with general symbolic array reasoning.

## 9. Bounded O2 comparison

| Case | Extant Jccs | Result |
|---|---:|---|
| OLLVM BCF O2 | 2 | One opaque gate proved; first short-circuit global comparison is two-sided |
| Hikari BCF O2 control | 0 | Target bytes identical to matching clean O2; no discovery claimed |
| Polaris BCF O2 control | 0 | Target bytes identical to matching clean O2; no discovery claimed |
| Tigress AddOpaque O2 generic | 6 | Four reached/two-sided, two array gates unreached |
| Tigress AddOpaque O2 initialized | 6 | Three injected gates proved; three remaining genuine Jccs two-sided |

The OLLVM first `jl` is compiler lowering of one component of an injected OR, not itself an invariant. Counting it as a missed opaque branch would be wrong. Optimized source decisions often become CMOVs instead of Jccs; the absence of a Jcc is not a detector failure. Hikari/Polaris exact target-byte comparisons are recorded in [O2 controls](../results/deobfuscation/opaque_triton/summaries/o2_negative_controls.json).

## 10. BinProtect static-only stress case

**STATIC ONLY / SEMANTICALLY INVALID PROTECTED PE / DO NOT EXECUTE.** No protected executable was launched or loaded for native invocation.

Eleven pass-introduced regions were isolated from the original bytes, including power products, flag saves, explicit saved-ZF modification and restoration. Triton executed those bytes with unconstrained entry GPRs/flags except concrete original RIP and synthetic RSP=`0x6FFFFFF8`. Stack accesses therefore remain concrete and faithfully modeled. No Fermat equation was manually implemented.

| Local result | Count | Interpretation |
|---|---:|---|
| One-sided | 4 | UNSAT for one edge under this fixed stack/image layout only |
| Both sides SAT | 4 | Concrete register witnesses replayed through the exact region in Triton |
| UNKNOWN due to TIMEOUT | 3 | One query exceeded the 2,000 ms solver budget |
| Other conditional branches not analyzed | 7 | Four original-source branches and three bogus-copy internal branches |

Machine multiplication wraps modulo 2^64. A Fermat-style argument over unbounded positive integers does not establish the corresponding machine predicate. The SAT/SAT models refute universal one-sidedness in these isolated machine-state models; they do not show those states are reachable in the invalid whole PE. Likewise local UNSAT does not establish correctness of the protected program. These results are excluded from runnable-family precision/recall.

## 11. Soundness and evidence audit

Each predicate directory retains the condition AST, complete relevant prefix, both typed SMT-LIB queries, explicit statuses/timings, SAT model, input seed and contributing expression comments. `run_*.json` retains full actual-byte instruction traces. No timeout, missing model or unseen path is called UNSAT. An empty SAT model is valid for a constant satisfiable query.

The final [SMT serialization audit](../results/deobfuscation/opaque_triton/summaries/smt_serialization_audit.json) replays 660 queries through bundled Z3's public C API: **446 SAT and 211 UNSAT results reproduced**. Of three original TIMEOUTs, two replayed UNKNOWN and one replayed SAT under the SMT-LIB front-end. Original TIMEOUT classifications are preserved. This checks serialization and witnesses, not an independently implemented solver or proof certificate.

The [proof freeze](../results/deobfuscation/opaque_triton/summaries/proof_freeze.json) hashes proof evidence and aggregate classifications before graph projection. [Preservation audit](../results/deobfuscation/opaque_triton/summaries/preservation_audit.json) checks 34 prior source/environment-marker/summary files, all 17 inventoried PEs, and the frozen provenance evidence. Installation and all new outputs are confined to this study's environment/results/scripts/docs.

Integration fixes are documented in [harness development notes](../results/deobfuscation/opaque_triton/environment/harness_development_notes.md), including callback lifetime, Windows TEB state, and differences between current documentation and the installed wheel. These were not attributed to obfuscator failures.

## 12. Accuracy and coverage

Detailed [accuracy](../results/deobfuscation/opaque_triton/summaries/accuracy_metrics.csv), [predicate](../results/deobfuscation/opaque_triton/summaries/predicate_results.csv), [family](../results/deobfuscation/opaque_triton/summaries/family_results.csv) and [solver](../results/deobfuscation/opaque_triton/summaries/solver_metrics.csv) tables have JSON counterparts.

| O0 evaluation policy | TP | FN | FP | TN | UNKNOWN | UNREACHED | Precision | Decidable analyzed recall | FPR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| All generic entry state | 38 | 1 | 0 | 16 | 0 | 2 | 100% | 97.44% | 0% |
| Substitute initialized Tigress lane | 41 | 0 | 0 | 16 | 0 | 0 | 100% | 100% | 0% |

The generic-state FN is the analyzed Tigress pointer gate, whose runtime invariant was absent from the model. The two unvisited array gates are **not counted as negatives**. Generic proof yield over all 41 known gates is 38/41 = 92.68%; initialized-state yield is 41/41. Generic branch coverage is 55/57; initialized coverage is 57/57. Every reached predicate is extracted. Symbolic-variable-containing conditions are 55/55 generic and 54/57 initialized; the remaining three initialized conditions are concrete. These small, selected, related programs do not establish population-level accuracy.

## 13. Complexity and solver timing

Metrics describe optimized Triton condition DAGs with SSA references preserved, **not textual expansion size**. Depth records a reference-traversal lower bound when sharing is present; contributing expression IDs/comments plus full traces support inspection. Constant folding strongly shrinks known-state Tigress gates.

| Lane | Condition DAG nodes, min/median/max | Median query wall time | Maximum wall time |
|---|---|---:|---:|
| OLLVM O0 | 25 / 46 / 46 | 15.75 ms | 20.99 ms |
| Hikari O0, genuine only | 25 / 25 / 37 | 17.27 ms | 20.68 ms |
| Polaris O0 | 15 / 46 / 46 | 17.68 ms | 22.77 ms |
| Tigress O0 generic, reached subset | 15 / 19 / 25 | 16.62 ms | 17.43 ms |
| Tigress O0 initialized | 5 / 7 / 25 | 15.63 ms | 16.93 ms |
| BinProtect local, STATIC ONLY / SEMANTICALLY INVALID / DO NOT EXECUTE | 87 / 93 / 97 | 482.03 ms | 2,275.16 ms |

Triton's median solver-reported times are approximately 5–7 ms for runnable lanes and 468.5 ms for the BinProtect stress lane; wall timing also includes translation/interface overhead. A 2,000 ms solver timeout is not a strict whole-call wall-clock cap. Nonlinear bit-vector difficulty is not predicted by node count alone.

## 14. Read-only CFG projection

[DOT/SVG graphs](../results/deobfuscation/opaque_triton/cfg_projection/) were created after proof freezing. Only proven-impossible edges are removed; UNKNOWNs are untouched. Unreachable nodes are omitted from the after view. No instruction deletion, block merging, binary patching or runnable deobfuscation is claimed.

| Case | Before reachable blocks/edges | After reachable blocks/edges | Clean blocks/edges |
|---|---:|---:|---:|
| OLLVM O0 | 70 / 95 | 37 / 40 | 11 / 14 |
| Polaris O0 | 54 / 73 | 30 / 33 | 11 / 14 |
| Tigress O0, initialized state only | 16 / 22 | 15 / 18 | 11 / 14 |

The substantial remaining blocks and instructions include predicate computations and jump stubs. Removing impossible edges is not the same as restoring the clean binary. Calls are represented by intraprocedural fall-through edges in these graphs.

## 15. Four course examples

Each [course evidence chain](../results/deobfuscation/opaque_triton/summaries/course_examples.json) links independent provenance → actual machine trace → AST/SMT → both solver results → classification → graph consequence.

1. **OLLVM, `0x140001667`:** two symbolic global reads, actual arithmetic/flags and a JNE. Taken SAT / fall-through UNSAT; remove only the fall-through graph edge. No parity recognizer is present in the analyzer.
2. **Polaris, `0x140001257`:** the same workflow proves a differently emitted gate using separate site globals. Compare its instruction ordering and AST with OLLVM while acknowledging their related arithmetic identity.
3. **Tigress, `0x14000128C`:** unconstrained pointer globals give SAT/SAT; actual-main initialization establishes their relation, yielding taken SAT / fall-through UNSAT. This illustrates state-model sufficiency, not a stronger solver.
4. **Clean low-byte source condition:** one prefix forces the condition, but other reachable x values admit both outcomes. Keep both graph edges. This is the strongest teaching example against deleting legitimate path-correlated branches.

BinProtect's modular-arithmetic counterexample is a useful optional fifth static-only exercise, not a runnable lab specimen.

## 16. Limitations and interpretation

- Proof scope is bounded function exploration within the recorded ABI/memory model, not unrestricted whole-program correctness.
- The generic loader does not implement symbolic pointer/array address reasoning, asynchronous mutation, arbitrary imports, exception dispatch or a complete Windows process.
- Tigress assistance represents one actual initializer path with a successful-allocation summary. It does not prove all runtime states or allocation failures.
- OLLVM and Polaris provide two implementations of related arithmetic, not an unrelated challenge distribution. Hikari contributes no surviving positive gates.
- BinProtect local fixed-stack proofs do not quantify all stack addresses or establish surrounding reachability; bogus-copy corruption is left untouched.
- AST simplifications and solver versions affect expression sizes, timings and timeout reproducibility. UNKNOWN remains a first-class result.
- SMT replay checks the retained queries using the same Z3 build, not an independent solver or certified UNSAT proof checker.

## 17. Reproduction and next phase

Using the dedicated environment from the workspace root:

```powershell
& .venvs\triton_dba\Scripts\python.exe -B scripts\deobfuscation\opaque_triton\run_study.py
& .venvs\triton_dba\Scripts\python.exe -B scripts\deobfuscation\opaque_triton\summarize.py
& .venvs\triton_dba\Scripts\python.exe -B scripts\deobfuscation\opaque_triton\project_cfg.py
& .venvs\triton_dba\Scripts\python.exe -B scripts\deobfuscation\opaque_triton\course_examples.py
```

`run_study.py` logs exact subprocess commands and enforces the clean gate before treatment claims. It never rebuilds the corpus and never invokes BinProtect natively. `setup_environment.py`, `inventory.py` and `ground_truth.py` document initial setup/provenance; the frozen ground truth should not be regenerated merely to match a later analysis result.

Recommended next phase: **a narrowly scoped proof-driven binary-rewriting pilot for OLLVM O0 and Polaris O0**, with an explicit review of proof assumptions, disposable output copies, PE/unwind-aware edits and differential native testing over the retained solver inputs. This has direct supporting proofs and a clear success criterion. Keep initialized-state Tigress and invalid BinProtect outside the first rewrite pilot. Mergen/x64-to-LLVM lifting is a separate, larger experiment and is not needed to validate these already-proved edge removals.

This study stops here. No rewrite or Mergen phase has begun.
