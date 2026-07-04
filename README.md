# Britbox AI Project — AI-Driven Development Environment

An environment that uses AI to cover the **full software lifecycle** — generating an application,
maintaining it, debugging, and adding new features on demand — by emulating a real software team.
Specialised **roles** (AI agents) work alongside humans through well-defined **skills** and gates,
producing versioned artifacts at each stage.

> **New here? Read this file top to bottom, then run step 1 (`project-init`).**

---

## How it works

Roles are AI agents (in `.claude/agents/`) that perform work via reusable skills
(in `.claude/skills/`). Each role pairs with a human counterpart and only advances the pipeline at
explicit **human gates**. The application the team builds lives in this same repo under `apps/`.

```
Confluence "Product" folder            (humans write requirements)
        │  ①  PRODUCT role
        │      • publishes a requirement TEMPLATE humans must follow
        │      • reviews docs, posts comments/questions, iterates
        │      • HUMAN GATE: mark doc "Signed Off"
        ▼
   docs/features/<slug>/requirement.md
        │  ②  ARCHITECT role   (works directly in the repo, interactive)
        │      • checks if existing architecture already covers the requirement
        │      • proposes needs (infra/tech/components); interviews the architect
        │      • HUMAN GATE: architect signs off
        │      • publishes agreed design to Confluence, linked to the requirement
        ▼
   docs/features/<slug>/architecture.md
        │  ③  DEVOPS role      (works directly in the repo, interactive)
        │      • checks if existing infra/pipeline already covers the need
        │      • Terraform + GitHub Actions from the artifacts above
        │      • HUMAN GATE: agree envs, deploy rules, AWS account → sign off
        │      • publishes agreed design to Confluence, linked to architecture/requirement
        ▼
   infra/ + .github/workflows/     →  infrastructure ready

   ── (in parallel with DevOps, also from requirement + architecture) ──
        │  ④  TECH LEAD role   (works directly in the repo, interactive)
        │      • checks if existing code structure already covers the need
        │      • designs code structure/interfaces/data models; interviews the tech lead
        │      • HUMAN GATE: tech lead signs off → creates Jira Stories + Sub-tasks
        │      • publishes design to Confluence, linked to architecture/requirement
        ▼
   docs/features/<slug>/tech-design.md  +  code tickets (To Do)
        │  ⑤  DEVELOPER role   (NON-interactive)
        │      • consumes one code ticket → feature branch → implements → opens PR
        │      • ticket moves To Do → In Progress → In Review; PR gated by Reviewer/QA
        ▼
   apps/<module>/ code via PR per ticket

   A NEW FEATURE re-enters the pipeline; each role computes a DELTA vs existing artifacts.
```

## Rules that keep it safe and consistent

- **Config-driven integrations** — all Confluence/Jira IDs come from `config/atlassian.json`.
  Nothing is hardcoded. Until it's configured, integration skills stop and ask you to run
  `project-init` rather than making live calls.
- **Jira gate** — no AI role changes anything (Terraform, GitHub config, Actions, code, Confluence)
  without first opening a Jira ticket and moving it `To Do → In Progress → In Review/Testing → Done`.
- **Per-feature artifacts** — one folder per feature under `docs/features/<slug>/`; nothing is
  overwritten across features.
- **Human-in-the-loop** — the pipeline only advances at explicit human approvals.

## Getting started

### Step 0 — One-time Atlassian setup (human, admin)

The AI can create Confluence **pages** and Jira **issues**, but **not** spaces or projects
(admin-only). So a human creates the shells once:

- **Jira project** — *Team-managed software*, Access **Private**. Issue types: Epic, Story, Task,
  Bug, Sub-task. Workflow: `To Do → In Progress → In Review → Testing → Done` (+ `Blocked`).
- **Confluence space** — Global, restricted to the owner, with a top-level **`Product`** page.

### Step 1 — Initialise the environment

Run the **`project-init`** skill and give it the space key and project key. It connects to Jira and
Confluence, records all IDs (space/page IDs, issue-type IDs, workflow transition IDs) into
`config/atlassian.json`, creates the Confluence page structure, and uploads the requirement
template from `docs/templates/requirement-template.md`. See `config/README.md` for details.

### Step 2 — Run the pipeline

1. **Product team** authors a requirement in Confluence using the published template.
2. **Product role** reviews it (comments/questions), iterates, and on **Sign Off** converts it to
   `docs/features/<slug>/requirement.md`.
3. **Architect** and **DevOps** roles follow (as they are added).

## Repository layout

| Path | Purpose |
|---|---|
| `.claude/agents/` | Role definitions (AI agents). |
| `.claude/skills/` | Reusable procedures the roles invoke. |
| `config/` | Integration config (`atlassian.json`) + how to fill it in. |
| `docs/templates/` | Source of truth for the requirement template. |
| `docs/features/` | Per-feature artifacts + `INDEX.md` registry. |
| `docs/roles/`, `docs/process/` | Role catalogue and lifecycle detail. |
| `apps/`, `packages/` | The solution code (per-module stacks) + shared libraries. |
| `infra/`, `.github/workflows/` | Terraform and CI/CD produced by DevOps. |

## Current status

- ✅ Repo scaffold, conventions, requirement template
- ✅ **Product** role + skills (`project-init`, `jira-gate`, `product-requirement-template`,
  `product-review`, `product-signoff-to-md`)
- ✅ **Architect** role + skills (`architect-assess`, `architect-design`,
  `architect-signoff-to-md`) + architecture template
- ✅ **DevOps** role + skills (`devops-assess`, `devops-design`, `devops-signoff-to-md`)
  + devops template (Terraform + GitHub Actions)
- ✅ **Tech Lead** role + skills (`tech-lead-assess`, `tech-lead-design`, `tech-lead-signoff`)
  + tech-design template (code structure + Story/Sub-task breakdown → Jira tickets)
- ⏳ Atlassian space/project (awaiting permission) — everything runs config-guarded until then
- 🔜 **Developer** (non-interactive, feature-branch PRs), then QA / Reviewer / Release / Maintenance / Docs
