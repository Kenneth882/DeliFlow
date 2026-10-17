# Shared instructions and change ledger

`AGENTS.md` contains the project instructions. `CLAUDE.md` is a relative symbolic link to that file, so both paths read the same content. The original `AGENTS.MD` filename has been normalized to `AGENTS.md`.

Edit `AGENTS.md` for instruction changes. Writes through `CLAUDE.md` also reach the shared file when the editor follows symbolic links. Some editors save by replacing a file; replacing `CLAUDE.md` breaks the link. The check below and the instruction-link CI workflow detect that condition.

```sh
sh scripts/agent-ledger.sh check
```

The acceptance criterion is that `AGENTS.md` is a regular file and `CLAUDE.md` is a relative symbolic link to `AGENTS.md`. There is no copying delay or background process to start. Existing agent conversations may need to reload instructions to see edits.

## Read the ledger

```sh
sh scripts/agent-ledger.sh
```

Git supplies the ledger: each committed instruction change has a commit ID, timestamp, author, and description. The command also shows pending file status and staged/unstaged diffs. Untracked files appear in status; their contents enter the diff after staging. Both the original uppercase extension and the normalized filename are included in history.

For the full patches in the committed ledger:

```sh
git log -p -- AGENTS.MD AGENTS.md CLAUDE.md
```

Commit instruction changes with a message explaining the policy change and its reason. The ledger is computed when read; it needs no separately maintained history file. Uncommitted edits are visible as pending changes, but individual saves are not archived. This setup does not automatically commit, infer policy changes from application code, or rewrite project rules.

## Repair a replaced link

First compare both files and merge any wanted changes into `AGENTS.md`. Preserve the separate file before recreating the link (use an unused backup filename):

```sh
mv CLAUDE.md CLAUDE.md.backup
ln -s AGENTS.md CLAUDE.md
sh scripts/agent-ledger.sh check
```

Keep the backup until its contents have been reviewed. Clones must support Git symbolic links; on Windows, enable symlink support before checkout or use WSL. A checkout that materializes the link as plain text fails the check.
