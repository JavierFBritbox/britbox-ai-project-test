---
name: architect-design
description: >-
  Core of the Architect role. Drafts an AWS solution architecture for a requirement using the
  architecture template, then iterates with the human architect (trade-offs, alternatives, open
  questions) until Status is "Agreed". Consults official AWS docs before making service choices.
  Trigger: "design architecture", "architect design <slug>", "draft the AWS design".
---

# architect-design

Designs the AWS solution and drives it to human agreement.

## Steps

1. Read `config/atlassian.json` (guard: stop if unconfigured/`TBD`) and the requirement +
   the assess decision.
2. Draft `docs/features/<slug>/architecture.md` from
   `docs/templates/architecture-template.md`. Fill every section; use `mermaid` for the diagram.
3. **Ground service choices in official docs** — use the AWS skills (`aws-core`,
   `aws-serverless`, `aws-cdk`, `aws-messaging-and-streaming`, `aws-observability`, …) and the AWS
   documentation MCP (`aws___search_documentation`, `aws___read_documentation`) for limits, best
   practices, and service capabilities. Prefer managed/serverless unless a requirement dictates
   otherwise.
4. Cover the quality bar: security (IAM, encryption, network, secrets, PII/GDPR),
   scalability/availability, observability, cost, and alternatives considered (ADR table).
5. **Iterate with the human architect** (human gate): surface open questions and trade-offs,
   incorporate answers, revise. Publish/update the draft on the Confluence Architecture page for
   visibility if configured. Do **not** set Status to "Agreed" yourself.
6. When the human confirms and open questions are resolved, hand to `architect-signoff-to-md`.

## Guard & gate

Configuration guard as above. Track design + revisions with `jira-gate` (Task).
