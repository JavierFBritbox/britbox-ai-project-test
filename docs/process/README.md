# Process

The end-to-end lifecycle this environment automates.

```
Confluence "Product" folder (humans author requirements)
      │  PRODUCT role  ── template · review/comments · iterate · sign-off gate
      ▼
docs/features/<slug>/requirement.md
      │  ARCHITECT role (repo-local, interactive)
      │   ── coverage check (does existing arch already cover it?)
      │   ── propose needs · interview architect · AWS design
      │   ── HUMAN GATE: sign-off → publish to Confluence, linked to requirement
      ▼
docs/features/<slug>/architecture.md
      │  DEVOPS role (repo-local, interactive)
      │   ── coverage check (does existing infra/pipeline cover it?)
      │   ── Terraform + GitHub Actions · interview: envs/AWS account/deploy rules
      │   ── HUMAN GATE: sign-off → publish to Confluence, linked to architecture/requirement
      ▼
infra/ + .github/workflows/   →  infrastructure ready

(In parallel with DevOps, also from requirement + architecture:)
docs/features/<slug>/architecture.md
      │  TECH LEAD role (repo-local, interactive)
      │   ── coverage check (does existing code structure cover it?)
      │   ── code structure/interfaces/data models · interview tech lead
      │   ── HUMAN GATE: sign-off → create Jira Stories + Sub-tasks · publish to Confluence
      ▼
docs/features/<slug>/tech-design.md + code tickets (To Do)
      │  DEVELOPER role (NON-interactive, single dev, SERIAL)
      │   ── one ticket at a time; next ticket starts only after the previous PR merges
      │      (branch from fresh main) → no divergent branches, no merge conflicts
      │   ── consume one ticket → feature branch → implement → open PR
      │   ── ticket To Do → In Progress → In Review; PR gated by Reviewer/QA (later roles)
      ▼
apps/<module>/ code via PR per Sub-task
      │  CODE REVIEWER ── review PR vs coding standards → approve → merge (unblocks next ticket)
      ▼
Story complete (all Sub-tasks merged)
      │  RELEASE MANAGER ── cut vX.Y.0-rc.1 → deploy to test env
      │  QA ── test RC vs acceptance criteria → bugs (patch) or pass
      │  RELEASE MANAGER ── on QA pass, promote to vX.Y.0 → deploy to prod
      │  DOCS ── document the released feature → publish to Confluence Documentation folder
      ▼
released + documented version

New feature → re-enters the pipeline; each role computes a DELTA against existing artifacts.
Versioning & branching: see docs/process/versioning.md.
```

## Post-release loop (Maintenance / Debugger)

Once a version is released, the **Maintenance/Debugger** role is the front door for what comes next.
It does not run a separate pipeline — it triages and re-enters the existing one:

Intake sources include **human-created Jira tickets** — a human may add a Bug, small Task, or
improvement directly in Jira; Maintenance scans for and triages those the same way (routing, not
duplicating, the existing ticket).

```
Human-created Jira ticket / bug report / incident / change request
   │  MAINTENANCE ── intake (template) · reproduce & root-cause defects · classify · severity
   ▼
route to the correct entry point:
   • Defect            → Developer (fix) → Code Reviewer → Release Manager (patch vX.Y.Z) → QA re-test
   • Small enhancement → Tech Lead (new Story/Sub-task) → Developer → …
   • New capability    → Product (new requirement) → full pipeline (Architect/DevOps deltas → …)
```


## Cross-cutting rules

- **Config-driven integrations.** All Atlassian identifiers come from `config/atlassian.json`.
  Skills refuse live calls while it is `unconfigured`.
- **Jira gate.** No role mutates anything (Terraform, GitHub config, Actions, code, Confluence)
  without a Jira ticket moved To Do → In Progress → In Review/Testing → Done. Enforced by the
  `jira-gate` skill.
- **Per-feature artifacts.** Never overwrite another feature's files; one folder per feature.
- **Human gates.** Sign-off (Product), agreement (Architect), deploy-rule approval (DevOps),
  design + ticket-breakdown sign-off (Tech Lead). The Developer is non-interactive — its PR is
  gated at merge by the Reviewer/QA roles rather than at authoring time.
- **Author/review separation.** The authoring pass and the review/verification pass are distinct.
