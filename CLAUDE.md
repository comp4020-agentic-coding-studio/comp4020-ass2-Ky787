# Seeing Through Obfuscated Code

This repo contains a 12-week course about code obfuscation, assembly, and recovering program semantics.

## Core rules

- Treat `claude_course_handoff_v1/` as the technical source of truth.
- Prefer real supplied source, IR, assembly, CFGs, IDA screenshots, and experimental results over invented examples.
- Never invent measurements or claim results not supported by the handoff.
- Distinguish analysis success, semantic proof, binary rewriting, and runtime correctness.
- A cleaner CFG or verifier-valid IR does not prove semantic correctness.
- Keep Polaris FLA clearly labelled as an incorrect rewrite.
- Keep Mergen OLLVM SUB clearly labelled as a semantic failure.
- Keep BinProtect protected outputs labelled static-only / non-runnable.
- Respect screenshot publication holds and PDB warnings in the handoff.

## Curriculum

- The 12 weeks must form one cumulative argument rather than 12 independent articles.
- Explain intuition first, then expose real technical evidence.
- Weekly pages may use different teaching structures; do not force one repeated template.
- Core teaching content should live on the website, not only in PDFs.
- Assessment must total 100%.

## Site quality

- Preserve all assignment/starter SLOP requirements.
- Keep code, tables, CFGs and screenshots readable on desktop and mobile.
- Add meaningful automated checks for important course promises.
