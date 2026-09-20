# Process overview

## What I built

This course is about explaining the actual effects on assembly code by obfuscating it with various tools. It follows twelve weeks that follow one frozen 483-line C program through obfuscation, compilation, disassembly, graph recovery, binary deobfuscation and rewriting to a deobfuscated runnable program. I used 5 public obfuscators, 3 of which are clang based, one edits source and one edits compiled assembly for a diverse survey of different obfuscation methods. Overall the course is supposed to demonstrate to the students how assembly obfuscation and deobfuscation techniques can be generalised. 

## I Generated an entire corpus of binaries and prepared analysis for claude

From a single C source file I was able to generate hundreds of binaries, each with different compilation techniques and flags which I then got another model to automate verifiable results (e.g. did the deobfuscated binary run, how many blocks were added/deleted, did the obfuscation work correctly etc), after which I also opened various binaries in IDA Pro and performed diff's against binaries of interest, captured screenshots and gave all relevant info to claude. With all this work Claude was able to make the site using real data from my experiments instead of just prompting the model to write what it thinks obfuscated/deobfuscated code might look like. 

[`2955b2f`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/2955b2f). 
[`978a080`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/978a080): every artefact a page may cite is named in a manifest, published byte-for-byte, and sliced into the page at build time, so a listing that drifts from its source fails the build.

## Tailored first few weeks for better reading

Previously Claude created the first few lectures with assuming the reader had domain knowledge, this lead to a confusing read especially when I asked other friends to check the site and give feedback. I asked claude to trim unnesseccary stuff (e.g. hashes for various things) and reword various paragraphs to include explanatory content. 

[`9097a48`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/9097a48) 
[`43a3f90`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/43a3f90) 

## Removed visually demoting fake content 

After I gave my first prompt to claude with my dataset it generated the website with additional AI furniture content such as fake teaching staff, policies and addresses. I asked claude to remove it which make the site feel more authentic. This change was also reflected in the CLAUDE.md harness. 

[`18b3e02`](https://github.com/comp4020-agentic-coding-studio/comp4020-ass2-Ky787/commit/18b3e02) removed it, and four checks in `spec/` now hold the line: no people in the generated API, no page linking a person route, no teaching-team block, and the course-information page still naming who to approach by role.
