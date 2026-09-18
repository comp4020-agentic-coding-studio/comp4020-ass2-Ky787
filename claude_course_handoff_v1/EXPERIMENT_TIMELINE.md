# Methodological timeline

This is approximate methodological order, not a claim of twelve distinct dates or a teaching schedule. Reports record the exact dates/configurations where available. Older “next step” paragraphs are historical, not pending tasks.

1. **Obfuscator validation:** identify tool builds, confirm independent transformations, PE compatibility and seed behavior; Polaris IR and backend paths treated separately. [Polaris](assets/reports/polaris_validation.md), [Tigress](assets/reports/tigress_validation.md).
2. **Showcase freeze:** establish recognisable functions, runtime checks and a fixed source hash. [Source validation](assets/reports/showcase_validation.md).
3. **Optimization matrix:** controlled same-source comparisons across families and optimization levels; discover annotation targeting limitations and retain global fallback. [Matrix](assets/reports/showcase_matrix_v1.md), [survival](assets/reports/optimization_survival.md).
4. **BinProtect validation:** inspect post-link transformations, discover all eight protected outputs crash or hang, restrict claims to static evidence. [Report](assets/reports/binprotect_validation.md).
5. **Arithmetic deobfuscation:** extract local expressions with Miasm; separate AST/oracle, SiMBA and stochastic synthesis; independently check candidates. [msynth report](assets/reports/msynth_validation.md).
6. **Complex arithmetic probe:** freeze a second source; test composed expressions and preregistered synthesis expansion; retain failures/UNKNOWN. [Report](assets/reports/complex_arithmetic_deobfuscation.md).
7. **Flattening deobfuscation:** test stock recovery, score semantic successor pairs, distinguish discovery failure from an incorrect rewrite; inspect SSA methodology. [Unflattening](assets/reports/unflattening_validation.md).
8. **Opaque-predicate Triton study:** model actual x64 semantics and branch conditions, test genuine controls, compare arbitrary versus initialized Tigress state. [Report](assets/reports/opaque_predicate_triton.md).
9. **Proof-driven rewriting:** consume frozen proofs and exact bytes; preserve layout; validate outputs and audit reachable versus physical CFG. [Report](assets/reports/opaque_predicate_rewrite.md).
10. **Mergen lifting:** lift selected whole functions to LLVM, compare raw/internal optimization stages and runtime outcomes; retain OLLVM SUB silent mislift. [Report](assets/reports/mergen_validation.md).
11. **Evidence-pack curation:** select eight stories, comparisons and caveats; correct Hikari targeting wording; prepare lecture tables without adding experiments. [Corrected overview](assets/reports/FINAL_RESEARCH_OVERVIEW.md).
12. **IDA/Diaphora screenshots:** user-supplied manual-analysis views; this handoff indexes all 25 and flags two filename/content conflicts. Capture timestamps, software version and exact database hashes were not supplied. [Visual index](VISUAL_INDEX.md).

**The final course should NOT simply teach material in this chronological research order.** The provisional outline instead introduces representations and semantics before the later proof/rewrite/lifting comparisons.
