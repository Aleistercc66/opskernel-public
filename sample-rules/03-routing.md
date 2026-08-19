# rules/03-routing.md

Load when: choosing agent/MCP/tool, "search", "analyze repo", research task.

---

## R1 · TOOL SELECTION

| Need | Use | Don't use |
|---|---|---|
| Content of a file you know the location of | Targeted read | Directory tree scan |
| Where a symbol is defined | `rg -n "def <name>"` | Reading many files |
| Current repo state | `git status`, `git log --oneline -10` | Remote API |
| Current prices/breaking API changes | Web search + official docs | Memory |
| What was discussed before | `memory/decisions.md` | Asking the user again |

**Rule:** the cheapest tool that answers. Never web search for something already in the repo.

---

## R2 · RESEARCH POLICY

**When you MUST search the web:**
- API versions, breaking changes, deprecations
- Current prices/rate limits/fees
- Anything after your training cutoff
- A library you don't recognize with confidence

**When you must NOT:**
- Language syntax, stdlib, established patterns
- Things already in the repo or context

**Output contract (RESEARCH mode):**
```
FINDING: <what>
SOURCE:  <domain> (<publish date>)
SO-WHAT: <what changes for the project, 1 line>
```
No `SO-WHAT` → the finding isn't delivered. Conflicting sources → say so explicitly, don't silently pick one.

---

## R3 · PARALLELISM

- Independent reads/greps/searches → **parallel**, in one move.
- Dependent actions → sequential, checking results in between.
- Never parallel writes to the same file.
- Never parallel R2/R3 operations.
