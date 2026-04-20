# Supa Ralph Operating Model

## The purpose

Supa Ralph is not just "run Claude in a loop".
It is a disciplined feature-delivery funnel:

1. idea
2. clarifying questions
3. PRD
4. specs
5. implementation plan
6. iterative build loop

## Three phases

### Phase 1, discovery
Translate the user's free-form idea into a real PRD.

Artifacts:
- `tasks/prd-<feature>.md`
- optionally `specs/*.md`

### Phase 2, planning
Do gap analysis between requirements and the codebase.
Create or update `.supa-ralph/IMPLEMENTATION_PLAN.md`.

### Phase 3, building
Implement one meaningful increment at a time.
Run checks.
Commit.
Update plan and progress.
Repeat until done.

## High-value rules

- Ask only the questions needed to make the PRD real.
- Prefer multiple smaller stories over one giant story.
- Order work by dependency, backend before dependent UI.
- Do not assume something is missing, search first.
- Do not leave `IMPLEMENTATION_PLAN.md` stale.
- Keep `AGENTS.md` short and operational.
- Put status and discoveries in `.supa-ralph/progress.txt` and `.supa-ralph/IMPLEMENTATION_PLAN.md`.
- A build iteration should finish one coherent increment, not half-implement five things.

## When to create specs

Create `specs/*.md` when the feature naturally splits into distinct topics of concern, for example:
- permissions
- API surface
- dashboard UI
- reporting
- synchronization

If the feature is small, the PRD may be enough.
If the feature is large, specs are strongly preferred.
