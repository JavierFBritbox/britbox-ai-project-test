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

## The Iron Law

```
NO FIX WITHOUT ROOT-CAUSE INVESTIGATION FIRST
```

A symptom fix is a failure. You may not propose or hand off a fix until root cause is confirmed with
evidence. "Under time pressure" and "it looks obvious" are exactly when this matters most.

## Four phases (complete each before the next)

**Phase 1 — Read the evidence.** Read error messages, stack traces, logs *completely* — note exact
line numbers, files, codes. They often contain the answer.

**Phase 2 — Reproduce consistently** against the **released version**: check out the affected tag
(`vX.Y.Z`) and/or exercise the deployed prod/stage environment. Establish exact steps; note if
intermittent. If you can't reproduce → gather more data, don't guess.

**Phase 3 — Check recent changes.** `git log`/diff since the last good version, new dependencies,
config/environment differences — what changed that could cause this?

**Phase 4 — Instrument boundaries (multi-component systems).** For each component boundary (API →
service → DB, CI → build → deploy), log what data enters/exits and verify config propagation. Run
once to show *where* it breaks, then investigate that component.

**Phase 5 — Confirm root cause.** Form a hypothesis and test it against the evidence until confirmed
(not just plausible). Assess blast radius / regression risk and severity.

**Phase 6 — Write the diagnosis** into the intake doc (§6): reproduced?/where, confirmed root cause,
affected files/components, suggested fix approach, and regression risk. This is the Developer's
Bug-ticket context — and it must specify the **regression test** that has to go RED before the fix.

**Phase 7 — Hand off.** Return to `maintenance-triage` to create/attach the **Bug** ticket for the
Developer. Do **not** implement the fix here.

## Boundary

Diagnose only. Fixes go through Developer → Code Reviewer → Release Manager (patch) → QA, preserving
author/review separation and the gated, versioned flow.
