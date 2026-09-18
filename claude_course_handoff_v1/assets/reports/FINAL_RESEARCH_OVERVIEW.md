# Final research overview

Curated 2026-09-18. This synthesis records what the completed experiments demonstrate, where the evidence stops, and which exact artifacts best communicate it. It is not a 12-week course design. Start with [RESEARCH_SUMMARY](RESEARCH_SUMMARY.md), then [IDA_WALKTHROUGH](IDA_WALKTHROUGH.md).

## 1. Research objective

The objective was to study how obfuscation changes recognizable program semantics and representations, how compiler optimization changes those effects, and whether deobfuscation can recover expressions, control flow or working executables. The central unit is a named target function with a compatible clean baseline, not an unlabeled executable-size comparison. Correctness, analysis coverage and output usability are separate outcomes.

## 2. Corpus design

The canonical C showcase separates arithmetic, bogus-control-flow, flattening, calls, data and combined behavior. It uses memorable constants, runtime-visible inputs, exported non-inlined functions and built-in canonical checks. Tool-specific wrappers/transformed C avoid contaminating canonical semantics. Primary O0 treatments and an optimization-survival matrix retain compiler identities, commands, source hashes, IR/assembly and PE artifacts. Separate complex-arithmetic probes test whether local expression results generalize.

The compact manual pack shares OLLVM, Polaris and MSVC clean O0 binaries and retains only nine transformed originals and four rewrites. Exact generated Tigress C is copied. Additional Hikari/BinProtect outcomes remain indexed without duplicating entire trees. Whole-executable effects are not target-only when global passes touch other functions or runtime code. See [showcase_validation](reference/research_docs/showcase_validation.md) and [showcase_matrix_v1](reference/research_docs/showcase_matrix_v1.md).

## 3. Obfuscators tested

OLLVM-16, Hikari and Polaris provide related but non-identical LLVM IR techniques. Targeting differs: annotation-only SUB pilots compiled without transforming the target in both tested OLLVM-16 and Hikari compilers. The retained matrices therefore use global switches, not validated function-local isolation. Hikari uses `-enable-subobf`, `-enable-bcfobf`, `-enable-cffobf`, and `-enable-splitobf` (each passed via `-mllvm`). Target-function measurements remain isolated, but other eligible functions may also be transformed. Polaris needs pipeline selection plus annotations. Polaris global encryption and backend-obfu have different scope. Tigress transforms C before an environment-matched native compiler. BinProtect mutates a linked PE and discovered runtime functions as well as application functions.

The Polaris X86 MIR path worked in the individual smoke study and materially changed native code without a corresponding IR CFG transformation. It is not part of the six core stories or an IR-pass comparison. Alias/merge/ccc and virtualization are not promoted into validated capabilities. The [obfuscator table](tables/obfuscators.md) preserves these boundaries.

## 4. Effect of compiler optimization

Classic substitution demonstrates the gap between IR complexity and native code. OLLVM transforms all 24 intended O0 arithmetic sites, but native selection recovers recognizable XOR/SUB operations; higher optimization recovers all 24 native target operations. Hikari begins with partial probabilistic coverage and loses the measured SUB effect by O1. Polaris SUB is less persistent than its separate linear-MBA treatment.

Hikari and Polaris BCF targets become clean-equivalent by O1; OLLVM retains a small optimized residue. OLLVM/Hikari flattening remains pronounced. Polaris flattening shrinks but retains dispatch. Tigress Flatten changes between indirect jump tables and direct comparison networks according to compiler optimization. Tigress arithmetic uses the same generated C at every level and remains substantial at /Ox. These findings are bounded by the tested source, compiler and flags, not universal optimizer laws. See [optimization survival](tables/optimization_survival.md).

## 5. Arithmetic deobfuscation

The msynth study separates AST/oracle simplification, algebraic SiMBA and a distinct stochastic Synthesizer. Some native expressions were already canonical before the tool ran; these must not be credited as newly recovered semantics. Local synthesis transferred across selected OLLVM, Tigress and Polaris expressions; the expanded preregistered repeated-site set proved 10/12, with two Polaris ADD/SUB cases UNKNOWN rather than accepted.

Whole-function complexity changes the result: 44/48 return expressions were extracted in the complex study, while four Polaris MBA cases hit the Miasm flag-AST size guard. Neither AST/oracle nor SiMBA completely recovered any of the 20 extracted obfuscated complex return expressions; partial reductions still occurred. Stochastic whole-function candidates were not accepted when SMT found counterexamples. Local proof is not whole-function proof. None of these msynth workflows produced a rewritten PE. See [msynth_validation](reference/research_docs/msynth_validation.md) and [complex_arithmetic_deobfuscation](reference/research_docs/complex_arithmetic_deobfuscation.md).

Story 1 is the classic SUB/canonicalization example; story 2 supplies the strongest validated LLVM-family arithmetic expansion; optional story 7 shows source-stage arithmetic and optimizer survival.

## 6. Flattening deobfuscation

The stock Miasm-based unflattener recovered 25/25 OLLVM O0 and 28/28 Hikari O0 semantic successor pairs and produced working canonical PEs. The pair oracle comes from retained source/IR regions, not raw graph-edge identity; it does not by itself prove branch polarity. The rewritten OLLVM graph has 17 blocks versus the compiler-clean 21, illustrating why graph identity is not required for preserved semantics.

Transfer is limited. Polaris emits a structurally valid but semantically wrong rewrite: the legitimate four-way switch is collapsed into sequential case operations. Tigress fails earlier: stock discovery sees six blocks where the verified jump-table-aware reference has 38. It never reaches successful successor analysis. Hikari O2 also fails before useful recovery; O0 success does not imply layout/optimization independence. See stories 5, 6 and 8 and [unflattening_course_examples](reference/research_docs/unflattening_course_examples.md).

## 7. Opaque-predicate analysis and rewriting

Generic Triton DSE/SMT with symbolic writable globals proved all 22 OLLVM and 16 Polaris O0 injected gates, while genuine branch controls stayed two-sided. A separate project-local proof consumer checked source bytes/hashes and replaced each six-byte JNE with JMP plus NOP. No solver reruns were needed during that rewrite study.

Retained canonical and differential execution checks passed: 4591 OLLVM plus 4598 Polaris triples, zero mismatches. The dedicated PE-byte CFG audit shows reachable blocks shrink 70→37 and 54→30. Physical code remains; predicate arithmetic and unreachable clone/stub bytes were not deleted. The output is a working partial deobfuscation, not a fully clean binary.

Tigress AddOpaque required a captured initialized-state model for its 3/3 proofs; arbitrary symbolic entry globals yielded 0/3. BinProtect static predicates included two-sided cases and timeouts, and its invalid PEs do not support runtime transfer claims. See [opaque_predicate_triton](reference/research_docs/opaque_predicate_triton.md) and [opaque_predicate_rewrite](reference/research_docs/opaque_predicate_rewrite.md).

## 8. Whole-function lifting

Mergen at retained commit 71fc60766d3d74bd38693c1503087a074aa70a66 lifted 17 selected cases. Four stage variants per case yielded 68 valid, recompilable LLVM modules. R is the raw lift but already performs folding; R2 adds ordinary LLVM O2; M includes Mergen custom/internal optimization; M2 adds another ordinary O2. These are controlled comparisons, not a claim that every operation in M is ordinary LLVM.

Thirteen cases had passing runtime outcomes under their documented contracts. OLLVM SUB was the semantic failure; two OLLVM BCF cases were not executed as lifts because unknown helper calls/memory lacked a safe contract; BinProtect remained static-only. Polaris MBA passes 4118 vectors at each stage but retains 359 IR instructions in M2. OLLVM FLA's stock rewrite lifts without a dispatcher, while the original retains one.

For OLLVM SUB, all four stages miscompute 3917/4118 inputs. The native PE itself passes. The error is already present in the raw lift's unsound mask-to-select folding, so ordinary LLVM optimization cannot be blamed for introducing or expected to repair it. For Polaris BCF, original and patched inputs both simplify under Mergen's concrete-global assumptions; equivalent normalized structures are not byte-identical files and do not isolate a benefit from the earlier Triton patch. See [mergen_validation](reference/research_docs/mergen_validation.md).

## 9. What generalized

The strongest tested transfer is semantic opaque-edge proof plus a separate layout-preserving patch consumer across OLLVM and Polaris. Selected local arithmetic recovery also crosses implementation boundaries. Stock unflattening transfers from OLLVM to Hikari O0 where dispatcher/state assumptions align. Mergen's representation can lift Polaris MBA that exceeded a different extractor's guard. Each conclusion depends on explicit inputs, bounds, globals and validation, not merely shared technique names.

## 10. What did not generalize

A fixed seed does not universally reconstruct generated artifacts. Local arithmetic recovery does not imply whole-function normalization. O0 unflattening does not imply O2 compatibility. A mathematical opaque identity may fail under machine-width overflow. A runtime-initialized global invariant does not hold for arbitrary entry-state globals. An indirect-dispatch discovery failure is not a solver failure. Valid LLVM IR or a valid PE header is not proof of preserved semantics.

All eight retained BinProtect outputs crash or hang; arithmetic/CFG observations on them are static only. This pack intentionally omits their binaries while preserving the distinction in the tables. No evidence here establishes robust virtualization deobfuscation or broad production-program generality.

## 11. Correctness failures and why they matter

Two negative examples should stay central. Polaris FLA shrinks from 56 to 10 blocks but returns F9CD8332 instead of DBEFFCE7, exiting 1. Mergen OLLVM SUB produces syntactically valid, compilable IR whose x=0 result is 0 instead of 0x08083808. Neither should be counted as success because the representation looks simpler.

Rewritten metadata adds another pitfall. Original RSDS identifiers survive patching, so a PDB may appear to match while its instruction mappings are stale. Whole-function FLA rewriting also changes internal addresses without establishing exhaustive unwind correctness. Use exports/RVAs, decline old PDBs, and distinguish ordinary test execution from exception/unwind guarantees. No incorrect binary is marked safe to execute in the manifest.

## 12. Recommended evidence for later course design

The six core stories form complementary evidence: classic SUB, extreme MBA, OLLVM end-to-end BCF, Polaris BCF transfer, successful OLLVM FLA and incorrect Polaris FLA. Optional Tigress stories show source-stage optimization and CFG discovery limits. [Best examples](tables/best_course_examples.md) assigns broad topics only; [selected metrics](tables/selected_metrics.md) defines each count and exact provenance.

Use original versus clean, then rewritten versus original, rather than treating every smaller graph as cleaner semantics. Keep runtime outputs/proofs adjacent to visuals. The [manifest](MANIFEST.json) verifies copies, and the [walkthrough](IDA_WALKTHROUGH.md) provides manual entry points. The pack is sufficient to begin designing the course; no final sequence, assessment scheme or site has been created.

## 13. Open / future-work questions

Future work could examine seed-controlled diversity, fix and revalidate the Mergen folding issue, recover indirect jump tables robustly, preserve legitimate switch semantics during unflattening, and establish stronger rewrite metadata/unwind guarantees. Further studies could expand input/state coverage and compare expression normal forms without confusing extraction cost with solver power. BinProtect would need valid protected outputs before runtime claims could be made.

These are research questions, not tasks started here. Existing evidence remains frozen and authoritative. Any later experiment should have its own protocol, independent correctness checks and new output directory.
