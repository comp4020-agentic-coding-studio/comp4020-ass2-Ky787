# Transformation and deobfuscation pipelines

Arrows mean a retained transformation/analysis stage, not a claim that every route yields a correct runnable PE.

## Obfuscation

```text
Canonical C source
|
+-- Tigress (source-to-source) --> exact generated C --> MSVC --> native PE
|                                 [same C reused at /Od, /O1, /O2, /Ox]
|
+-- Clang frontend --> LLVM IR --> OLLVM / Hikari / Polaris IR passes
|                                 |
|                                 +--> optimizer --> instruction selection
|                                                      |
|                                                      +--> native PE
|                                                      |
|                                                      +--> Polaris X86 MIR/backend
|                                                           backend-obfu --> native PE
|
+-- ordinary compiler ----------------------------------------------> clean PE
                                                                      |
                                                                      +--> BinProtect
                                                                           post-link PE
                                                                           STATIC-ONLY INVALID
                                                                           in retained tests
```

Polaris backend-obfu acts after IR; a normal-looking IR CFG cannot measure its native junk injection. The standalone MIR route does not require another obfuscation pass.

## Deobfuscation

```text
native arithmetic --> Miasm expression extraction
                        +--> msynth AST/oracle
                        +--> SiMBA algebraic simplification
                        +--> separate Synthesizer
                                  |
                                  v
                          candidate expression --> SMT comparison
                          [NO rewritten PE from these workflows]

flattened native CFG --> discovery --> ollvm-unflattener
                                      |
                                      +--> successor recovery --> rewritten PE
                                      |                           +--> semantic validation
                                      |                                OLLVM/Hikari O0 PASS
                                      |                                Polaris O0 WRONG
                                      +--> Tigress discovery failure: NO output

opaque native CFG --> Triton DSE/SMT --> frozen proof + byte/hash identity
                                        |
                                        v
                                project-local branch rewriter
                                        |
                                        v
                                JMP + padding in original PE
                                        |
                                        +--> metadata audit + native differential checks
                                             OLLVM/Polaris BCF PASS

native x64 --> Mergen raw lift R [already includes folding]
                 +--> ordinary LLVM O2 --> R2
                 +--> Mergen custom/internal LLVM optimization --> M
                                                               +--> LLVM O2 --> M2
                    [verify IR; compile; execute ONLY under explicit case contract]
                    [valid IR is necessary, not evidence of correct semantics]
```

A lift harness is not a rewritten original PE. A solver proof is not a patch. A source/IR edge oracle is not a universal semantic proof. Each boundary is represented separately in [end-to-end results](tables/end_to_end_results.md).
