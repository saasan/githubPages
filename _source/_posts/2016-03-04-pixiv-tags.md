---
layout: post
title: pixiv Tags
date: 2016-03-04 20:47:55 +0900
category: script
image: /assets/images/pixivtags/normal.png
---

## 概要

[Greasemonkey](https://addons.mozilla.org/ja/firefox/addon/greasemonkey/)
用スクリプト。
設定したタグを [pixiv](https://www.pixiv.net/) 内に常時表示し、タグ巡回を快適にします。

## ダウンロード

[pixiv-tags.user.js](https://github.com/saasan/Scripts/raw/master/pixiv-tags.user.js)

## 詳細

ブラウザーのウィンドウ幅が広ければ、開いた状態で左側に表示されます。

![](/assets/images/pixivtags/normal.png)

ブラウザーのウィンドウ幅が狭ければ、閉じた状態で左上に表示されます。

![](/assets/images/pixivtags/closed.png)

閉じた状態の時にカーソルを乗せると開きます。

![](/assets/images/pixivtags/open.png)

設定の「ページの左側に固定表示する」からチェックをはずすと、タグを全て表示した状態で上部に表示されます。

![](/assets/images/pixivtags/always.png)

検索結果を表示した状態で「検索条件を追加」ボタンを押すと、タグを追加できます。

![](/assets/images/pixivtags/search.png)

「設定」ボタンを押すか、Greasemonkey のユーザースクリプトコマンドから設定ができます。

![](/assets/images/pixivtags/menu.png)

タグは1行に1つ書いて下さい。
部分一致で検索したい場合は、タグの後ろにスペースを入れて下さい。
AND/OR検索もできます。

![](/assets/images/pixivtags/settings.png)

## 更新履歴

### 2016/03/04 ver.1.06

* 短縮表示機能を拡張し、タグの途中から指定文字数だけ表示できるように変更
* タグの短縮表示方法を設定画面に記載
* ページの左側への固定表示時に、ブラウザの幅にあわせてサイズが変わるように変更

### 2015/04/21 ver.1.05

[短縮表示、常に展開表示できるように by monsier-oui · Pull Request #1 · saasan/Greasemonkey](https://github.com/saasan/Greasemonkey/pull/1)

* 字数を設定して短縮表示できるように
* 常に展開して表示する選択肢を追加
* 設定などのボタンを追加

### 2014/11/26 ver.1.04

* @grant を記述し、Greasemonkey 2.x に対応(したはず)。
