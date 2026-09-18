// The twelve lecture comparison tables, read from the research package's own
// structured rows (`tables.json`) rather than reproduced by hand.
//
// The package also ships each table as an SVG and a PNG. Those are reference
// artefacts with their own typography and a hardcoded white background, so the
// site renders the rows as a real HTML table — selectable, searchable, legible
// at 390px, and correct in dark mode — and links the original figure beside it.
import { evidenceJson, evidenceUrl } from "./evidence";

const TABLES_ID = "assets/tables/lecture/tables.json";

export type Tone = "pass" | "fail" | "partial" | "info" | "neutral";

export interface TableCell {
  text: string;
  tone?: Tone;
}

export interface LectureTable {
  id: string;
  title: string;
  subtitle?: string;
  columns: string[];
  rows: (string | TableCell)[][];
  takeaway?: string;
  note?: string;
  /** URL of the original SVG figure from the research package. */
  figure: string;
  /** Table number, 1--12. */
  number: number;
}

interface RawTables {
  tables: Omit<LectureTable, "figure" | "number">[];
}

const raw = evidenceJson<RawTables>(TABLES_ID);

const bySlug = new Map<string, LectureTable>(
  raw.tables.map((table) => {
    const number = Number.parseInt(table.id.slice(0, 2), 10);
    return [
      table.id,
      {
        ...table,
        number,
        figure: evidenceUrl(`assets/tables/lecture/svg/${table.id}.svg`),
      },
    ];
  }),
);

export function lectureTable(id: string): LectureTable {
  const table = bySlug.get(id);
  if (!table) {
    throw new Error(
      `no lecture table "${id}" in ${TABLES_ID} — available: ${[...bySlug.keys()].join(", ")}`,
    );
  }
  return table;
}

export function allLectureTables(): LectureTable[] {
  return [...bySlug.values()].sort((a, b) => a.number - b.number);
}

export function cellText(cell: string | TableCell): string {
  return typeof cell === "string" ? cell : cell.text;
}

export function cellTone(cell: string | TableCell): Tone | undefined {
  return typeof cell === "string" ? undefined : cell.tone;
}
