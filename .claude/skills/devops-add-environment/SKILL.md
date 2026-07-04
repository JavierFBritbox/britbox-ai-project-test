---
name: devops-add-environment
description: >-
  Adds a new deployment environment to an existing DevOps setup, incrementally. Use when the project
  started with one environment (one AWS account) and now needs another (e.g. add stage, then prod),
  or to bootstrap the first environment. Provisions the GitHub Environment, Terraform per-env config
  + state key, and wires it into the promotion path — following all enforced DevOps standards.
  Trigger: "add environment <name>", "add stage/prod", "set up a new AWS account env", "devops add
  environment".
---

# devops-add-environment

Grows the environment topology one environment at a time toward the target `test → stage → prod`,
without re-doing the whole DevOps setup. Every environment added obeys
`docs/standards/devops-standards.md`.

## Steps

1. **Preflight** — `preflight-check` (git, `gh`, AWS). Confirm the target **environment name**
   (`test`/`stage`/`prod`) and its **AWS account + region**.
2. **OIDC role (human prerequisite)** — verify the per-env **OIDC IAM role** exists for the new
   account. If not, **stop and request the human DevOps engineer** to create it (the AI cannot).
   If provisioning needs new IAM permissions, **request Platform Engineering** — do not self-escalate.
3. **GitHub Environment** — create the `<env>` GitHub Environment (via `gh`/API) with its scoped
   **variables + secrets** and **protection rules**; for **prod**, require manual approval /
   reviewers. Prompt the human to set secret **values** in GitHub (never in the repo).
4. **Terraform** — add `infra/envs/<env>` composition with its **own state key** (S3 + DynamoDB),
   reusing `infra/modules/*`; tag resources with the environment. `fmt`/`validate`/`plan`.
5. **Workflows** — wire the new environment into `.github/workflows/` (apply + deploy jobs) and the
   **promotion path in order** (`test → stage → prod`); prod stays behind manual approval.
6. **Verify** — the new environment deploys via OIDC (no static keys), plan is clean, promotion order
   holds. Fix issues before finalizing.
7. **Document & gate** — update `docs/features/<slug>/devops.md` (or the shared infra doc) and
   `INDEX.md`; track via `jira-gate` (Task) → branch → PR → Code Reviewer. Publish the update to
   Confluence (config-guarded).

## Notes

- Starting state may be a **single environment**; that's allowed. This skill is how you reach the
  full `test → stage → prod` topology later.
- Never skip an **existing** environment on the promotion path to reach prod.
