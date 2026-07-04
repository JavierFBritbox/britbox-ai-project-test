---
name: docs-author
description: >-
  Writes/updates end-user and developer documentation for a released feature. Reads the feature's
  requirement, tech design, shipped code, and CHANGELOG entry, and produces docs under
  docs/product/<slug>/ from the documentation template — traceable to the feature and the version.
  Trigger: "document <slug>", "write docs for <feature>", "update docs", "docs author".
---

# docs-author

Produces documentation that matches what actually shipped.

## Steps

1. **Preflight & guard** — `preflight-check` (git); read `config/atlassian.json`.
2. **Gather truth** — read `docs/features/<slug>/requirement.md` and `tech-design.md`, the shipped
   code in the relevant `apps/<module>`/`packages/`, and the `CHANGELOG.md` entry for the version.
3. **Write/update** `docs/product/<slug>/` from `docs/templates/documentation-template.md`:
   - **User guide** — task-oriented steps for end users.
   - **Developer reference** — APIs/contracts, data/schemas, key modules, run/build/test locally,
     required env/secret **names** (never values).
   - Note the **version documented** and link the requirement + CHANGELOG entry.
4. **Verify accuracy** — cross-check claims against the actual code/behavior; remove anything
   speculative. Documentation trails released behavior.
5. **Hand off** — the docs are ready for `docs-publish` to push to Confluence.

## Rules

No secrets/PII/tokens in docs. If you discover a defect or a requirement/code mismatch while
writing, route it to **Maintenance** (`maintenance-triage`) — don't fix code here. Track with
`jira-gate` (Task).
