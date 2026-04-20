# Running Safely

Supa Ralph uses Claude Code in autonomous mode.
That makes it productive, but it also means the normal permission dialog is intentionally bypassed.

## Minimum rule

Run Supa Ralph only in an environment you are willing to trust with autonomous code changes and shell access.

## Better defaults

- use a sandbox, container, VM, or isolated dev host
- keep secrets out of scope where possible
- use a dedicated project checkout rather than your whole machine workspace
- keep iterations bounded unless you deliberately want a longer autonomous run

## Acknowledging the risk

The loop script refuses to run plan or build mode until you have acknowledged the risk. There are two ways to do that:

- **Per-invocation env var** — `export SUPA_RALPH_I_ACCEPT_RISK=1` before running `ralph.sh`. Clears when the shell exits. Easy, but env-var exports can silently leak across unrelated projects in the same shell session.
- **Per-project file marker** — `touch .supa-ralph/.risk-accepted` inside the target project. The marker only applies to that single checkout, so it cannot accidentally authorise a different repo. Preferred for long-lived projects.

Either is sufficient. If both are set, the env var wins. If neither is set, the loop refuses to start and prints a reminder.

## Practical reminder

If you are thinking "I can probably just run this in my personal shell once," stop and decide that consciously.
