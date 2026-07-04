# Roles

Each role is implemented as a Claude Code **agent** in `.claude/agents/` and performs its work
through reusable **skills** in `.claude/skills/`. Roles are human-in-the-loop: they collaborate
with a human counterpart and only advance the pipeline at explicit gates.

| Role | Agent | Purpose | Human gate | Output artifact |
|---|---|---|---|---|
| **Product** | `product` | Requirement lifecycle in Confluence; review & sign-off | Human marks doc "Signed Off" | `docs/features/<slug>/requirement.md` |
| **Architect** | _(planned)_ | Decide if architecture is needed; design AWS solution | Human architect agreement | `docs/features/<slug>/architecture.md` |
| **DevOps** | _(planned)_ | Terraform + GitHub Actions from requirement + architecture | Human agrees deploy rules/envs/account | `infra/`, `.github/workflows/`, `docs/features/<slug>/devops.md` |

More roles (Dev, QA/Test, Reviewer, Release, …) will be added here as they are defined.

See the pipeline overview and conventions in the repo `README.md`.
