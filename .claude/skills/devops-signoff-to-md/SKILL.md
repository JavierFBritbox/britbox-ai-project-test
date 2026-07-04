---
name: devops-signoff-to-md
description: >-
  Use when the human DevOps engineer has signed off the deployment design. Generates the Terraform
  (infra/) + GitHub Actions (.github/workflows/), writes devops.md, and publishes to Confluence.
  Trigger: "devops signed off", "generate infra", "devops sign off <slug>".
---

# devops-signoff-to-md

Turns the agreed deployment design into real infrastructure and CI/CD. Sign-off is a **human
action in the local session** — the engineer explicitly confirms.

## Sign-off mechanism (repo-local)

Either is sufficient (never mark on the human's behalf):
- the engineer states sign-off in the session (record name + date), or
- sets `Status: Agreed` and completes section 13 (Agreement) in `devops.draft.md`.

## Steps

1. Confirm sign-off and that open questions are resolved. If not, stop and report.
2. **Generate infrastructure** from the agreed design, per `docs/standards/devops-standards.md`:
   - `infra/` — Terraform modules + **per-env config for the environment(s) being provisioned now**
     (at least one; `infra/envs/<env>`), remote state (S3 + DynamoDB) with per-env keys, each
     resource tagged and traceable to an architecture component. **No secrets or `*.tfvars` with
     secrets in VCS** (`.gitignore` already excludes them).
   - `.github/workflows/` — the required workflows (CI, terraform-plan on PR, terraform-apply with
     environment protection, deploy/smoke) for the environment(s) that exist; RC tag → **test**,
     promotion follows `test → stage → prod` across existing envs with **prod behind manual
     approval**. Use **GitHub OIDC → AWS IAM role per env**; reference GitHub Environment
     secrets/variables, **never inline**.
   - **GitHub Environments** — ensure the environment(s) being provisioned exist (via `gh`/API) with
     protection rules (prod = required reviewers) and scoped variables/secrets. Prompt the human to
     set secret **values** in GitHub (never store them in the repo). Add more environments later with
     `devops-add-environment`.
3. **Verify** against the DevOps Definition of Done (via `verify-before-done`): `terraform fmt
   -check`, `terraform validate` (and `plan` if creds allow), lint the workflows, and confirm the
   **environment(s) provisioned now** (at least one) have their OIDC role (no static keys) and are
   wired into the promotion path in order. Fix issues; don't claim done on failure.
4. Finalize `docs/features/<slug>/devops.md` (strip HTML comments; keep answered questions; Status
   `Agreed`; Agreement section with name + date; provenance footer linking requirement +
   architecture).
5. Remove `devops.draft.md`. Update `docs/features/INDEX.md` (status → `Infra Defined`, links, date).
6. **Publish to Confluence** (config-guarded): create/update a page under the **DevOps** folder
   (`confluence.devopsPageId`) with the agreed doc, linked to the architecture and requirement
   pages. Store the page link in the `devops.md` provenance footer and `INDEX.md`. If Confluence is
   `unconfigured`/`TBD`, skip and flag as pending.
7. Hand off: infrastructure is ready; the Developer role can begin building against it.

## Gate

Track with `jira-gate` (Task); move to Done after infra/workflows are committed and verified. If
Jira/Confluence are unconfigured/`TBD`, flag the pending ticket/publish.
