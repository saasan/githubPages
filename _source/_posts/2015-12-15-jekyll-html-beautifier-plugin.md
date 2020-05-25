---
layout: page
title: '[Jekyll] HTMLを読みやすいように整形するプラグイン'
date: 2015-12-15 18:59:07 +0900
category: blog
tags: Jekyll
description: beautifierとかpretty printとかいわれる機能をJekyllでのビルド時に実行します。
---

Jekyll で include を多用してると、include されたファイルの中に
include があってまたそのファイルの中に include が……なんてことになって
HTML の構造が分からなくなるときがあります。
できあがった HTML をみてもインデントがメチャクチャでわけがわからない…！

そこで、HTML を整形して出力するプラグインを作ってみました。
いわゆるbeautifierとかpretty printとかいわれる機能ですね。

{% gist saasan/7c92d15e7ebb4870f581 %}

```gem install htmlbeautifier``` などで htmlbeautifier をインストールしたあと、
このファイルを _plugins フォルダに入れれば
Jekyll でのビルド時に HTML が整形されます。

プラグインなので、プラグインが使えない GitHub Pages 上でのビルドには使えません。
あらかじめローカルの環境でビルドして生成されたファイルをアップロードしてください。
