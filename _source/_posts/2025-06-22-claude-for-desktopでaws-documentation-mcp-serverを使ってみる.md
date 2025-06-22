---
layout: post
title: Claude for Desktop で AWS Documentation MCP Server を使ってみる
date: 2025-06-22 23:00:00 +0900
category: blog
tags: [ Claude, AWS, MCP ]
description:
---

MCP の使い道を調べているうちに知った
AWS Documentation MCP Server が便利そうだったので使ってみた。

## AWS Documentation MCP Server とは？

AI アシスタントが AWS の公式ドキュメントを参照して回答できるようにする MCP Server。
これにより、AWS に関する質問に対してより正確で詳細な回答が提供されるようになる。

[AWS Documentation MCP Server - AWS MCP Servers](https://awslabs.github.io/mcp/servers/aws-documentation-mcp-server/){:target="_blank"}

## AWS Documentation MCP Server を起動する

GitHub の
[awslabs/mcp](https://github.com/awslabs/mcp){:target="_blank"}
を git clone して docker build で起動するだけ。

 uv と Python のインストールから説明しているサイトもあるが、
 現状 Dockerfile が提供されておりインストール不要になっている。

```shell
git clone git@github.com:awslabs/mcp.git aws-mcp
docker build -t mcp/aws-documentation aws-mcp/src/aws-documentation-mcp-server
```

## Claude for Desktop の設定

1.  ウィンドウ左上のハンバーガーボタンから「ファイル > 設定...」をクリックする
    ![設定画面を開く](/assets/images/blog/2025-06-22/claude-for-desktop1.png)
1.  「開発者」をクリックする
1.  「構成を編集」をクリックする
1.  `claude_desktop_config.json` があるフォルダが開く
1.  `claude_desktop_config.json` へ
    [Installation](https://awslabs.github.io/mcp/servers/aws-documentation-mcp-server/#installation){:target="_blank"}
    にかかれている Docker 用 JSON を書き込む
1． 設定画面を閉じる
1.  ウィンドウ左上のハンバーガーボタンから「ファイル > 終了」をクリックし Claude for Desktop を終了させる
1.  再度 Claude for Desktop を起動すると、チャット入力欄のメニューに追加されている
    ![チャット入力欄のメニューに追加された AWS Documentation MCP Server](/assets/images/blog/2025-06-22/claude-for-desktop2.png)

## 使ってみる

AWS に関する質問をすると外部連携の許可を何度か確認される。

![外部連携の許可](/assets/images/blog/2025-06-22/claude-for-desktop3.png)

しばらく待つと AWS の公式ドキュメントを元にした回答が提示される。

![AWS の公式ドキュメントを元にした回答](/assets/images/blog/2025-06-22/claude-for-desktop4.png)
