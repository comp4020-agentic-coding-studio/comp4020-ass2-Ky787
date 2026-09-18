import { defineCollection, reference } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";
import { courseNodeSchema } from "astro-course-university/schemas";

const weekSchema = z.coerce.number().int().min(1).max(12);
const courseNodeLoader = (dir: string) =>
  glob({ pattern: ["**/*.{md,mdx}", "!**/CLAUDE.md"], base: `src/content/${dir}` });
const teacherRefs = z.array(reference("people")).min(1);

const weightedMarking = z
  .object({
    mode: z.literal("weighted"),
    criteria: z
      .array(z.object({ name: z.string().trim().min(1), weight: z.number().positive() }))
      .min(1),
  })
  .superRefine((marking, ctx) => {
    const total = marking.criteria.reduce((sum, criterion) => sum + criterion.weight, 0);
    if (total !== 100) {
      ctx.addIssue({
        code: "custom",
        path: ["criteria"],
        message: `criterion weights sum to ${total}, not 100`,
      });
    }
  });

const holisticMarking = z.object({
  mode: z.literal("holistic"),
  description: z.string().trim().min(40),
});

export const collections = {
  // One entry per teaching week. Two fields are required here that the starter
  // schema did not have, and both exist to stop this course turning into
  // twelve interchangeable pages:
  //
  //   `question` — the single thing the week answers. Writing one forces the
  //   week to have a point, and the point is what the week page leads with.
  //   `mode` — the teaching shape (a side-by-side diff, a solver walkthrough,
  //   a failure audit). Naming it makes a repeated shape visible to the
  //   author, and `spec/curriculum.test.ts` refuses a shape used too often.
  sessions: defineCollection({
    loader: courseNodeLoader("sessions"),
    schema: courseNodeSchema
      .extend({
        week: weekSchema,
        date: z.coerce.date(),
        teachers: teacherRefs.optional(),
        question: z.string().trim().min(20).max(220),
        mode: z.string().trim().min(3).max(44),
      })
      .loose(),
  }),

  assessments: defineCollection({
    loader: courseNodeLoader("assessments"),
    schema: courseNodeSchema
      .extend({
        week: weekSchema,
        due: z.coerce.date(),
        weight: z.coerce.number().positive().max(100),
        /** Short label used in navigation and cross-references: A1, A2, Capstone. */
        label: z.string().trim().min(2).max(12),
        // Not optional here. A brief that does not say how it is judged is
        // half a brief, and this course marks reasoning rather than output,
        // which is exactly the case where students need it written down.
        marking: z.discriminatedUnion("mode", [weightedMarking, holisticMarking]),
      })
      .loose(),
  }),

  // Four spine lectures, one per block, each opening the argument its three
  // weeks carry. `slides` is required: a lecture on this site exists as a
  // page *and* as the deck that was delivered from it.
  lectures: defineCollection({
    loader: courseNodeLoader("lectures"),
    schema: courseNodeSchema
      .extend({
        week: weekSchema,
        date: z.coerce.date(),
        teachers: teacherRefs.optional(),
        block: z.coerce.number().int().min(1).max(4),
        covers: z.array(weekSchema).min(1),
        slides: z
          .string()
          .regex(/^\/decks\/[a-z0-9-]+\/$/),
      })
      .loose(),
  }),

  people: defineCollection({
    loader: courseNodeLoader("people"),
    schema: ({ image }) =>
      z
        .object({
          title: z.string().trim().min(1),
          description: z.string().trim().min(40),
          role: z.string().trim().min(1),
          contact: z.string().trim().min(1).optional(),
          affiliation: z.string().trim().min(1).optional(),
          email: z.email().optional(),
          url: z.url().optional(),
          photo: image().optional(),
          photoAlt: z.string().trim().optional(),
          published: z.coerce.boolean().default(true),
        })
        .superRefine((person, ctx) => {
          if (person.photo && !person.photoAlt) {
            ctx.addIssue({
              code: "custom",
              path: ["photoAlt"],
              message: "describe the photo when one is supplied",
            });
          }
        }),
  }),
};
