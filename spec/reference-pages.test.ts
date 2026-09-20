// Three pages on this site are the research package's own reference tables,
// rendered at build time rather than retyped: the claim boundaries, the
// glossary and the tool catalogue.
//
// The point of generating them is that they cannot drift from the source. The
// risk of generating them is that a parser change empties one silently, and
// nobody notices because the page still looks like a page. So the row counts
// are asserted against the documents.
import { describe, expect, it } from "vitest";
import { markdownTableRows, page, text } from "./site";

const HANDOFF = "claude_course_handoff_v1";

const rowCount = (route: string): number => {
  const html = page(route).html;
  return (html.match(/<tr>/g) ?? []).length;
};

describe("the claim boundaries page", () => {
  const source = markdownTableRows(`${HANDOFF}/CLAIMS_AND_CAVEATS.md`);

  it("renders every row of the authoritative table", () => {
    expect(source.length).toBeGreaterThan(20);
    // One header row plus one row per boundary.
    expect(rowCount("/claims/")).toBeGreaterThanOrEqual(source.length + 1);
  });

  it("states the row count it rendered, so a reader can check it", () => {
    expect(text(page("/claims/").html)).toContain(String(source.length));
  });

  it("carries the four statements the site will never make", () => {
    const content = text(page("/claims/").html);
    expect(content).toMatch(/smaller control-flow graph/i);
    expect(content).toMatch(/verifier-valid/i);
    expect(content).toMatch(/BinProtect/);
    expect(content).toMatch(/3,917|3917/);
  });
});

describe("the glossary", () => {
  const source = markdownTableRows(`${HANDOFF}/TERMINOLOGY.md`);

  it("renders every term from the authoritative table", () => {
    expect(source.length).toBeGreaterThan(20);
    expect(rowCount("/glossary/")).toBeGreaterThanOrEqual(source.length + 1);
  });

  it("defines the terms the assessments depend on", () => {
    const content = text(page("/glossary/").html);
    for (const term of ["Opaque predicate", "UNSAT", "UNKNOWN", "Lifting", "Dispatcher", "MBA"]) {
      expect(content, `glossary does not define "${term}"`).toContain(term);
    }
  });
});

describe("the tools page", () => {
  it("renders all three of the catalogue's tables", () => {
    const html = page("/tools/").html;
    expect((html.match(/<table>/g) ?? []).length).toBeGreaterThanOrEqual(4);
  });

  it("says what each tool produced, not only what it is for", () => {
    const content = text(page("/tools/").html);
    expect(content).toMatch(/Working rewritten binary/i);
    expect(content).toMatch(/No core exercise|read-only|without a decompiler|paid decompiler/i);
  });

  it("separates the two things called Triton and the two called virtualization", () => {
    const content = text(page("/tools/").html);
    expect(content).toMatch(/GPU/);
    expect(content).toMatch(/virtual machine|embedded interpreter/i);
  });
});

describe("the evidence page", () => {
  it("catalogues the specimens without offering them for download", () => {
    const content = text(page("/evidence/").html);
    expect(content).toMatch(/INCORRECT_DEOBFUSCATION/);
    expect(content).toMatch(/No executable is downloadable/i);
    expect(content).toMatch(/demo_substitution/);
  });

  it("warns about the stale debug mappings in a rewritten specimen", () => {
    expect(text(page("/evidence/").html)).toMatch(/RSDS|PDB/);
  });
});

describe("course information", () => {
  // Five things this page exists to answer. Generic administration —
  // extensions, remarking, turnaround — is deliberately not among them.
  it("answers what a student needs to use the course", () => {
    const content = text(page("/policies/").html);
    expect(content, "no prerequisites").toMatch(/Assumed before week 1|prerequisite/i);
    expect(content, "no teaching format").toMatch(/stud(io|ios)|lecture/i);
    expect(content, "no read-only route").toMatch(/read-only route/i);
    expect(content, "no lab safety rule").toMatch(/endpoint protection/i);
    expect(content, "no accessibility guidance").toMatch(/Accessibility/i);
    expect(content, "no assessment summary").toMatch(/25%|assessment/i);
  });

  it("is labelled course information everywhere it is linked", () => {
    for (const route of ["/", "/sessions/", "/assessments/"]) {
      const html = page(route).html;
      if (!html.includes('href="') || !html.includes("/policies/")) continue;
      expect(text(html), `${route} still calls it Policies`).not.toMatch(/\bPolicies\b/);
    }
  });
});
