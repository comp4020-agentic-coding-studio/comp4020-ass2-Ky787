// Render the handoff's own reference tables, rather than retyping them.
//
// Three pages on this site — the claim boundaries, the glossary and the tool
// catalogue — are the research package's tables, parsed out of the authoritative
// markdown at build time. That is deliberate. Those three documents are the
// ones a mistake would do the most damage in, and a transcription is a copy
// that can drift. This way the page cannot disagree with the source, and
// `spec/reference-pages.test.ts` asserts the row counts so a silently emptied
// table fails the build rather than shipping.
//
// Inline markdown in the cells is converted narrowly: code spans, bold, and
// links whose target is a published artefact. A link to something the site does
// not publish keeps its text and loses its href, because a dead link in a
// claim boundary is worse than plain prose.
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { HANDOFF_DIR, allEvidence } from "./evidence-manifest";
import { evidenceUrl } from "./evidence";

export interface MarkdownTable {
  /** The nearest preceding markdown heading, without its hashes. */
  heading: string;
  /** Prose between that heading and the table. */
  intro: string[];
  columns: string[];
  /** Cells, as rendered HTML. */
  rows: string[][];
}

const published = new Set(allEvidence);

function escapeHtml(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

/** Resolve a handoff-relative markdown link target to a site URL, if published. */
function resolveTarget(target: string, fromDir: string): string | undefined {
  if (/^https?:\/\//.test(target)) return target;
  // Targets inside the handoff are written relative to the file they appear in.
  const normalised = fromDir === "" ? target : `${fromDir}/${target}`;
  const candidate = normalised.replace(/^\.\//, "");
  if (published.has(candidate)) return evidenceUrl(candidate);
  if (published.has(target)) return evidenceUrl(target);
  return undefined;
}

/** A narrow inline-markdown renderer for table cells. */
export function renderCell(raw: string, fromDir: string): string {
  let html = escapeHtml(raw.trim());
  html = html.replace(/`([^`]+)`/g, (_, code: string) => `<code>${code}</code>`);
  html = html.replace(/\*\*([^*]+)\*\*/g, (_, bold: string) => `<strong>${bold}</strong>`);
  html = html.replace(
    /\[([^\]]+)\]\(([^)\s]+)\)/g,
    (_, text: string, target: string) => {
      const href = resolveTarget(target, fromDir);
      return href ? `<a href="${href}">${text}</a>` : text;
    },
  );
  html = html.replace(/<br>|<br \/>/g, " ");
  return html;
}

const splitRow = (line: string): string[] =>
  line
    .replace(/^\|/, "")
    .replace(/\|$/, "")
    .split("|");

const isSeparator = (line: string): boolean => /^\|[\s:|-]+\|$/.test(line.trim());

/**
 * Every pipe table in a published markdown artefact, in document order.
 *
 * @param id manifest id of the markdown file
 */
export function markdownTables(id: string): MarkdownTable[] {
  const fromDir = id.includes("/") ? id.slice(0, id.lastIndexOf("/")) : "";
  const source = readFileSync(resolve(process.cwd(), HANDOFF_DIR, id), "utf8").replace(
    /\r\n/g,
    "\n",
  );
  const lines = source.split("\n");

  const tables: MarkdownTable[] = [];
  let heading = "";
  let prose: string[] = [];

  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index] ?? "";
    const headingMatch = /^#{1,6}\s+(.*)$/.exec(line);
    if (headingMatch) {
      heading = headingMatch[1]!.trim();
      prose = [];
      continue;
    }

    const next = lines[index + 1] ?? "";
    if (line.trim().startsWith("|") && isSeparator(next)) {
      const columns = splitRow(line).map((cell) => renderCell(cell, fromDir));
      const rows: string[][] = [];
      let cursor = index + 2;
      while (cursor < lines.length && (lines[cursor] ?? "").trim().startsWith("|")) {
        rows.push(splitRow(lines[cursor]!).map((cell) => renderCell(cell, fromDir)));
        cursor += 1;
      }
      tables.push({ heading, intro: prose, columns, rows });
      prose = [];
      index = cursor - 1;
      continue;
    }

    if (line.trim() !== "") prose.push(line.trim());
  }

  return tables;
}

/** The one table in a document that has this many columns, or the nth of them. */
export function markdownTable(id: string, index = 0): MarkdownTable {
  const table = markdownTables(id)[index];
  if (!table) throw new Error(`${id} has no markdown table at index ${index}`);
  return table;
}
