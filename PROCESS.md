# Process overview

## What I built

`SLOP8445 — Seeing Through Obfuscated Code`: twelve dated weeks that follow one
frozen 483-line C program through obfuscation, compilation, disassembly, graph
recovery, symbolic execution, binary rewriting and lifting. The course already
had its evidence — a curated research package sitting in the repo — so the
design problem was never "invent a course". It was resisting the pull of
somebody else's results. Two of them look like successes and are not: a rewrite
whose graph shrinks from 56 blocks to 10 and returns the wrong value, and a
lift whose LLVM IR verifies cleanly and miscomputes 3,917 of 4,118 inputs.
Those two are the course.

## How I got here

The decision everything else rests on is that **no page contains a pasted
listing**. Every snippet is sliced out of the real artefact while the site
builds, through a manifest that throws on an unknown id
([`978a080`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/978a080)).
The obvious approach — copy the interesting instructions into MDX — produces a
page that looks identical and drifts silently. This one cannot: an anchor that
no longer matches its file fails the build. It failed on the first attempt,
because the handoff files are CRLF and my anchor regex ended in `$`, which is
precisely the class of defect the mechanism exists to catch. The same
reasoning made me generate three reference pages from the handoff's own
markdown rather than retype them; a transcription of a claim-boundaries table
is a copy that can go stale.

Three promises went into the content schemas, so a bad page cannot build: every
week declares a driving question and a teaching shape, every lecture carries a
real deck, every assessment states how it is marked. Nine more went into
`spec/` — twelve dated weeks in order, weights totalling 100, a SHA-256
identity check on all 168 published artefacts, no `.exe` served, neither
publication-held screenshot ever rendered, and forbidden phrasings parsed
straight out of the research package's own "DO NOT SAY" column.

Writing those tests found five real defects rather than confirming the site was
fine
([`3e07c2f`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/3e07c2f)).
The evidence page named BinProtect in passing without its 0/8 runtime status.
Three separate places quoted "56 blocks to 10" with no counting convention
attached — the corpus uses two and they are not interchangeable. And my
excerpt-provenance check was simply too strict: week 12 is a synthesis week
with no listings, and the test would have pushed one onto it for its own
benefit, so I rewrote it as the contract I actually wanted.

The check I am least sure of is the one I would keep: no teaching shape may be
used by three or more weeks. It cannot tell whether a week is any good. It can
tell me I have written the same page twice, which was the failure mode I was
most likely to reach for at week nine.

Then Chrome at both viewports found what no test could
([`1c2e65f`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/1c2e65f)):
the reading measure applied only to direct children of the content column, so
the intro to every week set 70-character lines and the body below it set 95.

Left to judgement, deliberately: whether the prose earns its length, whether
week 9 needs to precede week 10, and how much of a negative result belongs on
a home page. The full range is
[`2955b2f...1c2e65f`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/compare/2955b2f...1c2e65f).
