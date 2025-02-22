---
layout: page
title: Windows 11 の WSL で ext4 ファイルシステムのドライブの内容を確認する
date: 2025-02-23 03:20:00 +0900
category: blog
tags: [ Windows, WSL ]
description:
---

[WSL 2 で Linux ディスクのマウントを開始する](https://learn.microsoft.com/ja-jp/windows/wsl/wsl2-mount-disk)
の内容を自分用にまとめたやつ

1.  PowerShell でドライブを確認

        GET-CimInstance -query "SELECT * from Win32_DiskDrive"

1.  PowerShell でドライブをマウント (要管理者権限)

        wsl --mount \\.\PHYSICALDRIVE5 --bare

    PHYSICALDRIVE5 は確認したいドライブ

1.  WSL 内でパーティション番号とファイルシステムを確認

        lsblk -f
        sudo blkid

1.  PowerShell でパーティションをマウント

        wsl --mount \\.\PHYSICALDRIVE5 --partition 1 --type ext4

1.  WSL 内でパーティションをマウント

        sudo mkdir /mnt/external
        sudo mount /dev/sdf1 /mnt/external

    sdf1 は確認したいパーティション

1.  ドライブの内容を確認

        ls /mnt/external

1.  WSL 内でマウント解除

        sudo umount /mnt/external
        ls /mnt/external

1.  PowerShell でマウント解除 (要管理者権限)

        wsl.exe --unmount \\.\PHYSICALDRIVE5
