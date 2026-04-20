# supa-ralph

Supa Ralph is a portable, PRD-first Ralph kit for Claude Code.

It starts from the solid autonomous loop idea in `snarktank/ralph`, then bakes in stronger operating guidance from the Ralph playbook so a fresh session can:

1. take a free-form feature idea,
2. ask clarifying questions,
3. turn that into a real PRD,
4. derive or refine specs,
5. create an implementation plan,
6. run iterative Claude Code build loops until the work is done.

## What this repo gives you

- a portable `.supa-ralph/` project kit
- a Claude-focused Ralph loop script
- PRD, planning, and building prompt files
- templates for `AGENTS.md`, `IMPLEMENTATION_PLAN.md`, `PRD_TEMPLATE.md`, `progress.txt`, and `specs/`
- installed docs so future sessions can operate from inside the target repo
- project-local Claude skill links for `supa-prd` and `supa-ralph`
- rewritten guidance that preserves the strongest useful ideas without forcing `prd.json` as runtime state

## Canonical trigger phrase

Preferred phrase: **"Use Supa Ralph on this idea."**

Aliases are fine, but this is the canonical name to document and reuse.

## Core operating model

Supa Ralph follows a three-stage flow:

1. **Discovery / PRD**
   - take the raw idea
   - ask 3 to 5 essential questions if needed
   - write `tasks/prd-<feature>.md`

2. **Planning**
   - study PRD plus any `specs/*`
   - compare requirements against the codebase
   - create or refresh `.supa-ralph/IMPLEMENTATION_PLAN.md`

3. **Building**
   - implement the highest-value planned task
   - run checks
   - commit and push
   - update plan and progress
   - repeat with fresh context until complete

## Important runtime truth

Each plan or build iteration is a **fresh Claude process**.

That means memory does not carry forward automatically. Everything that matters must be written to disk in:
- `tasks/`
- `specs/`
- `.supa-ralph/IMPLEMENTATION_PLAN.md`
- `.supa-ralph/progress.txt`
- `.supa-ralph/AGENTS.md`

## Run this only in a sandbox

Supa Ralph uses Claude Code with `--dangerously-skip-permissions` for autonomous execution.
That is powerful and convenient, but it removes the normal approval boundary.

**Do not treat this as safe to run casually on your laptop or a machine full of secrets.**
Use it in a sandboxed or otherwise intentionally trusted environment.

Recommended minimum posture:
- run inside a disposable sandbox, VM, container, or tightly scoped dev box
- use a repo-specific environment, not your entire personal machine context
- keep secrets and unrelated credentials out of the working environment when possible

The loop script requires `SUPA_RALPH_I_ACCEPT_RISK=1` before it will run plan/build mode.

## Quick start

### 1. Clone this repo

```bash
git clone git@github.com:gtg489p/supa-ralph.git
```

### 2. Install into a target project

```bash
./scripts/install-into-project.sh /path/to/your/project
```

This creates a `.supa-ralph/` folder inside the target project, copies the docs into that kit, and creates Claude skill symlinks under `.claude/skills/` when safe to do so.

### 3. Create the PRD from a free-form idea

Use `.supa-ralph/prompts/CLAUDE_PRD_DISCOVERY.md` as the operating contract for the first Claude session.

Expected output:
- `tasks/prd-<feature>.md`
- optionally `specs/*.md` if the idea naturally breaks into distinct topics of concern

### 4. Run a planning pass

```bash
cd /path/to/your/project
SUPA_RALPH_I_ACCEPT_RISK=1 .supa-ralph/scripts/ralph.sh plan 1
```

Expected output:
- `.supa-ralph/IMPLEMENTATION_PLAN.md`

### 5. Run the build loop

```bash
cd /path/to/your/project
SUPA_RALPH_I_ACCEPT_RISK=1 .supa-ralph/scripts/ralph.sh build 10
```

Expected outputs over time:
- code changes
- commits and pushes
- updates to `.supa-ralph/IMPLEMENTATION_PLAN.md`
- updates to `.supa-ralph/progress.txt`

### 6. Check status without running the loop

```bash
cd /path/to/your/project
.supa-ralph/scripts/ralph.sh status
```

## Fresh-session assistant workflow

When Nathan says "Use Supa Ralph on this idea", the expected agent flow is:

1. capture the free-form idea
2. ask clarifying questions only where necessary
3. write a proper PRD in `tasks/`
4. load `.supa-ralph/README.md`, `.supa-ralph/docs/`, and `.supa-ralph/prompts/`
5. run a planning pass
6. run build loops until complete

## Project layout

```text
supa-ralph/
├── docs/
├── prompts/
├── scripts/
├── skills/
└── templates/
```

## Important conventions baked in

- PRD first, not coding first
- use specs to break large ideas into clear topics of concern
- plan mode and build mode are separate
- one focused increment per build iteration
- keep `AGENTS.md` operational, not chatty
- keep implementation status in `IMPLEMENTATION_PLAN.md`
- keep reusable learnings in `progress.txt` and `AGENTS.md`
- use tests and checks as backpressure before commit
- prefer fresh Claude context each loop rather than giant uninterrupted sessions
- do not assume a missing feature is missing, search first

## Commit prefix override

Supa Ralph commits default to `feat(ralph):` / `fix(ralph):`. Override with either:

- `SUPA_RALPH_COMMIT_PREFIX=chore(myscope):` exported in the environment before running `ralph.sh build`
- a `.supa-ralph/config` file line: `commit_prefix=chore(myscope):`

Environment variable wins over config file. Without either, the default applies.

## References

See `NOTICE.md` for source inspiration and attribution.
