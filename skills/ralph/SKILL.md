---
name: supa-ralph
description: Convert a PRD into Ralph-ready execution structure and run planning/build loops.
user-invocable: true
---

# Supa Ralph

## Job

1. Study the PRD in `tasks/`.
2. Create or refine `specs/*.md` if the feature needs topic-level breakdown.
3. Create or refresh `.supa-ralph/IMPLEMENTATION_PLAN.md`.
4. Run build loops incrementally until complete.

## Rules

- Plan first, build second.
- Keep implementation plan current.
- One meaningful increment per build iteration.
- Run checks before commit.
