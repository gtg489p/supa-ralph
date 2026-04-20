You are in build mode.

You are running in a fresh Claude process.
You do not remember prior iterations unless the information is written to disk.
Everything that matters is on disk.

Your job is to implement the next most important planned increment from `.supa-ralph/IMPLEMENTATION_PLAN.md`.

## Orientation first

0a. Study `tasks/*.md` to understand the required behavior.
0b. Study `specs/*.md` if they exist.
0c. Study `.supa-ralph/IMPLEMENTATION_PLAN.md`.
0d. Study `.supa-ralph/progress.txt` and `.supa-ralph/AGENTS.md` for reusable learnings and run commands.
0e. Search the real codebase before changing anything. Do not assume a missing feature is missing.

## What to do

1. Choose the highest-value unfinished increment from `.supa-ralph/IMPLEMENTATION_PLAN.md`.
2. Verify it is not already implemented.
3. Implement that increment fully.
4. Run the appropriate checks for the touched area.
5. Update `.supa-ralph/IMPLEMENTATION_PLAN.md` with what changed and what remains.
6. Append reusable learnings to `.supa-ralph/progress.txt`.
7. If you discover stable operational knowledge, update `.supa-ralph/AGENTS.md` briefly.
8. If checks pass, commit and push the work.

## Commit contract

Resolve the commit-message prefix using this ladder, stopping at the first hit:

1. If the environment variable `SUPA_RALPH_COMMIT_PREFIX` is set, use that value verbatim.
2. Else if `.supa-ralph/config` exists and defines a `commit_prefix=<value>` line, use that value.
3. Else default to `feat(ralph):` for feature increments or `fix(ralph):` for bug fixes.

Append the completed increment summary after the prefix, for example:

`feat(ralph): <completed increment summary>`

If the resolved prefix is already scoped (e.g., `chore(auth):`), use it directly without adding another scope.

## Guardrails

999. One meaningful increment per iteration.
9999. No placeholders if the real implementation is feasible.
99999. Keep `AGENTS.md` operational and brief. Status belongs in the plan and progress log.
999999. If unrelated tests are already failing, either fix them if they block your increment or document them clearly in the plan.
9999999. When authoring or editing documentation, capture the *why* — the problem or constraint behind the change — not only the outcome.
99999999. Prefer the strongest reasoning available for architecture and debugging, and use parallel subagents or parallel reads/searches when the environment supports them.
999999999. Keep `.supa-ralph/IMPLEMENTATION_PLAN.md` current. Remove completed clutter when it becomes noisy.
9999999999. Use `git push` after a successful commit so the work is externally visible.
99999999999. Only make the last non-empty line `<promise>COMPLETE</promise>` when all genuinely pending work for this feature is done and checks pass.
