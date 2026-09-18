#!/usr/bin/env node
// The site's artwork, drawn from the course's own machine code.
//
// The hero and the link-preview card are two columns of hexadecimal bytes: the
// left column is the clean build of `demo_substitution`, the right column is
// the same function after instruction substitution, and the highlighted row is
// the six-byte branch patch from week 8 — `0F 85 05 00 00 00` becoming
// `E9 06 00 00 00 90`. Every byte on screen was read out of a retained
// disassembly listing while this script ran.
//
// It is generated rather than drawn because the alternative was a stock image
// of a padlock. Run it with `pnpm artwork`; the outputs are committed.
import { readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";
import { pathToFileURL } from "node:url";
import sharp from "sharp";
import { HANDOFF_DIR } from "../src/lib/evidence-manifest.ts";

const root = process.cwd();
const INK = "#0c0d10";
const GOLD = "#c98f2a";
const GOLD_BRIGHT = "#e8b04a";
const PAPER = "#f4efe6";

/** The byte column out of an objdump-style listing, one row per instruction. */
function byteRows(id: string, limit: number): string[] {
  const text = readFileSync(resolve(root, HANDOFF_DIR, id), "utf8").replace(/\r\n/g, "\n");
  const rows: string[] = [];
  for (const line of text.split("\n")) {
    // `140001030: 48 83 ec 28   subq $0x28, %rsp` -> the middle field.
    const match = /^[0-9a-f]{6,16}:\s+((?:[0-9a-f]{2}\s)+)/i.exec(line.trim());
    if (!match) continue;
    rows.push(match[1]!.trim().toUpperCase());
    if (rows.length >= limit) break;
  }
  if (rows.length === 0) throw new Error(`no byte column found in ${id}`);
  return rows;
}

const escape = (text: string): string =>
  text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

interface ColumnOptions {
  x: number;
  y: number;
  rows: string[];
  step: number;
  size: number;
  opacity: number;
  label: string;
}

function column({ x, y, rows, step, size, opacity, label }: ColumnOptions): string {
  const head = `<text x="${x}" y="${y - step * 1.6}" fill="${PAPER}" fill-opacity="0.5" font-family="ui-monospace, 'DejaVu Sans Mono', monospace" font-size="${size * 0.78}" letter-spacing="${size * 0.12}">${escape(label)}</text>`;
  const rule = `<line x1="${x}" y1="${y - step * 1.1}" x2="${x + size * 16}" y2="${y - step * 1.1}" stroke="${PAPER}" stroke-opacity="0.16" stroke-width="1"/>`;
  const body = rows
    .map(
      (bytes, index) =>
        `<text x="${x}" y="${y + index * step}" fill="${GOLD}" fill-opacity="${opacity}" font-family="ui-monospace, 'DejaVu Sans Mono', monospace" font-size="${size}" xml:space="preserve">${escape(bytes)}</text>`,
    )
    .join("\n");
  return `${head}\n${rule}\n${body}`;
}

/** The week-8 patch, drawn as a highlighted before/after pair. */
function patch(x: number, y: number, size: number): string {
  const before = "0F 85 05 00 00 00";
  const after = "E9 06 00 00 00 90";
  const width = size * 11.2;
  const step = size * 1.85;
  return `
  <rect x="${x - size * 0.5}" y="${y - size * 1.35}" width="${width}" height="${step * 2 + size * 0.9}" fill="${GOLD_BRIGHT}" fill-opacity="0.09" stroke="${GOLD_BRIGHT}" stroke-opacity="0.5" stroke-width="1"/>
  <text x="${x}" y="${y}" fill="${GOLD_BRIGHT}" font-family="ui-monospace, 'DejaVu Sans Mono', monospace" font-size="${size}" xml:space="preserve">${before}</text>
  <text x="${x}" y="${y + step}" fill="${PAPER}" font-family="ui-monospace, 'DejaVu Sans Mono', monospace" font-size="${size}" xml:space="preserve">${after}</text>`;
}

const CLEAN = "assets/evidence/baselines/ollvm16/demo_substitution_disassembly.txt";
const SUB = "assets/evidence/s01_ollvm_sub/demo_substitution_disassembly.txt";

function hero(): string {
  const width = 2400;
  const height = 920;
  const clean = byteRows(CLEAN, 22);
  const sub = byteRows(SUB, 26);
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}" role="img">
  <rect width="${width}" height="${height}" fill="${INK}"/>
  <g>
${column({ x: 1180, y: 150, rows: clean, step: 34, size: 21, opacity: 0.68, label: "CLEAN  ·  demo_substitution  ·  O0" })}
${column({ x: 1740, y: 150, rows: sub, step: 30, size: 19, opacity: 0.44, label: "SUB  ·  same function  ·  O0" })}
${patch(1180, 812, 26)}
  </g>
  <line x1="1120" y1="0" x2="1120" y2="${height}" stroke="${GOLD}" stroke-opacity="0.28" stroke-width="2"/>
</svg>
`;
}

function card(): string {
  const width = 1200;
  const height = 630;
  const clean = byteRows(CLEAN, 13);
  const sub = byteRows(SUB, 15);
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}" role="img">
  <rect width="${width}" height="${height}" fill="${INK}"/>
${column({ x: 640, y: 128, rows: clean, step: 27, size: 16.5, opacity: 0.6, label: "CLEAN" })}
${column({ x: 924, y: 128, rows: sub, step: 24, size: 15, opacity: 0.38, label: "SUBSTITUTED" })}
${patch(640, 546, 20)}
  <line x1="600" y1="0" x2="600" y2="${height}" stroke="${GOLD}" stroke-opacity="0.3" stroke-width="2"/>
  <text x="64" y="120" fill="${GOLD}" font-family="ui-monospace, 'DejaVu Sans Mono', monospace" font-size="22" letter-spacing="3">SLOP8445</text>
  <text x="64" y="232" fill="${PAPER}" font-family="'DejaVu Sans', Helvetica, Arial, sans-serif" font-size="58" font-weight="700">Seeing Through</text>
  <text x="64" y="298" fill="${PAPER}" font-family="'DejaVu Sans', Helvetica, Arial, sans-serif" font-size="58" font-weight="700">Obfuscated Code</text>
  <rect x="64" y="336" width="86" height="5" fill="${GOLD}"/>
  <text x="64" y="396" fill="${PAPER}" fill-opacity="0.72" font-family="'DejaVu Sans', Helvetica, Arial, sans-serif" font-size="25">Obfuscation, assembly, and</text>
  <text x="64" y="430" fill="${PAPER}" fill-opacity="0.72" font-family="'DejaVu Sans', Helvetica, Arial, sans-serif" font-size="25">recovering program semantics</text>
  <text x="64" y="540" fill="${PAPER}" fill-opacity="0.5" font-family="'DejaVu Sans', Helvetica, Arial, sans-serif" font-size="21">Slop University · Semester 1, 2027</text>
</svg>
`;
}

async function main(): Promise<void> {
  const heroPath = resolve(root, "src/assets/images/hero-home.svg");
  writeFileSync(heroPath, hero());

  const cardSvg = card();
  writeFileSync(resolve(root, "src/assets/images/card.svg"), cardSvg);
  // libvips renders SVG at 96 dpi by default, so pin the output size: the
  // link-preview card has to be exactly 1200x630.
  await sharp(Buffer.from(cardSvg), { density: 96 })
    .resize(1200, 630, { fit: "fill" })
    .png({ compressionLevel: 9 })
    .toFile(resolve(root, "src/assets/images/card.png"));

  console.log("✓ artwork: hero-home.svg, card.svg, card.png — bytes read from the retained listings");
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  await main();
}
