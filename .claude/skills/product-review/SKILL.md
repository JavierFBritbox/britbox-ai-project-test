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

## Known limitation — comments cannot be cleared by the AI

The Atlassian Rovo MCP exposes only comment **create** operations (`createConfluenceInlineComment`,
`createConfluenceFooterComment`, and replies). There is **no tool to resolve or delete a Confluence
comment**. Consequences the loop must account for:

- **Comments are write-once and accumulate.** Inline comments do **not** auto-resolve. If a later
  revision removes or rewrites the anchored text, the comment stays listed as **open** (not even
  auto-marked `dangling`), so every review round leaves residue that only a human can clear in the
  Confluence UI (open comment → Resolve, or ⋯ → Delete).
- **Prefer fewer, higher-value inline comments + one footer summary.** Since they can't be tidied,
  don't over-anchor. Anchor only to text likely to survive edits; put broad/structural feedback in
  the footer summary rather than many inline notes.
- **Before a re-review, don't re-post superseded points.** Read existing open comments first
  (already required in Steps) and skip anything the new revision has addressed — you cannot retract
  a now-stale comment, so avoid creating it again.
- **On a major reframe/rewrite, warn the human.** Rewriting a page orphans its inline comments
  (their anchor text is gone) but leaves them listed as open. Flag which comment IDs are now stale
  and tell the human they must be resolved/deleted in the Confluence UI — the AI cannot do it.
- **Do not "tidy" by replying.** Adding "superseded" replies increases clutter instead of removing
  it; it is not a substitute for UI resolution.

## Guard & gate

Configuration guard as above. Track a review pass with `jira-gate` (Story/Task) if it changes
external state (posting comments counts).
