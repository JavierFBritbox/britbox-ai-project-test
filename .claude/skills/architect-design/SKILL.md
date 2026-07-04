---
name: architect-design
description: >-
  Use when a signed-off requirement needs an AWS solution designed. Runs the interactive, repo-local
  architecture interview with the human architect until they sign off (producing architecture.md).
  Trigger: "design architecture", "start architecture", "architect design <slug>".
---

# architect-design

The interactive, repo-local design loop. This is where the architecture step is triggered.

## How it works (interactive, in the repo)

This runs in a local Claude session with the human architect present. It is a conversation, not a
Confluence workflow. You propose; the architect decides; you revise; repeat until sign-off.

## Steps

1. Read the signed-off `docs/features/<slug>/requirement.md`. If missing/unsigned, stop and report.
2. **Coverage check (esp. for feature iterations):** read existing `docs/features/*/architecture.md`
   and the current `apps/`, `packages/`, `infra/`. Determine whether the **existing architecture
   already covers this requirement's needs**.
   - Fully covered → say so, record "No architecture change required", and hand off (no new design).
   - Partially covered → design only the **delta**.
   - Not covered → design new architecture.
   (The `architect-assess` skill formalizes this decision; call it first if not already done.)
3. Draft/extend a working design (`docs/features/<slug>/architecture.draft.md`) from
   `docs/templates/architecture-template.md`, Status `Draft`.
4. **Propose what the app needs** — infrastructure, AWS services, technologies, components, data,
   integrations — grounded in the requirement. Use `mermaid` for the diagram.
5. **Ground service choices in official docs** — AWS skills (`aws-core`, `aws-serverless`,
   `aws-cdk`, `aws-messaging-and-streaming`, `aws-observability`, …) and the AWS documentation MCP
   (`aws___search_documentation`, `aws___read_documentation`). Don't invent capabilities.
6. **Interview the human architect:** present proposals, trade-offs, and open questions; ask what
   they think should be added or changed; capture answers; revise the draft. Cover the quality bar
   (security/IAM/PII, scalability/availability, observability, cost, ADR alternatives). Loop until
   the architect is satisfied.
7. When the architect confirms and open questions are resolved, hand to `architect-signoff-to-md`.
   **Do not self-sign-off** — that is the human's decision.

## Gate

Track design + revisions with `jira-gate` (Task) once Jira is configured. If Jira is still
`unconfigured`/`TBD`, proceed with the local design but flag that the ticket is pending.
