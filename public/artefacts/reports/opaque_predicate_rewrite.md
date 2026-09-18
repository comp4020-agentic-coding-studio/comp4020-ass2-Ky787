# Proof-driven opaque-branch rewriting pilot

Completed 2026-09-18. **Both pilots passed:** OLLVM-16 BCF O0: 22/22 eligible gates patched; Polaris BCF O0: 16/16. Both rewritten Windows x64 PEs produce the exact canonical output and exit 0. Across 9,189 differential input triples (27,567 native function calls), clean, original, rewritten, and the source oracle agree with zero mismatches.

This is a deliberately narrow, proof-backed in-place rewrite of `demo_bogus_control_flow`, not a general binary rewriter. Other functions in the same showcase executables are unchanged. Only Stage 1 modifies binary bytes; Stage 2 is a read-only reachable-CFG projection.

## 1. Scope, inputs, and preservation

Workspace: `E:\Workspace\seeing_through_obfuscation`.

The authority is the already frozen [Triton study](opaque_predicate_triton.md), under `results/deobfuscation/opaque_triton`. No solver was rerun, no proof was regenerated, and no compiler or toolchain was rebuilt. The existing `.venvs/triton_dba` environment was used with Python `-B`; Triton's library was used **only for static instruction decoding**, never `processing()`, symbolic execution, or solving. LLVM 22.1.3 `llvm-objdump` independently cross-checked instruction addresses and bytes.

The canonical `src/showcase.c` remains SHA-256 `39FEF0BB2A9742870F3D6F7CC864F7CFFA129136F6D2A59C4FB37F25906B99D2`. The final preservation check found **3,476 files unchanged**: the whole prior study, its scripts/report, the existing Triton environment, canonical source, and selected original/clean PE, PDB, map, IR, assembly, and metadata files. This inventory includes prior out-of-scope evidence only for read-only preservation hashing; those cases were not analyzed or executed.

Exact originals:

| Family | Original PE, relative to workspace | SHA-256 |
|---|---|---|
| OLLVM-16 | `results/showcase_matrix_v1/optimization_survival/ollvm16/bcf/O0/showcase.exe` | `3ED20E83BE53F28FAF64D1A1CFBC2FEB323B83EC35CCEE0FAF8D85AD7905285F` |
| Polaris | `results/showcase_matrix_v1/optimization_survival/polaris/bcf/O0/showcase.exe` | `859F3F4303CF59BB6437EEAC4DCC6894A9E4F6D47665C87B80C0F5A6634009F0` |

Matching clean PEs are in each family's `clean/O0/showcase.exe`. Their hashes are:

- OLLVM-16: `7FC180DAA49940E993245D7C131ABD19561E8181CBF6E40FFC1F080343E469E4`.
- Polaris: `4C75C71BD29C9B4403C50457AD859A4EEA010D7298ED7D5501AECC29ED14E202`.

Excluded throughout: Tigress, Hikari, BinProtect, O2, flattening, virtualization, Mergen, rebuilding the corpus, and course-design changes.

## 2. Proof-source audit and eligibility

The rewriter fails closed unless all checks pass:

1. Original and matching clean PE hashes match retained `inventory/cases.json`; the exported function and `RUNTIME_FUNCTION` boundaries match the retained target.
2. Every original instruction byte matches the frozen exact-byte inventory. Frozen IR, assembly, disassembly, ground-truth labels, family results, and per-context evidence match their retained freeze manifests.
3. The gate is independently labeled `OBFUSCATOR-INJECTED OPAQUE BRANCH`, rather than inferred to be injected from a solver result.
4. The retained exploration is complete, uses `GENERIC ENTRY-STATE RESULT`, and has no incomplete/failing retained runs.
5. **Every retained context** at that gate contains explicit SAT for the feasible direction and UNSAT for the impossible one. Each stored true/false SMT query is checked to assert the complete recorded prefix with the branch condition or its negation. The corresponding prefix/condition files are also checked and hash-verified.
6. As an additional conservative guard against path-relative rewrites, each context's frozen **unrestricted** queries must also report the same SAT/UNSAT directions. Nothing is newly solved.
7. The original Jcc, target, fallthrough, file offset, unwind range, and replacement are audited at the exact original bytes/address. Targets must be decoded instruction boundaries; no direct jump may enter a patch's interior.

Result: 22 OLLVM gates across 90 retained contexts, and 16 Polaris gates across 76 contexts. All are taken-SAT / fallthrough-UNSAT. Four genuine source branches in each family are explicitly excluded and verified byte-identical after patching. No UNKNOWN, TIMEOUT, absent-proof, initialized-only, or path-relative branch is accepted.

This audits the retained evidence and its declared execution model; it is not an independent theorem-prover verification of Triton/Z3. The original symbolic model's assumptions remain in force, including its memory, call, and single-threaded execution treatment.

Audit records: [OLLVM](../results/deobfuscation/opaque_rewrite/proof_audit/ollvm16.json), [Polaris](../results/deobfuscation/opaque_rewrite/proof_audit/polaris.json). Every gate carries VA/RVA, original opcode/bytes, both successors, directions, ground-truth provenance, full retained prefix, and per-context evidence paths/hashes.

## 3. Patching method and encoding safety

No relocation, new section, function replacement, predicate-arithmetic edit, or dead-block deletion was needed. Each approved original instruction-sized window is replaced as follows:

| Original form | Taken feasible | Fallthrough feasible |
|---|---|---|
| Short Jcc, `7x rel8` (2 bytes) | `EB rel8` (2 bytes), preserve target | Two `90` NOPs |
| Near Jcc, `0F 8x rel32` (6 bytes) | `E9 new_rel32 90` (5-byte JMP + 1-byte NOP) | Six `90` NOPs |

The new displacement is `target - (instruction_VA + new_JMP_length)`, **not** a blind copy of the Jcc displacement. A near Jcc at the maximum positive rel32 distance cannot necessarily become a five-byte near JMP: that extreme would overflow by one and is rejected. Short Jcc uses a same-size short JMP, never a five-byte overwrite. Prefixed Jcc, LOOP/JCXZ-family encodings, malformed instructions, overlapping sites, and prologue-overlapping patches are not supported by this pilot.

There were **292 successful encoding checks**, including all 16 short/near conditions, positive/negative displacement boundaries, NOP fallthrough cases, and expected rejection of overflow/unsupported encodings. Triton's decoder independently checked generated JMP destinations. These are encoder tests, not claims that all those forms were exercised in real rewritten PEs.

All **38 actual sites are six-byte near JNEs**, replaced with five-byte near JMPs plus one NOP. No site was unsupported or dropped. No failing subset was silently removed. Bytes outside the approved windows are exactly identical, and the full original and patched byte strings remain in the [patch manifest](../results/deobfuscation/opaque_rewrite/summaries/patches.json).

## 4. Outputs and execution order

OLLVM was patched, executed, differentially tested, and its actual-byte CFG validated **before** Polaris was patched. The Polaris command also requires a passing OLLVM validation artifact.

| Family | Disposable output | SHA-256 | File bytes, unchanged |
|---|---|---|---:|
| OLLVM-16 | [showcase_ollvm_bcf_deopaque.exe](../results/deobfuscation/opaque_rewrite/ollvm16_o0/showcase_ollvm_bcf_deopaque.exe) | `15BF8731CD94663F5E0691983F1616969E28675E89B8595371DDBCBA51EA906A` | 571,904 |
| Polaris | [showcase_polaris_bcf_deopaque.exe](../results/deobfuscation/opaque_rewrite/polaris_o0/showcase_polaris_bcf_deopaque.exe) | `6E5C2E7D5AB299766F5157B65E4202AEE5DA8BBEDF6A9AB6BF1BBD5F74E61A8A` | 557,056 |

Commands used, from the workspace (PowerShell):

```powershell
.\.venvs\triton_dba\Scripts\python.exe -B scripts\deobfuscation\opaque_rewrite\pilot.py audit
.\.venvs\triton_dba\Scripts\python.exe -B scripts\deobfuscation\opaque_rewrite\pilot.py ollvm16
.\.venvs\triton_dba\Scripts\python.exe -B scripts\deobfuscation\opaque_rewrite\pilot.py polaris
.\.venvs\triton_dba\Scripts\python.exe -B scripts\deobfuscation\opaque_rewrite\pilot.py finalize
.\.venvs\triton_dba\Scripts\python.exe -B scripts\deobfuscation\opaque_rewrite\verify.py
```

The audit and patch phases deliberately refuse to overwrite an existing initial audit or output PE. These commands document this completed run, not a suggestion to delete or overwrite its evidence. Exact native-worker, canonical execution, and disassembly commands/stdout/stderr/exit status are retained per family. Full rewritten PE disassembly is `exact_pe_disassembly_stdout.txt`; target-only independent listings are in `cfg_projection/<family>`.

## 5. Runtime and differential validation

All six canonical executions (clean, original, rewritten for both families) exited **0**, with empty stderr and exactly this stdout, allowing CRLF-to-LF normalization only:

```text
SUB      = 08080000
BCF      = 6665BBBC
FLA      = DBEFFCE7
CALLS    = 12345F05
DATA     = 57977293
COMBINED = EEBB6D71
SHOWCASE PASS
```

The isolated native driver loads one PE at a time with `LoadLibraryExW(..., DONT_RESOLVE_DLL_REFERENCES)`, resolves the exported `demo_bogus_control_flow`, checks its loaded bytes against the audited file, calls it with the native Windows x64 ABI, and unloads it before loading the next image. This avoids same-basename loader aliasing. The export is self-contained apart from internal code such as OLLVM's `__chkstk`; no imported-function/CRT initialization is required on its tested path. This is **not** a general method for running arbitrary EXE exports. Separately, normal process launches validate the actual complete executable.

The recorded loaded bases were ASLR-relocated, and the target's loaded bytes still exactly matched the audited function bytes. Neither the driver nor patcher writes target globals at runtime.

Test selection, per family:

- Reuse x/y values from frozen SAT models and retained exploration seeds. If a model omits x/y, that missing input is set to zero. Symbolic global models are **not** injected; native PE data initialization is retained. These are input reuses, not full symbolic-state replays.
- A 22 by 22 edge-value Cartesian grid (484 pairs), including zero, `0x37`, `0x1337`, neighbors, `0x1233FFFF`, `0x12340000`, `0x12340001`, `UINT32_MAX`, signed boundaries, `AAAAAAAA`, `55555555`, `A5A5A5A5`, `5A5A5A5A`, `DEADBEEF`, and `CAFEBABE`.
- 4,096 pairs from Python 3.11 `random.Random(0x5EED20260918)`, two `getrandbits(32)` calls per pair.
- Ordered deduplication merges provenance rather than duplicating input pairs.

| Family | Unique input triples | Native function calls | Mismatches | Genuine-condition tuples |
|---|---:|---:|---:|---:|
| OLLVM-16 | 4,591 | 13,773 | 0 | 12/12 |
| Polaris | 4,598 | 13,794 | 0 | 12/12 |
| Total | 9,189 | 27,567 | 0 | Both families complete |

For every pair: `clean == original == rewritten == uint32 source oracle`. All four genuine conditions occur both true and false; all 12 feasible joint tuples occur. There cannot be 16 feasible tuples because `x == 0x1337` implies `(x & 0xFF) == 0x37`. Coverage is determined from the tested source-condition inputs, **not** hardware branch tracing. The [runtime CSV](../results/deobfuscation/opaque_rewrite/summaries/runtime_tests.csv) and [JSON](../results/deobfuscation/opaque_rewrite/summaries/runtime_tests.json) retain each triple and result, plus six canonical records (9,195 rows total).

## 6. Actual-byte CFG measurements

Boundaries come from exports and PE unwind function extents, not guessed next-symbol addresses. Linear disassembly includes all bytes in those extents, including unreachable code. Leaders are the entry, direct branch targets, and the instruction after a branch/return. Calls do not split intraprocedural blocks; returns terminate them. No indirect branches occur. LLVM and Triton static decoders agree on every instruction address and byte sequence in all six targets.

**All-static** includes physically present dead blocks and NOPs. **Entry-reachable** follows the rewritten direct CFG from the entry, retaining both genuine conditional successors, without additional solver reasoning. Original CFG reachability is syntactic; it includes the impossible edges that had not yet been patched.

| Family / version / scope | Blocks | Edges | Jcc | JMP | Indirect | Instructions | Instruction bytes in scope | Opaque Jcc | Genuine Jcc |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| OLLVM clean, both scopes | 11 | 14 | 4 | 2 | 0 | 39 | 179 | 0 | 4 |
| OLLVM original, both scopes | 70 | 95 | 26 | 43 | 0 | 460 | 1,668 | 22 | 4 |
| OLLVM rewritten, all-static | 70 | 73 | 4 | 65 | 0 | 482 | 1,668 | 0 | 4 |
| OLLVM rewritten, entry-reachable | 37 | 40 | 4 | 32 | 0 | 385 | 1,329 | 0 | 4 |
| Polaris clean, both scopes | 11 | 14 | 4 | 2 | 0 | 39 | 179 | 0 | 4 |
| Polaris original, both scopes | 54 | 73 | 20 | 31 | 0 | 286 | 1,111 | 16 | 4 |
| Polaris rewritten, all-static | 54 | 57 | 4 | 47 | 0 | 302 | 1,111 | 0 | 4 |
| Polaris rewritten, entry-reachable | 30 | 33 | 4 | 23 | 0 | 250 | 923 | 0 | 4 |

Preferred-image VA ranges, end exclusive (image base `0x140000000`):

- Both clean targets: `0x140001210–0x1400012C3` (RVA `0x1210–0x12C3`, 179 bytes).
- OLLVM original and rewritten: `0x140001630–0x140001CB4` (RVA `0x1630–0x1CB4`, 1,668 bytes).
- Polaris original and rewritten: `0x140001210–0x140001667` (RVA `0x1210–0x1667`, 1,111 bytes).

The physical instruction counts **increase** by 22 and 16 because each six-byte JNE becomes two decoded instructions: JMP plus NOP. This does not mean code size increased. The NOP is unreachable after its JMP, and predicate setup/arithmetic on the feasible path is still present and executed. The actual target function byte ranges and PE file sizes are unchanged.

Machine-readable measurements: [CSV](../results/deobfuscation/opaque_rewrite/summaries/cfg_metrics.csv), [JSON](../results/deobfuscation/opaque_rewrite/summaries/cfg_metrics.json).

## 7. Read-only pruning projection

| Family | Original blocks now unreachable | Bogus clones | Jump stubs | Predicate computation | Genuine semantic | Unknown |
|---|---:|---:|---:|---:|---:|---:|
| OLLVM-16 | 33 | 11 | 22 | 0 | 0 | 0 |
| Polaris | 24 | 8 | 16 | 0 | 0 | 0 |

The mapping follows each independently labeled injected gate's now-impossible fallthrough to its one-JMP stub and then the clone. Compiler assembly instruction counts and mnemonic sequences match the frozen PE instruction order exactly. Clone provenance is retained at OLLVM labels `.LBB8_33` through `.LBB8_43`, and Polaris `.LBB8_27` through `.LBB8_34`, with the corresponding retained IR showing original/clone edges. Empty forwarding clones are classified as clones by provenance, rather than relabeled stubs because they contain one JMP.

Per-original-block addresses, instructions, compiler labels, and associated proof gates are retained in each `original_blocks_now_unreachable.json/.csv`. Comparison uses reachable **instruction addresses**, not just post-patch block leaders, because the new padding NOP shifts the beginning of an unreachable block by one byte.

The newly unreachable original blocks account for 317 OLLVM bytes and 172 Polaris bytes. Adding 22/16 unreachable padding NOPs gives the 339/188-byte gaps between total and entry-reachable bytes. **No such bytes were deleted.** No genuine semantic block or predicate-computation block became unreachable under this classification.

Actual-byte graph JSON, DOT, and SVG exist for clean, original, and rewritten, both all-static and entry-reachable. The read-only pruned comparisons are:

- [OLLVM reachable projection](../results/deobfuscation/opaque_rewrite/cfg_projection/ollvm16/rewritten_entry_reachable.svg).
- [Polaris reachable projection](../results/deobfuscation/opaque_rewrite/cfg_projection/polaris/rewritten_entry_reachable.svg).

These are structural intraprocedural CFGs, not whole-program proofs. Unusual external jumps into internal blocks, exception transfers, debugger-modified execution, concurrent global mutation, or self-modifying code are outside this analysis.

## 8. PE metadata, unwind, and debugger caveats

The complete headers and every byte outside the patch windows are identical. This preserves section layout, `SizeOfImage`, exports/imports and their data, entry points, relocations, exception/unwind metadata, and debug-directory bytes. VA/RVA/file-offset translation is explicit; ASLR runtime addresses should be obtained as loaded module base plus RVA. See Microsoft's [PE format specification](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format).

| Family | SizeOfImage, unchanged | Approved instruction-window bytes | Actual changed bytes | Unwind prologue end VA |
|---|---:|---:|---:|---|
| OLLVM-16 | 598,016 | 132 | 88 | `0x14000163A` |
| Polaris | 581,632 | 96 | 64 | `0x140001214` |

Every patched gate is inside the original unwind-described function, **outside its prologue**. All original prologue, epilogue, stack-adjustment, and unwind-info bytes remain unchanged. Both inputs have a zero PE checksum and no certificate table, so no checksum update/signature repair was performed; the pilot rejects nonzero-checksum/signed inputs instead of generalizing this policy.

Ordinary execution and metadata identity do **not** prove Windows exception or asynchronous unwinding correctness. No exception-injection, forced unwind, or debugger single-step campaign was performed. Microsoft's [x64 exception-handling documentation](https://learn.microsoft.com/en-us/cpp/build/exception-handling-x64?view=msvc-170) describes the relationship between function ranges, prologues, and unwind information; physical code compaction would need a separate metadata-aware treatment.

No PDB is copied alongside either output. The old PDB is input provenance only. Because headers are preserved, the original RSDS/PDB reference remains embedded; **do not accept it as a valid instruction-level mapping for the rewritten PE**, even if a debugger or IDA offers to load it. Use exports, module-relative RVAs, and the new exact-byte listings. This task did not claim an interactive IDA/x64dbg test.

## 9. Strongest course-facing patch example

Use the first OLLVM gate, preferred VA `0x140001667`, RVA `0x1667`, raw file offset `0xA67`. Its predicate loads two symbolic 32-bit globals, computes the low bit of `A*(A-1)`, compares signed `B < 10`, ORs those boolean results, then tests bit 0. Relevant unmodified instructions include:

```asm
14000164c: 89c2         mov edx, eax
14000164e: 83ea01       sub edx, 1
140001651: 0fafc2       imul eax, edx
140001654: 83e001       and eax, 1
140001657: 83f800       cmp eax, 0
14000165a: 0f94c0       sete al
14000165d: 83f90a       cmp ecx, 0xa
140001660: 0f9cc1       setl cl
140001663: 08c8         or al, cl
140001665: a801         test al, 1
```

The explanatory parity identity is useful for a reader, but **not a recognition rule in the patcher**. Authority is the frozen machine-derived predicate evidence at `opaque_triton/ollvm16/o0/predicate_0000`:

- Complete entry prefix: `(= (_ bv1 1) (_ bv1 1))` (no prior constraints).
- Branch condition: `(= ref!108 (_ bv0 1))`, backed by its retained machine-derived expression DAG.
- Taken query: **SAT**; not-taken query: **UNSAT**.
- Unrestricted queries: the same SAT/UNSAT split.
- Independent ground truth: injected opaque branch.

Before:

```asm
140001667: 0f 85 05 00 00 00    jne 0x140001672
14000166d: e9 73 05 00 00       jmp 0x140001be5 ; impossible stub -> clone
```

After:

```asm
140001667: e9 06 00 00 00       jmp 0x140001672
14000166c: 90                   nop
14000166d: e9 73 05 00 00       jmp 0x140001be5 ; retained, unreachable
```

The displacement changes from 5 to 6 because JMP ends one byte earlier. Only this six-byte instruction window changes; the clone stub is untouched. The full 22-site rewritten PE runs normally with `SHOWCASE PASS`, exit 0, and passes 4,591 differential triples. In a rebased debugger, inspect `module_base + 0x1667`, not the preferred VA literally.

This is the teaching chain: **actual predicate instructions → frozen full-prefix SAT/UNSAT evidence → exact JNE bytes → displacement-correct JMP/NOP → working PE → smaller reachable CFG**. Polaris then demonstrates transfer of the same proof-consumption/patching method to a second implementation.

## 10. Interpretation, limitations, and next step

The proofs support branch feasibility within the frozen analysis model; concrete execution and exact-byte checks support the correctness of this patch implementation. Neither substitutes for the other. No finite runtime sample exhausts all inputs. The retained proofs are not newly independently verified, nor are they proofs of arbitrary whole-program, concurrent, or exception behavior.

The results establish that these selected impossible choices can be replaced consistently with their proved feasible direction in both Windows x64 families, preserving every tested result. They do **not** establish that the binaries have returned to compiler-clean form, that predicate arithmetic is gone, or that Triton alone automatically rewrites arbitrary binaries. Residual feasible-path arithmetic and many JMPs make the rewritten targets much larger than the 39-instruction clean target.

### Optional Stage 2: design only

Further cleanup is worthwhile for readability, but separate from this successful pilot:

1. Confirm whole-function/whole-program reachability assumptions and exceptional/external entries before removing unreachable blocks.
2. Lift reachable instructions with alias, flag, memory-side-effect, and call models; use liveness/dataflow proofs to remove predicate computations that no longer affect behavior. Do not delete arithmetic merely because it resembles an opaque-predicate template.
3. If compacting code, recalculate every changed relative branch/call and RIP-relative data reference; maintain function/export addresses or deliberately remap all references.
4. Shorten branches with iterative layout and range checks, not a single unchecked pass.
5. Rebuild/revalidate affected `RUNTIME_FUNCTION` and unwind data, relocations, debug information, checksums/signatures as applicable; repeat exact-byte, canonical, differential, and dedicated exception/unwind tests.

None of that cleanup was implemented. It would be a separate optimizer/metadata project, not a small extension to these 38 byte-window edits.

**Recommendation: begin assembling the course next**, using the clean/original/branch-rewritten/reachable-projection ladder. The current example already makes a complete, reproducible proof-to-binary lesson. An advanced opaque-predicate probe would be the focused later experiment if the course needs to teach limitations beyond parity predicates; moving to Mergen now would broaden the question before that teaching need is established. This is a recommendation only: no course files were changed, and no advanced probe or Mergen work began.

## 11. Evidence index

- `proof_audit/`: both exact input/proof audits, encoding tests, before/after preservation manifests.
- `ollvm16_o0/`, `polaris_o0/`: disposable PE, original/patched bytes and proofs, metadata audit, complete PE disassembly, canonical logs, deterministic input plan, isolated-worker logs, per-input triples, validation status.
- `summaries/patches.csv/.json`: 38 patches and their provenance.
- `summaries/runtime_tests.csv/.json`: 9,189 differential triples and six canonical records.
- `summaries/cfg_metrics.csv/.json`: 12 family/version/scope rows.
- `cfg_projection/<family>/`: exact target instruction inventories, independent LLVM listings/checks, CFG JSON/DOT/SVG, per-original-block unreachable classification.
- [Final audit](../results/deobfuscation/opaque_rewrite/summaries/final_audit.json): completion, hashes, tools/scripts, preservation count, and aggregate validation results.
- [Independent post-run checks](../results/deobfuscation/opaque_rewrite/summaries/independent_verification.json): separately recalculated actual branch displacements, every patch window, non-patch/genuine bytes, runtime records, syntax, SVG validity, and report links. [Output freeze](../results/deobfuscation/opaque_rewrite/summaries/output_freeze.json) records SHA-256 hashes of the completed pilot files, scripts, and this report.
- [Pilot implementation](../scripts/deobfuscation/opaque_rewrite/pilot.py), [encoder/PE helpers](../scripts/deobfuscation/opaque_rewrite/support.py), [native driver](../scripts/deobfuscation/opaque_rewrite/native_worker.py), [CFG reconstruction](../scripts/deobfuscation/opaque_rewrite/cfg.py).

Stopped after this pilot. Frozen source, prior evidence, original binaries, PDBs, environments, toolchains, and course design are unchanged.
