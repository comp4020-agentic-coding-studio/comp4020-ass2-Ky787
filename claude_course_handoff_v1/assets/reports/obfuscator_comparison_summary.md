# Cross-obfuscator comparison summary

## Scope

This is the concise synthesis after validating OLLVM-16, Hikari, Polaris, Tigress 4.0.11, and BinProtect on the showcase research workspace. The implementations operate at different stages, so similarly named passes are controlled analogues rather than identical treatments:

| Tool | Transformation stage | Important consequence |
|---|---|---|
| OLLVM-16 | LLVM IR | Ordinary optimizer/backend can simplify or canonicalize the obfuscation. |
| Hikari | LLVM IR | Same broad exposure to later optimization; some legacy IR serialization issues exist. |
| Polaris | LLVM IR plus a separate X86 MIR/backend lane | IR passes can simplify; backend-obfu survives directly into machine code. |
| Tigress | C source | Compiler and selected frontend environment materially affect generated code and compatibility. |
| BinProtect | linked PE machine code | No compiler optimizer follows the transformation, but full-image rewriting must preserve Windows PE/runtime semantics itself. |

## Arithmetic substitution and MBA

| Tool/treatment | Measured behavior | Optimization/reproducibility lesson | Current disposition |
|---|---|---|---|
| OLLVM SUB | At O0, all 8 XOR, 8 ADD, and 8 SUB source-intended sites are transformed in IR with multiple template shapes. Instruction selection already recovers recognizable native operations, and O1+ recovers all 24 target machine operations. | Rich IR does not imply rich final machine code. | Keep as the canonical optimizer-canonicalization example. |
| Hikari SUB | O0 default probability rewrites only a subset (2/8 XOR, 4/8 ADD, 6/8 SUB); O1 removes the measured target effect. | Coverage probability and optimizer survival must be reported separately. | Keep O0 only, with qualified coverage. |
| Polaris SUB | O0 rewrites 8/8 XOR, 8/8 ADD, and 3/8 SUB; O1+ largely returns native target operations. | Deterministic in the validated sample but weak high-optimization machine survival. | Keep O0 as a distinct template family. |
| Polaris Linear MBA | All 24 O0 sites expand; every site in each operator family had a distinct recorded operator tree, reaching 678 target machine instructions. | Strongest validated LLVM-family arithmetic treatment; output varied despite the requested LLVM seed. | Keep as an advanced high-diversity arithmetic case. |
| Tigress EncodeArithmetic | Source generation rewrites all 24 sites with multiple C-level templates; substantial machine complexity survives MSVC through `/Ox`. | Source-level treatment survives conventional optimization better than the tested LLVM SUB passes, though compilers lower it differently. | Keep with fixed settings and retained generated C. |
| BinProtect Linear | O0 target coverage is 0/24; O2 is 24/24. O2 uses one additive-split semantic template with 24 distinct random pairs and grows 106→943 instructions. | O0's indexed stack operands trigger the frame-rewrite conflict/skip path; O2 uses fixed offsets. No user seed; output is non-deterministic. | Static study only: both outputs crash. |
| BinProtect MBA | O0 target coverage is 0/24; O2 is 24/24. O2 shows one XOR, three ADD, and three SUB identities and grows 106→381 instructions. | Machine-level identities fully persist because nothing follows them; recognizable constants also persist. | Static study only: both outputs crash. |

The key methodological distinction is now concrete: “transformed in IR/source” and “complex in final machine code” are different measurements. BinProtect demonstrates the maximum persistence expected from post-link insertion, but persistence is not useful without a correct executable.

## Bogus and opaque control flow

| Tool/treatment | Predicate and bogus-region design | Survival/result |
|---|---|---|
| OLLVM BCF | Algebraic `x*(x+1) mod 2`-style guards, cloned real regions, bogus successors. | Largest validated LLVM BCF at O0 (59 machine blocks/84 edges). Most structure disappears at O2, but a small opaque-loop residue survives. |
| Hikari BCF | Similar cloned IR topology, often guarded by literal-true comparisons. | Backend folds much of it at O0; O1+ matches the clean target. Its exact O0 serialized IR also has legacy mixed-pointer spelling that cannot be reparsed by Clang 15. |
| Polaris BCF | Algebraic predicates plus cloned regions. | Strong O0 structure (46 machine blocks/65 edges), but O1+ matches clean in the measured target. |
| Tigress AddOpaque | Source-visible entropy/opaque arrays and pointer relations guard real statements; the conservative test used `Kinds=true`, not fake/junk blocks. | Survives through high MSVC optimization and remains structurally distinct. |
| BinProtect Opaque | Every eligible machine block is copied; the copy's operands are shuffled; a randomized three-variable Fermat-style power predicate and explicit saved-ZF handling route to the real block. | O0 target grows 11→36 blocks and 39→496 instructions; O2 grows 3→10 and 19→141. O0 crashes and O2 hangs. |

Bogusness should continue to be attributed from construction/provenance, not merely from a path not being observed dynamically. BinProtect provides especially clear provenance because its source explicitly creates and operand-shuffles each copy.

## Control-flow flattening

| Tool/treatment | Dispatcher representation | Optimization/result |
|---|---|---|
| OLLVM FLA | Randomized integer state and LLVM `switch` loop. | Survives essentially intact through O3; strongest validated high-optimization LLVM flattener. |
| Hikari FLA | State/switch layout similar in family but different in details. | Also survives strongly through O3. |
| Polaris FLA | LLVM state/switch dispatcher with fewer blocks than OLLVM/Hikari. | Roughly half the O0 structure is simplified by O2/O3, but the target remains clearly flattened. |
| Tigress Flatten | Source `while (1)` plus state and `switch`. | Survives; backend lowering varies. MSVC O0/O2 may use an indirect jump, while another level/compiler may use direct comparisons. |
| BinProtect CFF | Random 16-bit state in a selected GPR, a linear `cmp`/`jnz` chain, direct jumps to semantic blocks, transition stubs back to the anchor, and an unmatched-state `int3`. | No indirect dispatch. O0 grows 19→81 blocks; O2 7→28. Both crash. |

Absence of an indirect branch is not evidence that flattening disappeared. OLLVM-family sparse switches, Tigress compiler lowering, and BinProtect's design can all yield direct comparison networks for different reasons.

## Other notable transformations

- Hikari SPLIT creates substantial IR fragmentation at O0, but the backend coalesces most machine-level boundaries. It remains an optional teaching lane, not a primary treatment.
- Polaris indirect branches replaces direct CFG edges with block-address-table dispatch and worked deterministically in validation.
- Polaris indirect calls and global/string encryption worked on the Windows smoke test; global encryption is module-wide rather than function-selective.
- Polaris X86 backend/MIR `backend-obfu` materially injects junk arithmetic, flag operations, stack-address disguising, and `rdrandq` after IR. It is non-deterministic and best treated as an advanced stress test.
- BinProtect virtualization was intentionally not tested. It defaults on, which is why every controlled BinProtect command must explicitly set `--vm 0` along with every other pass value.

## Cross-cutting conclusions

1. Optimization level is part of the treatment, not merely a build setting. It can erase IR obfuscation, change source-obfuscation lowering, and—even for BinProtect—change which machine instructions a pass recognizes.
2. Flattening is the most consistently durable structural family across the working compiler-integrated tools.
3. Tigress EncodeArithmetic and Polaris MBA retain the most useful validated arithmetic complexity in executable samples.
4. BinProtect proves that post-link insertion can preserve very large machine-level expansions, but this build's 0/8 semantic result prevents any claim of practical superiority.
5. Seeds must be evaluated empirically. A visible seed option does not guarantee byte reproducibility, and BinProtect exposes no seed at all.
6. Symbol scope matters: annotation-only targeting did not activate the tested SUB pass in either the Hikari or OLLVM-16 pilot. Their retained showcase matrices therefore use global switches, not validated function-local isolation. Hikari uses `-mllvm -enable-subobf`, `-mllvm -enable-bcfobf`, `-mllvm -enable-cffobf`, and `-mllvm -enable-splitobf`. Target-function measurements remain isolated, but other eligible functions may also be transformed. Polaris IR pipeline-plus-annotation selection and Tigress `--Functions` work in their validated lanes (Polaris `gvenc` remains module-wide). Current BinProtect also globally processes discovered functions/blocks, including runtime code. See `docs/showcase_matrix_v1.md`, "Selective targeting result"; this is a finding about the tested compilers, not a universal claim about annotation support.

The new BinProtect measurements use PE unwind ranges and clean MAP boundaries, and explicitly exclude adjacent non-exported functions. The previous matrix's MSVC O2 arithmetic count of 228 was based on a next-export span; the newly verified `demo_substitution` itself contains 106 instructions. Prior matrix artifacts remain intact, but exact cross-tool machine-size rankings and ratios based on the old extractor need a boundary audit before publication. The qualitative pass designs and recorded runtime outcomes above do not depend on that overcount.

## Recommended controlled-corpus core

- Arithmetic: OLLVM SUB O0 plus an optimized canonicalization case; Polaris MBA O0; Tigress EncodeArithmetic at controlled optimization levels.
- Opaque/BCF: OLLVM BCF O0 and its high-optimization residue; Polaris BCF O0; Tigress AddOpaque across optimization levels.
- Flattening: OLLVM, Hikari, Polaris, and Tigress individual FLA/Flatten conditions with optimization recorded.
- Advanced side lanes: Polaris indirect branches and backend/MIR.
- BinProtect: retain Opaque O0, CFF O0, MBA O2, and Linear O2 for static/manual analysis only. Exclude all current outputs from runnable corpus claims until semantic correctness is fixed and revalidated.

## Questions for the deobfuscation phase

1. Can msynth or another equality-saturation/synthesis workflow normalize OLLVM, Hikari, Polaris, Tigress, and BinProtect arithmetic without per-tool templates?
2. Can one symbolic opaque-predicate solver handle OLLVM's parity construction, Polaris algebraic guards, Tigress runtime opaque state, and BinProtect's Fermat/ZF construction?
3. Can OLLVM-focused unflatteners transfer to Hikari, Polaris, Tigress, or BinProtect when dispatcher lowering changes from switch/indirect form to direct comparison chains?
4. Does lifting BinProtect output back to a sound IR recover ordinary simplification opportunities for its additive splits, MBA identities, opaque predicates, and dispatcher stubs?
5. Which observed failures arise from transformation semantics, which from frontend/optimizer/backend representation, and which from binary discovery/recompilation defects?
6. How should analysis distinguish genuine semantic blocks from cloned/shuffled bogus copies without relying on one dynamic trace?
7. Can normalized structural metrics predict manual-analysis difficulty better than raw PE or instruction size?
8. How much cross-seed diversity survives normalization, and can deobfuscators generalize to unseen templates/constants rather than memorizing one build?
