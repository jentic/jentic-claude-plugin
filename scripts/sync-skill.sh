#!/usr/bin/env bash
#
# Update the onboarding skill from an upstream copy.
#
# The onboard-jentic-one skill is maintained upstream and re-packaged here as a
# Claude Code plugin skill. Point this at a local copy of the upstream markdown
# to refresh it so the two do not drift.
#
# Usage:
#   UPSTREAM_SKILL=/path/to/onboard-jentic-one.md scripts/sync-skill.sh
set -euo pipefail

DEST="$(cd "$(dirname "$0")/.." && pwd)/skills/onboard-jentic-one/SKILL.md"

if [[ -z "${UPSTREAM_SKILL:-}" ]]; then
  echo "Set UPSTREAM_SKILL to the path of the upstream onboard-jentic-one markdown." >&2
  echo "  UPSTREAM_SKILL=/path/to/onboard-jentic-one.md scripts/sync-skill.sh" >&2
  exit 1
fi

echo "Updating from ${UPSTREAM_SKILL}"
cp "${UPSTREAM_SKILL}" "${DEST}"

echo "Updated ${DEST}"
echo "Review the diff and commit if it changed:"
echo "  git diff -- skills/onboard-jentic-one/SKILL.md"
