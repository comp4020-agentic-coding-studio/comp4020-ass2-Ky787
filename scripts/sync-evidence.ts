#!/usr/bin/env node
// Publish the cited slice of the research package.
//
// Every artefact named in `src/lib/evidence-manifest.ts` is copied
// byte-for-byte from `claude_course_handoff_v1/` into `public/artefacts/`, so
// what a reader downloads from a week page is the file the experiment
// produced, not a retyped version of it. Screenshots additionally get a
// 1600px AVIF/JPEG derivative for inline display; the verbatim original stays
// behind the "full resolution" link.
//
// Re-runnable and idempotent. `spec/evidence-integrity.test.ts` re-checks the
// copies against the originals' hashes, and refuses orphans, so running this
// is not a matter of trust.
import { createHash } from "node:crypto";
import { copyFileSync, existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { pathToFileURL } from "node:url";
import sharp from "sharp";
import {
  HANDOFF_DIR,
  IMAGE_DERIVATIVE_WIDTH,
  PUBLIC_EVIDENCE_DIR,
  derivativePath,
  evidenceFiles,
  evidenceImages,
  evidencePath,
} from "../src/lib/evidence-manifest.ts";

const root = process.cwd();
const sha256 = (path: string): string =>
  createHash("sha256").update(readFileSync(path)).digest("hex");

/** Where a manifest entry lands on disk, given its public URL path. */
const target = (urlPath: string): string =>
  resolve(root, PUBLIC_EVIDENCE_DIR, urlPath.replace(/^\/artefacts\//, ""));

function copyVerbatim(id: string): { copied: boolean; bytes: number } {
  const from = resolve(root, HANDOFF_DIR, id);
  const to = target(evidencePath(id));
  mkdirSync(dirname(to), { recursive: true });
  if (existsSync(to) && sha256(to) === sha256(from)) {
    return { copied: false, bytes: statSync(to).size };
  }
  copyFileSync(from, to);
  return { copied: true, bytes: statSync(to).size };
}

async function makeDerivatives(id: string): Promise<number> {
  const from = resolve(root, HANDOFF_DIR, id);
  let made = 0;
  for (const ext of ["avif", "jpg"] as const) {
    const to = target(derivativePath(id, ext));
    if (existsSync(to)) continue;
    mkdirSync(dirname(to), { recursive: true });
    const pipeline = sharp(from).resize({
      width: IMAGE_DERIVATIVE_WIDTH,
      withoutEnlargement: true,
    });
    const buffer = await (ext === "avif"
      ? pipeline.avif({ quality: 62, effort: 5 })
      : pipeline.jpeg({ quality: 76, mozjpeg: true })
    ).toBuffer();
    writeFileSync(to, buffer);
    made += 1;
  }
  return made;
}

interface EntryMeta {
  sha256: string;
  bytes: number;
  lines?: number;
  width?: number;
  height?: number;
}

/** Facts pages quote beside a citation: size, line count, pixel dimensions. */
async function describe(id: string, isImage: boolean): Promise<EntryMeta> {
  const from = resolve(root, HANDOFF_DIR, id);
  const meta: EntryMeta = {
    sha256: sha256(from).toUpperCase(),
    bytes: statSync(from).size,
  };
  if (isImage) {
    const { width, height } = await sharp(from).metadata();
    meta.width = width;
    meta.height = height;
  } else if (/\.(c|ll|txt|smt2|json|md)$/.test(id)) {
    meta.lines = readFileSync(from, "utf8").split("\n").length;
  }
  return meta;
}

async function main(): Promise<void> {
  if (!existsSync(resolve(root, HANDOFF_DIR))) {
    console.error(`✗ ${HANDOFF_DIR}/ is missing — the site cites it for every claim`);
    process.exit(1);
  }

  let copied = 0;
  let bytes = 0;
  for (const id of [...evidenceFiles, ...evidenceImages]) {
    const result = copyVerbatim(id);
    if (result.copied) copied += 1;
    bytes += result.bytes;
  }

  let derived = 0;
  for (const id of evidenceImages) derived += await makeDerivatives(id);

  // Two records of what the site publishes: one served beside the files for
  // anyone auditing the citations, one imported by the site so a page can
  // quote a file's size, line count or pixel dimensions without re-reading it.
  const meta: Record<string, EntryMeta> = {};
  for (const id of evidenceFiles) meta[id] = await describe(id, false);
  for (const id of evidenceImages) meta[id] = await describe(id, true);

  const index = [...evidenceFiles, ...evidenceImages].map((id) => ({
    id,
    url: evidencePath(id),
    sha256: meta[id]!.sha256,
    bytes: meta[id]!.bytes,
  }));
  writeFileSync(
    join(root, PUBLIC_EVIDENCE_DIR, "published-evidence.json"),
    `${JSON.stringify(
      {
        source: HANDOFF_DIR,
        note:
          "Byte-identical copies of the cited research artefacts. Hashes are of the " +
          "originals in the handoff package. No Windows executables are published here.",
        count: index.length,
        files: index,
      },
      null,
      2,
    )}\n`,
  );
  writeFileSync(
    join(root, "src/lib/evidence-meta.json"),
    `${JSON.stringify(meta, null, 2)}\n`,
  );

  console.log(
    `✓ evidence: ${index.length} artefacts published (${copied} copied, ${derived} derivatives, ` +
      `${(bytes / 1024 / 1024).toFixed(1)} MB verbatim)`,
  );
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  await main();
}
