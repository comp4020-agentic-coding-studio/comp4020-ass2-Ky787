# The spec

Every deliverable's spec — what the markers consider when they judge whether
your work matches what was required — is published on the course website, and
this repo's name tells you which one applies: the course API maps repo prefixes
to deliverables, and the `start` course skill walks your agent through pulling
the right one. The brief poses the problem; the spec is the fixed contract. Read
both on the site before you plan or build.

One file is supplied here:

## Course coherence (shipped, always on)

`data-integrity.test.ts` checks the one cross-page fact the content schemas and
build cannot: dated material stays inside the course period. The build already
owns compilation, accessibility, internal links, content references, API
generation and deck compilation.

## This course's spec tests

Four files, and between them they protect the promises this site makes that a
reader would otherwise have to take on trust.

`curriculum.test.ts` — the structural contract. Twelve dated teaching weeks,
numbered 1 to 12 with no gaps and no week dated before the one before it.
Assessment weights totalling exactly 100. Every assessment declaring how it is
marked and falling due no earlier than the material it is built on. Every
lecture carrying a deck that actually built, with real content on it. The whole
semester linked from every week page, and all twelve linked from the index.
Plus the one that is specific to this course: **no teaching shape may be used
by three or more weeks**, and there must be more than eight distinct shapes
across the twelve. That check cannot tell whether a week is good. It can tell
me I have written the same page twice.

`evidence-integrity.test.ts` — the citation contract. Every one of the
published artefacts is compared by SHA-256 against its original in
`claude_course_handoff_v1/`, in both directions, so a listing on a page cannot
have been retyped or quietly edited. Nothing is published that is not in the
manifest. No Windows executable is served or linked, because one specimen in
this corpus is an explicitly incorrect rewrite. Neither of the two screenshots
that `VISUAL_INDEX.md` puts on publication hold is ever rendered. Every
`/artefacts/` link resolves, every week cites at least four artefacts, and any
page showing a code block names its source file's hash.

`claims.test.ts` — the honesty contract, and the one worth reading. Wherever
the wrong-answer specimen's output appears, the verdict and the expected value
appear with it. Wherever the mislifted IR's mismatch count appears, the failure
is named. Wherever the post-link lane is named, its 0/8 runtime status is
named. Any page quoting the flattening block counts has to name a counting
convention, because the corpus uses two and they are not interchangeable. And
the forbidden-phrasing list is **generated**: the research package's own
`CLAIMS_AND_CAVEATS.md` has a "DO NOT SAY" column, and every page except the
one whose subject is that column is checked against it.

`reference-pages.test.ts` — three pages are rendered from the handoff's
authoritative markdown rather than retyped, so this asserts their row counts
against the source documents. A parser change that silently empties a table
fails here instead of shipping a page that still looks like a page.

Deliberately not mechanised: whether the prose is any good, whether the weeks
are in the right order, and whether a week's evidence is the best available
for its point. Those are the crit's business.

## Writing your own



Turning the week's published spec into tests is your work, not the template's.
Some spec lines are mechanically checkable — assert those here, in your own test
file alongside the supplied ones (any `spec/*.test.ts` runs with `pnpm check`).
Some lines only a person can judge; leave those to the crit. There is no minimum
count: select the checks that protect your work's real promises, and test the
**contracts** — what the page must do, not how you built it — so the tests
survive a change of approach, or of stack.

A green suite here is backpressure, not a mark: your tutor verifies what you
deployed against the published spec at the crit, and keeping your own tests
green is how you arrive with no surprises.
