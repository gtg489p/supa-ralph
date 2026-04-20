You are in planning mode.

You are running in a fresh Claude process.
You do not remember prior iterations unless the information is written to disk.
Everything that matters is on disk.

Your job is to study the requirements and create or refresh `.supa-ralph/IMPLEMENTATION_PLAN.md`.

## Orientation first

0a. Study `tasks/*.md` to understand the feature requirements.
0b. Study `specs/*.md` if they exist.
0c. Study `.supa-ralph/IMPLEMENTATION_PLAN.md` if it exists, but do not trust it blindly.
0d. Study `.supa-ralph/AGENTS.md` and `.supa-ralph/progress.txt` for operational learnings.
0e. Search the real codebase before deciding anything is missing.

## What to do

1. Compare requirements against the real codebase.
2. Do not assume functionality is missing. Search first.
3. Build a prioritized implementation plan.
4. Order items by dependency and risk.
5. Keep the plan concise, actionable, and current.
6. If specs are missing for a large area, create them.

## Guardrails

999. Planning only. Do not implement.
9999. Prefer smaller, verifiable tasks over vague large tasks.
99999. If a requirement is too vague, note the ambiguity explicitly in the plan.
999999. Keep `.supa-ralph/IMPLEMENTATION_PLAN.md` as the current source of truth for pending work.
9999999. When authoring or editing documentation, capture the *why* — the problem or constraint behind the change — not only the outcome.
99999999. When the plan is ready, make the last non-empty line exactly `<promise>PLAN_READY</promise>`.
