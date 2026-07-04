# `config/` — Integration configuration

This folder holds the shared configuration that every AI role/skill reads. **No Atlassian
identifiers are hardcoded anywhere else in the repo** — they all come from here.

## `atlassian.json`

Single source of truth for the Confluence space and Jira project this project is wired to.

While `"status": "unconfigured"` (or any value is still `"TBD"`), integration skills will
**refuse to make live Confluence/Jira calls** and instead tell you what to configure. This lets
every role be authored and tested before Atlassian is available.

### How to configure it (one-time, when you have permission)

1. Create the Confluence **space** and Jira **project** in the Atlassian UI
   (see the recommended setup in the project guide, `docs/GUIDE.md`).
2. Run the **`project-init`** skill. It will:
   - read the space/project keys you provide,
   - look up and fill in the Confluence `spaceId` / `productPageId`,
   - look up and fill in the Jira `issueTypes` and `transitions` IDs,
   - create the Confluence page structure and upload the requirement template,
   - flip `"status"` to `"configured"`.

You can also fill the values in by hand if you prefer.

### Fields

| Field | Meaning |
|---|---|
| `cloudId` | Atlassian cloud ID for `britbox.atlassian.net` (already known). |
| `confluence.spaceKey` / `spaceId` | The dedicated space for this project. |
| `confluence.productPageId` | Page ID of the top-level **Product** page that the Product role scans. |
| `confluence.architecturePageId` | Page ID of the **Architecture** page/folder where agreed architectures are published and linked to their requirement. |
| `confluence.devopsPageId` | Page ID of the **DevOps** page/folder where agreed deployment designs are published and linked to their architecture/requirement. |
| `jira.projectKey` / `projectId` | The dedicated Jira project. |
| `jira.issueTypes.*` | Numeric IDs of each issue type (needed to create issues via API). |
| `jira.transitions.*` | Transition IDs used to move a ticket To Do → In Progress → In Review → Testing → Done. |
