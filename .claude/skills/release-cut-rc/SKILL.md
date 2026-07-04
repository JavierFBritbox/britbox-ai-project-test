---
name: release-cut-rc
description: >-
  Cuts a release-candidate version when a Story completes (or after a QA bug fix merges). Computes
  the next RC per SemVer, updates VERSION + CHANGELOG, tags main and pushes (triggering the test-env
  deploy), moves the Story to Testing, and hands to QA. Trigger: "cut RC", "cut release candidate",
  "story complete <slug>", "release-cut-rc".
---

# release-cut-rc

Produces the versioned RC that QA will test. Follows `docs/process/versioning.md`.

## Steps

1. **Config guard** — read `config/atlassian.json`; if Jira `unconfigured`/`TBD`, do the local
   version work and flag pending transitions.
2. **Confirm the trigger** — either the Code Reviewer signalled a Story's last Sub-task merged, or a
   QA bug fix for the current RC has merged. Ensure `main` is green.
3. **Compute the next version:**
   - New Story → minor bump, `-rc.1` (e.g. `0.2.3 → 0.3.0-rc.1`).
   - Additional fix on an in-flight RC → increment `-rc.N` (e.g. `0.3.0-rc.1 → 0.3.0-rc.2`).
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
