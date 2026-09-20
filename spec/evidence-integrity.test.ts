// The evidence this course publishes has to be the evidence the experiments
// produced.
//
// This file is the reason the site can make the claims it makes. Every
// artefact a page cites is a byte-identical copy of a file in
// `claude_course_handoff_v1/`, so a listing on a week page cannot have been
// retyped, trimmed to flatter a conclusion, or invented. The hash comparison
// is the whole check; the rest of the file closes the ways around it.
import { createHash } from "node:crypto";
import { existsSync, readFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { describe, expect, it } from "vitest";
import { DIST, exists, links, pages, sitePages, unbase, walk, weekPages } from "./site";

const HANDOFF = "claude_course_handoff_v1";
const PUBLIC = "public/artefacts";

interface Published {
  source: string;
  count: number;
  files: { id: string; url: string; sha256: string; bytes: number }[];
}

const published = JSON.parse(
  readFileSync(resolve(PUBLIC, "published-evidence.json"), "utf8"),
) as Published;

const sha256 = (path: string): string =>
  createHash("sha256").update(readFileSync(path)).digest("hex").toUpperCase();

describe("published artefacts are the originals", () => {
  it("publishes something to cite", () => {
    expect(published.source).toBe(HANDOFF);
    expect(published.files.length).toBe(published.count);
    expect(published.count).toBeGreaterThan(100);
  });

  it("matches every original's SHA-256, byte for byte", () => {
    const wrong: string[] = [];
    for (const entry of published.files) {
      const original = resolve(HANDOFF, entry.id);
      const copy = resolve(PUBLIC, entry.url.replace(/^\/artefacts\//, ""));
      if (!existsSync(original)) {
        wrong.push(`${entry.id}: missing from the research package`);
        continue;
      }
      if (!existsSync(copy)) {
        wrong.push(`${entry.id}: not published`);
        continue;
      }
      const actual = sha256(copy);
      if (actual !== sha256(original)) wrong.push(`${entry.id}: copy differs from the original`);
      if (actual !== entry.sha256) wrong.push(`${entry.id}: recorded hash is stale`);
    }
    expect(wrong).toEqual([]);
  });

  it("publishes nothing that is not in the manifest", () => {
    const declared = new Set(
      published.files.map((entry) => entry.url.replace(/^\/artefacts\//, "")),
    );
    const orphans = walk(resolve(PUBLIC)).filter((file) => {
      if (file === "published-evidence.json") return false;
      // Width-capped screenshot derivatives for inline display; the verbatim
      // original sits beside each one and is hash-checked above.
      if (/-w\d+\.(avif|jpg)$/.test(file)) return false;
      return !declared.has(file);
    });
    expect(orphans).toEqual([]);
  });

  it("keeps the frozen source at the hash the research package recorded", () => {
    const showcase = published.files.find((entry) => entry.id.endsWith("source/showcase.c"));
    expect(showcase).toBeTruthy();
    // The same value is stated independently in three of the package's own
    // documents. If the source ever changed, the corpus would stop being a
    // controlled experiment, so this is worth asserting rather than trusting.
    const corpus = readFileSync(join(HANDOFF, "EXPERIMENTAL_CORPUS.md"), "utf8");
    expect(corpus).toContain(showcase!.sha256);
  });
});

describe("what the site refuses to publish", () => {
  // Obfuscated Windows binaries do not belong on a public web page, and one of
  // the corpus's specimens is an explicitly incorrect rewrite that must never
  // be one click from looking runnable.
  it("serves no Windows executable", () => {
    const executables = walk(DIST).filter((file) => /\.(exe|dll|sys|pdb)$/i.test(file));
    expect(executables).toEqual([]);
    for (const sitePage of pages()) {
      const bad = links(sitePage.html).filter((href) => /\.exe(\?|#|$)/i.test(href));
      expect(bad, `${sitePage.route} links an executable`).toEqual([]);
    }
  });

  // VISUAL_INDEX.md puts two screenshots on publication hold: in each, the
  // visible content contradicts the filename. The site discusses them by name
  // and never renders them.
  const held = ["demo_flattening5_clean_to_rewritten_1.jpg", "demo_substitution6_1.jpg"];

  it("ships neither held screenshot", () => {
    for (const name of held) {
      const shipped = walk(DIST).filter((file) => file.includes(name.replace(".jpg", "")));
      expect(shipped, `${name} was published despite its hold`).toEqual([]);
    }
  });

  it("never renders a held screenshot, and only names them where the hold is explained", () => {
    for (const sitePage of pages()) {
      for (const name of held) {
        const referenced = links(sitePage.html).some((href) => href.includes(name));
        expect(referenced, `${sitePage.route} references ${name}`).toBe(false);
      }
    }
    // Naming them is the point on the evidence page; it must say why.
    const evidence = pages().find((candidate) => candidate.route === "/evidence/")!;
    for (const name of held) expect(evidence.html).toContain(name);
    expect(evidence.html).toMatch(/publication hold|hold/i);
  });
});

describe("citations resolve", () => {
  it("has a working file behind every artefact link on every page", () => {
    const broken: string[] = [];
    for (const sitePage of pages()) {
      for (const href of links(sitePage.html)) {
        if (!href.includes("/artefacts/")) continue;
        const target = unbase(href.split(/[?#]/)[0]!);
        if (!exists(target)) broken.push(`${sitePage.route} -> ${href}`);
      }
    }
    expect(broken).toEqual([]);
  });

  // A week that teaches from evidence has to actually point at some.
  it("cites at least four distinct artefacts on every week page", () => {
    for (const weekPage of weekPages()) {
      const cited = new Set(
        links(weekPage.html)
          .filter((href) => href.includes("/artefacts/"))
          .map((href) => unbase(href.split(/[?#]/)[0]!)),
      );
      expect(cited.size, `${weekPage.route} cites only ${cited.size} artefacts`).toBeGreaterThan(3);
    }
  });

  // A listing is worth nothing unless the reader can reach the file it came
  // from. Every evidence pane therefore carries a link to its own artefact —
  // which only the build-time excerpt component emits, so a listing pasted
  // into a page fails this.
  //
  // This used to assert a printed SHA-256 instead. The hash was dropped from
  // the pane because a reader cannot check twelve hex digits by eye, and the
  // copy's identity is already asserted above, against the original. The
  // contract the page owes is reachability, so that is what is tested.
  const panes = (html: string): string[] => html.split('<figure class="sc-pane').slice(1);

  it("links its own source artefact from every evidence pane", () => {
    for (const sitePage of sitePages()) {
      for (const pane of panes(sitePage.html)) {
        const foot = pane.split("</figure>")[0] ?? "";
        if (!foot.includes("<pre") && !foot.includes("<table")) continue;
        expect(
          foot.includes("/artefacts/"),
          `a pane on ${sitePage.route} shows evidence without linking its artefact`,
        ).toBe(true);
      }
    }
  });

  // One week of the twelve is a synthesis week with no listings of its own.
  // More than that and the course has stopped teaching from evidence.
  it("teaches from sliced-out evidence in at least ten of the twelve weeks", () => {
    const withExcerpts = weekPages().filter((weekPage) =>
      panes(weekPage.html).some((pane) => pane.includes("<pre")),
    );
    expect(withExcerpts.length).toBeGreaterThanOrEqual(10);
  });
});

describe("the research package is intact", () => {
  it("still contains every artefact the site cites", () => {
    const missing = published.files
      .map((entry) => entry.id)
      .filter((id) => !existsSync(resolve(HANDOFF, id)));
    expect(missing).toEqual([]);
  });

  it("still contains the curation validation record", () => {
    const report = readFileSync(join(HANDOFF, "VALIDATION_REPORT.md"), "utf8");
    expect(report).toContain("298/298 PASS");
  });
});

describe("pages that are not evidence pages", () => {
  it("keeps the site's own pages out of the artefact tree", () => {
    for (const sitePage of sitePages()) {
      expect(sitePage.file.startsWith("artefacts/")).toBe(false);
    }
  });
});
