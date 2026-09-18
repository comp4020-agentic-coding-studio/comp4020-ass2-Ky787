import type { CourseMetaInput } from "astro-course-university";
import { z } from "astro/zod";

// The level digits ANU uses: 1000--4000 undergraduate, 6000 and 8000
// postgraduate. Both the code pattern and the level field derive from this.
const LEVELS = [1, 2, 3, 4, 6, 8] as const;
const allowedCode = new RegExp(`^SLOP[${LEVELS.join("")}]\\d{3}$`);

export const slopCourseMetaSchema = z
  .strictObject({
    code: z.string().regex(allowedCode, {
      message: "use SLOP plus a 1000–4000, 6000 or 8000 level code",
    }),
    title: z.string().trim().min(1).max(100),
    session: z.string().trim().min(1).max(40),
    year: z.number().int().min(2026).max(2200),
    level: z.literal(LEVELS),
    startDate: z.iso.date(),
    endDate: z.iso.date(),
    description: z.string().trim().min(80).max(300),
    tags: z.array(z.string().trim().min(2).max(24)).min(1).max(3),
  })
  .superRefine((course, ctx) => {
    const codeLevel = Number(course.code.at(4));
    if (course.level !== codeLevel) {
      ctx.addIssue({
        code: "custom",
        path: ["level"],
        message: `must match ${course.code}'s first digit (${codeLevel})`,
      });
    }
    if (course.startDate > course.endDate) {
      ctx.addIssue({
        code: "custom",
        path: ["startDate"],
        message: "must not be after endDate",
      });
    }
  })
  // The teaching programme is twelve weekly studios plus four spine lectures,
  // and both are dated content. Assert the window can actually hold them, so a
  // change to the record fails here rather than in `spec/`.
  .superRefine((course, ctx) => {
    const weeks = (Date.parse(course.endDate) - Date.parse(course.startDate)) / 604_800_000;
    if (weeks < 12) {
      ctx.addIssue({
        code: "custom",
        path: ["endDate"],
        message: `teaching period is ${weeks.toFixed(1)} weeks; twelve dated weeks will not fit`,
      });
    }
  });

// The single source of truth for the course record. The generated homepage,
// navigation label and /api/index.json all read this object.
//
// The code's last three digits (445) were assigned to this repo when it was
// provisioned. The leading 8 is the level: the prerequisites below assume C,
// unsigned arithmetic and introductory architecture, which puts this at
// introductory postgraduate rather than first-year.
export const courseMeta = slopCourseMetaSchema.parse({
  code: "SLOP8445",
  title: "Seeing Through Obfuscated Code",
  session: "Semester 1",
  year: 2027,
  level: 8,
  startDate: "2027-02-22",
  endDate: "2027-05-28",
  description:
    "Obfuscation, assembly, and recovering program semantics. Twelve weeks on how much of a " +
    "program's meaning survives a change of representation — and on why a deobfuscated result " +
    "that looks cleaner is not yet a result that is correct.",
  tags: ["reverse engineering", "program semantics", "compilers"],
}) satisfies CourseMetaInput;

/** The subtitle, carried separately so the 300-character record stays prose. */
export const courseSubtitle = "Obfuscation, assembly, and recovering program semantics";

/** The question the twelve weeks answer together. */
export const courseQuestion =
  "How much program meaning survives a change of representation, and which deobfuscation " +
  "methods generalise beyond one implementation?";
