# Process overview

## What I built

This course is about explaining the actual effects on assembly code by obfuscating it with various tools. It follows twelve weeks that follow one frozen 483-line C program through obfuscation, compilation, disassembly, graph recovery, binary deobfuscation and rewriting to a deobfuscated runnable program. I used 5 public obfuscators, 3 of which are clang based, one edits source and one edits compiled assembly for a diverse survey of different obfuscation methods. Overall the course is supposed to demonstrate to the students how assembly obfuscation and deobfuscation techniques can be generalised. 

## I Generated an entire corpus of binaries and prepared analysis for claude

From a single C source file I was able to generate hundreds of binaries, each with different compilation techniques and flags which I then got another model to automate verifiable results (e.g. did the deobfuscated binary run, how many blocks were added/deleted, did the obfuscation work correctly etc), after which I also opened various binaries in IDA Pro and performed diff's against binaries of interest, captured screenshots and gave all relevant info to claude. With all this work Claude was able to make the site using real data from my experiments instead of just prompting the model to write what it thinks obfuscated/deobfuscated code might look like. 

The corpus and the analysis landed in [`2955b2f`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/2955b2f). What makes the site use it rather than paraphrase it is [`978a080`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/978a080): every artefact a page may cite is named in a manifest, published byte-for-byte, and sliced into the page at build time, so a listing that drifts from its source fails the build.

## Tailored first few weeks for better reading

Previously Claude created the first few lectures with assuming the reader had domain knowledge, this lead to a confusing read especially when I asked other friends to check the site and give feedback. I asked claude to trim unnesseccary stuff (e.g. hashes for various things) and reword various paragraphs to include explanatory content. 

[`9097a48`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/9097a48) built the ramp into weeks 1 to 3 and dropped the hashes; [`43a3f90`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/43a3f90) did the same for the home page, which was hitting visitors with the Polaris failure before defining a basic block.

## Added curated graphics

When I was running the experiments I was manually opening various binaries in IDA and performing diffs, I took screenshots of these and provided them to claude to help break out the text in the lectures. I also asked Codex to summarise and generate nice graphics for claude to use. These were then included in the handoff and I 

The screenshots go to work across the twelve weeks in [`3e07c2f`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/3e07c2f), which also renders all twelve Codex tables — from their shared `tables.json` rather than as images, so they stay selectable, searchable and legible in dark mode and at 390px. The authoring project behind them, with its printable PDF, arrived later in [`9097a48`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/9097a48).
