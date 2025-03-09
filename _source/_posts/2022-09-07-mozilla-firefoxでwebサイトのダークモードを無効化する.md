---
layout: post
title: Mozilla Firefox で Web サイトのダークモードを無効化する
date: 2022-09-07 00:16:02 +0900
category: blog
tags: [ PC, Mozilla Firefox ]
description:
---

Firefox 本体はダークテーマを使いたいけど
Web サイトまでダークモードになると文字が読みづらい。

そんな私みたいにわがままな人向けなのかは分からないが
Firefox には Web サイトだけライトモードにする方法があった。

`about:config` で
`layout.css.prefers-color-scheme.content-override`
を変更すればいいらしい。

- 0: ダーク固定
- 1: ライト固定
- 2: OS の設定に従う
- 3: Firefox のテーマに従う

デフォルト値は 3。

当然だがこれを 0 にしても対応していないサイトはダークモードにならない。
