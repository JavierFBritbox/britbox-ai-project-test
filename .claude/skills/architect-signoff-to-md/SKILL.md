---
name: architect-signoff-to-md
description: >-
  Finalizes an agreed architecture. When the human architect and the Architect role both agree
  (Status "Agreed"), commits docs/features/<slug>/architecture.md, records provenance, updates
  docs/features/INDEX.md, and hands off to the DevOps role. Trigger: "architecture agreed",
  "finalize architecture", "architect sign off <slug>".
---

# architect-signoff-to-md

Turns an agreed design into the committed artifact that DevOps consumes.

## Preconditions

- Architecture Status is **"Agreed"** and section 17 (Agreement) is complete.
- Open questions are resolved.

## Steps

1. Read `config/atlassian.json` (guard: stop if unconfigured/`TBD`).
2. Verify Status == "Agreed"; if not, stop and report what's outstanding.
3. Finalize `docs/features/<slug>/architecture.md` — strip authoring HTML comments; keep the
   answered open-questions table and the ADR/alternatives for traceability.
4. Add a provenance footer: requirement link, Confluence page link (if published), agreement date,
   parties.
5. Update `docs/features/INDEX.md` (status → `Architecture Agreed`, links, date).
6. Hand off: state that the DevOps role can now derive infrastructure from this architecture.

## Guard & gate

Configuration guard as above. Track with `jira-gate` (Task); move to Done once committed.
