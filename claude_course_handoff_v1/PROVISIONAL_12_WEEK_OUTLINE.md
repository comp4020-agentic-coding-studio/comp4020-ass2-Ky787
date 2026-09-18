# Provisional 12-week outline

This is a research-backed starting structure, not a pedagogically finalized syllabus. Contact hours, pacing, institutional requirements, tool access and assessment weights remain open. The site builder may improve the sequence while preserving findings and their qualifications. References below are package-relative; see [HANDS_ON_LABS](HANDS_ON_LABS.md) for exact specimen pairs and [CLAIMS_AND_CAVEATS](CLAIMS_AND_CAVEATS.md) before turning an observation into a claim.

Each week groups its material into 2–4 subtopics. Screenshots are illustrative, not correctness evidence. Where a suitable screenshot is absent, use the supplied text/SVG evidence instead of inventing one.

## Week 1 — From C to machine code

- **Objective:** Follow the same computation across representations and distinguish source meaning from compiler-generated structure.
- **Subtopics:** (1) C and the compiler frontend; (2) LLVM IR and the optimizer; (3) backend lowering and x64 assembly; (4) why representation and measurement boundaries matter.
- **Best evidence:** [Frozen showcase C](assets/source/showcase.c), paired with [clean target IR](assets/ir/baselines/ollvm16/demo_substitution.ll) and [clean disassembly](assets/evidence/baselines/ollvm16/demo_substitution_disassembly.txt).
- **Best table:** [Transformation layers](assets/tables/lecture/svg/01_transformation_layers.svg).
- **Best screenshot:** [Story 1 close-up](assets/ida/demo_substitution1_2.jpg), using only the clean left pane initially; the right pane introduces a later treatment.
- **Activity:** Trace one unsigned operation and `0x12345678` from C to IR to assembly; explain one change in spelling that preserves meaning (Lab 1).
- **Prerequisites:** Incoming C, unsigned arithmetic, functions, branches/loops and elementary assembly knowledge; no previous course week.

## Week 2 — What is obfuscation?

- **Objective:** Classify a transformation by where it acts and identify what evidence would demonstrate its effect.
- **Subtopics:** (1) Source, IR, backend and binary transformation layers; (2) OLLVM-16, Hikari, Polaris, Tigress and BinProtect as tested implementations; (3) goals, structural complexity and semantic preservation; (4) controlled comparisons, targeting and tool/version scope.
- **Best evidence:** [Corrected obfuscator comparison](assets/tables/research/obfuscators.md), with [build inventory](assets/evidence/matrix/compiler_inventory.json) and [BinProtect limitation](assets/reports/binprotect_validation.md).
- **Best table:** [Obfuscator snapshot](assets/tables/lecture/svg/02_obfuscator_snapshot.svg).
- **Best screenshot:** [Polaris MBA overview](assets/ida/demo_substitution2_1.jpg), solely to illustrate visible expansion—not to rank protection strength.
- **Activity:** Classify the five tool lanes by representation, inputs, outputs and validation status; explain why BinProtect is not a runnable lab lane.
- **Prerequisites:** Week 1's representation pipeline.

## Week 3 — Instruction substitution

- **Objective:** Separate substitution coverage, template diversity and survival into native code.
- **Subtopics:** (1) Classic OLLVM SUB identities; (2) repeated static sites and fixed/random template choices; (3) clean versus obfuscated IR/assembly; (4) compiler/backend canonicalization.
- **Best evidence:** [OLLVM SUB target IR](assets/ir/s01_ollvm_sub/target_function.ll) and [native disassembly](assets/evidence/s01_ollvm_sub/demo_substitution_disassembly.txt), interpreted through the [arithmetic report](assets/reports/msynth_validation.md).
- **Best table:** [Arithmetic versus optimization](assets/tables/lecture/svg/03_arithmetic_optimization.svg).
- **Best screenshot:** [Clean versus OLLVM SUB close-up](assets/ida/demo_substitution1_2.jpg).
- **Activity:** Compare a selected ADD and XOR across the clean/SUB pair; mark the 24 intended static sites separately from setup/reduction operations (Lab 1).
- **Prerequisites:** Weeks 1–2; modular unsigned arithmetic and bitwise operations.

## Week 4 — MBA and semantic simplification

- **Objective:** Evaluate a simplification claim under a stated bit width, expression boundary and equivalence obligation.
- **Subtopics:** (1) Polaris MBA and Tigress EncodeArithmetic; (2) Miasm lifting, msynth and SiMBA; (3) synthesis candidates and SMT equivalence checks; (4) isolated sites versus composed expressions and partial recovery.
- **Best evidence:** [Complex arithmetic findings](assets/reports/complex_arithmetic_deobfuscation.md), [isolated synthesis results](assets/evidence/complex_arithmetic_v1_summaries/synthesis_expansion.json) and [composed-expression source](assets/source/substitution_complex.c).
- **Best table:** [Deobfuscation outputs](assets/tables/lecture/svg/06_deobfuscation_outputs.svg).
- **Best screenshot:** [Polaris MBA assembly close-up](assets/ida/demo_substitution2_2.jpg). No confirmed arithmetic-target Tigress screenshot was supplied.
- **Activity:** Inspect MBA operators and compare an accepted isolated recovery with UNKNOWN and incomplete composed-expression outcomes; state exactly what was proved (Lab 2).
- **Prerequisites:** Week 3; Boolean identities and bit-vector arithmetic. Introduce the required SAT/UNSAT vocabulary here, before Week 7's deeper treatment.

## Week 5 — Optimization versus obfuscation

- **Objective:** Treat optimization level as part of the experiment, using matched controls and comparable metrics.
- **Subtopics:** (1) O0/O1/O2/O3 matrix design and Tigress's MSVC /Ox lane; (2) SUB simplification and BCF disappearance; (3) FLA survival; (4) IR survival versus machine-code survival and measurement boundaries.
- **Best evidence:** [Optimization report](assets/reports/optimization_survival.md), plus [Tigress O0 disassembly](assets/evidence/s06_tigress_arithmetic/demo_substitution_O0_disassembly.txt) versus [/Ox disassembly](assets/evidence/s06_tigress_arithmetic/demo_substitution_Ox_disassembly.txt) from the same generated C.
- **Best table:** [Arithmetic optimization](assets/tables/lecture/svg/03_arithmetic_optimization.svg); use [opaque](assets/tables/lecture/svg/04_opaque_optimization.svg) and [flattening](assets/tables/lecture/svg/05_flattening_optimization.svg) tables only when those questions arise.
- **Best screenshot:** None with a confirmed matched optimization-level arithmetic pair. The story-6 filename shows `demo_flattening`, not `demo_substitution`; use the disassembly pair above.
- **Activity:** Compare Tigress's 426 O0 versus 226 /Ox target instructions against the correct clean controls; explain why neither counts nor compiler flag names alone establish a fair cross-tool ranking (Lab 3).
- **Prerequisites:** Weeks 1–4; revisit BCF/FLA at an overview level before their detailed weeks.

## Week 6 — Bogus control flow and opaque predicates

- **Objective:** Distinguish genuine program decisions from injected opaque gates and cloned structure.
- **Subtopics:** (1) Classic BCF, cloned blocks and opaque conditions; (2) genuine versus injected branches; (3) OLLVM, Hikari, Polaris and Tigress differences; (4) provenance and optimization-dependent gate survival.
- **Best evidence:** [Triton study's branch classification](assets/reports/opaque_predicate_triton.md) with [family results](assets/evidence/triton_summaries/family_results.json) and [OLLVM BCF CFG](assets/cfg/s03_ollvm_bcf/original_entry_reachable.svg).
- **Best table:** [Opaque predicates versus optimization](assets/tables/lecture/svg/04_opaque_optimization.svg).
- **Best screenshot:** [OLLVM clean versus BCF close-up](assets/ida/demo_bogus_control3_flow_clean_to_bcf_2.jpg).
- **Activity:** Match genuine source comparisons to assembly and contrast one injected gate; explain why Hikari's surviving genuine Jccs cannot count as injected-gate proof successes.
- **Prerequisites:** Weeks 1–3 and 5; basic CFG reading.

## Week 7 — Symbolic execution and SMT

- **Objective:** Interpret a branch proof relative to path prefixes, symbolic inputs and modeled runtime state.
- **Subtopics:** (1) Triton, symbolic/concolic execution and inputs; (2) path predicates, SAT, UNSAT and UNKNOWN; (3) path-relative implications and coverage; (4) Tigress initialization and runtime-state assumptions.
- **Best evidence:** [One frozen OLLVM gate proof](assets/evidence/s03_ollvm_bcf/first_gate_proof/result.json) and [its queries](assets/evidence/s03_ollvm_bcf/first_gate_proof/false.smt2), contrasted with [Tigress initialized state](assets/evidence/support_tigress_opaque/o0_initialized/initialized_state.json).
- **Best table:** [BCF proof to patch](assets/tables/lecture/svg/08_bcf_proof_to_patch.svg), focusing on the proof stage before introducing rewriting.
- **Best screenshot:** [OLLVM branch close-up](assets/ida/demo_bogus_control3_flow_bcf_to_rewritten_2.jpg) is native context only; no screenshot of the solver proof is supplied.
- **Activity:** Interpret `P ∧ C` and `P ∧ ¬C`, then explain Tigress's 0/3 generic versus 3/3 initialized yield without generalizing to arbitrary globals (Lab 4).
- **Prerequisites:** Weeks 4 and 6; Boolean logic and bit-vector semantics.

## Week 8 — From proof to a working binary

- **Objective:** Separate proof consumption, byte rewriting, reachable-CFG change and runtime validation.
- **Subtopics:** (1) Frozen Triton proofs and a separate patch consumer; (2) Jcc → JMP + NOP in OLLVM/Polaris; (3) reachable edges versus physically retained dead code; (4) runtime contracts and stale PDB internals.
- **Best evidence:** [OLLVM patch manifest](assets/evidence/s03_ollvm_bcf/patch_manifest.json), [validation](assets/evidence/s03_ollvm_bcf/validation.json) and [rewritten all-static CFG](assets/cfg/s03_ollvm_bcf/rewritten_all_static.svg).
- **Best table:** [BCF proof to patch](assets/tables/lecture/svg/08_bcf_proof_to_patch.svg).
- **Best screenshot:** [OLLVM BCF versus rewrite close-up](assets/ida/demo_bogus_control3_flow_bcf_to_rewritten_2.jpg); [Polaris equivalent](assets/ida/demo_bogus_control_flow7_polaris_bcf_to_rewritten_2.jpg) supports transfer comparison.
- **Activity:** Explain the six-byte patch at OLLVM RVA `0x1667`, verify its destination arithmetically, and reconcile reduced reachable blocks with unchanged physical bytes (Lab 5). No new patching required.
- **Prerequisites:** Weeks 6–7; x64 relative branches and RVA/base distinction.

## Week 9 — Control-flow flattening

- **Objective:** Identify the dispatcher/state mechanism and distinguish it from the program's semantic blocks.
- **Subtopics:** (1) Dispatcher and state variable; (2) semantic blocks and successor transitions; (3) OLLVM/Hikari/Polaris/Tigress layouts; (4) clean versus flattened CFGs and indirect dispatch.
- **Best evidence:** [OLLVM flattened IR](assets/ir/s04_ollvm_fla/before_target.ll) and [before CFG](assets/cfg/s04_ollvm_fla/before_cfg.svg), with [Tigress complete reference CFG](assets/cfg/s08_tigress_flatten/reference_complete_cfg.svg) for a different dispatcher.
- **Best table:** [Flattening versus optimization](assets/tables/lecture/svg/05_flattening_optimization.svg).
- **Best screenshot:** [Clean versus OLLVM FLA](assets/ida/demo_flattening4_clean_to_ollvm_fla_1.jpg); [Tigress detail](assets/ida/demo_flattening8_1.jpg) for the jump-table variant.
- **Activity:** Follow one state transition and one source conditional through the dispatcher without trying to reconstruct every block (first part of Lab 6).
- **Prerequisites:** Weeks 1–3, 5–6; CFGs, switches and loops.

## Week 10 — Unflattening and hidden assumptions

- **Objective:** Diagnose where a recovery workflow succeeds or fails, and reject a structurally attractive incorrect result.
- **Subtopics:** (1) ollvm-unflattener and Miasm symbolic successor recovery; (2) OLLVM success and Hikari O0 transfer; (3) Polaris incorrect rewrite and Tigress discovery failure; (4) SSA/RPISEC methodology and hidden representation assumptions.
- **Best evidence:** [Paired unflattening examples](assets/reports/unflattening_course_examples.md), [Polaris WRONG result](assets/evidence/s05_polaris_fla_wrong/stock_result.json) and [Tigress discovery result](assets/evidence/s08_tigress_flatten/stock_result.json).
- **Best table:** [Unflattening outcomes](assets/tables/lecture/svg/09_unflattening_outcomes.svg).
- **Best screenshot:** [Polaris original versus WRONG rewrite](assets/ida/demo_flattening5_polaris_to_rewritten_1.jpg), contrasted with [successful OLLVM rewrite](assets/ida/demo_flattening4_ollvm_to_rewritten_fla_1.jpg). Do not use the held Polaris clean-to-rewrite filename.
- **Activity:** Choose from Labs 6–8: validate a recovered successor story, find sequentialized switch cases in the wrong result, or explain incomplete jump-table discovery. RPISEC is a source-inspected alternative, not a reproduced success.
- **Prerequisites:** Weeks 7–9; introduce SSA def/use as needed.

## Week 11 — Lifting machine code back to LLVM IR

- **Objective:** Distinguish a valid lifted representation from a semantically trustworthy lift and from a rewritten original PE.
- **Subtopics:** (1) Mergen whole-function symbolic lifting; (2) LLVM optimization along `R→R2` and `R→M→M2`; (3) Polaris MBA and FLA before/after unflattening; (4) OLLVM SUB's silent mislift and semantic checking.
- **Best evidence:** [Mergen report](assets/reports/mergen_validation.md), [passing Polaris semantic record](assets/evidence/s02_polaris_mba/mergen/semantic_result.json) and [failing OLLVM SUB record](assets/evidence/s01_ollvm_sub/mergen/semantic_result.json).
- **Best table:** [Deobfuscation outputs](assets/tables/lecture/svg/06_deobfuscation_outputs.svg), paired selectively with [correctness traps](assets/tables/lecture/svg/10_correctness_traps.svg).
- **Best screenshot:** No Mergen IR screenshot supplied. [Polaris native MBA close-up](assets/ida/demo_substitution2_2.jpg) can establish the input; the output evidence is [actual M2 LLVM text](assets/ir/s02_polaris_mba/mergen/internal_O2.ll).
- **Activity:** Contrast verifier success, residual complexity and recorded mismatches; explain why an error present in raw lifted IR is not introduced by subsequent O2 (Lab 9).
- **Prerequisites:** Weeks 1, 4–5 and 7–10; LLVM representation and runtime validation boundaries.

## Week 12 — How generic can deobfuscation be?

- **Objective:** Choose and justify analysis methods using representation assumptions and correctness evidence rather than vendor labels or graph appearance.
- **Subtopics:** (1) Expression simplification, CFG recovery and branch proof; (2) binary rewriting versus lifting and their output contracts; (3) genericity, assumptions and correctness; (4) future work, with virtualization/devirtualization only as a brief unmeasured endpoint.
- **Best evidence:** [End-to-end outcomes](assets/tables/research/end_to_end_results.md), [claims guide](CLAIMS_AND_CAVEATS.md) and [corrected research overview](assets/reports/FINAL_RESEARCH_OVERVIEW.md).
- **Best table:** [End-to-end results](assets/tables/lecture/svg/07_end_to_end_results.svg).
- **Best screenshot:** Revisit [Polaris's WRONG smaller CFG](assets/ida/demo_flattening5_polaris_to_rewritten_1.jpg) alongside the [working OLLVM rewrite](assets/ida/demo_flattening4_ollvm_to_rewritten_fla_1.jpg); neither image alone establishes its verdict.
- **Activity:** Produce a short evidence audit or proposed capstone protocol: select methods, list assumptions, identify required correctness checks and state what remains unknown. See [ASSESSMENT_IDEAS](ASSESSMENT_IDEAS.md); do not invent a new measured virtualization result.
- **Prerequisites:** Weeks 1–11; synthesize rather than introduce a new toolchain requirement.

## Open teaching decisions

The course owner and future site builder should settle the weekly workload, depth of SMT/SSA formalism, institutional assessment rules, Windows VM availability and accessibility requirements. Core proposed exercises can be completed by reading supplied text and visuals on Linux. Optional execution is limited to the Windows x64 samples marked suitable in [BINARY_GUIDE](BINARY_GUIDE.md); no experiment was rerun to create this outline.
