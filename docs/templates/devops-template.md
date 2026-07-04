<!--
  DEVOPS / DEPLOYMENT DOCUMENT TEMPLATE
  ----------------------------------------------------------------------------
  Produced by the DevOps role from a signed-off requirement + agreed architecture,
  through an interactive, repo-local session with the human DevOps engineer.
  On sign-off this becomes docs/features/<slug>/devops.md, and the role emits the
  actual Terraform (infra/) and GitHub Actions (.github/workflows/).

  Target cloud: AWS. Deployment: Terraform + GitHub Actions. Prefer OIDC over
  long-lived credentials. HTML comments are guidance and stripped on conversion.
-->

# DevOps / Deployment: <Feature / System Name>

## 1. Metadata

| Field | Value |
|---|---|
| Feature slug | `<kebab-case-slug>` |
| Requirement | `docs/features/<slug>/requirement.md` |
| Architecture | `docs/features/<slug>/architecture.md` |
| DevOps engineer (human) | <name> |
| Created / Updated | <YYYY-MM-DD> / <YYYY-MM-DD> |
| Status | `Draft` <!-- Draft → In Review → Agreed --> |
| Jira task | <KEY-123> |

## 2. Coverage / Delta Decision

<!-- For feature iterations: does the existing infra + pipeline already cover this? -->
- **Existing infra/pipeline coverage:** `<Fully covered / Partial / Not covered>`
- **Scope of change:** 
- **Rationale:** 

## 3. Environments & AWS Accounts

| Environment | AWS account | Region(s) | Purpose | Auto/manual deploy |
|---|---|---|---|---|
| dev |  |  |  |  |
| staging |  |  |  |  |
| prod |  |  |  |  |

## 4. Deployment Strategy & Rules

<!-- Branching model, what triggers a deploy, required approvals/reviewers,
     promotion path dev→staging→prod, rollback strategy, change windows. -->
- Branch/trigger model: 
- Approvals / protection rules: 
- Promotion path: 
- Rollback: 

## 5. Terraform Plan

<!-- Map each architecture component (architecture.md §6) to Terraform resources. -->
| Architecture component | Terraform resource / module | Notes |
|---|---|---|
|  |  |  |

- **State backend:** <S3 bucket + DynamoDB lock table, per-env keys>
- **Module layout:** <infra/modules/*, infra/envs/{dev,staging,prod}>
- **Variables / tfvars:** <per-env, secrets excluded from VCS>

## 6. GitHub Actions Workflows

<!-- One row per workflow; define triggers, jobs, and gates. -->
| Workflow | Trigger | Jobs / steps | Environment gates |
|---|---|---|---|
| ci |  | lint, test, build |  |
| terraform-plan | PR | fmt, validate, plan (comment) |  |
| terraform-apply | merge/tag | apply |  environment approval |
| deploy |  |  |  |

## 7. Secrets & Credential Management

<!-- Prefer GitHub OIDC → AWS IAM role assumption; no long-lived AWS keys. -->
| Secret / credential | Stored in | Consumed by |
|---|---|---|
| AWS access (OIDC role ARN) | GitHub environment / vars | Actions |

## 8. Observability & Deployment Gates

<!-- Smoke tests, health checks, canary, deployment metrics/alarms, failure rollback. -->

## 9. Cost & Tagging

<!-- Tagging policy, budgets/alerts, cost-impacting resources. -->

## 10. Risks & Assumptions

- **Assumption:** 
- **Risk / mitigation:** 

## 11. Impact on Existing Infra (delta)

<!-- What infra/workflows change, what is reused, what is migrated/decommissioned.
     "N/A — greenfield" if new. -->

## 12. Open Questions

| # | Question | Raised by | Answer | Status |
|---|---|---|---|---|
| Q-1 |  |  |  | Open |

## 13. Agreement / Sign-Off

<!-- Set Status to "Agreed" only when the human DevOps engineer signs off. This
     gates generation of infra/ and .github/workflows/. -->
| Party | Name | Decision | Date |
|---|---|---|---|
| Human DevOps engineer |  | ☐ Agreed |  |
| DevOps role (AI) | product-pipeline | ☐ Agreed |  |
