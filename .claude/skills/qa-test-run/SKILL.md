---
name: qa-test-run
description: >-
  Use when a release candidate has been deployed and needs testing. Tests the RC against the Story's
  acceptance criteria using Qase, files defects (Qase + linked Jira Bug) for failures, and signs off
  the RC on a green run. Trigger: "test RC", "qa test <version>", "run QA for <slug>", "qa-test-run".
---

# qa-test-run

Executes and records a QA cycle for one RC via Qase.

## Steps

1. **Config guard** — read `config/qase.json` + `config/atlassian.json`; verify the Qase token env
   var is set. If anything is `unconfigured`/`TBD`/unset, stop and say what to configure. Never print
   the token.
2. **Confirm the RC** — `vX.Y.0-rc.N` is deployed to the test/staging environment (from the Release
   Manager). Know the environment URL/endpoint to exercise.
3. **Test cases (Qase API)** — ensure cases exist for each acceptance criterion of the Story
   (create/update under the project suite); keep them traceable to the requirement + ticket.
4. **Create test run (Qase API)** — for `vX.Y.0-rc.N`, including the relevant cases.
5. **Execute** — run the automated suite against the deployed env; perform manual checks where
   needed. Record each result (pass/fail + evidence) against the Qase run.
6. **Failures** — per failure: create a Qase **defect** and a linked Jira **Bug** (`jira-gate`) with
   repro, expected/actual, severity, and the RC version. Keep the Story in **Testing**; the fix flows
   back through Developer → Reviewer → Release Manager (`release-cut-rc` → next `-rc`) → re-test.
7. **Sign-off** — when all results pass, complete the Qase run and record an explicit sign-off for
   **this exact RC**. Notify the **Release Manager** (`release-promote`).

## Notes

- Test against acceptance criteria, not implementation detail.
- A new RC always gets a **new** Qase run; never reuse a prior run's sign-off.
