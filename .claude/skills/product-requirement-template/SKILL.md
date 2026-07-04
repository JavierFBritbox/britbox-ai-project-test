---
name: product-requirement-template
description: >-
  Publishes/updates the requirement-document template in Confluence under the Product page so
  human Product members author requirements in a consistent structure. Source of truth is the
  repo file docs/templates/requirement-template.md. Trigger: "publish requirement template",
  "update the requirement template".
---

# product-requirement-template

Keeps the Confluence requirement template in sync with the repo.

## Source of truth

`docs/templates/requirement-template.md` in this repo is authoritative. Edit it there; this skill
pushes it to Confluence — never the other way around.

## Steps

1. Read `config/atlassian.json`. Guard: if unconfigured/`TBD`, stop and tell the human to run
   `project-init`.
2. Read `docs/templates/requirement-template.md`.
3. Convert markdown → Confluence storage format.
4. Under the Product page (`confluence.productPageId`), create or update a child page titled
   **"Requirement Template"** using `createConfluencePage` / `updateConfluencePage`.
5. Add a short intro panel telling authors to **copy** this template into a new page for each
   requirement and to set Status to "Signed Off" when ready.

## Guard & gate

Configuration guard as above. Track the publish/update with `jira-gate` (Task).
