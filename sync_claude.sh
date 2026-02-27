#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCK_FILE="/tmp/dotfiles-sync-claude.lock"
BRANCH_PREFIX="sync-claude"

if ! mkdir "$LOCK_FILE" 2>/dev/null; then
  echo "Another sync is already running. Exiting."
  exit 0
fi
trap 'rmdir "$LOCK_FILE"' EXIT

cd "$DOTFILES_DIR"

if git diff --name-only HEAD -- HOME/.claude/ | grep -q .; then
  echo "Changes detected. Creating/updating PR..."
else
  echo "No changes detected."
  exit 0
fi

timestamp="$(date +%Y%m%d-%H%M%S)"
branch="${BRANCH_PREFIX}/${timestamp}"

# 既存の sync PR があればそのブランチに追加 push
existing_pr="$(gh pr list --head "${BRANCH_PREFIX}/" --state open --json number,headRefName --jq '.[0].headRefName // empty' 2>/dev/null || true)"

if [ -n "$existing_pr" ]; then
  branch="$existing_pr"
  git checkout "$branch"
fi

git add HOME/.claude/

if git diff --cached --quiet; then
  echo "No changes to commit."
  [ -n "$existing_pr" ] && git checkout master
  exit 0
fi

if [ -z "$existing_pr" ]; then
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
