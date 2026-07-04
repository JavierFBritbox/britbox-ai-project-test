<!--
  TECHNICAL DESIGN & WORK-BREAKDOWN TEMPLATE
  ----------------------------------------------------------------------------
  Produced by the Tech Lead role from a signed-off requirement + agreed
  architecture, through an interactive, repo-local session with the human tech
  lead. It defines HOW the requirement becomes code (structure, interfaces, data
  models) and decomposes the work into code tickets (Stories + Sub-tasks).

  On sign-off this becomes docs/features/<slug>/tech-design.md, the code tickets
  are created in Jira under the feature Epic, and the work is handed to the
  (non-interactive) Developer role. HTML comments are guidance, stripped on conversion.
-->

# Technical Design: <Feature / System Name>

## 1. Metadata

| Field | Value |
|---|---|
| Feature slug | `<kebab-case-slug>` |
| Requirement | `docs/features/<slug>/requirement.md` |
| Architecture | `docs/features/<slug>/architecture.md` |
| Tech lead (human) | <name> |
| Created / Updated | <YYYY-MM-DD> / <YYYY-MM-DD> |
| Status | `Draft` <!-- Draft → In Review → Agreed --> |
| Jira feature Epic | <KEY-100> |

## 2. Coverage / Delta Decision

<!-- For feature iterations: does the existing code structure already accommodate this? -->
- **Existing code coverage:** `<Fully / Partial / Not covered>`
- **Scope of change:** 
- **Rationale:** 

## 3. Technical Approach

<!-- How the requirement + architecture translate into code. The overall plan. -->

## 4. Module & Package Structure

<!-- Which apps/<module> and packages/* are touched/created, and their tech stack. -->
| Path | New/Existing | Language / framework | Responsibility |
|---|---|---|---|
| `apps/<module>` |  |  |  |
| `packages/<lib>` |  |  |  |

## 5. Component Design

<!-- Components, responsibilities, and boundaries within each module. -->

## 6. Interfaces & Contracts

<!-- Public APIs, events, message schemas, function/service contracts. -->

## 7. Data Models

<!-- Entities, fields, relationships, and how they map to storage from architecture.md. -->

## 8. Key Technical Decisions

<!-- Libraries, patterns, conventions chosen and why (ADR-style). -->
| Decision | Options | Choice | Rationale |
|---|---|---|---|

## 9. Testing Strategy

<!-- Unit/integration/e2e split, coverage expectations, what QA will verify against
     the requirement's acceptance criteria. -->

## 10. Work Breakdown → Code Tickets

<!-- This section becomes the Jira tickets on sign-off: Stories (increments) under the
     feature Epic, each split into Sub-tasks (individual dev units). Every Sub-task must be
     self-contained enough for a non-interactive Developer to implement from it alone. -->
| Story | Sub-task | Target path | Description | Acceptance criteria | Depends on |
|---|---|---|---|---|---|
| S1: <increment> | ST1.1 | `apps/<module>/…` |  |  | — |
|  | ST1.2 |  |  |  | ST1.1 |

## 11. Sequencing & Dependencies

<!-- Order of work, parallelizable vs blocked items, cross-module dependencies. -->

## 12. Risks & Assumptions

- **Assumption:** 
- **Risk / mitigation:** 

## 13. Impact on Existing Code (delta)

<!-- What changes, what is reused, what is refactored/removed. "N/A — greenfield" if new. -->

## 14. Open Questions

| # | Question | Raised by | Answer | Status |
|---|---|---|---|---|
| Q-1 |  |  |  | Open |

## 15. Agreement / Sign-Off

<!-- Set Status to "Agreed" only when the human tech lead signs off. This gates ticket
     creation and the Developer role. -->
| Party | Name | Decision | Date |
|---|---|---|---|
| Human tech lead |  | ☐ Agreed |  |
| Tech Lead role (AI) | product-pipeline | ☐ Agreed |  |
