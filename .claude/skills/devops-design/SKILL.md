---
name: devops-design
description: >-
  Core of the DevOps role — the trigger for the deployment step. Runs an INTERACTIVE, repo-local
  interview with the human DevOps engineer: reads the requirement + agreed architecture, checks
  existing infra coverage, and defines environments, target AWS accounts, deploy rules (triggers,
  approvals, promotion, rollback), and GitHub Actions steps. Drafts Terraform + workflow designs
  and iterates until the engineer SIGNS OFF. Trigger: "design devops", "start deployment setup",
  "devops design <slug>".
---

# devops-design

The interactive, repo-local deployment-design loop. This is where the DevOps step is triggered.

## How it works

Runs in a local Claude session with the human DevOps engineer present. You propose; the engineer
decides; you revise; repeat until sign-off. No infra is generated until sign-off (that's
`devops-signoff-to-md`).

## Steps

1. Read `docs/features/<slug>/requirement.md` + `architecture.md` (must be `Agreed`). Run/confirm
   the `devops-assess` coverage decision.
2. Draft/extend `docs/features/<slug>/devops.draft.md` from `docs/templates/devops-template.md`
   (Status `Draft`).
3. **Interview the engineer** on the decisions that need a human:
   - **Environments** (dev/staging/prod) and the target **AWS account(s)** per environment;
   - **Deploy rules** — what triggers deploys, required approvals/reviewers, promotion path,
     rollback strategy, change windows;
   - **GitHub Actions steps** — CI (lint/test/build), `terraform plan` on PR, `terraform apply`
     on merge/tag with environment protection, deploy/smoke-test jobs;
   - **State backend** (S3 + DynamoDB) and **secrets** approach (prefer GitHub OIDC → AWS IAM).
4. Map each architecture component to Terraform resources/modules; propose the `infra/` module
   layout and workflow set. Ground non-trivial choices in official docs (AWS skills + AWS docs MCP,
   Terraform/GitHub Actions docs).
5. Iterate on trade-offs and open questions until the engineer is satisfied. **Do not self-sign-off.**
6. When the engineer confirms, hand to `devops-signoff-to-md` to generate and publish.

## Gate

Track with `jira-gate` (Task) once Jira is configured; if unconfigured/`TBD`, proceed locally and
flag the pending ticket.
