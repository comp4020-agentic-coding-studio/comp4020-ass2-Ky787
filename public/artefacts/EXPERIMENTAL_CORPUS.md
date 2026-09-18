# Experimental corpus

## Frozen source identities

| Source | SHA-256 | Role |
| --- | --- | --- |
| [showcase.c](assets/source/showcase.c) | `39FEF0BB2A9742870F3D6F7CC864F7CFFA129136F6D2A59C4FB37F25906B99D2` | Canonical cross-obfuscator showcase; source frozen before the matrix. |
| [substitution_complex.c](assets/source/substitution_complex.c) | `026AA69530C711ACC856C62A21852ABC0F536D7784717C9EBDC48252BCA47F37` | Later, separately frozen composed-arithmetic probe; does not replace or edit the showcase. |

Both hashes were rechecked while copying this handoff. Version records are included beside the sources. No source was modified or compiled for this task.

## Showcase functions

| Function | Intended teaching purpose |
| --- | --- |
| `demo_substitution` | Eight independent static XOR sites using 0x12345678, eight ADD sites using 0x1337 and eight SUB sites using 0x1111; exposes pass coverage and template diversity. Other setup and reduction operations also exist—“24 sites” is the selected repeated-site set, not the entire instruction count. |
| `demo_bogus_control_flow` | Genuine equality, threshold, low-byte and parity decisions with memorable constants; ground truth for distinguishing real branches from injected gates and clones. |
| `demo_flattening` | If/else, four-iteration loop with internal condition, and a four-way switch that reconverges; supports dispatcher/state analysis and exposes the Polaris rewrite's lost switch alternatives. |
| `demo_calls` | Three clear helper calls: addition, XOR and subtraction. It supplies an understandable baseline for indirect-call experiments, not a new call-deobfuscation result. |
| `demo_data` | Checksums recognisable strings and combines a small constant table; makes data/string encryption effects observable without relying on visual string disappearance alone. |
| `demo_combined` | Small mixed call/branch/loop/switch behavior for potential combinations. Its presence does not mean the retained controlled matrix tested arbitrary pass combinations. |

The program uses runtime-visible volatile inputs, exported non-inlined targets and built-in canonical output checks. Memorable constants are navigation landmarks across C, IR and assembly; constant matching alone is not a semantic proof. Volatile storage also affects optimized code shape and must remain part of the specimen's description.

Repeated operations were manually unrolled so a transformer encounters multiple independent **static instruction sites**. A loop executed eight times would not necessarily offer eight separately chosen transformation sites. Freezing the source before the matrix prevents changes in semantics, site count or function layout from masquerading as tool effects. Generated wrappers and transformed C carry tool-specific metadata outside the frozen source.

The canonical main checks print `SHOWCASE PASS` and exit 0 for validated originals. They are limited test vectors, not a proof for all inputs. Rewritten BCF specimens also have separate native differential checks. Do not edit input globals and describe the result as a retained experiment.

## Complex probe and limits

The later probe has four small branchless uint32 expression trees: `complex_constants`, `complex_variables`, `complex_mixed` and `expression_tree`. Unlike the repeated-site study, intermediates feed other operations and the objective is recovery of the **complete return expression**. It tests whether local success composes; it is not a harder-looking substitute selected after seeing solver results.

The retained study extracted 44/48 expressions; four Polaris MBA cases hit the configured Miasm flag-AST guard. AST/SiMBA completely recovered none of the 20 extracted obfuscated return expressions, although reductions such as Tigress mixed 305→79 nodes were proved. Separate repeated-site synthesis accepted 10/12 recoveries, with two UNKNOWN checks. Keep those populations separate. [Detailed report](assets/reports/complex_arithmetic_deobfuscation.md).

## Included versus omitted

This handoff selects the eight manual stories, four family O0 clean baselines, the additional matched Tigress /Ox clean, Hikari FLA transfer and Tigress initialized-state evidence. It preserves chosen compiler IR, generated C, native disassemblies, CFGs, proof/patch records and output logs. It does not duplicate all 68 build directories, toolchains, PDBs, solver traces or BinProtect protected outputs.

All executables remain Windows PE x64. A Linux rebuild would be a new specimen with different ABI, compiler lowering and runtime; it must not silently replace these results. See [BINARY_GUIDE](BINARY_GUIDE.md), [matrix](assets/reports/showcase_matrix_v1.md), [optimization study](assets/reports/optimization_survival.md) and [manifest](ASSET_MANIFEST.json).
