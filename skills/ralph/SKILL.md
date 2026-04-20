---
name: supa-ralph
description: Take a PRD into planning and iterative build execution using the Supa Ralph three-phase workflow.
user-invocable: true
---

# Supa Ralph

## The job

1. Study the PRD in `tasks/`.
2. Create or refine `specs/*.md` if the feature needs topic-level breakdown.
3. Create or refresh `.supa-ralph/IMPLEMENTATION_PLAN.md`.
4. Run planning mode first.
5. Run build loops incrementally until complete.

## Core rules

- PRD first, not coding first.
- Plan first, build second.
- Keep implementation plan current.
- One meaningful increment per build iteration.
- Run checks before commit.
- Push after successful commit.
