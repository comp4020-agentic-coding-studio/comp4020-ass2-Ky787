// Shared readers for the spec suite.
//
// The tests assert what the site *built*, not how it was written, so they
// survive a change of components or of stack. Everything here reads `dist/`
// or the generated course API, and nothing imports site source.
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative, resolve } from "node:path";

export const DIST = resolve("dist");

export interface ApiNode {
  id: string;
  type: string;
  title: string;
  description?: string | null;
  spec?: string[];
  related?: string[];
  meta?: Record<string, unknown>;
  body?: string;
}

export interface CourseApi {
  course: { code: string; startDate: string; endDate: string; title: string };
  nodes: ApiNode[];
  edges: unknown[];
}

export const api = JSON.parse(readFileSync(join(DIST, "api/index.json"), "utf8")) as CourseApi;

export const nodesOfType = (type: string): ApiNode[] =>
  api.nodes.filter((node) => node.type === type);

/** Every file under a directory, as paths relative to it. */
export function walk(dir: string, base = dir): string[] {
  const out: string[] = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) out.push(...walk(full, base));
    else out.push(relative(base, full));
  }
  return out;
}

export interface Page {
  /** Route, e.g. `/sessions/week-01/`. */
  route: string;
  /** Path of the built file relative to dist. */
  file: string;
  html: string;
}

let cache: Page[] | undefined;

/** Every built HTML page, excluding the slide decks. */
export function pages(): Page[] {
  if (cache) return cache;
  cache = walk(DIST)
    .filter((file) => file.endsWith(".html"))
    .map((file) => ({
      file,
      route: `/${file.replace(/index\.html$/, "").replace(/\\/g, "/")}`,
      html: readFileSync(join(DIST, file), "utf8"),
    }))
    .sort((a, b) => a.route.localeCompare(b.route));
  return cache;
}

export const decks = (): Page[] => pages().filter((page) => page.route.startsWith("/decks/"));
export const sitePages = (): Page[] => pages().filter((page) => !page.route.startsWith("/decks/"));
export const weekPages = (): Page[] =>
  pages().filter((page) => /^\/sessions\/week-\d\d\/$/.test(page.route));

export const page = (route: string): Page => {
  const found = pages().find((candidate) => candidate.route === route);
  if (!found) {
    throw new Error(`no built page at ${route} — built routes: ${pages().map((p) => p.route).join(", ")}`);
  }
  return found;
};

/** Visible text, with tags and entities flattened enough for phrase matching. */
export function text(html: string): string {
  return html
    .replace(/<script[\s\S]*?<\/script>/g, " ")
    .replace(/<style[\s\S]*?<\/style>/g, " ")
    .replace(/<[^>]+>/g, " ")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#39;|&apos;/g, "'")
    .replace(/&mdash;/g, "—")
    .replace(/\s+/g, " ")
    .trim();
}

/** Every href and src on a page, verbatim. */
export function links(html: string): string[] {
  return [...html.matchAll(/(?:href|src|srcset)="([^"]+)"/g)].flatMap((match) =>
    match[1]!.split(",").map((candidate) => candidate.trim().split(/\s+/)[0]!),
  );
}

export const exists = (distRelative: string): boolean => {
  try {
    statSync(join(DIST, distRelative));
    return true;
  } catch {
    return false;
  }
};

/** The deployment base path this build used, e.g. `/comp4020-ass2-Ky787`. */
export const BASE = (() => {
  const home = readFileSync(join(DIST, "index.html"), "utf8");
  const match = /href="((?:\/[^"/]+)?)\/sessions\/"/.exec(home);
  return match?.[1] ?? "";
})();

/** Strip the base path off an internal URL, giving a dist-relative path. */
export const unbase = (href: string): string =>
  href.replace(/^https?:\/\/[^/]+/, "").replace(new RegExp(`^${BASE}/`), "");

/** Rows of the first pipe table in a markdown file, as cell arrays. */
export function markdownTableRows(path: string): string[][] {
  const lines = readFileSync(resolve(path), "utf8").replace(/\r\n/g, "\n").split("\n");
  const rows: string[][] = [];
  let inTable = false;
  for (let index = 0; index < lines.length; index += 1) {
    const line = (lines[index] ?? "").trim();
    if (!inTable) {
      const next = (lines[index + 1] ?? "").trim();
      if (line.startsWith("|") && /^\|[\s:|-]+\|$/.test(next)) {
        inTable = true;
        index += 1;
      }
      continue;
    }
    if (!line.startsWith("|")) break;
    rows.push(
      line
        .replace(/^\|/, "")
        .replace(/\|$/, "")
        .split("|")
        .map((cell) => cell.trim()),
    );
  }
  return rows;
}
