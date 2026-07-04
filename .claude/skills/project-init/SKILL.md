---
name: project-init
description: >-
  Step 1 of the AI development environment. Connects to Jira and Confluence, verifies the
  dedicated space and project exist, discovers and records their IDs (issue types, workflow
  transitions, space/page IDs) into config/atlassian.json, creates the Confluence page
  structure (a top-level "Product" page + supporting pages), and uploads the requirement-document
  template from docs/templates/requirement-template.md to Confluence. Run once per project, or
  again to re-sync IDs. Trigger: "init project", "project-init", "set up the AI environment".
---

# project-init

Initialises the integration layer for this AI development environment. This is **step 1**.

## Prerequisites (human, one-time)

The available Atlassian tools can create pages and issues but **cannot create a Confluence space
or a Jira project** (those need admin scopes). So a human must first create, in the Atlassian UI:

- A **Jira project** — recommended: *Team-managed software*, Access = **Private**, key e.g. `BAIP`.
  Issue types: Epic, Story, Task, Bug, Sub-task. Workflow statuses:
  `To Do → In Progress → In Review → Testing → Done` (+ `Blocked`).
- A **Confluence space** — Global, restricted to the owner, key e.g. `BAIP`.

Then provide the **space key** and **project key** to this skill.

## What this skill does

1. **Read `config/atlassian.json`.** Use `cloudId` already present.
2. **Verify Confluence space** via `getConfluenceSpaces` (by key) → record `spaceId`.
3. **Verify Jira project** via `getVisibleJiraProjects` (by key) → record `projectId`.
4. **Discover Jira issue-type IDs** via `getJiraProjectIssueTypesMetadata` → fill `jira.issueTypes`.
5. **Discover workflow transition IDs**: create (or inspect) a sample issue and call
   `getTransitionsForJiraIssue` → map names to IDs in `jira.transitions`
   (To Do / In Progress / In Review / Testing / Done / Blocked). Delete the sample issue or reuse
   a real one; do not leave stray tickets.
6. **Create the Confluence structure** via `createConfluencePage`:
   - top-level **`Product`** page (record its id as `confluence.productPageId`),
   - a **`Requirement Template`** child page whose body is
     `docs/templates/requirement-template.md` (converted to Confluence storage format),
   - an **`Architecture`** landing page/folder (record its id as `confluence.architecturePageId`)
     where the Architect role publishes agreed architectures and links them to their requirement,
   - a **`DevOps`** landing page/folder (record its id as `confluence.devopsPageId`) where the
     DevOps role publishes agreed deployment designs, linked to the architecture/requirement,
   - a **`Technical Design`** landing page/folder (record its id as `confluence.techDesignPageId`)
     where the Tech Lead role publishes agreed technical designs, linked to architecture/requirement.
7. **Write back** all discovered IDs to `config/atlassian.json` and set `"status": "configured"`.

## Guard

If the space or project cannot be found by key, **stop** and report exactly which one is missing
and the recommended settings above. Do not attempt to create spaces/projects — it will fail.

## Jira gate

Track this initialisation itself with a Jira ticket via `jira-gate` once the project exists
(open → In Progress → Done). For the very first run, the ticket is created as part of step 5.

## Idempotency

Safe to re-run. If a page already exists (same title under the same parent), update it rather
than creating a duplicate. If IDs are already filled, verify and refresh them.
