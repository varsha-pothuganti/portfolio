#!/usr/bin/env bash
# Shell-local only — does not change global gh active account.
# Usage (from repo root): source .cursor/skills/github-ci-monitor/scripts/activate-varsha-gh.sh

unset GH_TOKEN GITHUB_TOKEN

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
TOKEN_FILE="$ROOT/.cursor/.gh-token"

if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "Missing $TOKEN_FILE — add varsha-pothuganti PAT first." >&2
  return 1 2>/dev/null || exit 1
fi

export GH_TOKEN="$(tr -d '[:space:]' < "$TOKEN_FILE")"
LOGIN="$(gh api user --jq .login 2>/dev/null || true)"
if [[ "$LOGIN" != "varsha-pothuganti" ]]; then
  echo "Expected varsha-pothuganti, got: ${LOGIN:-<auth failed>}" >&2
  return 1 2>/dev/null || exit 1
fi

echo "Active for this shell: $LOGIN (project token; keyring unchanged)"
