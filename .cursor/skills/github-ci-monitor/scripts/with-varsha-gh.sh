#!/usr/bin/env bash
# Run one command with project-local Varsha GH_TOKEN.
# Usage: .cursor/skills/github-ci-monitor/scripts/with-varsha-gh.sh <cmd...>

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../../.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT/.cursor/skills/github-ci-monitor/scripts/activate-varsha-gh.sh" >/dev/null
exec "$@"
