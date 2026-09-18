# Tigress 4.0.11 Windows x64 validation

Validation date: 2026-09-11, Australia/Sydney.

## Outcome

Official Tigress 4.0.11 installed successfully and its three requested non-virtualizing transformations work on Windows x64 when the generated source is compiled in the compiler environment for which Tigress produced it:

- opaque control flow: `InitEntropy` + `InitOpaque` + `AddOpaque` with conservative `true` opaque predicates;
- arithmetic/MBA rewriting: `EncodeArithmetic` with builtin encodings;
- control-flow flattening: `Flatten` with `switch` dispatch.

All 27 successful PE x64 builds executed with the expected output and exit status. The 21 failures were cross-environment compilation attempts retained intentionally: MSVC-environment source does not compile with GCC, and GCC-environment source does not compile with MSVC or clang-cl. Tigress output therefore **must be generated and retained separately for the MSVC and GCC environments**. Visual Studio clang-cl consumes the MSVC-environment source.

No transformation combinations were tested except the initializers required by `AddOpaque`. No virtualization, final corpus generation, website work, binary protection, or course-design changes were performed.

## Installation and provenance

The University of Arizona download page identified the selected package as version 4.0.11, Windows, X86/Arm, `.exe.zip`, dated 2025-09-23.[^download] The official Windows instructions describe the installer, Perl requirement, `TIGRESS_HOME`, and Visual Studio developer-environment workflow.[^windows]

| Item | Observed value |
|---|---|
| Downloaded package | `C:\Users\royga\Downloads\Tigress_Windows_v4.0.11.exe.zip` |
| Package size | `16,464,230` bytes |
| Package SHA-256 | `9FB8864242D019624BCA9AF76F7FB3DB8AB89378F7F73D4856CF62FDC9F7885B` |
| Inner installer | `Tigress_Windows_v4.0.11.exe`, `21,010,519` bytes |
| Installer SHA-256 | `C431A37C776F8AFADE0C09D3A21B5F3B2A8B5AEDCD136436A216534F53B20079` |
| Installer PE metadata | Company `University of Arizona`; description `Tigress C Source Code Obfuscator Installer`; generic file/product version `1.0.0` |
| Authenticode | `NotSigned`; provenance depends on the official HTTPS download and recorded hashes |
| Install root | `D:\Programs\Tigress_C_Obfuscator` |
| `TIGRESS_HOME` | `D:\Programs\Tigress_C_Obfuscator\Tigress` |
| Launcher | `D:\Programs\Tigress_C_Obfuscator\Tigress\tigress.bat` |
| Launcher SHA-256 | `532FC3F322D2DFA9C97551C64924E74662825095D78DE11D0F295CDD93257AEA` |
| Native CIL/Tigress engine | `D:\Programs\Tigress_C_Obfuscator\Tigress\Cygwin-x86_64\cilly.native` |
| Engine SHA-256 | `296D48D8532C3C342AD39BFF3F8DCC6A4902D6E2F08A27FD9866BAD8430652AD` |
| Installed license | `D:\Programs\Tigress_C_Obfuscator\Tigress\licenses\tigress_license.txt` |
| License SHA-256 | `B296EDC42472A32698305F3C89DCF1A90996F8A4BB3BF75C46CC58F2D8CD7B7D` |
| Visual Studio extension | Installed package contains `TigressObfuscator2.vsix`; it was not installed or used by this validation |

Version `4.0.11` is established by the official download listing and package/installer filename. The installer executable's generic `1.0.0` resource is not the Tigress version. The installed launcher cannot confirm the version because `tigress.bat --version` incorrectly tries to read `%TIGRESS_HOME%\Darwin-x86_64\version.txt`; that directory does not exist in the Windows package. It prints a path error but returns exit code `0`. `tigress.bat --license` similarly looks for `%TIGRESS_HOME%\tigress_license.txt` instead of the installed `licenses\tigress_license.txt`, prints a file-not-found error, and also returns `0`. The retained probes are under `results\tigress_smoke\probes\launcher`.

### Perl and environment configuration

| Item | Observed value |
|---|---|
| Runtime | Strawberry Perl `v5.32.1`, `MSWin32-x64-multi-thread` |
| Executable | `D:\Programs\Perl\perl\bin\perl.exe` |
| SHA-256 | `4D61EBE19311DBF7B9710AC2C6C402E3CBA3E23B63E8B82BE88E471343BED52D` |
| Bundled compiler used only while Tigress preprocesses GCC-environment input | Strawberry GCC `8.3.0` |

User-level `TIGRESS_HOME` and `PATH` entries for Tigress and Perl were configured successfully. The already-running sandboxed task does not inherit or expose that updated registry view, so the validation runner also sets them explicitly.

A direct PowerShell invocation pattern for a fresh shell is:

```powershell
$env:TIGRESS_HOME = 'D:\Programs\Tigress_C_Obfuscator\Tigress'
$env:Path = "D:\Programs\Perl\perl\bin;$env:TIGRESS_HOME;$env:Path"
& "$env:TIGRESS_HOME\tigress.bat" `
  --Environment=x86_64:Windows:Msvc:0.0 `
  --Seed=424242 `
  --Transform=Flatten --Functions=structural_probe --FlattenDispatch=switch `
  --out=output.c input.c
```

The retained wrapper `results\tigress_smoke\invoke_tigress_windows.cmd` is the validated project invocation. It also initializes Visual Studio Community 2026 and uses Strawberry GCC 8.3 while Tigress preprocesses `x86_64:Windows:Gcc` input. This is necessary because putting MSYS2 GCC 16 first during Tigress generation fails in GCC 16's `stddef.h` at its C23 `nullptr` declaration. The exact zero-byte-output probe and diagnostic are retained under `results\tigress_smoke\probes\gcc16_frontend`.

## Compiler matrix

| Lane | Exact compiler | Version / target |
|---|---|---|
| MSVC x64 | `E:\Visual Studio\VC\Tools\MSVC\14.51.36231\bin\Hostx64\x64\cl.exe` | `19.51.36248.0`, x64 |
| Visual Studio clang-cl x64 | `E:\Visual Studio\VC\Tools\Llvm\x64\bin\clang-cl.exe` | Clang `22.1.3`, `x86_64-pc-windows-msvc` |
| MSYS2 UCRT64 GCC x64 | `D:\Programs\msys64\ucrt64\bin\gcc.exe` | `16.2.0` (`16.2.0-3`), `x86_64-w64-mingw32` |
| PE inspection/disassembly | `D:\Programs\msys64\ucrt64\bin\objdump.exe` | GNU Binutils `2.47.20260726` (`2.47-3`) |

The primary build configuration was C, x64, O0/no inlining:

- MSVC: `/TC /Od /Ob0 /GS- /FAs /INCREMENTAL:NO /Brepro`;
- clang-cl: `/TC /Od /Ob0 /GS- /FAs /INCREMENTAL:NO /Brepro`;
- GCC: `-std=c11 -O0 -fno-inline -fno-omit-frame-pointer -Wl,--no-insert-timestamp`, plus `-S -masm=intel` for compiler assembly.

Every successful executable was also disassembled with `objdump -f -p -d -Mintel`. All successful outputs reported `architecture: i386:x86-64` and executed natively.

## Smoke programs

`results\tigress_smoke\source\structural.c` contains arithmetic, a conditional branch, a seven-iteration loop, and a no-inline `structural_probe` call. Its fixed check is stdout `STRUCT:24` and exit code `0`.

`results\tigress_smoke\source\repeated_ops.c` contains three static sites each for XOR, ADD, and SUB using volatile operands and no loop around those operations. Its fixed check is stdout `OPS:0002BC2E` and exit code `0`.

All six clean baselines—two programs times three compilers—compiled as PE x64 and passed.

## Installed and documented switches

Tigress's top-level interface uses `--Environment`, `--Seed`, one or more `--Transform`/`--Functions` pairs, `--out`, and a single input C file.[^top] The installed Visual Studio transformation-description JSON was hashed and reduced to `results\tigress_smoke\summaries\documented_transform_options.json`.

| Transform | Installed option names relevant to this pass |
|---|---|
| `InitEntropy` | `--InitEntropyKinds`, `--InitEntropyThreadName`, `--InitEntropyThreadSleep`, `--InitEntropyTrace`, `--InitEntropyObfuscate` |
| `InitOpaque` | `--InitOpaqueStructs`, `--InitOpaqueCount`, `--InitOpaqueTrace`, `--InitOpaqueDebug`, `--InitOpaqueSize` |
| `UpdateOpaque` | `--UpdateOpaqueCount`, `--UpdateOpaqueTrace`, `--UpdateOpaqueDebug`, `--UpdateOpaqueAllowAddNodes` |
| `AddOpaque` | `--AddOpaqueCount`, `--AddOpaqueKinds`, `--AddOpaqueObfuscate`, `--AddOpaqueSplitBasicBlocks`, `--AddOpaqueInline`, `--AddOpaqueSplitKinds`, `--AddOpaqueSplitLevel`, `--AddOpaqueStructs` |
| `EncodeArithmetic` | `--EncodeArithmeticKinds`, `--EncodeArithmeticMaxLevel`, `--EncodeArithmeticMaxTransforms`, `--EncodeArithmeticMaxSplit`, `--EncodeArithmeticRepeatTimes`, `--EncodeArithmeticAddImplicitFlow`, `--EncodeArithmeticImplicitFlow`, `--EncodeArithmeticAddOpaques`, `--EncodeArithmeticDumpFileName` |
| `Flatten` | `--FlattenDispatch`, `--FlattenObfuscateNext`, `--FlattenDumpBlocks`, `--FlattenOpaqueStructs`, `--FlattenSplitBasicBlocks`, `--FlattenRandomizeBlocks`, `--FlattenTrace`, `--FlattenConditionalKinds`, `--FlattenImplicitFlowNext`, `--FlattenImplicitFlow`, `--FlattenNumberOfBlocksPerFunction`, `--FlattenNumberOfThreads`, `--FlattenSplitName` |

The official pages describe `InitOpaque`/`UpdateOpaque`/`AddOpaque`, arithmetic encoding diversity, and flatten dispatch choices.[^opaque][^addopaque][^arithmetic][^flatten]

## Exact canonical transformation commands

The same commands were repeated into separate directories with seed `424242`; `EncodeArithmetic` was additionally generated with seed `424243`. Each generated directory contains its exact `generation_command.txt`, stdout, and stderr.

### Opaque flow/predicates

MSVC environment:

```text
E:\Workspace\seeing_through_obfuscation\results\tigress_smoke\invoke_tigress_windows.cmd --Environment=x86_64:Windows:Msvc:0.0 --Seed=424242 --Transform=InitEntropy --Functions=main --InitEntropyKinds=vars --Transform=InitOpaque --Functions=main --InitOpaqueStructs=list,array --Transform=AddOpaque --Functions=structural_probe --AddOpaqueKinds=true --AddOpaqueCount=3 --out=E:\Workspace\seeing_through_obfuscation\results\tigress_smoke\generated\add_opaque_msvc_seed424242_r1\structural.c E:\Workspace\seeing_through_obfuscation\results\tigress_smoke\source\structural.c
```

GCC environment: the identical command except `--Environment=x86_64:Windows:Gcc:0.0` and output directory `add_opaque_gcc_seed424242_r1`.

`InitEntropy` and `InitOpaque` are prerequisites, not separate experimental effects. `AddOpaqueKinds=true` was chosen as the conservative bogus-control-flow equivalent. It avoids unresolved-symbol `fake` blocks and raw-byte `junk` blocks, which are unsuitable for a first comparable Windows compiler matrix.[^addopaque]

### Arithmetic/MBA

MSVC environment:

```text
E:\Workspace\seeing_through_obfuscation\results\tigress_smoke\invoke_tigress_windows.cmd --Environment=x86_64:Windows:Msvc:0.0 --Seed=424242 --Transform=EncodeArithmetic --Functions=repeated_ops --EncodeArithmeticKinds=builtin --EncodeArithmeticMaxLevel=2 --EncodeArithmeticMaxTransforms=2 --EncodeArithmeticRepeatTimes=1 --out=E:\Workspace\seeing_through_obfuscation\results\tigress_smoke\generated\encode_arithmetic_msvc_seed424242_r1\repeated_ops.c E:\Workspace\seeing_through_obfuscation\results\tigress_smoke\source\repeated_ops.c
```

GCC environment: change the environment to `x86_64:Windows:Gcc:0.0` and output directory to `encode_arithmetic_gcc_seed424242_r1`.

### Flattening

MSVC environment:

```text
E:\Workspace\seeing_through_obfuscation\results\tigress_smoke\invoke_tigress_windows.cmd --Environment=x86_64:Windows:Msvc:0.0 --Seed=424242 --Transform=Flatten --Functions=structural_probe --FlattenDispatch=switch --out=E:\Workspace\seeing_through_obfuscation\results\tigress_smoke\generated\flatten_msvc_seed424242_r1\structural.c E:\Workspace\seeing_through_obfuscation\results\tigress_smoke\source\structural.c
```

GCC environment: change the environment to `x86_64:Windows:Gcc:0.0` and output directory to `flatten_gcc_seed424242_r1`.

## Results

### Transformation/compiler compatibility

Each success below passed compilation, PE x64 inspection, execution, exact stdout comparison, and exit-code comparison. Each failure is a compilation failure with retained diagnostics; no successfully compiled artifact failed semantically.

| Input | MSVC | clang-cl | GCC | Matching successful executable sizes |
|---|---|---|---|---|
| Clean structural | Pass | Pass | Pass | `140,288`; `147,456`; `39,119` bytes |
| Clean repeated operations | Pass | Pass | Pass | `140,288`; `147,456`; `39,148` bytes |
| AddOpaque, MSVC environment | Pass | Pass | Fail | `141,824`; `148,480` bytes |
| AddOpaque, GCC environment | Fail | Fail | Pass | `42,816` bytes |
| EncodeArithmetic, MSVC environment | Pass | Pass | Fail | `140,800`; `147,968` bytes |
| EncodeArithmetic, GCC environment | Fail | Fail | Pass | `41,980` bytes |
| Flatten, MSVC environment | Pass | Pass | Fail | `140,800`; `147,968` bytes |
| Flatten, GCC environment | Fail | Fail | Pass | `41,951` bytes |

The same-seed repeats produced the same compatibility and semantics. Both different-seed arithmetic variants also passed in their matching environments.

No endpoint-security product rejected or quarantined any generated C file or executable during this pass.

Cross-compilation failures are expected and useful findings:

- GCC rejects MSVC-environment output after Tigress has expanded MSVC/Windows SDK headers and emitted MSVC types such as `unsigned __int64`. Tigress itself emits a compiler-environment warning.
- MSVC rejects GCC-environment output containing expanded MinGW headers and GNU attributes.
- clang-cl rejects GCC-environment output at the expanded MinGW `__debugbreak` inline definition.

Consequently, using one Tigress-generated C file for the three-compiler comparison would be invalid. MSVC and clang-cl can share an MSVC-environment source; GCC needs a separately generated GCC-environment source.

### Actual source-level changes

Extracted target functions for every variant are under `results\tigress_smoke\analysis\source_functions`.

`AddOpaque` expanded the clean function from 330 to 1,552 bytes in the MSVC environment and introduced four function-local `if` tokens instead of one, opaque array/entropy expressions, an opaque pointer comparison, and guarded real operations. A representative guarded statement is:

```c
if (_TIG_iO_...__opaque_array[opaque_index] %
        _TIG_iO_...__opaque_array[5] == _TIG_iO_...__opaque_array[2]) {
    if (_TIG_iO_..._opaque_ptr_1 == _TIG_iO_..._opaque_ptr_2) {
        accumulator += value;
    }
}
```

`EncodeArithmetic` expanded the repeated-operations function from 640 to 1,744 bytes in the MSVC environment. The three instances of each source operator were replaced by multiple equivalent templates:

```c
xor0 = (((x - y) - ((x | ~y) << 1U)) - 2U);
xor1 = ((x | z) - (x & z));
add0 = ((x - ~y) - 1U);
add1 = ((x | z) + (x & z));
sub0 = ((x ^ y) - ((~x & y) << 1U));
sub1 = ((y + ~z) + 1U);
```

All nine explicit static operation sites were transformed. The three XOR sites received three distinct structural forms: a shift-based identity, a duplicated-add identity, and an OR/AND/subtract identity. The three ADD sites used two forms, with a complement/subtract template reused twice and an OR/AND/add template used once. The three SUB sites likewise used two forms, with an XOR/NOT/AND/shift template reused twice and a complement/add template used once. Thus Tigress provides per-occurrence diversity, but not a unique encoding at every site.

At O0, each compiler still produced three distinguishable assembly forms for the three XOR sites and two forms each for ADD and SUB. MSVC retained the complement-based ADD/SUB expansions. Clang and GCC canonicalized those identities back to native `add`/`sub` instructions even at O0, while retaining the OR/AND and XOR/NOT/AND templates. This is direct evidence that the final form reflects both Tigress's source rewrite and subsequent compiler lowering. The site-level classification is retained in `summaries\operation_site_diversity.{csv,json}`.

`Flatten` expanded the structural function from 330 to 1,871 bytes in the MSVC environment. The structured loop and branch became a `while (1)` dispatcher around one state variable and a ten-case `switch`. Each original block assigns the next state before returning to the dispatcher.

### Assembly and CFG changes

The counts below apply only to the target function extracted from compiler-generated O0 assembly, avoiding CRT/header-expansion noise in whole-program disassembly.

| Compiler | Function/condition | Instructions | Conditional branches | Unconditional jumps | Indirect jumps |
|---|---|---:|---:|---:|---:|
| MSVC | structural clean | 37 | 2 | 3 | 0 |
| MSVC | AddOpaque | 103 | 5 | 2 | 0 |
| MSVC | Flatten | 81 | 4 | 13 | 1 |
| clang-cl | structural clean | 34 | 2 | 3 | 0 |
| clang-cl | AddOpaque | 97 | 6 | 10 | 0 |
| clang-cl | Flatten | 68 | 4 | 15 | 1 |
| GCC | structural clean | 35 | 2 | 2 | 0 |
| GCC | AddOpaque | 125 | 5 | 3 | 0 |
| GCC | Flatten | 89 | 18 | 13 | 0 |
| MSVC | repeated operations clean | 69 | 0 | 0 | 0 |
| MSVC | EncodeArithmetic | 160 | 0 | 0 | 0 |
| clang-cl | repeated operations clean | 68 | 0 | 0 | 0 |
| clang-cl | EncodeArithmetic | 117 | 1 | 2 | 0 |
| GCC | repeated operations clean | 71 | 0 | 0 | 0 |
| GCC | EncodeArithmetic | 121 | 0 | 0 | 0 |

All three transformations materially change assembly:

- `AddOpaque` materially enlarges the function and adds predicate-controlled paths; it is the requested bogus-control-flow equivalent.
- `EncodeArithmetic` more than doubles MSVC's target-function instruction count and substantially increases clang-cl/GCC counts, but intentionally does not restructure the core CFG.
- `Flatten` materially restructures the CFG. MSVC and clang-cl lower the switch to a jump-table-style indirect jump at O0; GCC 16 lowers this small dispatcher to a long chain of direct comparisons and jumps at O0. The source-level flattened CFG is present in all three.

The complete compiler listings and PE disassemblies are under each `results\tigress_smoke\build\<variant>\<compiler>` directory.

### Conceptual mapping to LLVM obfuscators

| Tigress condition | Closest OLLVM concept | Important imperfection in the comparison |
|---|---|---|
| `InitEntropy` + `InitOpaque` + `AddOpaqueKinds=true` | BCF / opaque predicates | Tigress introduces source-visible runtime entropy/opaque data structures and guards real C statements; OLLVM injects opaque CFG in LLVM IR. |
| `EncodeArithmeticKinds=builtin` | SUB and MBA-style rewriting | Tigress rewrites C expressions before type lowering and compiler canonicalization; LLVM substitutes typed IR instructions after the C frontend. |
| `FlattenDispatch=switch` | FLA | Tigress emits a source-level switch dispatcher that each compiler lowers differently; OLLVM builds the dispatcher directly in LLVM IR. |

These are useful controlled analogues, not equivalent implementations. `UpdateOpaque` is documented and may be useful for a stronger later opaque-state condition, but it was not added here because this pass intentionally isolated the smallest required AddOpaque chain. The broader transformation catalogue offers many other techniques, but none is necessary for the initial BCF/SUB/FLA comparison.[^transforms]

## Reproducibility and seed observations

Tigress exposes `--Seed`, but version 4.0.11 did not provide byte-for-byte reproducibility in this Windows pass:

- two fresh generations with `--Seed=424242` had different whole-file SHA-256 values for every transformation and both environments;
- the differences include four-character `_TIG_...` identifier salts and generated declaration ordering not controlled by the supplied seed;
- after normalizing only those four-character salts, the extracted target function was identical across the same-seed repeats for all transforms;
- for `EncodeArithmetic`, the extracted target function was byte-identical even before normalization;
- changing `EncodeArithmetic` from seed `424242` to `424243` did not change any tested arithmetic template or the normalized target function.

The seed is therefore insufficient as a reconstruction key. Eventual experiments should archive the exact generated C and record its hash; they should not assume the source can be regenerated from a seed alone. Seed-controlled diversity should not be an experimental factor until a larger probe or clarification from Tigress establishes what `--Seed` controls.

PE linking used `/Brepro` for MSVC/clang-cl and `--no-insert-timestamp` for GCC so ordinary PE timestamps did not dominate. The fixed-seed clang-cl PEs were byte-identical for all three transformations. The fixed-seed MSVC and GCC PEs were not byte-identical, following the non-identical full generated sources. For `EncodeArithmetic`, MSVC and clang-cl produced the same PE hash for seeds `424242` and `424243`; GCC's hashes changed, but its same-seed repeats also changed, so that difference cannot be attributed to the seed. Exact comparisons are in `summaries\binary_reproducibility.{csv,json}`.

## License and research-use notes

The public download page says Tigress is free for research use by non-profit organizations and requires a University of Arizona license for for-profit use.[^download] The installed EULA is materially narrower in wording: it grants a non-transferable internal right for assessing Tigress virtualization software, restricts redistribution of the program, prohibits reverse engineering/disassembly of the program, disclaims warranties, and includes export-control obligations.

This validation analyzed only Tigress-generated test programs; it did not reverse engineer or disassemble Tigress itself. Before distributing a future course corpus or using generated material beyond internal evaluation, the institution should reconcile the public research-use statement with the installed EULA, ideally through its legal/licensing process or written clarification from the University of Arizona. This is a compliance flag, not legal advice.

## Recommendations for the controlled corpus

Recommended, after the license question is cleared:

1. Include `AddOpaqueKinds=true` with explicit `InitEntropy` and `InitOpaque` prerequisites as the conservative opaque-control-flow condition.
2. Include builtin `EncodeArithmetic` at fixed level/transform counts; retain the repeated-site program because it demonstrated two templates per operator family.
3. Include `FlattenDispatch=switch`; it produces a clear source CFG transformation and distinct MSVC/clang-cl versus GCC backend lowering.
4. Generate and archive MSVC- and GCC-environment C separately. Use the MSVC source for MSVC and clang-cl; use the GCC source only for GCC.
5. Preserve the exact generated C, transformation command, compiler command, compiler version, and hashes. Do not rely on `--Seed` for reconstruction.

Exclude or defer:

- cross-compiling a Tigress output with a compiler family different from its declared `--Environment`;
- direct Tigress preprocessing with MSYS2 GCC 16 until the C23 `nullptr` incompatibility is resolved;
- `AddOpaqueKinds=fake` and `junk` in the controlled baseline because of unresolved-symbol and raw-byte portability/security-scanner issues documented by Tigress;
- seed value as an independent diversity variable, because the alternate seed did not alter the tested arithmetic function while unseeded identifier salts prevented byte reproducibility;
- virtualization, which was expressly outside this phase.

## Retained evidence

The disposable root is `results\tigress_smoke`:

- `source`: the two original C programs;
- `generated`: all 14 generated C variants, exact commands, stdout, and stderr;
- `build`: all 48 compiler attempts with commands, logs, executable/assembly/disassembly where successful, and run output;
- `analysis`: extracted target C functions and target assembly functions;
- `summaries`: CSV/JSON generation, build, source, function, assembly, reproducibility, installation, and installed-switch records;
- `probes`: launcher defects and GCC 16 frontend incompatibility;
- `run_validation.ps1` and `analyze_results.ps1`: repeatable runners.

No files were placed in a future corpus directory.

## Sources

[^download]: University of Arizona, [Tigress download and licensing page](https://tigress.wtf/tigress-download.html).
[^windows]: University of Arizona, [Installing and using Tigress on Windows](https://tigress.wtf/tigress-windows.html).
[^top]: University of Arizona, [Tigress top-level options](https://tigress.wtf/top-level.html).
[^opaque]: University of Arizona, [Tigress opaque-predicate infrastructure](https://tigress.wtf/opaque.html).
[^addopaque]: University of Arizona, [Tigress AddOpaque transformation](https://tigress.wtf/addOpaque.html).
[^arithmetic]: University of Arizona, [Tigress EncodeArithmetic transformation](https://tigress.wtf/encodeArithmetic.html).
[^flatten]: University of Arizona, [Tigress Flatten transformation](https://tigress.wtf/flatten.html).
[^transforms]: University of Arizona, [Tigress transformation catalogue](https://tigress.wtf/transformations.html).
