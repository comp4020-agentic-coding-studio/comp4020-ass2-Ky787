# Bibliography and resources

Primary URLs below were checked during this curation. They identify upstream resources, not a claim that current HEAD or current documentation matches the experimental revision. Retained reports and per-case metadata identify the builds actually tested. No publication metadata is inferred from a repository name. Papers listed below are background, not additional experiments reproduced by this project.

## PRIMARY TOOL/SOURCE DOCUMENTATION

| Resource | Authoritative link | Use and provenance |
| --- | --- | --- |
| Original Obfuscator-LLVM | [Canonical repository](https://github.com/obfuscator-llvm/obfuscator) | Historical lineage and original techniques. Distinct from the tested LLVM16 port. |
| wwh1004 OLLVM-16 | [Port repository](https://github.com/wwh1004/ollvm-16) | Tested modern port; source revision `5cbfb7245415f6b8e9f845e70c848eeb1605045f` in retained inventory. Compiler identity is in [matrix](assets/reports/showcase_matrix_v1.md). |
| Hikari LLVM15 | [ChandHsu port](https://github.com/ChandHsu/Hikari-LLVM15) | Retained compiler reports `021f73404e4b0bd1ea05c7226953cab8d9801c7a`; existing production build includes a local splitting patch. Do not imply a pristine rebuild. |
| Polaris | [Source and README](https://github.com/za233/Polaris-Obfuscator) | Tested checkout `1e066e69652be6c93885823b8cbbabdba8a16c73`; [local validation](assets/reports/polaris_validation.md). |
| Tigress | [Official documentation](https://tigress.wtf/) | Source transformations and environment options; tested Windows version 4.0.11. Use official documentation/licensing, not a mirror as implementation provenance. |
| BinProtect | [noahware/binprotect](https://github.com/noahware/binprotect) | Tested `067c2db79196e4809685e9af1862fd3222a41d80`; upstream capability descriptions do not override local runtime failure. |
| Miasm | [cea-sec/miasm](https://github.com/cea-sec/miasm) | Disassembly, IR and symbolic execution; integration/revision details differ between local studies. |
| msynth, SiMBA integration, Synthesizer | [mrphrazer/msynth](https://github.com/mrphrazer/msynth) | Oracle simplification and separate synthesis path. Tested local revision recorded as `661a5e3d7c0358950cf48b27ae422450c3064966`; current README can differ. |
| ollvm-unflattener | [cdong1012/ollvm-unflattener](https://github.com/cdong1012/ollvm-unflattener) | Stock tool at `d0062012b66ab2c845207c733216900d5e99f0a9`; [local protocol/results](assets/reports/unflattening_validation.md). |
| RPISEC llvm-deobfuscator | [RPISEC repository](https://github.com/RPISEC/llvm-deobfuscator) | SSA/Binary Ninja alternative; inspected revision `3f13f4f3c16dfe57f58f3c280ba2a3c341bc2d87`; not executed here. |
| Triton | [JonathanSalwan/Triton](https://github.com/JonathanSalwan/Triton) | Dynamic binary analysis/SMT framework, not the similarly named GPU compiler. |
| Mergen | [NaC-L/Mergen](https://github.com/NaC-L/Mergen) | Tested `71fc60766d3d74bd38693c1503087a074aa70a66`; whole-function x64-to-LLVM lifting. |
| Diaphora | [joxeankoret/diaphora](https://github.com/joxeankoret/diaphora) | IDA-integrated binary diffing. Screenshot version was not recorded. |
| IDA | [Hex-Rays documentation](https://docs.hex-rays.com/) | Official disassembly/navigation reference; verify institutional access separately. |
| x64dbg | [Official documentation](https://help.x64dbg.com/en/latest/) | Optional Windows debugger route; no Linux execution claim. |
| LLVM IR | [LLVM Language Reference](https://llvm.org/docs/LangRef.html) | SSA, types, instructions and semantic requirements. Choose version-specific docs when demonstrating LLVM15/16/18 artifacts. |
| LLVM lowering/backend | [Target-independent code generator](https://llvm.org/docs/CodeGenerator.html) | Selection, lowering and machine representation background; distinguish Polaris IR from MIR/backend work. |
| Z3 | [Microsoft Z3 Guide](https://microsoft.github.io/z3guide/) | Formulating solver queries and understanding theories; pair with retained bit-vector model assumptions. |
| SMT-LIB | [Official SMT-LIB site](https://smt-lib.org/) | Standard input language and theory documentation for the supplied `.smt2` artifacts. |

## BACKGROUND / RESEARCH PAPERS

- Pascal Junod, Julien Rinaldini, Johan Wehrli and Julie Michielin. **Obfuscator-LLVM — Software Protection for the Masses** (2015). The [upstream repository's citation](https://github.com/obfuscator-llvm/obfuscator) identifies SPRO 2015 and DOI `10.1109/SPRO.2015.10`. Historical background, not the tested LLVM16 build.
- **Polaris: MIR-Level Obfuscation in LLVM for Efficient and Robust Decompiler Resistance.** [Author-hosted paper](https://ttfish.cc/content/Papers/ICSE26-Polaris.pdf), also cited in the retained repository inventory. Use for the MIR motivation; do not attribute the paper's full evaluation to our separate smoke validation.
- Benjamin Reichenwallner and Peter Meerwald-Stadler. **Efficient Deobfuscation of Linear Mixed Boolean-Arithmetic Expressions** (2022). [arXiv record](https://arxiv.org/abs/2209.06335). Background for SiMBA's algebraic approach, distinct from stochastic search.
- Tim Blazytko, Moritz Contag, Cornelius Aschermann and Thorsten Holz. **Syntia: Synthesizing the Semantics of Obfuscated Code** (2017). [Author-hosted paper](https://synthesis.to/papers/usenix17-syntia.pdf). Synthesis background; Syntia itself was not executed in the retained corpus.
- Robin David, Luigi Coniglio and Mariano Ceccato. **QSynth — A Program Synthesis based Approach for Binary Code Deobfuscation** (BAR 2020). [Workshop preprint](https://archive.bar/pdfs/bar2020-preprint9.pdf). Background for expression-oriented synthesis and abstraction. No QSynth performance replication is claimed.

Further bibliography expansion should be selective and use verified author/publisher records. Do not fill unknown venue, edition, page or DOI fields from memory. Third-party papers are linked, not redistributed in this handoff.
