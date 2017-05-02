---
layout: page
title: コマンドライン(CLI)でFortiGateを設定する
date: 2017-05-03 00:18:36 +0900
category: blog
---

## 概要

FortiGateはブラウザーでアクセスすることでWeb上からGUIで設定できる。
しかし、諸事情によりコマンドラインから設定することになったので、設定方法をメモしておく。

## ログインする

sshで接続することでコマンドラインから設定ができる。

    $ ssh admin@192.168.0.1

## ヘルプを表示する

「?」を入力すると現在使えるコマンドが表示される。

    # ? ←「?」を入力しても表示されない
    config      config object
    get         get dynamic and system information
    show        show configuration
    diagnose    diagnose facility
    execute     execute static commands
    exit        exit CLI

コマンドの入力途中に「?」を入力するとコマンドが補完される。
例えば、sh?と入力するとshowに補完される。

また、引数が必要なコマンドを入力した後に「?」を入力すると引数の候補が表示される。

## バージョンを確認する

    # get system status

## 設定を確認する

    # show

## デフォルト値を含むすべての設定を確認する

数メガバイトある設定が出力される為、かなり時間がかかるので注意。

    # show full-configuration

# moreを使用しない

コンソールへ設定を出力してバックアップを取りたいような場合は、
下記のコマンドでmoreを表示しないようにすることができる。

- moreを使用しないように変更

      # config system console
      # set output standard
      # end

- moreを使用するように戻す

      # config system console
      # set output more
      # end

## 設定を変更する

上記「設定を確認する」や「デフォルト値を含むすべての設定を確認する」で
表示されたものを見れば分かるが、設定はディレクトリのように階層化されている。
また、表示されたものがほぼそのまま設定用のコマンドになっている。

基本的に、

1. コマンド「config ○○○」で設定を行いたい階層に移動
1. コマンド「set △△△ ×××」で値を設定
1. コマンド「end」で設定を完了

という流れで設定する。上記「moreを使用しない」を参照。

## 設定を保存する

設定は自動的に保存される。
Cisco製品のように「write memory」などで明示的に保存する必要はない。

## 設定を終了し切断する

    # exit
