# Seeing Through Obfuscated Code

This repo builds the SlopU course site for **SLOP8445 — Seeing Through
Obfuscated Code**: obfuscation, assembly, and recovering program semantics.

`claude_course_handoff_v1/` is the technical source of truth. It is a curated
research package — one frozen 483-line C program, sixty-eight build
conditions, twenty-one retained Windows x64 specimens, frozen solver
artefacts, and two results that look like successes and are not.

## Core rules

- Treat `claude_course_handoff_v1/` as the technical source of truth.
- Prefer real supplied source, IR, assembly, CFGs, IDA screenshots, and
  experimental results over invented examples.
- Never invent measurements or claim results not supported by the handoff.
- Distinguish analysis success, semantic proof, binary rewriting, and runtime
  correctness.
- A cleaner CFG or verifier-valid IR does not prove semantic correctness.
- Keep Polaris FLA clearly labelled as an incorrect rewrite.
- Keep Mergen OLLVM SUB clearly labelled as a semantic failure.
- Keep BinProtect protected outputs labelled static-only / non-runnable.
- Respect screenshot publication holds and PDB warnings in the handoff.

## Citing evidence

- **Never paste a listing into a page.** Every snippet comes from
  `EvidenceCode`, which slices it out of the real file at build time. A pasted
  listing and a sliced one look identical and only one of them fails the build
  when the source moves.
- Every artefact a page may cite is named in `src/lib/evidence-manifest.ts`.
  `evidenceUrl()` throws on an unknown id, so a citation to an unpublished
  file cannot ship. Add the entry, run `pnpm artefacts`, then cite it.
- Anchor excerpts with `fromMatch` where the content matters more than the
  line number. The handoff files are CRLF; the excerpt reader normalises them
  and the published copies stay byte-identical.
- Provenance on a page is a **link to the artefact**, not a printed hash. A
  reader cannot check twelve hex digits by eye; the copies are hash-checked in
  `spec/evidence-integrity.test.ts` and the identities stated once on
  `/evidence/`. Print a hash only where it is the claim — the frozen source,
  the two builds that share a generated file, a rewrite's before and after.
- Quote every number with its representation, its counting convention and the
  comparator it was taken against. The corpus uses **two** CFG conventions and
  they are not interchangeable.
- Never publish an `.exe`. The specimens are distributed through the course
  lab, and one of them is an explicitly incorrect rewrite.

## Curriculum

- The 12 weeks must form one cumulative argument rather than 12 independent
  articles. Four blocks of three, each opened by one spine lecture.
- **Introduce a term before the listing that needs it.** Block I is written for
  a reader who has not seen compiler output: `Primer` hands over the vocabulary
  at the point of difficulty, and no week may use a term that no earlier week
  or primer has given. The evidence does not get simpler; the ramp gets built.
- Every week declares a `question` and a `mode` in frontmatter; the schema
  requires both, and `spec/curriculum.test.ts` refuses a `mode` used by three
  or more weeks.
- Every week ends its evidence with a `Ledger` — what it establishes **and**
  what it does not. Both columns are required props.
- Explain intuition first, then expose real technical evidence.
- Weekly pages may use different teaching structures; do not force one
  repeated template.
- Core teaching content lives on the website, not only in PDFs or decks.
- Assessment must total 100%.

## No invented people

- **Do not invent a teaching team.** No named lecturers, biographies,
  credentials, photographs, office locations or consultation hours. A course
  that spends twelve weeks on the difference between something established and
  something that merely looks established cannot open with a fabricated cast.
- Where a reference is structurally necessary — extensions, lab access,
  remarking — use the **role**: "the convenor", "the tutor". That tells a
  reader who to approach without inventing a person to be.
- The `people` collection stays declared in `src/content.config.ts`, because
  the starter fixes the four graph collections, and stays empty. The one
  build warning about it is the truth, not a defect.
- Removing invented material means removing it. Do not backfill the space
  with filler.

## Site quality

- Preserve all assignment/starter SLOP requirements.
- Keep code, tables, CFGs and screenshots readable on desktop and mobile. Test
  at 1920×1080 and 390×844, in both colour schemes.
- Prose sits at `--sc-measure`; evidence gets the full column. Note the theme
  puts an 18px root on the page, so `rem` values are 12.5% larger than they
  look.
- Add meaningful automated checks for important course promises.
- Root-absolute hrefs inside a `set:html` string skip Astro's base handling:
  they work on localhost and 404 on the deployed site. Pass links as
  structured props and apply `withBase` in the component.
- Render the handoff's reference tables from the authoritative markdown
  (`src/lib/mdtable.ts`) rather than retyping them, and assert their row
  counts so an emptied parse fails the build.

## Commands

```sh
pnpm install
pnpm artefacts       # republish the cited slice of the research package
pnpm artwork         # regenerate the hero and card from the retained listings
pnpm dev             # http://localhost:4321/<repo>/
pnpm check           # types, build (axe + links + API) and the spec suite
pnpm check:evidence  # the submission gate
```
