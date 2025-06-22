---
layout: post
title: M5Stack ATOM Lite 用の開発環境構築
date: 2021-08-14 16:33:22 +0900
category: blog
tags: [ M5Stack, ATOM-Lite, ESP32 ]
---

M5StickC 1台だけだと用途ごとにプログラムを転送し直す必要があり手間がかかるので
ATOM Lite を購入してみた。

先日 PC を変えたこともあり
再度 Arduino IDE での開発環境を構築する必要があったため
手順を備忘録として残しておく。

内容は基本的に
[m5-docs](https://docs.m5stack.com/en/arduino/arduino_development){:target="_blank"}
と同じ。
PC は Windows 10。

## ドライバーと Arduino IDE のインストール

1. ATOM Lite を PC へ接続し、デバイスマネージャーで "USB Serial Port" が追加されているか確認。  
"M5Stack" という名前のデバイスに黄色い "！" が付いていたらドライバーがインストールされていない。

1. ドライバーが自動でインストールされない場合は
[VCP Drivers - FTDI](https://ftdichip.com/drivers/vcp-drivers/){:target="_blank"}
からダウンロードしてインストール。

1. "USB Serial Port" が表示されたら COM の番号を覚えておく。

1. [Arduino IDE](https://www.arduino.cc/en/software){:target="_blank"} をダウンロードしてインストール。

## ボードの設定

1. Arduino IDE を起動。

1. メニューの [ファイル] > [環境設定] をクリック。

1. [追加のボードマネージャのURL] に以下を入力。

       https://m5stack.oss-cn-shenzhen.aliyuncs.com/resource/arduino/package_m5stack_index.json

1. [OK] をクリック。

1. メニューの [ツール] > [ボード] > [ボードマネージャ...] をクリック。

1. "M5Stack" で検索。

1. 表示された "M5Stack" を [インストール]。

1. インストールが完了したらボードマネージャを閉じる。

1. メニューの [ツール] > [ボード] > [M5Stack Arduino] >[M5Stack-ATOM] をクリック。

1. ウィンドウ下部に [M5Stack-ATOM] と表示されていることを確認。

## ライブラリのインクルード

1. メニューの [スケッチ] > [ライブラリをインクルード] > [ライブラリを管理...] をクリック。

1. "M5Atom" で検索。

1. 表示された "M5Atom" を [インストール]。

1. "Dependencies for library M5Atom" というウィンドウが表示されたら [Install all] をクリック。

1. インストールが完了したらライブラリマネージャを閉じる。

## スケッチの書き込みと動作確認

1. メニューの [ツール] > [シリアルポート] で ATOM Lite の COM 番号をクリック。

1. ウィンドウ下部に選択した COM 番号が表示されていることを確認。

1. メニューの [ファイル] >  [スケッチ例] > [M5Atom] > [Basics] > [Button] をクリック。

1. ツールバーの左から2番目にある右矢印か、メニューの [スケッチ] >  [マイコンボードに書き込む] をクリック。 (`Ctrl + U` でも可)

1. "ボードへの書き込みが完了しました。" が表示されるまで待つ。

1. 書き込みが完了したら ATOM Lite のボタンを押し LED の色が変わることを確認。

以上で ATOM Lite を使う準備が整った。

## リビルドが遅い場合の設定

同じスケッチで2回目以降のビルドが遅い場合は、以下のサイトを参考に設定すると良い。

[Arduino IDEのビルドを速くする｜オブジェクトファイルの出力先を固定する \| ハングスタック](https://hangstuck.com/arduino-buildpath-fix/){:target="_blank"}
