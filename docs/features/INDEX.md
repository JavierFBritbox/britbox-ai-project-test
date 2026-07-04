# Feature Registry

One row per feature/epic that has entered the pipeline. The Product role adds a row on sign-off;
the Architect and DevOps roles update the artifact columns as they produce them.

| Slug | Title | Status | Requirement | Architecture | DevOps | Jira | Updated |
|---|---|---|---|---|---|---|---|
| _(none yet)_ | | | | | | | |

**Status values:** `Requirement Signed Off` → `Architecture Agreed` → `Infra Defined` →
`In Development` → `Released`.

Each feature's artifacts live in `docs/features/<slug>/`:
`requirement.md`, `architecture.md` (if needed), `devops.md`.
