---
layout: page
title: dtab Compact d-42A から不要なアプリを削除する方法
date: 2022-05-06 01:31:47 +0900
category: blog
tags: [ ガジェット, Android ]
description: Android 端末の不要なアプリを削除する方法
---

昨年踏んで割ってしまった Xperia Z3 Tablet Compact の後継として
[dtab Compact d-42A](https://www.docomo.ne.jp/product/d42a/) を買った。

スペック的にはミドルレンジの Snapdragon 665 なので最新のゲームは動かないけど、
Z3 Tablet Compact と同じ8インチサイズだし電子書籍を読むにはいいんじゃないかと。
そもそも Android の8インチタブレットは不作で、
他は低スペックな激安タブレットしか選択肢がない。

d-42A はドコモ製なのでキャリア製端末の例に漏れず
削除できない不要なアプリが大量に入っていた。
まずはこれを削除したので手順を残しておく。
なお、Android 11 へアップデート後にアプリを削除したが
以前と同じ手順で特に問題なかった。

## 削除手順

**アプリを削除すると最悪の場合端末が起動しなくなったり
動作が不安定になる可能性があります。  
リスクを承知の上、自己責任で行ってください。**

1. d-42A で 設定 > タブレット情報 を開く
1. ビルド番号を7回タップし開発者向けオプションを表示する
1. 設定 > システム > 詳細設定 > 開発者向けオプション を開く
1. USBデバッグをオンにする
1. PC で
   [Android SDK Platform-Tools](https://developer.android.com/studio/releases/platform-tools)
   をダウンロードし展開する
1. Platform-Tools を展開したフォルダをコマンドプロンプトで開く
1. `adb devices` を実行し接続している端末を確認する
1.  d-42A に「USBデバッグを許可しますか?」と表示されるので「OK」を押して許可する
1.  `adb shell pm list packages -s` を実行しパッケージ名の一覧を表示する
1. `adb shell` を実行しシェルを起動する
1. `pm uninstall -k --user 0 パッケージ名` を実行し不要アプリを削除する
1. `exit` を実行しシェルを終了する
1. `adb kill-server` を実行し adb サーバーを停止する

## 削除したパッケージ

パッケージ名に `nttdocomo` が含まれるもの+αを削除した。

`jp.co.omronsoft.iwnnime.ml_lenovo` は標準のキーボードアプリのため
Gboard など他のキーボードアプリをインスールする前に消すと
文字が入力できなくなって死ぬので注意。

    com.android.contacts (ドコモ電話帳)
    com.google.android.apps.photos (Google フォト)
    com.google.android.apps.tachyon (Google Duo)
    com.google.android.apps.wellbeing (Digital Wellbeing)
    com.google.android.apps.youtube.music (YouTube Music)
    com.google.android.projection.gearhead (Android Auto)
    com.google.android.videos (Google Play ムービー＆ TV)
    com.iii.app.kidsgallery
    com.iii.app.safebrowser
    com.lenovo.d42a.manual
    com.lenovo.docomosettings
    com.lenovo.homescreenshot (マイホームスクリーン)
    com.lenovo.simplemenu
    com.nttdocomo.android.accountauthenticator
    com.nttdocomo.android.accountwipe
    com.nttdocomo.android.anmane2
    com.nttdocomo.android.apnsw
    com.nttdocomo.android.applicationmanager
    com.nttdocomo.android.cloudset
    com.nttdocomo.android.databackup
    com.nttdocomo.android.devicehelp
    com.nttdocomo.android.dmenu2
    com.nttdocomo.android.docomoset
    com.nttdocomo.android.homezozo
    com.nttdocomo.android.idmanager
    com.nttdocomo.android.initialization
    com.nttdocomo.android.lpa
    com.nttdocomo.android.mascot
    com.nttdocomo.android.msg
    com.nttdocomo.android.mymagazine
    com.nttdocomo.android.pf.dcmippushaggregator
    com.nttdocomo.android.pf.dcmwappush
    com.nttdocomo.android.remotelock
    com.nttdocomo.android.schedulememo
    com.nttdocomo.android.sdcardbackup
    com.nttdocomo.android.sha2.kids
    com.nttdocomo.android.store
    com.nttdocomo.android.wipe
    com.tblenovo.kidslauncher
    com.tblenovo.kidsmodewebview
    com.tblenovo.lewea
    jp.co.nttdocomo.anshinmode
    jp.co.nttdocomo.bridgelauncher
    jp.co.nttdocomo.carriermail
    jp.co.nttdocomo.lcsapp
    jp.co.nttdocomo.saigaiban
    jp.co.omronsoft.android.decoemojimanager_docomo
    jp.co.omronsoft.iwnnime.ml_lenovo
