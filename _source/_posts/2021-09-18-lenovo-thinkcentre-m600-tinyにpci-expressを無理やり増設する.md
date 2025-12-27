---
layout: post
title: Lenovo ThinkCentre M600 Tiny に PCI Express を無理やり増設する
date: 2021-09-18 13:04:35 +0900
category: blog
tags: [ PC ]
description: 超小型デスクトップPCで無理やりTVチューナーボードを使う
---

5年ほど前に組んだ自作 PC がスペック的につらくなってきたため
新しいものを組むことにしました。
PC 入れ替えにあたり、これまで1台で
ゲーム、開発、TV 録画などすべて行っていた状態から録画機能を切り離し、
録画専用 PC として分けることにしました。

目的は以下のとおりです。

- PC 交換時の録画への影響を最小限にする
- ゲームなどの高負荷による録画への影響を避ける
- 電力消費の少ない録画用 PC を常時起動しておき、メインの PC はいつでも電源を切れるようにする

## 使用 PC

録画用 PC には、ほとんど使わないまま放置していた
Lenovo ThinkCentre M600 Tiny
を使用することにしました。
昨年メルカリで 15,000 円で購入したやつです。

これは容積1リットルを謳う超小型デスクトップ PC で、
CPU は
[Intel Celeron J3060](https://ark.intel.com/content/www/jp/ja/ark/products/91534/intel-celeron-processor-j3060-2m-cache-up-to-2-48-ghz.html){:target="_blank"}
1.6GHz 2コア、TDP 6 W となっています。

## USB 接続の TV チューナーを購入したが…

M600 Tiny は前述の通り超小型デスクトップ PC のため、
今まで使用していた PCI Express (以下 PCI-E) 接続の TV チューナーボードが利用できません。
また、しばらくはメイン PC での録画と平行運用して様子をみたかったため、別途 USB 接続の TV チューナーを購入しました。

購入後1週間ほど使用してみましたが、
信号がドロップしているのか
時々ひどいブロックノイズが入り使い物になりません。
これは困りました。
PC を変えるか USB 接続でも安定する別のチューナーが必要です。

## PCI-E の TV チューナーを無理やり増設

もう1つ思いついたのが
今まで使用していた PCI-E 接続の TV チューナーボードを
無理やり M600 Tiny に取り付けるというものです。

最初は PCI-E を USB に変換するものがないか探していましたが、
M.2 の A & E キーに対応した以下の
M.2 → PCI-E x1 変換アダプタを見つけました。

<div class="affiliate-product-list">
    <a href="https://www.amazon.co.jp/dp/B07L9RFVBZ?tag=saasan-22" target="_blank" class="affiliate-product">
        <img src="https://m.media-amazon.com/images/I/51N8ZHiY7vL.__AC_SX300_SY300_QL70_ML2_.jpg" alt="NGFF PCI 変換アダプタ M.2キーA / E → PCI-E Express X1 + USBライザカード 高速FPCケーブル2本付き">
        <span class="affiliate-product-name">NGFF PCI 変換アダプタ M.2キーA / E → PCI-E Express X1 + USBライザカード 高速FPCケーブル2本付き</span>
    </a>
</div>

[M.2](https://ja.wikipedia.org/wiki/M.2){:target="_blank"}
は物理的な接続方法が異なるだけで
PCI-E の信号をそのまま送ることができます。
M600 Tiny には Wi-Fi の増設用と思われる
E キーに対応した M.2 スロットがあるため、
そこにこの変換アダプタを接続すれば問題なく使用できるはずです。

変換アダプタには 5 V と 12 V の電源を
FDD 4ピンコネクタで供給する必要があります。
光学ドライブなどに使用される4ピンペリフェラルコネクタから
FDD 4ピンコネクタへ変換するケーブルが付属していますが、
M600 Tiny にはどちらもありません。
そこで以下の変換ケーブルを購入し SATA から電源を取ることにしました。

<div class="affiliate-product-list">
    <a href="https://www.amazon.co.jp/dp/B0028WIES8?tag=saasan-22" target="_blank" class="affiliate-product">
        <img src="https://m.media-amazon.com/images/I/51yi6NatXRL.__AC_SX300_SY300_QL70_ML2_.jpg" alt="オウルテック 電源変換ケーブル12cm OWL-CBPU005">
        <span class="affiliate-product-name">オウルテック 電源変換ケーブル12cm OWL-CBPU005</span>
    </a>
</div>

SATA が使えなくなるため、ストレージはもともと付属していた SATA 接続の HDD をはずして M.2 の SSD にします。
(上記の Wi-Fi 用 M.2 とは別にもうひとつストレージ用の M.2 があります。)

## 完成

変換アダプタを購入して実際に接続してみました。
内部は以下のようになっています。

![PC 内部](/assets/images/blog/2021-09-18/thinkcentre-tiny-pci-express1.jpg)

背面の VGA (D-Sub 15 ピン) 端子が増設できる場所の板をはずして
ケーブルを外に出しています。

![ケーブルの外出し1](/assets/images/blog/2021-09-18/thinkcentre-tiny-pci-express2.jpg)

![ケーブルの外出し2](/assets/images/blog/2021-09-18/thinkcentre-tiny-pci-express3.jpg)

最後に TV チューナーボードを取り付けて以下のようになりました。
PC を起動して確認しましたが問題なく認識され使用できました！

![TV チューナーボードの取り付け](/assets/images/blog/2021-09-18/thinkcentre-tiny-pci-express4.jpg)

## まとめ

以上のように超小型デスクトップ PC で
PCI-E 接続の TV チューナーボードを利用できました。

Dell の Optiplex Micro も中身は似たような作りのため
おそらく同様に PCI-E のボードを増設できると思います。
HP の ProDesk DM や EliteDesk DM は中を見たことがないためわかりません。

基板がむき出しのため今後ホコリへの対策を考えます。
