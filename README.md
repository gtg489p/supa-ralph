# supa-ralph

Supa Ralph is a portable, PRD-first Ralph kit for Claude Code.

It starts from the solid autonomous loop idea in `snarktank/ralph`, then bakes in the stronger operating guidance from the Ralph playbook so a fresh session can:

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
- upgraded docs so future sessions know how to run the method without prior chat context
- copied/adapted Ralph skills for PRD creation and PRD-to-JSON conversion

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
   - commit
   - update plan and progress
   - repeat with fresh context until complete

## Quick start

### 1. Clone this repo

```bash
git clone git@github.com:gtg489p/supa-ralph.git
```

### 2. Install into a target project

```bash
./scripts/install-into-project.sh /path/to/your/project
```

This creates a `.supa-ralph/` folder inside the target project.

### 3. Create the PRD from a free-form idea

Use `prompts/CLAUDE_PRD_DISCOVERY.md` as the operating contract for the first Claude session.

Expected output:
- `tasks/prd-<feature>.md`
- optionally `specs/*.md` if the idea naturally breaks into distinct topics of concern

### 4. Run a planning pass

```bash
cd /path/to/your/project
.supa-ralph/scripts/ralph.sh plan 1
```

Expected output:
- `.supa-ralph/IMPLEMENTATION_PLAN.md`

### 5. Run the build loop

```bash
cd /path/to/your/project
.supa-ralph/scripts/ralph.sh build 10
```

Expected outputs over time:
- code changes
- commits
- updates to `.supa-ralph/IMPLEMENTATION_PLAN.md`
- updates to `.supa-ralph/progress.txt`

## Fresh-session assistant workflow

When Nathan says something like:
- "Go do Ralph Wiggum on this idea"
- "Go get Supa Ralph"
- "Use Super Ralph for this feature"

The expected agent flow is:

1. capture the free-form idea
2. ask clarifying questions only where necessary
3. write a proper PRD in `tasks/`
4. install or load `.supa-ralph/`
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

## References

See `NOTICE.md` for source inspiration and attribution.
