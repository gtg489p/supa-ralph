---
name: supa-prd
description: Generate a PRD from a free-form idea, asking only the clarifying questions needed to make it implementation-ready.
user-invocable: true
---

# Supa PRD

## Job

1. Receive a free-form feature idea.
2. Ask 3 to 5 essential clarifying questions only when needed.
3. Write `tasks/prd-<feature-name>.md`.
4. If the feature is broad, also create `specs/*.md` topic docs.

## Rules

- Do not implement.
- Make acceptance criteria verifiable.
- Keep user stories small enough for iterative build loops.
- Surface non-goals clearly.
