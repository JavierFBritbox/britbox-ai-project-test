---
name: tech-lead-design
description: >-
  Core of the Tech Lead role — the trigger for the technical-design step. Runs an INTERACTIVE,
  repo-local interview with the human tech lead: reads requirement + agreed architecture, checks
  code coverage, and defines module/package structure, component design, interfaces, data models,
  technical decisions, and testing strategy. Then decomposes the work into Stories + Sub-tasks
  (self-contained code tickets). Iterates until the human SIGNS OFF. Trigger: "design tech",
  "technical design", "break down into tickets", "tech-lead design <slug>".
---

# tech-lead-design

The interactive, repo-local design + work-breakdown loop. Where the technical-design step is
triggered. No tickets are created until sign-off (that's `tech-lead-signoff`).

## Steps

1. Read `requirement.md` (signed off) + `architecture.md` (agreed). Run/confirm the
   `tech-lead-assess` coverage decision.
2. Draft/extend `docs/features/<slug>/tech-design.draft.md` from
   `docs/templates/tech-design-template.md` (Status `Draft`).
3. **Design & interview the human tech lead:**
   - **Module/package structure** — which `apps/<module>` and `packages/*` are created/touched and
     their tech stack;
   - **Component design** — responsibilities and boundaries;
   - **Interfaces & contracts** — APIs, events, schemas;
   - **Data models** — entities mapped to the architecture's storage;
   - **Technical decisions** — libraries, patterns, conventions (ADR-style), grounded in official
     docs for non-trivial choices;
   - **Testing strategy** — unit/integration/e2e and what QA verifies vs acceptance criteria.
4. **Work breakdown** — decompose into **Stories** (increments) each split into **Sub-tasks**.
   Each Sub-task must be implementable by a non-interactive Developer from the ticket alone:
   target path, precise description, explicit acceptance criteria, dependencies, and sequencing.
5. Iterate on open questions/trade-offs until the tech lead is satisfied. **Do not self-sign-off.**
6. When the tech lead confirms, hand to `tech-lead-signoff` to finalize, create tickets, and publish.

## Gate

Track with `jira-gate` (Task) once Jira is configured; if unconfigured/`TBD`, proceed locally and
flag the pending ticket.
