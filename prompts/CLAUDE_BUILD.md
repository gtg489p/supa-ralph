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
0f. Check the current git branch. If you are on `main`, `master`, or `trunk`, derive a slug from the most recent `tasks/prd-*.md` filename (drop the `prd-` prefix and `.md` suffix) and create or check out `feature/<slug>` before making changes. If already on a non-default branch, record its name in `.supa-ralph/progress.txt` so later iterations stay on the same branch. Why: build iterations produce commits; running them on the default branch silently rewrites trunk and surprises reviewers.

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
99999999. Match the model to the task. Use Sonnet for parallel searches, file reads, and mechanical edits; reserve Opus (or the strongest available reasoning model) for architectural decisions, non-obvious debugging, and anything where wrong answers are expensive. Run parallel subagents for independent reads and searches, but keep writes, commits, and pushes serial so state stays coherent. Prefer the strongest reasoning only where it materially changes the outcome — otherwise the cheaper model is the right tool.
999999999. Keep `.supa-ralph/IMPLEMENTATION_PLAN.md` current. Remove completed clutter when it becomes noisy.
9999999999. Use `git push` after a successful commit so the work is externally visible.
99999999999. Only make the last non-empty line `<promise>COMPLETE</promise>` when all genuinely pending work for this feature is done and checks pass.
