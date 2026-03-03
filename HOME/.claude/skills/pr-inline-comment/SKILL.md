---
name: pr-inline-comment
description: >
  GitHub PRのファイル変更にインラインコメントを残すスキル。`gh` CLIを使用。
  PRにコメントを追加、PR変更の説明、インラインコメントでのレビュー、コード変更のアノテーション、
  PRへのサジェスチョン投稿、特定行へのレビューコメント追加を行いたい場合に使用する。
  「PRにコメントして」「PRの変更を説明して」「diffにメモを残して」「変更にフィードバックして」
  「PRをアノテーションして」「PRをレビューして」といった指示にも対応する。
---

# PR Inline Comment

GitHub PRのファイル変更に `gh api` でインラインコメントを残す。主な用途:

- **自分の変更の説明** — 人間のレビュアーが変更意図を理解しやすくする
- **コードレビュー** — 該当行にアンカーされた具体的なフィードバック
- **コード提案** — GitHubの `suggestion` ブロックでワンクリック適用可能な修正提案

## 前提条件

- `gh` CLIがインストール・認証済み（`pull_requests:write` スコープが必要）
- 現在のブランチにオープンなPRがある（またはPR番号を明示的に指定）

## ワークフロー

### 1. PR情報の取得

現在のブランチからPR情報を取得する。PR が存在しない場合は `gh pr view` がエラーを返すので、先にPRの存在を確認する:

```bash
# PRの存在確認（エラーの場合はPRが未作成）
gh pr view --json number --jq '.number' 2>/dev/null || echo "PRが見つかりません"

PR_NUMBER=$(gh pr view --json number --jq '.number')
COMMIT_SHA=$(gh pr view --json headRefOid --jq '.headRefOid')
OWNER=$(gh repo view --json owner --jq '.owner.login')
REPO=$(gh repo view --json name --jq '.name')
```

リモートリポジトリを指定する場合は `--repo OWNER/REPO` フラグを使う:

```bash
PR_NUMBER=123
COMMIT_SHA=$(gh pr view $PR_NUMBER --repo OWNER/REPO --json headRefOid --jq '.headRefOid')
```

### 2. diffの確認と行番号の特定

コメント対象の行番号を正確に特定するために、diffを確認する:

```bash
gh pr diff "$PR_NUMBER"
```

#### diffの行番号の読み方

unified diff のhunkヘッダー `@@ -old_start,old_count +new_start,new_count @@` から行番号を読み取る:

```
@@ -98,5 +100,8 @@        ← 旧ファイルは98行目から5行、新ファイルは100行目から8行
 unchanged line             ← 100行目（コンテキスト行、空白で始まる）
-removed line               ← 旧ファイルの行（削除行、LEFT side）
+added line                 ← 101行目（追加行、RIGHT side）
+another added line         ← 102行目（追加行、RIGHT side）
 unchanged line             ← 103行目（コンテキスト行）
```

- `+` で始まる行 → 新ファイルの行番号（RIGHT side でコメント可能）
- `-` で始まる行 → 旧ファイルの行番号（LEFT side でコメント可能）
- 空白で始まる行 → コンテキスト行（RIGHT side でコメント可能）
- diff hunk 内の行のみがコメント対象。hunk外の行にコメントすると422エラー

ファイル一覧を構造化して取得する場合（大きなPRでは `--paginate` で全ファイル取得）:

```bash
gh api "/repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}/files" --paginate \
  --jq '.[] | {filename, status, additions, deletions}'
```

#### コメント不可なファイルの判別

以下のファイルにはインラインコメントを付けられない:
- **バイナリファイル**: `patch` フィールドが空のファイル
- **削除されたファイル**: RIGHT side へのコメント不可（LEFT side は可能）
- **リネームのみのファイル**: 内容変更がない場合はdiffがない

### 3. 既存コメントの確認（重複防止）

コメントを投稿する前に、既存のコメントを確認して重複を防ぐ:

```bash
gh api "/repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}/comments" \
  --jq '.[] | {id, path, line, body}'
```

### 4. コメントの投稿

個別コメント（即時反映）またはグループレビュー（一括投稿）を選択する。
複数コメントを投稿する場合は、通知ノイズの削減とAPI呼び出し回数の節約のためグループレビューを推奨する。

#### 方式A: 個別インラインコメント

1件だけの場合に適切。各コメントはdiff上の独立したコメントとして即座に表示される。

**単一行コメント:**

```bash
gh api \
  -X POST \
  "/repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}/comments" \
  -f body="コメント内容" \
  -f commit_id="${COMMIT_SHA}" \
  -f path="src/example.ts" \
  -F line=42 \
  -f side="RIGHT"
```

**複数行コメント（行範囲指定）:**

```bash
gh api \
  -X POST \
  "/repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}/comments" \
  -f body="このブロックはXのためにYしている" \
  -f commit_id="${COMMIT_SHA}" \
  -f path="src/example.ts" \
  -F start_line=10 \
  -f start_side="RIGHT" \
  -F line=18 \
  -f side="RIGHT"
```

#### 方式B: グループレビュー（複数コメントを一括投稿）

全コメントを1つのレビューとしてまとめて投稿する。GitHubのUIで「Submit review」するのと同じ挙動。
heredoc内で変数展開するために `<<EOF`（クォートなし）を使う:

```bash
gh api \
  -X POST \
  "/repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}/reviews" \
  --input - <<EOF
{
  "commit_id": "${COMMIT_SHA}",
  "body": "レビューサマリー",
  "event": "COMMENT",
  "comments": [
    {
      "path": "src/auth.ts",
      "line": 15,
      "side": "RIGHT",
      "body": "テスタビリティのために認証ロジックを専用モジュールに分離"
    },
    {
      "path": "src/api/handler.ts",
      "line": 42,
      "side": "RIGHT",
      "body": "指数バックオフ付きリトライロジックを追加"
    }
  ]
}
EOF
```

`event` フィールドは必ず `"COMMENT"` を使う。`"APPROVE"` や `"REQUEST_CHANGES"` はPRの承認状態を永続的に変更するため、ユーザーが明示的にレビューアクションを求めた場合のみ使用すること。自分のPRをAPPROVEしてはいけない。

## パラメータリファレンス

| パラメータ | 型 | 必須 | 説明 |
|-----------|------|------|------|
| `path` | string | yes | リポジトリルートからの相対ファイルパス（リネームされたファイルは新しいパスを使用） |
| `body` | string | yes | コメント本文（Markdown対応） |
| `line` | int | yes | 行番号（複数行の場合は終了行）。diff hunk内の行のみ有効 |
| `side` | string | yes | `"RIGHT"` = 新コード、`"LEFT"` = 削除されたコード（大文字小文字を区別） |
| `commit_id` | string | yes | PRブランチのHEADコミットSHA |
| `start_line` | int | no | 複数行コメントの開始行 |
| `start_side` | string | no | 開始行のside（`side` と同じ値にすること。クロスサイド範囲は非対応） |

`gh api` では文字列パラメータに `-f`、整数パラメータに `-F` を使う。

## コード提案（suggestion）構文

レビュアーがワンクリックで適用できる具体的なコード修正を提案するには、GitHubのsuggestionブロックを使う。
明確で機械的な修正に適しており、1-5行程度の短いsuggestionが最も効果的:

````markdown
```suggestion
const result = items.map(transform);
```
````

GitHub UIでは「Apply suggestion」ボタンとして表示され、コメント対象の行を置換する。
複数行のsuggestionには行範囲（`start_line` + `line`）を指定する。

JSON内でsuggestionを書く場合は改行を `\n`、バッククォートを `` \` `` でエスケープする:

```
"body": "説明\n\n\`\`\`suggestion\nconst x = 1;\n\`\`\`"
```

## 効果的なPRアノテーションのガイドライン

### 自分の変更を説明する場合

レビュアーの認知負荷を下げることが目的。コメントの焦点:

- **なぜ** その変更をしたか（何を変えたかはdiffで分かる）
- 自明でない設計判断やトレードオフ
- 破壊的変更や以前との振る舞いの違い
- 簡潔な説明があると助かる複雑なロジック
- ファイル間の変更の依存関係（「handler.ts:35の変更と対になっている」など）

PRの複雑さに応じて3〜8件程度のコメントが目安。trivialな変更（import追加、フォーマット、リネーム）には説明不要。

### 他人のコードをレビューする場合

- 何が問題で、なぜ問題なのかを具体的に。実行可能なフィードバックを心がける
- suggestionブロックは明確で機械的な修正にのみ使う（設計レベルの提案には不向き）
- 関連するフィードバックは個別コメントではなくグループレビューでまとめる

## エラーハンドリング

| エラー | 原因 | 対処 |
|--------|------|------|
| 422 Validation Failed | `line` がdiff hunk範囲外 | `gh pr diff` でhunkヘッダーから有効な行番号を確認 |
| 404 Not Found | PR番号、リポジトリ、ファイルパスが間違い | `gh pr view` で確認。リネームファイルは新しいパスを使う |
| 403 Forbidden | トークンに `pull_requests:write` 権限がない | `gh auth status` で確認 |
| 重複コメント | 同じスキルの再実行 | 投稿前に既存コメントを確認（ステップ3） |

## 注意事項

- コメント本文にシークレットやトークンを含めないこと。diffに含まれる秘密情報を引用しない
- diff hunk外の行にはコメントできない（GitHub APIの制約）
- `side` の値は大文字小文字を区別する（`"RIGHT"`, `"LEFT"`）
- バイナリファイルやリネームのみのファイルにはdiffがないためコメント不可
- 大量のPRファイルには `--paginate` フラグで全ファイルを取得する
- コメントは一度投稿すると一括削除が難しい。投稿前にパラメータを確認すること
