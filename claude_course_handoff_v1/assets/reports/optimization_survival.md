# Optimization survival in showcase matrix v1

## Executive finding

Optimization level is not a nuisance variable; it changes the experimental treatment. The most severe loss occurs in Hikari and Polaris BCF, both of which are indistinguishable from their same-family clean target by O1 in the recorded IR and machine metrics. Hikari SUB also disappears by O1. Flattening is the most durable family: OLLVM and Hikari keep essentially their complete dispatcher CFG through O3, while Polaris and Tigress retain a smaller but still obvious dispatcher.

All values below are target-function measurements. LLVM IR and reconstructed PE machine CFGs are kept separate.

## SUB and arithmetic survival

### Size trajectory

| Family/condition | O0 IR instructions | O1 | O2 | O3 | O0 machine instructions | O1 | O2 | O3 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Clean LLVM baseline | 155 | 128 | 128 | 128 | 115 | 51 | 51 | 51 |
| OLLVM SUB | 337 | 312 | 312 | 312 | 311 | 71 | 71 | 71 |
| Hikari SUB | 245 | 128 | 128 | 128 | 213 | 51 | 51 | 51 |
| Polaris SUB | 282 | 267 | 267 | 267 | 227 | 71 | 71 | 71 |
| Tigress clean/MSVC | n/a | n/a | n/a | n/a | 249 | 217 | 228 | 106 |
| Tigress EncodeArithmetic/MSVC | n/a | n/a | n/a | n/a | 426 | 483 | 503 | 226 |

OLLVM SUB preserves non-native IR trees at every optimization level, but instruction selection recovers all eight immediate XOR and SUB operations even at O0 and all 24 target operations by O1. The 71-versus-51 instruction residue at O1+ comes from other globally transformed arithmetic in the target, not survival of the 24 requested immediate sites.

Hikari SUB is partially probabilistic at O0—XOR 2/8, ADD 4/8, and SUB 6/8 transformed—but its O1/O2/O3 IR and machine target are identical in the recorded metrics to clean. This is complete treatment loss for the requested sites.

Polaris SUB transforms XOR 8/8, ADD 8/8, and SUB 3/8 at O0. At O1+ its post-pass IR remains structurally non-native for XOR/ADD and five SUB sites, yet the backend selects native immediate operations for all target sites. It is therefore an excellent example of IR obfuscation surviving while machine-code diversity collapses.

Tigress generated C transforms all 24 sites before MSVC. Its generated-source template counts remain fixed at XOR 3, ADD 5, and SUB 3 because the same source is reused. At machine level, visible native-immediate instruction counts are:

| Optimization | XOR | ADD | SUB | Target instructions vs clean |
|---|---:|---:|---:|---:|
| O0 | 0 | 0 | 5 | 426 vs 249 |
| O1 | 0 | 0 | 0 | 483 vs 217 |
| O2 | 0 | 2 | 5 | 503 vs 228 |
| O3 (`/Ox`) | 0 | 2 | 5 | 226 vs 106 |

These are conservative native-immediate instruction counts, not a claim that every matching instruction maps one-to-one to a source site. The retained generated source provides the actual site provenance. Even at `/Ox`, the target remains about 2.1 times the clean machine-instruction count, so EncodeArithmetic survives conventional MSVC optimization better than the LLVM SUB implementations do at final machine level.

Polaris MBA O0 is the strongest arithmetic case in this pass: all 24 sites are transformed, every site has a distinct normalized operator tree, and the target reaches 626 IR and 678 machine instructions. It is intentionally not in the four-level matrix, and its output is nondeterministic despite `rng-seed=123456`.

## BCF and opaque-control-flow survival

| Family | Metric | O0 | O1 | O2 | O3 | Clean comparison at same level |
|---|---|---:|---:|---:|---:|---|
| OLLVM BCF | IR blocks/edges | 44/69 | 7/9 | 3/3 | 3/3 | 11/14, 1/0, 1/0, 1/0 |
| OLLVM BCF | machine blocks/edges | 59/84 | 7/9 | 5/6 | 5/6 | 11/14, 1/0, 1/0, 1/0 |
| Hikari BCF | IR blocks/edges | 44/69 | 1/0 | 1/0 | 1/0 | 11/14, 1/0, 1/0, 1/0 |
| Hikari BCF | machine blocks/edges | 15/18 | 1/0 | 1/0 | 1/0 | 11/14, 1/0, 1/0, 1/0 |
| Polaris BCF | IR blocks/edges | 35/54 | 1/0 | 1/0 | 1/0 | 11/14, 1/0, 1/0, 1/0 |
| Polaris BCF | machine blocks/edges | 46/65 | 1/0 | 1/0 | 1/0 | 11/14, 1/0, 1/0, 1/0 |
| Tigress AddOpaque | machine blocks/edges | 16/22 | 11/16 | 11/15 | 11/15 | 11/14, 3/3, 3/3, 3/3 |

OLLVM is the only LLVM BCF implementation here with a persistent high-optimization residue. By O2/O3, most clones are gone, but an algebraic opaque predicate remains around the real single-block computation and a false successor is an infinite loop. The resulting 3-block IR/5-block machine target is much smaller than O0 but not clean.

Hikari's O0 serialized IR has the same 44/69 topology as OLLVM, but many guards are literal `icmp eq i32 1, 1`. Backend folding reduces it to 15 machine blocks at O0, and ordinary O1 removes the pass entirely. The O0 textual-IR pointer-spelling defect is a separate serialization limitation, not a semantic failure.

Polaris O0 produces 35/54 IR and 46/65 machine topology with algebraic opaque predicates and cloned regions. O1 and above are exactly the clean target in the measured structure. Its BCF should not be used as a high-optimization treatment without changing pass order or protecting the opaque dependencies.

Tigress starts from source-level runtime entropy/opaque arrays and three explicit `AddOpaqueKinds=true` guards. Optimization reduces O0 from 16 to 11 machine blocks, but the O1-O3 results remain far larger than the corresponding clean target and keep six conditional branches versus one clean branch. It survives best among the BCF/opaque lanes, though it is not implementation-equivalent to LLVM BCF and uses no `fake`/`junk` kind.

## Flattening survival

| Family | IR blocks/edges O0 → O1 → O2 → O3 | Machine blocks/edges O0 → O1 → O2 → O3 | Result |
|---|---|---|---|
| OLLVM FLA | 23/41 → 22/40 → 22/40 → 22/40 | 58/76 → 53/82 → 53/82 → 53/82 | Dispatcher survives essentially intact |
| Hikari FLA | 25/45 → 24/44 → 24/44 → 24/44 | 64/84 → 52/79 → 52/79 → 52/79 | Dispatcher survives essentially intact |
| Polaris FLA | 20/38 → 11/20 → 10/18 → 10/18 | 54/72 → 23/34 → 20/29 → 20/29 | Roughly half the structure removed, but still far above clean |
| Tigress Flatten | source fixed at 2 switches/one dispatcher loop | 39/46 → 44/63 → 25/28 → 25/28 | Survives; MSVC changes dispatch lowering |

The same-level clean LLVM target is 16/21 IR blocks/edges at O0, 8/11 at O1, and 6/8 at O2/O3. Thus OLLVM and Hikari O2/O3 remain roughly three to four times the clean block count. Polaris O2/O3 remains at 10/18 versus clean 6/8—simplified, but not de-flattened.

All LLVM variants retain a state variable, randomized state constants, and an LLVM `switch` dispatcher. Their machine forms in this build use comparison/direct-branch networks rather than indirect jumps. That lowering choice does not undo the state machine.

Tigress retains the same 2,942-byte source target at every level, with `_..._next`, `while (1)`, and a dispatcher `switch`. MSVC O0 and O2/O3 use one indirect jump; O1 uses a direct comparison/branch network. O1's lack of an indirect jump is a lowering change, not removal of source-level flattening. O2/O3 reduce the target to 25 machine blocks/28 edges, still well above the clean 7/6 target.

## Most and least durable treatments

Most simplified:

1. Hikari BCF: strong O0 IR, mostly backend-folded at O0, completely clean by O1.
2. Polaris BCF: strong O0, completely clean by O1.
3. Hikari SUB: partial O0 substitution, completely clean by O1.
4. OLLVM/Polaris SUB at machine level: complex post-pass IR remains, but target immediate operations canonicalize substantially or completely.

Best survival:

1. OLLVM and Hikari FLA: essentially stable from O1 through O3.
2. Tigress EncodeArithmetic: exact source treatment persists and `/Ox` remains about 2.1 times clean in machine instructions.
3. Tigress AddOpaque and Flatten: both remain structurally distinct through O3.
4. Polaris FLA: loses substantial structure but retains a dispatcher through O3.
5. OLLVM BCF: only a small residue survives, but it is the sole LLVM BCF residue at O2/O3.

## Interpretation and course impact

The course should distinguish transformation layer from observed layer:

- generated-source diversity for Tigress;
- post-pass IR diversity for LLVM obfuscators;
- final machine-code diversity after backend canonicalization.

It should also include explicit O0/O2 pairs rather than presenting O0 as representative. The sharp Hikari/Polaris BCF collapse is pedagogically valuable, as is the counterexample of robust FLA. The planned high-level course sequence need not be redesigned, but optimization survival should become a dedicated lesson and dataset dimension. Hikari/Polaris BCF at O1+ should not be labeled as an obfuscated binary treatment because no structural treatment remains.

Full values, including instructions, calls, branches, target bytes, PE size, VA/RVA, and artifact paths, are in `results\showcase_matrix_v1\summaries\optimization_metrics.{csv,json}` and `cfg_metrics.{csv,json}`.
