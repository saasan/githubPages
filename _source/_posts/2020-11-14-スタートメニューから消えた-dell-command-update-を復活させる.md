---
layout: page
title: スタートメニューから消えた Dell Command | Update を復活させる
date: 2020-11-14 00:46:11 +0900
category: blog
tags: PC
---

Dell Command \| Update を実行したあとにスタートメニューから Dell Command \| Update が消えることがある。

しばらく待っていれば自動で復活することもあれば復活しないこともある。
復活しないときは一度アンインストールして
[Dell のサイトからダウンロード](https://www.dell.com/support/article/ja-jp/sln311129/dell-command-update?lang=ja)
したものを入れ直していたが、けっこう手間がかかって面倒だった。
そもそもアプリの一覧に残ってるならもっと簡単に復活できるんじゃないか？

そう思ってスタートメニューだけ復活させる方法がないか調べたら以下の方法で復活できた。

 1. 管理者権限で PowerShell を起動する。
 1. 以下のコマンドを実行する。

        $ManifestPath = (Get-AppxPackage -AllUsers -Name "DellInc.DellCommandUpdate").InstallLocation + "\Appxmanifest.xml"
        Add-AppxPackage -Path $ManifestPath -Register -DisableDevelopmentMode

※Get-AppxPackage に -AllUsers オプションを付けて実行するのに管理者権限が必要。

参考 : [Add-AppxPackage (AppX) \| Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/module/appx/add-appxpackage?view=winserver2012r2-ps#example-2)
