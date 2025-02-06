#!/bin/bash

# 概要:
# このスクリプトは、Firebaseプロジェクトを初期化し、必要な機能をセットアップします。
#
# 入力:
# - コマンドライン引数またはプロンプトからのプロジェクト名
#
# 出力:
# - Firebaseプロジェクトが作成され、選択した機能が初期化されます

# 前提条件:
# 1. Firebase CLIのインストール
#    npm install -g firebase-tools
#
# 2. Firebase CLIの認証
#    firebase login
#
# 3. Node.jsとnpmのインストール
#    Mac: brew install node

# 間違えてしまった場合:
# プロジェクトを削除する必要がある場合は、以下のコマンドを実行してください：
# gcloud projects delete プロジェクトID

# プロジェクト名を入力
read -p "Firebaseプロジェクト名を入力してください: " project_name

if [ -z "$project_name" ]; then
    echo "プロジェクト名が入力されていません。"
    exit 1
fi

echo "Firebaseプロジェクトを作成中..."
# Firebaseプロジェクトを初期化。同時にGCPプロジェクトも作成される
firebase projects:create "$project_name" --display-name "$project_name"

if [ $? -ne 0 ]; then
    echo "プロジェクトの作成に失敗しました。"
    exit 1
fi

echo "セットアップが完了しました: $project_name"

