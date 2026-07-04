---
name: devops-signoff-to-md
description: >-
  Finalizes the DevOps setup when the human engineer SIGNS OFF (repo-local). Generates Terraform
  (infra/) and GitHub Actions (.github/workflows/), converts the draft into
  docs/features/<slug>/devops.md, updates docs/features/INDEX.md, and publishes the agreed doc to
  the Confluence DevOps folder linked to the architecture + requirement. Trigger: "devops signed
  off", "generate infra", "devops sign off <slug>".
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
2. **Generate infrastructure** from the agreed design:
   - `infra/` — Terraform modules + per-env config, remote state backend (S3 + DynamoDB), each
     resource traceable to an architecture component. **No secrets or `*.tfvars` with secrets in
     VCS** (`.gitignore` already excludes them).
   - `.github/workflows/` — the agreed workflows (CI, terraform-plan on PR, terraform-apply with
     environment protection, deploy/smoke). Use **GitHub OIDC → AWS IAM role**; reference secrets
     from GitHub environments, never inline.
3. **Verify** before finalizing: `terraform fmt -check`, `terraform validate` (and `plan` if creds
   allow), and lint the workflows. Fix issues; don't claim done on failure.
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
