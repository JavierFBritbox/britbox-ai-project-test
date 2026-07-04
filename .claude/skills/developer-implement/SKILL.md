---
name: developer-implement
description: >-
  Implements ONE code ticket end to end (non-interactive). Claims a Jira Story/Sub-task (To Do →
  In Progress), creates a feature branch, implements it in the target module to the repo coding
  standards with mandatory unit tests, verifies locally (tests/lint/type/audit/secret-scan), commits
  and opens a PR, then moves the ticket to In Review. Never merges to main. Trigger: "implement
  ticket <KEY>", "develop <KEY>", "pick up the next ticket".
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
5. **Claim** — `jira-gate`: move **To Do → In Progress**.
6. **Gather context** — read the ticket, `docs/features/<slug>/tech-design.md`, `architecture.md`,
   `requirement.md`, the target module's `CLAUDE.md`, and `docs/standards/coding-standards.md`.
7. **Branch** — from fresh `main`: `git switch -c <JIRA-KEY>-<kebab-summary>`.
8. **Implement** — in the target `apps/<module>`/`packages/<lib>`, matching existing style/stack.
   Clean, secure, efficient (standards doc). Consult official library/framework docs when unsure.
9. **Unit tests** — cover happy/edge/error paths from the acceptance criteria; deterministic; meet
   the coverage bar.
10. **Verify locally** — run tests, lint, format, type checks, dependency audit, and a secret scan of
    the diff. Iterate until all green; never proceed on failure.
11. **Commit** — conventional commit(s) referencing the Jira key; scan staged files for secrets first.
12. **PR** — `gh pr create` from the branch to `main`; body = what/why, how tested, acceptance-criteria
    checklist. Add the PR link to the Jira ticket.
13. **Hand off** — move ticket **In Progress → In Review**. Do **not** merge — Reviewer/QA gate it.

## If blocked

If the ticket cannot be implemented as specified (ambiguous spec, missing dependency, conflicts with
design), move it to **Blocked** with a precise reason and stop. Do not redesign or expand scope.

## Definition of Done

All boxes in `docs/standards/coding-standards.md` → Definition of Done. Verify before claiming done.
