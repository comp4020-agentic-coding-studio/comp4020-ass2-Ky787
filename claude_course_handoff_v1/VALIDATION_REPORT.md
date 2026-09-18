# Curation validation — PASS

Validated 2026-09-18T06:04:43+00:00. This is integrity, navigation and evidence-label QA, **not a new experiment**. No specimen was executed, rebuilt or patched; no source or upstream toolchain was modified.

| Check | Result |
| --- | --- |
| Copied assets exist and match both copied-from and authoritative-original SHA-256 | 298/298 PASS |
| Pre-curation original-file snapshot | 347/347 unchanged; complete inventories unchanged for evidence pack, lecture tables, docs and src |
| Frozen source hashes | Both exactly match the requested hashes |
| PE headers / binary index | 21 AMD64 PE32+ files; all indexed |
| Screenshots | 25 visually inspected and indexed; 2 explicit publication holds |
| CFG visuals | 24 selected SVGs |
| Lecture tables | 12 indexed; SVG/PNG/shared JSON copied unchanged |
| Topic mappings | 16 concept entries checked |
| Provisional outline | 12 weeks, each with objective, 2–4 grouped subtopics, evidence, table, screenshot availability, activity and prerequisites |
| Linux portability | Primary Markdown and index paths exist with exact case; no case-colliding filenames or symlinks |
| Historical report references | 207 catalogued: 80 mapped to included assets, 127 intentionally not bundled |
| Invalid Polaris rewrite | Explicit WRONG status, warning filename and NO-execution classification |
| Mergen OLLVM SUB lift | SEMANTIC FAILURE on every included corresponding IR/result asset; native input remains PASS |
| Hikari targeting | Corrected global-switch / inactive annotation-pilot wording retained in table and overview |
| PDB / MAP files | None included; rewritten internals must not use original PDB mappings |
| BinProtect protected executables | None included; runtime failures documented, not presented as working samples |
| Website implementation | No HTML/CSS/JS/site files; no final styling or lesson pages |

## Transfer check

Run `python3 verify_handoff.py` after copying the complete directory. It uses only the Python standard library, reads packaged files, checks asset and whole-package SHA-256 values, validates primary local links with Linux-exact case and inspects PE headers. It never launches an executable, compiles IR or accesses the network. [SHA256SUMS.txt](SHA256SUMS.txt) covers every packaged file except itself; it detects accidental alteration, not adversarial replacement of both data and checksum inventory.

Copied reports remain verbatim archival evidence. Their old Windows links and structured-data provenance paths are intentionally not rewritten; [ARCHIVAL_REPORT_LINKS.md](ARCHIVAL_REPORT_LINKS.md) is the resolver. Primary handoff navigation and proposed core/static labs do not require those unbundled research-tree files. External bibliography links were checked during curation but are not part of the offline validator.

## Remaining limits

- The story-5 clean-to-rewrite screenshot has a content/filename conflict; the story-6 screenshot visibly shows the wrong target. Both are retained with publication holds, not silently relabelled. See [VISUAL_INDEX.md](VISUAL_INDEX.md).
- No confirmed Tigress arithmetic-target screenshot or Mergen-output screenshot was supplied; actual disassembly/IR is included instead. Capture versions/database hashes are also unavailable.
- Native optional execution/x64dbg requires a separately supplied Windows x64 environment. PASS is inherited from retained tests, not a Linux compatibility claim or universal correctness proof.
- Course workload, assessment weighting, student tool access and redistribution permissions remain open. Website work has not begun.

Machine-readable QA: [VALIDATION_REPORT.json](VALIDATION_REPORT.json). Asset provenance: [ASSET_MANIFEST.json](ASSET_MANIFEST.json).
