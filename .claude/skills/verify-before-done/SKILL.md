---
name: verify-before-done
description: >-
  Shared discipline every role runs before claiming work complete, fixed, passing, or ready — and
  before committing, merging, tagging, or creating a PR. Requires running the actual verification
  command and reading its output first. Evidence before claims, always. Trigger: about to say
  "done"/"fixed"/"passes"/"ready", or before any commit/PR/merge/tag/promote.
---

# verify-before-done

The single "evidence before claims" gate used across the pipeline (Developer, Code Reviewer, DevOps,
QA, Release Manager, Maintenance). This is the project-local adoption of the Superpowers
`verification-before-completion` skill (required plugin) — invoke that for the general discipline.

## The Iron Law

```
NO COMPLETION CLAIM WITHOUT FRESH VERIFICATION EVIDENCE
```

If you have not run the verifying command *in this session* and read its output, you cannot claim it
passes. Confidence is not evidence.

## Gate function

Before claiming any status or expressing satisfaction:

1. **Identify** the command that proves the claim.
2. **Run** it fresh and in full.
3. **Read** the full output — exit code, failure count.
4. **Verify** the output actually confirms the claim.
5. **Only then** state the claim, *with* the evidence.

Skipping a step is claiming without proof.

## What each claim requires (not sufficient: "should", "looks right", a previous run)

| Claim | Requires |
|---|---|
| Tests pass | Test command output: 0 failures, this run |
| Lint/format/type clean | Each tool's output: 0 errors |
| Build/`terraform validate` succeeds | Command exit 0 |
| Bug fixed | The original symptom test now passes (and failed before the fix — RED→GREEN) |
| Deploy/pipeline green | `gh run` shows success for the target env |
| Requirement/acceptance met | Line-by-line checklist against acceptance criteria |
| Subagent/role "done" | The actual artifact/diff/ticket state, not a "success" report |

## Red flags — stop and verify

"should", "probably", "seems to"; saying "Done/Perfect/Great" before running the check; about to
commit/push/PR/merge/tag without evidence; trusting a report instead of the artifact; "just this
once"; being tired. Different wording does not exempt the rule — spirit over letter.
