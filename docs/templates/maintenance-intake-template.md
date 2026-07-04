<!--
  MAINTENANCE INTAKE TEMPLATE
  ----------------------------------------------------------------------------
  Used by the Maintenance/Debugger role to capture a post-release bug report or
  change request consistently before triage. HTML comments are guidance.
-->

# Maintenance Intake: <short title>

## 1. Report

| Field | Value |
|---|---|
| Type (initial guess) | `<Bug / Change request / Unclear>` |
| Reported by | <name / source> |
| Date | <YYYY-MM-DD> |
| Affected version | <vX.Y.Z released, or "unknown"> |
| Environment | `<prod / staging>` |
| Related feature/slug | <docs/features/<slug>, if known> |
| Source | `<user report / Jira Bug KEY / Qase defect ID / monitoring alert>` |

## 2. Description

<!-- What happened, in the reporter's words. -->

## 3. Expected vs Actual

- **Expected:** 
- **Actual:** 

## 4. Reproduction steps

<!-- Exact steps; note if intermittent. Filled/confirmed during debug. -->
1. 

## 5. Impact & severity

| Field | Value |
|---|---|
| Severity | `<Critical / High / Medium / Low>` |
| Users/scope affected |  |
| Workaround available? |  |

## 6. Diagnosis (filled by maintenance-debug for defects)

- **Reproduced?** `<Yes/No>` on `<version/env>`
- **Root cause:** 
- **Affected components/files:** 
- **Suggested fix approach:** 
- **Regression risk / blast radius:** 

## 7. Triage decision & routing

| Field | Value |
|---|---|
| Classification | `<Defect / Small enhancement / New capability>` |
| Route to | `<Developer (fix ticket) / Tech Lead (enhancement ticket) / Product (new requirement)>` |
| Ticket(s) created | <Jira keys> |
| Target version | `<patch vX.Y.Z / next RC / new minor>` |
