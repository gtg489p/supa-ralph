You are in bootstrap-agents mode.

You are running in a fresh Claude process as a **single-shot** invocation, not a loop.

Your job is to populate `.supa-ralph/AGENTS.md` with the real commands and conventions for this specific project, so later plan and build iterations start with accurate operational knowledge instead of the generic template.

## Orientation first

0a. Inspect the repo root for build-system signals, in order of specificity:
    - `package.json` plus one of `pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`, `bun.lockb` (pick the manager the lockfile implies)
    - `pyproject.toml`, `setup.cfg`, `requirements.txt`, `Pipfile`, `poetry.lock`, `uv.lock`
    - `Cargo.toml`, `Cargo.lock`
    - `go.mod`, `go.sum`
    - `Gemfile`, `Gemfile.lock`
    - `pom.xml`, `build.gradle`, `build.gradle.kts`
    - `Makefile`, `justfile`, `Taskfile.yml`
    - `Dockerfile`, `docker-compose.yml`, `compose.yaml`
0b. Read the existing `.supa-ralph/AGENTS.md`. Note anything that is clearly NOT template boilerplate — a maintainer-authored section is load-bearing and must survive your rewrite.
0c. Skim the top-level `README.md` (and any `CONTRIBUTING.md` or `docs/`) for documented commands.
0d. For each plausible tool, verify it against the actual repo before writing it down — e.g. confirm the `test` script exists in `package.json.scripts` before claiming `npm test` is the test command.

## What to do

1. Infer the concrete commands this project uses for each of these categories (omit any that genuinely do not apply):
   - **typecheck** — e.g. `npm run typecheck`, `mypy .`, `cargo check`
   - **test** — unit tests; if integration/e2e exist separately, list them distinctly
   - **build** — production build or binary compile
   - **lint / format** — static analysis, formatting checks
   - **run / dev** — local dev server or binary entrypoint
   - **preflight** — anything that has to run before the above works (migrations, codegen, container build)
2. Rewrite `.supa-ralph/AGENTS.md`:
   - Replace generic template prose with concrete commands.
   - Preserve any human-authored section (heading plus its body) that is clearly not part of the Supa Ralph template.
   - Keep the file short and operational. Bullet lists of commands beat paragraphs.
3. If a category has no command — e.g. the project has no linter — **omit** the category rather than inventing one.
4. Note ambiguities explicitly. If there are two plausible test runners, pick the one the lockfile/tool signal favours and note the alternative in a one-line comment.

## Guardrails

999. Single-shot. Do not loop. Do not wait for further input. Exit when `AGENTS.md` is written.
9999. Do not invent commands. If a tool is absent from the repo, say so explicitly or omit the category — a wrong command is worse than a missing one because the later build loop will run it.
99999. Keep `AGENTS.md` under roughly 60 lines. Operational, not chatty. Status updates do not belong here.
999999. Preserve maintainer-authored sections verbatim. When in doubt whether content is boilerplate or human-authored, keep it.
9999999. When authoring or editing documentation, capture the *why* — the problem or constraint behind the change — not only the outcome.
99999999. When the rewrite is complete and saved, make the last non-empty line of your output exactly `<promise>BOOTSTRAP_READY</promise>` so a human reviewer can confirm the run reached a clean exit. The runner does not check for this tag; it is purely for auditability.
