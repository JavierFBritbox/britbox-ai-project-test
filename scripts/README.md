# scripts/

Shared helper scripts. Mechanical, deterministic operations live here so roles **invoke** them
rather than re-describing the logic in prose (per the writing-skills principle: automate what's
enforceable, reserve documentation for judgment).

| Script | Purpose | Used by |
|---|---|---|
| `next-version.sh <story\|rc\|patch\|promote> [current]` | Compute the next SemVer per `docs/process/versioning.md`. Defaults `current` to `./VERSION`. | Release Manager (`release-cut-rc`, `release-promote`) |
| `secret-scan.sh [file …]` | Scan the staged diff (or given files) for likely secrets; non-zero exit if found. | Developer, Code Reviewer, `jira-gate` (pre-commit) |

Examples:
```
scripts/next-version.sh story 0.2.3     # -> 0.3.0-rc.1
scripts/next-version.sh promote 0.3.0-rc.2  # -> 0.3.0
scripts/secret-scan.sh                    # scans git diff --cached
```
