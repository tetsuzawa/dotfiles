#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
DEST_DIR="$DOTFILES_DIR/HOME/.claude"
LOCK_FILE="/tmp/dotfiles-sync-claude.lock"
BRANCH_PREFIX="sync-claude"

exec 200>"$LOCK_FILE"
if ! flock -n 200; then
  echo "Another sync is already running. Exiting."
  exit 0
fi

# ホワイトリスト方式で管理対象ファイルを定義
MANAGED_FILES=(
  "CLAUDE.md"
  "settings.json"
  "hooks/hook_pre_commands.sh"
  "hooks/hook_stop_words.sh"
)

sync_files() {
  local changed=false

  for f in "${MANAGED_FILES[@]}"; do
    local src="$CLAUDE_DIR/$f"
    local dst="$DEST_DIR/$f"
    if [ -f "$src" ]; then
      mkdir -p "$(dirname "$dst")"
      if ! diff -q "$src" "$dst" >/dev/null 2>&1; then
        cp "$src" "$dst"
        changed=true
      fi
    fi
  done

  # hooks/rules/*.json
  if [ -d "$CLAUDE_DIR/hooks/rules" ]; then
    mkdir -p "$DEST_DIR/hooks/rules"
    for src in "$CLAUDE_DIR"/hooks/rules/*.json; do
      [ -f "$src" ] || continue
      local name
      name="$(basename "$src")"
      if ! diff -q "$src" "$DEST_DIR/hooks/rules/$name" >/dev/null 2>&1; then
        cp "$src" "$DEST_DIR/hooks/rules/$name"
        changed=true
      fi
    done
  fi

  echo "$changed"
}

create_or_update_pr() {
  cd "$DOTFILES_DIR"

  git add HOME/.claude/

  if git diff --cached --quiet; then
    echo "No changes to commit."
    return
  fi

  local timestamp
  timestamp="$(date +%Y%m%d-%H%M%S)"
  local branch="${BRANCH_PREFIX}/${timestamp}"

  # 既存の sync PR があればそのブランチに push
  local existing_pr
  existing_pr="$(gh pr list --head "${BRANCH_PREFIX}/" --state open --json number,headRefName --jq '.[0].headRefName // empty' 2>/dev/null || true)"

  if [ -n "$existing_pr" ]; then
    branch="$existing_pr"
    git checkout "$branch"
    git add HOME/.claude/
    if git diff --cached --quiet; then
      echo "No changes to commit on existing branch."
      git checkout master
      return
    fi
  else
    git checkout -b "$branch"
  fi

  git commit -m "sync: ~/.claude 設定ファイルを同期 (${timestamp})"
  git push -u origin "$branch"

  if [ -z "$existing_pr" ]; then
    gh pr create \
      --title "sync: ~/.claude 設定ファイルを同期" \
      --body "$(cat <<'EOF'
## Summary
- ~/.claude 配下の管理対象設定ファイルを自動同期

自動生成された PR です。CI でのバリデーション後、auto merge されます。
EOF
)"
  fi

  git checkout master
}

changed="$(sync_files)"
if [ "$changed" = "true" ]; then
  echo "Changes detected. Creating/updating PR..."
  create_or_update_pr
else
  echo "No changes detected."
fi
