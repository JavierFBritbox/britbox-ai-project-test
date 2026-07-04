# Process

The end-to-end lifecycle this environment automates.

```
Confluence "Product" folder (humans author requirements)
      │  PRODUCT role  ── template · review/comments · iterate · sign-off gate
      ▼
docs/features/<slug>/requirement.md
      │  ARCHITECT role ── needs-architecture? · AWS design · agreement gate
      ▼
docs/features/<slug>/architecture.md
      │  DEVOPS role ── Terraform + GitHub Actions · envs/rules/account gate
      ▼
infra/ + .github/workflows/   →  infrastructure ready

New feature → re-enters the pipeline; each role computes a DELTA against existing artifacts.
```

## Cross-cutting rules

- **Config-driven integrations.** All Atlassian identifiers come from `config/atlassian.json`.
  Skills refuse live calls while it is `unconfigured`.
- **Jira gate.** No role mutates anything (Terraform, GitHub config, Actions, code, Confluence)
  without a Jira ticket moved To Do → In Progress → In Review/Testing → Done. Enforced by the
  `jira-gate` skill.
- **Per-feature artifacts.** Never overwrite another feature's files; one folder per feature.
- **Human gates.** Sign-off (Product), agreement (Architect), deploy-rule approval (DevOps).
- **Author/review separation.** The authoring pass and the review/verification pass are distinct.
