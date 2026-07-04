# DevOps Standards (ENFORCED)

These are **mandatory**, not preferences. The DevOps role must comply; the Code Reviewer/QA and any
review of infra changes verify against them. A DevOps setup that violates any rule below is not
"Agreed" and must not ship.

## Mandatory platform

- **CI/CD: GitHub Actions only.** No other CI system. All build/test/deploy automation lives in
  `.github/workflows/`.
- **Infrastructure: AWS only, provisioned exclusively via Terraform.** No other IaC tool; no manual
  console changes for anything Terraform manages.
- **Environment config lives in GitHub.** Environments, **secrets**, and **variables** are defined as
  **GitHub Environments** (environment-scoped) and consumed by workflows. Secrets/variables are
  **never** committed to the repo, Terraform files, or code.
- **Auth: GitHub OIDC → AWS IAM role assumption**, one role per environment. **No long-lived AWS
  access keys** anywhere — not in the repo, not in GitHub secrets.

## Mandatory environments — all three

DevOps **must** set up a full multi-environment topology. No skipping straight to prod.

| Env | Role | Deploy trigger | Gate |
|---|---|---|---|
| **test** | RC target; QA runs here | RC tag (`vX.Y.0-rc.N`) | automatic |
| **stage** | pre-production; smoke/UAT | on promotion | automatic after test |
| **prod** | production | on promotion | **manual approval** (GitHub Environment protection + required reviewers) |

Each environment has: its **own AWS account** (or a clearly isolated account boundary), its **own
GitHub Environment** (with scoped secrets/variables + protection rules), its **own OIDC IAM role**,
and its **own Terraform state key**. **Promotion path is `test → stage → prod`** — always in order.

## Terraform

- **Remote state:** S3 bucket + DynamoDB lock table, **per-environment** state keys.
- **Layout:** `infra/modules/*` (reusable) and `infra/envs/{test,stage,prod}` (per-env composition).
- Every resource **tagged** with environment + feature/owner, and **traceable** to an architecture
  component (`architecture.md` §6).
- `terraform fmt`/`validate` clean; **plan on PR**, **apply gated** by the environment's approval.

## Required GitHub Actions workflows

- **ci** — lint, test, build on PR.
- **terraform-plan** — `fmt`/`validate`/`plan` on PR, posted as a PR comment.
- **terraform-apply** — apply on merge/tag, per environment; **prod behind manual approval**.
- **deploy** — ship the built artifact to the target environment + smoke test.
- Tag-driven: an RC tag deploys to **test**; a released tag promotes through **stage → prod**.

## Prohibited

- Secrets/keys in the repo, Terraform files, or workflow YAML literals.
- Manual AWS console mutations for Terraform-managed resources.
- Deploying to prod without going through test and stage.
- Long-lived cloud credentials of any kind.

## Human prerequisites & permission boundaries

The AI operates **within** granted cloud permissions — it never creates or escalates its own access.

- **OIDC role setup is a human prerequisite.** The target AWS account usually already has the OIDC
  identity provider / trust entity; a **real (human) DevOps engineer** must create/configure the
  **OIDC IAM role** per environment. The AI is **not permitted** to do this. The DevOps role
  **verifies the OIDC role exists** (preflight) and, if missing, **stops and requests the human
  DevOps engineer** to set it up.
- **Once OIDC is set up**, the roles may create anything **within the permissions that OIDC role
  grants**.
- **New permissions → Platform Engineering (human).** If new infrastructure requires IAM
  permissions or capabilities the OIDC role does not have, the DevOps role must **request the
  Platform Engineering human team** to grant them — documenting *what* permission and *why* — and
  **block until granted**. It must **never** self-escalate, widen its own role, or work around the
  missing permission.

## DevOps Definition of Done

- [ ] `test`, `stage`, `prod` GitHub Environments exist with scoped secrets/variables and protection
      rules; **prod requires approval**.
- [ ] OIDC IAM role per environment; **no static AWS keys**.
- [ ] Terraform `validate`/`plan` clean; remote state backend configured per env.
- [ ] Required workflows present and green; promotion path `test → stage → prod` enforced.
- [ ] `devops.md` documents environments, AWS accounts, deploy rules, promotion path, and rollback.
