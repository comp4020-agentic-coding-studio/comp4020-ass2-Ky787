// The evidence manifest: every handoff artefact this site is allowed to cite.
//
// Paths are relative to `claude_course_handoff_v1/`, the curated research
// package that is this course's technical source of truth. `scripts/
// sync-evidence.ts` copies each entry byte-for-byte into `public/artefacts/`,
// and `spec/evidence-integrity.test.ts` re-checks every copy against the
// original's SHA-256. Nothing on the site may reference an artefact that is
// not listed here: `evidenceUrl()` throws at build time on an unknown id, so
// a fabricated citation cannot reach a page.
//
// Two deliberate exclusions:
//
//   1. No `.exe`. The package's 21 Windows x64 specimens are distributed
//      through the course VM, not from a public web page. One of them is an
//      explicitly incorrect rewrite and must never be a click away from
//      looking runnable.
//   2. No `demo_flattening5_clean_to_rewritten_1.jpg` and no
//      `demo_substitution6_1.jpg`. Both are on publication hold in
//      VISUAL_INDEX.md because their visible content contradicts their
//      filename. The site discusses them by name on /evidence/ and never
//      renders them.

export const HANDOFF_DIR = "claude_course_handoff_v1";
export const PUBLIC_EVIDENCE_DIR = "public/artefacts";

/** Screenshot derivative width, in CSS pixels, used for inline display. */
export const IMAGE_DERIVATIVE_WIDTH = 1600;

/** Filenames kept out of the site by VISUAL_INDEX.md publication holds. */
export const HELD_IMAGES = [
  "demo_flattening5_clean_to_rewritten_1.jpg",
  "demo_substitution6_1.jpg",
] as const;

/** Text, data and vector artefacts, served verbatim. */
export const evidenceFiles: readonly string[] = [
  // --- handoff-level reference documents -------------------------------
  "CLAIMS_AND_CAVEATS.md",
  "BEST_EVIDENCE_BY_TOPIC.md",
  "BINARY_GUIDE.md",
  "BINARY_INDEX.json",
  "TERMINOLOGY.md",
  "TOOL_CATALOG.md",
  "EXPERIMENTAL_CORPUS.md",
  "VISUAL_INDEX.md",
  "VALIDATION_REPORT.md",
  "ASSET_MANIFEST.json",
  "LECTURE_TABLE_INDEX.md",
  "HANDS_ON_LABS.md",
  "BIBLIOGRAPHY.md",

  // --- frozen source ---------------------------------------------------
  "assets/source/showcase.c",
  "assets/source/SHOWCASE_VERSION.txt",
  "assets/source/substitution_complex.c",
  "assets/source/SUBSTITUTION_COMPLEX_VERSION.txt",

  // --- compiler IR and generated C -------------------------------------
  "assets/ir/baselines/ollvm16/demo_substitution.ll",
  "assets/ir/s01_ollvm_sub/target_function.ll",
  "assets/ir/s02_polaris_mba/target_function.ll",
  "assets/ir/s03_ollvm_bcf/target_function.ll",
  "assets/ir/s04_ollvm_fla/clean_target.ll",
  "assets/ir/s04_ollvm_fla/before_target.ll",
  "assets/ir/s05_polaris_fla_wrong/before_target.ll",
  "assets/ir/support_hikari_fla/before_target.ll",
  "assets/ir/s06_tigress_arithmetic/exact_generated_encode_arithmetic.c",
  "assets/ir/s08_tigress_flatten/exact_generated_flatten.c",
  "assets/ir/support_tigress_opaque/add_opaque.c",

  // --- lifted IR (Mergen) ----------------------------------------------
  "assets/ir/s01_ollvm_sub/mergen/raw_O2.ll",
  "assets/ir/s01_ollvm_sub/mergen/internal_O2.ll",
  "assets/ir/s02_polaris_mba/mergen/internal_lift.ll",
  "assets/ir/s02_polaris_mba/mergen/internal_O2.ll",
  "assets/ir/mergen_fla/ollvm_original/internal_O2.ll",
  "assets/ir/mergen_fla/ollvm_unflattened/internal_O2.ll",

  // --- native disassembly ----------------------------------------------
  "assets/evidence/baselines/ollvm16/demo_substitution_disassembly.txt",
  "assets/evidence/baselines/ollvm16/run_stdout.txt",
  "assets/evidence/baselines/tigress_Ox/target_function_disassembly.txt",
  "assets/evidence/s01_ollvm_sub/demo_substitution_disassembly.txt",
  "assets/evidence/s02_polaris_mba/demo_substitution_disassembly.txt",
  "assets/evidence/s06_tigress_arithmetic/demo_substitution_O0_disassembly.txt",
  "assets/evidence/s06_tigress_arithmetic/demo_substitution_Ox_disassembly.txt",
  "assets/evidence/s06_tigress_arithmetic/original/metadata.json",
  "assets/evidence/s06_tigress_arithmetic/optimized/metadata.json",
  "assets/evidence/s03_ollvm_bcf/clean_target_disassembly.txt",
  "assets/evidence/s03_ollvm_bcf/original_target_disassembly.txt",
  "assets/evidence/s03_ollvm_bcf/rewritten_target_disassembly.txt",
  "assets/evidence/support_tigress_opaque/original/target_function_disassembly.txt",

  // --- solver evidence -------------------------------------------------
  "assets/evidence/s03_ollvm_bcf/first_gate_proof/result.json",
  "assets/evidence/s03_ollvm_bcf/first_gate_proof/prefix.smt2",
  "assets/evidence/s03_ollvm_bcf/first_gate_proof/condition.smt2",
  "assets/evidence/s03_ollvm_bcf/first_gate_proof/true.smt2",
  "assets/evidence/s03_ollvm_bcf/first_gate_proof/false.smt2",
  "assets/evidence/triton_summaries/family_results.json",
  "assets/evidence/triton_summaries/aggregate_accuracy.json",
  "assets/evidence/triton_summaries/course_examples.json",
  "assets/evidence/support_tigress_opaque/o0/result.json",
  "assets/evidence/support_tigress_opaque/o0_initialized/result.json",
  "assets/evidence/support_tigress_opaque/o0_initialized/initialized_state.json",

  // --- rewriting evidence ----------------------------------------------
  "assets/evidence/s03_ollvm_bcf/validation.json",
  "assets/evidence/s03_ollvm_bcf/projection_notes.json",
  "assets/evidence/s03_ollvm_bcf/metadata_audit.json",
  "assets/evidence/s03_ollvm_bcf/canonical_rewritten_stdout.txt",
  "assets/evidence/s07_polaris_bcf/validation.json",
  "assets/evidence/s07_polaris_bcf/projection_notes.json",

  // --- unflattening evidence -------------------------------------------
  "assets/evidence/s04_ollvm_fla/clean_cfg.txt",
  "assets/evidence/s04_ollvm_fla/before_cfg.txt",
  "assets/evidence/s04_ollvm_fla/after_cfg.txt",
  "assets/evidence/s04_ollvm_fla/stock_result.json",
  "assets/evidence/s04_ollvm_fla/semantic_edge_score.json",
  "assets/evidence/s04_ollvm_fla/output_runtime_stdout.txt",
  "assets/evidence/s05_polaris_fla_wrong/after_cfg.txt",
  "assets/evidence/s05_polaris_fla_wrong/stock_result.json",
  "assets/evidence/s05_polaris_fla_wrong/semantic_edge_score.json",
  "assets/evidence/s05_polaris_fla_wrong/input_runtime_stdout.txt",
  "assets/evidence/s05_polaris_fla_wrong/output_runtime_stdout.txt",
  "assets/evidence/support_hikari_fla/stock_result.json",
  "assets/evidence/support_hikari_fla/semantic_edge_score.json",
  "assets/evidence/s08_tigress_flatten/stock_result.json",
  "assets/evidence/s08_tigress_flatten/verified_jump_table.json",
  "assets/evidence/s08_tigress_flatten/before_cfg.txt",
  "assets/evidence/s08_tigress_flatten/reference_complete_cfg.txt",

  // --- lifting and arithmetic evidence ---------------------------------
  "assets/evidence/s01_ollvm_sub/mergen/semantic_result.json",
  "assets/evidence/s01_ollvm_sub/mergen/ir_metrics.json",
  "assets/evidence/s02_polaris_mba/mergen/semantic_result.json",
  "assets/evidence/s02_polaris_mba/mergen/ir_metrics.json",
  "assets/evidence/mergen_summaries/totals.json",
  "assets/evidence/complex_arithmetic_v1_summaries/synthesis_expansion.json",
  "assets/evidence/complex_arithmetic_v1_summaries/family_results.json",
  "assets/evidence/complex_arithmetic_v1_summaries/smt_overview.json",
  "assets/evidence/msynth_summaries/synthesis_results.json",
  "assets/evidence/matrix/compiler_inventory.json",

  // --- control-flow graphs ---------------------------------------------
  "assets/cfg/s03_ollvm_bcf/clean_entry_reachable.svg",
  "assets/cfg/s03_ollvm_bcf/original_entry_reachable.svg",
  "assets/cfg/s03_ollvm_bcf/rewritten_entry_reachable.svg",
  "assets/cfg/s03_ollvm_bcf/rewritten_all_static.svg",
  "assets/cfg/s07_polaris_bcf/original_entry_reachable.svg",
  "assets/cfg/s07_polaris_bcf/rewritten_entry_reachable.svg",
  "assets/cfg/s04_ollvm_fla/clean_cfg.svg",
  "assets/cfg/s04_ollvm_fla/before_cfg.svg",
  "assets/cfg/s04_ollvm_fla/after_cfg.svg",
  "assets/cfg/s04_ollvm_fla/course_comparison.svg",
  "assets/cfg/s05_polaris_fla_wrong/before_cfg.svg",
  "assets/cfg/s05_polaris_fla_wrong/after_cfg.svg",
  "assets/cfg/s05_polaris_fla_wrong/course_comparison.svg",
  "assets/cfg/support_hikari_fla/after_cfg.svg",
  "assets/cfg/s08_tigress_flatten/before_cfg.svg",
  "assets/cfg/s08_tigress_flatten/reference_complete_cfg.svg",
  "assets/cfg/support_tigress_opaque/tigress-add_opaque-O0_before.svg",
  "assets/cfg/support_tigress_opaque/tigress-add_opaque-O0_after.svg",

  // --- lecture tables (structured rows plus the original figures) -------
  "assets/tables/lecture/tables.json",
  "assets/tables/lecture/svg/01_transformation_layers.svg",
  "assets/tables/lecture/svg/02_obfuscator_snapshot.svg",
  "assets/tables/lecture/svg/03_arithmetic_optimization.svg",
  "assets/tables/lecture/svg/04_opaque_optimization.svg",
  "assets/tables/lecture/svg/05_flattening_optimization.svg",
  "assets/tables/lecture/svg/06_deobfuscation_outputs.svg",
  "assets/tables/lecture/svg/07_end_to_end_results.svg",
  "assets/tables/lecture/svg/08_bcf_proof_to_patch.svg",
  "assets/tables/lecture/svg/09_unflattening_outcomes.svg",
  "assets/tables/lecture/svg/10_correctness_traps.svg",
  "assets/tables/lecture/svg/11_reproducibility.svg",
  "assets/tables/lecture/svg/12_manual_analysis_examples.svg",

  // --- research tables -------------------------------------------------
  "assets/tables/research/selected_metrics.md",
  "assets/tables/research/end_to_end_results.md",
  "assets/tables/research/obfuscators.md",
  "assets/tables/research/deobfuscators.md",
  "assets/tables/research/optimization_survival.md",
  "assets/tables/research/best_course_examples.md",

  // --- retained research reports ---------------------------------------
  "assets/reports/FINAL_RESEARCH_OVERVIEW.md",
  "assets/reports/RESEARCH_SUMMARY.md",
  "assets/reports/PIPELINES.md",
  "assets/reports/showcase_validation.md",
  "assets/reports/showcase_matrix_v1.md",
  "assets/reports/optimization_survival.md",
  "assets/reports/obfuscator_comparison_summary.md",
  "assets/reports/msynth_validation.md",
  "assets/reports/complex_arithmetic_deobfuscation.md",
  "assets/reports/opaque_predicate_triton.md",
  "assets/reports/opaque_predicate_rewrite.md",
  "assets/reports/unflattening_validation.md",
  "assets/reports/unflattening_course_examples.md",
  "assets/reports/mergen_validation.md",
  "assets/reports/binprotect_validation.md",
  "assets/reports/polaris_validation.md",
  "assets/reports/tigress_validation.md",
];

/** IDA / Diaphora screenshots: verbatim original plus web derivatives. */
export const evidenceImages: readonly string[] = [
  "assets/ida/demo_substitution1_1.jpg",
  "assets/ida/demo_substitution1_2.jpg",
  "assets/ida/demo_substitution2_1.jpg",
  "assets/ida/demo_substitution2_2.jpg",
  "assets/ida/demo_bogus_control3_flow_clean_to_bcf.jpg",
  "assets/ida/demo_bogus_control3_flow_clean_to_bcf_2.jpg",
  "assets/ida/demo_bogus_control3_flow_bcf_to_rewritten_2.jpg",
  "assets/ida/demo_bogus_control3_flow_clean_to_rewritten_1.jpg",
  "assets/ida/demo_bogus_control_flow7_polaris_clean_to_polaris_bcf_2.jpg",
  "assets/ida/demo_bogus_control_flow7_polaris_bcf_to_rewritten_2.jpg",
  "assets/ida/demo_flattening4_clean_to_ollvm_fla_1.jpg",
  "assets/ida/demo_flattening4_ollvm_to_rewritten_fla_1.jpg",
  "assets/ida/demo_flattening4_clean_to_rewritten_fla_1.jpg",
  "assets/ida/demo_flattening5_clean_to_polaris_1.jpg",
  "assets/ida/demo_flattening5_polaris_to_rewritten_1.jpg",
  "assets/ida/demo_flattening8_1.jpg",
  "assets/ida/demo_flattening8_2.jpg",
];

export const allEvidence: readonly string[] = [...evidenceFiles, ...evidenceImages];

/** Public URL path (before the base prefix) for a manifest entry. */
export function evidencePath(id: string): string {
  return `/artefacts/${id.replace(/^assets\//, "")}`;
}

/** `foo/bar.jpg` -> `foo/bar-w1600.avif` / `-w1600.jpg` */
export function derivativePath(id: string, ext: "avif" | "jpg"): string {
  return evidencePath(id).replace(/\.jpg$/, `-w${IMAGE_DERIVATIVE_WIDTH}.${ext}`);
}
