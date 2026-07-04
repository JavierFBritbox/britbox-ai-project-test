---
name: maintenance-debug
description: >-
  Reproduces a suspected defect against the released version, isolates the root cause, and produces a
  diagnosis (root cause, affected components, suggested fix approach, regression risk) for the fix
  ticket. Diagnoses only — the Developer implements the fix through the normal gated flow. Trigger:
  "debug <issue>", "reproduce the bug", "root cause <KEY>", "maintenance debug".
---

# maintenance-debug

Deep diagnosis for a defect. Produces the evidence and root cause the Developer needs — it does
**not** fix the code.

## Steps

1. **Preflight & guard** — `preflight-check` (git; plus deploy-env/log access if needed). 
2. **Reproduce** against the **released version**: check out the affected tag (`vX.Y.Z`) and/or
   exercise the deployed prod/staging environment. Gather evidence (logs, inputs, stack traces,
   failing conditions). Note if intermittent.
3. **Isolate root cause** — read the relevant code, trace the path, bisect across versions/commits
   if useful, form and test a hypothesis until the cause is confirmed.
4. **Assess** blast radius / regression risk and severity.
5. **Write the diagnosis** into the intake doc (§6): reproduced?/where, root cause, affected
   files/components, a suggested fix approach, and regression risk. This becomes the Developer's
   Bug-ticket context.
6. **Hand off** — return to `maintenance-triage` to create/attach the **Bug** ticket for the
   Developer. Do **not** implement the fix here.

## Boundary

Diagnose only. Fixes go through Developer → Code Reviewer → Release Manager (patch) → QA, preserving
author/review separation and the gated, versioned flow.
