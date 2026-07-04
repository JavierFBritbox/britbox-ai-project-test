---
name: developer-implement
description: >-
  Use when a code ticket (Jira Story/Sub-task) is ready to build. Implements one ticket end to end —
  non-interactive and test-first — then opens a PR and moves it to In Review; never merges to main.
  Trigger: "implement ticket <KEY>", "develop <KEY>", "pick up the next ticket".
---

# developer-implement

The Developer role's end-to-end implementation loop for a single ticket.

## Steps

1. **Config guard** — read `config/atlassian.json`; if Jira is `unconfigured`/`TBD`, only proceed
   with a locally provided spec and flag the gap.
2. **Check nothing is in flight** — single developer, serial consumption. If a prior Developer PR
   is still open (not merged), **stop** and report the pipeline is waiting on Reviewer/QA. Only one
   branch/PR at a time.
3. **Select one ticket** — the given `<KEY>`, else the highest-priority unblocked **To Do**
   Story/Sub-task under the active feature Epic (dependencies Done), respecting sequencing.
4. **Claim** — `jira-gate`: move the Sub-task **To Do → In Progress**. If its parent **Story** is
   still **To Do**, move the Story → **In Progress** too (and set `INDEX.md` status → `In Development`
   the first time any Sub-task of the feature starts).
5. **Gather context** — read the ticket, `docs/features/<slug>/tech-design.md`, `architecture.md`,
   `requirement.md`, the target module's `CLAUDE.md`, and `docs/standards/coding-standards.md`.
6. **Branch** — from fresh `main`: `git switch -c <JIRA-KEY>-<kebab-summary>`.
7. **Implement test-first (TDD)** — in the target `apps/<module>`/`packages/<lib>`, matching existing
   style/stack. For each behavior from the acceptance criteria: write a failing test (**RED**, watch
   it fail for the right reason), write minimal code to pass (**GREEN**), then **REFACTOR** while
   green. Clean, secure, efficient (standards doc). Consult official library/framework docs when
   unsure. Cover happy/edge/error paths; tests deterministic; meet the coverage bar.
8. **Verify locally** — via `verify-before-done`: run tests, lint, format, type checks, dependency
   audit, and a secret scan of the diff; read the output. Iterate until all green; never proceed on
   failure or claim done without fresh evidence.
9. **Commit** — conventional commit(s) referencing the Jira key; run `scripts/secret-scan.sh` on the
   staged diff first (must be clean).
10. **PR** — `gh pr create` from the branch to `main`; body = what/why, how tested, acceptance-criteria
    checklist. Add the PR link to the Jira ticket.
11. **Hand off** — move ticket **In Progress → In Review**. Do **not** merge — Reviewer/QA gate it.

## Boundaries

Never modify `.github/workflows/` or `infra/` — those belong to DevOps. If the ticket needs a
pipeline or infrastructure change, **invoke the DevOps role** to do it and depend on that, rather
than editing those files here.

## If blocked

If the ticket cannot be implemented as specified (ambiguous spec, missing dependency, conflicts with
design), move it to **Blocked** with a precise reason and stop. Do not redesign or expand scope.

## Definition of Done

All boxes in `docs/standards/coding-standards.md` → Definition of Done. Verify before claiming done.
