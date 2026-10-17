#!/bin/sh
set -eu

cd "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

check_link() {
  if [ ! -f AGENTS.md ] || [ -L AGENTS.md ]; then
    printf '%s\n' 'Expected AGENTS.md to be the regular shared instruction file.' >&2
    return 1
  fi
  if [ ! -L CLAUDE.md ] || [ "$(readlink CLAUDE.md)" != 'AGENTS.md' ]; then
    printf '%s\n' 'Expected CLAUDE.md to be a symbolic link to AGENTS.md. See docs/agent-instructions.md.' >&2
    return 1
  fi
  cmp -s AGENTS.md CLAUDE.md
  printf '%s\n' 'OK: AGENTS.md and CLAUDE.md share one instruction source.'
}

case "${1:-history}" in
  check)
    check_link
    ;;
  history)
    check_link
    printf '\n%s\n' 'Committed instruction ledger (newest first):'
    git --no-pager log --date=iso-strict --format='%h | %aI | %an | %s' -- AGENTS.MD AGENTS.md CLAUDE.md
    printf '\n%s\n' 'Pending instruction files:'
    git status --short -- AGENTS.MD AGENTS.md CLAUDE.md
    printf '\n%s\n' 'Unstaged instruction changes:'
    git --no-pager diff -- AGENTS.MD AGENTS.md CLAUDE.md
    printf '\n%s\n' 'Staged instruction changes:'
    git --no-pager diff --cached -- AGENTS.MD AGENTS.md CLAUDE.md
    ;;
  *)
    printf '%s\n' 'Usage: sh scripts/agent-ledger.sh [history|check]' >&2
    exit 2
    ;;
esac
