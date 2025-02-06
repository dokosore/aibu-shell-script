#!/bin/bash

# TODO: 消す
# 自動デプロイの設定
gcloud beta builds triggers create github \
  --name="nextjs-app-trigger" \
  --repo-owner="YOUR_GITHUB_USERNAME" \
  --repo-name="YOUR_REPOSITORY_NAME" \
  --branch-pattern="^main$" \
  --build-config="cloudbuild.yaml"
