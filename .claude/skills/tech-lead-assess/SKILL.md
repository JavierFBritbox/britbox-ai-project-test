---
name: tech-lead-assess
description: >-
  First step of the Tech Lead role. Reads a signed-off requirement + agreed architecture and — for
  feature iterations — checks whether the EXISTING code structure (apps/, packages/) already
  accommodates the need. Decides: fully covered, partial (design the delta), or not covered (full
  design). Trigger: "assess tech design", "does the code cover this", "tech-lead assess <slug>".
---

# tech-lead-assess

Keeps technical design and ticketing proportional to the change.

## Steps

1. Read `docs/features/<slug>/requirement.md` (signed off) and `architecture.md` (agreed). If
   either is missing/not final, stop and report.
2. **Coverage check.** Read existing `apps/`, `packages/`, and prior `tech-design.md` files to
   understand the current code structure and conventions.
3. Decide and record:
   - **Fully covered** → little/no new code design; minimal or no tickets; note rationale.
   - **Partial** → design and ticket only the **delta** in `tech-lead-design`.
   - **Not covered / greenfield** → full design in `tech-lead-design`.

## Gate

Track with `jira-gate` (Task) once Jira is configured; if unconfigured/`TBD`, proceed locally and
flag the pending ticket.
