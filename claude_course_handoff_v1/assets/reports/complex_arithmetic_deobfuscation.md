# Complex arithmetic probe: obfuscation and deobfuscation

Validation date: 2026-09-17. Scope: arithmetic only. No flattening, opaque-predicate solving, virtualization, BinProtect generation/repair, compiler rebuild, or package change.

## Outcome

The new probe was validated, frozen, and built successfully in all requested lanes. Its four small functions occupy a useful middle ground in source size, but the experiment exposes a clear limit: **none of the obfuscated complete functions was fully recovered by the fixed AST/oracle, SiMBA, or 10-second synthesis configurations**. AST/SiMBA did produce SMT-proved partial reductions. The separate preregistered repeated-site expansion recovered **10/12** previously failed sites; two more candidates remain SMT-UNKNOWN.

Complete-function extraction succeeded for 44/48 build/function cases. The four Polaris MBA cases stopped at the preregistered state-size guard, specifically on carry-flag expressions. They never reached msynth and must not be represented as four demonstrated simplifier failures.

This does not replace the repeated-operation dataset. That dataset tests multiple identical static operations; this one tests composition and interaction between operations.

## 1. Frozen source and independent validation

Source: [substitution_complex.c](../src/probes/substitution_complex.c). Version record: [SUBSTITUTION_COMPLEX_VERSION.txt](../src/probes/SUBSTITUTION_COMPLEX_VERSION.txt).

```text
COMPLEX ARITHMETIC PROBE VERSION 1.0
SHA-256: 026AA69530C711ACC856C62A21852ABC0F536D7784717C9EBDC48252BCA47F37
```

All inputs, intermediates, and results are `uint32_t`; arithmetic is modulo `2^32`. The functions are exported, noinline, straight-line, and contain no multiply/divide. `OBF_SUB` and `OBF_MBA` are empty unless a generated wrapper defines them. The canonical source contains no tool-specific implementation.

| Function | Source operations | Design | Expected result for x=`0x1337`, y=`0x12345678` |
| --- | ---: | --- | --- |
| `complex_constants` | 4 | XOR, ADD, SUB, XOR chain with memorable constants | `0x30166557` |
| `complex_variables` | 5 | `((x+y) & (x^y)) ^ (x-y)` | `0xFFFFFDB0` |
| `complex_mixed` | 6 | `((((x+y)^0x12345678)-0x1337)+(x^y))^0x22222222` | `0x301653CD` |
| `expression_tree` | 10 | `((x+0x1337)^(y-0x1111)) + (((x^y)&0x12345678) + ((x&0x22222222)|(y^0x11111111)))` | `0x278DEEBC` |

The tiny driver reads volatile canonical inputs, prints all four results, checks fixed independently computed answers, prints `COMPLEX ARITHMETIC PASS`, and exits 0. The [independent Python model](../scripts/deobfuscation/complex_arithmetic/model.py) explicitly wraps each operation; it does not call the C functions or Miasm.

MSVC, clean Clang, and GCC each passed ten predetermined input pairs: the canonical pair, zero/one cases, unsigned-wraparound and sign-boundary values, equal inputs, swapped canonical inputs, and memorable patterns. There are **120 clean C/model output comparisons**. Separate generated drivers rename the original main and call the unchanged semantic functions; these validation builds are not the obfuscated treatment PEs. Later, all 44 extracted machine expressions also matched the model on these ten pairs (440 diagnostic comparisons). These finite checks are not substituted for SMT proofs.

Freeze occurred only after clean runtime, noinline/structure, and clean machine-expression SMT checks passed. [freeze.json](../results/deobfuscation/complex_arithmetic_v1/preregistration/freeze.json) binds source, version file, model, protocol, and compiler identities. No post-freeze source edits occurred.

The original `showcase.c` remains at `39FEF0BB2A9742870F3D6F7CC864F7CFFA129136F6D2A59C4FB37F25906B99D2`; its version marker and the retained earlier PE/site artifacts are unchanged.

## 2. Build configurations and clean structure

The existing Visual Studio Community x64 developer environment was used. Required clean compilers were MSVC **19.51.36248**, Visual Studio Clang **22.1.3**, and MSYS2 UCRT64 GCC **16.2.0 Rev3**. Additional matched clean baselines used the existing OLLVM Clang 16.0.6, Hikari Clang 15.0.0, and Polaris Clang 16.0.6 binaries.

MSVC O0 uses `/Od /Ob0 /Zi /Oy- /FAsc`. LLVM lanes use `-m64 -O0 -g -gcodeview`; Hikari also uses `-Xclang -disable-O0-optnone`. GCC uses `-m64 -O0 -g -fno-inline`. No LTO is enabled. Windows link steps retain MAP/PDB where supported, disable incremental linking/ICF, and use reproducible-link flags. GCC retains DWARF and a GNU MAP, not a PDB.

All six clean compilers preserve separate callable exports. Every target has a retained direct call, no native branch, and no external call. LLVM IR retains exactly **4, 5, 6, 10** arithmetic/Boolean operations, respectively, with `noinline` attributes. Clean assembly still contains the meaningful arithmetic rather than precomputed answers. All 24 clean machine-expression/source queries were UNSAT.

Clean binaries, commands, LLVM IR, assembly, exact PE disassembly, hashes, symbols, vector drivers, and output are in [results/complex_arithmetic_v1/clean](../results/complex_arithmetic_v1/clean). Analysis records live separately under [results/deobfuscation/complex_arithmetic_v1](../results/deobfuscation/complex_arithmetic_v1).

| Treatment | Exact selection/pass settings beyond common O0 flags |
| --- | --- |
| OLLVM-16 SUB | `-mllvm -sub -mllvm -aesSeed=00112233445566778899AABBCCDDEEFF`; **global-pass build**, with `sub` annotations also present; annotation-only selection previously failed |
| Hikari SUB | `-mllvm -enable-subobf -mllvm -aesSeed=123456`; global enable plus `sub` annotations; `-disable-O0-optnone`; default `sub_prob=50`, default one loop |
| Polaris SUB | `OBF_SUB=__attribute__((annotate("substitution")))`; `-mllvm -passes=sub -mllvm -rng-seed=123456` |
| Polaris MBA | `OBF_MBA=__attribute__((annotate("linearmba")))`; `-mllvm -passes=mba -mllvm -rng-seed=123456` |
| Tigress EncodeArithmetic | Windows/MSVC environment, seed 424242, all four functions, builtin identities, max level 2, max transforms 2, repeat times 1; compile with MSVC `/Od /Ob0`, then optional `/Ox` |

For LLVM treatments, the pass runs once to emit retained IR; object and assembly generation both consume that exact IR with `-Xclang -disable-llvm-passes`. This is particularly important for nondeterministic Polaris MBA. The fixed binary/IR is the specimen; no claim of seed reproducibility is inferred or new repeat-build study attempted here.

Tigress's two optimization levels use the identical generated C, SHA-256 `CFCF7F4B1023F21C8CB5230D1A85E35652E27860EC16D85B327225E2200AF373`. No LLVM IR is claimed for the MSVC-generated machine lane; generated C is its transformation evidence.

All **12 treatment/baseline PEs** run successfully on the canonical inputs. Exact compiler paths, versions, hashes, commands, input-source hashes and artifact hashes are in [builds.json](../results/deobfuscation/complex_arithmetic_v1/summaries/builds.json).

Two harness/environment problems were corrected before producing their relevant artifacts: GCC needed its matching UCRT64 directory ahead of Strawberry Perl's C runtime directory on process PATH; Tigress's batch wrapper rejected unnecessarily quoted `--Environment=...` arguments. Failed-attempt logs were retained. Neither fix changed source semantics, toolchains, or packages.

### Actual SUB coverage

Hikari replaced **2/4, 2/5, 2/6, 6/10** original operations: **12/25 (48%)**. OLLVM replaced **25/25**. These counts use the retained original debug-tagged operators and their SSA reachability to stores/return, not merely the presence of extra instructions. Replacement instructions are untagged in these exact two implementations. Hikari advertises 50%; its source uses an inclusive probability comparison. Observed coverage is recorded rather than assuming every operation transformed.

## 3. Structural growth

Tuple order throughout this report: **constants, variables, mixed, tree**. IR counts exclude debug intrinsics/records but include retained dead original arithmetic instructions. Live-SSA arithmetic counts and operator histograms are recorded separately. Machine counts exclude alignment padding and are not semantic AST counts.

| Build | LLVM IR instructions | x64 instructions | Target bytes | Miasm return AST occurrences |
| --- | --- | --- | --- | --- |
| Clean LLVM lanes | 20, 28, 30, 27 | 17, 19, 22, 23 | 69, 71, 88, 89 | 7, 12, 12, 20 |
| Clean MSVC | N/A | 17, 29, 28, 27 | 67, 91, 98, 97 | 7, 12, 12, 20 |
| Clean GCC | N/A | 20, 23, 27, 29 | 64, 64, 81, 88 | 7, 12, 12, 20 |
| OLLVM SUB | 35, 51, 63, 83 | 33, 49, 61, 94 | 124, 166, 237, 331 | 29, 62, 65, 109 |
| Hikari SUB | 33, 42, 44, 60 | 31, 39, 41, 64 | 130, 134, 153, 237 | 15, 36, 22, 43 |
| Polaris SUB | 31, 49, 55, 68 | 26, 42, 50, 61 | 100, 137, 180, 230 | 31, 53, 77, 78 |
| Polaris MBA | 72, 94, 110, 158 | 81, 106, 122, 184 | 317, 385, 457, 727 | Not reached: state guard |
| Tigress O0 | N/A | 32, 54, 72, 53 | 130, 170, 243, 192 | 58, 70, 305, 39 |
| Tigress `/Ox` | N/A | 17, 25, 34, 24 | 66, 74, 119, 87 | 66, 54, 317, 31 |

Depths, operators, constants, variables, exact VA/RVA/end-exclusive ranges, and matched-baseline growth ratios are in [expression_metrics.json](../results/deobfuscation/complex_arithmetic_v1/summaries/expression_metrics.json) and [structural_metrics.json](../results/deobfuscation/complex_arithmetic_v1/summaries/structural_metrics.json).

Compiler lowering removes dead replacement remnants and folds constant operations. Miasm then propagates stack values and normalizes arithmetic before msynth sees it. For example, the clean constant chain's `+0x1337-0x1111` becomes `+0x226`; all clean compilers yield the same four normalized formulas. Thus the clean AST sizes are already normalized, not a count of raw lifted micro-operations. This study does not quantitatively separate every compiler contribution from every Miasm rewrite.

Optimization is **not uniformly helpful** here. Tigress `/Ox` reduces all machine instruction counts, but increases the constant-chain and mixed return AST sizes (58→66 and 305→317), while reducing variables/tree (70→54 and 39→31). It loses the proved SiMBA partial reductions seen at O0. This differs from the previous isolated-site optimization result.

## 4. Complete-function extraction and Polaris's limit

The project harness reuses Miasm PE loading, instruction semantics and retained PE boundary parsing. It does not translate assembly into hand-written formulas.

- Windows x64 inputs are the low 32 bits of RCX and RDX, independently symbolic `x` and `y`. Upper argument-register bits are also initially symbolic; their disappearance is checked, not assumed.
- RSP starts at `0x7FFF00001008`. Other registers and unread memory remain symbolic. Stack writes/loads are evaluated; no artificial operation cut points are inserted.
- Addresses are image VAs. `RUNTIME_FUNCTION` bounds are used where present. Leaf functions without unwind entries are bounded by contiguous branch/call-free decoding from the export through RET, not by a next-export approximation.
- Each decoded instruction's bytes are checked against the actual PE. Residual return-value memory, unrelated symbols, native branches/calls, stack imbalance, or damaged nonvolatile registers cause rejection.
- Limits are 20,000 AST occurrences per assigned state value and 60 seconds per extraction worker. Every successful extraction reached RET, preserved nonvolatile registers, and produced the expected stack increment.

**44/48 complete return expressions extracted:** all six clean baselines and all OLLVM/Hikari/Polaris SUB/Tigress cases. All 44 were invariant when the modeled stack was relocated by `0x20000000`.

Tigress inserts a write of 1 to a concrete `tigress_platform_fixes_init_state` global. The initial stack-only harness rejected it. A general correction permits writes to resolved writable PE sections, models them with Miasm, and records them. No instruction is skipped, no unknown global is concretized, and no external-memory dependency remains in the return. The eight initial rejection records are retained. Claims concern **arithmetic return values**, not equivalence of all global side effects; the transformed function is not strictly pure as a state transformer.

### Polaris MBA diagnostic

| Function | First guarded destination | AST occurrences | Unique DAG nodes |
| --- | --- | ---: | ---: |
| constants | `cf`, one bit | 23,567 | 100 |
| variables | `cf`, one bit | 23,058 | 173 |
| mixed | `cf`, one bit | 20,601 | 110 |
| tree | `cf`, one bit | 27,459 | 217 |

These are **intermediate carry-flag expressions**, not final return expressions. The full-state engine can expand flag semantics heavily even in branchless code. The same guard failures were reproduced without raising the limit; diagnostic ASTs, instructions and counts are retained in [guard_diagnostics.json](../results/deobfuscation/complex_arithmetic_v1/summaries/guard_diagnostics.json).

Conclusion: Polaris MBA is not tractable under this particular full-state occurrence-count guard, even for the four-operation chain. This is not a proof that its return-value DAG is intrinsically unmanageable, nor evidence that msynth rejected these four functions. A generic flag-liveness/DAG-aware extraction experiment would isolate that limitation, but was not substituted into the preregistered results.

## 5. Fixed deobfuscation protocol

The unchanged `.venvs/msynth` environment contains Python 3.11.4, msynth 1.0.0 at `661a5e3d7c0358950cf48b27ae422450c3064966`, Miasm 0.1.5 at `24a64bb30a181d60fe9572293c1b2fa597b2d0c9`, and Z3 5.1.0.0. The supplied SQLite oracle remains at SHA-256 `C4CAA8213BD19D06C621D1E72EC41195887BB459FF9F8170DC4C1BEBBFE26715`. No installation, upgrade, source patch, or new oracle generation occurred.

[protocol.json](../results/deobfuscation/complex_arithmetic_v1/preregistration/protocol.json) was saved before any new synthesis outcomes:

| Mode | Configuration |
| --- | --- |
| AST/oracle | `PipelineMode.AST`, supplied oracle, `enforce_equivalence=True`, internal solver 2 s, CEGIS and dead-variable elimination off; includes stock closing rewriter |
| SiMBA | Same settings, `PipelineMode.SIMBA`; algebraic simplification, not stochastic synthesis |
| Synthesizer | `Synthesizer(use_smir=True).synthesize_from_expression(expr, num_samples=50, timeout=10)`; random seed 0, `PYTHONHASHSEED=0` |

All methods receive the complete uncut return expression. Expected clean semantics are used only by the verifier/classifier, never as synthesis hints. No obfuscator identity selects rules. Workers run four at a time, each with a 90-second safety limit. Algorithm times are single-run wall measurements, not performance benchmarks; the synthesis API's ten seconds constrain search, while sampling/setup and SMT are additional.

Every returned candidate receives two independent 10-second, 32-bit bit-vector disequality checks: raw→candidate and candidate→expected. Both `x` and `y` remain symbolic for two-input functions. UNSAT proves equality; SAT gives a counterexample; UNKNOWN is not a proof.

Exact recovery requires canonical equality to the expected formula plus both proofs. Equivalent recovery requires both proofs and an AST no larger than the canonical clean formula. Partial requires both proofs and at least 20% reduction. Smaller reductions/growth are `NO SIMPLIFICATION`. Missing extraction, search-budget exhaustion, SMT UNKNOWN, and SMT counterexamples are retained separately. No equivalent-recovery cases occurred.

Occurrence-counted ASTs are not unique DAGs. Binary normalization can increase this metric even for an already-simple expression. The pinned Miasm pretty-printer incorrectly renders some binary `ExprOp('-', x, y)` nodes as unary negation. Candidate display text is therefore regenerated from the retained AST by a faithful renderer; original pretty text and authoritative `repr` remain available. Proofs used ASTs, never the ambiguous pretty strings.

## 6. Complete-expression results

| Obfuscated build | Extracted | AST exact/equivalent | SiMBA exact/equivalent | Synthesis exact/equivalent | AST partial / UNKNOWN | SiMBA partial / UNKNOWN |
| --- | ---: | ---: | ---: | ---: | --- | --- |
| OLLVM SUB | 4/4 | 0/4 | 0/4 | 0/4 | 2 / 0 | 2 / 0 |
| Hikari SUB | 4/4 | 0/4 | 0/4 | 0/4 | 0 / 0 | 0 / 0 |
| Polaris SUB | 4/4 | 0/4 | 0/4 | 0/4 | 2 / 0 | 3 / 0 |
| Polaris MBA | 0/4 | Not attempted | Not attempted | Not attempted | — | — |
| Tigress O0 | 4/4 | 0/4 | 0/4 | 0/4 | 1 / 1 | 2 / 2 |
| Tigress `/Ox` | 4/4 | 0/4 | 0/4 | 0/4 | 0 / 2 | 0 / 1 |

Across obfuscated cases, complete recovery is **0/20 successfully extracted expressions per mode**; four other intended targets were extraction failures. There are five proved AST partial reductions and seven SiMBA partial reductions (overlapping functions across modes).

Clean controls: AST and SiMBA preserve all **24/24 already-canonical formulas**, adding zero new recoveries. Synthesis fails **24/24 clean controls** as well as **20/20 extracted obfuscated cases**. The six compilers' clean expressions are identical per function, so those 24 controls are not 24 distinct semantic problems.

All 44 whole-expression synthesis calls finish without a zero-score solution within budget. Their best candidates have SAT counterexamples. They are rejected search outputs, **not accepted unsound simplifications**. Their shorter ASTs are not useful deobfuscation reductions. No extra per-family tuning, larger budget, or subtree synthesis was used to improve the scores.

Observed accepted oracle substitutions total 23 in AST mode and 7 in SiMBA mode, without complete obfuscated-function recovery. These counters indicate lookup activity, not a causal ablation; closing rewrites and SiMBA can contribute separately. Most remaining expressions retain masked Boolean forms, nested arithmetic/Boolean composition, or widened/shifted compiler forms. This experiment does not isolate any single feature as the cause of failure.

The largest proved SiMBA reduction is Tigress O0 `complex_mixed`, **305→79 nodes (74.10%)**; it remains much larger than the 12-node normalized source formula. Full per-function outputs, operator mixes and timings are in [simplification_results.json](../results/deobfuscation/complex_arithmetic_v1/summaries/simplification_results.json) and [family_results.json](../results/deobfuscation/complex_arithmetic_v1/summaries/family_results.json).

## 7. Preregistered repeated-site synthesis expansion

Selection rule: choose the lowest two site indices among previous **SiMBA non-recoveries**, excluding already-simple sites and previously synthesized XOR index 0. Thus XOR indices 1 and 2 test beyond the original successful example. Select all available failures when fewer than two exist; do not substitute successful sites. No BinProtect case was added.

| Family / operation | Selected indices | Attempted | Exact/equivalent recovered | Search timeout | Failed/unverified |
| --- | --- | ---: | ---: | ---: | ---: |
| OLLVM XOR | 1, 2 | 2 | 2 | 0 | 0 |
| OLLVM ADD | None available | 0 | 0 | 0 | 0 |
| OLLVM SUB | None available | 0 | 0 | 0 | 0 |
| Tigress XOR | 1, 2 | 2 | 2 | 0 | 0 |
| Tigress ADD | 1, 2 | 2 | 2 | 0 | 0 |
| Tigress SUB | None available | 0 | 0 | 0 | 0 |
| Polaris MBA XOR | 1, 2 | 2 | 2 | 0 | 0 |
| Polaris MBA ADD | 0, 1 | 2 | 1 | 0 | 1 SMT UNKNOWN |
| Polaris MBA SUB | 0, 1 | 2 | 1 | 0 | 1 SMT UNKNOWN |

All 12 searches produced zero-score, three-node candidates in approximately 0.08–0.17 s. **Only 10/12 (83.3%) count as recovery.** Polaris ADD 0 and SUB 1 have raw→candidate SMT timeouts; their candidate→expected checks are UNSAT. This is a proof limit, not a search timeout or a known semantic counterexample.

The same configuration therefore generalizes beyond the earlier single selected XORs and across XOR/ADD/SUB, but these are still isolated-operation successes. They must not be pooled into the new complete-expression recovery rate. Exact original PE hashes, expressions and choices are in [synthesis_expansion.json](../results/deobfuscation/complex_arithmetic_v1/summaries/synthesis_expansion.json).

## 8. Representative proved examples

### Complete two-variable function: partial recovery, not full recovery

Polaris SUB `complex_variables`, AST mode: **53→30 nodes**, raw/candidate and candidate/source both UNSAT. For compact display only, let `A=x+y`, `B=(x & ~y) | (y & ~x)`, and `D=x-y`; every value is 32-bit.

```text
BEFORE: (D & (~A | ~B)) | (~D & ~(~A | ~B))
AFTER:  (D & (~A | ~(x ^ y))) | ((y + ~x) & (A & (x ^ y)))
SOURCE: ((x+y) & (x^y)) ^ (x-y)
```

The abbreviations only render repeated subtrees; they were not supplied to msynth. Inner XOR reconstruction improves the expression, but the outer XOR expansion survives. This is not called recovery merely because it is equivalent or shorter.

### One-variable chain: proved partial reduction

Tigress O0 `complex_constants`, AST/SiMBA: **58→24 nodes**, both checks UNSAT. Let `T=x-((x|0xEDCBA987)<<1)+0xEDCBA986` for display:

```text
BEFORE: U = 2*(T | 0x1337) + (T ^ 0xFFFFECC8) + 0xFFFFEEF0
        -(U & 0x22222222) + (U | 0x22222222)
AFTER:  V = x-((x|0xEDCBA987)<<1)+0xEDCBABAC
        -(V & 0x22222222) + (V | 0x22222222)
SOURCE: (((x ^ 0x12345678) + 0x1337 - 0x1111) ^ 0x22222222)
```

The middle arithmetic is reduced, while two XOR encodings remain. The temporary names here are presentation abbreviations, not additional analysis cut points. Four additional SMT checks confirm these two examples' abbreviated before/after formulas match the retained ASTs; see [document_example_checks.json](../results/deobfuscation/complex_arithmetic_v1/summaries/document_example_checks.json).

### Earlier repeated-site specimen: full synthesis recovery

OLLVM XOR index 1, **9→3 nodes**, both checks UNSAT:

```text
BEFORE: (x & 0xEDCBA987) | ((x ^ 0xFFFFFFFF) & 0x12345678)
AFTER:  x ^ 0x12345678
```

Polaris MBA XOR index 1 similarly recovers **73→3 nodes**, ending at `x ^ 0x12345678`, with both checks UNSAT. Its input contains conditional sign-extension, 64-bit multiplication and low-32-bit slices; the exact AST is linked in the course evidence index rather than reproduced as a long expression here.

## 9. Complete soundness accounting

| Query set | UNSAT | UNKNOWN | SAT |
| --- | ---: | ---: | ---: |
| Extracted raw return → expected source | 42 | 2 | 0 |
| AST/SiMBA raw → candidate | 83 | 5 | 0 |
| AST/SiMBA candidate → expected | 86 | 2 | 0 |
| Recorded internal Simplifier checks | 45 | 0 | 0 |
| Whole-expression synthesis raw → best candidate | 0 | 0 | 44 |
| Whole-expression synthesis best candidate → expected | 0 | 0 | 44 |
| Repeated-site synthesis raw → candidate | 10 | 2 | 0 |
| Repeated-site synthesis candidate → expected | 12 | 0 | 0 |

The 88 SAT results above concern nonzero-score failed-search candidates only. No candidate claimed by a Simplifier or zero-score Synthesizer result has a detected counterexample. The intentional wrong-addition negative control also returned SAT; the modulo-wraparound positive control returned UNSAT. These controls are outside the table.

There are six AST/SiMBA rows with at least one direct proof UNKNOWN: Tigress O0 variables (both modes), Tigress O0 tree (SiMBA), Tigress `/Ox` variables (both modes), and Tigress `/Ox` mixed (AST). Raw/source timeouts occur for Tigress O0 variables and tree. These remain explicit under the fixed direct-query protocol; no random testing or larger post-hoc solver budget upgrades the rates.

Every soundness result and counterexample is retained. See [smt_overview.json](../results/deobfuscation/complex_arithmetic_v1/summaries/smt_overview.json) and [evidence_audit.json](../results/deobfuscation/complex_arithmetic_v1/summaries/evidence_audit.json).

## 10. Interpretation and course examples

1. **Composed chains:** the stock configurations partially simplify complete interacting functions but do not fully recover this new set. Positive isolated-site results do not automatically compose.
2. **Variable-variable versus variable-constant:** both extract correctly; both fail complete synthesis under this budget. Two-variable functions yield useful partial reductions, but operation counts/shapes differ, so this is not a controlled causal test of variable count alone. No universal harder/easier claim is justified.
3. **Growth:** semantic AST growth can diverge sharply from machine-code size. Tigress `/Ox` demonstrates this directly. Polaris's guard is dominated by repeated flag-expression occurrences, not a measured final-return size.
4. **Synthesis versus fixed simplification:** synthesis is strong on the bounded repeated-site expansion but worse on complete functions here. It was invoked on the whole expression, not recursively on selected subexpressions. AST/SiMBA reduce subexpressions within the complete expression; no method recovered the whole obfuscated function.
5. **Genericity:** the strongest positive evidence is 10 SMT-proved repeated-site recoveries across unrelated implementations and operators with one configuration. The strongest negative control is synthesis failing even the clean composed formulas. Neither outcome is a universal claim about all possible budgets, grammars, extraction policies, or solvers.

Four course-facing examples are selected in [COURSE_EXAMPLES.md](../results/deobfuscation/complex_arithmetic_v1/COURSE_EXAMPLES.md): Tigress constants (partial chain), Polaris SUB variables (two symbolic inputs), Tigress mixed (large proved partial reduction), and Polaris MBA repeated-site XOR (full synthesis recovery, explicitly from the earlier dataset). Each links the source/IR or generated C, exact x64, Miasm AST, candidate, and proof. Polaris's carry-flag guard is an additional negative example, not a fabricated successful pipeline.

**Recommendation:** arithmetic is now sufficiently characterized for an initial course/research baseline to move to a separately authorized flattening study. Do not claim generic whole-expression synthesis is solved. Keep a narrowly scoped, generic flag-liveness/DAG-aware extraction follow-up on the arithmetic backlog; the evidence does not justify replacing Miasm wholesale with Triton or extending budgets selectively until results look successful.

This experiment stops here. No flattening analysis was started.

## Reproduction and evidence layout

Project scripts: [scripts/deobfuscation/complex_arithmetic](../scripts/deobfuscation/complex_arithmetic). Original registration, model, and freeze are preserved; do not overwrite them after outcomes are known. Build/evaluation scripts resume retained results and verify frozen hashes.

```powershell
$py = '.\.venvs\msynth\Scripts\python.exe'
$taskScripts = '.\scripts\deobfuscation\complex_arithmetic'
# First construction only, before outcomes: preregister.py, build.py clean,
# extract_complex.py --clean, and freeze.py after the version file is approved.
& $py -B "$taskScripts\build.py" obfuscated
& $py -B "$taskScripts\extract_complex.py"
& $py -B "$taskScripts\structure.py"
& $py -B "$taskScripts\evaluate_complex.py" --stage core
& $py -B "$taskScripts\evaluate_complex.py" --stage expansion
& $py -B "$taskScripts\guard_diagnostics.py"
& $py -B "$taskScripts\render_expressions.py"
& $py -B "$taskScripts\evaluate_complex.py" --summarize
& $py -B "$taskScripts\summarize.py"
& $py -B "$taskScripts\audit_complex.py"
```

Required machine-readable tables, each in CSV and JSON: `builds`, `expression_metrics`, `simplification_results`, and `synthesis_expansion`. Supplementary tables contain structural metrics, method/family aggregates, expansion availability, guard diagnostics, and soundness accounting. Each case retains exact commands, stdout/stderr, hashes, boundaries, AST representations, candidate scores, timings, and SMT outcomes. Fresh experiments should use a new preserved results version rather than overwrite this one.
