// The course's structural promises.
//
// These are the lines on the assessment page and on this site that a reader
// would be entitled to rely on: twelve dated teaching weeks, assessment that
// adds to 100%, a lecture with a real deck behind it, and — the one that is
// specific to this course — twelve weeks that are not twelve copies of one
// page.
import { describe, expect, it } from "vitest";
import { api, exists, nodesOfType, page, sitePages, text, weekPages } from "./site";

const sessions = nodesOfType("sessions");
const lectures = nodesOfType("lectures");
const assessments = nodesOfType("assessments");

const week = (node: { meta?: Record<string, unknown> }): number => Number(node.meta?.week);
const metaString = (node: { meta?: Record<string, unknown> }, key: string): string =>
  String(node.meta?.[key] ?? "");

describe("twelve dated teaching weeks", () => {
  it("has exactly twelve, numbered 1 to 12 with no gaps or repeats", () => {
    expect(sessions).toHaveLength(12);
    expect(sessions.map(week).sort((a, b) => a - b)).toEqual([
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
    ]);
  });

  it("runs them in order: a later week never has an earlier date", () => {
    const dated = sessions
      .map((session) => ({ week: week(session), date: String(session.meta?.date).slice(0, 10) }))
      .sort((a, b) => a.week - b.week);
    for (let index = 1; index < dated.length; index += 1) {
      expect(
        dated[index]!.date > dated[index - 1]!.date,
        `week ${dated[index]!.week} (${dated[index]!.date}) is not after week ${dated[index - 1]!.week} (${dated[index - 1]!.date})`,
      ).toBe(true);
    }
  });

  it("builds a page for every week", () => {
    expect(weekPages()).toHaveLength(12);
    for (const session of sessions) {
      expect(exists(`${session.id}/index.html`), `${session.id} has no built page`).toBe(true);
    }
  });

  it("gives every week a driving question and a named teaching shape", () => {
    for (const session of sessions) {
      const question = metaString(session, "question");
      const mode = metaString(session, "mode");
      expect(question.length, `${session.id} has no question`).toBeGreaterThan(19);
      expect(question, `${session.id}'s question is not a question`).toMatch(/\?$/);
      expect(mode.length, `${session.id} has no mode`).toBeGreaterThan(2);
    }
  });

  // The anti-template check. The brief this site answers warns that repetitive
  // weeks damage it regardless of what CI says, and "each week declares its
  // teaching shape" is only worth having if the shapes actually differ. Two
  // weeks may share a shape; three is a template.
  it("does not reuse one teaching shape across three or more weeks", () => {
    const counts = new Map<string, string[]>();
    for (const session of sessions) {
      const mode = metaString(session, "mode").toLowerCase();
      counts.set(mode, [...(counts.get(mode) ?? []), session.id]);
    }
    const overused = [...counts.entries()].filter(([, ids]) => ids.length > 2);
    expect(overused, `teaching shapes reused too often: ${JSON.stringify(overused)}`).toEqual([]);
    expect(counts.size, "not enough distinct teaching shapes across twelve weeks").toBeGreaterThan(
      8,
    );
  });

  // Every week page carries the course's signature block, and it has two
  // columns on purpose: what the evidence establishes, and what it does not.
  // A week that only ships the first half has stopped teaching the subject.
  it("files every week's evidence with what it does not establish", () => {
    for (const weekPage of weekPages()) {
      const body = text(weekPage.html);
      expect(body, `${weekPage.route} has no "This establishes" column`).toContain(
        "This establishes",
      );
      expect(body, `${weekPage.route} has no "This does not establish" column`).toContain(
        "This does not establish",
      );
    }
  });

  it("puts the whole semester on every week page", () => {
    for (const weekPage of weekPages()) {
      for (const session of sessions) {
        expect(
          weekPage.html.includes(`/${session.id}/`),
          `${weekPage.route} does not link ${session.id}`,
        ).toBe(true);
      }
    }
  });
});

describe("assessment", () => {
  it("adds up to exactly 100%", () => {
    const total = assessments.reduce((sum, node) => sum + Number(node.meta?.weight), 0);
    expect(total).toBe(100);
  });

  it("says how each piece is marked, and poses a spec a reader can check", () => {
    expect(assessments.length).toBeGreaterThanOrEqual(2);
    for (const assessment of assessments) {
      expect(assessment.meta?.marking, `${assessment.id} has no marking model`).toBeTruthy();
      expect(assessment.spec?.length ?? 0, `${assessment.id} has a thin spec`).toBeGreaterThan(3);
      expect(String(assessment.meta?.label ?? ""), `${assessment.id} has no label`).not.toBe("");
      expect(exists(`${assessment.id}/index.html`)).toBe(true);
    }
  });

  it("falls due no earlier than the material it is built on", () => {
    const sessionWeek = new Map(sessions.map((session) => [session.id, week(session)]));
    for (const assessment of assessments) {
      const dependsOn = (assessment.related ?? [])
        .map((ref) => sessionWeek.get(ref))
        .filter((value): value is number => value !== undefined);
      if (dependsOn.length === 0) continue;
      expect(
        Number(assessment.meta?.week) >= Math.max(...dependsOn),
        `${assessment.id} is due in week ${assessment.meta?.week} but depends on week ${Math.max(...dependsOn)}`,
      ).toBe(true);
    }
  });

  it("is reachable from the assessment index", () => {
    const index = page("/assessments/");
    for (const assessment of assessments) {
      expect(index.html.includes(`/${assessment.id}/`), `index does not link ${assessment.id}`).toBe(
        true,
      );
    }
  });
});

describe("lectures and decks", () => {
  it("has at least one lecture, and every one of them carries a real deck", () => {
    expect(lectures.length).toBeGreaterThanOrEqual(1);
    for (const lecture of lectures) {
      const slides = String(lecture.meta?.slides ?? "");
      expect(slides, `${lecture.id} declares no deck`).toMatch(/^\/decks\/[a-z0-9-]+\/$/);
      expect(
        exists(`${slides.replace(/^\//, "")}index.html`),
        `${lecture.id} points at ${slides}, which did not build`,
      ).toBe(true);
    }
  });

  it("links the deck from the lecture's own page", () => {
    for (const lecture of lectures) {
      const lecturePage = page(`/${lecture.id}/`);
      expect(
        lecturePage.html.includes(String(lecture.meta?.slides)),
        `${lecture.id} does not link its deck`,
      ).toBe(true);
    }
  });

  // A deck that is one slide is a link to a PDF with extra steps.
  it("builds decks with real content on them", () => {
    for (const lecture of lectures) {
      const deck = page(String(lecture.meta?.slides));
      const slides = (deck.html.match(/<section/g) ?? []).length;
      expect(slides, `${lecture.meta?.slides} has only ${slides} slides`).toBeGreaterThan(8);
      expect(text(deck.html).length, `${lecture.meta?.slides} is nearly empty`).toBeGreaterThan(
        1200,
      );
    }
  });
});

describe("navigation", () => {
  const home = () => page("/");

  it("reaches the weeks, the lectures, the assessment and the evidence from every page", () => {
    for (const sitePage of sitePages()) {
      for (const route of ["/sessions/", "/lectures/", "/assessments/", "/evidence/"]) {
        expect(sitePage.html.includes(route), `${sitePage.route} has no path to ${route}`).toBe(
          true,
        );
      }
    }
  });

  it("lists all twelve weeks on the weeks index", () => {
    const index = page("/sessions/");
    for (const session of sessions) {
      expect(index.html.includes(`/${session.id}/`), `weeks index omits ${session.id}`).toBe(true);
    }
  });

  it("names the course on the home page", () => {
    expect(text(home().html)).toContain(api.course.title);
    expect(text(home().html)).toContain(api.course.code);
  });
});
