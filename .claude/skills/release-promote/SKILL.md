---
name: release-promote
description: >-
  Promotes a QA-signed-off release candidate to a real version. Requires an explicit QA sign-off for
  the RC. Drops the -rc suffix (vX.Y.0), finalizes the CHANGELOG, tags main and pushes (triggering
  the production deploy per DevOps rules), and moves the Story to Done. Trigger: "promote release",
  "promote RC", "release-promote", "QA signed off <version>".
---

# release-promote

Turns a QA-approved RC into a released version. Follows `docs/process/versioning.md`.

## Preconditions

- An explicit **QA sign-off** exists for the specific RC (from the QA role / Qase run result).
  Never promote without it.

## Steps

1. **Config guard** — read `config/atlassian.json`; if Jira `unconfigured`/`TBD`, do the local work
   and flag pending transitions.
2. **Verify sign-off** — confirm QA passed the exact `vX.Y.0-rc.N` being promoted. If not, stop.
3. **Compute released version** — `scripts/next-version.sh promote` (drops the `-rc.N` suffix →
   `X.Y.Z`).
4. **Update files** — set `VERSION` and manifests to `X.Y.0`; move the CHANGELOG entry from RC to the
   released version with today's date. Commit to `main`.
5. **Tag & push** — `git tag vX.Y.0` and push. This fires the DevOps deploy workflow to
   **production** per its deploy rules/approvals.
6. **Verify** the prod deploy workflow (`gh run list`); report status and any environment approval
   still required.
7. **Transition** — `jira-gate`: move the **Story** → **Done**.
8. **Update `docs/features/INDEX.md`** — status → `Released`, record the released version and date.
9. **Hand off to Docs** — notify the **Docs role** (`docs-author` → `docs-publish`) to document the
   released feature/version.

## Gate

Track with `jira-gate` (Task). A released tag must correspond to a QA-signed-off RC.
