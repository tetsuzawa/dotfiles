# dotfiles

## セットアップ

```bash
# dotfiles を symlink で配置（~/.claude/ 以外）
make force-symlink-all
```

## ~/.claude/ の管理

Claude Code は symlink を破壊する可能性があるため、`~/.claude/` はコピー方式で管理する。

```bash
# ローカル → リポジトリ（変更を検知して PR 作成）
make sync-claude

# リポジトリ → ローカル（新しいマシンや設定復元時）
make restore-claude
```

`sync-claude` は launchd で1時間ごとに自動実行される:

```bash
make install-launchd    # launchd エージェントを登録
make uninstall-launchd  # 解除
```
