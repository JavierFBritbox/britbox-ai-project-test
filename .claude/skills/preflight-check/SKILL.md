---
name: preflight-check
description: >-
  Shared readiness check every role runs before using an external tool. Verifies the required CLIs
  are installed, authenticated/configured, and that the relevant config files and secret env vars
  are set. For anything missing, STOPS and prompts the user with the exact install/configure step —
  never guesses or proceeds. Atlassian (Confluence + Jira) is provided by project-init; all other
  tools (Qase, gh, AWS, Terraform, runtimes) are prompted just-in-time here. Trigger: any role about
  to use a tool/credential, "preflight", "check my tools".
---

# preflight-check

The single place that turns "tool not set up" into a clear, actionable prompt instead of a failure.

## Rule

Before a role uses any external tool or credential, verify it is ready. If not, **stop and prompt
the user** with the precise remediation, then wait. Do not proceed, fake, or guess.

- **The Superpowers plugin is a hard prerequisite** for this environment — check it first; if it's
  not installed/enabled, stop and give the install command before doing anything else.
- **Atlassian (Confluence + Jira)** is set up once by the **`project-init`** skill and recorded in
  `config/atlassian.json`. If it's still `unconfigured`/`TBD`, tell the user to run `project-init`.
- **Every other tool is prompted just-in-time** by the role that needs it (below).

## Checks (run only those the current task needs)

| Tool / credential | Check | If missing, prompt the user to… |
|---|---|---|
| **Superpowers plugin** (required, all roles) | plugin installed/enabled (e.g. its skills are available, or `grep -q superpowers ~/.claude/plugins/installed_plugins.json`) | **stop** and prompt: `/plugin install superpowers@claude-plugins-official` (or the `/plugin` menu) — this environment requires it |
| `git` | `command -v git` | install git |
| GitHub CLI `gh` | `command -v gh` && `gh auth status` | install `gh` and run `gh auth login` |
| AWS CLI | `command -v aws` && `aws sts get-caller-identity` | install AWS CLI and configure credentials (`aws configure` / SSO) |
| AWS **OIDC role** (DevOps deploys) | the per-env OIDC IAM role exists / is assumable | **request a human DevOps engineer** to set up the OIDC role — the AI must not create it. Missing IAM permissions → request **Platform Engineering** |
| Terraform | `command -v terraform` && `terraform version` | install Terraform |
| Language runtimes | `node -v` / `python --version` / etc. per module | install the module's runtime + package manager |
| Atlassian | `config/atlassian.json` status ≠ `unconfigured`, no `TBD` | run `project-init` (creates/records Confluence + Jira) |
| Qase | `config/qase.json` status ≠ `unconfigured`; token env var (`tokenEnvVar`) is non-empty | set the Qase `projectCode` and `export QASE_API_TOKEN=…` |

- Never print secret values (tokens/keys); only check that they are set (non-empty).
- Interactive roles ask the user in-session; the non-interactive Developer emits a clear blocking
  message naming exactly what to install/configure, then stops.

## Output

- All required tools ready → return "preflight OK" and continue.
- Anything missing → a concise checklist of what to install/configure (with the exact command),
  and stop until it's resolved.
