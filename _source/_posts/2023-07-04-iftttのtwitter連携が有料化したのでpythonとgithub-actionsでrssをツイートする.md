---
layout: post
title: IFTTT の Twitter 連携が有料化したので Python と GitHub Actions で RSS をツイートする
date: 2023-07-05 00:20:00 +0900
category: blog
tags: [ Twitter, Python, GitHub Actions ]
description: Github Actions の cache をデータの永続化に使う
---

IFTTT で動かしてた某ゲーム公式サイトの RSS をツイートするやつが
Twitter 連携の有料化によって動かなくなったため、
GitHub Actions で自作の Python スクリプトを動かして代用することにした。

コードは以下のリポジトリにある。

<a href="https://github.com/saasan/feed2tweet" target="_blank"><img src="https://github-link-card.s3.ap-northeast-1.amazonaws.com/saasan/feed2tweet.png" width="460px"></a>

## なぜ GitHub Actions なのか？

1. Public リポジトリなら無料で利用可能
2. 定期的な実行が可能
3. データの永続化に近いことが可能
4. GitHub Actions の利用経験がなかったため学習用として

RSS 内のどこまでツイートしたかを判別するためその情報を保存しておきたいが、
IFTTT を利用する前に調べた際は
無料で利用可能でデータの永続化が可能なサービスが見つからなかった記憶がある。

今回いくつかの候補の中から GitHub Actions について調べていたところ、
[Github Actionsのcacheをデータの永続化(?)に使う - MJHD](https://mjhd.hatenablog.com/entry/2022/06/04/104711){:target="_blank"}
を見て cache が永続化に利用できると知り GitHub Actions を利用することとした。

## Github Actions の cache

公式のドキュメント: 
[依存関係をキャッシュしてワークフローのスピードを上げる - GitHub Docs](https://docs.github.com/ja/actions/using-workflows/caching-dependencies-to-speed-up-workflows){:target="_blank"}

ファイルをキャッシュとして保存し、次回以降のワークフロー実行時に利用できる。

本来はビルドに必要なライブラリなど依存関係を保持しておき
ワークフローの実行を高速化するためのものだが、
データの永続化に利用することも可能。

ただし、7日間以上アクセスされていないキャッシュは削除される。容量は最大10 GB。

## キャッシュの利用方法

キャッシュを上書きすることはできないため、
保存時は常に新しいキャッシュを作成し、
読込時は最新のものを取得する必要がある。

以下のように key に新しいキーを指定することで新しいキャッシュを作成、
restore-keys に接頭辞のみ指定すると最新のものが取得できる。

{% raw %}
```yaml
- name: actions/cache用keyの生成
  run: echo "CACHE_TIMESTAMP=$(date +%s)" >> "$GITHUB_ENV"

- uses: actions/cache@v3
  id: tweeted
  with:
    path: ./tweeted
    key: tweeted-${{ env.CACHE_TIMESTAMP }}
    restore-keys: tweeted-
```
{% endraw %}

## 古いキャッシュの削除

前述の通り放置していても古いキャッシュは7日で消えるが、
新しいものから5個を残して削除することとした。

GitHub CLI の `gh cache` を使用している。

{% raw %}
```yaml
- name: Cleanup cache
  run: |
    # 新しいものから5個を残してキャッシュ削除
    gh cache list --key tweeted- --order asc --sort created_at --json id | \
      jq -r '.[0:-5][].id' | \
      xargs -r -I ID gh cache delete ID
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
{% endraw %}

## GitHub Actions での定期実行に関する注意点

以下のように schedule で10分毎に実行する設定としたが、
[公式のドキュメント](https://docs.github.com/ja/actions/using-workflows/events-that-trigger-workflows#schedule){:target="_blank"}
にも書かれている通り、負荷が高い場合は遅延したりそもそも実行されない場合がある。

```yaml
on:
  schedule:
    - cron: '3-59/10 * * * *'
```

実際半日で72回ほど動くはずが53回しか動いていなかった。
確実に動かしたいものは避けたほうがよい。
