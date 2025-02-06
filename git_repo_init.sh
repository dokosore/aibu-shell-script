#!/bin/bash

# 前提条件:
# 1. GitHub CLIのインストール
#    Mac: brew install gh
#    Linux: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
#
# 2. GitHub CLIの認証
#    gh auth login
#    
# 3. Gitのインストール
#    Mac: brew install git
#    Linux: sudo apt-get install git

# .envファイルから環境変数を読み込む
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# 環境変数から値を取得
github_user=${GITHUB_USER:-"default_username"}

# プロジェクト名を入力
read -p "リポジトリ名を入力してください: " repo_name

# 入力値が空の場合はエラー
if [ -z "$repo_name" ]; then
    echo "エラー: リポジトリ名を入力してください"
    exit 1
fi

# 新しいリポジトリを初期化
git init

# すべてのファイルをステージング
git add .

# 初期コミット
git commit -m "initial commit"

# GitHubに新しいリポジトリを作成（パブリック）
gh repo create "$github_user/$repo_name" --public -y

# mainブランチに変更
git branch -M main

# リモートリポジトリを追加
git remote add origin "https://github.com/$github_user/$repo_name.git"

# 変更をプッシュ
git push -u origin main

echo "リポジトリの初期化が完了しました: $repo_name"