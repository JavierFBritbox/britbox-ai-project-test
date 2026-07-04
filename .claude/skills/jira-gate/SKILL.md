---
name: jira-gate
description: >-
  Mandatory gate every role must call before mutating anything (Terraform, GitHub config,
  GitHub Actions, code, Confluence content, committed artifacts). Ensures a Jira ticket exists
  and is moved through the workflow: open (To Do) → In Progress before work starts → In
  Review/Testing during verification → Done only after the change is verified. Trigger: any
  time a role is about to make a change, or "open a ticket", "gate this change".
---

# jira-gate

The single enforcement point for the rule: **no change without a tracked ticket.**

## Rule

Before an AI role performs any state-changing action it MUST:

1. **Ensure a ticket exists.** Reuse a linked ticket if the work already has one; otherwise
   create it with `createJiraIssue` using the project key and issue-type IDs from
   `config/atlassian.json`.
   - Feature-level work → **Epic** — the **Product role is the authoritative creator** (at
     requirement sign-off); other roles link to that Epic rather than creating their own.
     Requirement/story work → **Story**; technical work (architecture, Terraform, Actions) →
     **Task**; defects → **Bug**.
2. **Move to In Progress** (`transitionJiraIssue` with `transitions.inProgress`) *before* the
   first mutation.
3. **Do the work.**
4. **Move to In Review / Testing** while verifying (`transitions.inReview` / `transitions.testing`).
5. **Move to Done** (`transitions.done`) only after verification succeeds. If blocked, move to
   **Blocked** and report why.

## Configuration guard

Read `config/atlassian.json` first. If `status` is `"unconfigured"` or any needed
`jira.projectKey` / `issueTypes` / `transitions` value is `"TBD"`, **stop** and tell the human
to run `project-init`. Do not attempt Jira calls with placeholder IDs.

## Notes

- Always put the feature slug and a link to the relevant `docs/features/<slug>/` artifact in the
  ticket description so tickets are traceable to repo state.
- Never self-approve a change to Done without evidence it works (tests, plan/apply output, review).
