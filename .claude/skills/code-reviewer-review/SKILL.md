---
name: code-reviewer-review
description: >-
  Reviews and gates one Developer PR (a Sub-task). Confirms CI is green, reviews the diff against
  the coding standards (correctness, security, efficiency, clean code, tests, acceptance criteria),
  posts review comments, then either requests changes (ticket → In Progress) or approves + squash-
  merges (ticket → Done) and, if it was the Story's last Sub-task, signals the Release Manager.
  Trigger: "review PR <#>", "review the developer PR", "code review <KEY>".
---

# code-reviewer-review

Independent PR review + merge gate for a single Sub-task.

## Steps

1. **Config guard** — read `config/atlassian.json`; if Jira `unconfigured`/`TBD`, proceed with the
   PR but flag pending ticket transitions.
2. **Locate** the open PR (`gh pr view`) and its Jira Sub-task; read `tech-design.md` + acceptance
   criteria.
3. **CI check** — confirm required checks pass (`gh pr checks`), reading the output
   (`verify-before-done` — evidence, not "looks green"). If failing → request changes; stop.
4. **Review the diff** (`gh pr diff`) against `docs/standards/coding-standards.md`:
   correctness/acceptance, security (input validation, secrets/PII, injection, least privilege,
   deps), efficiency, clean code, and test adequacy (present, meaningful, deterministic, coverage;
   for a bug fix, a **regression test** that fails without the fix — TDD RED→GREEN).
5. **Post comments** — `gh pr review` with line-anchored, actionable feedback.
6. **Decision:**
   - Problems → `gh pr review --request-changes`; `jira-gate` move Sub-task **In Review → In
     Progress**; hand back to Developer.
   - Clean → `gh pr review --approve`; `gh pr merge --squash --delete-branch`; `jira-gate` move
     Sub-task → **Done**.
7. **Story-completion check** — if all Sub-tasks of the parent Story are Done, signal the **Release
   Manager** (`release-cut-rc`) to cut an RC for the Story.

## Independence

Never approve code you wrote. Review is a separate pass from authoring — this is a hard rule.
