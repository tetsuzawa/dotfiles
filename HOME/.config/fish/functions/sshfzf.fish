function bcc
  # 引数チェック
  if test (count $argv) -eq 0
    echo "使用方法: bcc <branch-name>"
    echo "例: bcc feature-xyz"
    return 1
  end

  # worktree名の定義
  set worktree_name "../cac-mcp-add-$argv[1]"
  
  # 既存のworktreeをチェック
  if test -d $worktree_name
    echo "エラー: worktree '$worktree_name' はすでに存在します"
    return 1
  end
  
  # git worktreeを作成
  if not git worktree add $worktree_name
    echo "エラー: git worktreeの作成に失敗しました"
    return 1
  end
  
  # worktreeディレクトリに移動
  if not cd $worktree_name
    echo "エラー: ディレクトリ '$worktree_name' への移動に失敗しました"
    return 1
  end

  # package.jsonが元ディレクトリと同じかチェック
  set original_package_json "../package.json"
  set current_package_json "./package.json"
  
  if test -f $original_package_json; and test -f $current_package_json
    # package.jsonのハッシュを比較
    set original_hash (shasum $original_package_json | cut -d' ' -f1)
    set current_hash (shasum $current_package_json | cut -d' ' -f1)
    
    if test "$original_hash" = "$current_hash"; and test -d "../node_modules"
      echo "package.jsonが同じなので、node_modulesをコピーします..."
      cp -r ../node_modules ./
      # pnpm用のsymlinkを再構築
      pnpm install --frozen-lockfile --prefer-offline
    else
      echo "package.jsonが異なるため、通常のinstallを実行します..."
      pnpm install
    end
  else
    echo "package.jsonが見つからないため、通常のinstallを実行します..."
    pnpm install
  end

  pnpm install

  # claudeコマンドを実行
  claude "/mcp-add-tool $argv[1]"
  
  # claudeコマンドの終了ステータスを返す
  return $status
end
