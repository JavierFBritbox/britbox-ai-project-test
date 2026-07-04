---
name: architect-assess
description: >-
  First step of the Architect role. Reads a signed-off requirement
  (docs/features/<slug>/requirement.md) plus existing architecture/infra, and decides whether new
  or changed architecture is required (vs config-only or reuse of existing systems). Records the
  decision and rationale. Trigger: "assess architecture", "does this need architecture",
  "architect assess <slug>".
---

# architect-assess

Decides whether a requirement warrants architecture work before any design begins.

## Steps

1. Read `config/atlassian.json` (guard: stop if unconfigured/`TBD`).
2. Read `docs/features/<slug>/requirement.md`. If missing/unsigned, stop and report.
3. Read existing context: other `docs/features/*/architecture.md`, and the current `apps/`,
   `packages/`, `infra/` layout — to know what already exists.
4. Decide:
   - **New architecture** — greenfield system or major new component.
   - **Change/extend** — modifies existing architecture (compute the delta).
   - **Not needed** — config-only, content, or fully covered by existing design.
5. Record the decision + rationale + scope in section 2 of a draft architecture doc (or a short
   note if "not needed").
6. Track with `jira-gate` (Task).

## Output

- If architecture is needed → hand to `architect-design`.
- If not → write a brief `docs/features/<slug>/architecture.md` stating "No architecture change
  required" with rationale, update `INDEX.md`, and hand off to DevOps (which may also be a no-op).
