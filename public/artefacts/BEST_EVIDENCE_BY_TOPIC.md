# Best evidence by topic

Paths below are relative to this package and work after copying it to Linux. All binaries are Windows x64 PE, not Linux ELF. Runtime status is inherited, not rerun. See [BINARY_INDEX.json](BINARY_INDEX.json) for exact hashes/exports and [CLAIMS_AND_CAVEATS.md](CLAIMS_AND_CAVEATS.md) for claim boundaries. “None” is deliberate: do not invent missing outputs.

## Compiler pipeline / representation

Weeks: 1–2.

- Binary: [ollvm16_clean_O0.exe](assets/binaries/baselines/ollvm16/ollvm16_clean_O0.exe).
- Matched clean comparator: Not available / not applicable.
- Rewritten / other comparator: Not available / not applicable.
- LLVM IR / generated C: [demo_substitution.ll](assets/ir/baselines/ollvm16/demo_substitution.ll).
- CFG SVG: [clean_cfg.svg](assets/cfg/s04_ollvm_fla/clean_cfg.svg).
- IDA/Diaphora screenshot: [demo_substitution1_2.jpg](assets/ida/demo_substitution1_2.jpg).
- Lecture table: [01_transformation_layers.svg](assets/tables/lecture/svg/01_transformation_layers.svg).
- Detailed report: [showcase_matrix_v1.md](assets/reports/showcase_matrix_v1.md).
- Qualification: Use the clean left pane; image includes a later SUB treatment. Native disassembly is also bundled. No new compilation required.

## OLLVM SUB

Weeks: 3, 5.

- Binary: [ollvm16_sub_O0.exe](assets/binaries/s01_ollvm_sub/original/ollvm16_sub_O0.exe).
- Matched clean comparator: [ollvm16_clean_O0.exe](assets/binaries/baselines/ollvm16/ollvm16_clean_O0.exe).
- Rewritten / other comparator: Not available / not applicable.
- LLVM IR / generated C: [target_function.ll](assets/ir/s01_ollvm_sub/target_function.ll).
- CFG SVG: Not available / not applicable.
- IDA/Diaphora screenshot: [demo_substitution1_2.jpg](assets/ida/demo_substitution1_2.jpg).
- Lecture table: [03_arithmetic_optimization.svg](assets/tables/lecture/svg/03_arithmetic_optimization.svg).
- Detailed report: [msynth_validation.md](assets/reports/msynth_validation.md).
- Qualification: Global pass builds; arithmetic is largely one block. No rewritten SUB PE exists; Mergen lift is a separate semantic failure.

## Polaris MBA

Weeks: 4, 11.

- Binary: [polaris_mba_O0.exe](assets/binaries/s02_polaris_mba/original/polaris_mba_O0.exe).
- Matched clean comparator: [polaris_clean_O0.exe](assets/binaries/baselines/polaris/polaris_clean_O0.exe).
- Rewritten / other comparator: Not available / not applicable.
- LLVM IR / generated C: [target_function.ll](assets/ir/s02_polaris_mba/target_function.ll).
- CFG SVG: Not available / not applicable.
- IDA/Diaphora screenshot: [demo_substitution2_2.jpg](assets/ida/demo_substitution2_2.jpg).
- Lecture table: [06_deobfuscation_outputs.svg](assets/tables/lecture/svg/06_deobfuscation_outputs.svg).
- Detailed report: [complex_arithmetic_deobfuscation.md](assets/reports/complex_arithmetic_deobfuscation.md).
- Qualification: Native target 115→678 instructions; exact specimen is authoritative, not seed alone. Local simplification is not whole-function recovery.

## Tigress EncodeArithmetic

Weeks: 4–5.

- Binary: [tigress_encode_arithmetic_O0.exe](assets/binaries/s06_tigress_arithmetic/original/tigress_encode_arithmetic_O0.exe).
- Matched clean comparator: [tigress_clean_O0.exe](assets/binaries/baselines/tigress/tigress_clean_O0.exe).
- Rewritten / other comparator: [tigress_encode_arithmetic_Ox.exe](assets/binaries/s06_tigress_arithmetic/optimized/tigress_encode_arithmetic_Ox.exe).
- LLVM IR / generated C: [exact_generated_encode_arithmetic.c](assets/ir/s06_tigress_arithmetic/exact_generated_encode_arithmetic.c).
- CFG SVG: Not available / not applicable.
- IDA/Diaphora screenshot: Not available / not applicable.
- Lecture table: [03_arithmetic_optimization.svg](assets/tables/lecture/svg/03_arithmetic_optimization.svg).
- Detailed report: [msynth_validation.md](assets/reports/msynth_validation.md).
- Qualification: Comparator listed in the rewrite column is optimized /Ox, NOT deobfuscated. Matched /Ox clean is assets/binaries/baselines/tigress_Ox/showcase.exe. The supplied story-6 image shows the wrong target.

## Optimization survival

Weeks: 5.

- Binary: [tigress_encode_arithmetic_Ox.exe](assets/binaries/s06_tigress_arithmetic/optimized/tigress_encode_arithmetic_Ox.exe).
- Matched clean comparator: [showcase.exe](assets/binaries/baselines/tigress_Ox/showcase.exe).
- Rewritten / other comparator: [tigress_encode_arithmetic_O0.exe](assets/binaries/s06_tigress_arithmetic/original/tigress_encode_arithmetic_O0.exe).
- LLVM IR / generated C: [exact_generated_encode_arithmetic.c](assets/ir/s06_tigress_arithmetic/exact_generated_encode_arithmetic.c).
- CFG SVG: Not available / not applicable.
- IDA/Diaphora screenshot: [demo_substitution1_2.jpg](assets/ida/demo_substitution1_2.jpg).
- Lecture table: [03_arithmetic_optimization.svg](assets/tables/lecture/svg/03_arithmetic_optimization.svg).
- Detailed report: [optimization_survival.md](assets/reports/optimization_survival.md).
- Qualification: Compare Tigress O0 versus /Ox using exact same generated C. The screenshot is an O0 SUB illustration, not an optimization-level pair. Other levels are summarized, not all duplicated.

## OLLVM BCF

Weeks: 6–8.

- Binary: [ollvm16_bcf_O0.exe](assets/binaries/s03_ollvm_bcf/original/ollvm16_bcf_O0.exe).
- Matched clean comparator: [ollvm16_clean_O0.exe](assets/binaries/baselines/ollvm16/ollvm16_clean_O0.exe).
- Rewritten / other comparator: [ollvm16_bcf_O0_triton_rewritten.exe](assets/binaries/s03_ollvm_bcf/rewritten/ollvm16_bcf_O0_triton_rewritten.exe).
- LLVM IR / generated C: [target_function.ll](assets/ir/s03_ollvm_bcf/target_function.ll).
- CFG SVG: [original_entry_reachable.svg](assets/cfg/s03_ollvm_bcf/original_entry_reachable.svg).
- IDA/Diaphora screenshot: [demo_bogus_control3_flow_clean_to_bcf_2.jpg](assets/ida/demo_bogus_control3_flow_clean_to_bcf_2.jpg).
- Lecture table: [08_bcf_proof_to_patch.svg](assets/tables/lecture/svg/08_bcf_proof_to_patch.svg).
- Detailed report: [opaque_predicate_triton.md](assets/reports/opaque_predicate_triton.md).
- Qualification: 22/22 injected gates; target proof scope is not a proof of the whole PE.

## Polaris BCF

Weeks: 6–8.

- Binary: [polaris_bcf_O0.exe](assets/binaries/s07_polaris_bcf/original/polaris_bcf_O0.exe).
- Matched clean comparator: [polaris_clean_O0.exe](assets/binaries/baselines/polaris/polaris_clean_O0.exe).
- Rewritten / other comparator: [polaris_bcf_O0_triton_rewritten.exe](assets/binaries/s07_polaris_bcf/rewritten/polaris_bcf_O0_triton_rewritten.exe).
- LLVM IR / generated C: [target_function.ll](assets/ir/s07_polaris_bcf/target_function.ll).
- CFG SVG: [rewritten_entry_reachable.svg](assets/cfg/s07_polaris_bcf/rewritten_entry_reachable.svg).
- IDA/Diaphora screenshot: [demo_bogus_control_flow7_polaris_bcf_to_rewritten_2.jpg](assets/ida/demo_bogus_control_flow7_polaris_bcf_to_rewritten_2.jpg).
- Lecture table: [08_bcf_proof_to_patch.svg](assets/tables/lecture/svg/08_bcf_proof_to_patch.svg).
- Detailed report: [opaque_predicate_rewrite.md](assets/reports/opaque_predicate_rewrite.md).
- Qualification: 16/16 gates; proof-driven rewrite works on retained tests. Dead bytes and predicate computations remain.

## Tigress opaque predicates

Weeks: 6–7.

- Binary: [showcase.exe](assets/binaries/support_tigress_opaque/original/showcase.exe).
- Matched clean comparator: [tigress_clean_O0.exe](assets/binaries/baselines/tigress/tigress_clean_O0.exe).
- Rewritten / other comparator: Not available / not applicable.
- LLVM IR / generated C: [add_opaque.c](assets/ir/support_tigress_opaque/add_opaque.c).
- CFG SVG: [tigress-add_opaque-O0_after.svg](assets/cfg/support_tigress_opaque/tigress-add_opaque-O0_after.svg).
- IDA/Diaphora screenshot: Not available / not applicable.
- Lecture table: [04_opaque_optimization.svg](assets/tables/lecture/svg/04_opaque_optimization.svg).
- Detailed report: [opaque_predicate_triton.md](assets/reports/opaque_predicate_triton.md).
- Qualification: CFG is a symbolic projection under captured initialized state, not a patched PE. 0/3 generic versus 3/3 initialized proofs; x/y symbolic in both.

## Triton proof

Weeks: 7.

- Binary: [ollvm16_bcf_O0.exe](assets/binaries/s03_ollvm_bcf/original/ollvm16_bcf_O0.exe).
- Matched clean comparator: [ollvm16_clean_O0.exe](assets/binaries/baselines/ollvm16/ollvm16_clean_O0.exe).
- Rewritten / other comparator: Not available / not applicable.
- LLVM IR / generated C: [target_function.ll](assets/ir/s03_ollvm_bcf/target_function.ll).
- CFG SVG: [original_entry_reachable.svg](assets/cfg/s03_ollvm_bcf/original_entry_reachable.svg).
- IDA/Diaphora screenshot: [demo_bogus_control3_flow_bcf_to_rewritten_2.jpg](assets/ida/demo_bogus_control3_flow_bcf_to_rewritten_2.jpg).
- Lecture table: [06_deobfuscation_outputs.svg](assets/tables/lecture/svg/06_deobfuscation_outputs.svg).
- Detailed report: [opaque_predicate_triton.md](assets/reports/opaque_predicate_triton.md).
- Qualification: Primary artifact: assets/evidence/s03_ollvm_bcf/first_gate_proof/false.smt2 and result.json. Screenshot is context, not proof.

## Proof-driven branch rewriting

Weeks: 8.

- Binary: [ollvm16_bcf_O0.exe](assets/binaries/s03_ollvm_bcf/original/ollvm16_bcf_O0.exe).
- Matched clean comparator: [ollvm16_clean_O0.exe](assets/binaries/baselines/ollvm16/ollvm16_clean_O0.exe).
- Rewritten / other comparator: [ollvm16_bcf_O0_triton_rewritten.exe](assets/binaries/s03_ollvm_bcf/rewritten/ollvm16_bcf_O0_triton_rewritten.exe).
- LLVM IR / generated C: [target_function.ll](assets/ir/s03_ollvm_bcf/target_function.ll).
- CFG SVG: [rewritten_entry_reachable.svg](assets/cfg/s03_ollvm_bcf/rewritten_entry_reachable.svg).
- IDA/Diaphora screenshot: [demo_bogus_control3_flow_bcf_to_rewritten_2.jpg](assets/ida/demo_bogus_control3_flow_bcf_to_rewritten_2.jpg).
- Lecture table: [08_bcf_proof_to_patch.svg](assets/tables/lecture/svg/08_bcf_proof_to_patch.svg).
- Detailed report: [opaque_predicate_rewrite.md](assets/reports/opaque_predicate_rewrite.md).
- Qualification: Primary patch_manifest.json and validation.json are bundled for both families. No old PDB mappings; unchanged byte length does not mean unchanged reachable CFG.

## OLLVM FLA

Weeks: 9–10.

- Binary: [ollvm16_fla_O0.exe](assets/binaries/s04_ollvm_fla/original/ollvm16_fla_O0.exe).
- Matched clean comparator: [ollvm16_clean_O0.exe](assets/binaries/baselines/ollvm16/ollvm16_clean_O0.exe).
- Rewritten / other comparator: [ollvm16_fla_O0_stock_unflattened.exe](assets/binaries/s04_ollvm_fla/rewritten/ollvm16_fla_O0_stock_unflattened.exe).
- LLVM IR / generated C: [before_target.ll](assets/ir/s04_ollvm_fla/before_target.ll).
- CFG SVG: [course_comparison.svg](assets/cfg/s04_ollvm_fla/course_comparison.svg).
- IDA/Diaphora screenshot: [demo_flattening4_ollvm_to_rewritten_fla_1.jpg](assets/ida/demo_flattening4_ollvm_to_rewritten_fla_1.jpg).
- Lecture table: [09_unflattening_outcomes.svg](assets/tables/lecture/svg/09_unflattening_outcomes.svg).
- Detailed report: [unflattening_course_examples.md](assets/reports/unflattening_course_examples.md).
- Qualification: 25/25 semantic successor pairs and retained canonical PASS; graph non-identity is allowed.

## Hikari FLA

Weeks: 9–10.

- Binary: [showcase.exe](assets/binaries/support_hikari_fla/original/showcase.exe).
- Matched clean comparator: [showcase.exe](assets/binaries/baselines/hikari/showcase.exe).
- Rewritten / other comparator: [stock_rewritten.exe](assets/binaries/support_hikari_fla/rewritten/stock_rewritten.exe).
- LLVM IR / generated C: [before_target.ll](assets/ir/support_hikari_fla/before_target.ll).
- CFG SVG: [after_cfg.svg](assets/cfg/support_hikari_fla/after_cfg.svg).
- IDA/Diaphora screenshot: Not available / not applicable.
- Lecture table: [09_unflattening_outcomes.svg](assets/tables/lecture/svg/09_unflattening_outcomes.svg).
- Detailed report: [unflattening_validation.md](assets/reports/unflattening_validation.md).
- Qualification: 28/28 successor pairs and retained O0 PASS. O2 is not covered by this success. Global -enable-cffobf, not validated annotation-only targeting.

## Polaris incorrect FLA rewrite

Weeks: 10, 12.

- Binary: [polaris_fla_O0.exe](assets/binaries/s05_polaris_fla_wrong/original/polaris_fla_O0.exe).
- Matched clean comparator: [polaris_clean_O0.exe](assets/binaries/baselines/polaris/polaris_clean_O0.exe).
- Rewritten / other comparator: [INCORRECT_DEOBFUSCATION_DO_NOT_USE_AS_WORKING_BINARY.exe](assets/binaries/s05_polaris_fla_wrong/rewritten/INCORRECT_DEOBFUSCATION_DO_NOT_USE_AS_WORKING_BINARY.exe).
- LLVM IR / generated C: [before_target.ll](assets/ir/s05_polaris_fla_wrong/before_target.ll).
- CFG SVG: [course_comparison.svg](assets/cfg/s05_polaris_fla_wrong/course_comparison.svg).
- IDA/Diaphora screenshot: [demo_flattening5_polaris_to_rewritten_1.jpg](assets/ida/demo_flattening5_polaris_to_rewritten_1.jpg).
- Lecture table: [10_correctness_traps.svg](assets/tables/lecture/svg/10_correctness_traps.svg).
- Detailed report: [unflattening_course_examples.md](assets/reports/unflattening_course_examples.md).
- Qualification: WRONG rewrite: F9CD8332 instead of DBEFFCE7; exit 1. Static failure analysis only. Exclude the mislabeled clean-to-rewrite screenshot.

## Tigress Flatten discovery failure

Weeks: 9–10.

- Binary: [tigress_flatten_O0.exe](assets/binaries/s08_tigress_flatten/original/tigress_flatten_O0.exe).
- Matched clean comparator: [tigress_clean_O0.exe](assets/binaries/baselines/tigress/tigress_clean_O0.exe).
- Rewritten / other comparator: Not available / not applicable.
- LLVM IR / generated C: [exact_generated_flatten.c](assets/ir/s08_tigress_flatten/exact_generated_flatten.c).
- CFG SVG: [reference_complete_cfg.svg](assets/cfg/s08_tigress_flatten/reference_complete_cfg.svg).
- IDA/Diaphora screenshot: [demo_flattening8_1.jpg](assets/ida/demo_flattening8_1.jpg).
- Lecture table: [09_unflattening_outcomes.svg](assets/tables/lecture/svg/09_unflattening_outcomes.svg).
- Detailed report: [unflattening_validation.md](assets/reports/unflattening_validation.md).
- Qualification: 38 reference blocks versus 6 stock-discovered; no successful rewrite. IDA discovery is not the stock Miasm result.

## Mergen lifting

Weeks: 11.

- Binary: [polaris_mba_O0.exe](assets/binaries/s02_polaris_mba/original/polaris_mba_O0.exe).
- Matched clean comparator: [polaris_clean_O0.exe](assets/binaries/baselines/polaris/polaris_clean_O0.exe).
- Rewritten / other comparator: Not available / not applicable.
- LLVM IR / generated C: [internal_O2.ll](assets/ir/s02_polaris_mba/mergen/internal_O2.ll).
- CFG SVG: [after_cfg.svg](assets/cfg/s04_ollvm_fla/after_cfg.svg).
- IDA/Diaphora screenshot: [demo_substitution2_2.jpg](assets/ida/demo_substitution2_2.jpg).
- Lecture table: [06_deobfuscation_outputs.svg](assets/tables/lecture/svg/06_deobfuscation_outputs.svg).
- Detailed report: [mergen_validation.md](assets/reports/mergen_validation.md).
- Qualification: No screenshot of Mergen IR supplied. Use the LLVM text; CFG here is the native unflattened FLA comparator, not a lifted-IR CFG. R→R2 and R→M→M2 are separate branches.

## Correctness failures

Weeks: 10–12.

- Binary: [polaris_fla_O0.exe](assets/binaries/s05_polaris_fla_wrong/original/polaris_fla_O0.exe).
- Matched clean comparator: [polaris_clean_O0.exe](assets/binaries/baselines/polaris/polaris_clean_O0.exe).
- Rewritten / other comparator: [INCORRECT_DEOBFUSCATION_DO_NOT_USE_AS_WORKING_BINARY.exe](assets/binaries/s05_polaris_fla_wrong/rewritten/INCORRECT_DEOBFUSCATION_DO_NOT_USE_AS_WORKING_BINARY.exe).
- LLVM IR / generated C: [raw_O2.ll](assets/ir/s01_ollvm_sub/mergen/raw_O2.ll).
- CFG SVG: [after_cfg.svg](assets/cfg/s05_polaris_fla_wrong/after_cfg.svg).
- IDA/Diaphora screenshot: [demo_flattening5_polaris_to_rewritten_1.jpg](assets/ida/demo_flattening5_polaris_to_rewritten_1.jpg).
- Lecture table: [10_correctness_traps.svg](assets/tables/lecture/svg/10_correctness_traps.svg).
- Detailed report: [mergen_validation.md](assets/reports/mergen_validation.md).
- Qualification: Two distinct failures: Polaris rewritten PE WRONG; OLLVM native SUB PASS but Mergen IR SEMANTIC FAILURE. No BinProtect executable is bundled.

## Additional expression and machine-evidence anchors

- [substitution_complex.c](assets/source/substitution_complex.c) — composed-expression source, distinct from the repeated-site showcase.
- [synthesis_expansion.json](assets/evidence/complex_arithmetic_v1_summaries/synthesis_expansion.json) — 10/12 proved isolated-site recoveries; two UNKNOWN.
- [family_results.json](assets/evidence/complex_arithmetic_v1_summaries/family_results.json) — no complete recovery among 20 extracted obfuscated complex returns.
- [semantic_result.json](assets/evidence/s02_polaris_mba/mergen/semantic_result.json) and [semantic_result.json](assets/evidence/s01_ollvm_sub/mergen/semantic_result.json) — passing versus failing lift.
- [internal_O2.ll](assets/ir/mergen_fla/ollvm_original/internal_O2.ll) versus [internal_O2.ll](assets/ir/mergen_fla/ollvm_unflattened/internal_O2.ll) — Mergen on flattened versus stock-unflattened input.
