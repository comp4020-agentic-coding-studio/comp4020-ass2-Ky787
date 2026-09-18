// The promises this course makes about its own honesty.
//
// Two results in this corpus look like successes and are not, and one tool
// lane produced eight binaries that all crash or hang. The teaching value of
// all three depends entirely on never being described as anything else. Prose
// drifts, so the labels are asserted here rather than trusted.
//
// The forbidden-phrasing list is generated: CLAIMS_AND_CAVEATS.md has a
// "DO NOT SAY" column, and the site is checked against it.
import { describe, expect, it } from "vitest";
import { markdownTableRows, page, pages, sitePages, text } from "./site";

const CLAIMS = "claude_course_handoff_v1/CLAIMS_AND_CAVEATS.md";

/** Pages that may quote an overclaim, because quoting it is their subject. */
const QUOTES_OVERCLAIMS = new Set(["/claims/"]);

const body = (route: string): string => text(page(route).html);

describe("the incorrect rewrite stays labelled incorrect", () => {
  // The rewrite that shrank a graph from 56 blocks to 10 and returns
  // F9CD8332 instead of DBEFFCE7. Anywhere the site shows that value, it has
  // to show the verdict too.
  const WRONG_OUTPUT = "F9CD8332";

  it("appears somewhere — this course is built on it", () => {
    const mentions = sitePages().filter((candidate) => text(candidate.html).includes(WRONG_OUTPUT));
    expect(mentions.length, "the wrong-answer specimen is not discussed anywhere").toBeGreaterThan(
      1,
    );
  });

  it("carries a verdict on every page that shows its output", () => {
    for (const candidate of sitePages()) {
      const content = text(candidate.html);
      if (!content.includes(WRONG_OUTPUT)) continue;
      expect(
        /WRONG|incorrect|wrong answer|wrong value|wrong semantics|FAIL/i.test(content),
        `${candidate.route} shows ${WRONG_OUTPUT} without labelling the result`,
      ).toBe(true);
    }
  });

  it("shows the expected value beside it, so the failure is checkable", () => {
    for (const candidate of sitePages()) {
      const content = text(candidate.html);
      if (!content.includes(WRONG_OUTPUT)) continue;
      expect(
        content.includes("DBEFFCE7"),
        `${candidate.route} shows the wrong output without the expected one`,
      ).toBe(true);
    }
  });

  it("is never presented as a successful deobfuscation", () => {
    for (const candidate of pages()) {
      if (QUOTES_OVERCLAIMS.has(candidate.route)) continue;
      const content = text(candidate.html).toLowerCase();
      for (const phrase of [
        "successfully deobfuscated",
        "successful deobfuscation of the polaris",
        "polaris fla was successfully",
      ]) {
        expect(content.includes(phrase), `${candidate.route} contains "${phrase}"`).toBe(false);
      }
    }
  });
});

describe("the mislifted IR stays labelled a semantic failure", () => {
  // Verifier-clean LLVM IR that miscomputes 3,917 of 4,118 inputs.
  it("labels the failure on every page that quotes the mismatch count", () => {
    const mentions = sitePages().filter((candidate) =>
      /3,?917/.test(text(candidate.html)),
    );
    expect(mentions.length, "the mislift is not discussed anywhere").toBeGreaterThan(1);
    for (const candidate of mentions) {
      const content = text(candidate.html);
      expect(
        /SEMANTIC FAILURE|miscomput|wrong|mismatch/i.test(content),
        `${candidate.route} quotes the mismatch count without naming the failure`,
      ).toBe(true);
    }
  });

  it("never claims verifier validity implies a correct lift", () => {
    for (const candidate of pages()) {
      if (QUOTES_OVERCLAIMS.has(candidate.route)) continue;
      const content = text(candidate.html).toLowerCase();
      for (const phrase of [
        "valid ir means the lift is correct",
        "verifier-valid lifted ir is semantically correct",
        "the verifier proves the lift",
      ]) {
        expect(content.includes(phrase), `${candidate.route} contains "${phrase}"`).toBe(false);
      }
    }
  });

  it("keeps the native input's PASS separate from the lift's failure", () => {
    const week = body("/sessions/week-11/");
    expect(week).toMatch(/native (?:PE|binary|input)[^.]{0,80}(?:PASS|passes)/i);
  });
});

describe("the post-link lane stays static-only", () => {
  it("marks it invalid wherever it is named", () => {
    const mentions = sitePages().filter((candidate) =>
      /BinProtect|post-link/i.test(text(candidate.html)),
    );
    expect(mentions.length).toBeGreaterThan(0);
    for (const candidate of mentions) {
      const content = text(candidate.html);
      expect(
        /static[- ]only|static observations|static-analysis evidence|0 ?\/ ?8|crash|hang|invalid/i.test(
          content,
        ),
        `${candidate.route} names the post-link lane without its validity status`,
      ).toBe(true);
    }
  });

  it("never describes a protected output as runnable or working", () => {
    for (const candidate of pages()) {
      if (QUOTES_OVERCLAIMS.has(candidate.route)) continue;
      const content = text(candidate.html).toLowerCase();
      for (const phrase of [
        "working protected executable",
        "runnable binprotect",
        "binprotect provides a working",
      ]) {
        expect(content.includes(phrase), `${candidate.route} contains "${phrase}"`).toBe(false);
      }
    }
  });
});

describe("counts carry their convention", () => {
  // The corpus uses two control-flow-graph conventions and they are not
  // interchangeable. Any page quoting a block count from the unflattening
  // study has to say so.
  it("names a convention wherever the flattening block counts appear, slides included", () => {
    for (const candidate of pages()) {
      const content = text(candidate.html);
      if (!/56 (?:blocks )?(?:→|to) 10|56 flattened/.test(content)) continue;
      expect(
        /Miasm|convention|split(?:s)? (?:at|blocks at) calls/i.test(content),
        `${candidate.route} quotes flattening block counts without naming the convention`,
      ).toBe(true);
    }
  });

  it("explains both conventions somewhere a reader will find them", () => {
    const glossary = body("/glossary/");
    expect(glossary).toMatch(/convention/i);
    expect(glossary).toMatch(/split/i);
  });
});

describe("solver vocabulary", () => {
  it("keeps UNKNOWN from being read as equivalence", () => {
    const week = body("/sessions/week-04/");
    expect(week).toMatch(/UNKNOWN/);
    expect(week).toMatch(/not a weak yes|absence of an answer|not accepted/i);
  });

  it("states the path-relative boundary where the proof is taught", () => {
    const week = body("/sessions/week-07/");
    expect(week).toMatch(/path prefix/i);
    expect(week).toMatch(/UNSAT/);
    expect(week).toMatch(/model/i);
  });
});

describe("against the research package's own DO NOT SAY column", () => {
  const rows = markdownTableRows(CLAIMS);

  it("found the boundary table to check against", () => {
    expect(rows.length).toBeGreaterThan(20);
    expect(rows[0]).toHaveLength(3);
  });

  // Each row's middle cell is a sentence the package explicitly forbids. The
  // /claims/ page renders that column on purpose; nowhere else may.
  it("does not state any forbidden formulation", () => {
    const forbidden = rows
      .map((row) => text(row[1] ?? "").replace(/[`*]/g, ""))
      .filter((phrase) => phrase.length > 24);
    expect(forbidden.length).toBeGreaterThan(15);

    const offences: string[] = [];
    for (const candidate of pages()) {
      if (QUOTES_OVERCLAIMS.has(candidate.route)) continue;
      const content = text(candidate.html);
      for (const phrase of forbidden) {
        if (content.includes(phrase)) offences.push(`${candidate.route}: "${phrase}"`);
      }
    }
    expect(offences).toEqual([]);
  });
});

describe("the four outcomes vocabulary", () => {
  const OUTCOMES = ["Analysis success", "Semantic proof", "Binary rewriting", "Runtime correctness"];

  it("appears on the home page, the glossary and every assessment brief", () => {
    const routes = [
      "/",
      "/glossary/",
      "/assessments/",
      "/assessments/a1-trace-the-transformation/",
      "/assessments/a2-recover-the-semantics/",
      "/assessments/capstone-unfamiliar-binary/",
    ];
    for (const route of routes) {
      const content = body(route);
      for (const outcome of OUTCOMES) {
        expect(content, `${route} does not name "${outcome}"`).toContain(outcome);
      }
    }
  });
});
