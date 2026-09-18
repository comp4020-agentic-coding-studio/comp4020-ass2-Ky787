# Showcase matrix v1: cross-obfuscator O0 comparison

Validation date: 2026-09-17 (Australia/Sydney).

## Outcome and scope

The first comparative dataset is complete under `results\showcase_matrix_v1`. The frozen `src\showcase.c` hash was checked before every scripted build and remained:

`39FEF0BB2A9742870F3D6F7CC864F7CFFA129136F6D2A59C4FB37F25906B99D2`

Neither `src\showcase.c` nor `src\SHOWCASE_VERSION.txt` was modified. The dataset contains 68 planned build conditions. All 68 linked as PE x64, executed, printed `SHOWCASE PASS`, and returned exit code `0`. No BinProtect, virtualization, combined transformations, or Polaris backend/MIR pass was used.

Hikari BCF O0 is a qualified success: the pass emitted exact post-pass textual IR, but that text contains legacy mixed-pointer spelling such as `ptr*`, which Clang 15 rejects when reparsed. Direct source-to-object and source-to-assembly compilation with the same pass arguments works, is same-seed deterministic in this probe, and produces the passing executable. Both the malformed exact IR and the direct-path artifacts are retained.

One transient endpoint-security event occurred on the first attempt to start Polaris FLA O0. No protection setting was changed and no bypass was attempted. An unchanged rerun and later full runs passed. Details are in `results\showcase_matrix_v1\summaries\endpoint_security_events.md`.

## Toolchains

| Family | Compiler used for the family baseline and obfuscated builds | Identity | SHA-256 |
|---|---|---|---|
| OLLVM-16 | `D:\VM_Shared_Folder\software\ollvm\original_ollvm\clang.exe` | wwh1004 OLLVM-16, Clang 16.0.6, LLVM revision `7cbf1a2591520c2491aa35339f227775f4d3adf6` | `0D0392508AF664396606F4E006922E57573690272A4E5A39F7E60E6543B710BE` |
| Hikari | `D:\VM_Shared_Folder\software\ollvm\for_website\hikari15\build-vs-patched\Release\bin\clang.exe` | Hikari LLVM15 revision `021f73404e4b0bd1ea05c7226953cab8d9801c7a` | `E968913828CBCE9D64CED8FD23F90A68B5CA176276B35FD2BC6D379CC031EDF1` |
| Polaris | `E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe` | Polaris Clang 16.0.6 | `88DC08535F71EFD84B3BFACE00080CF5BCA56DC47ADF6DD50FC4293568E50D10` |
| Tigress lane | `E:\Visual Studio\VC\Tools\MSVC\14.51.36231\bin\Hostx64\x64\cl.exe` | Tigress 4.0.11 MSVC-environment C, then MSVC 19.51.36248 x64 | `DC8426B8760D92CF757DF3D10B9F0244A95B454FF43194A58161568A0EC70D53` |

The full version output is retained in `summaries\compiler_inventory.json`.

## Build method and evidence model

LLVM-family builds use a generated wrapper that defines only the requested `OBF_*` macro and includes the frozen source. The frontend emits post-pass LLVM IR once at the requested optimization level. Object and assembly are then generated from that exact IR with `-Xclang -disable-llvm-passes`, preventing a second middle-end run. The exception is the documented Hikari BCF O0 textual-IR limitation above.

Tigress generated one exact C file per transformation with seed `424242`; that same file was compiled at MSVC O0, O1, O2, and the MSVC maximum-optimization analogue `/Ox` recorded as O3. `AddOpaque` used an include-only wrapper to provide its documented `<stdlib.h>`/`malloc` declaration without touching the frozen source.

Every build directory contains command, stdout, stderr, exit, duration, metadata, executable, hashes, PDB/MAP, compiler listing, exact-PE disassembly, PE inspection, and extracted target-function evidence. Machine CFG counts are explicitly reconstructed from the target's exact-PE disassembly; they are not mixed with LLVM IR blocks.

## Selective targeting result

Annotation-only pilots were run before enabling global fallback.

- OLLVM-16 `annotate("sub")` compiled but did not transform the annotated target. Its legacy annotation reader did not recognize the opaque-pointer annotation representation emitted by this frontend. The matrix therefore uses the documented global `-mllvm -sub`, `-bcf`, and `-fla` switches. Target-function measurements remain isolated, but other program functions may also be transformed.
- Hikari `annotate("sub")` likewise compiled without transforming the target, so the matrix uses global `-enable-subobf`, `-enable-bcfobf`, `-enable-cffobf`, and `-enable-splitobf`. O0 alone adds `-Xclang -disable-O0-optnone`.
- Polaris selective targeting works: the suffix annotations `substitution`, `boguscfg`, `flatten`, `linearmba`, and `indirectcall` work with their respective `-mllvm -passes=...` pipelines. `gvenc` is correctly treated as module/data-wide.

The pilot IR files are under `results\showcase_matrix_v1\pilot`.

## O0 comparison

### Substitution and arithmetic encoding

| Condition | IR instructions | Machine instructions | Target bytes | Site-level result |
|---|---:|---:|---:|---|
| Clean LLVM-family O0 | 155 | 115 | 467 | Eight native XOR, ADD, and SUB sites |
| OLLVM SUB O0 | 337 | 311 | 1,186 | All 8/8/8 transformed in IR; 2 XOR, 4 ADD, and 3 SUB IR template shapes |
| Hikari SUB O0 | 245 | 213 | 808 | Default pass probability transformed XOR 2/8, ADD 4/8, SUB 6/8; 2/2/3 non-native shapes |
| Polaris SUB O0 | 282 | 227 | 836 | XOR 8/8, ADD 8/8, SUB 3/8 transformed; 2/4/1 non-native shapes |
| Polaris MBA O0 | 626 | 678 | 2,750 | All 8/8/8 expanded; all eight sites in each operator family had distinct recorded operator trees |
| Tigress EncodeArithmetic O0 | n/a (source transform) | 426 | 1,698 | Generated C transformed all 8/8/8 sites with 3 XOR, 5 ADD, and 3 SUB templates |

LLVM IR template classification follows each volatile store's SSA dependency tree and normalizes constants/SSA names while retaining operator structure. The machine summary conservatively counts visible native-immediate instructions; it does not falsely claim source-site provenance from a coincidental instruction.

Polaris MBA is qualitatively stronger than Polaris SUB at O0: it expands the target from 115 to 678 machine instructions and gives every tested site a distinct IR tree. Its `-rng-seed=123456` is not sufficient for reproduction: two fresh same-command IR generations had different SHA-256 hashes. The exact dataset IR, assembly, and PE are therefore authoritative.

### Bogus/opaque control flow

The clean O0 LLVM baseline is confirmed at 11 IR blocks, 14 IR edges, and four conditional branches.

| Condition | IR blocks/edges | Machine blocks/edges | Machine instructions | Observed construction |
|---|---:|---:|---:|---|
| Clean LLVM O0 | 11 / 14 | 11 / 14 | 39 | Four genuine source conditions |
| OLLVM BCF O0 | 44 / 69 | 59 / 84 | 407 | Algebraic `x*(x+1) mod 2`-style opaque tests, cloned real regions, and bogus successors; `bcf_prob=100`, `bcf_loop=1` |
| Hikari BCF O0 | 44 / 69 | 15 / 18 | 99 | IR cloning guarded largely by literal-true `icmp eq 1, 1`; backend folds much of it even at O0 |
| Polaris BCF O0 | 35 / 54 | 46 / 65 | 266 | Algebraic opaque predicates and cloned regions, fewer blocks than OLLVM at this setting |
| Tigress AddOpaque O0 | source: 8 `if` tokens | 16 / 22 | 106 | Three explicit runtime opaque guards plus the four genuine conditions and one Tigress initialization guard |

`AddOpaqueKinds=true` guards real statements; it does not use Tigress `fake` or `junk`, so the report does not mislabel every untaken path as a fake block. Likewise, LLVM bogus-block counts are not inferred merely from non-execution: provenance is based on pass-introduced predicate/clone regions, while the numeric report uses total blocks and edges.

### Flattening

| Condition | IR blocks/edges | Machine blocks/edges | Machine instructions | Dispatcher observation |
|---|---:|---:|---:|---|
| Clean LLVM O0 | 16 / 21 | 21 / 26 | 68 | Structured branch, loop, and semantic switch |
| OLLVM FLA O0 | 23 / 41 | 58 / 76 | 189 | Stack state variable, randomized integer states, LLVM `switch` dispatcher |
| Hikari FLA O0 | 25 / 45 | 64 / 84 | 201 | Same broad switch/state pattern with a different state layout |
| Polaris FLA O0 | 20 / 38 | 54 / 72 | 164 | Switch/state dispatcher; fewer IR blocks and edges than OLLVM/Hikari |
| Tigress Flatten O0 | source: 2 switches, one `while (1)` | 39 / 46 | 121 | Source-level state variable and dispatcher; MSVC O0 lowers it with one indirect branch |

Real semantic regions remain recognizable as dispatcher cases in all four implementations. A missing machine indirect jump is not treated as evidence that flattening disappeared: the LLVM backends often lower these sparse randomized states to comparison/direct-branch networks.

## Other O0 lanes

### Hikari SPLIT

Against Hikari's clean `demo_flattening` O0 target, SPLIT changes IR from 16 blocks/21 edges/69 instructions to 45 blocks/50 edges/98 instructions. At machine level it changes 21 blocks/26 edges/68 instructions to only 22 blocks/27 edges but 137 instructions. The effect is predominantly trivial IR fragmentation/fallthrough chains rather than new semantics; the backend coalesces most split boundaries. It does not justify a full four-level matrix yet.

### Polaris indirect calls

The clean target has three direct calls. Polaris changes all three to indirect calls in IR and in PE machine code. Each call loads an encoded pointer from a generated global, converts it through integer form, subtracts a per-call offset (`18467`, `26500`, or `15724`; machine immediates `0x4823`, `0x6784`, `0x3D6C`), then executes `callq *%rax`. The target retains 0 direct and 3 indirect calls.

### Polaris global encryption

In the clean Polaris O0 PE, both marker strings and the complete table byte sequence are present once. In the `gvenc` PE all are absent:

- `OBFUSCATION-DEMO-ALPHA-1337`: absent;
- `OBFUSCATION-DEMO-BRAVO-12345678`: absent;
- `37 13 00 00 78 56 34 12 11 11 11 11 22 22 22 22`: absent.

The target retains 13 IR blocks/15 edges, but grows from 66 to 81 IR instructions and adds six direct IR calls associated with global decoding/initialization. Exact byte-search evidence is in `summaries\global_encryption_visibility.json`.

## Seeds and reproducibility

Fresh same-command IR repeats were byte-identical for OLLVM SUB with its AES seed, Hikari SUB with `aesSeed=123456`, and Polaris SUB with `rng-seed=123456`. Hikari BCF O0 direct object and assembly repeats were also identical. Polaris MBA repeats differed despite the supplied RNG seed, confirming that the exact retained artifact—not source plus seed—is the reproducibility unit for that pass.

Tigress's broader seed limitations remain as documented in `docs\tigress_validation.md`: archive exact generated C rather than relying on seed reconstruction. This matrix correctly reuses one exact generated C per transformation across all MSVC optimization levels.

## Dataset and metric files

- Build inventory: `results\showcase_matrix_v1\summaries\all_builds.{csv,json}`
- IR/machine/source metrics: `optimization_metrics.{csv,json}`
- CFG-only projection: `cfg_metrics.{csv,json}`
- Site classifications: `substitution_sites.{csv,json}`
- Integrity and completion: `integrity_summary.json`, `run_summary.json`
- Recommended manual cases: `results\showcase_matrix_v1\MANUAL_ANALYSIS_INDEX.md`

The per-function byte size ends at the final return and excludes objdump alignment padding. Machine blocks and edges are static reconstructions from direct branches within the exported target. An indirect branch contributes one unresolved successor edge, so machine CFG edge counts are conservative where jump tables occur.

## Recommendation for the course dataset

Keep optimization level as a first-class variable. In particular, teach BCF with explicit O0-versus-O2 counterexamples, because Hikari and Polaris BCF vanish by O1 while OLLVM leaves a small residual opaque loop. Teach flattening as the robust structural family: OLLVM and Hikari survive strongly through O3; Polaris and Tigress simplify but remain recognizably flattened. For arithmetic, contrast IR/source survival with backend canonicalization: OLLVM and Polaris SUB retain complex IR but mostly native machine operations at O1+, while Tigress EncodeArithmetic and Polaris MBA retain substantial machine-level complexity.

No course phase should assume annotations are selective in the current OLLVM/Hikari binaries. Label those datasets as global-pass builds or repair the legacy annotation reader before claiming function-local isolation. Do not advance automatically to BinProtect.
