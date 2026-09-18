# Seeing Through Obfuscated Code — course handoff v1

Copy this entire directory to the Linux university machine and give it to the future course-building agent. It is curated evidence and a provisional teaching plan, **not a website implementation**. No new experiments, binary execution or compiler builds were performed during curation.

## Reading order

1. [CLAUDE_SITE_BUILDER_HANDOFF.md](CLAUDE_SITE_BUILDER_HANDOFF.md) — instructions and factual boundaries for the future agent.
2. [COURSE_BRIEF.md](COURSE_BRIEF.md) — thesis, technical level and rationale.
3. [PROVISIONAL_12_WEEK_OUTLINE.md](PROVISIONAL_12_WEEK_OUTLINE.md) — provisional objectives, topics, evidence and activities.
4. [BEST_EVIDENCE_BY_TOPIC.md](BEST_EVIDENCE_BY_TOPIC.md) — primary artifact lookup.
5. [CLAIMS_AND_CAVEATS.md](CLAIMS_AND_CAVEATS.md) — safe claims and explicit overclaims to avoid.
6. [HANDOFF_ASSET_MAP.md](HANDOFF_ASSET_MAP.md) — concept-to-week-to-artifact cross-reference.
7. [VISUAL_INDEX.md](VISUAL_INDEX.md) and [LECTURE_TABLE_INDEX.md](LECTURE_TABLE_INDEX.md) — screenshot interpretation and table selection.
8. Detailed evidence only as required: [corpus](EXPERIMENTAL_CORPUS.md), [tools](TOOL_CATALOG.md), [terms](TERMINOLOGY.md), [timeline](EXPERIMENT_TIMELINE.md), [labs](HANDS_ON_LABS.md), [assessment ideas](ASSESSMENT_IDEAS.md), [bibliography](BIBLIOGRAPHY.md), then reports/results in `assets/`.

## Contents and portability

There are 298 verbatim curated assets: 21 Windows x64 executables, 25 indexed IDA screenshots, 24 CFG SVGs, all 12 lecture tables as SVG/PNG with shared JSON, selected source/IR, and supporting reports/results. The asset total excludes newly authored handoff documents and indexes.

Primary handoff links are relative and use exact filename casing. The package works independently of the Windows research tree for the proposed reading/static labs. Original absolute paths inside copied evidence are provenance; [ARCHIVAL_REPORT_LINKS.md](ARCHIVAL_REPORT_LINKS.md) resolves selected links and marks deeper intentionally unbundled resources. Table 12 and old reports use older story IDs; the visual index gives the crosswalk.

All executables are PE x64, not Linux ELF. Optional execution/debugging requires a supplied Windows x64 environment. Use [BINARY_GUIDE.md](BINARY_GUIDE.md) and [BINARY_INDEX.json](BINARY_INDEX.json) for statuses and export RVAs. The explicitly named wrong Polaris FLA rewrite is static negative evidence only; no BinProtect protected binary or PDB is included. Mergen's OLLVM SUB IR is SEMANTIC FAILURE, while its native input passes.

Two images are preserved on publication hold: the story-5 clean-to-rewrite image appears to show OLLVM code, and the story-6 arithmetic filename visibly shows `demo_flattening`. Exact screenshot database hashes/tool versions were not supplied. These limits do not prevent the proposed course planning; use the recommended alternatives.

## Integrity

[ASSET_MANIFEST.json](ASSET_MANIFEST.json) records original paths, SHA-256, descriptions, correctness and execution statuses; [ASSET_MANIFEST.md](ASSET_MANIFEST.md) is its readable counterpart. [VALIDATION_REPORT.md](VALIDATION_REPORT.md) records the final curation checks. After transfer, run `python3 verify_handoff.py` from this directory to recheck packaged checksums and portable links without executing any specimen or contacting the network.

The full research archive, toolchains, installers and exhaustive logs are deliberately excluded. No final styling, lesson pages, assessment weights or website files have been created. Redistribution permissions and institutional/tool-access requirements remain decisions for the course owner before publication.
