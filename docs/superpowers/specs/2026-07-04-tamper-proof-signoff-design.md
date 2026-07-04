# Design: Tamper-Proof Requirement Sign-Off Check

**Date:** 2026-07-04
**Author:** Javier Fernandez (with Claude Code)
**Status:** Draft — pending review
**Affects:** `docs/templates/requirement-template.md`, `.claude/skills/product-signoff-to-md/SKILL.md`, `.claude/skills/product-review/SKILL.md`

## Problem

A requirement is considered "signed off" when a human sets the **Status** field to
`Signed Off` in the requirement's Confluence page. That status is free-text inside the
page body (a Metadata table row), and `product-signoff-to-md` currently trusts it after a
single equality check. This lets a requirement be converted into the repo — and the whole
downstream pipeline started — while it is in fact **incomplete**: Open Questions still
unresolved, the approvals table empty, review comments unaddressed, or metadata still full
of template placeholders.

## Goal

Make the sign-off check reject a page that *says* `Signed Off` but is not genuinely
complete. The threat being closed is **premature / incomplete sign-off**, not identity
forgery — so no new Jira gate, approver allowlist, or Atlassian admin config is required.
All checks read from the live Confluence page using scopes the roles already have.

## Non-Goals

- Verifying **who** set the status (identity / approver allowlist) — explicitly out of scope.
- Moving the authoritative gate to a Jira transition — out of scope.
- Any change to Confluence space/project setup or `config/atlassian.json`.
- Blocking on unrelated content quality (that is the `product-review` loop's job).

## Design

Two parts: make the sign-off **machine-checkable** in the template, then **enforce** it in
the skill before any conversion happens.

### Part A — Template (`docs/templates/requirement-template.md`)

The current template uses signals that are hard to parse deterministically in Confluence
storage format (checkbox glyphs). Replace them with explicit, checkable values.

1. **Sign-Off table (§16).** Replace the `☐ Approved` checkbox column with an explicit
   **Decision** column, allowed values `Approved` / `Rejected` / `Pending`, alongside
   **Name** and **Date** columns:

   | Role | Name | Decision | Date |
   |---|---|---|---|
   | Product owner |  | Pending |  |
   | Stakeholder(s) |  | Pending |  |

   Author guidance: set **Status = `Signed Off` only when every row is `Approved` with a
   Name and a Date.**

2. **Open Questions (§14).** Keep the **Status** column, allowed values `Open` / `Resolved`.
   Guidance: every question must be `Resolved` with a non-empty **Answer** before sign-off.

3. **Metadata (§1).** Add a note that no angle-bracket placeholders (`<...>`) or `TBD` may
   remain in **Feature slug**, **Priority**, or **Target release** at sign-off.

The `Status` field enumeration stays `Draft → In Review → Changes Requested → Signed Off`.

### Part B — Enforcement (`product-signoff-to-md`)

Insert a **Sign-Off Gate** step that runs *after* reading the page and *before* any
storage→markdown conversion or file write. It reads the live page (never trusts the trigger
text), evaluates all gates, and **hard-stops on the first failure set** without writing
`requirement.md` or touching `INDEX.md`. It reports every failing gate at once with the
offending rows/text so the human can fix them in one pass.

| Gate | Condition to PASS | Source |
|---|---|---|
| A — Status | Metadata `Status` cell equals `Signed Off` (exact, trimmed) | page body §1 |
| B — Open questions | No §14 row has Status `Open`; every row has a non-empty Answer | page body §14 |
| C — Approvals | Every §16 row has Decision `Approved`, a non-empty Name, and a valid Date | page body §16 |
| D — Inline comments | No unresolved/open inline comments on the page | `getConfluencePageInlineComments` |
| E — Metadata | No `<...>` or `TBD` in Feature slug / Priority / Target release | page body §1 |

**Failure behavior.** Stop. Emit a message of the form:

```
Sign-off gate FAILED for <slug> — not converting. Fix these and re-run:
  - Gate C (Approvals): row "Stakeholder(s)" Decision is "Pending" (expected Approved)
  - Gate D (Inline comments): 2 unresolved inline comments remain
```

No partial writes: if the gate fails, `requirement.md`, `INDEX.md`, and the Jira Epic are
left untouched.

**Pass behavior.** Proceed with the existing steps unchanged (convert, strip authoring
comments, write `requirement.md` with provenance footer, ensure feature Epic, update
`INDEX.md`, hand off to Architect).

### Part C — Review loop nudge (`product-review`)

Add one line to the iteration guidance: when a human answers a question, its §14 **Status**
should be set to `Resolved` (and the Answer filled). Without this, Gate B can never pass and
sign-off is permanently blocked. This keeps the authoring convention aligned with the gate.

## Data / parsing notes

- Confluence returns the page in **storage format** (XHTML). Tables are `<table>` with
  `<tr>/<td>`; the skill already converts storage→markdown, so gate parsing operates on the
  same parsed table model rather than raw glyphs — this is why §16 moves from a checkbox to a
  text `Decision` value.
- **Date validity** for Gate C = non-empty and parseable as a date; exact format is not
  enforced beyond "looks like a date" to avoid brittle locale rules.
- **Inline comment resolution** (Gate D): `getConfluencePageInlineComments` exposes each
  comment's resolved state; an unresolved comment fails the gate. Footer/summary comments do
  not count (they are the review loop's running notes).

## Error handling

- **Config guard** (unchanged): if `config/atlassian.json` is `unconfigured`/`TBD`, stop and
  tell the human to run `project-init` — before any gate runs.
- **Page not found / API error:** stop and report; do not assume pass or fail silently.
- **Missing sections** (e.g. no §16 table at all): treated as a gate failure with a clear
  "required Sign-Off section missing" message, not a crash.

## Testing strategy

Because these skills are Markdown procedures (not executable units), verification is by
**fixture-driven manual/agent runs** against representative pages:

1. **Happy path** — fully complete page → gate passes → `requirement.md` written with
   provenance; `INDEX.md` updated. (verify-before-done: read the written file.)
2. **Gate A** — Status `In Review` → stop, only Gate A reported.
3. **Gate B** — one Open Question `Open` / blank Answer → stop, Gate B reports that row.
4. **Gate C** — one approver `Pending` / missing Date → stop, Gate C reports that row.
5. **Gate D** — one unresolved inline comment → stop, Gate D reports the count.
6. **Gate E** — `Priority` still `<Must/Should/...>` → stop, Gate E reports the field.
7. **Multiple failures** — B + C + D fail together → single message lists all three.
8. **No partial writes** — after any failure, confirm `requirement.md`/`INDEX.md`/Epic
   unchanged.

## Rollout

1. Update the template (Part A). The template's Confluence copy is republished via
   `product-requirement-template`; existing in-flight pages keep working because the gate
   tolerates the old checkbox column by treating an unparseable Decision as `Pending`
   (fails safe → blocks sign-off until updated to the new column).
2. Update `product-signoff-to-md` (Part B) and `product-review` (Part C).
3. All three edits are one logical change; gate them behind a single Jira Story per the
   normal `jira-gate` flow when applied to a configured project.

## Open questions

None outstanding — threat model and gate set confirmed with the user (premature/incomplete;
all four gates blocking).
