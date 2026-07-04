---
name: architect-assess
description: >-
  First step of the Architect role. Reads a signed-off requirement
  (docs/features/<slug>/requirement.md) plus existing architecture/infra, and — especially for
  feature iterations — checks whether the EXISTING architecture already covers the requirement's
  needs. Decides: fully covered (no change), partially covered (design the delta), or not covered
  (new architecture). Records the decision and rationale. Trigger: "assess architecture",
  "does this need architecture", "does existing architecture cover this", "architect assess <slug>".
---

# architect-assess

Decides whether a requirement needs architecture work — and how much — before any design begins.
This is the guard that keeps feature iterations cheap: if the current architecture already covers
the need, there's nothing to design.

## Steps

1. Read `docs/features/<slug>/requirement.md`. If missing/unsigned, stop and report.
2. **Coverage check.** Read existing `docs/features/*/architecture.md` and the current `apps/`,
   `packages/`, `infra/` to understand what already exists. Compare the requirement's needs
   (components, data, integrations, non-functionals) against the existing architecture.
3. Decide and record one of:
   - **Fully covered** — existing architecture already satisfies the requirement → "No architecture
     change required" (with rationale). Skip design; hand off.
   - **Partially covered** — design only the **delta** (what's new/changed) in `architect-design`.
   - **Not covered / greenfield** — full new design in `architect-design`.
4. Note the decision, rationale, and scope in section 2/15 of the draft architecture doc (or a short
   standalone note if fully covered).

## Output

- Fully covered → write a brief `docs/features/<slug>/architecture.md` stating "No architecture
  change required" + rationale, update `INDEX.md`, hand off to DevOps (may also be a no-op).
- Partial/new → hand to `architect-design` with the scope of what must be designed.

## Gate

Track with `jira-gate` (Task) once Jira is configured; if unconfigured/`TBD`, proceed locally and
flag the pending ticket.
