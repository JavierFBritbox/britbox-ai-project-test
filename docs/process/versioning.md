# Versioning & Branching Strategy

How code flows to `main`, how versions are cut, and who owns them. This is authoritative for the
Developer, Code Reviewer, QA, and Release Manager roles.

## Branching model — trunk-based

`main` is always releasable. There are **no** long-lived `develop`/`release` branches — with a
single, serial AI Developer they add cost and no benefit.

- **Feature branch per Sub-task:** `<JIRA-KEY>-<kebab-summary>`, cut from fresh `main`.
- **One branch/PR in flight at a time** (serial Developer). The next Sub-task starts only after the
  previous PR merges.
- **PR → `main`** after the Code Reviewer approves. Merge unblocks the next ticket.

## Versioning — SemVer, tags on `main`

Versions are git tags on `main`, following `vMAJOR.MINOR.PATCH`.

| Event | Bump | Example |
|---|---|---|
| A **Story** completes (all its Sub-tasks merged + reviewed) | **minor** | `0.2.x → 0.3.0` |
| QA-reported **bug fix** on a version | **patch** | `0.3.0 → 0.3.1` |
| First **production** release | major to `1.0.0` | `0.x → 1.0.0` |
| Breaking change post-1.0 | **major** | `1.4.2 → 2.0.0` |

- The version is recorded in the root `VERSION` file, relevant package manifests, and `CHANGELOG.md`.
- Pushing a tag triggers the matching **deploy workflow** (DevOps GitHub Actions) to the right
  environment.

## Release-candidate (RC) flow — the QA loop

A version is **not** the Developer's decision. It is cut on **Story completion** and owned by the
**Release Manager** role.

```
Story's last Sub-task merged (reviewed)
   │  RELEASE MANAGER cuts a release candidate:  vX.Y.0-rc.1   (tag on main)
   │     → deploy workflow ships it to the TEST environment
   ▼
QA tests vX.Y.0-rc.N against the Story's acceptance criteria
   │  issues found → Bug tickets → Developer fixes → merged → RELEASE MANAGER cuts rc.(N+1)
   │  QA passes    → RELEASE MANAGER promotes → vX.Y.0 (drop -rc suffix)
   ▼
vX.Y.0 released → deploy workflow promotes through STAGE → PROD
                   (prod behind manual approval, per DevOps rules)
```

Environments (`test`, `stage`, `prod`) and the promotion path are enforced by
`docs/standards/devops-standards.md`.

## Ownership (who does what)

| Concern | Owner |
|---|---|
| Implement a Sub-task, open PR | **Developer** (never versions/merges) |
| Review & approve/merge the PR | **Code Reviewer** |
| Cut RC on Story completion, changelog, promote, tag, trigger deploy | **Release Manager** |
| Test the RC, file bug tickets, sign off the version | **QA** |

## Jira status mapping

- **Sub-task:** To Do → In Progress (dev) → In Review (PR review) → Done (on merge).
- **Story:** In Progress (while Sub-tasks build) → Testing (RC cut, QA testing) → Done (QA passed,
  version promoted).
- **Bug (QA-found):** To Do → In Progress → In Review → Done, shipped in the next `-rc` / patch.
