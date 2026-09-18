// The shape of the semester: four blocks of three weeks, each opened by one
// spine lecture. The blocks are not decoration — they are where the argument
// turns, and every week page says which turn it belongs to.
export interface Block {
  /** 1--4. */
  id: number;
  /** Roman numeral, used in the week rail and on the weeks index. */
  numeral: string;
  title: string;
  /** What the block establishes, in one sentence. */
  claim: string;
  weeks: number[];
  /** The spine lecture that opens it. */
  lecture: string;
}

export const BLOCKS: Block[] = [
  {
    id: 1,
    numeral: "I",
    title: "Representation",
    claim:
      "One computation has several truthful descriptions, and obfuscation is a change of " +
      "description before it is anything else.",
    weeks: [1, 2, 3],
    lecture: "spine-01",
  },
  {
    id: 2,
    numeral: "II",
    title: "Simplification",
    claim:
      "Something usually simplifies the obfuscation for you — the algebra, the compiler " +
      "backend, or your own reading — and each of the three proves a different thing.",
    weeks: [4, 5, 6],
    lecture: "spine-02",
  },
  {
    id: 3,
    numeral: "III",
    title: "Proof",
    claim:
      "A solver can prove a branch impossible and that proof can be turned into changed " +
      "bytes; neither step covers what flattening hides.",
    weeks: [7, 8, 9],
    lecture: "spine-03",
  },
  {
    id: 4,
    numeral: "IV",
    title: "Limits",
    claim:
      "The methods that generalise are the ones that carry their assumptions with them, and " +
      "every output still needs validating at the level of its claim.",
    weeks: [10, 11, 12],
    lecture: "spine-04",
  },
];

export function blockForWeek(week: number): Block {
  const block = BLOCKS.find((candidate) => candidate.weeks.includes(week));
  if (!block) throw new Error(`week ${week} is not in any block`);
  return block;
}

/** The four outcomes the course refuses to let collapse into one another. */
export const OUTCOMES = [
  {
    name: "Analysis success",
    gloss: "A tool ran, produced output, and did not error.",
  },
  {
    name: "Semantic proof",
    gloss: "A property holds — under a stated model, state and path prefix.",
  },
  {
    name: "Binary rewriting",
    gloss: "Bytes changed and a file still loads.",
  },
  {
    name: "Runtime correctness",
    gloss: "The program answered correctly, on the inputs that were actually run.",
  },
] as const;
