#!/usr/bin/env bash
# OpsKernel — PreToolUse hook.
# Blocks destructive Bash commands unless OPSKERNEL_ALLOW_R3=yes is set for that call.
# Wire-up: see ../install.sh output / ../README.md for the settings.json snippet.
set -euo pipefail

INPUT="$(cat)"

# Windows Git Bash gotcha: `python3` on PATH is often the Microsoft Store
# app-execution-alias stub, which prints an install nag and exits nonzero
# instead of running real Python. Probe candidates and use the first that
# actually executes.
PYBIN=""
for c in python3 python py; do
  if command -v "$c" >/dev/null 2>&1 && "$c" -c "print(1)" >/dev/null 2>&1; then
    PYBIN="$c"
    break
  fi
done

if [ -z "$PYBIN" ]; then
  # No usable Python interpreter found — fail OPEN (don't block), but say so.
  echo "OpsKernel guard-destructive: no working Python found, skipping JSON parse (fail-open)." >&2
  exit 0
fi

CMD="$(printf '%s' "$INPUT" | "$PYBIN" -c '
import json,sys
try:
    data = json.load(sys.stdin)
    print(data.get("tool_input", {}).get("command", ""))
except Exception:
    print("")
' 2>/dev/null || true)"

if [ -z "$CMD" ]; then
  exit 0
fi

PATTERNS=(
  'rm[[:space:]]+-rf'
  'Remove-Item[[:space:]]+-Recurse[[:space:]]+-Force'
  'git[[:space:]]+push[[:space:]]+--force'
  'git[[:space:]]+reset[[:space:]]+--hard'
  'git[[:space:]]+branch[[:space:]]+-D'
  'DROP[[:space:]]+TABLE'
  'TRUNCATE[[:space:]]+TABLE'
  'del[[:space:]]+/s'
  '>[[:space:]]*/dev/sd[a-z]'
)

for pat in "${PATTERNS[@]}"; do
  if printf '%s' "$CMD" | grep -Eiq "$pat"; then
    if [ "${OPSKERNEL_ALLOW_R3:-}" = "yes" ]; then
      exit 0
    fi
    {
      echo "OpsKernel BLOCKED a destructive command (pattern: $pat)."
      echo "Command: $CMD"
      echo "If this is intentional and the user explicitly confirmed it, re-run with OPSKERNEL_ALLOW_R3=yes."
    } >&2
    exit 2
  fi
done

exit 0
