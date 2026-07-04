<!--
  DEVOPS / DEPLOYMENT DOCUMENT TEMPLATE
  ----------------------------------------------------------------------------
  Produced by the DevOps role from a signed-off requirement + agreed architecture,
  through an interactive, repo-local session with the human DevOps engineer.
  On sign-off this becomes docs/features/<slug>/devops.md, and the role emits the
  actual Terraform (infra/) and GitHub Actions (.github/workflows/).

  ENFORCED (docs/standards/devops-standards.md): CI/CD = GitHub Actions only;
  Infrastructure = AWS via Terraform only; environments/secrets/variables defined in
  GitHub Environments; auth via GitHub OIDC → AWS IAM (no long-lived keys); three
  mandatory environments test/stage/prod with prod behind manual approval; promotion
  path test → stage → prod. HTML comments are guidance and stripped on conversion.
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

## 3. Environments & AWS Accounts (test / stage / prod — all mandatory)

| Environment | AWS account | Region(s) | GitHub Environment | Deploy |
|---|---|---|---|---|
| test |  |  | `test` (RC target; QA) | auto on RC tag |
| stage |  |  | `stage` (pre-prod) | auto on promotion |
| prod |  |  | `prod` (protection + reviewers) | **manual approval** |

## 4. Deployment Strategy & Rules

<!-- Promotion path is fixed: test → stage → prod. Fill in the specifics. -->
- Branch/trigger model: 
- Approvals / protection rules (prod requires manual approval): 
- Promotion path: `test → stage → prod`
- Rollback: 

## 5. Terraform Plan

<!-- Map each architecture component (architecture.md §6) to Terraform resources. -->
| Architecture component | Terraform resource / module | Notes |
|---|---|---|
|  |  |  |

- **State backend:** <S3 bucket + DynamoDB lock table, per-env keys>
- **Module layout:** <infra/modules/*, infra/envs/{test,stage,prod}>
- **Variables / tfvars:** <per-env, secrets excluded from VCS>

## 6. GitHub Actions Workflows

<!-- One row per workflow; define triggers, jobs, and gates. -->
| Workflow | Trigger | Jobs / steps | Environment gates |
|---|---|---|---|
| ci |  | lint, test, build |  |
| terraform-plan | PR | fmt, validate, plan (comment) |  |
| terraform-apply | merge/tag | apply |  environment approval |
| deploy |  |  |  |

## 7. GitHub Environments, Secrets & Variables (required)

<!-- ENFORCED: environments, secrets, and variables are defined as GitHub Environments
     (env-scoped) and consumed by workflows. Auth via OIDC → AWS IAM role per env; NO
     long-lived AWS keys; NO secret values in repo/Terraform/YAML. -->
| GitHub Environment | Protection rules | Variables (non-secret) | Secrets | OIDC IAM role (per env) |
|---|---|---|---|---|
| test |  |  |  |  |
| stage |  |  |  |  |
| prod | required reviewers / manual approval |  |  |  |

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
