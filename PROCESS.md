# Process overview

## What I built

This course is about explaining the actual effects of various obfuscation tools on assembly code. Across twelve weeks, it follows one frozen 483-line C program through obfuscation, compilation, disassembly, graph recovery, binary deobfuscation and rewriting to a deobfuscated runnable program. I used five public obfuscators: three are Clang-based, one edits source and one edits compiled assembly, providing a diverse survey of obfuscation methods. Overall, the course is supposed to demonstrate to students how assembly obfuscation and deobfuscation techniques can be generalised.

## I generated an entire corpus of binaries and prepared analysis for Claude

From a single C source file, I was able to generate hundreds of binaries, each with different compilation techniques and flags. I then got another model to automate verifiable results (e.g. whether the deobfuscated binary ran, how many blocks were added or deleted, and whether the obfuscation worked correctly). After that, I opened various binaries in IDA Pro, performed diffs against binaries of interest, captured screenshots and gave all the relevant information to Claude. With all this work, Claude was able to make the site using real data from my experiments instead of just prompting the model to write what it thinks obfuscated or deobfuscated code might look like.

[`2955b2f`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/2955b2f).
[`978a080`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/978a080): every artefact a page may cite is named in a manifest, published byte-for-byte, and sliced into the page at build time, so a listing that drifts from its source fails the build.

## Tailored first few weeks for better reading

Previously, Claude created the first few lectures assuming the reader had domain knowledge. This led to a confusing read, especially when I asked other friends to check the site and give feedback. I asked Claude to trim unnecessary material (e.g. hashes for various things) and reword various paragraphs to include explanatory content.

[`9097a48`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/9097a48)
[`43a3f90`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/43a3f90)

## Removed visually distracting fake content

After I gave my first prompt to Claude with my dataset, it generated the website with additional AI furniture such as fake teaching staff, addresses and generic university administration. I asked Claude to remove the fictional teaching team and unnecessary institutional filler because they made the site feel like a generic generated university template rather than a deliberately authored technical course. This change was also reflected in the CLAUDE.md harness. After verification, I realised that Claude had left stale links that were now 404s, so I got the agent to create tests to ensure it would not happen again (`spec/reference-pages.test.ts`).

[`18b3e02`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/18b3e02)
[`6e584ab`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/6e584ab)
