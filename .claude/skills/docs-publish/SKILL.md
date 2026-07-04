---
name: docs-publish
description: >-
  Publishes product documentation to the Confluence Documentation folder, linked to the feature's
  requirement, and records the page link back in the repo doc. Config-guarded — skips and flags if
  Confluence is not configured. Trigger: "publish docs", "publish documentation for <slug>", "docs
  publish".
---

# docs-publish

Pushes the authored docs to Confluence for the wider team.

## Steps

1. **Preflight & guard** — read `config/atlassian.json`. If Confluence is `unconfigured`/`TBD`,
   **skip publishing** and flag it as pending; the repo docs still stand.
2. **Read** the finalized `docs/product/<slug>/` documentation.
3. **Publish** — under the Confluence **Documentation** folder (`confluence.docsPageId`), create or
   update a page per feature (markdown → storage format). Link it to the feature's **requirement**
   page (and architecture where useful).
4. **Backlink** — store the Confluence page link in the repo doc's metadata for traceability.
5. **Idempotent** — update the existing page for a feature rather than creating duplicates; note the
   version documented.

## Gate

Track with `jira-gate` (Task). No secrets/PII in published content.
