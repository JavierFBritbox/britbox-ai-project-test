# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

An **AI-driven development environment** that emulates a real software team. Specialised **roles**
(implemented as agents in `.claude/agents/`) collaborate with humans, through reusable **skills**
(`.claude/skills/`), to carry a project across its full lifecycle: requirements → architecture →
infrastructure → development → maintenance/debugging → on-demand features. The solution code the
team builds lives in `apps/` (and shared code in `packages/`) within this same monorepo.

## The pipeline

```
Confluence Product folder ──PRODUCT──▶ docs/features/<slug>/requirement.md
   ──ARCHITECT──▶ docs/features/<slug>/architecture.md
   ──DEVOPS──▶ infra/ + .github/workflows/ + docs/features/<slug>/devops.md
```
Full detail: `docs/process/README.md`. Roles: `docs/roles/README.md`.

## Non-negotiable rules

1. **Integrations are config-driven.** Every Confluence/Jira identifier comes from
   `config/atlassian.json`. Never hardcode space keys, project keys, page IDs, issue-type IDs, or
   transition IDs anywhere else. If that file's `status` is `"unconfigured"` or a value is `"TBD"`,
   integration skills must **stop** and tell the user to run the `project-init` skill — not fail
   with live calls.
2. **Jira gate.** No role may mutate external state (Terraform, GitHub config/Actions, code,
   Confluence content, committed artifacts) without a Jira ticket moved
   `To Do → In Progress → In Review/Testing → Done`. This is enforced via the `jira-gate` skill;
   call it before mutating.
3. **Per-feature artifacts.** One folder per feature under `docs/features/<slug>/`. Never overwrite
   another feature's files; treat same-slug changes as revisions.
4. **Human gates.** Advance the pipeline only at explicit human approvals: Product sign-off,
   Architect agreement, DevOps deploy-rule approval.
5. **Author/review separation.** Keep the authoring pass and the review/verification pass distinct;
   verify before claiming a step complete. The Developer never merges its own PR — the Reviewer/QA
   roles gate the merge.
6. **Coding standards.** All code changes meet `docs/standards/coding-standards.md` (clean, secure,
   efficient, unit-tested; Definition of Done). The Developer writes to it; Reviewer/QA verify it.
7. **Preflight tool checks.** Before using any external tool/credential (`gh`, AWS, Terraform, Qase,
   language runtimes…), run the `preflight-check` skill. If something is missing, **stop and prompt
   the user** with the exact install/configure step — never guess or fail silently. Atlassian
   (Confluence + Jira) is provided once by `project-init`; all other tools are prompted just-in-time.

## Layout

- `.claude/agents/` — role definitions.  `.claude/skills/` — reusable procedures.
- `config/` — integration config (Atlassian) + how to fill it in.
- `docs/templates/requirement-template.md` — source of truth for the requirement template
  (published to Confluence by `product-requirement-template`).
- `docs/features/` — per-feature artifacts + `INDEX.md` registry.
- `apps/`, `packages/` — the solution code.  `infra/`, `.github/workflows/` — deployment.

## Atlassian

Cloud: `britbox.atlassian.net` (cloudId in `config/atlassian.json`), via the Atlassian Rovo MCP.
Available scopes allow reading/writing **pages** and **issues** but **not** creating spaces or
projects (admin-only) — those are created once by a human, then `project-init` records their IDs.
