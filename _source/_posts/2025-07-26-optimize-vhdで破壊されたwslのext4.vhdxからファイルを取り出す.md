---
layout: post
title: Optimize-VHD に破壊された WSL の ext4.vhdx からファイルを取り出す
date: 2025-07-26 14:50:00 +0900
category: blog
tags: [ WSL ]
description: バックアップは取っとけ！
---

WSL の VHDX ファイルが 850GB くらいまで肥大化してたんで
Optimize-VHD を実行したら、ファイルが破損して WSL が起動しなくなった。
Windows 11 自体でのマウントや diskpart での認識、
Hyper-V マネージャーのディスクの検査、市販 VHD 修復ソフトの無料デモなど試したけどどれもダメ。

最近開発は全部 WSL 上でやってたうえに、
作りかけのものは GitHub に push しておらずバックアップなし。
数ヶ月の作業が消えてしまった…。

## 状況確認

諦めきれないので Claude に相談しつつ状況確認と復旧を試みる。

まずは ext4.vhdx をいつも使ってる Zorin OS へ持っていき `qemu-img info ext4.vhdx` を実行。  
※Zorin OS は Ubuntu 系 Linux ディストリビューション

```bash
$ sudo apt install libguestfs-tools qemu-utils
(略)
$ qemu-img info ext4.vhdx
qemu-img: VHDX BAT entry 5939 start offset 211707494400 points after end of file (27629977600). Image has probably been truncated.
qemu-img: Could not open 'ext4.vhdx': Could not open 'ext4.vhdx': Invalid argument
```

### Claude による解説

> このエラーメッセージは、VHDXファイルが**深刻に破損している**ことを示しています。
>
> #### エラーの詳細解析
>
> `VHDX BAT entry 5939 start offset 211707494400 points after end of file (27629977600)`
>
> **BAT (Block Allocation Table)**: VHDXファイル内のデータブロックの位置を管理するテーブル
>
> - **エントリ5939**: データブロック#5939の位置情報
> - **start offset 211707494400**: このブロックが211GB地点にあるとBAT記録
> - **end of file (27629977600)**: 実際のファイルサイズは約27GB
> - **問題**: 27GBしかないファイルの211GB地点を参照しようとしている
>
> `Image has probably been truncated`
>
> ファイルが途中で切断されている（不完全な状態）
>
> `Could not open 'ext4.vhdx': Invalid argument`
>
> QEMU/libguestfsがファイルを認識できない

うおお…

> **深刻に破損している**

終わった……

と思ったが Claude は部分的なデータ救出方法も提案してくれた。

## Claude による現実的な復旧方法の提案

> ### 期待できる救出レベル
> 
> - **完全復旧**: 困難（BAT破損のため）
> - **部分データ**: 可能性あり
> - **設定ファイル**: 救出可能かも
>
> ### 推奨アプローチ
>
> 1. **ddrescue**で読み取り可能な部分をコピー
> 2. 部分イメージから**testdisk/photorec**でファイル救出
> 3. 重要データのみ手動で救出
> 4. WSL環境は**再構築**
>
> ### データ救出の順序
>
> ```bash
> # 1. 部分コピー作成
> ddrescue -d -r3 ext4.vhdx recovered.raw recovery.log
>
> # 2. パーティション情報の確認
> testdisk recovered.raw
>
> # 3. ファイル救出
> photorec recovered.raw
> ```
>
> 残念ながら、このレベルの破損では完全復旧は困難です。部分的なデータ救出に焦点を当てることをお勧めします。

## データの救出

### ddrescue

`ddrescue -d -r3 ext4.vhdx recovered.raw recovery.log`

`ddrescue` は不良セクタの多いディスクを扱える dd の強化版みたいなものらしい
([Wikipedia](https://ja.wikipedia.org/wiki/Ddrescue){:target="_blank"} 調べ)。

`-d` が入力ファイルへのダイレクトディスクアクセス、`-r` が試行回数の指定。
問題なさそうなのでそのまま実行したあと、しばらく待つと `recovered.raw` が出力された。

### TestDisk

`testdisk recovered.raw`

`testdisk` は失われたパーティションの復元や壊れたファイルシステムの復元ができるらしい
([Wikipedia](https://ja.wikipedia.org/wiki/TestDisk){:target="_blank"} 調べ)。

実行してみたが ext4 パーティションの存在が確認できただけで、ファイルの救出には至らなかった。

### PhotoRec

`photorec recovered.raw`

`photorec` は失われたファイルを回復することができるらしい
([Wikipedia](https://ja.wikipedia.org/wiki/PhotoRec){:target="_blank"} 調べ)。

救出対象とするファイルは拡張子単位で指定可能だが、
今回はできる限り復旧したかったため指定せずに実行。
約15万ファイルが出力された。

救出されたファイルは `recup_dir.x` というディレクトリに
`fxxxxxxx.ext` というファイル名で出力される (`x` は数字)。
救出したかった JavaScript と JSON ファイルは
テキストファイル (`*.txt`) として出力されていた。

以下のように検索・コピーして、ファイルの一部を取り出すことができた。

```bash
# 検索
$ find recup_dir.* -name '*.txt' -print0 | xargs -0 grep -l '検索する文字列'
# コピー
$ find recup_dir.* -name '*.txt' -print0 | xargs -0 grep -l '検索する文字列' | xargs -I {} cp {} コピー先
```

## まとめ

ちゃんとバックアップは取ろう！
