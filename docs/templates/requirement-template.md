<!--
  REQUIREMENT DOCUMENT TEMPLATE
  ----------------------------------------------------------------------------
  This document is a STORY told from the PRODUCT point of view: it explains what
  we want to achieve and why, clearly enough that anyone can read it top to bottom
  and understand the goal.

  IT IS THE AI's INPUT FOR THE NEXT STEPS. The Architect, Tech Lead and Developer
  roles (AI) consume this to design and build the feature. But you only need to
  provide what PRODUCT can provide: the intent, the outcomes, and pointers to any
  relevant material. You do NOT need to define APIs, schemas, contracts, data
  models or system designs — those are worked out in the ARCHITECTURE phase. If you
  know a relevant spec, system, prototype or doc, just link it under "Background &
  references" and the Architect will take it from there.

  HOW WE USE IT
  - Write it as prose, not a form. Fill each section; write "N/A" only if a section
    genuinely doesn't apply. Don't delete headings.
  - Discussion belongs in COMMENTS, not in the body. Ask questions, challenge and
    debate using Confluence inline/footer comments. When a comment is resolved, fold
    the change into the relevant section and resolve the comment. Do NOT keep a
    running "open questions" list — it makes the document variable and hard to read.
    The body should always be a clean, current statement of intent.
  - When it is agreed and all comments are resolved, set Status to "Signed Off".
    The Product role converts it into docs/features/<slug>/requirement.md.
  - Guidance in HTML comments (like this) is for authors and is stripped on conversion.
-->

# Requirement: <Feature / System Name>

## 1. At a glance

<!-- Keep this small — just the facts needed to find and place the work. -->

| Field | Value |
|---|---|
| Feature slug | `<kebab-case-slug>` <!-- becomes the docs/features/<slug>/ folder name --> |
| Product owner | <name> |
| Author(s) | <name(s)> |
| Status | `Draft` <!-- Draft → In Review → Signed Off --> |
| Priority | `<Must / Should / Could / Won't>` (MoSCoW) |
| Target release | <milestone / date, or "TBD"> |
| Links | <Jira epic, related docs, designs> |

## 2. The story — what we want to achieve, and why

<!--
  The heart of the document. In a few short paragraphs, tell the story:
  - Where are we today, and what's the problem or opportunity?
  - What do we want to be true instead?
  - Why does this matter now?
  Write it so a non-expert understands the goal. Prefer plain language over jargon.
-->

## 3. Who it's for

<!-- The people this serves and what they are trying to do. One line each is fine. -->

- As a <role>, I want <capability>, so that <benefit>.

## 4. What success looks like

<!-- The outcomes that define success. Make them observable/measurable where you can. -->

- 

## 5. What we're not doing

<!-- Explicitly out of scope, and non-goals. Prevents scope creep and sets expectations. -->

- 

## 6. What it needs to do

<!--
  The capabilities we need, in plain product language — what the user should be able
  to do, and why. One bullet per capability; tag priority inline: (Must)/(Should)/(Could).
  Describe the WHAT and WHY, not the technical HOW — the architecture phase handles HOW.
-->

- **<capability>** — <what the user can do and why> _(Must)_

## 7. Quality expectations

<!--
  The qualities that matter, described the way Product experiences them
  (e.g. "feels fast", "works in all our regions", "accessible", "handles our busy
  periods", "keeps personal data safe"). Fill only what applies; "N/A" the rest.
  Exact targets/SLAs can be firmed up with the Architect.
-->

| Aspect | What matters here |
|---|---|
| Speed / responsiveness |  |
| Reliability / availability |  |
| Scale (busy periods) |  |
| Privacy & security (personal data) |  |
| Accessibility |  |
| Languages / regions |  |

## 8. What it connects to

<!--
  In plain terms, the other products, systems or data this relies on or affects — as
  far as Product knows. You don't need technical detail or ownership; naming them and
  linking anything useful (in "Background & references") is enough for the Architect.
-->

- 

## 9. How we'll know it's done

<!-- Acceptance criteria — the checks that prove success, in user terms.
     Given/When/Then or a checklist. These become the QA/verification basis. -->

- [ ] 

## 10. Constraints & assumptions

<!-- Deadlines, budget, policy or business limits, and anything we're taking as true. -->

- **Constraint:** 
- **Assumption:** 

## 11. Risks

<!-- What could go wrong, and how likely/impactful. -->

- **Risk:** 

## 12. Background & references

<!--
  Anything that helps the reader (and the AI Architect) understand or build this:
  links to related docs, specs, prototypes, designs, tickets, or systems you know are
  relevant. You don't have to explain them technically — just link and say in one line
  what each is. This is how the requirement stays product-focused but still points the
  architecture phase at the right material.
-->

- <link> — <what it is / why it's relevant>

## 13. Sign-off

<!-- Set Status (section 1) to "Signed Off" only when this is complete and comments are resolved. -->

| Role | Name | Decision | Date |
|---|---|---|---|
| Product owner |  | ☐ Approved |  |
| Stakeholder(s) |  | ☐ Approved |  |
