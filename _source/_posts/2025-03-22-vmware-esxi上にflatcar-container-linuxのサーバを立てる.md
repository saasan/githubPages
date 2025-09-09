---
layout: post
title: VMware ESXi 上に Flatcar Container Linux のサーバを立てる
date: 2025-03-22 23:55:00 +0900
category: blog
tags: [ VMware, ESXi, Flatcar Container Linux ]
description: VMware ESXi 上に Flatcar Container Linux のサーバを立てた際のメモ
---

ChatGPT に Docker コンテナの実行・運用に最適な OS を聞いたところ、
その中のひとつに「Flatcar Container Linux」があった。
気になったのでとりあえず VMware ESXi 上にサーバを立ててみた。

## Flatcar Container Linux とは？

Flatcar Container Linux は、コンテナの運用に特化した軽量 Linux ディストリビューションである。
自動更新機能を備え、シンプルな構成でセキュリティと安定性を重視している。

### 特徴

- **自動アップデート**: システムのアップデートが自動で適用され、セキュリティと安定性を確保する。
- **イミュータブルな設計**: ルートファイルシステムが書き換え不可のため、一貫性が保たれ、運用時のトラブルを低減できる。

本記事では、VMware ESXi 上に Flatcar Container Linux を導入する手順を解説する。

## 事前準備

作業 PC にて事前に以下を準備しておく。

### VMware 用 OVA ファイルのダウンロード

OVA ファイルのダウンロード元は、以下の公式ドキュメントに書かれている。

- [Running Flatcar Container Linux on VMware](https://www.flatcar.org/docs/latest/installing/cloud/vmware/){:target="_blank"}

### OVF Tool のインストール

仮想マシン作成時に Base64 エンコードした設定ファイルを指定する必要がある。
GUI でも構築可能だが、CLI で
[OVF Tool](https://developer.broadcom.com/tools/open-virtualization-format-ovf-tool/latest){:target="_blank"}
を使用したほうが楽。

## Butane 設定ファイルを作成

Butane 設定ファイル (`butane_config.yaml`) を作成する。
以下は静的 IP アドレスとホスト名、SSH 公開鍵の設定例である。

```yaml
variant: flatcar
version: 1.0.0

passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - SSH公開鍵

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

エラーメッセージが表示されなければ問題なし。

## OVF Tool で Ignition 設定ファイルを指定して起動

作業 PC にて ovftool を実行する。
オプションとして Ignition 設定ファイルを指定し
ESXi サーバ上で仮想マシンを作成・起動する。

`vi://～` は デプロイ先の ESXi サーバの情報。

```shell
ovftool \
  --name=testvm \
  --datastore=datastore1 \
  --diskMode=thin \
  --network="VM Network" \
  --allowExtraConfig \
  --extraConfig:guestinfo.ignition.config.data="$(base64 -w0 ignition_config.json)" \
  --extraConfig:guestinfo.ignition.config.data.encoding="base64" \
  --powerOn \
  --overwrite --powerOffTarget \
  --X:waitForIp \
  flatcar_production_vmware_ova.ova \
  'vi://<YOUR_USER>@<ESXI_HOST_IP>'
```

実行後、コンソール上に設定した IP アドレスが表示されれば OK。
SSH で接続し `docker` コマンドも実行できた。

## Docker サービスの自動起動設定

標準状態では Docker サービスが無効となっている。

Flatcar は自動アップデート機能があり、システムが自動的に再起動することがある。
この時、Docker サービスが無効のままだと、再起動後にコンテナが自動で立ち上がらない。

### 必要な設定

#### Docker サービスの有効化

[Permanently running a container](https://www.flatcar.org/docs/latest/container-runtimes/getting-started-with-docker/#permanently-running-a-container){:target="_blank"}
に書かれている設定を追加し Docker サービスを有効化する。

#### コンテナの再起動ポリシー設定

コンテナ作成時に `--restart=always` または `--restart=unless-stopped` オプションを指定する。

## Docker Compose の追加

Flatcar では `systemd-sysext` を利用して機能を拡張する仕組みになっている。
Docker Compose を利用するには、以下の公式ドキュメントを参考に Butane 設定ファイルを変更する。

- [Docker-compose sysext \| sysext-bakery](https://flatcar.github.io/sysext-bakery/docker_compose/){:target="_blank"}

また、利用可能な Docker Compose のバージョンは以下で確認できる。

- [Release docker-compose · flatcar/sysext-bakery](https://github.com/flatcar/sysext-bakery/releases/tag/docker-compose){:target="_blank"}

## 最終的な Butane 設定ファイル

```yaml
variant: flatcar
version: 1.0.0

passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - SSH公開鍵

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

    # Docker-compose sysext
    - path: /opt/extensions/docker-compose/docker-compose-2.39.2-x86-64.raw
      mode: 0644
      contents:
        source: https://extensions.flatcar.org/extensions/docker-compose-2.39.2-x86-64.raw
    - path: /etc/sysupdate.docker-compose.d/docker-compose.conf
      contents:
        source: https://extensions.flatcar.org/extensions/docker-compose.conf
    - path: /etc/sysupdate.d/noop.conf
      contents:
        source: https://extensions.flatcar.org/extensions/noop.conf

    # Dockerのアドレスプール設定
    - path: /etc/docker/daemon.json
      mode: 0644
      contents:
        inline: |
          {
            "default-address-pools": [
              {
                "base": "172.17.0.0/12",
                "size": 24
              }
            ]
          }

  links:
    # Dockerサービスの有効化
    - path: /etc/systemd/system/multi-user.target.wants/docker.service
      target: /usr/lib/systemd/system/docker.service
      hard: false
      overwrite: true

    # Docker-compose sysext
    - target: /opt/extensions/docker-compose/docker-compose-2.39.2-x86-64.raw
      path: /etc/extensions/docker-compose.raw
      hard: false

systemd:
  units:
    # Dockerサービスの有効化
    - name: docker.service
      enabled: true

    # Docker-compose sysext
    - name: systemd-sysupdate.timer
      enabled: true
    - name: systemd-sysupdate.service
      dropins:
        - name: docker-compose.conf
          contents: |
            [Service]
            ExecStartPre=/usr/bin/sh -c "readlink --canonicalize /etc/extensions/docker-compose.raw > /tmp/docker-compose"
            ExecStartPre=/usr/lib/systemd/systemd-sysupdate -C docker-compose update
            ExecStartPost=/usr/bin/sh -c "readlink --canonicalize /etc/extensions/docker-compose.raw > /tmp/docker-compose-new"
            ExecStartPost=/usr/bin/sh -c "if ! cmp --silent /tmp/docker-compose /tmp/docker-compose-new; then touch /run/reboot-required; fi"
```

Ignition の仕様的には `ignition.config.merge` で他のファイルを取り込むことができるようだが、
これを使用したところ OS が起動しなかったためベタ書きしている。

先ほど作成した仮想マシンを削除し再構築したところ、
無事 Docker Compose が利用できる環境ができあがった。

## 参考サイト

- [Running Flatcar Container Linux on VMware \| Flatcar Container Linux](https://www.flatcar.org/docs/latest/installing/cloud/vmware/){:target="_blank"}
- [Getting started with Docker \| Flatcar Container Linux](https://www.flatcar.org/docs/latest/container-runtimes/getting-started-with-docker/){:target="_blank"}
- [Getting Started \| Ignition](https://coreos.github.io/ignition/getting-started/#config-validation){:target="_blank"}
- [Getting started \| Butane](https://coreos.github.io/butane/getting-started/){:target="_blank"}
- [Network configuration with networkd](https://www.flatcar.org/docs/latest/setup/customization/network-config-with-networkd/){:target="_blank"}
- [Butane Config Transpiler](https://www.flatcar.org/docs/latest/provisioning/config-transpiler/){:target="_blank"}
- [Docker-compose sysext \| sysext-bakery](https://flatcar.github.io/sysext-bakery/docker_compose/){:target="_blank"}
- [Release docker-compose · flatcar/sysext-bakery](https://github.com/flatcar/sysext-bakery/releases/tag/docker-compose){:target="_blank"}
