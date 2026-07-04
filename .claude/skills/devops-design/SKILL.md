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
3. **Interview the engineer** on the specifics (the platform/env set/auth are FIXED by
   `docs/standards/devops-standards.md` — enforce them):
   - **AWS account + region** for each of the three mandatory environments **test / stage / prod**;
   - **Deploy rules** — triggers, required approvals/reviewers (**prod requires manual approval**),
     promotion path (`test → stage → prod`), rollback strategy, change windows;
   - **GitHub Actions steps** — CI (lint/test/build), `terraform plan` on PR, `terraform apply`
     on merge/tag with environment protection, deploy/smoke-test jobs;
   - **GitHub Environments** — the `test`/`stage`/`prod` environments and their scoped
     **variables + secrets** (values set by the human in GitHub, never in the repo);
   - **State backend** (S3 + DynamoDB, per-env keys) and **auth via GitHub OIDC → AWS IAM role per
     env** (no long-lived keys).
4. Map each architecture component to Terraform resources/modules; propose the `infra/` module
   layout and workflow set. Ground non-trivial choices in official docs (AWS skills + AWS docs MCP,
   Terraform/GitHub Actions docs).
5. Iterate on trade-offs and open questions until the engineer is satisfied. **Do not self-sign-off.**
6. When the engineer confirms, hand to `devops-signoff-to-md` to generate and publish.

## Gate

Track with `jira-gate` (Task) once Jira is configured; if unconfigured/`TBD`, proceed locally and
flag the pending ticket.
