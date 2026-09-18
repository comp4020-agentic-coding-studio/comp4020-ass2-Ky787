# Seeing Through Obfuscated Code

Preferred subtitle: **Obfuscation, assembly, and recovering program semantics**.

This is a technical brief for a future course-building agent, not marketing copy or a finalized syllabus.

## Thesis and caution

Obfuscation can radically alter source, IR, CFG and machine-code structure. Successful deobfuscation increasingly depends on recovering semantics rather than recognizing one vendor's surface patterns. The research supports this as a course thesis through bounded examples, not a universal claim that semantic methods solve every obfuscation.

The central caution is equally important: **a cleaner-looking result is not automatically a correct result**.

The generic Triton workflow proved 22 OLLVM and 16 Polaris injected O0 opaque gates; a separate proof consumer patched them, and retained differential tests found zero mismatches across 9,189 clean/original/rewrite triples. Conversely, Polaris FLA shrank from 56 to 10 Miasm blocks while returning the wrong result, and Mergen produced verifier-valid OLLVM SUB IR with 3,917/4,118 mismatches per lifted stage. These contrasts make correctness part of the method rather than a final disclaimer. See [branch rewriting](assets/reports/opaque_predicate_rewrite.md), [unflattening](assets/reports/unflattening_course_examples.md), [Mergen](assets/reports/mergen_validation.md) and [claim boundaries](CLAIMS_AND_CAVEATS.md).

## Intended technical level

Provisional audience: upper-level undergraduate or introductory postgraduate students in systems/security, including readers new to symbolic program analysis but not new to programming. The course should build from readable C and x64 instructions to bounded semantic reasoning; it should not assume graduate-level theorem proving or experience implementing a compiler.

Assumed prerequisites:

- C functions, pointers, arrays, control flow and unsigned integer operations.
- Binary/hexadecimal notation, bitwise operators and basic modular arithmetic.
- Introductory architecture: registers, memory, stack, calls and conditional branches.
- Basic command-line/file handling; ability to read a short script, without requiring advanced Python.

Introduce SSA, SMT, symbolic execution and lifting within the course. Refresh the Windows x64 calling convention, PE exports and address/RVA distinction before optional debugger work. [TERMINOLOGY](TERMINOLOGY.md) supplies consistent definitions.

## Why this corpus and these representations

C exposes arithmetic, branches and data movement with relatively little language-runtime machinery. The same program can be compiled through the LLVM-family tools and transformed by Tigress, while its uint32 computations make wraparound reasoning explicit. Exported, non-inlined functions and memorable constants help students locate the same logic in different forms. This is controlled experimental convenience, not a claim that C resembles all protected production software.

Repeatedly following the same source through generated C, compiler IR, native instructions, recovered graphs and lifted expressions reduces semantic uncertainty: students know the intended operation before diagnosing what a tool changed or lost. Keep compiler-produced IR distinct from IR lifted back from a PE. Compiler annotations and debugger symbols aid navigation but are not ground truth about semantic correctness. See [EXPERIMENTAL_CORPUS](EXPERIMENTAL_CORPUS.md).

Optimization level is an experimental variable. Classic SUB may expand IR yet collapse in native instruction selection; Hikari/Polaris BCF target effects disappear by O1; flattening persists with different dispatch forms. Tigress uses one exact generated C file across optimization levels. Comparisons must control both the compiler family and optimization level; the MSVC lane's directory label O3 means `/Ox`, not a literal `/O3` option. See [optimization study](assets/reports/optimization_survival.md).

## Learning outcome, not tool collection

A successful student should be able to trace a small behavior across representations, identify what an analysis actually established, propose a bounded semantic check, and distinguish a valid-looking output from a trustworthy one. The strongest capstone is a justified analysis of unfamiliar evidence, not an implementation of an entire deobfuscator.

Runtime tests, local SMT proofs and structural recovery answer different questions. Tests can falsify a claim quickly but cover only their inputs/state; an SMT proof is universal only within its formal model and preconditions. Whole-program memory, initialization, ABI and metadata assumptions can remain outside a local proof. The course must repeatedly expose these boundaries.

The proposed twelve-week sequence and assessment ideas are provisional. Tool availability, contact hours and institutional weighting are open decisions. This package contains neither final lesson pages nor a website design.
