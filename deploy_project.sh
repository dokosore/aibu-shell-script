#!/bin/bash

# プロジェクト名とリージョンの設定
PROJECT_ID=$(gcloud config get-value project)
REGION=asia-northeast1
SERVICE_NAME=next-app
DOMAIN_NAME="$PROJECT_ID.dokokichi.com" # ここを独自ドメインに置き換えてください

# Cloud RunにデプロイされたサービスのURLを取得
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region $REGION --format "value(status.url)")

# 独自ドメインをマッピング
gcloud run domain-mappings create --service $SERVICE_NAME --domain $DOMAIN_NAME --region $REGION

# DNS設定の確認（ドメインのDNS設定にこれらの情報を追加する必要があります）
echo "以下のDNS設定を行ってください："
gcloud beta run domain-mappings describe --domain $DOMAIN_NAME --region $REGION --format="get(resourceRecords)"

# SSL証明書の自動取得（gcloudが自動的にSSL証明書を取得）
