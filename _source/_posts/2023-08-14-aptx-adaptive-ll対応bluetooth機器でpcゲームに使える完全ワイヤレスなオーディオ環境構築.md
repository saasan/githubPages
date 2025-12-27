---
layout: post
title: aptX Adaptive LL 対応 Bluetooth 機器で PC ゲームに使える完全ワイヤレスなオーディオ環境構築
date: 2023-08-14 23:07:00 +0900
category: blog
tags: [ ガジェット, PC ]
description:
---

PC でゲームをしたり音楽を聞いたりする際に有線のイヤホンを使用していたが、
ケーブルが煩わしく感じていたのでゲームに使える完全ワイヤレスイヤホンを探すことにした。

## aptX LL と aptX Adaptive

ある程度汎用的に使える Bluetooth 接続のものにしたいが、
Bluetooth のプロファイル A2DP で標準のコーデック SBC は音声の遅延が大きい。
ゲームに向いた低遅延のコーデックについて調べたところ、
aptX LL (Low Latency) と aptX Adaptive という規格があるらしい。

aptX LL は名前通り低遅延なコーデック、
aptX Adaptive はローレイテンシー (LL) モードとハイクオリティ (HQ) モードを切替可能。
aptX Adaptive の方が新しいコーデックだが、
aptX Adaptive のローレイテンシーモードよりも aptX LL の方が規格上の遅延は少ない。

よって、aptX LL 対応の機器を買おうとネット上で調べたり某家電量販店で探したが、
aptX LL 対応の機器が少なくいいものが見つからなかった。

## Creative BT-W5 と EarFun Air Pro 3 を購入 

結局 aptX Adaptive 対応の USB アダプタ
[Creative BT-W5](https://jp.creative.com/p/accessories/creative-bt-w5){:target="_blank"} と
完全ワイヤレスイヤホン EarFun Air Pro 3 を購入した。

<div class="affiliate-product-list">
    <a href="https://www.amazon.co.jp/dp/B0B1J2WTB2?tag=saasan-22" target="_blank" class="affiliate-product">
        <img src="https://m.media-amazon.com/images/I/41V33CRpvGL._AC_SY355_.jpg" alt="Creative BT-W4 Bluetooth トランスミッター USB オーディオ/チャット用アナログマイク付 aptX Adaptiveモデル HP-BTW4">
        <span class="affiliate-product-name">Creative BT-W4 Bluetooth トランスミッター USB オーディオ/チャット用アナログマイク付 aptX Adaptiveモデル HP-BTW4</span>
    </a>
    <a href="https://www.amazon.co.jp/dp/B0BNQ611R2?tag=saasan-22" target="_blank" class="affiliate-product">
        <img src="https://m.media-amazon.com/images/I/51mtle79kTL._AC_SX522_.jpg" alt="【VGP金賞】EarFun Air Pro 3 ANC搭載完全ワイヤレスイヤホン【Bluetooth 5.3 + 43dBまでノイズキャンセリング】QCC3071チップ搭載/aptX adaptive対応/超低遅延55ms/マルチポイント接続/専用アプリ/cVc8.0通話ノイズリダクション/最大45時間再生/ワイヤレス充電/IPX5防水(ブラック)">
        <span class="affiliate-product-name">【VGP金賞】EarFun Air Pro 3 ANC搭載完全ワイヤレスイヤホン【Bluetooth 5.3 + 43dBまでノイズキャンセリング】QCC3071チップ搭載/aptX adaptive対応/超低遅延55ms/マルチポイント接続/専用アプリ/cVc8.0通話ノイズリダクション/最大45時間再生/ワイヤレス充電/IPX5防水(ブラック)</span>
    </a>
</div>

BT-W5 は発売時の記事が印象に残っていたのと、
Sound Blaster 等 PC 用サウンド系パーツの老舗メーカーという安心感から選択。

クリエイティブストアのみでの販売なので、上のリンクは旧機種の BT-W4 にしている。
BT-W5 との違いは aptX HD、24bit/96kHz への対応の有無なので低遅延が目的ならどちらでもいい。

EarFun Air Pro 3 を選んだ理由は、1万円以下の完全ワイヤレスイヤホンで評判が良かったため。

[迫力サウンドと強力NCで8,990円! 信じられない超コスパTWS「EarFun Air Pro 3」 - AV Watch[Sponsored]](https://av.watch.impress.co.jp/docs/topic/special/1500373.html)

## 遅延時間の確認

遅延時間の確認には
[Latency Tester](https://nullvoxpopuli.github.io/latency-tester/){:target="_blank"}
を使用した。
Web サイト上で音に合わせてマウスをクリックするかスペースキーを押すことで簡易的に遅延時間を確認できる。

また、確認に使用した機器は以下の通り。

### アダプタ

| アダプタ | 対応コーデック |
| --- | --- |
| サンワサプライ MM-BTUD43 | SBC, aptX |
| Creative BT-W5 | SBC, aptX, aptX HD, aptX Adaptive |

### ヘッドホン / イヤホン

| ヘッドホン / イヤホン | 対応コーデック |
| --- | --- |
| EarFun Air Pro 3 | SBC, AAC, aptX Adaptive |
| Sony MDR-ZX770BN | SBC, AAC, aptX |
| FOSTEX TM2C | SBC, AAC, aptX |

### 確認結果

| アダプタ | ヘッドホン / イヤホン | コーデック | 遅延時間 |
| --- | --- | --- | --- |
| Creative BT-W5 | EarFun Air Pro 3 | aptX Adaptive LL | 100 ms |
| サンワサプライ MM-BTUD43 | Sony MDR-ZX770BN | aptX | 160 ms |
| Creative BT-W5 | Sony MDR-ZX770BN | SBC | 200 ms |
| Creative BT-W5 | FOSTEX TM2C | aptX | 335 ms |
| Creative BT-W5 | EarFun Air Pro 3 | aptX Adaptive HQ | 350 ms |

当然だが Creative BT-W5 と EarFun Air Pro 3
の組み合わせが最も遅延が少ない結果となった。

実際に PSO2 を遊んでみたがアクションゲームで使用するなら特に問題なさそうだった。
音ゲーはやってないからわからない。

## 問題点

低遅延という点では満足な結果だったが、
それ以外の点でいくつか問題があったので書いておく。

### Creative BT-W5

- PC からはスピーカーとして認識される
- よって Windows 標準の Bluetooth 設定画面からは機器との接続/切断ができず、 Creative 独自のアプリで操作する必要がある
- Windows 標準の Bluetooth 接続だと機器が切断されたら自動で別のスピーカー等へ音声出力が切り替わるが、それも行われないため手動で切り替えが必要
- 音量が大きいため Windows の音量設定を 1 ～ 5% あたりまで下げる必要があり細かい音量調整が効かない

### EarFun Air Pro 3

- 付属のイヤーピースが最大のものでも私には小さくはずれやすい
- タッチ操作のため誤タッチにより意図しない操作が発生する場合がある

## 参考サイト

- [aptX LL / Adaptive でやる音ゲー - う！](https://uzuky.hatenablog.com/entry/20201215/1608005651){:target="_blank"}
- [Creative BT-W5レビュー。aptX Adaptiveで24bit/96kHzや低遅延にできるトランスミッター - AndroPlus](https://androplus.org/entry/creative-bt-w5-review/){:target="_blank"}
