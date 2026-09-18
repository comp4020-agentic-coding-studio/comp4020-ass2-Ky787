# Polaris Windows x64 Validation

Validation date: 2026-09-11, Australia/Sydney.

## Outcome

Polaris built successfully from the pinned upstream checkout and produced a working Windows x64 Clang 16.0.6 compiler. The clean baseline and every requested individual transformation compiled to PE32+ x64, executed with exit status `0`, and printed the expected output:

```text
POLARIS_SMOKE result=7 text=validation-string
```

No transformation was combined with another transformation. No final research corpus was generated. The existing Hikari source and compiler were not modified or rebuilt.

Two reproducibility limitations were found. Linear MBA and the X86 backend/MIR transformation produce different binaries on repeated builds even when the same LLVM `-rng-seed=123456` argument is supplied. All other tested variants were byte-identical on the repeated `/Brepro` build.

## Source identity and cleanliness

| Item | Value |
|---|---|
| Repository | `E:\Workspace\seeing_through_obfuscation\third_party\obfuscators\Polaris-Obfuscator` |
| Upstream | `https://github.com/za233/Polaris-Obfuscator.git` |
| Branch | `main` |
| Commit | `1e066e69652be6c93885823b8cbbabdba8a16c73` |
| Bundled LLVM/Clang | `16.0.6` |
| Source state after build and validation | Clean; `git status --porcelain=v1` produced no output |

The build and all disposable artifacts are outside the checkout. No upstream file was changed.

## Build configuration

| Setting | Value |
|---|---|
| Build directory | `E:\Workspace\seeing_through_obfuscation\builds\polaris` |
| Generator | Ninja |
| Configuration | `Release` |
| Enabled project | `clang` |
| LLVM targets | `X86` only |
| LLVM assertions | Explicitly `OFF` |
| C/C++ host compiler | MSVC `19.51.36248.0`, x64 host and target |
| Visual Studio environment | Visual Studio Community 2026 developer environment, version `18.7.3` |
| CMake | Visual Studio copy `4.3.1-msvc1` |
| Ninja | Visual Studio copy `1.13.2` |
| Build target | `clang` |
| Parallelism | 20 |
| Build footprint after completion | Approximately 1.40 GiB, 3,081 files |

The exact configuration and build commands were:

```bat
call "E:\Visual Studio\Common7\Tools\VsDevCmd.bat" -arch=amd64 -host_arch=amd64

"E:\Visual Studio\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" ^
  -S "E:\Workspace\seeing_through_obfuscation\third_party\obfuscators\Polaris-Obfuscator\src\llvm" ^
  -B "E:\Workspace\seeing_through_obfuscation\builds\polaris" ^
  -G Ninja ^
  -DCMAKE_MAKE_PROGRAM="E:\Visual Studio\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe" ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DLLVM_ENABLE_PROJECTS=clang ^
  -DLLVM_TARGETS_TO_BUILD=X86 ^
  -DLLVM_ENABLE_ASSERTIONS=OFF ^
  -DLLVM_INCLUDE_TESTS=OFF ^
  -DCLANG_INCLUDE_TESTS=OFF ^
  -DLLVM_INCLUDE_EXAMPLES=OFF ^
  -DLLVM_INCLUDE_BENCHMARKS=OFF

"E:\Visual Studio\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" ^
  --build "E:\Workspace\seeing_through_obfuscation\builds\polaris" ^
  --target clang --parallel 20
```

The reusable command is `scripts\build_polaris.cmd`.

### Build observations

The 2,653-action Ninja build completed without errors. CMake 4.3.1 emitted compatibility/deprecation warnings for older LLVM 16 policies including CMP0114, CMP0116, CMP0175, and CMP0146. Zlib, LibXml2, and Backtrace were not found, but none was required for this Clang target.

The Polaris sources emitted non-fatal MSVC warnings for signed/unsigned comparison and unused local variables in `BogusControlFlow2.cpp`, `Substitution.cpp`, `Flattening.cpp`, and `X86RubbishCode.cpp`. These warnings did not affect the resulting compiler.

## Resulting compiler

Path:

```text
E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe
```

`clang --version`:

```text
clang version 16.0.6
Target: x86_64-pc-windows-msvc
Thread model: posix
InstalledDir: E:\Workspace\seeing_through_obfuscation\builds\polaris\bin
```

| Property | Value |
|---|---|
| File size | 68,880,896 bytes |
| SHA-256 | `88DC08535F71EFD84B3BFACE00080CF5BCA56DC47ADF6DD50FC4293568E50D10` |

## Available switches and markers

Polaris uses two selectors for each function-level IR pass: the module pipeline is enabled with `-mllvm -passes=<short-name>`, while a Clang annotation marks the target function. The implementation performs substring matching on `llvm.global.annotations`.

| Transformation | Pipeline name | Required function annotation | Tested |
|---|---|---|---|
| Control-flow flattening | `fla` | `flatten` | Yes |
| Global/string encryption | `gvenc` | None; module-wide | Yes |
| Indirect calls | `indcall` | `indirectcall` | Yes |
| Indirect branches | `indbr` | `indirectbr` | Yes |
| Alias access | `alias` | `aliasaccess` | No |
| Bogus control flow | `bcf` | `boguscfg` | Yes |
| Instruction substitution | `sub` | `substitution` | Yes |
| Function merging | `merge` | `mergefunction` | No |
| Linear MBA | `mba` | `linearmba` | Yes |
| Custom calling convention | `ccc` | `customcc` | No; present in `Pipeline.cpp` but omitted from the README's main pass list |
| X86 backend/MIR obfuscation | No pipeline name | Inline assembly marker `asm("backend-obfu")` | Yes |

The README's prose calls the flattening annotation `flattening`, while its example and `Flattening.cpp` use `flatten`. The validation used the implementation-correct `flatten` spelling.

## Smoke-test design

The disposable source is `results\polaris_smoke\source\smoke.c`. It contains:

- integer multiplication, addition, and XOR;
- an odd/even conditional branch;
- a six-iteration loop;
- a non-inlined call from `smoke_transform` to `smoke_callee`;
- an internal validation string for the global-encryption test; and
- a semantic self-check that returns `23` on failure and `0` on success.

Compilation used `-m64 -O0`. The zero optimization level keeps the small program structurally legible and avoids ordinary optimization obscuring whether a Polaris pass ran. Polaris marks its passes as required, so they still run on `optnone` functions.

Every binary was linked with `/Brepro`. Each obfuscated invocation also received `-mllvm -rng-seed=123456`; the second executable build was delayed by at least 1.2 seconds to expose transformations that seed themselves from wall-clock time. Each produced executable was:

1. checked with `dumpbin /headers` for COFF machine `8664 (x64)`;
2. disassembled from the exact PE with `dumpbin /disasm:nobytes`;
3. executed and checked for the expected output and exit status;
4. rebuilt and re-executed; and
5. hashed with SHA-256.

An additional compiler-generated `.s` file and LLVM `.ll` file were created in each variant directory. These are representative separate compiler invocations; the `dumpbin` listing is the assembly evidence tied to the exact tested PE.

## Exact executable commands

All paths below are absolute. Complete commands for PE headers, disassembly, representative assembly, IR, and the repeat build are recorded in each variant's `commands.txt`.

### Clean baseline

```text
"E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe" -m64 -O0 -Wl,/Brepro -mllvm -rng-seed=123456 E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\source\smoke.c -o E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\clean\clean.exe
```

### Bogus control flow

```text
"E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe" -m64 -O0 -Wl,/Brepro -DTEST_BCF -mllvm -passes=bcf -mllvm -rng-seed=123456 E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\source\smoke.c -o E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\bcf\bcf.exe
```

### Instruction substitution

```text
"E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe" -m64 -O0 -Wl,/Brepro -DTEST_SUB -mllvm -passes=sub -mllvm -rng-seed=123456 E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\source\smoke.c -o E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\sub\sub.exe
```

### Control-flow flattening

```text
"E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe" -m64 -O0 -Wl,/Brepro -DTEST_FLA -mllvm -passes=fla -mllvm -rng-seed=123456 E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\source\smoke.c -o E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\fla\fla.exe
```

### Linear MBA

```text
"E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe" -m64 -O0 -Wl,/Brepro -DTEST_MBA -mllvm -passes=mba -mllvm -rng-seed=123456 E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\source\smoke.c -o E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\mba\mba.exe
```

### Indirect branches

```text
"E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe" -m64 -O0 -Wl,/Brepro -DTEST_INDBR -mllvm -passes=indbr -mllvm -rng-seed=123456 E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\source\smoke.c -o E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\indbr\indbr.exe
```

### Indirect calls

```text
"E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe" -m64 -O0 -Wl,/Brepro -DTEST_INDCALL -mllvm -passes=indcall -mllvm -rng-seed=123456 E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\source\smoke.c -o E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\indcall\indcall.exe
```

### Global/string encryption

```text
"E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe" -m64 -O0 -Wl,/Brepro -mllvm -passes=gvenc -mllvm -rng-seed=123456 E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\source\smoke.c -o E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\gvenc\gvenc.exe
```

### X86 backend/MIR obfuscation

```text
"E:\Workspace\seeing_through_obfuscation\builds\polaris\bin\clang.exe" -m64 -O0 -Wl,/Brepro -DTEST_BACKEND -mllvm -rng-seed=123456 E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\source\smoke.c -o E:\Workspace\seeing_through_obfuscation\results\polaris_smoke\backend\backend.exe
```

## Results

All compilation results in this table are successful PE x64 binaries. All final executions and repeat executions produced the expected output and exit status `0`.

The IR and assembly counts are limited to `smoke_transform`, except the byte size, which is the complete linked PE. “ASM instructions” comes from the representative compiler-generated assembly; the exact PE disassembly is retained beside it.

| Variant | PE bytes | IR blocks | Direct `br` | `indirectbr` | ASM instructions | ASM jumps | Same-seed repeat | Obvious change |
|---|---:|---:|---:|---:|---:|---:|---|---|
| Clean | 140,800 | 8 | 7 | 0 | 29 | 5 | Identical | Baseline structured loop and conditional |
| BCF | 141,824 | 23 | 22 | 0 | 183 | 32 | Identical | Extensive duplicated blocks and opaque control predicates; one bogus duplicate call site |
| Substitution | 141,312 | 8 | 7 | 0 | 51 | 5 | Identical | Arithmetic/bitwise expansion; CFG shape unchanged |
| Flattening | 141,312 | 11 | 9 | 0 | 74 | 22 | Identical | Dispatcher `switch`, state variable, and dispatcher loop materially replace the structured CFG |
| Linear MBA | 141,312 | 8 | 7 | 0 | 111 | 5 | **Different** | Large mixed Boolean/arithmetic expressions; CFG shape unchanged |
| Indirect branch | 141,312 | 8 | 0 | 7 | 54 | 7 | Identical | Every direct IR branch in the target became table-based `indirectbr`; assembly uses `jmpq *%rax` |
| Indirect call | 140,800 | 8 | 7 | 0 | 31 | 5 | Identical | Direct `callq smoke_callee` became `callq *%rax` through an encoded function-pointer global |
| Global encryption | 141,312 | 8 | 7 | 0 | 29 | 5 | Identical | Target function unchanged; module gains encrypted constant data and `__obfu_globalenc_dec` runtime decryption |
| Backend/MIR | 141,824 | 8 | 7 | 0 | 192 | 5 | **Different** | Large volume of target-specific junk arithmetic, flag operations, stack-address disguising, and `rdrandq`; CFG branch count unchanged in this specimen |

### Binary hashes

| Variant | Primary SHA-256 | Repeat SHA-256 |
|---|---|---|
| Clean | `72DEECF06B4BFAEBB5EED3B12C8EBB0947E633CAF8EF17F5A823A29DB257FEB6` | Same |
| BCF | `B071BC08A5C9C020ED0E01BD3C80306F77464266CABA5A5977C5B764E7CABBEA` | Same |
| Substitution | `2B974FC02394CB2B9FFBF0362F9630198F93A89286A42A0518EA9C8EF1F517A8` | Same |
| Flattening | `7F64451E0970D30555BF23E174F16D9CCF93A587F106C2954738208E8FD817E4` | Same |
| Linear MBA | `5C02CBB8A426B59950B81CA4750DDFD3E88DB8C9220E64144362667F6EA82932` | `C10B96129BBD65B6C01D99196B28C2CC89C2DC3559BD8823D4EC749DB5FEEC76` |
| Indirect branch | `200F96C368C8545572233DF5E7E4595520612C76D4DF288DF8C15FFC2C535BED` | Same |
| Indirect call | `0CC89B1D4B2642FE965EA1AA59C108DDF0B07A54FA3AA74A7333EFDBB57DF8AC` | Same |
| Global encryption | `5C8F7C606F4A1D563350393A2B18EF0229846D7F452E0ECE36854096F8B955EA` | Same |
| Backend/MIR | `AB9F8F81F6560D9B05E0E7DAF96C47F3DBAA78875880BF63286C30A0DC7567C8` | `9092EFE7B9238971D03D2F0090260D504C953853C9F2E184D35EDE0DD23426DF` |

The MBA and backend hashes describe the final recorded run. Re-running the validation is expected to replace them with different values.

## IR-level versus backend-level behavior

BCF, substitution, flattening, MBA, indirect branches, indirect calls, and global encryption run in the LLVM module optimization pipeline. Their transformed `.ll` files expose the effect directly:

- BCF expands the target from 8 to 23 blocks and duplicates instruction regions behind opaque predicates.
- Flattening creates a dispatcher `switch` and state-driven loop.
- Indirect branches create a private block-address table and seven `indirectbr` terminators.
- Indirect calls create an encoded pointer global and indirect call operand.
- Global encryption encrypts internal/private integer arrays, copies them to stack storage, and calls the generated private `__obfu_globalenc_dec` routine before use.
- Substitution and MBA expand arithmetic without changing block structure.

The X86 backend path is selected by the side-effecting inline-assembly marker `backend-obfu`. The marker is still visible in emitted LLVM IR; the X86 machine pass consumes it during target code generation. The main IR CFG remains clean-like, while the assembly expands from 29 to 192 target-function instructions in this run. This is therefore a distinct MIR/backend condition and should not be labeled as an LLVM IR transformation.

## Windows PE compatibility and limitations

All nine variants, including the clean baseline, were verified as `8664 machine (x64)` PE images. Every final primary and repeat executable ran successfully with correct output and status.

During an earlier harness run, the first flattening executable launch was rejected by the Windows process API with:

```text
Operation did not complete successfully because the file contains a virus or potentially unwanted software
```

No security setting was weakened or bypassed. A freshly generated flattening binary subsequently executed successfully in repeated full runs. This appears to be a transient heuristic endpoint-security reaction to obfuscated control flow, not a demonstrated semantic failure, but it is an important Windows deployment limitation. Future corpus storage and classroom distribution should be coordinated with institutional endpoint-security policy.

The backend output includes deliberately suspicious and unusual instruction sequences. Even though it executed correctly here, disassemblers, decompilers, endpoint scanners, and older processors may handle it differently. Its emitted `rdrandq` instruction also creates a CPU-feature compatibility consideration not present in the clean sample.

## Reproducibility and seed observations

`-rng-seed=123456` is a general LLVM seed option, but it does not control every Polaris random source.

- BCF, substitution, flattening, indirect branches, indirect calls, and global encryption were byte-reproducible in this test.
- Flattening calls its implementation with seed `0`, independent of the command-line LLVM seed.
- MBA uses `std::random_device` and `std::mt19937`, so the same command-line seed does not reproduce its expressions.
- The X86 backend calls `srand(time(0))` for each processed machine function, so a delayed repeat changes its output.
- Other Polaris code also uses the process-global C `rand()` or a default-constructed shuffle engine. Apparent determinism in this small test should not be treated as a stable public reproducibility contract.

For a controlled corpus, retain exact binaries, IR, assembly, commands, compiler hash, and per-artifact hashes rather than assuming source-plus-seed is sufficient.

## Recommended corpus policy

Recommended primary individual conditions:

- BCF, because it produces the largest deterministic CFG expansion in this validation.
- Flattening, because the dispatcher structure is clear, deterministic, and central to the deobfuscation study.
- Indirect branches, because it deterministically replaces direct CFG edges with block-address-table dispatch.
- Indirect calls, because it creates a clean, narrowly scoped call-target-obfuscation condition.
- Substitution, because it is deterministic and isolates instruction-level algebraic rewriting without changing CFG shape.
- Global/string encryption, as a separate data-obfuscation condition rather than a CFG condition.

Conditional or advanced lanes:

- Linear MBA should be excluded from the reproducible primary corpus until its `random_device` use is replaced by a pinned seed mechanism, or included only as immutable prebuilt artifacts with recorded hashes.
- The backend/MIR path should be an advanced stress-test lane, not part of the primary controlled IR-pass comparison. It works on this Windows x64 sample but is non-deterministic, can trigger endpoint-security heuristics, and massively changes assembly without a corresponding IR CFG transformation.
- `alias`, `merge`, and `ccc` should remain excluded until they receive their own individual semantic and repeatability validation.

No combined transformation recommendation is made here because combinations were intentionally outside this pass.

## Artifact map

| Artifact | Location |
|---|---|
| Build wrapper | `scripts\build_polaris.cmd` |
| Validation entry point | `scripts\validate_polaris.cmd` |
| Validation logic | `scripts\validate_polaris.ps1` |
| Smoke source | `results\polaris_smoke\source\smoke.c` |
| Machine-readable summary | `results\polaris_smoke\summary.json` and `summary.csv` |
| Per-variant evidence | `results\polaris_smoke\<variant>\` |

Each variant directory contains the executable, repeat executable, LLVM IR, compiler-generated assembly, exact-PE disassembly, PE headers, exact commands, stdout/stderr logs, hashes, and JSON metadata.
