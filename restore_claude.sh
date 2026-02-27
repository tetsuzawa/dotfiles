#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$DOTFILES_DIR/HOME/.claude"
CLAUDE_DIR="$HOME/.claude"

if [ ! -d "$SRC_DIR" ]; then
  echo "Error: $SRC_DIR not found."
  exit 1
fi

restored=0

while IFS= read -r -d '' src; do
  rel="${src#"$SRC_DIR"/}"
  dst="$CLAUDE_DIR/$rel"

  mkdir -p "$(dirname "$dst")"

  if [ ! -f "$dst" ] || ! diff -q "$src" "$dst" >/dev/null 2>&1; then
    cp "$src" "$dst"
    echo "restored: $rel"
    restored=$((restored + 1))
  fi
done < <(find "$SRC_DIR" -type f -print0)

if [ "$restored" -eq 0 ]; then
  echo "No changes. Already up to date."
else
  echo "Restored $restored file(s)."
fi
