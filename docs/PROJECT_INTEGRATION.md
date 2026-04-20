# Project Integration

## Install into a project

```bash
./scripts/install-into-project.sh /path/to/project
```

This copies the portable kit into:

```text
<project>/.supa-ralph/
```

It also:
- creates `tasks/` and `specs/` if needed
- preserves existing live `.supa-ralph/AGENTS.md`, `IMPLEMENTATION_PLAN.md`, and `progress.txt`
- creates `.claude/skills/supa-prd` and `.claude/skills/supa-ralph` symlinks when safe

## Expected target-project structure after install

```text
project/
├── .claude/
│   └── skills/
├── .supa-ralph/
│   ├── AGENTS.md
│   ├── IMPLEMENTATION_PLAN.md
│   ├── NOTICE.md
│   ├── README.md
│   ├── docs/
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
5. inspect `.supa-ralph/scripts/ralph.sh status` between runs when useful
