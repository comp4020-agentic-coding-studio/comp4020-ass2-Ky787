# Visual index

All 25 source files were visually inspected and copied without renaming or editing. These are screenshots of analysis views, not semantic proofs. All show assembly/CFG views; none is a pseudocode/decompiler screenshot. Color meanings are not asserted without the original diff legend. Panes generally say only primary/secondary: pair assignments combine filename, visible instructions and retained story evidence, not embedded binary hashes.

## Story-number cross-reference

| Screenshot / new handoff story | Topic | Older evidence-pack folder / table 12 ID |
| --- | --- | --- |
| 1 | OLLVM SUB | 01_ollvm_sub |
| 2 | Polaris MBA | 02_polaris_mba |
| 3 | OLLVM BCF | 03_ollvm_bcf |
| 4 | OLLVM FLA | 05_ollvm_fla |
| 5 | Polaris FLA incorrect rewrite | 06_polaris_fla_incorrect |
| 6 | Tigress arithmetic | 07_tigress_arithmetic |
| 7 | Polaris BCF | 04_polaris_bcf |
| 8 | Tigress Flatten | 08_tigress_flatten_discovery |

This handoff uses the user-supplied screenshot numbering. The unchanged older reports and lecture table 12 use the older evidence-pack numbering.

## Two publication holds

- `demo_flattening5_clean_to_rewritten_1.jpg`: visible right pane matches OLLVM rewrite constants/addresses, not the labelled Polaris case. Check [after_cfg.txt](assets/evidence/s04_ollvm_fla/after_cfg.txt) against [after_cfg.txt](assets/evidence/s05_polaris_fla_wrong/after_cfg.txt).
- `demo_substitution6_1.jpg`: both visible pane titles say `demo_flattening`. No confirmed Tigress arithmetic-target screenshot was supplied.

Keep these files; do not silently relabel or treat them as confirmed results. No new screenshots were captured.

## demo_substitution1_1.jpg

[Open original screenshot](assets/ida/demo_substitution1_1.jpg)

- Story: 1
- Topic: OLLVM SUB
- Likely comparison: Likely clean (left) versus OLLVM SUB O0 (right)
- Target function: demo_substitution
- Type: overview CFG; graph diff
- Visible content: Both functions appear as a single long block; the right block is substantially taller. No readable opcodes at this zoom.
- Recommended use: Weeks 3/4: contrast expression size with block count.
- Suggested caption: One basic block can contain much more arithmetic: clean versus OLLVM SUB.
- Confidence: Medium: family and pair inferred from supplied story mapping; only function title and relative block shape are visible.

## demo_substitution1_2.jpg

[Open original screenshot](assets/ida/demo_substitution1_2.jpg)

- Story: 1
- Topic: OLLVM SUB
- Likely comparison: Clean left; OLLVM SUB right
- Target function: demo_substitution
- Type: assembly diff; close-up
- Visible content: Repeated clean ADDs and XOR 12345678h at left; canceling constants and negation/subtraction sequences at right.
- Recommended use: Week 3: follow a repeated static addition site.
- Suggested caption: The same source addition is lowered through different substitution templates; compare semantics, not instruction spelling.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_substitution2_1.jpg

[Open original screenshot](assets/ida/demo_substitution2_1.jpg)

- Story: 2
- Topic: Polaris MBA
- Likely comparison: Likely clean (left) versus Polaris MBA O0 (right)
- Target function: demo_substitution
- Type: overview CFG; graph diff
- Visible content: Both functions appear as a single long block; the right block is substantially taller. No readable opcodes at this zoom.
- Recommended use: Weeks 3/4: contrast expression size with block count.
- Suggested caption: One basic block can contain much more arithmetic: clean versus Polaris MBA.
- Confidence: Medium: family and pair inferred from supplied story mapping; only function title and relative block shape are visible.

## demo_substitution2_2.jpg

[Open original screenshot](assets/ida/demo_substitution2_2.jpg)

- Story: 2
- Topic: Polaris MBA
- Likely comparison: Clean left; Polaris MBA right
- Target function: demo_substitution
- Type: assembly diff; close-up
- Visible content: Simple clean operations contrast with IMUL, XOR, AND, OR and many constants.
- Recommended use: Week 4: motivate symbolic expression recovery.
- Suggested caption: Polaris MBA expands simple arithmetic into dense mixed Boolean-arithmetic machine code; correctness comes from separate retained checks.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control3_flow_bcf_to_rewritten_1.jpg

[Open original screenshot](assets/ida/demo_bogus_control3_flow_bcf_to_rewritten_1.jpg)

- Story: 3
- Topic: OLLVM BCF
- Likely comparison: BCF original left; proof-driven rewrite right
- Target function: demo_bogus_control_flow
- Type: overview CFG; graph diff
- Visible content: Changed routing and a reorganized, shorter overall graph; disconnected-looking blocks remain in the rewritten view.
- Recommended use: Week 8: pair with entry-reachable and all-static SVGs.
- Suggested caption: OLLVM branch patches change connectivity without deleting all predicate arithmetic or dead bytes.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control3_flow_bcf_to_rewritten_2.jpg

[Open original screenshot](assets/ida/demo_bogus_control3_flow_bcf_to_rewritten_2.jpg)

- Story: 3
- Topic: OLLVM BCF
- Likely comparison: BCF original left; proof-driven rewrite right
- Target function: demo_bogus_control_flow
- Type: assembly diff; graph diff; close-up
- Visible content: Injected conditional JNZ instructions become JMP in the right pane while predicate calculations and clone/stub blocks remain.
- Recommended use: Week 8: connect an SMT result to a branch patch.
- Suggested caption: OLLVM: conditional opaque gates become unconditional transfers; this is a partial rewrite, not full cleanup.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control3_flow_clean_to_bcf.jpg

[Open original screenshot](assets/ida/demo_bogus_control3_flow_clean_to_bcf.jpg)

- Story: 3
- Topic: OLLVM BCF
- Likely comparison: Clean left; BCF original right
- Target function: demo_bogus_control_flow
- Type: overview CFG; graph diff
- Visible content: A compact clean graph contrasts with a much taller, branching graph.
- Recommended use: Week 6: introduce clone and opaque-edge inflation.
- Suggested caption: OLLVM BCF visibly expands the target graph. Screenshot geometry is not an audited block-count measurement.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control3_flow_clean_to_bcf_2.jpg

[Open original screenshot](assets/ida/demo_bogus_control3_flow_clean_to_bcf_2.jpg)

- Story: 3
- Topic: OLLVM BCF
- Likely comparison: Clean left; BCF original right
- Target function: demo_bogus_control_flow
- Type: assembly diff; graph diff; close-up
- Visible content: Clean comparisons use 1337h, 12340000h and parity/low-byte tests; the obfuscated pane adds global loads, multiplication, tests and duplicated routes.
- Recommended use: Week 6: distinguish genuine source conditions from injected conditions.
- Suggested caption: Genuine source branches remain among the injected OLLVM predicate and clone machinery.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control3_flow_clean_to_rewritten_1.jpg

[Open original screenshot](assets/ida/demo_bogus_control3_flow_clean_to_rewritten_1.jpg)

- Story: 3
- Topic: OLLVM BCF
- Likely comparison: Clean left; proof-driven rewrite right
- Target function: demo_bogus_control_flow
- Type: overview CFG; graph diff
- Visible content: The rewritten graph still has much more structure than the clean comparator.
- Recommended use: Week 8: discuss residual overhead and graph non-identity.
- Suggested caption: The working OLLVM rewrite is not graph-identical to the clean compiler output.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control3_flow_clean_to_rewritten_2.jpg

[Open original screenshot](assets/ida/demo_bogus_control3_flow_clean_to_rewritten_2.jpg)

- Story: 3
- Topic: OLLVM BCF
- Likely comparison: Clean left; proof-driven rewrite right
- Target function: demo_bogus_control_flow
- Type: assembly diff; graph diff; close-up
- Visible content: Clean source decisions contrast with remaining global predicate arithmetic and unconditional transfers in the rewrite.
- Recommended use: Week 8: explain why removed impossible edges do not mean removed calculations.
- Suggested caption: OLLVM clean versus rewritten: semantic preservation does not require identical instructions or CFG layout.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_flattening4_clean_to_ollvm_fla_1.jpg

[Open original screenshot](assets/ida/demo_flattening4_clean_to_ollvm_fla_1.jpg)

- Story: 4
- Topic: OLLVM FLA
- Likely comparison: Clean left; OLLVM FLA original right
- Target function: demo_flattening
- Type: overview CFG; graph diff
- Visible content: Compact structured clean flow versus a wide dispatcher comparison ladder and return-to-dispatch edges.
- Recommended use: Week 9: identify dispatcher topology.
- Suggested caption: OLLVM flattening routes semantic blocks through a state dispatcher.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_flattening4_clean_to_rewritten_fla_1.jpg

[Open original screenshot](assets/ida/demo_flattening4_clean_to_rewritten_fla_1.jpg)

- Story: 4
- Topic: OLLVM FLA
- Likely comparison: Clean left; OLLVM stock rewrite right
- Target function: demo_flattening
- Type: assembly diff; graph diff; close-up
- Visible content: Loop and case operations are visible in both panes; the rewrite retains state-related instructions and NOPs but connects blocks directly.
- Recommended use: Week 10: correct need not mean identical.
- Suggested caption: Clean and successful OLLVM rewrite differ in instructions and layout while preserving the tested behavior.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_flattening4_ollvm_to_rewritten_fla_1.jpg

[Open original screenshot](assets/ida/demo_flattening4_ollvm_to_rewritten_fla_1.jpg)

- Story: 4
- Topic: OLLVM FLA
- Likely comparison: OLLVM FLA original left; stock rewrite right
- Target function: demo_flattening
- Type: overview CFG; graph diff
- Visible content: The large dispatcher network is replaced by a compact branching/loop graph.
- Recommended use: Week 10: positive unflattening example, alongside runtime record.
- Suggested caption: OLLVM O0 unflattening reconnects semantic successors; retained execution checks pass.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_flattening5_clean_to_polaris_1.jpg

[Open original screenshot](assets/ida/demo_flattening5_clean_to_polaris_1.jpg)

- Story: 5
- Topic: Polaris FLA incorrect rewrite
- Likely comparison: Clean left; Polaris FLA original right
- Target function: demo_flattening
- Type: overview CFG; graph diff
- Visible content: Clean structured flow versus a wide state-dispatch network.
- Recommended use: Week 9, before discussing the failed rewrite.
- Suggested caption: The Polaris original is a passing flattened specimen; later rewriting must be validated separately.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_flattening5_clean_to_rewritten_1.jpg

[Open original screenshot](assets/ida/demo_flattening5_clean_to_rewritten_1.jpg)

- Story: 5
- Topic: Polaris FLA incorrect rewrite
- Likely comparison: Filename claims Polaris clean versus rewrite; visible right pane instead matches retained OLLVM rewrite
- Target function: demo_flattening
- Type: assembly diff; graph diff; close-up
- Visible content: Right pane shows state constants 51837FD6h and 3AD94FDh, a branch to 14000160E and the OLLVM rewritten topology. These match OLLVM after_cfg.txt, not Polaris after_cfg.txt.
- Recommended use: HOLD: do not publish as Polaris evidence. Prefer demo_flattening5_polaris_to_rewritten_1.jpg and the retained Polaris CFG SVG.
- Suggested caption: Identity warning: filename says Polaris, but visible rewritten code matches OLLVM; provenance must be resolved before use.
- Confidence: High confidence of content/filename inconsistency; original database identity remains unverified.
- Warning: LIKELY MISLABELLED — keep filename unchanged; excluded from recommended Polaris visuals.

## demo_flattening5_polaris_to_rewritten_1.jpg

[Open original screenshot](assets/ida/demo_flattening5_polaris_to_rewritten_1.jpg)

- Story: 5
- Topic: Polaris FLA incorrect rewrite
- Likely comparison: Polaris FLA original left; incorrect stock rewrite right
- Target function: demo_flattening
- Type: overview CFG; graph diff
- Visible content: A broad dispatcher collapses into a much smaller graph, including a long straight-line region.
- Recommended use: Week 10: use with wrong runtime output and after_cfg.txt.
- Suggested caption: Polaris FLA: the smaller stock rewrite is WRONG. Visual simplification is not semantic correctness.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_substitution6_1.jpg

[Open original screenshot](assets/ida/demo_substitution6_1.jpg)

- Story: 6
- Topic: Tigress arithmetic
- Likely comparison: Likely lower- versus higher-optimization demo_flattening in Tigress-generated builds; exact pair unverified
- Target function: demo_flattening (visible; expected arithmetic target is demo_substitution)
- Type: assembly diff; graph diff; close-up
- Visible content: Both pane titles explicitly say demo_flattening. Left contains the four-iteration loop and switch; right uses CMOV/BT and an unrolled arithmetic chain. No demo_substitution target is visible.
- Recommended use: HOLD for arithmetic teaching. At most an optimization illustration after exact binary/flags are confirmed. Use retained EncodeArithmetic disassemblies instead.
- Suggested caption: This image shows demo_flattening, despite its substitution filename; it does not demonstrate EncodeArithmetic on demo_substitution.
- Confidence: High confidence of wrong target in filename; medium for optimization interpretation; low for exact build pair.
- Warning: WRONG TARGET FOR STORY 6 — no confirmed arithmetic-target screenshot supplied.

## demo_bogus_control_flow7_polaris_bcf_to_rewritten_1.jpg

[Open original screenshot](assets/ida/demo_bogus_control_flow7_polaris_bcf_to_rewritten_1.jpg)

- Story: 7
- Topic: Polaris BCF
- Likely comparison: BCF original left; proof-driven rewrite right
- Target function: demo_bogus_control_flow
- Type: overview CFG; graph diff
- Visible content: Changed routing and a reorganized, shorter overall graph; disconnected-looking blocks remain in the rewritten view.
- Recommended use: Week 8: pair with entry-reachable and all-static SVGs.
- Suggested caption: Polaris branch patches change connectivity without deleting all predicate arithmetic or dead bytes.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control_flow7_polaris_bcf_to_rewritten_2.jpg

[Open original screenshot](assets/ida/demo_bogus_control_flow7_polaris_bcf_to_rewritten_2.jpg)

- Story: 7
- Topic: Polaris BCF
- Likely comparison: BCF original left; proof-driven rewrite right
- Target function: demo_bogus_control_flow
- Type: assembly diff; graph diff; close-up
- Visible content: Injected conditional JNZ instructions become JMP in the right pane while predicate calculations and clone/stub blocks remain.
- Recommended use: Week 8: connect an SMT result to a branch patch.
- Suggested caption: Polaris: conditional opaque gates become unconditional transfers; this is a partial rewrite, not full cleanup.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control_flow7_polaris_clean_to_polaris_bcf_1.jpg

[Open original screenshot](assets/ida/demo_bogus_control_flow7_polaris_clean_to_polaris_bcf_1.jpg)

- Story: 7
- Topic: Polaris BCF
- Likely comparison: Clean left; BCF original right
- Target function: demo_bogus_control_flow
- Type: overview CFG; graph diff
- Visible content: A compact clean graph contrasts with a much taller, branching graph.
- Recommended use: Week 6: introduce clone and opaque-edge inflation.
- Suggested caption: Polaris BCF visibly expands the target graph. Screenshot geometry is not an audited block-count measurement.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control_flow7_polaris_clean_to_polaris_bcf_2.jpg

[Open original screenshot](assets/ida/demo_bogus_control_flow7_polaris_clean_to_polaris_bcf_2.jpg)

- Story: 7
- Topic: Polaris BCF
- Likely comparison: Clean left; BCF original right
- Target function: demo_bogus_control_flow
- Type: assembly diff; graph diff; close-up
- Visible content: Clean comparisons use 1337h, 12340000h and parity/low-byte tests; the obfuscated pane adds global loads, multiplication, tests and duplicated routes.
- Recommended use: Week 6: distinguish genuine source conditions from injected conditions.
- Suggested caption: Genuine source branches remain among the injected Polaris predicate and clone machinery.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control_flow7_polaris_clean_to_rewritten_1.jpg

[Open original screenshot](assets/ida/demo_bogus_control_flow7_polaris_clean_to_rewritten_1.jpg)

- Story: 7
- Topic: Polaris BCF
- Likely comparison: Clean left; proof-driven rewrite right
- Target function: demo_bogus_control_flow
- Type: overview CFG; graph diff
- Visible content: The rewritten graph still has much more structure than the clean comparator.
- Recommended use: Week 8: discuss residual overhead and graph non-identity.
- Suggested caption: The working Polaris rewrite is not graph-identical to the clean compiler output.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_bogus_control_flow7_polaris_clean_to_rewritten_2.jpg

[Open original screenshot](assets/ida/demo_bogus_control_flow7_polaris_clean_to_rewritten_2.jpg)

- Story: 7
- Topic: Polaris BCF
- Likely comparison: Clean left; proof-driven rewrite right
- Target function: demo_bogus_control_flow
- Type: assembly diff; graph diff; close-up
- Visible content: Clean source decisions contrast with remaining global predicate arithmetic and unconditional transfers in the rewrite.
- Recommended use: Week 8: explain why removed impossible edges do not mean removed calculations.
- Suggested caption: Polaris clean versus rewritten: semantic preservation does not require identical instructions or CFG layout.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_flattening8_1.jpg

[Open original screenshot](assets/ida/demo_flattening8_1.jpg)

- Story: 8
- Topic: Tigress Flatten
- Likely comparison: Single Tigress Flatten original; no before/after pair
- Target function: demo_flattening
- Type: overview CFG; close-up
- Visible content: State storage, indirect switch jump and IDA-recognized switch cases are visible, with edges extending beyond the crop.
- Recommended use: Weeks 9/10: distinguish indirect CFG discovery from symbolic successor recovery.
- Suggested caption: IDA resolves Tigress jump-table edges that the stock research unflattener missed; this is not a successful rewrite.
- Confidence: High for topic/comparison from filename and visible content; exact PE hash not embedded

## demo_flattening8_2.jpg

[Open original screenshot](assets/ida/demo_flattening8_2.jpg)

- Story: 8
- Topic: Tigress Flatten
- Likely comparison: Single Tigress Flatten original; zoomed-out companion to _1
- Target function: demo_flattening
- Type: overview CFG
- Visible content: A wide fan-out/return-to-dispatch shape; opcodes are not readable at this zoom.
- Recommended use: Week 9: topology overview; use retained reference SVG for complete labels.
- Suggested caption: Tigress Flatten overview: many state cases share a dispatcher; the screenshot does not establish exact block counts.
- Confidence: Medium-high: consistent with the detailed companion and supplied mapping; exact binary hash not displayed.
