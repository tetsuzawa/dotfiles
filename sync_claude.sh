#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
DEST_DIR="$DOTFILES_DIR/HOME/.claude"
LOCK_FILE="/tmp/dotfiles-sync-claude.lock"
BRANCH_PREFIX="sync-claude"
WORKTREE_DIR=""

if ! mkdir "$LOCK_FILE" 2>/dev/null; then
  echo "Another sync is already running. Exiting."
  exit 0
fi

cleanup() {
  if [ -n "$WORKTREE_DIR" ]; then
    git -C "$DOTFILES_DIR" worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
  fi
  rmdir "$LOCK_FILE" 2>/dev/null || true
}
trap cleanup EXIT

# ~/.claude/ から HOME/.claude/ へ差分コピー
# DEST_DIR に既に存在するファイルのみを同期対象とする
sync_files() {
  local changed=false

  while IFS= read -r -d '' dst; do
    local rel="${dst#"$DEST_DIR"/}"
    local src="$CLAUDE_DIR/$rel"
    [ -f "$src" ] || continue
    if ! diff -q "$src" "$dst" >/dev/null 2>&1; then
      cp "$src" "$dst"
      changed=true
    fi
  done < <(find "$DEST_DIR" -type f -print0)

  echo "$changed"
}

create_or_update_pr() {
  cd "$DOTFILES_DIR"

  local timestamp
  timestamp="$(date +%Y%m%d-%H%M%S)"
  local branch="${BRANCH_PREFIX}/${timestamp}"

  WORKTREE_DIR="$(mktemp -d)"

  local existing_pr
  existing_pr="$(gh pr list --head "${BRANCH_PREFIX}/" --state open --json number,headRefName --jq '.[0].headRefName // empty' 2>/dev/null || true)"

  if [ -n "$existing_pr" ]; then
    branch="$existing_pr"
    git worktree add "$WORKTREE_DIR" "$branch"
  else
    git worktree add "$WORKTREE_DIR" -b "$branch"
  fi

  cp -R "$DEST_DIR"/. "$WORKTREE_DIR/HOME/.claude/"

  cd "$WORKTREE_DIR"
  git add HOME/.claude/

  if git diff --cached --quiet; then
    echo "No changes to commit."
    return
  fi

  git commit -m "sync: ~/.claude 設定ファイルを同期 (${timestamp})"
  git push -u origin "$branch"

  if [ -z "$existing_pr" ]; then
    gh pr create \
      --base master \
      --title "sync: ~/.claude 設定ファイルを同期" \
      --body "$(cat <<'EOF'
## Summary
- ~/.claude 配下の管理対象設定ファイルを自動同期

自動生成された PR です。CI でのバリデーション後、auto merge されます。
EOF
)"
  fi
}

changed="$(sync_files)"
if [ "$changed" = "true" ]; then
  echo "Changes detected. Creating/updating PR..."
  create_or_update_pr
else
  echo "No changes detected."
fi
