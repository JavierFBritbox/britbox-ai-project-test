---
name: devops-assess
description: >-
  First step of the DevOps role. Reads a signed-off requirement + agreed architecture and — for
  feature iterations — checks whether the EXISTING infra (infra/) and pipeline (.github/workflows/)
  already cover the need. Decides: fully covered (no change), partial (design the delta), or not
  covered (new setup). Trigger: "assess devops", "does infra cover this", "devops assess <slug>".
---

# devops-assess

Keeps deployment work proportional: if the existing infrastructure and CI/CD already cover the
requirement/architecture, there's nothing to build.

## Steps

1. Read `docs/features/<slug>/requirement.md` and `architecture.md`. If either is missing or the
   architecture isn't `Agreed`, stop and report.
2. **Coverage check.** Read existing `infra/`, `.github/workflows/`, and prior `devops.md` files.
   Compare what the architecture requires (components, environments, integrations) against what
   already exists.
3. Decide and record:
   - **Fully covered** → "No infra/pipeline change required" + rationale; hand off.
   - **Partial** → design only the **delta** in `devops-design`.
   - **Not covered / greenfield** → full setup in `devops-design`.

## Gate

Track with `jira-gate` (Task) once Jira is configured; if unconfigured/`TBD`, proceed locally and
flag the pending ticket.
