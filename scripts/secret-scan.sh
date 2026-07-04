#!/usr/bin/env bash
# secret-scan.sh — scan for likely secrets before a commit/PR.
# Mechanical guard invoked by roles (Developer, Code Reviewer, jira-gate) instead of
# re-describing the grep in prose. Exits non-zero if anything suspicious is found.
#
# Usage:  scripts/secret-scan.sh [file ...]
#   With no args, scans the staged diff (git diff --cached).
set -euo pipefail

# Real assignments (KEY=abc123), private key headers, and long AWS-style keys.
pattern='(AWS_)?(SECRET|ACCESS)?_?KEY[[:space:]]*=[[:space:]]*[A-Za-z0-9/+]{8,}|(TOKEN|SECRET|PASSWORD|PASSWD|API_KEY)[[:space:]]*=[[:space:]]*[^[:space:]]{6,}|-----BEGIN[[:space:]].*PRIVATE KEY-----|AKIA[0-9A-Z]{16}'

hits=""
if [[ $# -gt 0 ]]; then
  hits="$(grep -HInERo "$pattern" "$@" 2>/dev/null || true)"
else
  hits="$(git diff --cached -U0 | grep -nE "^\+" | grep -EIo "$pattern" || true)"
fi

if [[ -n "$hits" ]]; then
  echo "POTENTIAL SECRETS FOUND — do not commit:" >&2
  echo "$hits" >&2
  echo "Move secrets to env vars / a secret manager (see docs/standards/*). " >&2
  exit 1
fi
echo "secret-scan: clean"
