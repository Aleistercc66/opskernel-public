#!/usr/bin/env bash
# Installs just the free guard-destructive hook into ~/.claude/hooks/.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_HOME:-$HOME/.claude}/hooks"

mkdir -p "$DEST"
cp "$SRC/hooks/guard-destructive.sh" "$DEST/guard-destructive.sh"
chmod +x "$DEST/guard-destructive.sh"

echo "Installed to $DEST/guard-destructive.sh"
echo
echo "Add this to ~/.claude/settings.json under \"hooks\" (merge with anything already there):"
echo
cat <<'JSON'
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "bash ~/.claude/hooks/guard-destructive.sh" }
        ]
      }
    ]
  }
}
JSON
