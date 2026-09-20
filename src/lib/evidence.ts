// Build-time access to the published research artefacts.
//
// The point of routing every citation through here is that a snippet on a week
// page is *sliced out of the real file while the site builds*. There is no
// second copy of the assembly to drift from the first, and no way to paste in
// a plausible-looking instruction that no experiment produced: an unknown id
// fails the build, and a line range past the end of the file fails with it.
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { withBase } from "astro-theme-university/url";
import {
  HANDOFF_DIR,
  allEvidence,
  derivativePath,
  evidenceImages,
  evidencePath,
} from "./evidence-manifest";
import meta from "./evidence-meta.json";

export interface EvidenceMeta {
  sha256: string;
  bytes: number;
  lines?: number;
  width?: number;
  height?: number;
}

const known = new Set(allEvidence);
const images = new Set(evidenceImages);
const metaById = meta as Record<string, EvidenceMeta>;

function assertKnown(id: string): void {
  if (!known.has(id)) {
    throw new Error(
      `evidence "${id}" is not in src/lib/evidence-manifest.ts — ` +
        `add it there (and re-run \`pnpm artefacts\`) rather than citing an unpublished file`,
    );
  }
}

/** The artefact's URL on this site, base path included. */
export function evidenceUrl(id: string): string {
  assertKnown(id);
  return withBase(evidencePath(id));
}

/** Size, line count and pixel dimensions, recorded when the file was published. */
export function evidenceInfo(id: string): EvidenceMeta {
  assertKnown(id);
  const info = metaById[id];
  if (!info) throw new Error(`evidence "${id}" has no recorded metadata — re-run \`pnpm artefacts\``);
  return info;
}

/** The artefact's filename, for captions and download links. */
export function evidenceName(id: string): string {
  assertKnown(id);
  return id.split("/").pop() ?? id;
}

/** The path a reader can check inside the research package. */
export function evidenceSource(id: string): string {
  assertKnown(id);
  return `${HANDOFF_DIR}/${id}`;
}

export interface Excerpt {
  /** The excerpt text, with trailing blank lines trimmed. */
  text: string;
  /** 1-based line number of the excerpt's first line in the source file. */
  firstLine: number;
  /** Total lines in the source file. */
  totalLines: number;
  /** True when the excerpt is only part of the file. */
  partial: boolean;
}

export interface ExcerptOptions {
  /** 1-based first line to include. */
  from?: number;
  /** 1-based last line to include (inclusive). */
  to?: number;
  /** Include lines from the first match of this pattern. */
  fromMatch?: RegExp;
  /** Take this many lines once `fromMatch` has hit. */
  take?: number;
  /** Strip this many leading spaces from every line. */
  dedent?: number;
}

/**
 * Slice an excerpt out of a published artefact, at build time.
 *
 * `fromMatch` anchors on content rather than a line number, so an excerpt
 * keeps pointing at the same instruction even if the file above it changes —
 * and fails loudly if that content is gone.
 */
export function excerpt(id: string, options: ExcerptOptions = {}): Excerpt {
  assertKnown(id);
  // The published copy stays byte-identical, CRLF and all — that is what the
  // integrity test hashes. An excerpt is normalised to LF so anchors match and
  // no stray carriage return lands in a code block.
  const raw = readFileSync(resolve(process.cwd(), HANDOFF_DIR, id), "utf8").replace(/\r\n/g, "\n");
  const lines = raw.replace(/\n$/, "").split("\n");
  const totalLines = lines.length;

  let from = options.from ?? 1;
  if (options.fromMatch) {
    const hit = lines.findIndex((line) => options.fromMatch!.test(line));
    if (hit === -1) {
      throw new Error(`evidence "${id}" has no line matching ${options.fromMatch} any more`);
    }
    from = hit + 1;
  }
  const to = options.to ?? (options.take ? from + options.take - 1 : totalLines);
  if (from < 1 || from > totalLines) {
    throw new Error(`evidence "${id}" has ${totalLines} lines; asked for line ${from}`);
  }

  let slice = lines.slice(from - 1, Math.min(to, totalLines));
  while (slice.length > 0 && slice.at(-1)!.trim() === "") slice = slice.slice(0, -1);
  if (options.dedent) {
    const cut = options.dedent;
    slice = slice.map((line) => (line.startsWith(" ".repeat(cut)) ? line.slice(cut) : line));
  }

  return {
    text: slice.join("\n"),
    firstLine: from,
    totalLines,
    partial: from > 1 || Math.min(to, totalLines) < totalLines,
  };
}

/** Read a published JSON artefact as data. */
export function evidenceJson<T = unknown>(id: string): T {
  assertKnown(id);
  return JSON.parse(readFileSync(resolve(process.cwd(), HANDOFF_DIR, id), "utf8")) as T;
}

export interface ScreenshotSources {
  avif: string;
  jpg: string;
  full: string;
  width: number;
  height: number;
  fullWidth: number;
  fullHeight: number;
}

/** Inline derivatives plus the verbatim original, for a screenshot. */
export function screenshot(id: string): ScreenshotSources {
  assertKnown(id);
  if (!images.has(id)) throw new Error(`evidence "${id}" is not a screenshot`);
  const info = evidenceInfo(id);
  const fullWidth = info.width ?? 1600;
  const fullHeight = info.height ?? 1000;
  const width = Math.min(1600, fullWidth);
  return {
    avif: withBase(derivativePath(id, "avif")),
    jpg: withBase(derivativePath(id, "jpg")),
    full: withBase(evidencePath(id)),
    width,
    height: Math.round((fullHeight / fullWidth) * width),
    fullWidth,
    fullHeight,
  };
}

/** Human-readable byte size. */
export function formatBytes(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${Math.round(bytes / 1024)} kB`;
  return `${(bytes / 1024 / 1024).toFixed(1)} MB`;
}
