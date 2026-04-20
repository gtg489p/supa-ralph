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

## Practical reminder

If you are thinking "I can probably just run this in my personal shell once," stop and decide that consciously.
