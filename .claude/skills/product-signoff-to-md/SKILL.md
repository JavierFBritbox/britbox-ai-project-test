---
name: product-signoff-to-md
description: >-
  When a human marks a Confluence requirement doc "Signed Off", converts it into
  docs/features/<slug>/requirement.md in the repo (stripping authoring comments), records
  provenance, updates docs/features/INDEX.md, and hands off to the Architect role. Trigger:
  "sign off", "convert signed-off requirement", "requirement is signed off".
---

# product-signoff-to-md

Turns an approved Confluence requirement into a versioned repo artifact — the input for the
Architect role.

## Preconditions

- The Confluence page Status is **"Signed Off"** and the Sign-Off section is complete.
- The doc has a `feature slug` in its metadata. If missing, ask the human before proceeding.

## Steps

1. Read `config/atlassian.json`. Guard: if unconfigured/`TBD`, stop and tell the human to run
   `project-init`.
2. Read the signed-off Confluence page.
3. Verify Status == "Signed Off"; if not, stop and report.
4. Convert storage format → clean markdown; **strip** HTML authoring comments and resolved
   question threads. Keep the answered Open Questions table for traceability.
5. Write `docs/features/<slug>/requirement.md`. Do **not** overwrite a different feature's file;
   if the same slug already has a requirement, treat it as a revision (note the version/date).
6. Add a provenance footer: Confluence page link, page version, sign-off date, approvers.
7. **Ensure the feature Epic exists** — create a Jira **Epic** for this feature (via `jira-gate`,
   `issueTypes.epic`) if one doesn't already exist, so all downstream tickets (Architect/DevOps
   Tasks, Tech Lead Stories/Sub-tasks) link to it. Record the Epic key in `INDEX.md`.
8. Update `docs/features/INDEX.md` (slug → status `Requirement Signed Off`, Jira Epic, links, date).
9. Hand off: state that the Architect role can now assess this requirement.

## Guard & gate

Configuration guard as above. Track the conversion + commit with `jira-gate` (Story) and move it
to Done once `requirement.md` is committed.
