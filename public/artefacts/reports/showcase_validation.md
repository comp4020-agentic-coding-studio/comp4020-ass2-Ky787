# SHOWCASE CORPUS clean validation

Validation date: 2026-09-11 (Australia/Sydney)

Verdict: **READY TO FREEZE AS v1.0**

The clean program compiled and executed successfully with MSVC x64, Visual Studio clang-cl x64, and MSYS2 UCRT64 GCC x64. All three exact PE executables produced identical per-function results, printed `SHOWCASE PASS`, and exited with status 0. An independent PowerShell semantic model using explicit 32-bit wrapping reproduced every embedded `EXPECT_*` value. The intended teaching structures remain sufficiently clear in O0 LLVM IR and machine code.

No obfuscation was performed during this validation. `src\showcase.c` was not modified.

## Source identity

- Source: `E:\Workspace\seeing_through_obfuscation\src\showcase.c`
- Size: 11,781 bytes
- SHA-256: `39FEF0BB2A9742870F3D6F7CC864F7CFFA129136F6D2A59C4FB37F25906B99D2`
- Canonical inputs: `g_input_a = 0x00001337`, `g_input_b = 0x12345678`

The source header still says `draft v0.1`. This is harmless provenance text rather than a semantic or structural defect. The authoritative freeze record is `src\SHOWCASE_VERSION.txt`; changing the comment merely to echo the external version would unnecessarily change the validated source hash.

## Validation artifacts

Disposable artifacts are under `results\showcase_validation`, not the future corpus directory:

- `clean\msvc`, `clean\clangcl`, and `clean\gcc`: exact executables, commands, stdout, stderr, exit codes, SHA-256 files, compiler assembly, exact-PE disassembly, PE headers/exports, and symbol scans;
- `clean\msvc` and `clean\clangcl`: object files, PDBs, MAPs, import libraries, and export files;
- `clean\clangcl\showcase_clangcl.ll`: O0 LLVM IR used for structural checks;
- `analysis`: independently calculated semantics, per-function PE disassembly, instruction counts, call sites, marker offsets, CFG statistics, and DOT CFGs;
- `run_clean_validation.ps1` and `analyze_clean.ps1`: reproducible validation and analysis harnesses.

Every captured native-tool invocation has sibling `_command.txt`, `_stdout.txt`, `_stderr.txt`, and `_exit.txt` files.

## Compiler environment and exact build commands

The Visual Studio lanes imported the existing Community x64 environment with:

```text
"E:\Visual Studio\Common7\Tools\VsDevCmd.bat" -no_logo -arch=amd64 -host_arch=amd64
```

### MSVC x64

Version: Microsoft C/C++ Optimizing Compiler `19.51.36248` for x64.

Compile:

```text
"E:\Visual Studio\VC\Tools\MSVC\14.51.36231\bin\Hostx64\x64\cl.exe" /nologo /TC /c /Od /Ob0 /Zi /FS /Oy- /FAsc /FoE:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\msvc\showcase.obj /FdE:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\msvc\showcase_compile.pdb /FaE:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\msvc\showcase_msvc.asm E:\Workspace\seeing_through_obfuscation\src\showcase.c
```

Link:

```text
"E:\Visual Studio\VC\Tools\MSVC\14.51.36231\bin\Hostx64\x64\link.exe" /NOLOGO E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\msvc\showcase.obj /OUT:E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\msvc\showcase_msvc.exe /MACHINE:X64 /DEBUG:FULL /PDB:E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\msvc\showcase_msvc.pdb /MAP:E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\msvc\showcase_msvc.map /INCREMENTAL:NO /OPT:NOREF /OPT:NOICF /Brepro
```

### Visual Studio clang-cl x64

Version: Clang `22.1.3`, commit `e9846648fd6183ee6d8cbdb4502213fcf902a211`, target `x86_64-pc-windows-msvc`.

Compile:

```text
"E:\Visual Studio\VC\Tools\Llvm\x64\bin\clang-cl.exe" /nologo /TC /c /Od /Ob0 /Zi /FS /Oy- /FAsc /FoE:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\clangcl\showcase.obj /FdE:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\clangcl\showcase_compile.pdb /FaE:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\clangcl\showcase_clangcl.asm E:\Workspace\seeing_through_obfuscation\src\showcase.c
```

Link:

```text
"E:\Visual Studio\VC\Tools\MSVC\14.51.36231\bin\Hostx64\x64\link.exe" /NOLOGO E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\clangcl\showcase.obj /OUT:E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\clangcl\showcase_clangcl.exe /MACHINE:X64 /DEBUG:FULL /PDB:E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\clangcl\showcase_clangcl.pdb /MAP:E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\clangcl\showcase_clangcl.map /INCREMENTAL:NO /OPT:NOREF /OPT:NOICF /Brepro
```

LLVM IR (supplementary analysis artifact, not a separate executable build):

```text
"E:\Visual Studio\VC\Tools\Llvm\x64\bin\clang.exe" -target x86_64-pc-windows-msvc -S -emit-llvm -O0 -gcodeview -fno-inline -Xclang -disable-O0-optnone -o E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\clangcl\showcase_clangcl.ll E:\Workspace\seeing_through_obfuscation\src\showcase.c
```

### MSYS2 UCRT64 GCC x64

Version: `gcc.exe (Rev3, Built by MSYS2 project) 16.2.0`; target output is x86-64 PE/COFF.

Compile and link:

```text
"D:\Programs\msys64\ucrt64\bin\gcc.exe" -std=c11 -O0 -g3 -fno-inline -fno-omit-frame-pointer -fno-toplevel-reorder -Wall -Wextra E:\Workspace\seeing_through_obfuscation\src\showcase.c -o E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\gcc\showcase_gcc.exe -Wl,-Map,E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\gcc\showcase_gcc.map,--no-insert-timestamp
```

Compiler assembly:

```text
"D:\Programs\msys64\ucrt64\bin\gcc.exe" -std=c11 -O0 -g3 -fno-inline -fno-omit-frame-pointer -fno-toplevel-reorder -S -masm=intel -fverbose-asm E:\Workspace\seeing_through_obfuscation\src\showcase.c -o E:\Workspace\seeing_through_obfuscation\results\showcase_validation\clean\gcc\showcase_gcc.s
```

All compilation and link stderr files are empty. MSVC's normal compile stdout contains only `showcase.c`; GCC and clang-cl compile stdout are empty.

## Clean PE results

`llvm-readobj` reports `COFF-x86-64`, architecture `x86_64`, and `IMAGE_FILE_MACHINE_AMD64 (0x8664)` for all three executables.

| Compiler | PE size | SHA-256 | Exit | Semantic output |
|---|---:|---|---:|---|
| MSVC | 556,032 bytes | `352B745D513338649669ED3A1CE105EB1E161B7508D2E159F8CC2A9E1992C560` | 0 | all six expected values; `SHOWCASE PASS` |
| clang-cl | 556,032 bytes | `7724A4661ECBBB7D581E2490B98331EF737DACF721C1BC3D28E868FBFD32CD75` | 0 | all six expected values; `SHOWCASE PASS` |
| GCC | 79,270 bytes | `8A9CE4A853582138FD27DBBD2BCF74A808D8BA63544CEC8333C62BC62A54A6D6` | 0 | all six expected values; `SHOWCASE PASS` |

Exact PE disassembly was made from each linked executable with Visual Studio LLVM `llvm-objdump -d --print-imm-hex`; the GCC lane additionally has GNU `objdump -d -Mintel` output. PE headers and exports were independently captured with `llvm-readobj` and `dumpbin`.

## Independent semantic verification

`results\showcase_validation\analysis\independent_semantics.csv` comes from a separate implementation of each algorithm. It does not compile, include, or call `showcase.c`; every arithmetic operation explicitly wraps to 32 bits.

| Function | Independent result | Embedded `EXPECT_*` | MSVC | clang-cl | GCC |
|---|---:|---:|---:|---:|---:|
| `demo_substitution` | `08080000` | `08080000` | match | match | match |
| `demo_bogus_control_flow` | `6665BBBC` | `6665BBBC` | match | match | match |
| `demo_flattening` | `DBEFFCE7` | `DBEFFCE7` | match | match | match |
| `demo_calls` | `12345F05` | `12345F05` | match | match | match |
| `demo_data` | `57977293` | `57977293` | match | match | match |
| `demo_combined` | `EEBB6D71` | `EEBB6D71` | match | match | match |

The current `EXPECT_*` constants are all correct. There is no compiler disagreement and no undefined signed-overflow dependency; the intended `uint32_t` wrap semantics are preserved.

## Structural validation

### `demo_substitution`

The Clang O0 IR contains exactly the intended static sites:

- eight `xor i32 <value>, 305419896` (`0x12345678`);
- eight `add i32 <value>, 4919` (`0x1337`);
- eight `sub i32 <value>, 4369` (`0x1111`).

They are independent, unrolled source sites, not loop iterations. The same IR also contains eight initialization `add` operations and seven final-aggregation `xor` operations; there are no other IR `sub` operations in the function. `getelementptr` instructions perform array addressing and were not miscounted as arithmetic targets.

Exact-PE instruction counts are:

| Compiler | Target XOR `0x12345678` | Target ADD `0x1337` | Target SUB semantic sites | Other XOR | Other ADD | Other SUB |
|---|---:|---:|---:|---:|---:|---:|
| MSVC | 8 direct `xorl` | 8 direct `addl` | 8 direct `subl $0x1111` | 9 | 9 | 1 |
| clang-cl | 8 direct `xorl` | 8 direct `addl` | 8 `addl $0xffffeeef` | 10 | 9 initialization/stack plus 8 lowered SUB sites | 2 |
| GCC | 8 direct `xorl` | 8 direct `addl` | 8 direct `subl $0x1111` | 7 | 9 | 1 |

The “other” arithmetic is explainable: eight source initializers; seven XORs that fold the eight array values; stack allocation/restoration; and MSVC/clang-cl security-cookie bookkeeping. Clang canonicalizes `value -= 0x1111` to addition of the 32-bit two's-complement constant `0xFFFFEEEF` during instruction selection, despite preserving all eight `sub` instructions in LLVM IR. This is a useful documented frontend/backend contrast, not a source defect. For binary-level substitution experiments that require literal `sub $0x1111` targets, use the MSVC clean PE as binprotect's input.

The complete target-site lines are saved per compiler under `analysis\<compiler>\demo_substitution_target_{xor,add,sub}.txt`, and the whole exact function disassemblies are adjacent.

### `demo_bogus_control_flow`

The clean Clang IR has 11 basic blocks, four conditional branches, six unconditional branches, 14 CFG edges, and four obvious reconvergence points. All genuine conditions are direct and readable:

- equality against `0x1337`;
- unsigned comparison against `0x12340000`;
- low-byte mask `0xFF` followed by comparison with `0x37`;
- parity mask/test on `y & 1`.

All three exact PEs preserve those recognizable patterns. MSVC and clang-cl emit the `and $0xff` explicitly; GCC expresses the same low-byte extraction as `movzbl %al,%eax`, followed by `cmp $0x37`. Each machine-code function has 11 identified block leaders, four conditional branches, and two explicit unconditional jumps. The successive if/else regions reconverge cleanly, so this is a strong baseline for later bogus/opaque-CFG comparison.

### `demo_flattening`

The Clang O0 IR visibly retains the intended initial if/else, four-iteration loop (`icmp ult ..., 4`), conditional inside the loop, four-outcome switch, reconvergence, and final XOR with `0xCAFEBABE`.

| View | Basic blocks/leaders | Conditional branches | Unconditional branches/jumps | Switch |
|---|---:|---:|---:|---:|
| Clang O0 IR | 16 | 3 | 11 | one terminator, four outcomes |
| MSVC exact PE | 19 | 6 | 8 | direct compare/branch chain |
| clang-cl exact PE | 21 | 6 | 10 | direct zero/decrement compare chain |
| GCC exact PE | 19 | 7 | 7 | direct decision-tree comparisons |

The PE leader count is a conservative machine-level partition derived from direct branch targets and conditional fall-throughs; clang-cl's zero-distance jumps create two extra trivial leaders. None of the three compilers uses an indirect jump table for this small O0 switch. The clean logic is still easy to reconstruct mentally in every lane: initial parity choice, bounded loop, inner `0x100` test, case chain, and final `0xCAFEBABE` XOR are conspicuous.

The two requested DOT baselines are `analysis\demo_bogus_control_flow_clang_ir_cfg.dot` and `analysis\demo_flattening_clang_ir_cfg.dot`.

### `demo_calls`

All three exact PEs contain one unmistakable direct `call` to each helper, with the symbolized target present in the disassembly:

| Compiler | `step_add_1337` | `step_xor_12345678` | `step_sub_1111` |
|---|---:|---:|---:|
| MSVC | `0x1400015FC` | `0x140001609` | `0x140001616` |
| clang-cl | `0x1400013FC` | `0x140001409` | `0x140001416` |
| GCC | `0x1400017D0` | `0x1400017DD` | `0x1400017EA` |

No helper is inlined. This is a clean baseline for indirect-call transformations.

### `demo_data`

Both marker strings and the entire little-endian four-element table occur exactly once in every PE.

| Compiler | Alpha file offset / VA | Bravo file offset / VA | Table file offset / VA |
|---|---|---|---|
| MSVC | `0x6DB90` / `0x14006F390` | `0x6DBB0` / `0x14006F3B0` | `0x6DBD0` / `0x14006F3D0` |
| clang-cl | `0x6DB90` / `0x14006F390` | `0x6DBB0` / `0x14006F3B0` | `0x6DBD0` / `0x14006F3D0` |
| GCC | `0x2020` / `0x140004020` | `0x2040` / `0x140004040` | `0x2060` / `0x140004060` |

The saved strings-like scans show `OBFUSCATION-DEMO-ALPHA-1337` and `OBFUSCATION-DEMO-BRAVO-12345678` verbatim. The table signature is `37 13 00 00 78 56 34 12 11 11 11 11 22 22 22 22`.

### `demo_combined`

Clang IR has 19 blocks, four conditional branches, 13 unconditional branches, one four-outcome switch, and 25 edges. It retains:

- a direct call to `step_add_1337` and a later two-way choice between the XOR/subtraction helpers;
- the `y & 0xFF == 0x78` branch;
- a three-iteration loop and an inner conditional;
- arithmetic and recognizable constants;
- a four-outcome switch and final `0xDEADBEEF` XOR.

The MSVC, clang-cl, and GCC PE views respectively have 22, 24, and 22 block leaders. This function is mixed enough to be a later stress/showcase target while remaining small and source-correlatable.

## Manual-analysis friendliness

The existing build options and source declarations are sufficient for IDA/x64dbg:

- `DEMO_EXPORT` emits all six `demo_*` functions and all three `step_*` helpers into each PE export directory with their plain C names;
- MSVC and clang-cl produce full linker PDBs (6,205,440 and 6,213,632 bytes) and MAP files; MSVC also emits a compile PDB, while clang-cl retains CodeView information in its object before the linker creates the final PDB;
- GCC retains DWARF/debug information, a MAP file, exported names, and a populated COFF symbol table visible to GNU/LLVM symbol tools;
- `/OPT:NOREF /OPT:NOICF`, `/Ob0`, `DEMO_NOINLINE`, and GCC's no-inline/no-top-level-reorder settings keep function boundaries distinct;
- the marker strings and constants make navigation from data and immediate-value searches straightforward.

No build-option change is required. For final teaching binaries, preserve the exact matching PDB/MAP beside each PE, and do not strip GCC symbols. The MSVC clean PE is the preferred binprotect input because its PDB is supported by binprotect and its eight target subtraction sites are literal `sub` instructions.

## Function-level targeting plan

Subsequent validation supersedes the annotation-only plan below: the Hikari and OLLVM-16 `annotate("sub")` pilots compiled without transforming their targets. The retained showcase matrix uses global switches for both families; Hikari uses `-mllvm -enable-subobf`, `-mllvm -enable-bcfobf`, `-mllvm -enable-cffobf`, and `-mllvm -enable-splitobf`. This section and the later planned-build table record the original proposal, not the final targeting configuration. See `docs/showcase_matrix_v1.md`, "Selective targeting result", and the retained per-case commands. Do not label these Hikari/OLLVM builds as function-isolated.

The empty macros in `showcase.c` are well placed for generated include wrappers. A wrapper may define exactly one macro and then include the canonical file, for example:

```c
#define OBF_BCF __attribute__((annotate("bcf")))
#include "../../../src/showcase.c"
```

This does not duplicate or edit the semantic implementation: the wrapper is generated build metadata whose input is the frozen source hash. Each tool must use its own implementation-correct annotation string.

| Tool | Individual-function mechanism | Plan and limitation |
|---|---|---|
| OLLVM-16 | LLVM global annotation read by `toObfuscate` | Generated include wrapper: `OBF_SUB=annotate("sub")`, `OBF_BCF=annotate("bcf")`, `OBF_FLA=annotate("fla")`; optional split uses `annotate("split")`. Its linked plugin registers the function passes in the pipeline and annotations can enable one function. Do **not** pass global `-mllvm -sub/-bcf/-fla` for selective builds because a true global flag selects every eligible function. Validate annotation-only operation when the matrix begins. |
| Hikari LLVM15 | The same `llvm.global.annotations` model, plus a dummy-call fallback | Generated include wrapper with `sub`, `bcf`, `fla`, or `split`. Avoid global `-mllvm -enable-subobf`, `-enable-bcfobf`, `-enable-cffobf`, and `-enable-splitobf`, which select all eligible functions. The production Hikari checkout/compiler remains untouched. Validate annotation-only operation first. |
| Polaris | Pass-specific annotation plus module pipeline selection | Use `-mllvm -passes=<short-name>` and one wrapper annotation: `sub` + `substitution`; `bcf` + `boguscfg`; `fla` + implementation-correct `flatten`; `mba` + `linearmba`; `indcall` + `indirectcall`; `indbr` + `indirectbr`. The README prose says `flattening`, but source and the validated example require `flatten`. `gvenc` is module-wide and has no function annotation. Backend/MIR requires an inline `asm("backend-obfu")` in the function body, so a deterministic generated copy must inject that one statement into the selected body; the existing suffix macros cannot express a body statement. |
| Tigress | Native `--Functions=<exact-name>` selector on each transform | Apply `EncodeArithmetic` to `demo_substitution`, `AddOpaque` to `demo_bogus_control_flow`, and `Flatten` to `demo_flattening`. `AddOpaque` retains its required `InitEntropy` and `InitOpaque` setup. Generate separate MSVC- and GCC-environment C, as established in `docs\tigress_validation.md`, and compile clang-cl from the MSVC-environment output. |
| binprotect | None in the present CLI/source | All enabled passes iterate all discovered functions or all eligible basic blocks; PDB/MAP input improves discovery but is not a selector. For strict one-function experiments, prefer a small tool-side `--function <symbol-or-RVA>` allowlist enhancement. Without changing binprotect, generate a target-only PE (target function, required helpers/data, and a tiny semantic driver) from the frozen canonical source and apply one globally enabled pass. A single full showcase PE cannot keep non-target functions clean with the current tool. |

Polaris `gvenc` should be treated as a module/data lane. If isolation beyond the current module-wide behavior is required, mechanically generate a dedicated `demo_data` translation unit plus a clean remainder from the single frozen source, then link them; do not fork the semantic implementation by hand.

For Polaris backend/MIR, retain the exact generated-source diff and hash. That lane is advanced because prior validation found non-deterministic, time-seeded machine rewriting, `rdrandq`, and possible endpoint-security/disassembler sensitivity.

## Source-design problems and fixes

No semantic or structural source change is recommended.

The only noteworthy compiler difference is clang-cl's assembly-level canonicalization of the eight `- 0x1111` sites into `+ 0xFFFFEEEF`. Because the IR keeps eight distinct `sub` sites, MSVC/GCC keep literal `sub` instructions, and the principal OLLVM-family substitutions operate on IR, changing the C spelling is neither necessary nor likely to force a different Clang lowering. It should remain documented rather than patched.

The version-comment mismatch is also intentionally left alone: `SHOWCASE_VERSION.txt` is the freeze authority for the already validated hash.

## Proposed first individual-transform matrix — do not run yet

Every row is a separate build. No transformation combinations are proposed except Tigress's mandatory opaque-state initializers. Every generated wrapper/source, command, seed, compiler hash, IR, assembly, PE, symbols, runtime output, and artifact hash should be retained.

| Family | Variant | Intended target | Selection |
|---|---|---|---|
| Clean | MSVC, clang-cl, GCC | all clean | validated baselines above |
| OLLVM-16 | SUB | `demo_substitution` | wrapper `annotate("sub")`; no global enable flag |
| OLLVM-16 | BCF | `demo_bogus_control_flow` | wrapper `annotate("bcf")`; no global enable flag |
| OLLVM-16 | FLA | `demo_flattening` | wrapper `annotate("fla")`; no global enable flag |
| Hikari | SUB | `demo_substitution` | wrapper `annotate("sub")`; no global enable flag |
| Hikari | BCF | `demo_bogus_control_flow` | wrapper `annotate("bcf")`; no global enable flag |
| Hikari | FLA | `demo_flattening` | wrapper `annotate("fla")`; no global enable flag |
| Hikari | SPLIT, optional separate lane | `demo_flattening` | wrapper `annotate("split")`; no global enable flag |
| Polaris | SUB | `demo_substitution` | `-passes=sub` + `annotate("substitution")` |
| Polaris | BCF | `demo_bogus_control_flow` | `-passes=bcf` + `annotate("boguscfg")` |
| Polaris | FLA | `demo_flattening` | `-passes=fla` + `annotate("flatten")` |
| Polaris | MBA | `demo_substitution` | `-passes=mba` + `annotate("linearmba")` |
| Polaris | indirect calls | `demo_calls` | `-passes=indcall` + `annotate("indirectcall")` |
| Polaris | global encryption | `demo_data` data/module | `-passes=gvenc`; module-wide or generated data TU |
| Polaris | backend/MIR, advanced | `demo_combined` | generated body marker `asm("backend-obfu")`; no IR pass required |
| Tigress | EncodeArithmetic | `demo_substitution` | `--Transform=EncodeArithmetic --Functions=demo_substitution` with controlled builtin settings |
| Tigress | AddOpaque | `demo_bogus_control_flow` | required `InitEntropy`/`InitOpaque`, then `--Transform=AddOpaque --Functions=demo_bogus_control_flow --AddOpaqueKinds=true` |
| Tigress | Flatten | `demo_flattening` | `--Transform=Flatten --Functions=demo_flattening --FlattenDispatch=switch` |
| binprotect | linear substitution | full PE initially, or target-only PE | all other pass values explicitly zero; `--lin 1` |
| binprotect | MBA | full PE initially, or target-only PE | all other pass values explicitly zero; `--mba 1` |
| binprotect | opaque predicates | full PE initially, or target-only PE | all other pass values explicitly zero; `--opa 1` |
| binprotect | flattening | full PE initially, or target-only PE | all other pass values explicitly zero; `--cff 1` |

Binprotect defaults every technique on (`cff=1`, `vm=1`, `opaque=1`, `linear=1`, `mba=2`). Therefore every controlled command must explicitly set `--cff`, `--vm`, `--opa`, `--lin`, and `--mba`, including zero values for non-target transformations. Virtualization is outside this first matrix.

## Freeze recommendation

**READY TO FREEZE AS v1.0.**

The source is portable across the three required x64 Windows compiler lanes, its constants are correct, its clean structures survive with useful compiler-specific variation, and its exported names/debug artifacts support manual analysis. The clang subtraction lowering and the selective-targeting limits of Polaris global encryption/backend MIR and binprotect belong in build methodology, not in the canonical semantic source.
