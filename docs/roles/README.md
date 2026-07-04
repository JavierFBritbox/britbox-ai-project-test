# Roles

Each role is implemented as a Claude Code **agent** in `.claude/agents/` and performs its work
through reusable **skills** in `.claude/skills/`. Roles are human-in-the-loop: they collaborate
with a human counterpart and only advance the pipeline at explicit gates.

| Role | Agent | Purpose | Human gate | Output artifact |
|---|---|---|---|---|
| **Product** | `product` | Requirement lifecycle in Confluence; review & sign-off | Human marks doc "Signed Off" | `docs/features/<slug>/requirement.md` |
| **Architect** | `architect` | Decide if architecture is needed; design AWS solution | Human architect agreement | `docs/features/<slug>/architecture.md` |
| **DevOps** | `devops` | Terraform + GitHub Actions from requirement + architecture (repo-local, interactive) | Human agrees deploy rules/envs/account | `infra/`, `.github/workflows/`, `docs/features/<slug>/devops.md` |
| **Tech Lead** | `tech-lead` | Translate requirement+architecture into code design; break work into code tickets (repo-local, interactive) | Human tech lead signs off design + breakdown | `docs/features/<slug>/tech-design.md` + Jira Stories/Sub-tasks |
| **Developer** | `developer` | Consume one code ticket → implement (clean/secure/efficient + unit tests) → open PR (**non-interactive**) | Reviewer approves the PR merge | `apps/<module>/` code + PR per ticket |
| **Code Reviewer** | `code-reviewer` | Independent review of each Sub-task PR vs coding standards; approve → squash-merge | — (is the gate) | PR approval / change requests |
| **Release Manager** | `release-manager` | On Story completion, cut RC version, changelog, promote on QA pass, trigger deploy | — (owns versioning) | git tags, `CHANGELOG.md`, `VERSION` |
| **QA** | `qa` | Test the deployed RC vs acceptance criteria **using Qase**; file bug tickets; sign off the version | QA sign-off promotes the release | Qase runs, Bug tickets |
| **Maintenance/Debugger** | `maintenance` | Post-release front door: intake, reproduce/root-cause, classify, route back into the pipeline | — (routes to owning role) | intake docs, Bug tickets, diagnoses |

More roles (Docs, …) will be added here as they are defined.

The Developer, Code Reviewer, and QA hold code to `docs/standards/coding-standards.md`.
Versioning/branching is defined in `docs/process/versioning.md`.

## Interactivity

- **Interactive (repo-local, human-gated):** Architect, DevOps, Tech Lead. A human runs Claude in
  the repo, iterates with the role, and signs off.
- **Confluence-based:** Product (product team authors in Confluence).
- **Non-interactive:** Developer — executes a fully-specified ticket and opens a PR; humans/roles
  gate the merge, not the authoring.

See the pipeline overview and conventions in the repo `README.md`.
