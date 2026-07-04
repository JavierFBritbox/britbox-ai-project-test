---
name: architect-signoff-to-md
description: >-
  Finalizes the architecture when the human architect SIGNS OFF (repo-local, not Confluence).
  Converts the working draft into docs/features/<slug>/architecture.md, records the sign-off
  (name + date) and provenance, updates docs/features/INDEX.md, and hands off to DevOps. Trigger:
  "architecture signed off", "finalize architecture", "architect sign off <slug>".
---

# architect-signoff-to-md

Turns the agreed design into the committed artifact DevOps consumes. Sign-off is a **human action
in the local session** — the architect explicitly confirms.

## Sign-off mechanism (repo-local)

The human architect signs off in one of two ways (either is sufficient):
- states sign-off in the session (you record their name + date), or
- sets `Status: Agreed` and completes section 17 (Agreement) in
  `docs/features/<slug>/architecture.draft.md`.

Never mark sign-off on the human's behalf.

## Steps

1. Confirm the human architect has signed off and open questions are resolved. If not, stop and
   report what's outstanding.
2. Finalize the draft into `docs/features/<slug>/architecture.md`:
   - strip authoring HTML comments; keep the answered open-questions table and the ADR/alternatives;
   - set Status `Agreed`; complete the Agreement section with the architect's name + date.
3. Add a provenance footer: requirement link, sign-off date, architect name, and (for iterations) a
   summary of the delta applied vs prior architecture.
4. Remove the `architecture.draft.md` working file.
5. Update `docs/features/INDEX.md` (status → `Architecture Agreed`, links, date).
6. **Publish to Confluence** (traceability). Read `config/atlassian.json`:
   - If Confluence is configured, create/update a page under the **Architecture** folder
     (`confluence.architecturePageId`) with the agreed architecture (markdown → storage format),
     and **link it to the requirement page** (add a link both ways: architecture → requirement and,
     if possible, a note on the requirement page pointing to the architecture). Store the resulting
     page link back in the `architecture.md` provenance footer and in `INDEX.md`.
   - If Confluence is `unconfigured`/`TBD`, **skip the publish** but keep the committed
     `architecture.md`; flag that the Confluence publish is pending (do it on next run once configured).
7. Hand off: state that the DevOps role can now derive infrastructure from this architecture.

## Gate

Track with `jira-gate` (Task) once Jira is configured; move to Done after `architecture.md` is
committed and (when possible) published. If Jira/Confluence are unconfigured/`TBD`, flag the
pending ticket/publish.
