# msynth arithmetic/MBA validation

Validation date: 2026-09-17. Scope: arithmetic only; no unflattening, opaque-predicate solving, binary rewriting, corpus rebuild, or BinProtect repair.

## Outcome

msynth installed successfully in a dedicated Python 3.11 environment. Miasm extracted all 192 intended arithmetic sites from eight existing PE/x64 specimens, including the two explicitly static-only BinProtect specimens. Each site was measured in two separately identified Simplifier modes: 384 site/mode records.

The standard oracle-oriented path was weak on the remaining machine-level obfuscation. The current default SiMBA-enabled path helped Tigress and BinProtect MBA, but recovered none of the 24 Polaris MBA sites completely. A deliberately small, separate Synthesizer probe recovered three previously failed XOR sites—one each from OLLVM, Tigress, and Polaris MBA—with full 32-bit SMT proofs. This supports a bounded claim of cross-implementation semantic generalization, not a claim that the oracle solves the complete corpus.

The frozen source, version marker, upstream checkout, compilers, and existing PE artifacts are unchanged. BinProtect was **not executed** during this phase.

## 1. Identity, requirements, and installation

| Component | Exact tested identity |
| --- | --- |
| msynth checkout | `third_party/deobfuscators/msynth`, branch `main`, commit `661a5e3d7c0358950cf48b27ae422450c3064966`; clean before and after |
| Latest local commit | Tim Blazytko; committed by GitHub; 2026-06-14 18:54:49 -0400; “Clarify simplification techniques in README” |
| Installed package | `msynth 1.0.0`, built from a Git archive of that commit, not an editable installation |
| Interpreter | `E:\Workspace\seeing_through_obfuscation\.venvs\msynth\Scripts\python.exe`, CPython **3.11.4**, 64-bit |
| Base interpreter | `D:\Programs\anaconda3_11\python.exe`; used only to create a venv; `include-system-site-packages = false` |
| Miasm | package **0.1.5**, exact Git revision **`24a64bb30a181d60fe9572293c1b2fa597b2d0c9`**, confirmed by installed `direct_url.json` |
| Z3 | `z3-solver 5.1.0.0` |
| Other packages | `future 1.0.0`, `pyparsing 3.3.2`, `packaging 26.3`, `wheel 0.48.0`, `setuptools 84.0.0`, `pip 26.2.1` |

The actual local README and implementation were inspected, along with the current [upstream README](https://github.com/mrphrazer/msynth#installation). Remote HEAD was observed as `0f98c9c8df75644228a38adb5e4bf56ee31bf24b`; the existing checkout was deliberately not updated. Results refer to the tested commit above, not implicitly to latest upstream.

The repository requirements are exactly `wheel`, unpinned `z3-solver`, and the Git-pinned Miasm revision above. `setup.py` declares Python `>=3.7`; this experiment tested 3.11.4, not every declared version. The LICENSE file contains GPL version 2, while the setup classifier advertises GPLv3+. This upstream metadata discrepancy is recorded without changing either file.

Installation is retained in [install.ps1](../scripts/deobfuscation/msynth/install.ps1). It creates `.venvs/msynth`, archives tracked msynth source into `deobfuscators/msynth_runtime/source`, and runs:

```powershell
& $python -m pip install --force-reinstall -r $upstream\requirements.txt
& $python -m pip install --no-deps $runtime\source
& $python -m pip check
```

The full paths and bootstrap commands are in the script. Force reinstall prevents a different Miasm commit with the same `0.1.5` version from being silently reused. No Anaconda base packages were installed or upgraded. Miasm's Python wheel sufficed for disassembly/lifting; a native JIT is not required here.

Two environment issues were handled without source patches: Git Schannel could not acquire credentials, so a process-local OpenSSL backend was used with TLS verification retained; pip's default wheel cache was unwritable, so its cache was moved into the project runtime directory. The initial failed attempt and successful install logs are preserved. `pip check` passed. No msynth or Miasm compatibility patch was needed.

The checkout includes `gen_oracle.py`, `symbolic_simplification.py`, standalone simplification/SiMBA/CEGIS/synthesis examples, preprocessing and corpus runners, tests, datasets, and `samples/mba_challenge`. The complete script inventory, package list, requirements, license hash, and Git metadata are in [environment/identity.json](../results/deobfuscation/msynth/environment/identity.json).

## 2. Database and oracle

The included ZIP is 10,268,029 bytes and contains a 172,389,908-byte text library with **1,293,020 nonempty expression lines**. It was inspected directly through ZIP streaming; decompression into the upstream checkout was unnecessary. A ready-made `oracle.pickle` is also included.

| Artifact | SHA-256 |
| --- | --- |
| `database/3_variables_constants_7_nodes.txt.zip` | `A3E3711A1D42E1F83E3D1103F415CEFDAF73CC3EFBAD7CC124C66BC2FE1E9169` |
| Included `oracle.pickle` | `176F2BB6420DB7A8D171535D9CC45B0B9D7FEA95573D9F9D8A7A27AE057EBDC0` |
| Project-local `oracle.db` | `C4CAA8213BD19D06C621D1E72EC41195887BB459FF9F8170DC4C1BEBBFE26715` |

The supplied pickle was copied outside the checkout and converted using upstream `SimplificationOracle.load_from_file(...)` followed by `dump_to_file(..., use_sqlite=True)`. This was **format conversion, not new oracle generation**. The pickle load took 6.201 seconds; conversion took 8.372 seconds. SQLite size: **65,789,952 bytes**; 403,675 equivalence classes; 30 variables and 50 oracle samples. SQLite integrity check returned `ok`, and the database hash remained unchanged after validation. No optional external database was downloaded.

Command:

```powershell
& .\.venvs\msynth\Scripts\python.exe -B .\scripts\deobfuscation\msynth\sanity.py --setup-oracle
```

The runtime oracle is `deobfuscators/msynth_runtime/oracle.db`; original pickle size is 60,118,922 bytes. Full conversion metadata is in [environment/oracle.json](../results/deobfuscation/msynth/environment/oracle.json). The supplied oracle's historical generation duration is not known and is not invented here.

## 3. Upstream sanity tests

| Test | Result |
| --- | --- |
| Standalone 32-bit `(x & y) * 2 + (x ^ y)` | `x + y`, 9 → 3 AST nodes, UNSAT for disequality in both AST and SiMBA modes; upstream SMT API also returned UNSAT |
| Upstream `simplify_expression.py` | 449 → 11 AST nodes; output `6*v0 + 6*v1 + 3*v2`; compositional SMT proof succeeded |
| Upstream `symbolic_simplification.py samples/mba_challenge 0x1290 oracle.db` | ELF/x64 loading and symbolic simplification worked on Windows; 18 output expressions checked; 17 proved, one auxiliary 1-bit zero-test remained UNKNOWN |

The scripts ran from the unmodified checkout using the installed package. The ELF sample was analyzed, not executed as a Windows program. A project wrapper observed returned expressions without changing the upstream scripts' Simplifier settings.

Some monolithic proofs timed out. A separate verifier generated subtree candidates, accepted only SMT-proven equalities, and checked the final residual equality. These are congruence/transitivity proofs, not random testing. Proof certificates and the initial timeouts are retained; a later audit replayed the certificate substitution structure. Repeated sanity runs reused retained proofs only for identical input/output expression pairs. The one unresolved zero-test is **not** labeled a proof or a detected unsound rewrite. The arithmetic output is proved, so this is not an installation blocker.

See [sanity](../results/deobfuscation/msynth/sanity), [sanity.py](../scripts/deobfuscation/msynth/sanity.py), and [proof_lemmas.py](../scripts/deobfuscation/msynth/proof_lemmas.py). This is the requested sanity coverage, not a claim that the entire upstream test suite was run.

## 4. Exact selected machine-code artifacts

All targets are `demo_substitution`. Address intervals below are **RVA, end-exclusive**, with image base `0x140000000`. Every range was obtained from the PE exception directory's `RUNTIME_FUNCTION` BeginAddress/EndAddress and corroborated by retained symbol/disassembly evidence; no next-export approximation was used. Miasm decoded the actual PE bytes across the entire interval, and byte lengths/instruction counts were checked against the bounded retained disassembly.

| Specimen | RVA interval | Bytes | Instructions | Matching PDB/MAP |
| --- | --- | ---: | ---: | --- |
| OLLVM-16 SUB O0 | `[0x1070, 0x1512)` | 1,186 | 311 | Both |
| Hikari SUB O0 | `[0x1050, 0x1378)` | 808 | 213 | Both |
| Polaris SUB O0 | `[0x1030, 0x1374)` | 836 | 227 | Both |
| Tigress EncodeArithmetic O0 / MSVC `/Od /Ob0` | `[0x11D0, 0x1872)` | 1,698 | 426 | Both |
| Polaris MBA O0 | `[0x1030, 0x1A63)` | 2,611 | 678 | Both |
| Tigress EncodeArithmetic O3 / MSVC `/Ox` | `[0x11A0, 0x14EB)` | 843 | 226 | Both |
| BinProtect MBA O2 — **STATIC ONLY / SEMANTICALLY INVALID PROTECTED PE** | `[0x181F, 0x1CCC)` | 1,197 | 381 | No relocated matching pair |
| BinProtect Linear O2 — **STATIC ONLY / SEMANTICALLY INVALID PROTECTED PE** | `[0x1995, 0x23C8)` | 2,611 | 943 | No relocated matching pair |

The corrected Polaris MBA range measures 2,611 bytes, rather than reusing an older approximate byte count. Original clean-input MAP files for BinProtect are retained as provenance only; they are not represented as matching symbols for relocated protected functions.

[summaries/artifacts.json](../results/deobfuscation/msynth/summaries/artifacts.json) records every exact executable path, full SHA-256, VA/RVA, byte range, optimization flag, source hash where available, and symbol availability. Original matrix site classifications were retained in each case's `prior_site_provenance.json`. They describe IR/source coverage and are not treated as precise machine-site boundaries.

## 5. Miasm input and machine-code extraction

The upstream symbolic example uses `Container.from_stream(file, LocationDB())`, `Machine(container.arch)`, the architecture disassembler, `lifter_model_call`, an empty initial symbolic state, and one disassembled basic block. It simplifies nontrivial values from `sb.modified()`, not specifically a Windows function's EAX return. That example is not automatically a complete Windows ABI harness.

The project harness [extract.py](../scripts/deobfuscation/msynth/extract.py) instead:

1. Loads PE directly with Miasm's `ContainerPE` and confirms `x86_64`. Disassembly addresses are image **VAs**, not RVAs or file offsets.
2. Uses `machine.lifter` and Miasm's actual instruction semantics, including register alias handling, stack memory, 32-bit writes, extension/truncation, and instruction-local IR blocks. No assembly instructions are manually translated into arithmetic formulas.
3. Initializes RCX with a zero-extended arbitrary 32-bit `input`, and RSP to an isolated, aligned stack anchor `0x7FFF00001008`. Other registers and uninitialized memory remain symbolic. The model assumes the local stack is separate from the image and globals. It does not invoke a native JIT or the specimen executable.
4. Discovers eight contiguous four-byte stack cells, each written four times: initialization, XOR, ADD, SUB. This property comes from the canonical volatile-array source, not an obfuscator template.
5. On a second pass, replaces each completed array store with a fresh independent 32-bit memory symbol. At the next writeback of that cell, the accumulated Miasm expression isolates that source operation. Only this previous-value marker is renamed to generic `x`.
6. Rejects a site with residual memory or unrelated symbolic inputs. All 192 extracted sites passed this structural check. Source-operation matching is evaluated separately by SMT after simplification.

The expected operations are `x ^ 0x12345678`, `x + 0x1337`, and `x - 0x1111`, modulo `2^32`. Site indices are zero-based. The symbolic cut points prevent previous arithmetic stages and final aggregation from contaminating an individual operation. All symbolic extraction preserves the stack stores and loads rather than treating the function as register-only.

Each site includes its writeback VA/RVA, explicit conservative instruction-dependency address set, and enclosing range. These are **not minimal slices**: stack-address setup, hoisted constants, and syntactically canceled dependencies may remain. The range can therefore start near the prologue. “Raw expression” means the result of Miasm's normal symbolic evaluation **before msynth**, not an unsimplified instruction-by-instruction AST; Miasm's own normalization can already remove considerable obfuscation.

Eight initialization checks per artifact are also retained. Five Polaris MBA initialization-to-source queries timed out; they are not silently called proofs. The primary site experiment uses independent values at store cut points, not an assumption that those initialization queries succeeded.

## 6. Experimental modes, classification, and soundness

Two fixed modes were applied identically across families:

- **`oracle_AST`**, primary: supplied SQLite oracle, `PipelineMode.AST`, `enforce_equivalence=True`, 2-second internal solver timeout, CEGIS and dead-variable elimination disabled. It includes msynth's stock closing algebraic rewriter; “AST mode” is not synonymous with a successful lookup.
- **`oracle_plus_SIMBA`**, secondary: the same configuration with `PipelineMode.SIMBA`, the tested revision's default pipeline. SiMBA is algebraic reconstruction, **not stochastic synthesis**.

Workers receive the raw expression and expected expression only. The expected operation is used for post-result verification/classification; it is not passed as a simplification hint. No family identity or per-obfuscator rules select transformations. Python random seed and `PYTHONHASHSEED` are 0 in site workers. Each worker has a 90-second wall limit.

Every returned result is independently checked with Miasm's Z3 translator and a 10-second solver timeout. A disequality returning **UNSAT** proves equivalence over bit-vectors. SAT is a counterexample; UNKNOWN/timeouts are unverified. This external check is necessary because this msynth revision's final candidate gate still uses permissive sampling even when internal replacement equivalence is enforced. Random or oracle I/O samples are never treated as proofs.

AST counts are occurrence-counted trees, including repeated subtrees, not unique DAG nodes. Native Miasm variadic operators count as one node; a binary-normalized result can therefore slightly increase this metric. Reduction is `100*(before-after)/before`; ratio is `after/before`. Negative reduction is retained.

Classification policy:

- **EXACT RECOVERY:** proved equivalence and source match, with the result matching the expected expression after normal Miasm canonicalization.
- **EQUIVALENT RECOVERY:** proved source match in a different compact form of at most five AST nodes. None occurred in this run.
- **PARTIAL SIMPLIFICATION:** both proofs succeed and AST reduction is at least 20%, but the simple expected form is not recovered.
- **NO SIMPLIFICATION:** proofs succeed but neither compact recovery nor the 20% reduction threshold is met; includes no change and small AST growth.
- **EXTRACTION FAILURE:** unresolved inputs/memory or inability to extract the site. None occurred.
- **UNSOUND / VERIFICATION FAILURE:** the required proof is missing or fails. A separate status distinguishes SAT from UNKNOWN. Here these rows are **UNKNOWN_TIMEOUT only**, not detected unsoundness.

`already_canonical_before_msynth` and `nontrivial_recoveries` separate compiler/Miasm simplification from work actually added by msynth. An accepted-oracle-candidate counter distinguishes observed lookup activity from closing rewrites or SiMBA; it is not a causal ablation.

## 7. Primary cross-obfuscator results

All rows attempted and extracted 24 sites. “Simple at output” includes sites already simple at input. Counts below are exact recoveries; equivalent recoveries were zero.

| Runnable specimen | Already simple before msynth | AST simple at output | AST newly recovered | SiMBA simple at output | SiMBA newly recovered |
| --- | ---: | ---: | ---: | ---: | ---: |
| OLLVM-16 SUB O0 | 16 | 16/24 (66.7%) | 0 | 16/24 (66.7%) | 0 |
| Hikari SUB O0 | 22 | 22/24 (91.7%) | 0 | 22/24 (91.7%) | 0 |
| Polaris SUB O0 | 16 | 16/24 (66.7%) | 0 | 16/24 (66.7%) | 0 |
| Tigress EncodeArithmetic O0 | 7 | 8/24 (33.3%) | 1 | 13/24 (54.2%) | 6 |
| Polaris Linear MBA O0 | 0 | 0/24 | 0 | 0/24 | 0 |

OLLVM and Polaris SUB retain eight masked XOR expressions that neither mode recovered; their ADD and SUB sites are already canonical in Miasm. Hikari retains two such XOR failures, with the other 22 already canonical. These high end-to-end simple-expression rates are **not evidence of fresh msynth oracle recovery**.

Tigress SiMBA results are XOR 0/8, ADD 5/8, SUB 8/8. Its one new AST-mode recovery came from the closing rewriter, with zero accepted oracle replacements. Successful SiMBA recovery is demonstrated on noncanonical Tigress addition/subtraction expressions.

### AST reduction and measured simplification time

Statistics include all 24 returned expressions, including unverified source matches; they are size measurements, not additional successful recoveries. Times sum calls to `simplify`; independent verification, Python startup, and extraction are excluded. These are single-run timings, not stable performance rankings.

| Specimen | Mode | Mean / median / max reduction | Summed simplification seconds |
| --- | --- | --- | ---: |
| OLLVM SUB O0 | AST / SiMBA | 0 / 0 / 0% | 0.135 / 0.216 |
| Hikari SUB O0 | AST / SiMBA | 0 / 0 / 0% | 0.054 / 0.111 |
| Polaris SUB O0 | AST / SiMBA | 0 / 0 / 0% | 0.168 / 0.173 |
| Tigress O0 | AST | 0.26 / 0 / 72.73% | 0.091 |
| Tigress O0 | SiMBA | 14.98 / 0 / 75.00% | 0.139 |
| Polaris MBA O0 | AST | 10.31 / -3.23 / 41.46% | 0.509 |
| Polaris MBA O0 | SiMBA | 10.31 / -3.23 / 41.46% | 23.082 |
| Tigress `/Ox` | AST | 6.49 / 0 / 72.73% | 0.098 |
| Tigress `/Ox` | SiMBA | 22.61 / 0 / 72.73% | 0.094 |

All category counts, means, medians, maxima, times, and operator-level results are in [family_results.json](../results/deobfuscation/msynth/summaries/family_results.json) and [operator_results.json](../results/deobfuscation/msynth/summaries/operator_results.json).

## 8. Polaris MBA stress test

All 24 sites were extracted from the fixed existing PE hash; no nondeterministic recompile was performed. The machine-derived, constant-normalized input trees still have **8/8 distinct shapes in each operation family**. Raw sizes range from 43 to 94 nodes, mean 72.83.

Both modes produced the same classification distribution: **0 exact, 0 equivalent, 9 partial, 7 no simplification, 8 source-equivalence timeouts**. There were accepted oracle replacements at 11 sites, but they reduced subexpressions rather than recovering a simple source operation. Mean reduction was 10.31%; median was -3.23%; maximum was 41.46%.

Observed expression features, not inferred causes:

- All 24 contain multiplication, 32/64-bit slices/compositions, and conditional structures arising from signed-extension/multiply lifting: 4–8 slices, 4–8 compositions, and 2–4 conditionals per expression.
- No residual memory reads or shift operators remain in these site expressions. Machine shifts may have been normalized; this does not mean the machine code contained none.
- The eight source-proof timeouts had 67–88 nodes and 7–9 multiplication occurrences. Proven cases span 43–94 nodes and 4–8 multiplication occurrences. The overlap does not establish a size threshold or a causal explanation.
- Constants vary substantially. The experiment did not isolate unusual constants, multiplication, or mixed widths in a causal ablation, so none is asserted as the sole failure reason.

The unresolved source checks are XOR indices 3, 5, 6, 7; ADD 0, 5; SUB 1, 3. Every returned Simplifier expression was nevertheless proved equivalent to its raw input. The unresolved issue is the additional proof against the intended compact operation. Exact measurements are in [polaris_mba/feature_results.json](../results/deobfuscation/msynth/polaris_mba/feature_results.json).

## 9. Optimization comparison: identical Tigress-generated C

O0 and `/Ox` were built previously from the same generated C, SHA-256 `54163E7E0B29E5A3815CEB8A92A5C9C6A3186F7B790EC7E7CEEB525BBA19BD88`. No new builds were made.

Optimization reduced the bounded target from 426 to 226 instructions and mean raw site AST size from 7.83 to 7.08. The already-canonical count remained seven. AST-mode recovery rose **8 → 10/24**; SiMBA recovery rose **13 → 16/24**, with newly recovered sites **6 → 9**. ADD indices 1, 2, and 7 changed from SiMBA failures to exact recoveries. For example, their raw AST counts changed 15→11, 14→9, and 14→9 respectively.

Thus `/Ox` made these particular machine-level expressions easier for the tested simplifier. This is a paired specimen result, not a universal claim about optimization. Both levels' site outputs match the same modular source operations under SMT; the paired records are in [optimization_comparison/paired_sites.json](../results/deobfuscation/msynth/optimization_comparison/paired_sites.json).

## 10. BinProtect — STATIC ONLY / SEMANTICALLY INVALID PROTECTED PE

Neither protected PE was executed, patched, or repaired. Symbolically isolating local arithmetic does not validate entry-point behavior, stack-frame correctness, control flow, or the executable as a whole.

| Static-only specimen | AST exact recovery | SiMBA exact recovery | Interpretation |
| --- | ---: | ---: | --- |
| BinProtect MBA O2 — semantically invalid PE | 0/24 | 16/24 | All eight ADD and eight SUB sites recovered by SiMBA; all eight XOR sites remain complex. All 48 mode/site source checks proved. |
| BinProtect Linear O2 — semantically invalid PE | 24/24 | 24/24 | All 24 were already canonical after Miasm; zero new msynth recovery. Constant-pair materialization is a useful negative/control case, not strong MBA evidence. |

BinProtect MBA SiMBA mean/median/max reduction is 45.06% / 66.67% / 75%, summed simplification time 0.096 s. AST-mode reduction is zero, time 0.116 s. Linear reductions are zero in both modes, times 0.052/0.083 s.

See [binprotect_static](../results/deobfuscation/msynth/binprotect_static). Static labels are retained on the artifact and site records and in each specimen's warning file.

## 11. Representative before/after expressions

All expressions below are 32-bit modular operations. These are measured machine-code-derived results, not manually translated assembly.

Tigress ADD index 0, oracle plus SiMBA:

```text
BEFORE: (x & 0x1337) + (x | 0x1337)
AFTER:  0x1337 + x
```

This recovers the original `value[i] += 0x1337`; input/output and source-equivalence disequalities are UNSAT. No accepted oracle lookup was needed for this SiMBA result.

Tigress SUB index 2, AST mode's closing rewriter, 11 → 3 nodes:

```text
BEFORE: ((x ^ 0xFFFFFFFF) & 0x1111) * 0xFFFFFFFE + (x ^ 0x1111)
AFTER:  x + 0xFFFFEEEF
```

`0xFFFFEEEF` is `-0x1111` modulo `2^32`. Both proofs are UNSAT. This is a rewriter result, not evidence that the precomputed oracle recognized a Tigress signature.

OLLVM XOR index 0, separate Synthesizer probe, 11 → 3 nodes:

```text
BEFORE: ((x & 0xD0C65B7A) | ((x ^ 0xFFFFFFFF) & 0x2F39A485)) ^ 0x3D0DF2FD
AFTER:  x ^ 0x12345678
```

Both Simplifier modes left this expression unchanged. Synthesis recovered the intended XOR with two UNSAT checks.

## 12. Small synthesis probe, not an expanded matrix

Exactly three failed XOR-index-0 sites were preselected for the optional probe. All used the same stock `Synthesizer(use_smir=True)`, 50 I/O samples, random seed 0, and a 10-second search budget. The expected expression and obfuscator identity were not supplied to the synthesis algorithm. This is the upstream stochastic/SMIR path, not oracle lookup or pure SiMBA.

| Selected failure | AST nodes before → after | Search seconds | Output | SMT input/output and source |
| --- | ---: | ---: | --- | --- |
| OLLVM SUB O0 XOR 0 | 11 → 3 | 0.135 | `x ^ 0x12345678` | UNSAT / UNSAT |
| Tigress EncodeArithmetic O0 XOR 0 | 8 → 3 | 0.133 | `x ^ 0x12345678` | UNSAT / UNSAT |
| Polaris MBA O0 XOR 0 | 62 → 3 | 0.149 | `x ^ 0x12345678` | UNSAT / UNSAT |

All three sampling scores were zero, but success is based on the subsequent SMT proofs, not those scores. The Polaris input includes the sign-extended 64-bit multiply/truncate structure retained by Miasm; its full before-expression is in [synthesis_results.json](../results/deobfuscation/msynth/summaries/synthesis_results.json). Only **one of 24 Polaris MBA sites** was tested in this mode. These selected successes must not be extrapolated to a 24/24 recovery claim or added to the primary oracle rates.

## 13. Whole-function attempt and limitations

Whole-function analysis used no memory cut points, a 20,000-node-per-state-value guard, and a 60-second worker budget. It used AST mode only and independent 5-second final proof budgets.

| Runnable specimen | Outcome |
| --- | --- |
| OLLVM SUB O0 | Reached RET; 7,546 → 7,587 nodes; input/output and canonical-source return proved equivalent; no useful reduction |
| Hikari SUB O0 | Reached RET; 636 → 651 nodes; both proofs succeeded; no useful reduction |
| Polaris SUB O0 | Reached RET; 6,779 → 6,787 nodes; both proofs succeeded; no useful reduction |
| Tigress O0 | Obtained RAX at an external security-check call boundary, not a whole-function return; 946 → 756 nodes; both final queries UNKNOWN |
| Polaris MBA O0 | Stopped at the size guard: 25,384 nodes at VA `0x1400014A4`; no whole-function simplification claim |
| Tigress `/Ox` | Reached RET; 948 → 654 nodes; both final queries UNKNOWN; reduction is not a verified whole-function recovery |

The expected whole-function expression uses arbitrary input and the eight actual initialization/XOR/ADD/SUB lanes followed by XOR aggregation. It is **not** replaced by the known output for the single default runtime input. No opaque-predicate solving or external-call semantics were invented to force completion. Full records: [whole_function_results.json](../results/deobfuscation/msynth/summaries/whole_function_results.json).

## 14. Complete soundness accounting

- Core site input → Simplifier output: **384 UNSAT, 0 SAT, 0 UNKNOWN**.
- Core site output → expected operation: **368 UNSAT, 16 UNKNOWN, 0 SAT**. The 16 UNKNOWN measurements are the same eight Polaris MBA sites in two modes.
- Recorded internal Simplifier candidate checks: **28 UNSAT**. Accepted lookup activity occurred only on Polaris MBA subexpressions and did not yield complete recovery there.
- Synthesis probes: **3 UNSAT** input/candidate and **3 UNSAT** candidate/source checks.
- Sanity: addition identity proved in both modes; the large standalone example proved compositionally; symbolic example 17/18 proved, one zero-test UNKNOWN. Initial monolithic timeouts remain in the evidence.
- Initialization diagnostics: 59/64 UNSAT, five Polaris MBA UNKNOWN. These diagnostics are outside the 24-site rates.
- Whole-function/prefix final queries: six UNSAT and four UNKNOWN, plus one expression-size abort. No SAT counterexample was found in any measured transformation output.

The audit also deliberately checked a wrong addition identity and obtained SAT, and checked 32-bit wraparound and obtained UNSAT. That deliberate SAT is a negative control, not a corpus defect. All 192 extracted site expressions were unchanged when the modeled stack anchor was relocated by `0x20000000`. Certificate structure, all PE hashes, frozen-source hashes, upstream cleanliness, and oracle integrity passed the final audit. See [evidence_audit.json](../results/deobfuscation/msynth/summaries/evidence_audit.json) and [smt_overview.json](../results/deobfuscation/msynth/summaries/smt_overview.json).

## 15. Interpretation and next step

The strongest positive evidence is **the same synthesis configuration recovering SMT-proved simple XORs from OLLVM, Tigress, and a structurally different Polaris MBA expression**, plus SiMBA recovering arithmetic from both Tigress and static BinProtect MBA. No per-obfuscator signatures were supplied.

The strongest limitation is that **the small supplied oracle plus stock AST path adds almost no complete recoveries**, and even the SiMBA-enabled path leaves all 24 Polaris MBA sites without full recovery. Masked XORs, several Tigress O0 arithmetic forms, and the mixed-width Polaris expressions remain difficult in those modes. This is a result for this commit, oracle, extraction normalization, and bounded settings—not a universal impossibility result for semantic simplification.

Recommend **one bounded expansion of arithmetic experiments next**: test the promising synthesis path on a preregistered set across operations/seeds and investigate generic, SMT-verified bit-width normalization separately from raw-input scores. Keep proven recoveries, already-simple inputs, and UNKNOWN results distinct. Miasm already extracts all intended sites here, so replacing it with Triton or building a broad custom extraction framework is not currently justified. Whole-function expression growth and call boundaries remain useful future extraction targets.

Do not move to flattening deobfuscation automatically. This phase stops here.

## Reproduction and evidence map

Project scripts: [scripts/deobfuscation/msynth](../scripts/deobfuscation/msynth). Core sequence, from the workspace root after installation/oracle setup:

```powershell
$py = '.\.venvs\msynth\Scripts\python.exe'
$scripts = '.\scripts\deobfuscation\msynth'
& $py -B "$scripts\sanity.py"
& $py -B "$scripts\extract.py"
& $py -B "$scripts\evaluate.py" --mode ast
& $py -B "$scripts\evaluate.py" --mode simba
& $py -B "$scripts\whole_function.py"
& $py -B "$scripts\extract.py" --case binprotect-mba-O2 --static
& $py -B "$scripts\extract.py" --case binprotect-linear-O2 --static
& $py -B "$scripts\evaluate.py" --case binprotect-mba-O2 --static --mode ast
& $py -B "$scripts\evaluate.py" --case binprotect-linear-O2 --static --mode ast
& $py -B "$scripts\evaluate.py" --case binprotect-mba-O2 --static --mode simba
& $py -B "$scripts\evaluate.py" --case binprotect-linear-O2 --static --mode simba
& $py -B "$scripts\synthesis_probe.py"
& $py -B "$scripts\audit.py"
& $py -B "$scripts\evaluate.py" --summarize
& $py -B "$scripts\summarize_analysis.py"
```

`evaluate.py` resumes existing result files; it does not silently recompute them. Use a separately preserved results directory/version for a genuinely fresh experiment. `--setup-oracle` rebuilds the local SQLite conversion and is unnecessary for ordinary reruns. Worker commands, stdout/stderr, exact expressions, proofs, and timings are retained per site. No reproduction command executes BinProtect.

Main data:

- [site_results.csv](../results/deobfuscation/msynth/summaries/site_results.csv) and [site_results.json](../results/deobfuscation/msynth/summaries/site_results.json): 384 core site/mode measurements.
- [family_results.csv](../results/deobfuscation/msynth/summaries/family_results.csv) and [family_results.json](../results/deobfuscation/msynth/summaries/family_results.json): 16 family/mode rows.
- [synthesis_results.csv](../results/deobfuscation/msynth/summaries/synthesis_results.csv) and [synthesis_results.json](../results/deobfuscation/msynth/summaries/synthesis_results.json): three separately labeled synthesis probes.
- Per-case folders contain bounded disassembly, exact artifact identity, extraction diagnostics, prior site provenance, and `ast`/`simba` worker records.
