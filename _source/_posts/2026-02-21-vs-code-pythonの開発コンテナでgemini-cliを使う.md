---
layout: post
title: '[VS Code] Python の開発コンテナで Gemini CLI を使う'
date: 2026-02-21 22:05:00 +0900
category: blog
tags: [ VS Code, Python, 開発コンテナ, Dev Containers, Gemini CLI ]
description:
---

Python の開発コンテナ (Dev Containers) で Gemini CLI を使う方法のメモ。

「開発コンテナー: 開発コンテナー構成ファイルを追加...」で JSON ファイルを作成する場合は
「機能の選択」で Node.js を追加する。

devcontainer.json を直接編集する場合は以下の通り。

```json
// .devcontainer/devcontainer.json

{
    "name": "Python 3",
    "image": "mcr.microsoft.com/devcontainers/python:2-3.14-trixie",

    // Node.jsを追加
    "features": {
        "ghcr.io/devcontainers/features/node:1": {}
    },

    // コンテナ作成後にGemini CLIをインストール
    "postCreateCommand": "sh .devcontainer/install-dependencies.sh",

    // ホストのGemini CLIの設定をコンテナ内にマウント
    "mounts": [
        {
        "source": "${localEnv:HOME}${localEnv:USERPROFILE}/.gemini",
        "target": "/home/vscode/.gemini",
        "type": "bind"
        }
    ]
}
```

```bash
# .devcontainer/install-dependencies.sh

# Gemini CLIのインストール
npm install -g @google/gemini-cli
```
