#!/usr/bin/env bash
# next-version.sh — compute the next SemVer per docs/process/versioning.md.
# Deterministic version math lives here so release skills invoke it instead of
# reasoning about version strings in prose.
#
# Usage:   scripts/next-version.sh <bump> [current]
#   bump = story    Story complete → minor bump, start RC:   0.2.3      → 0.3.0-rc.1
#          rc       another fix on an in-flight RC:          0.3.0-rc.1 → 0.3.0-rc.2
#          patch    released-version bug fix → patch RC:     0.3.0      → 0.3.1-rc.1
#          promote  QA signed off → drop the -rc suffix:     0.3.0-rc.2 → 0.3.0
#   current defaults to the contents of ./VERSION
#
# Prints the new version (without a leading "v") to stdout; exits non-zero on bad input.
set -euo pipefail

bump="${1:-}"
current="${2:-$(cat VERSION 2>/dev/null || echo 0.0.0)}"
current="${current#v}"

# Split into core (X.Y.Z) and optional -rc.N
core="${current%%-*}"
rc=""
[[ "$current" == *-rc.* ]] && rc="${current##*-rc.}"
IFS=. read -r major minor patch <<<"$core"
: "${major:=0}" "${minor:=0}" "${patch:=0}"

case "$bump" in
  story)   echo "${major}.$((minor + 1)).0-rc.1" ;;
  patch)   echo "${major}.${minor}.$((patch + 1))-rc.1" ;;
  rc)
    [[ -n "$rc" ]] || { echo "error: current version '$current' is not an -rc" >&2; exit 1; }
    echo "${core}-rc.$((rc + 1))" ;;
  promote)
    [[ -n "$rc" ]] || { echo "error: current version '$current' is not an -rc to promote" >&2; exit 1; }
    echo "${core}" ;;
  *) echo "usage: $0 <story|rc|patch|promote> [current]" >&2; exit 2 ;;
esac
