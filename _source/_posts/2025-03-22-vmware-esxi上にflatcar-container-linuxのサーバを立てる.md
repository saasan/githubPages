---
layout: post
title: VMware ESXi 上に Flatcar Container Linux のサーバを立てる
date: 2025-03-22 23:55:00 +0900
category: blog
tags: [ VMware, ESXi, Flatcar Container Linux ]
description: VMware ESXi 上に Flatcar Container Linux のサーバを立てた際のメモ
---

ChatGPT に Docker コンテナの実行・運用に最適な OS を聞いたところ、
選択肢の一つとして「Flatcar Container Linux (CoreOS の後継)」があった。
気になったのでとりあえず VMware ESXi 上にサーバを立ててみた。

## Flatcar Container Linux とは？

Flatcar Container Linux は、コンテナの運用に特化した軽量 Linux ディストリビューションである。
自動更新機能を備え、シンプルな構成でセキュリティと安定性を重視している。

本記事では、VMware ESXi 上に Flatcar Container Linux を導入する手順を解説する。

## 事前準備

作業 PC にて事前に以下を準備しておく。

### VMware 用 OVA ファイルのダウンロード

OVA ファイルのダウンロード元は
[Running Flatcar Container Linux on VMware](https://www.flatcar.org/docs/latest/installing/cloud/vmware/)
に書かれている。

### ovftool のインストール

仮想マシン作成時に Base64 エンコードした設定ファイルを指定する必要がある。
GUI でも構築可能だが、CLI で ovftool を使用したほうが楽。

## Butane 設定ファイルを作成

Butane 設定ファイル (`butane_config.yaml`) を作成する。
以下は静的 IP アドレスとホスト名、SSH 公開鍵の設定例である。

```yaml
variant: flatcar
version: 1.0.0
storage:
  files:
    - path: /etc/systemd/network/00-static.network
      mode: 0644
      contents:
        inline: |
          [Match]
          Name=ens192
          [Network]
          Address=192.168.xxx.xxx/24
          Gateway=192.168.xxx.xxx
          DNS=192.168.xxx.xxx
          LinkLocalAddressing=no
          IPv6AcceptRA=no

    - path: /etc/hostname
      mode: 0644
      contents:
        inline: ホスト名

passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - SSH公開鍵
```

## Ignition 設定ファイルへトランスパイル

Butane 設定ファイルを Ignition 設定ファイル (`ignition_config.json`) へ変換する。

```shell
docker run --interactive --rm quay.io/coreos/butane:release --pretty --strict < butane_config.yaml > ignition_config.json
```

## Ignition 設定ファイルを検証

変換した `ignition_config.json` を検証する。

```shell
docker run --pull=always --rm -i quay.io/coreos/ignition-validate:release - < ignition_config.json
```

## ovftool で Ignition 設定ファイルを指定して起動

作業 PC にて ovftool を実行する。
オプションとして Ignition 設定ファイルを指定し
ESXi サーバ上で仮想マシンを作成・起動する。

`vi:///～` は デプロイ先の ESXi サーバの情報。

```shell
ovftool --name=testvm \
  --skipManifestCheck --noSSLVerify \
  --datastore=datastore1 --powerOn=True \
  --net:"VM Network=VM Network" --X:waitForIp \
  --overwrite --powerOffTarget \
  --X:guest:ignition.config.data=$(cat ignition_config.json | base64 --wrap=0) \
  --X:guest:ignition.config.data.encoding=base64 \
  ./flatcar_production_vmware_ova.ova \
  'vi:///<YOUR_USER>:<ESXI_PASSWORD>@<ESXI_HOST_IP>'
```

コンソール上に設定した IP アドレスが表示されていれば OK。
SSH で接続し Docker コマンドも実行できた。

## 参考サイト

- [Running Flatcar Container Linux on VMware](https://www.flatcar.org/docs/latest/installing/cloud/vmware/)
- [Getting Started \| Ignition](https://coreos.github.io/ignition/getting-started/#config-validation)
- [Getting started \| Butane](https://coreos.github.io/butane/getting-started/)
- [Network configuration with networkd](https://www.flatcar.org/docs/latest/setup/customization/network-config-with-networkd/)
- [Butane Config Transpiler](https://www.flatcar.org/docs/latest/provisioning/config-transpiler/)

