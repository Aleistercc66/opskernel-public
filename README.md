# OpsKernel guard-destructive — a free PreToolUse hook for Claude Code

I gave my coding agent a kill switch.

Most "AI agent rules" advice is a markdown file you paste in and hope the
model reads under pressure. This is a hook — Claude Code actually calls it
before every Bash command, and it blocks the dangerous ones instead of
asking nicely.

```json
{"tool_input":{"command":"rm -rf /some/path"}}
```
```
OpsKernel BLOCKED a destructive command (pattern: rm[[:space:]]+-rf).
Command: rm -rf /some/path
If this is intentional and the user explicitly confirmed it, re-run with OPSKERNEL_ALLOW_R3=yes.
```

Blocks by default: `rm -rf`, `Remove-Item -Recurse -Force`, `git push --force`,
`git reset --hard`, `git branch -D`, `DROP TABLE`, `TRUNCATE TABLE`, `del /s`,
writes to raw block devices. Override per-call with `OPSKERNEL_ALLOW_R3=yes`
once you've actually confirmed the action.

Tested on macOS, Linux, WSL, and Windows Git Bash (the Windows test caught a
real bug: `python3` on Windows PATH is often the Microsoft Store
app-execution-alias stub, not real Python — the script now probes for a
working interpreter and fails open with a warning if it can't find one).

## Install (30 seconds)

```bash
git clone <repo-url> && cd opskernel-public
./install-hook.sh
```

Then add the printed JSON snippet to `~/.claude/settings.json` under `hooks`
(merge it with whatever's already there — this script won't touch your
existing config).

## Honest limitations

- Pattern-matching, not a sandbox. A determined rewrite of the same command
  can slip past it. It's a seatbelt, not a cage.
- Only guards the `Bash` tool. Other tools aren't covered by this hook.
- Fails open if it can't find a working Python on your machine — see the
  "Windows gotcha" note above.

## What's next

This hook is one piece of a fuller operating kernel for Claude Code
(response-mode selection, risk-tiered gating, epistemic tagging on claims,
session continuity) — `sample-rules/03-routing.md` in this repo is one
module from it. The complete kernel is a separate paid download:
**https://gerasimos7.gumroad.com/l/kmnicl** ($29/€29 one-time).

## License

MIT — this hook and the sample rule file. Do whatever you want with them.
