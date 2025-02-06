#!/bin/bash

# プロジェクト名を入力。重複に注意してください
read -p "Enter your project name: " project_name

# GitHubのユーザー名
github_user="nakayoshi-club"
# コピー元リポジトリのURL
template_repo="https://github.com/dokosore/setup-nextjs-app-router.git"

# ローカルにプロジェクトディレクトリを作成
mkdir "$project_name"
cd "$project_name"

# 指定されたリポジトリをクローン
git clone "$template_repo" .
rm -rf .git # .gitフォルダを削除して初期化

# .firebasercファイルを作成
cat <<EOL > .firebaserc
{
  "projects": {
    "default": "$project_name"
  }
}
EOL

# 新しいリポジトリを初期化
git init
git add .
git commit -m "initial commit"

# GitHubに新しいリポジトリを作成
gh repo create "$github_user/$project_name" --public -y
git branch -M main
git remote add origin "https://github.com/$github_user/$project_name.git"
git push -u origin main

# Firebaseプロジェクトを初期化。同時にGCPプロジェクトも作成される
firebase projects:create "$project_name" --display-name "$project_name"