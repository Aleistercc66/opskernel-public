Drafts for you to review/edit before anything goes live. Nothing here has been posted.

---

## Show HN

**Title:** Show HN: A PreToolUse hook that actually blocks rm -rf in Claude Code

**Body:**
```
I kept seeing "AI agent safety" advice that's just a markdown file telling
the model to be careful. That's a suggestion, not a control — under enough
context pressure the model can still run something destructive.

So I wrote an actual PreToolUse hook for Claude Code: it inspects every
Bash command before it runs and blocks a fixed set of destructive patterns
(rm -rf, git push --force, git reset --hard, DROP TABLE, ...) unless you
explicitly override it.

Free, MIT-licensed, one bash script, no dependencies beyond a working
Python interpreter (which caught a real bug during testing: python3 on
Windows PATH is often the Microsoft Store stub, not real Python — the
script now probes for a working interpreter and fails open with a warning
instead of silently doing nothing).

Repo: <link>

Honest caveats in the README — it's pattern-matching, not a sandbox, and it
only covers the Bash tool.
```

---

## r/ClaudeAI

**Title:** I gave Claude Code an actual kill switch (free hook, not another rules.md)

**Body:**
```
Most "make your agent safer" posts here are prompt text. Prompts are
requests, not controls — the model can still be talked into or drift into
running something you didn't want under enough pressure.

I built a PreToolUse hook instead: it runs before every Bash command and
blocks a set of destructive patterns (rm -rf, force-push, hard reset, DROP
TABLE, etc.) unless you explicitly set an override env var for that call.
Enforcement, not a suggestion.

Free repo + install script: <link>

Tested on macOS/Linux/WSL/Windows Git Bash. Found and fixed one real bug in
testing (Windows python3 PATH stub) before posting this, in case anyone's
curious what that looks like.

Happy to answer questions about the hook mechanics or Claude Code's hook
system in general.
```

---

## Notes for you before posting

- Both drafts are written in first person as if you built and tested this —
  adjust anything that doesn't sound like you.
- r/ClaudeAI and HN both dislike anything that reads as an ad. Neither draft
  mentions the paid kernel — that's deliberate, it's in the repo README as a
  soft mention, not the pitch. Keep it that way in any edits.
- Check subreddit rules for self-promo/account-age requirements before
  posting — I can't check your account status there.
- Post from your own accounts; I don't have login access to Reddit or HN.
