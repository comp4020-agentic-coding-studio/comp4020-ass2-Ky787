# Mergen: bounded native x64 → LLVM evaluation

Date: 2026-09-18. Workspace: `E:\Workspace\seeing_through_obfuscation`.

## Outcome

Mergen builds, passes its pinned upstream gate, and contributes a useful but distinctly non-universal methodology. All 17 selected functions produced verifier-valid IR; all four retained stages per function compiled and linked (68 modules). Thirteen cases have a tested runnable reconstruction. OLLVM SUB is a **semantic failure despite valid, smaller, recompilable IR**. Both OLLVM BCF cases remain **LIFTED IR ONLY / SEMANTIC EXECUTION NOT ESTABLISHED**. BinProtect is **STATIC ONLY / SEMANTICALLY INVALID PROTECTED PE / DO NOT EXECUTE AS THE PROTECTED PROGRAM**, with no execution of its PE or lift.

The strongest composition result is prior OLLVM unflattening followed by lifting: the original lift retains its state dispatcher, whereas the pre-unflattened lift has clean-control complexity and passes runtime tests. Polaris MBA lifts without expression explosion and executes correctly, but ordinary LLVM optimization does not eliminate most of its MBA identities. The strongest limitation is the confirmed OLLVM SUB mislift, not a timeout.

Evidence: [case summaries](../results/deobfuscation/mergen/summaries/cases.json), [case CSV](../results/deobfuscation/mergen/summaries/cases.csv), [IR metrics](../results/deobfuscation/mergen/summaries/ir_metrics.json), [IR CSV](../results/deobfuscation/mergen/summaries/ir_metrics.csv), and [course-facing comparisons](../results/deobfuscation/mergen/course_examples/README.md). These are separate evidence from all previous studies.

## 1. Tested identity and unchanged inputs

The existing checkout is `third_party/deobfuscators/Mergen`, branch `main`, commit **71fc60766d3d74bd38693c1503087a074aa70a66**. The upstream `origin/HEAD` query returned the same commit. No update, checkout replacement, source patch, or per-obfuscator signature was made. Local commit title: “Loop generalization, BSR/BSF intrinsics, and stack alloca split (#207)”, dated 2026-05-08, author naci, committer GitHub. Full metadata and the actual remote query are in `environment/git_identity` and `environment/git_upstream_head`. The local `LICENSE` contains GNU GPL version 3. The inspected README, BUILDING, ARCHITECTURE, LLVM_API_NOTES, SCOPE and AGENTS files are hashed in `environment/local_dependency_audit.json`. [Pinned upstream source](https://github.com/NaC-L/Mergen/tree/71fc60766d3d74bd38693c1503087a074aa70a66).

The `linux-pe` gitlink and its actual clean checkout are `58249d9aea44c4f52eb1c4350d936545217ee5e3`. Separately, the project's build fetches linux-pe `be6d1f6`, magic_enum `a413fcc` and its Corrosion fork `8b991b7`; these are not confused with the repository gitlink. Initial and final tracked source status are clean. Generated build directories remain ignored by upstream.

The final preservation audit checked 713 pre-existing Mergen files, all 4 frozen source files, 7,045 prior evidence files, and every selected input function's PE hash: **zero changes**. The exact paths, SHA-256s, target VAs/RVAs, unwind ranges and target-byte hashes are retained in [input_inventory.json](../results/deobfuscation/mergen/summaries/input_inventory.json). Shared PEs appear more than once when different functions are selected. No previous output PE, frozen source, Hikari/OLLVM/Polaris toolchain, course design, or prior results were changed.

## 2. Build environment and provisioning

The tested checkout's current Windows scripts and strict CI pin were followed. The primary backend is **iced**, not the optional Zydis lane. Official prebuilt LLVM development files were sufficient; LLVM was not built from source. Consequently its official distribution contains multiple targets; the user-requested X86-only preference applied to a hypothetical source build, which was unnecessary.

| Component | Exact version / location |
|---|---|
| LLVM development package and execution tools | 18.1.8, `E:\Workspace\seeing_through_obfuscation\toolchains\llvm18` |
| LLVM_DIR | `E:\Workspace\seeing_through_obfuscation\toolchains\llvm18\lib\cmake\llvm` |
| clang, clang-cl, opt, llc, llvm-as, llvm-dis, lli | 18.1.8, each under `toolchains\llvm18\bin\*.exe` |
| Mergen C/C++ compiler | clang-cl 21.1.8, `E:\Workspace\seeing_through_obfuscation\toolchains\clang21.1.8\bin\clang-cl.exe` |
| Existing developer environment | `E:\Visual Studio\Common7\Tools\VsDevCmd.bat -arch=amd64 -host_arch=amd64`, Community 2026 |
| MSVC tools / linker | 14.51.36231, compiler 19.51.36248; `E:\Visual Studio\VC\Tools\MSVC\14.51.36231\bin\Hostx64\x64\link.exe` |
| Windows SDK | 10.0.26100.0 |
| CMake | 4.3.1-msvc1, `E:\Visual Studio\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe` |
| Ninja | 1.13.2, `E:\Visual Studio\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe` |
| Rust | rustc 1.98.1 (`48a229cea`, 2026-09-01), stable-x86_64-pc-windows-msvc |
| Cargo | 1.98.1 (`797e8a9bc`, 2026-08-05) |
| Rust homes | `toolchains\rust\rustup` and `toolchains\rust\cargo`; proxy executables in `toolchains\rust\cargo\bin` |
| NASM | 3.01, `toolchains\nasm\nasm-3.01\nasm.exe` |
| Python | Existing read-only `.venvs\triton_dba\Scripts\python.exe`, 3.11.4, always `-B`; no new packages |
| LibXml2 | Existing read-only Anaconda 2.13.9, `C:\Users\royga\anaconda3\Library` |

Exact version output and tool hashes are in `environment/llvm18.json`, `environment/clang21.json`, and per-tool logs. Rust was provisioned with official rustup, minimal profile and `--no-modify-path`, into project-local homes. clang-cl 21 was extracted from its official installer without running the installer. Existing VS LLVM 22 was neither removed nor overwritten. [Official LLVM 18 release](https://github.com/llvm/llvm-project/releases/tag/llvmorg-18.1.8), [LLVM 21.1.8 release](https://github.com/llvm/llvm-project/releases/tag/llvmorg-21.1.8), [Rust installer](https://rust-lang.org/tools/install/), [NASM release](https://www.nasm.us/pub/nasm/releasebuilds/3.01/win64/).

LLVM 18 archive: `clang+llvm-18.1.8-x86_64-pc-windows-msvc.tar.xz`, 981,666,720 bytes, SHA-256 `22C5907DB053026CC2A8FF96D21C0F642A90D24D66C23C6D28EE7B1D572B82E8`. clang21 archive SHA-256: `7A5386C26497DB1691F320121E5B113364DD0274B98E55F15F4DBC00C0450113` (checked against the release digest). Dependency receipts remain under `environment/downloads`.

Two packaging/environment resolutions are disclosed, not represented as an untouched installation: the LLVM archive's `LLVMExports.cmake` hard-coded a VS2019 DIA library path; **only that path** was changed to `E:/Visual Studio/DIA SDK/lib/amd64/diaguids.lib`. Original, diff and both hashes are retained. Its LibXml2 dependency was resolved using the existing Anaconda package via CMAKE_PREFIX_PATH, without modifying Anaconda. Neither change touches Mergen source. Cargo's initial TLS failure was resolved with one approved dependency fetch into project Cargo home; subsequent builds were offline. Git used command-local OpenSSL and safe.directory settings, not global configuration changes. Git's Unix `link.exe` was kept behind the MSVC linker. Failed configure/build/provision attempts were retained, not silently removed.

### Commands and primary executable

Working directory: `E:\Workspace\seeing_through_obfuscation\third_party\deobfuscators\Mergen`.

```bat
cmd.exe /d /c E:\Workspace\seeing_through_obfuscation\third_party\deobfuscators\Mergen\scripts\dev\configure_iced.cmd
cmd.exe /d /c E:\Workspace\seeing_through_obfuscation\third_party\deobfuscators\Mergen\scripts\dev\build_iced.cmd
E:\Workspace\seeing_through_obfuscation\.venvs\triton_dba\Scripts\python.exe -B test.py quick
```

The scripts use Ninja, Release, the configured clang-cl, LLVM_DIR and the default Rust iced backend. `CI=1` suppresses automatic cmkr regeneration; generated CMakeLists was not edited. `MERGEN_BUILD_JOBS=8`. The checkout's supported scripts hard-code `build_iced`, so build output is a separate ignored directory within the checkout, not a hand-invented alternate layout. Exact child commands and process-local environment are retained in `environment/configure_iced_04`, `environment/build_iced_05`, and `environment/build_environment.json`.

Primary lifter:

`E:\Workspace\seeing_through_obfuscation\third_party\deobfuscators\Mergen\build_iced\lifter.exe`

Size: 15,241,216 bytes. SHA-256: **2F0764141DD52C6DB4928F3941158A184C526A190389AB4346DFD4BE1FA3132C**. Compiler SHA-256: `812F6A0E80A5541108C0F4AE31121BCD5B692707041AC83A86E595F4729F5C8A`. Configure/build wall times were approximately 8.17/15.66 seconds after dependencies were available. These are not total provisioning times.

## 3. Upstream gate: failures retained, not waived

The first diagnostic build used existing VS clang-cl 22.1.3. It built, but `test.py quick` failed 15 IR-pattern expectations in `jumptable_basic`, `jumptable_dense`, and `calc_jumptable_large`. No corpus claims were made from that lane. Its complete build was moved recoverably to `build_iced_clang22_diagnostic`; its logs and all 500 emitted modules are retained in `sanity/clang22`.

A fresh build with **the tested revision's CI-pinned clang-cl 21.1.8** passed the unmodified quick gate, exit 0, 93.067 seconds:

- 250 native sample lifts, 250 raw/internal pairs.
- All baseline patterns passed; 42 tracked golden files matched, 458 untracked files skipped by upstream policy.
- 246/246 semantic sample suites, **2,350 input vectors**.
- 228 instruction microtests passed. An additional explicit `python -B test.py micro --check-flags` also exited 0; its logs are `environment/upstream_strict_flags`. This is verification of the same upstream suite, not a corpus substitute.
- Independent LLVM 18 verification passed on all 500 primary modules and all 500 retained diagnostic modules.

Important scope: upstream `check_semantic.py` removes certain fixed-address stores/calls before its JIT check. Passing that gate is not proof that every unmodified emitted module can execute. Our corpus harness **does not remove those operations**. Also, baseline IR shape and the manifest's finite semantic vectors are not a universal correctness proof; the OLLVM SUB failure below passes through this baseline gap. No separate commercial-packer or virtualization experiment was run.

## 4. CLI, lifted ABI and optimization attribution

CLI: `lifter.exe <PE> <preferred-image VA>`. The address is a **VA**, not an RVA. Each lift runs in its own case's `lift/` directory, preserving `output_no_opts.ll`, `output.ll`, `output_diagnostics.json`, exact argv, cwd, stdout, stderr, exit status and wall time. The bounded timeout is 180 seconds; no case reached it.

The help exposes `-h/--help`, `-d/--enable-debug`, `--outline <addresses>` and `--`. `--concretize-unsafe-reads` is recognized but explicitly unimplemented; it was not used. No corpus-specific switches were added. The format is x64 PE, with function-level integer and supported SIMD instruction semantics. This is not source ABI recovery, a complete PE-to-source compiler, or a universal floating-point/AVX/self-modifying-code lifter. Current pinned SCOPE and loop-generalization source are more recent than older broad statements that loops are unsupported. Residual outlined calls and complicated memory/control flow remain important limits.

All selected functions expose 34 arguments and return i64:

```llvm
define i64 @main(i64 %RAX, i64 %RCX, i64 %RDX, i64 %RBX,
  i64 %RSP, i64 %RBP, i64 %RSI, i64 %RDI,
  i64 %R8, i64 %R9, i64 %R10, i64 %R11,
  i64 %R12, i64 %R13, i64 %R14, i64 %R15,
  ptr %EIP, ptr %memory, i128 %XMM0, ... , i128 %XMM15)
```

Some definitions add `noundef`. The wrapper parses and checks the actual ordered argument list rather than assuming the normal C source signature. RCX/ECX and RDX/EDX represent x/y; low 32 bits of returned RAX represent uint32_t return. EIP is a pointer-valued initial machine address, internally cast to integer. RSP is modeled from **0x14FEA0**, even though an RSP argument is exposed. Pseudo-stack reservation is clamped to 0x1000–0x100000. Raw accesses commonly use `getelementptr i8, ptr %memory, i64 <machine address>`. PE-backed reads can be concretized; other accesses can remain symbolic. Later promotion may produce allocas or **absolute inttoptr addresses**, which are not safely backed merely by passing an arbitrary memory buffer. Initial flags are fixed by the lifter; arbitrary caller flag-state reconstruction is not claimed.

Control flow appears as branches, selects, phis, switches, and generalized loops. A native loop may also be unrolled by lifting. Calls use Mergen's strict ABI/clobber contract, not arbitrary transparent calls back into the original PE. Known .pdata functions are auto-outlined. An unresolved outlined call is not an invitation to execute a synthetic C signature at its original VA.

Four stages are retained, using just one external optimization level:

| Stage | Artifact | Meaning |
|---|---|---|
| R | `lift/output_no_opts.ll` | Raw **emitted** IR; already includes symbolic folding and path decisions made while lifting |
| R2 | `raw_O2.ll` | R plus plain LLVM 18 `opt -S -O2` |
| M | `lift/output.ll` | Mergen's internal custom + LLVM pipeline |
| M2 | `internal_O2.ll` | M plus the same plain LLVM 18 `opt -S -O2` |

Internally Mergen iterates O1 plus `GEPLoadPass → ReplaceTruncWithLoadPass → PromotePseudoStackPass → PromotePseudoMemory` to an instruction-count fixpoint, then O2 and post-passes including scratch-store stripping, select-chain/switch normalization, dead-argument elimination and naming. Therefore R→M is **not ordinary LLVM alone**. R→R2 is the directly measured ordinary-optimizer comparison. R is not an instruction-faithful, no-simplification baseline.

For each actual module, exact commands use absolute paths:

```text
toolchains\llvm18\bin\opt.exe -passes=verify -disable-output <module.ll>
toolchains\llvm18\bin\opt.exe -S -O2 <raw-or-internal.ll> -o <separate-output.ll>
toolchains\llvm18\bin\llc.exe -O=0 -filetype=obj -mtriple=x86_64-pc-windows-msvc <wrapped.ll> -o <lift.obj>
<MSVC link.exe> /nologo /dll /noentry /machine:x64 /export:mergen_probe /out:<lift.dll> <lift.obj>
```

`llc -O=0` avoids intentionally adding a new IR optimization experiment at compilation. Each DLL is disassembled with LLVM 18 objdump, alongside a disassembly of the unchanged native target. A DLL's ability to link is recorded separately from safe executability.

## 5. Runtime validation, not just attractive IR

The generated wrapper appends `mergen_probe(i32 x, i32 y, ptr backing)` and calls the **unchanged** emitted `@main`. No arithmetic, branch, load, store or outlined call is rewritten. RCX/RDX receive zero-extended input, EIP the verified target VA, RSP the documented constant, other GPRs and XMMs zero. Return is truncated to uint32_t. Every wrapped module was independently verified; the retained wrapper is checked to contain the original module unchanged.

The ordinary backing buffer is 0x300000 bytes, covering the fixed pseudo-stack. It alternates 0xCD/0x5A initialization every 64 calls. Execution is refused for unbounded memory offsets, absolute pointers or external calls unless the specific data-only contract is separately backed. These tests cover the selected initialized machine state and source-visible return, **not every incoming register, flag, memory state, or volatile stack side effect**.

The native clean and input exports are called in isolated Python workers using `LoadLibraryExW(..., DONT_RESOLVE_DLL_REFERENCES)` and their actual export RVAs. Entry bytes are checked against the PE. No original PE entrypoint is called by this harness. The selected targets do not require DLL initialization; their actual native results, retained per vector, agree with the oracle in all 16 runnable-input cases. BinProtect is excluded by explicit guards before any loader call.

Frozen-source oracles implement uint32_t wraparound. Each one-input function gets 22 edges + 4,096 seeded random values = **4,118** tests. Each two-input function gets the 22×22 edge cross product + 4,096 random pairs = **4,580** tests. Inputs include both sides of the BCF thresholds and 32-bit wrap/sign boundaries. RNG seed is `0x4d455247454e`. Source hashes and every input/return are retained; no full corpus rebuild was needed.

Tigress's M/M2 retain `store i32 1` to **0x140099D3C**, a writable non-executable `.data` location. A supplementary worker reserves a fresh **data-only, PAGE_READWRITE** 64-KiB region at 0x140090000, populates intersecting original PE data, and backs that exact store. It executes the already-compiled, unchanged lifts and checks the store becomes 1 on every test. It never maps executable original code. The initial conservative exclusion and an audit attempt that stopped before execution are retained. R/R2 are still not executed: their separate memory-base-plus-image-offset contract was not expanded into a general address-space emulator.

There were 51 executed stage/case pairs, 218,334 lifted-function input evaluations: 47 passing stage pairs and four failing OLLVM SUB stage pairs. This is **tested equivalence, not an all-input formal proof**.

## 6. Results

`instructions/blocks` counts refer only to lifted `@main`, excluding wrapper/declarations. Native column is direct-edge reachable instruction count from the retained target extent; full linear extent counts and block counts are also in CSV/JSON. Native and LLVM instruction counts are different representations, not interchangeable units. One LLVM vector instruction may represent several scalar operations. All rows have lifter exit 0, valid IR at all stages, and all stages compiled/linked.

| Case | Native instructions | R | R2 | M | M2 | Runtime / interpretation |
|---|---:|---:|---:|---:|---:|---|
| Clean OLLVM SUB | 115 | 734/1 | 35/1 | 34/1 | 9/1 | All stages pass |
| Clean OLLVM BCF | 39 | 437/40 | 42/12 | 29/12 | 29/12 | All stages pass |
| Clean OLLVM FLA | 68 | 613/43 | 63/13 | 51/13 | 51/13 | All stages pass |
| Clean Polaris SUB | 115 | 734/1 | 35/1 | 34/1 | 9/1 | All stages pass |
| Clean Polaris BCF | 39 | 437/40 | 42/12 | 29/12 | 29/12 | All stages pass |
| Clean Tigress SUB | 249 | 746/5 | 39/1 | 34/1 | 9/1 | R2/M/M2 pass; R conservatively not executed |
| Clean complex_mixed | 22 | 123/1 | 24/1 | 10/1 | 10/1 | All stages pass |
| OLLVM SUB O0 | 311 | 1998/1 | 67/1 | 45/1 | 45/1 | **All stages fail: 3917/4118 mismatches** |
| Polaris MBA O0 | 678 | 6689/1 | 386/1 | 375/1 | 359/1 | All stages pass; substantial MBA remains |
| Tigress EncodeArithmetic O0 | 426 | 1591/5 | 104/1 | 80/1 | 80/1 | M/M2 pass with exact data backing; partial simplification |
| OLLVM BCF original | 460 | 1728/180 | 243/32 | 87/16 | 87/16 | IR-only; unresolved call/memory contract |
| OLLVM BCF Triton-rewritten | 385 | 1728/180 | 243/32 | 87/16 | 87/16 | Same limitation, no size benefit |
| Polaris BCF original | 286 | 1026/159 | 82/24 | 29/12 | 29/12 | R2/M/M2 pass; recovered decision logic |
| Polaris BCF Triton-rewritten | 250 | 1026/159 | 82/24 | 29/12 | 29/12 | R2/M/M2 pass; no incremental size benefit |
| OLLVM FLA original | 190 | 1121/125 | 92/22 | 61/22 | 61/22 | All stages pass; dispatcher survives |
| OLLVM FLA unflattened | 111 | 702/32 | 70/13 | 51/13 | 51/13 | All stages pass; dispatcher absent |
| BinProtect MBA O2 — STATIC ONLY, INVALID PROTECTED PE, DO NOT EXECUTE AS PROTECTED PROGRAM | 381 | 1700/1 | 101/1 | 83/1 | 74/1 | **No execution or semantic claim** |

Native bounds come from export entry plus PE RUNTIME_FUNCTION/chained ranges; BinProtect uses the already-frozen protected target VA 0x14000181F rather than guessing from a wrapper export. Linear decoding includes physically retained dead code/padding. For example, the FLA rewritten extent has 555 decoded instructions but 111 direct-edge reachable instructions. The direct CFG counter conservatively retains leader splits induced by dead branch targets (18 reachable blocks there versus 17 in the prior unflattener's own CFG); do not misinterpret this difference as a changed input. No indirect successors are guessed. The selected ordinary direct-flow counts agree with prior instruction totals.

### Clean controls

All three required controls and optional complex_mixed worked, with family-matched SUB/BCF controls retained. The clean SUB M output visibly contains eight adds of 0x01010101 multiples, eight XORs with 0x12345678, and net adds of **550 = 0x1337 − 0x1111**, then the XOR reduction. Extra O2 vectorizes this to nine counted instructions, not nine scalar source operations. The clean BCF conditions remain recognizable; some result arithmetic becomes constant selects. Clean FLA has its small source loop effectively unrolled/simplified. complex_mixed exposes the small add/xor/sub expression in ten IR instructions. Raw controls themselves expand substantially due to flags and pseudo-stack modeling.

### OLLVM SUB: wrong semantics already in raw emission

The original PE and clean control both match all 4,118 source tests. Every lifted stage mismatches the same 3,917 cases. At x=0, expected **0x08083808**, actual **0**. LLVM verifies these modules and can compile them; that does not validate their translation. The failure precedes the external O2 pipeline and Mergen's final internal optimizer, because R fails too. All 311 native instructions are reported supported; there is no diagnostic error or timeout.

A source-level explanation is visible without patching the tool: `lifter/semantics/OperandUtils.ipp:~173–193` folds `(~A & B) | (A & C)` to a scalar select when known-bits extrema are zero/all-ones. An unconstrained integer has those extrema too; that does **not** prove A is exclusively 0 or −1. For example A=1, B=0, C=2 gives bitwise result 0 but the proposed nonzero select yields 2. The emitted `%selectEZ...`/propagated selects are consistent with this unsound mask-to-condition fold. This is a strongly supported diagnosis, not a patched/fixed retest or a claim that no other defect exists. Retain OLLVM SUB as the negative lesson **valid IR ≠ correct lift**, never as successful arithmetic recovery.

### Polaris MBA: scalable representation, incomplete simplification

The exact primary-O0 PE is used, SHA-256 `48A7750AAAD7E6CC7E0F9638D9278CF7864882D4BA95D0C3222596BC6879AEF5`. Lift wall time was **0.04665 s**. R is 311,779 bytes / 6,689 instructions; plain O2 reduces it to 23,408 bytes / 386 instructions. M is 17,009 bytes / 375 instructions; M2 is 18,176 bytes / 359 instructions. Text byte size can rise while instruction count falls because vector/intrinsic syntax is longer.

All four stages match 4,118 tests. Flag-artifact name proxy drops from 3,300 to zero; M has no loads/stores or calls. M2's 13 calls are LLVM vector-reduction intrinsics, **not unresolved native calls**. Some ADD/XOR constants are recognizable, but hundreds of multiply/add/Boolean operations with coefficients remain (M: 372 arithmetic/Boolean instructions, versus clean M's small scalar expression). This is successful lifting and runnable partial simplification, not full MBA elimination.

The prior Miasm/msynth whole-function extraction stopped at its 20,000-AST-occurrence guard: 25,384 occurrences at VA 0x1400014A4, about 0.5334 s. That was an expression-size guard, not a measured timeout. Mergen handles this function better **at obtaining a compact, executable whole-function representation**. This is not a controlled speed benchmark or evidence that its residual MBA is simpler than every local synthesis result.

### Tigress EncodeArithmetic

R→R2: 1,591→104 instructions, five blocks→one. M/M2: 80 instructions, one block, one retained global store. Arithmetic/Boolean counts fall from 801 raw to 76 M and 54 M2 (vectorization affects counting). ADD/XOR/SUB semantics are partly recognizable but shifts, masks and encoded arithmetic remain. M and M2 each match 4,118 tests with the original fixed data-store semantics preserved and checked. This is a runnable reconstruction and partial simplification, not complete arithmetic normalization. R/R2 remain unexecuted rather than having their global memory accesses stripped.

### BCF before/after Triton, and the residual-arithmetic question

The input files are exactly the prior original and frozen proof-rewritten PEs. No further patches were made. Raw/internal block and instruction counts are identical between each family pair. Internal outputs are **equal modulo SSA names**, not byte-identical files; that comparison is retained in `summaries/controlled_comparisons.json`. Single-run times are essentially similar: OLLVM 0.03174 vs 0.03105 s, Polaris 0.02634 vs 0.02663 s. These tiny timing differences are not evidence of a speed improvement.

Polaris reaches 29 instructions / 12 blocks, no memory accesses or calls, and passes 4,580 inputs per executed stage. It matches the clean control's complexity and source-visible decisions, but is not byte-identical to the clean lift: predicate direction, integer widths, block ordering and SSA names differ. OLLVM retains three `inttoptr` calls to **0x1400057E0**, followed by stack-address arithmetic derived from their results and absolute loads/stores. In native code these calls precede `sub rsp, rax` in a stack-probing/allocation sequence. Mergen reports them as unknown outlined calls. No guessed helper model or native call shim was substituted. All OLLVM BCF stages are recompilable, but none has established lifted runtime semantics.

**What removed the opaque-predicate machinery?** The rewritten PE still physically contains it, but PE-backed opaque globals are concrete in Mergen's setup. The x·(x−1) predicate computation has already constant-folded during lifting; it is not present as a symbolic multiplication in R. For the rewritten Polaris case, R's 33 multiplies and 33 remainders are the lifter's parity-flag computations (constant 72340172838076673 and modulus 511), not surviving opaque-predicate products. Plain O2 removes these and other dead machine-state calculations: arithmetic/Boolean count 234→5, total instructions 1026→82. M additionally removes pseudo-stack state, giving 29 instructions and three genuine `and` operations. The same happens from the original PE.

Thus ordinary LLVM **does remove residual lifted flag/predicate-related dead work**, and the final semantic representation lacks opaque arithmetic. But these specimens do **not** isolate “Triton was necessary, then LLVM DCE removed symbolic x·(x−1)”: the specific opaque products were folded before emission, and originals achieve the same result. Mergen's concrete-global specialization is narrower than Triton's earlier universal bit-vector proof. The report does not equate the two proof strengths.

### FLA: most useful positive composition

Both original and successful stock-unflattener output lift, compile and match 4,118 inputs at all four stages. Original M has 61 instructions / 22 blocks and still contains a dispatcher switch over obfuscated state constants, state phis, and a backedge. “Runnable” does not mean “unflattened.” Pre-unflattened M has **51 instructions / 13 blocks**, the same complexity as the clean control, with the artificial dispatcher absent and only source-semantic branching/switching retained. R falls from 1121/125 to 702/32; plain-O2 output from 92/22 to 70/13. Prior unflattening improves representation, not an otherwise-failing lift. Single-run lift wall times: 0.02286 vs 0.01861 s; no robust timing claim.

### BinProtect: static-only endpoint

**STATIC ONLY / SEMANTICALLY INVALID PROTECTED PE / DO NOT EXECUTE AS THE PROTECTED PROGRAM.** The existing MBA O2 target lifts in 0.02003 s. R→R2 is 1700→101 instructions; M→M2 is 83→74. M has no memory accesses. Many flag artifacts vanish and some XOR/ADD operations emerge, but residual shifted/masked encoded arithmetic remains. All stages verify and compile/link for static inspection. **Neither the protected PE nor any compiled lift was executed.** This is no rehabilitation of the broken PE, no semantic-recovery claim, and no new BinProtect repair experiment. Optional Linear was unnecessary and was not tested.

## 7. Metrics, reproducibility and limits

The 68-row IR table contains paths and SHA-256s, byte sizes, instruction/block counts, arithmetic/Boolean histograms, branches, loads/stores, calls, inttoptr occurrences, used machine arguments, verifier/compile/runtime outcomes and per-stage DLL hashes. Flag counts are syntactic name proxies, not complete semantic liveness proofs; genuine source comparisons may retain flag-derived names. Calls include LLVM intrinsics and must be read alongside IR. Native extent and direct-reachability counts are both retained rather than silently counting dead padded code as executed code.

The seed fixes test-vector generation only. There is no documented Mergen CLI seed used here. Upstream golden checking passed as stated; independent repeated-build or repeated-lift determinism was not measured for all 17 cases. Linked DLL timestamps and SSA naming/textual ModuleID differences should not be mistaken for semantic differences. Timing is one bounded process wall-clock measurement per lift; internal profiler fields overlap and are not summed as independent phases.

Remaining limits include sampled rather than universal return equivalence; concrete initial image/global state; partial instruction coverage; raw IR already containing Mergen-specific folds; unsafe external call contracts; a large exposed machine-register ABI; and possible silent semantic defects despite passing upstream tests. No complete standalone reconstructed PE or source-level calling convention is claimed. DLLs are test harness artifacts, not deployable replacements for original programs.

Classification is deliberately multidimensional: all cases have **IR SIMPLIFICATION** in the structural sense and **RECOMPILABLE LIFT**; only passing wrapped executions receive **RUNNABLE RECONSTRUCTION**. **SEMANTIC RECOVERY (tested, not proof)** is limited to clearly recognizable clean controls, Polaris BCF and the pre-unflattened FLA result. OLLVM SUB's size reduction is explicitly tagged **SEMANTIC FAILURE**, overriding any suggestion of useful recovery. BinProtect and OLLVM BCF do not receive runtime or recovery credit. No case here was a literal LIFT FAILURE; that does not make every case successful deobfuscation.

## 8. Answers and stopping decision

1. **Does lifting itself simplify?** Yes: propagation, concrete-memory reads, native move/stack elimination and path handling act before raw emission. But raw IR commonly expands because it also models flags.
2. **What does ordinary LLVM add?** Large R→R2 reductions in every case; e.g. Polaris MBA 6689→386. Custom Mergen memory promotion accounts for further changes and must not be credited to plain O2 alone.
3. **Which families work best here?** Polaris BCF reaches clean-like decision logic. Arithmetic is mixed: runnable but residual MBA, plus one silent semantic failure. Original FLA remains flattened until composed with the existing unflattener.
4. **Polaris versus Miasm extraction?** Mergen obtains and validates the whole-function representation where the earlier extractor hit its size guard; no claim of complete MBA recovery.
5. **Does Triton rewriting help Mergen BCF?** No material incremental IR-size improvement in these two pairs; both final pairs are equivalent modulo SSA naming, with OLLVM still unsafe to execute.
6. **Does unflattening help FLA?** Yes: cleaner dispatcher-free representation and clean-control complexity, with tests passing before and after.
7. **Can lifts be recompiled?** Yes, all 68 retained stage modules.
8. **Can compiled lifts run correctly?** Thirteen cases have passing reconstruction tests; OLLVM SUB fails, OLLVM BCF lacks a safe contract, BinProtect is not executed.

Include Mergen as a **bounded methodology/composition topic**, not as a universal deobfuscator or trusted semantic oracle. Four best comparisons are the OLLVM SUB negative correctness example, Polaris MBA partial success, Polaris BCF with a no-incremental-benefit rewrite control, and OLLVM FLA before/after unflattening. The strongest positive composition is FLA; the strongest correctness warning is SUB.

**This phase is complete. There is enough distinct evidence to stop research experiments and assemble the course.** No new experiment, universal rewriter, obfuscator matrix, virtualization study, course redesign or course assembly has been started automatically.
