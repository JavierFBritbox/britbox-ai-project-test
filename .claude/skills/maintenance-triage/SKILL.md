---
name: maintenance-triage
description: >-
  Post-release intake and routing. Captures a bug report / change request using the maintenance
  intake template, classifies it (defect / small enhancement / new capability), assesses severity,
  and routes it to the correct pipeline entry point (Developer for fixes, Tech Lead for
  enhancements, Product for new capabilities), creating the appropriate Jira ticket(s). Trigger:
  "triage bug", "new bug report", "change request", "maintenance triage".
---

# maintenance-triage

The front door for anything arriving after release. Decides *what kind* of work it is and *where*
it re-enters the pipeline.

## Steps

1. **Preflight & guard** — `preflight-check` (git, `gh`, Atlassian); read `config/atlassian.json`.
   Prompt for anything missing.
2. **Intake** — capture the report in `docs/templates/maintenance-intake-template.md`: source,
   affected version/env, description, expected vs actual, any repro steps, initial severity.
3. **For suspected defects → `maintenance-debug`** to reproduce and root-cause before routing.
4. **Classify:**
   - **Defect** — released behavior is wrong.
   - **Small enhancement** — fits the existing design/architecture.
   - **New capability** — genuinely new scope.
5. **Assess severity/priority** (Critical/High/Medium/Low; scope; workaround).
6. **Route + create tickets** (`jira-gate`):
   - **Defect** → **Bug** ticket with the diagnosis + affected version, linked to the feature/Story
     → hand to **Developer**. Fix ships as a **patch** via Release Manager, then QA re-test.
   - **Enhancement** → hand to **Tech Lead** to add a Story/Sub-task under the feature Epic.
   - **New capability** → route to **Product** to open a new requirement (full pipeline).
7. **Record** the triage decision and links in the intake doc; track the item to closure.

## Boundary

Triage and route only — don't fix, redesign, or change infra here. Delegate to the owning role.
