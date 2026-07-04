---
name: product-review
description: >-
  Scans the Confluence Product folder for requirement documents, reads each one, and posts precise
  inline comments and questions to the human Product owner where anything is unclear, incomplete,
  ambiguous, untestable, or missing. Re-reviews after humans respond, until open questions are
  resolved. Trigger: "review requirements", "check the product docs", "review requirement <name>".
---

# product-review

The iterative requirement-review loop.

## Steps

1. Read `config/atlassian.json`. Guard: if unconfigured/`TBD`, stop and tell the human to run
   `project-init`.
2. List pages under the Product page (`getPagesInConfluenceSpace` / page descendants).
3. For each requirement doc **not** already "Signed Off":
   - Read the page and any existing comments (avoid duplicating open comments).
   - Evaluate against the review checklist below.
   - Post **inline comments** (`createConfluenceInlineComment`) anchored to the specific text,
     and a summary **footer comment** listing open questions. Be specific and constructive —
     propose concrete wording where possible.
   - If Status is "Draft", suggest moving it to "In Review".
4. Do **not** mark anything signed off — that is a human action.

## Review checklist

- Ambiguous / unmeasurable goals and acceptance criteria.
- Non-testable functional requirements; vague verbs ("support", "handle", "manage").
- Missing non-functional requirements: security/PII/GDPR, performance, availability, observability.
- Undefined users, data sources, integrations.
- Scope leakage between Goals ↔ Non-Goals ↔ Out of Scope.
- Unstated assumptions, dependencies, compliance/contractual constraints.
- Placeholder or missing metadata (feature slug, priority, target release, Jira epic).

## Iteration

Humans answer comments (Open Questions table / inline replies) and update the doc (themselves or,
on explicit request, via the Product role). Re-run this skill until no open questions remain, then
the human sets Status to "Signed Off" (handled by `product-signoff-to-md`).

## Guard & gate

Configuration guard as above. Track a review pass with `jira-gate` (Story/Task) if it changes
external state (posting comments counts).
