---
name: devops-monitor
description: >-
  DevOps pipeline monitoring & repair. Watches GitHub Actions runs (CI, terraform-plan/apply,
  deploy), diagnoses failures, and fixes pipeline issues — correcting workflows/Terraform through the
  normal gated flow, or escalating to Platform Engineering if it's a permissions gap. Keeps the CI/CD
  green and main deployable. Trigger: "check the pipeline", "why did the deploy fail", "monitor CI",
  "devops monitor", "fix the workflow".
---

# devops-monitor

DevOps owns the CI/CD after building it. This skill tests, watches, and repairs it.

## Steps

1. **Preflight** — `preflight-check` (git, `gh` authenticated; AWS/OIDC if diagnosing deploys).
2. **Observe runs** — `gh run list` / `gh run view [--log-failed]` / `gh run watch` across the
   required workflows (ci, terraform-plan, terraform-apply, deploy) for the affected env(s).
3. **Diagnose the failure** — classify: build/test failure, `terraform plan/apply` error, deploy or
   smoke-test failure, auth/OIDC issue, or a missing-permission error.
4. **Fix by cause:**
   - **Workflow / Terraform defect** → correct it via the normal gated flow (`jira-gate` Task →
     branch → PR → Code Reviewer). Verify with `terraform validate`/`plan` and a re-run.
   - **Auth / OIDC not set up** → stop and **request the human DevOps engineer** (OIDC role is a
     human prerequisite; the AI can't create it).
   - **Missing IAM permission / capability** → **request Platform Engineering (human)** with what +
     why; block until granted. Never self-escalate or work around it.
   - **Flaky/transient** → re-run; if it recurs, treat as a defect (don't mask it).
5. **Re-run & confirm green** — `gh run rerun` as needed; confirm the pipeline passes for the env.
6. **Record** — note the incident/fix and any escalation on the relevant Jira ticket.

## Boundaries

Fix pipeline/infra only, through the gated flow. Product code defects go to **Maintenance**, not
here. Respect the permission boundaries in `docs/standards/devops-standards.md`.
