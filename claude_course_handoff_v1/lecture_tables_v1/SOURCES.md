# Evidence sources

Each table is an authored condensation, not a new experiment. Source files below are in the unchanged evidence_pack_v1 companion directory. Exact SHA-256 values are in SOURCES.json.

## 01_transformation_layers

Where does obfuscation happen?

- [tables/obfuscators.json](../evidence_pack_v1/tables/obfuscators.json)
- [PIPELINES.md](../evidence_pack_v1/PIPELINES.md)

## 02_obfuscator_snapshot

Five obfuscators, five useful lessons

- [tables/obfuscators.json](../evidence_pack_v1/tables/obfuscators.json)
- [tables/end_to_end_results.json](../evidence_pack_v1/tables/end_to_end_results.json)

## 03_arithmetic_optimization

Arithmetic: complexity can shrink or survive

- [tables/optimization_survival.json](../evidence_pack_v1/tables/optimization_survival.json)
- [tables/selected_metrics.md](../evidence_pack_v1/tables/selected_metrics.md)

## 04_opaque_optimization

Opaque flow: what survives optimization?

- [tables/optimization_survival.json](../evidence_pack_v1/tables/optimization_survival.json)
- [tables/end_to_end_results.json](../evidence_pack_v1/tables/end_to_end_results.json)

## 05_flattening_optimization

Flattening can survive without an indirect jump

- [tables/optimization_survival.json](../evidence_pack_v1/tables/optimization_survival.json)
- [tables/obfuscators.json](../evidence_pack_v1/tables/obfuscators.json)

## 06_deobfuscation_outputs

What does each deobfuscator actually produce?

- [tables/deobfuscators.json](../evidence_pack_v1/tables/deobfuscators.json)

## 07_end_to_end_results

From obfuscated code to a working rewrite

- [tables/end_to_end_results.json](../evidence_pack_v1/tables/end_to_end_results.json)
- [tables/selected_metrics.md](../evidence_pack_v1/tables/selected_metrics.md)

## 08_bcf_proof_to_patch

BCF: proof becomes a working PE patch

- [tables/selected_metrics.md](../evidence_pack_v1/tables/selected_metrics.md)
- [manual_analysis/03_ollvm_bcf/evidence/validation.json](../evidence_pack_v1/manual_analysis/03_ollvm_bcf/evidence/validation.json)
- [manual_analysis/04_polaris_bcf/evidence/validation.json](../evidence_pack_v1/manual_analysis/04_polaris_bcf/evidence/validation.json)

## 09_unflattening_outcomes

Unflattening: the smaller graph can be wrong

- [tables/selected_metrics.md](../evidence_pack_v1/tables/selected_metrics.md)
- [tables/end_to_end_results.json](../evidence_pack_v1/tables/end_to_end_results.json)

## 10_correctness_traps

Four tempting conclusions to avoid

- [tables/selected_metrics.md](../evidence_pack_v1/tables/selected_metrics.md)
- [IDA_WALKTHROUGH.md](../evidence_pack_v1/IDA_WALKTHROUGH.md)
- [reference/research_docs/mergen_validation.md](../evidence_pack_v1/reference/research_docs/mergen_validation.md)

## 11_reproducibility

A seed is not always a reconstruction key

- [tables/obfuscators.json](../evidence_pack_v1/tables/obfuscators.json)
- [reference/research_docs/polaris_validation.md](../evidence_pack_v1/reference/research_docs/polaris_validation.md)
- [reference/research_docs/tigress_validation.md](../evidence_pack_v1/reference/research_docs/tigress_validation.md)

## 12_manual_analysis_examples

Six examples worth opening in IDA

- [tables/best_course_examples.md](../evidence_pack_v1/tables/best_course_examples.md)
- [IDA_WALKTHROUGH.md](../evidence_pack_v1/IDA_WALKTHROUGH.md)
