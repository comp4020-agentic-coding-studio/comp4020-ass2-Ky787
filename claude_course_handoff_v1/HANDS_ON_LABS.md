# Hands-on labs — proposals, not final lesson pages

All paths are relative to this package. Core work uses supplied C, IR, text disassembly, result JSON and SVG/JPEG views: a text editor and image/SVG viewer are sufficient. A disassembler capable of Windows PE x64 inspection is optional; IDA/Diaphora require an appropriately licensed compatible installation. Do not require a decompiler or Binary Ninja. Do not rebuild the corpus or run a complete deobfuscator to complete these exercises.

Optional execution requires a supplied Windows x64 lab/VM, not the Linux host. Use only binaries marked YES in [BINARY_GUIDE](BINARY_GUIDE.md), no arguments for canonical main checks, and expect the retained output logs. Do not disable endpoint protection or interpret a blocked launch as permission to bypass it. In x64dbg, break on an exported target or loaded base + RVA; ASLR can change preferred addresses. Decline original PDB auto-load for rewritten functions. No debugger session or Linux/Wine execution was validated during curation.

## Lab 1 — Find a constant, then follow its meaning

Weeks 1–3. Target: `demo_substitution`.

- [Source](assets/source/showcase.c), [clean compiler IR](assets/ir/baselines/ollvm16/demo_substitution.ll), [SUB IR](assets/ir/s01_ollvm_sub/target_function.ll).
- [Clean disassembly](assets/evidence/baselines/ollvm16/demo_substitution_disassembly.txt), [SUB disassembly](assets/evidence/s01_ollvm_sub/demo_substitution_disassembly.txt), [close-up](assets/ida/demo_substitution1_2.jpg).
- Optional pair: [OLLVM clean O0](assets/binaries/baselines/ollvm16/ollvm16_clean_O0.exe), [OLLVM SUB O0](assets/binaries/s01_ollvm_sub/original/ollvm16_sub_O0.exe).

Locate `0x12345678`/`12345678h`, trace one selected XOR and one ADD, and explain why an expanded IR operation may remain a recognizable native opcode. Deliver an annotated excerpt and distinguish the 24 intended repeated sites from setup/reduction operations. A literal search hit is a landmark, not proof that all sites survived unchanged.

## Lab 2 — Inspect Polaris MBA without counting CFG boxes

Week 4. Target: `demo_substitution`.

- [Clean PE](assets/binaries/baselines/polaris/polaris_clean_O0.exe), [MBA PE](assets/binaries/s02_polaris_mba/original/polaris_mba_O0.exe).
- [MBA IR](assets/ir/s02_polaris_mba/target_function.ll), [native instructions](assets/evidence/s02_polaris_mba/demo_substitution_disassembly.txt), [close-up](assets/ida/demo_substitution2_2.jpg).
- [Local synthesis evidence](assets/evidence/complex_arithmetic_v1_summaries/synthesis_expansion.json), [complex probe source](assets/source/substitution_complex.c).

Choose a short arithmetic segment, identify Boolean/arithmetic operators and state its bit width. Explain how a one-block function can be expensive to symbolically represent. Read one accepted synthesis result and one UNKNOWN result; say which can support an equivalence claim. Do not claim whole-function recovery from an isolated site.

## Lab 3 — Compare Tigress O0 and /Ox fairly

Week 5. Target: `demo_substitution`.

- [Exact generated C](assets/ir/s06_tigress_arithmetic/exact_generated_encode_arithmetic.c).
- [O0 PE](assets/binaries/s06_tigress_arithmetic/original/tigress_encode_arithmetic_O0.exe), [/Ox PE](assets/binaries/s06_tigress_arithmetic/optimized/tigress_encode_arithmetic_Ox.exe).
- [O0 disassembly](assets/evidence/s06_tigress_arithmetic/demo_substitution_O0_disassembly.txt), [/Ox disassembly](assets/evidence/s06_tigress_arithmetic/demo_substitution_Ox_disassembly.txt).
- Matched controls: [O0 clean](assets/binaries/baselines/tigress/tigress_clean_O0.exe), [/Ox clean](assets/binaries/baselines/tigress_Ox/showcase.exe), [/Ox clean disassembly](assets/evidence/baselines/tigress_Ox/target_function_disassembly.txt).

Compare 426 O0 and 226 /Ox target instructions with the appropriate clean condition (/Ox clean 106). Verify the two treatment metadata records share the same generated-source hash: [O0](assets/evidence/s06_tigress_arithmetic/original/metadata.json), [/Ox](assets/evidence/s06_tigress_arithmetic/optimized/metadata.json). Deliver a controlled comparison, not a cross-compiler ranking. Do not use `demo_substitution6_1.jpg` as arithmetic evidence—it shows the wrong target.

## Lab 4 — Model an opaque branch before trusting a proof

Weeks 6–7. Target: `demo_bogus_control_flow`.

- [Frozen gate result](assets/evidence/s03_ollvm_bcf/first_gate_proof/result.json), [prefix](assets/evidence/s03_ollvm_bcf/first_gate_proof/prefix.smt2), [taken query](assets/evidence/s03_ollvm_bcf/first_gate_proof/true.smt2), [fallthrough query](assets/evidence/s03_ollvm_bcf/first_gate_proof/false.smt2).
- [Tigress generic result](assets/evidence/support_tigress_opaque/o0/result.json), [initialized result](assets/evidence/support_tigress_opaque/o0_initialized/result.json), [captured state](assets/evidence/support_tigress_opaque/o0_initialized/initialized_state.json), [generated C](assets/ir/support_tigress_opaque/add_opaque.c).

Write the two obligations `P ∧ C` and `P ∧ ¬C`; interpret the recorded solver statuses without rerunning them. Explain why arbitrary symbolic globals and captured initialized globals justify different claims while x/y remain symbolic. Deliver an assumptions checklist and identify what UNKNOWN would mean. Solver execution is an optional future extension, not required for this lab.

## Lab 5 — From one frozen proof to six changed bytes

Week 8. Target: `demo_bogus_control_flow`.

- [Original OLLVM BCF PE](assets/binaries/s03_ollvm_bcf/original/ollvm16_bcf_O0.exe), [rewritten PE](assets/binaries/s03_ollvm_bcf/rewritten/ollvm16_bcf_O0_triton_rewritten.exe).
- [Patch manifest](assets/evidence/s03_ollvm_bcf/patch_manifest.json), [validation](assets/evidence/s03_ollvm_bcf/validation.json), [close-up](assets/ida/demo_bogus_control3_flow_bcf_to_rewritten_2.jpg).
- [Original reachable CFG](assets/cfg/s03_ollvm_bcf/original_entry_reachable.svg), [rewritten reachable CFG](assets/cfg/s03_ollvm_bcf/rewritten_entry_reachable.svg), [rewritten all-static CFG](assets/cfg/s03_ollvm_bcf/rewritten_all_static.svg).

At RVA `0x1667`, relate `0F 85 05 00 00 00` to `E9 06 00 00 00 90`. Explain why the destination is preserved despite changing instruction length and why the NOP is needed. Identify retained dead/stub bytes, then distinguish the solver proof from the 4,591 recorded differential triples. Deliver a patch rationale—not a newly patched executable. Optional Windows step-through must use the exact original/rewrite hashes.

Extension: repeat the interpretation using [Polaris manifest](assets/evidence/s07_polaris_bcf/patch_manifest.json) and [Polaris validation](assets/evidence/s07_polaris_bcf/validation.json), without assuming equal addresses or gate counts.

## Lab 6 — Clean, flattened, unflattened

Weeks 9–10. Target: `demo_flattening`.

- [Clean OLLVM PE](assets/binaries/baselines/ollvm16/ollvm16_clean_O0.exe), [FLA original](assets/binaries/s04_ollvm_fla/original/ollvm16_fla_O0.exe), [stock rewrite](assets/binaries/s04_ollvm_fla/rewritten/ollvm16_fla_O0_stock_unflattened.exe).
- [Three-way CFG](assets/cfg/s04_ollvm_fla/course_comparison.svg), [flattened IR](assets/ir/s04_ollvm_fla/before_target.ll), [successor score](assets/evidence/s04_ollvm_fla/semantic_edge_score.json), [runtime/result record](assets/evidence/s04_ollvm_fla/stock_result.json).

Identify dispatcher and state updates, follow one conditional semantic region, and contrast direct recovered edges with clean lowering. Explain why 17 rewritten versus 21 clean Miasm blocks is compatible with tested correctness. Optional transfer comparison: [Hikari before](assets/cfg/support_hikari_fla/before_cfg.svg), [after](assets/cfg/support_hikari_fla/after_cfg.svg), [result](assets/evidence/support_hikari_fla/stock_result.json). Do not assume the O0 outcome applies to O2.

## Lab 7 — Audit a beautiful but wrong result

Week 10. Static analysis only.

- [Passing Polaris original](assets/binaries/s05_polaris_fla_wrong/original/polaris_fla_O0.exe), [explicitly WRONG rewrite](assets/binaries/s05_polaris_fla_wrong/rewritten/INCORRECT_DEOBFUSCATION_DO_NOT_USE_AS_WORKING_BINARY.exe).
- [Comparison CFG](assets/cfg/s05_polaris_fla_wrong/course_comparison.svg), [rewritten instructions](assets/evidence/s05_polaris_fla_wrong/after_cfg.txt), [wrong stdout](assets/evidence/s05_polaris_fla_wrong/output_runtime_stdout.txt), [result](assets/evidence/s05_polaris_fla_wrong/stock_result.json).
- [Usable screenshot](assets/ida/demo_flattening5_polaris_to_rewritten_1.jpg). The clean-to-rewrite filename in story 5 is on identity hold; do not use it as Polaris evidence.

Find the source switch alternatives and compare them with the sequential arithmetic in the rewrite. Explain the loss of semantics using the retained counterexample/output and a short path argument. Deliver a rejection of the “smaller means correct” claim. Do not execute the marked incorrect PE for this exercise.

## Lab 8 — Discovery failure is not a six-block function

Week 10. Target: `demo_flattening`.

- [Tigress original](assets/binaries/s08_tigress_flatten/original/tigress_flatten_O0.exe), [complete reference](assets/cfg/s08_tigress_flatten/reference_complete_cfg.svg), [stock-discovered CFG](assets/cfg/s08_tigress_flatten/before_cfg.svg).
- [Verified jump table](assets/evidence/s08_tigress_flatten/verified_jump_table.json), [generated source](assets/ir/s08_tigress_flatten/exact_generated_flatten.c), [IDA detail](assets/ida/demo_flattening8_1.jpg), [stock result](assets/evidence/s08_tigress_flatten/stock_result.json).

Locate the indirect dispatch and distinguish what IDA discovered from what the stock unflattener discovered. Deliver an explanation of the 38-versus-6 discrepancy and identify the first failing stage. Do not invent a Tigress rewritten binary.

## Lab 9 — Valid LLVM IR, two very different verdicts

Weeks 11–12. No compilation required.

- Passing case: [Polaris MBA internal lift](assets/ir/s02_polaris_mba/mergen/internal_lift.ll), [M2 IR](assets/ir/s02_polaris_mba/mergen/internal_O2.ll), [metrics](assets/evidence/s02_polaris_mba/mergen/ir_metrics.json), [runtime contract/result](assets/evidence/s02_polaris_mba/mergen/semantic_result.json).
- Failing case: [OLLVM SUB R2 IR](assets/ir/s01_ollvm_sub/mergen/raw_O2.ll), [M2 IR](assets/ir/s01_ollvm_sub/mergen/internal_O2.ll), [SEMANTIC FAILURE record](assets/evidence/s01_ollvm_sub/mergen/semantic_result.json), [detailed cause](assets/reports/mergen_validation.md).
- Structural extension: [Mergen on OLLVM FLA original](assets/ir/mergen_fla/ollvm_original/internal_O2.ll) versus [on stock-unflattened input](assets/ir/mergen_fla/ollvm_unflattened/internal_O2.ll).

Draw the two study paths `R→R2` and `R→M→M2`, then classify verifier validity, residual complexity and runtime evidence separately. Explain why LLVM optimization cannot be blamed for introducing a bug already present in the raw lift, and why the passing Polaris vectors are still not a universal proof. Deliver an evidence-backed comparison, not a reconstructed original PE.
