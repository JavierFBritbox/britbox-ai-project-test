---
name: tech-lead-signoff
description: >-
  Finalizes the technical design when the human tech lead SIGNS OFF (repo-local). Converts the draft
  into docs/features/<slug>/tech-design.md, CREATES the code tickets in Jira (Stories + Sub-tasks
  under the feature Epic, in To Do), updates docs/features/INDEX.md, publishes the design to
  Confluence linked to architecture/requirement, and hands the tickets to the Developer role.
  Trigger: "tech design signed off", "create the code tickets", "tech-lead sign off <slug>".
---

# tech-lead-signoff

Turns the agreed technical design into code tickets the non-interactive Developer will consume.
Sign-off is a **human action in the local session** — the tech lead explicitly confirms.

## Sign-off mechanism (repo-local)

Either is sufficient (never mark on the human's behalf):
- the tech lead states sign-off in the session (record name + date), or
- sets `Status: Agreed` and completes section 15 (Agreement) in `tech-design.draft.md`.

## Steps

1. Confirm sign-off and that open questions are resolved. If not, stop and report.
2. Finalize `docs/features/<slug>/tech-design.md` (strip HTML comments; keep answered questions +
   decisions; Status `Agreed`; Agreement section with name + date; provenance footer linking
   requirement + architecture).
3. **Create the code tickets in Jira** (config-guarded). Read `config/atlassian.json`:
   - Ensure the **feature Epic** exists (create it under `jira.projectKey` using
     `issueTypes.epic` if missing).
   - For each Story in section 10 → create a **Story** (`issueTypes.story`) linked to the Epic,
     in **To Do**.
   - For each Sub-task → create a **Sub-task** (`issueTypes.subtask`) under its Story, in **To Do**,
     with the target path, description, acceptance criteria, and dependencies from the design.
   - Record the created ticket keys back into `tech-design.md` (§10) for traceability.
   - If Jira is `unconfigured`/`TBD`, **skip creation** but keep the finalized design; flag ticket
     creation as pending.
4. Update `docs/features/INDEX.md` (status → `Tickets Created`, links, date).
5. **Publish to Confluence** (config-guarded): create/update a page under the **Technical Design**
   folder (`confluence.techDesignPageId`) with the agreed design, linked to the architecture and
   requirement pages; store the page link in the provenance footer and `INDEX.md`. Skip/flag if
   Confluence is `unconfigured`/`TBD`.
6. Hand off: the Developer role can now consume the To Do tickets (one per run).

## Gate

Track this finalization with `jira-gate` (Task); move to Done after `tech-design.md` is committed
and tickets are created. The created Stories/Sub-tasks are the deliverable, not gate tickets.
