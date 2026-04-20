---
name: supa-prd
description: Generate a Product Requirements Document from a free-form idea, asking only the clarifying questions needed to make it implementation-ready.
user-invocable: true
---

# Supa PRD

## The job

1. Receive a free-form feature idea.
2. Ask 3 to 5 essential clarifying questions only if needed.
3. Prefer lettered options when that makes response faster.
4. Write `tasks/prd-<feature-name>.md`.
5. If the feature is broad, also create `specs/*.md` topic docs.

## Clarifying-question priorities

Focus on:
- problem and goal
- target user
- scope boundaries
- success criteria
- what is explicitly out of scope

## Output requirements

The PRD should include:
- overview
- goals
- user stories
- functional requirements
- non-goals
- technical considerations
- success criteria
- open questions

## Rules

- Do not implement.
- Make acceptance criteria verifiable.
- Keep user stories small enough for iterative build loops.
- Surface non-goals clearly.
