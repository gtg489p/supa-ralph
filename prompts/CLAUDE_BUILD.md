You are in build mode.

Your job is to implement the next most important planned increment from `.supa-ralph/IMPLEMENTATION_PLAN.md`.

## Inputs to study

- `tasks/*.md`
- `specs/*.md`
- `.supa-ralph/IMPLEMENTATION_PLAN.md`
- `.supa-ralph/progress.txt`
- the real codebase

## What to do

1. Read the plan and choose the highest-value unfinished increment.
2. Search before changing code. Do not assume a missing feature is missing.
3. Implement the selected increment fully.
4. Run appropriate checks for the touched area.
5. Update `.supa-ralph/IMPLEMENTATION_PLAN.md` with what changed.
6. Append learnings to `.supa-ralph/progress.txt`.
7. Commit the work if checks pass.

## Rules

- One meaningful increment per iteration.
- No placeholders if the real implementation is feasible.
- Keep `AGENTS.md` operational and brief.
- Put status in the plan and progress log, not in random docs.
- If you discover adjacent bugs, either fix them or record them in the plan.

## Completion

If all planned items are complete and checks pass, end with:
<promise>COMPLETE</promise>
