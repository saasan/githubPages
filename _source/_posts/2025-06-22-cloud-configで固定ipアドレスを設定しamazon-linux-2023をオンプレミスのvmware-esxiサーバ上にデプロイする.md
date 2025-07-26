---
layout: post
title: cloud-config で固定 IP アドレスを設定し Amazon Linux 2023 をオンプレミスの VMware ESXi サーバ上にデプロイする
date: 2025-06-22 09:55:00 +0900
category: blog
tags: [ VMware, ESXi, Amazon Linux 2023, cloud-config ]
description:
---

AWS の公式ドキュメントが分かりづらい上に面倒な手順となっているため、
簡単にデプロイできる手順をメモしておく。

## Amazon Linux 2023 OVA ファイルのダウンロード

[KVM、VMware、Hyper-V で使用する Amazon Linux 2023 イメージをダウンロードする - Amazon Linux 2023](https://docs.aws.amazon.com/ja_jp/linux/al2023/ug/outside-ec2-download.html){:target="_blank"}
に書かれている
[cdn.amazonlinux.com](https://cdn.amazonlinux.com/al2023/os-images/latest/){:target="_blank"}
から VMware 用の OVA ファイルをダウンロードする。

## ovftool のダウンロードとインストール

[ovftool](https://developer.broadcom.com/tools/open-virtualization-format-ovf-tool/latest){:target="_blank"}
をダウンロード・展開しパスを通しておく。
base64 コマンドを使用するため、Windows 環境の場合は WSL に Linux 版を入れいると楽。

## cloud-config ファイルの準備

[公式の手順](https://docs.aws.amazon.com/ja_jp/linux/al2023/ug/seed-iso.html){:target="_blank"}
だと `meta-data`, `user-data`, `network-config` の3ファイルを用意し
`seed.iso` ディスクイメージを作成するが、
`network-config` と `seed.iso` は不要。

以下のように `meta-data` と `user-data` を作成し、
`meta-data` にネットワーク設定を記載すればよい。

meta-data.yaml
```yaml
#cloud-config
local-hostname: al2023-server

network:
  version: 2
  ethernets:
    ens192:
      addresses:
        - 192.168.1.100/24
      routes:
        - to: 0.0.0.0/0
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

user-data.yaml
```yaml
#cloud-config
users:
  - default
  - name: ec2-user
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    groups: [wheel, adm, systemd-journal]
    ssh_authorized_keys:
      - ssh-rsa ssh-key

timezone: Asia/Tokyo
locale: ja_JP.UTF-8
```

## ovftool を使用したデプロイ

仮想マシンの構成パラメータ `guestinfo.metadata` 等に作成済みの cloud-config を指定し、
ovftool で OVA ファイルを ESXi サーバにデプロイする。

`guestinfo.metadata` 等は `--extraConfig` を使用して指定する。
AI に聞くと `--prop` で指定する方法を提案されるがそれは誤り。

```shell
ovftool \
  --name=al2023-server \
  --datastore=datastore1 \
  --diskMode=thin \
  --network="VM Network" \
  --allowExtraConfig \
  --extraConfig:guestinfo.metadata="$(base64 -w0 meta-data.yaml)" \
  --extraConfig:guestinfo.metadata.encoding="base64" \
  --extraConfig:guestinfo.userdata="$(base64 -w0 user-data.yaml)" \
  --extraConfig:guestinfo.userdata.encoding="base64" \
  --powerOn \
  al2023-vmware_esx-2023.7.20250609.0-kernel-6.1-x86_64.xfs.gpt.ova \
  'vi://<YOUR_USER>@<ESXI_HOST_IP>'
```
