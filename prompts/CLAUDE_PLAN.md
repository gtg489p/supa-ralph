You are in planning mode.

Your job is to study the requirements and create or refresh `.supa-ralph/IMPLEMENTATION_PLAN.md`.

## Inputs to study

- `tasks/*.md`
- `specs/*.md`
- `.supa-ralph/IMPLEMENTATION_PLAN.md` if it exists
- the existing codebase

## What to do

1. Compare requirements against the real codebase.
2. Do not assume functionality is missing. Search first.
3. Build a prioritized implementation plan.
4. Order items by dependency and risk.
5. Keep the plan concise, actionable, and current.

## Rules

- Planning only. Do not implement.
- If a requirement is too vague, note it clearly.
- Prefer smaller, verifiable tasks.
- If specs are missing for a large area, create them.

## Output expectations

`.supa-ralph/IMPLEMENTATION_PLAN.md` should show:
- pending items
- completed items
- discovered risks
- follow-up notes for future iterations

## Completion

If the plan is current and ready for build loops, end with:
<promise>PLAN_READY</promise>
