---
layout: post
title: Windows 11 の WSL で ext4 ファイルシステムのドライブの内容を確認する
date: 2025-02-23 03:20:00 +0900
category: blog
tags: [ Windows, WSL ]
description:
---

[WSL 2 で Linux ディスクのマウントを開始する](https://learn.microsoft.com/ja-jp/windows/wsl/wsl2-mount-disk){:target="_blank"}
の内容を自分用にまとめたやつ

1.  PowerShell でドライブを確認

    ```powershell
    GET-CimInstance -query "SELECT * from Win32_DiskDrive"
    ```

1.  PowerShell でドライブをマウント (要管理者権限)

    ```powershell
    wsl --mount \\.\PHYSICALDRIVE5 --bare
    ```

    PHYSICALDRIVE5 は確認したいドライブ

1.  WSL 内でパーティション番号とファイルシステムを確認

    ```shell
    lsblk -f
    sudo blkid
    ```

1.  PowerShell でパーティションをマウント

    ```powershell
    wsl --mount \\.\PHYSICALDRIVE5 --partition 1 --type ext4
    ```

1.  WSL 内でパーティションをマウント

    ```shell
    sudo mkdir /mnt/external
    sudo mount /dev/sdf1 /mnt/external
    ```

    sdf1 は確認したいパーティション

1.  ドライブの内容を確認

    ```shell
    ls /mnt/external
    ```

1.  WSL 内でマウント解除

    ```shell
    sudo umount /mnt/external
    ls /mnt/external
    ```

1.  PowerShell でマウント解除 (要管理者権限)

    ```powershell
    wsl.exe --unmount \\.\PHYSICALDRIVE5
    ```
