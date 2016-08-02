---
layout: page
title: '[Jekyll] ビルドするときにだけSass(SCSS)を圧縮する'
date: 2016-03-04 19:19:37 +0900
category: blog
tags: Jekyll
---

_config.yml に Sass(SCSS) を圧縮する設定を書くと、常時圧縮がかかってしまう。
これでは、ブラウザで表示を確認しながら CSS をいじるとき困る。
ということで、製作中は圧縮せずにビルド時だけ圧縮する方法。

<small>※ 2016/3/4現在、 Jekyll では Sourcemap が出力できないっぽい。</small>

### 1. ビルド用設定ファイルを作る

_config.yml と同じフォルダに
_config-production.yml という名前のファイルを作成し、以下の通り書く

    sass:
      style: compressed

参考: 
<a href="https://jekyllrb.com/docs/assets/#sassscss" target="_blank">Assets - Jekyll • Simple, blog-aware, static sites</a>

### 2. 製作時のコマンド

製作中はいつも通り。

    jekyll serve

### 3. ビルド時のコマンド

ビルドするときは --config オプションで _config.yml と _config-production.yml の2つを読み込む。
両方のファイルに同じ設定項目がある場合は、後ろに書いた方の設定で上書きされる。
カンマとファイル名の間にスペースを入れないこと。

    jekyll build --config _config.yml,_config-production.yml

参考: 
<a href="https://jekyllrb.com/docs/configuration/#build-command-options" target="_blank">Configuration - Jekyll • Simple, blog-aware, static sites</a>
