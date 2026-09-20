import { defineSiteConfig } from "astro-theme-university/types";
import { slopBranding } from "astro-theme-slop";
import { courseMeta } from "./course-config";

// The collection and URL stay `sessions`; these are the words students see.
// Each entry is one of the twelve teaching weeks, so that is what it is called.
export const sessionLabels = {
  singular: "Week",
  plural: "Weeks",
} as const;

export const graphCollections = ["sessions", "assessments", "lectures", "people"];

// The subset that actually has entries. `people` stays in the graph and in the
// API because the starter fixes those four, but this course populates no cast
// list, and asking Astro for an empty collection warns once per rendered page.
export const relatedCollections = ["sessions", "assessments", "lectures"];

export const courseApiCollections = [
  ...graphCollections.map((key) => ({ key })),
  { key: "policies", dir: "pages/policies" },
];

export const siteConfig = defineSiteConfig({
  ...slopBranding,
  name: "Slop University",

  links: [
    { text: sessionLabels.plural, href: "/sessions/" },
    { text: "Lectures", href: "/lectures/" },
    { text: "Assessment", href: "/assessments/" },
    { text: "Evidence", href: "/evidence/" },
    { text: "Tools", href: "/tools/" },
    { text: "Glossary", href: "/glossary/" },
    { text: "Course information", href: "/policies/" },
  ],

  contact: {
    description: `${courseMeta.code} · course enquiries`,
    email: "seeing-through@slop.university",
  },

  licence: "CC-BY-NC-SA-4.0",
  socialImage: "/src/assets/images/card.png",
  socialImageAlt:
    "A two-panel card: a short clean instruction sequence beside the same computation " +
    "expanded into dense obfuscated arithmetic, under the course title.",
});

// The theme renders `legalLinks` hrefs verbatim, since it expects external
// legal URLs there. These are internal pages, so the layout applies the base
// path to them rather than shipping links that work only on localhost.
export const footerLinks = [
  { text: "Course information and policies", href: "/policies/" },
  { text: "Evidence and provenance", href: "/evidence/" },
  { text: "What we do and do not claim", href: "/claims/" },
  { text: "Glossary", href: "/glossary/" },
] as const;
