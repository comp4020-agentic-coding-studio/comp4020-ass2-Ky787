# Read first: handoff to the course-site builder

You are receiving curated research evidence for **Seeing Through Obfuscated Code**, with the preferred subtitle **Obfuscation, assembly, and recovering program semantics**. The website has NOT been designed or implemented. This package is information architecture, a provisional teaching plan and an evidence selection—not completed lessons or a deployment project.

Start with [COURSE_BRIEF](COURSE_BRIEF.md), [PROVISIONAL_12_WEEK_OUTLINE](PROVISIONAL_12_WEEK_OUTLINE.md), [BEST_EVIDENCE_BY_TOPIC](BEST_EVIDENCE_BY_TOPIC.md) and [CLAIMS_AND_CAVEATS](CLAIMS_AND_CAVEATS.md). Use [HANDOFF_ASSET_MAP](HANDOFF_ASSET_MAP.md) to locate exact assets, rather than searching an experimental tree. All primary navigation is package-relative and portable to Linux.

## What you may change later

Improve pedagogy, pacing and ordering. The twelve-week structure is explicitly provisional: contact hours, assessment weights, institutional requirements and student tool access are not finalized. Design and implementation belong to a later task. Do not treat existing lecture-table colours as a required site style.

Preserve the experimental findings, their denominators, optimization levels, tool identities and qualifications. Do not repair an inconvenient negative result by quietly substituting another specimen. No new research is necessary to understand or present the selected evidence; any future experiment needs a separate protocol and preserved outputs.

## Evidence and teaching discipline

- Prefer real source, assembly, IR, generated C, screenshots and CFGs in this package over AI-generated pseudo-results. Any later schematic must be labelled conceptual, not experimental output.
- Every important technical claim must resolve to a retained report/result or cited primary documentation. A screenshot illustrates appearance; it does not establish correctness, solver status or a numeric CFG metric.
- Avoid turning course pages into giant research reports. Use progressive disclosure: simple explanation → source → IR/assembly → visual comparison → deeper technical detail and validation.
- Use comparison tables selectively at the point they answer a question. Prefer supplied SVG and structured JSON over raster reproductions. Keep text alternatives and captions accurate.
- Keep four outcomes distinct: analysis success; semantic proof under stated assumptions; production of a rewritten binary; runtime correctness under a documented test contract. None automatically implies the next.
- Optimization is part of the treatment. Pair specimens with the correct compiler-family and optimization-level clean comparator. Counts from different CFG recovery conventions are not interchangeable.

## Non-negotiable factual boundaries

1. Polaris FLA's stock rewrite is **WRONG**: the smaller graph computes the wrong result. Its explicitly named PE is static negative evidence, never a working sample.
2. Mergen's OLLVM SUB lift is **SEMANTIC FAILURE** although its LLVM IR verifies and recompiles. The original native OLLVM SUB executable passes; do not conflate it with the failing lift.
3. All eight tested BinProtect protected outputs were invalid at runtime (crash/hang). Only reports/static observations are included; no protected BinProtect PE is bundled.
4. Tigress opaque proofs depend on the captured initialized state. They do not establish opacity for arbitrary globals, allocation outcomes or later mutation.
5. Hikari's injected O0 BCF Jccs were folded before native predicate analysis. The remaining genuine branches must not be credited as removed injected predicates.
6. Hikari and OLLVM annotation-only SUB pilots did not transform the targets. Retained matrices use global flags; target-only measurements do not imply function-isolated treatments.
7. Rewritten functions must not inherit trust in original PDB instruction mappings. This package omits PDB/MAP files and supplies export/RVA navigation instead.

## Two numbering schemes and two screenshot holds

New handoff story IDs follow the user's screenshots: 1 SUB, 2 MBA, 3 OLLVM BCF, 4 OLLVM FLA, 5 Polaris wrong FLA, 6 Tigress arithmetic, 7 Polaris BCF, 8 Tigress Flatten. Older research-pack folders and unchanged lecture table 12 use different IDs for stories 4–7. Use the cross-reference in [VISUAL_INDEX](VISUAL_INDEX.md).

Two screenshots are preserved but on publication hold:

- `demo_flattening5_clean_to_rewritten_1.jpg` appears to show OLLVM's rewritten code in its right pane, not the labelled Polaris rewrite.
- `demo_substitution6_1.jpg` explicitly shows `demo_flattening`, not the arithmetic target.

Do not infer missing evidence from those names. Recommended alternatives are already selected in the topic map. Neither issue prevents course planning.

## Portability and scope

The 21 supplied executables are Windows x64 PE, not Linux binaries. Linux can host the notes and static-analysis assets. Optional native execution and x64dbg labs require a separately supplied Windows x64 environment. No Wine execution, modern-tool rebuild or Linux reproduction is claimed. Core exercises have a supplied-text/visual route and do not require commercial decompilers, paid Binary Ninja, toolchain rebuilding or internet access.

Research reports and evidence files are byte-for-byte copies. Their Windows paths and old future-work recommendations are archival context, not instructions. [ARCHIVAL_REPORT_LINKS](ARCHIVAL_REPORT_LINKS.md) maps included references and labels intentionally omitted deeper evidence. [ASSET_MANIFEST](ASSET_MANIFEST.json) records source paths, hashes, correctness and execution status. The full Windows research tree remains the exhaustive archive; it is intentionally not copied here.

Before public deployment, the course owner must settle institutional requirements, learner platform/tool access and asset/software redistribution permissions. No third-party tool installers or research toolchains are bundled. Do not treat academic access as blanket redistribution permission.

Your later deliverable should be a course, not a claim of universal deobfuscation. This handoff ends before website work begins.
