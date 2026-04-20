# Project Integration

## Install into a project

```bash
./scripts/install-into-project.sh /path/to/project
```

This copies the portable kit into:

```text
<project>/.supa-ralph/
```

## Expected target-project structure after install

```text
project/
├── .supa-ralph/
│   ├── AGENTS.md
│   ├── IMPLEMENTATION_PLAN.md
│   ├── progress.txt
│   ├── prompts/
│   ├── scripts/
│   ├── skills/
│   └── templates/
├── specs/
└── tasks/
```

## Suggested project flow

1. create PRD in `tasks/`
2. create or refine specs in `specs/`
3. run `.supa-ralph/scripts/ralph.sh plan 1`
4. run `.supa-ralph/scripts/ralph.sh build 10`
