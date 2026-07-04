# Feature Registry

One row per feature/epic that has entered the pipeline. Each role updates the row as it produces its
artifact; `Status` reflects the latest stage reached.

| Slug | Title | Status | Requirement | Architecture | DevOps | Tech Design | Docs | Version | Jira Epic | Updated |
|---|---|---|---|---|---|---|---|---|---|---|
| _(none yet)_ | | | | | | | | | | |

**Status values (who sets them):**
`Requirement Signed Off` (Product) → `Architecture Agreed` (Architect) → `Infra Defined` (DevOps) →
`Tickets Created` (Tech Lead) → `In Development` (Developer, on first Sub-task) →
`Testing (RC)` (Release Manager, on RC) → `Released` (Release Manager, on promote) →
`Documented` (Docs).

> Architecture, DevOps, and Tech Design can proceed in parallel from an agreed architecture; `Status`
> tracks the furthest stage reached, not a strict single track.

Each feature's artifacts live in `docs/features/<slug>/`: `requirement.md`,
`architecture.md` (if needed), `devops.md`, `tech-design.md`. Product documentation lives in
`docs/product/<slug>/`.
