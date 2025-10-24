---
layout: post
title: コマンドラインを使用した VMware ESXi ホストのパッチ適用
date: 2025-10-18 12:36:47 +0900
category: blog
tags: [ VMware, ESXi ]
description:
---

手順を忘れがちなのでメモしておく。

## 手順

- 事前に Broadcom のサイトからパッチをダウンロードしてデータストアに格納しておくこと
- SSH で接続できない場合は vCenter や Host Client の Web 画面から SSH のサービスを有効化すること

```bash
# バージョン確認
vmware -v
# メンテナンスモードへの移行
vim-cmd /hostsvc/maintenance_mode_enter
# ホストがメンテナンスモードか確認
vim-cmd /hostsvc/hostsummary | grep inMaintenanceMode
# プロファイルリストの表示
esxcli software sources profile list --depot /vmfs/volumes/datastore1/VMware-ESXi-8.0U3f-24784735-depot.zip
# ドライラン
esxcli software profile update --dry-run --profile ESXi-8.0U3f-24784735-standard --depot /vmfs/volumes/datastore1/VMware-ESXi-8.0U3f-24784735-depot.zip
# パッチ適用
esxcli software profile update --profile ESXi-8.0U3f-24784735-standard --depot /vmfs/volumes/datastore1/VMware-ESXi-8.0U3f-24784735-depot.zip
# ESXi ホストを再起動
esxcli system shutdown reboot -r 'apply patch'
```
再起動を待って SSH で再接続
```bash
# メンテナンスモードの終了
vim-cmd hostsvc/maintenance_mode_exit
# ホストがメンテナンスモードか確認
vim-cmd /hostsvc/hostsummary | grep inMaintenanceMode
# バージョン確認
vmware -v
```

## 参考サイト

[Patching ESXi host using Command Line](https://knowledge.broadcom.com/external/article/343840/patching-esxi-host-using-command-line.html){:target="_blank"}
