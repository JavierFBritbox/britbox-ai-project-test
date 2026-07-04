# Coding Standards

The quality bar every code change must meet. The **Developer** role writes to these standards; the
**Reviewer** and **QA** roles verify against them. They are deliberately concrete so a
non-interactive Developer can self-check before opening a PR. Module-specific conventions (in a
module's own `CLAUDE.md`) refine — never lower — this bar.

## Definition of Done (a ticket is not done until all hold)

- [ ] Implements the ticket's description and satisfies **every acceptance criterion**.
- [ ] Unit tests cover the new/changed behavior (happy path + edge + error cases) and pass.
- [ ] Lint, format, and type checks pass for the module.
- [ ] No secrets, credentials, or PII in code, tests, logs, or fixtures.
- [ ] Security checklist below reviewed; dependency audit clean (or risks noted).
- [ ] Code reads like the surrounding code; no dead code, no debug leftovers.
- [ ] PR opened from a feature branch, linked to the Jira ticket, with testing evidence.

## Clean code

- Match the existing style, naming, and structure of the module you're editing.
- Small, single-responsibility functions and modules; clear names over comments.
- No duplicated logic — extract shared code into `packages/` where it belongs.
- Comment the *why*, not the *what*; match the file's existing comment density.
- Delete dead/commented-out code; no leftover `TODO` without a linked ticket.

## Secure code

- **Validate and sanitize all external input** (API params, user data, file contents, env).
- **Never hardcode secrets** — read from config/env/secrets manager; keep them out of VCS and logs.
- Output-encode/escape to prevent injection (SQL/NoSQL, command, XSS, template).
- Enforce **least privilege** (IAM roles, DB users, tokens); no broad wildcards.
- Use parameterized queries / safe APIs; never build queries by string concatenation.
- Keep dependencies current; run the ecosystem audit (`npm audit`, `pip-audit`, etc.) and address
  high/critical findings or document why deferred.
- Handle errors without leaking stack traces or sensitive detail to callers.

## Efficient code

- Choose appropriate data structures and algorithms; avoid needless O(n²) and N+1 queries.
- Don't load more than needed (pagination, projections, streaming for large data).
- Cache/memoize only where it pays off and correctness is preserved.
- Avoid premature optimization — measure before tuning; keep it readable.

## Testing

### Test-Driven Development (required method)

Write the test **first**, watch it fail, then write minimal code to pass. RED → GREEN → REFACTOR.

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

- **RED** — write one minimal test for the next behavior (from the ticket's acceptance criteria);
  run it and **confirm it fails for the right reason**. A test you didn't watch fail proves nothing.
- **GREEN** — write the minimal code to make it pass; run and confirm all green.
- **REFACTOR** — clean up while staying green.
- **Bug fixes** — first write a regression test that reproduces the bug (RED), then fix (GREEN); this
  proves both the bug and the fix.
- Exceptions (throwaway prototypes, generated code, pure config) require the human's agreement.
  "Skip TDD just this once" is a rationalization — don't.

### Test quality

- **Unit tests are mandatory** for new/changed logic. Use the module's standard framework.
- Structure tests Arrange–Act–Assert; one behavior per test; descriptive names.
- Cover happy path, boundaries, and error/failure paths. Derive cases from acceptance criteria.
- Tests must be **deterministic** (no real network/time/randomness — mock or inject).
- Target **≥ 80% coverage of new/changed code** (module `CLAUDE.md` may set higher).
- Add integration tests where a unit test can't meaningfully exercise the behavior.

## Error handling & observability

- Fail fast with clear, typed errors; don't swallow exceptions.
- Log at appropriate levels with structured context — **never** log secrets or PII.
- Surface actionable messages; map internal errors to safe external responses.

## Commits & PRs

- Conventional commits: `type(scope): summary` (e.g. `feat(api): add title search`), referencing
  the Jira key.
- One ticket per branch/PR; keep PRs focused and reviewable.
- PR description: what changed, why, how it was tested, and the acceptance-criteria checklist.
