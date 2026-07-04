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
        │  ⑤  DEVELOPER role   (NON-interactive, single dev, serial)
        │      • one ticket at a time → feature branch → implements → opens PR
        │      • next ticket only after the previous PR merges (no divergent branches)
        ▼
   apps/<module>/ code via PR per Sub-task
        │  ⑥  CODE REVIEWER    • reviews PR vs coding standards → approve → merge
        ▼
   Story complete
        │  ⑦  RELEASE MANAGER  • cut vX.Y.0-rc.1 → deploy to test env
        │  ⑧  QA               • test RC vs acceptance criteria → bugs (patch) or pass
        │  ⑦  RELEASE MANAGER  • on QA pass, promote to vX.Y.0 → deploy to prod
        ▼
   released version

   A NEW FEATURE re-enters the pipeline; each role computes a DELTA vs existing artifacts.
   Versioning & branching: docs/process/versioning.md
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

## Toolkit — what you need installed & configured

This environment orchestrates real tools. Install/configure the ones for the roles you'll run;
each role also **checks its own tools at runtime** (`preflight-check` skill) and will prompt you for
anything missing rather than failing. **Atlassian is set up once via `project-init`; everything else
is prompted just-in-time.**

| Tool / access | Needed for | Install / configure |
|---|---|---|
| **Claude Code** + **Atlassian Rovo MCP** connected | all roles; Confluence/Jira access | Claude Code with the Atlassian (Rovo) MCP connected to `britbox.atlassian.net` |
| **git** | everything | preinstalled on macOS / your package manager |
| **GitHub CLI `gh`** (authenticated) | Developer, Code Reviewer, Release Manager | `brew install gh` → `gh auth login` |
| **AWS CLI** (credentials) | DevOps (and Architect research) | `brew install awscli` → `aws configure` / SSO |
| **Terraform** | DevOps | `brew install terraform` |
| **Language runtimes** (Node, Python, …) | Developer (per app module) | install the runtime + package manager each `apps/<module>` uses |
| **Atlassian project + space** | Product/Architect/DevOps/Tech Lead + gate | created once by a human (Step 0), recorded by `project-init` |
| **Qase** account + API token | QA | create a Qase project; `export QASE_API_TOKEN=…`; set `projectCode` in `config/qase.json` |

Config files that wire it together: `config/atlassian.json` (Confluence + Jira) and
`config/qase.json` (Qase). Secrets (tokens/keys) live in env vars, **never** in the repo.

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
- ✅ **Developer** role (non-interactive) + skill (`developer-implement`) + coding standards
  (`docs/standards/coding-standards.md`): one ticket → feature branch → tested code → PR
- ✅ **Versioning & branching strategy** (`docs/process/versioning.md`, `VERSION`, `CHANGELOG.md`):
  trunk-based, SemVer, version per Story via RC-then-promote
- ✅ **Code Reviewer** role (`code-reviewer-review`): per-Sub-task PR gate → approve + squash-merge
- ✅ **Release Manager** role (`release-cut-rc`, `release-promote`): SemVer tags, changelog, RC/promote
- ✅ **QA** role (`qa-test-run`) using **Qase** (`config/qase.json`): test the RC, file bugs, sign off
- ✅ **Maintenance/Debugger** role (`maintenance-triage`, `maintenance-debug`) + intake template:
  post-release front door — reproduce, root-cause, classify, route back into the pipeline
- ⏳ Atlassian space/project + Qase project (awaiting setup) — everything runs config-guarded until then
- 🔜 Docs / Technical Writer role
