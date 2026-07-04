---
name: release-cut-rc
description: >-
  Use when a Story completes, an in-flight RC gets a fix, or a released version needs a bug-fix
  patch — and a new version must be cut for QA. Cuts the next RC, tags main (triggering the test-env
  deploy), and hands to QA. Trigger: "cut RC", "story complete <slug>", "release-cut-rc".
---

# release-cut-rc

Produces the versioned RC that QA will test. Follows `docs/process/versioning.md`.

## Steps

1. **Config guard** — read `config/atlassian.json`; if Jira `unconfigured`/`TBD`, do the local
   version work and flag pending transitions.
2. **Confirm the trigger** and pick the bump — ensure `main` is green:
   - Code Reviewer signalled a Story's last Sub-task merged → `story`.
   - A fix for the current in-flight RC merged → `rc`.
   - A QA-reported bug fix on an already-**released** version (from Maintenance) → `patch`.
3. **Compute the next version** with the shared script (deterministic, per versioning.md):
   `scripts/next-version.sh <story|rc|patch>` → e.g. `0.2.3 →(story) 0.3.0-rc.1`,
   `0.3.0-rc.1 →(rc) 0.3.0-rc.2`, `0.3.0 →(patch) 0.3.1-rc.1`.
4. **Update files** — write the new version to `VERSION` and relevant manifests; add/extend the
   `CHANGELOG.md` entry (version, today's date, the Stories/tickets included). Commit these to `main`.
5. **Tag & push** — `git tag vX.Y.0-rc.N` and push the tag. This fires the DevOps deploy workflow to
   the **test/staging** environment.
6. **Verify** the deploy workflow started (`gh run list`); report status.
7. **Transition** — `jira-gate`: move the **Story** → **Testing**.
8. **Update `docs/features/INDEX.md`** — status → `Testing (RC)`, record the version and date.
9. **Hand off** — notify **QA** (`qa-test-run`) that `vX.Y.0-rc.N` is deployed and ready to test.

## Gate

Track with `jira-gate` (Task). Only tag commits that passed review + CI.
