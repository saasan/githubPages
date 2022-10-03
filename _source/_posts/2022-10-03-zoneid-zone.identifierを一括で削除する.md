---
layout: page
title: ZoneID (Zone.Identifier) を一括で削除する
date: 2022-10-03 18:30:00 +0900
category: blog
tags: [ Windows, WSL ]
description:
---

ネットからダウンロードしたファイルを WSL の Linux 環境にコピーすると
`〇〇:Zone.Identifier` というファイルが一緒にコピーされて煩わしい。

ファイルが1つだけならコピー前にファイルのプロパティから解除するかコピー後に削除すればいいが、
サブディレクトリ内なども含め複数まとめて処理したい場合は PowerShell を使う。

PowerShell で削除したいファイルがあるディレクトリに移動後に
以下のコマンドで Zone.Identifier があることを確認。

    Get-ChildItem -Recurse -File | Get-Item -Stream Zone.Identifier -ErrorAction SilentlyContinue

[Unblock-File](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.utility/unblock-file)
で削除できる。

    Get-ChildItem -Recurse -File | Get-Item -Stream Zone.Identifier -ErrorAction SilentlyContinue | Unblock-File

[Remove-Item -Stream Zone.Identifier](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.management/remove-item#7)
でもいい。
