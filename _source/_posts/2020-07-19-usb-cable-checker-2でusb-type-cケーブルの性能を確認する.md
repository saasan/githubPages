---
layout: post
title: USB CABLE CHECKER 2 で USB Type-C ケーブルの性能を確認する
date: 2020-07-19 09:00:00 +0900
category: blog
tags: [ ガジェット ]
description: 90W USB PD 充電器を買ったので、現在持っている USB Type-C ケーブルの性能を確認してみた。
---

先日 RAVPower 製 90W USB PD 充電器 RP-PC128 を買いました。
同じく RAVPower 製の 61W USB PD 充電器 PR-PC112 を持っていたのですが、
65W を要求する Dell 製ノート PC に給電しながら電源を入れると
途中で電力が足りない旨メッセージが表示されて起動が一時停止したり、
Windows 10 起動後も電力不足の通知が表示されるという状態で煩わしかったためです。

eMarker 付きのケーブルを持っていなかったので
RAMPOW という謎のメーカーの PD 3.0 / USB 3.1 Gen2 対応を謳う USB Type-C ケーブルと
Bit Trade One の
[USB CABLE CHECKER 2 (ADUSBCIM)](https://bit-trade-one.co.jp/adusbcim/){:target="_blank"}
もついでに購入しました。

RAMPOW は [Web サイト](https://rampow.com/){:target="_blank"} を見ても本社所在地や電話番号等が一切書かれておらず怪しげなメーカーという印象だったため、
ケーブルを使用する前に念の為 USB CABLE CHECKER 2 で確認しようという寸法です。
(※購入後に気付いたのですが、RAMPOW の
[Amazon出品者プロフィール](https://www.amazon.co.jp/sp?_encoding=UTF8&seller=A2RPIWYAIJTBUL){:target="_blank"}
に住所と電話番号が書かれていました。中国深センの会社のようです。)

<div class="affiliate-product-list">
    <a href="https://www.amazon.co.jp/dp/B0872MGDR2?tag=saasan-22" target="_blank" class="affiliate-product">
        <span class="affiliate-product-name">RAVPower 製 90W USB PD 充電器</span>
    </a>
    <a href="https://www.amazon.co.jp/dp/B0827NDHBQ?tag=saasan-22" target="_blank" class="affiliate-product">
        <img src="https://m.media-amazon.com/images/I/712PgRPfyEL._AC_SX522_.jpg" alt="RAMPOW USB-C &amp; USB-C ケーブル【100W PD対応/USB 3.2 Gen 2x2-20Gbpsデータ転送】PD3.0/QC3.0超高速充電 4K/60Hz 映像出力対応 超高耐久 type-cケーブル iPhone16/iPhone15シリーズ充電ケーブル MacBook Pro/iPad Pro/Google Pixel等タイプC対応 在宅勤務/出張支援 ネイビー 2M">
        <span class="affiliate-product-name">RAMPOW USB-C &amp; USB-C ケーブル【100W PD対応/USB 3.2 Gen 2x2-20Gbpsデータ転送】PD3.0/QC3.0超高速充電 4K/60Hz 映像出力対応 超高耐久 type-cケーブル iPhone16/iPhone15シリーズ充電ケーブル MacBook Pro/iPad Pro/Google Pixel等タイプC対応 在宅勤務/出張支援 ネイビー 2M</span>
    </a>
    <a href="https://www.amazon.co.jp/dp/B07Y8BPVV4?tag=saasan-22" target="_blank" class="affiliate-product">
        <img src="https://m.media-amazon.com/images/I/81MTfycxcnL._AC_SX522_.jpg" alt="BitTradeOne ADUSBCIM USB CABLE CHECKER 2">
        <span class="affiliate-product-name">BitTradeOne ADUSBCIM USB CABLE CHECKER 2</span>
    </a>
</div>

## RAMPOW 製ケーブル RAD03

さっそく RAMPOW 製ケーブルを確認してみます。

![RAMPOW 製ケーブル RAD03](/assets/images/blog/2020-07-19/rampow.jpg)

USB CABLE CHECKER 2 の表示は以下の通り。

    GND+VBUS=188mΩ
    CC:DOWN1K/E-MARKED
    SHELL-GND SHORT(A&B)

表示の意味については
[取扱説明書](https://github.com/bit-trade-one/USBCableChecker2/blob/master/README.md){:target="_blank"}
に記載されています。

> [DOWN1K/E-MARKED]
>
> Cプラグ内にGND-VCONN間に接続された1kΩの抵抗器を持ちます。
>
> これにより接続先USB機器にEマーカーIC内蔵ケーブルということを通知します。

> [SHELL-GND SHORT(SIDE)]
>
> プラグシェルがGNDと導通している場合表示されます。()内は導通している側のコネクタがA,Bどちらかを表します。
>
> 両側のコネクタが導通している場合はA&Bと表示されます。
>
> なお、タイプC-Cケーブルでは規格でGNDとシェルが接続されることが定められています。

<samp>CC:DOWN1K/E-MARKED</samp> は eMarker 内蔵、
<samp>SHELL-GND SHORT(A&B)</samp> は両側のプラグシェルが GND と導通していることを示しています。

eMarker が内蔵されているため 3A を超える電流が流せます。
connection のランプも全点灯しており、PD 3.0 / USB 3.1 Gen2 対応を謳うケーブルとして特に問題なさそうです。

## RAVPower 製充電器 RP-PC128 付属ケーブル

購入時に気付いてなかったのですが、
RP-PC128 にも 1.5m の Type-C ケーブルが付属していたためこれも確認してみます。

![RAVPower 製 90W USB PD 充電器 RP-PC128 付属ケーブル](/assets/images/blog/2020-07-19/ravpower.jpg)

    GND+VBUS=170mΩ
    CC:DOWN1K/E-MARKED
    SHELL-GND SHORT(A&B)

eMarker が内蔵されているため 3A を超える電流が流せます。
connection のランプは USB 2.0 の部分と CC (Configuration Channel) が点灯しています。
USB 2.0 対応の PD ケーブルとして使えるようです。

電源ケーブルとして使うならこれで十分ですね。
<del>RAMPOW のケーブルいらなかったのでは？</del>

## Lenovo Yoga Book C930 付属ケーブル

手元にあったほかの USB Type-C ケーブルも確認してみます。

![Lenovo Yoga Book C930 付属ケーブル](/assets/images/blog/2020-07-19/lenovo.jpg)

    GND+VBUS=212mΩ
    SHELL-GND SHORT(A&B)

eMarker が内蔵されていないため 3A までの電流しか流せません。
connection のランプは USB 3.2 が一部点灯しています。

USB 3.0, 3.1 では TX1/RX1 と TX2/RX2 のどちらかが繋がっていれば良いようです。
USB 3.2 Gen 2x2 では TX1, TX2, RX1, RX2 のすべてを使用してより高速な通信を行うため、このケーブルは利用できません。

SBU (Sideband Use) は USB では使用されず、
DisplayPort 出力や Thunderbolt などの Alternate Mode に使われる信号線のようです。

USB 3.1 対応の PD ケーブルとしては使えそう。

## One-Netbook OneMix3S 付属ケーブル

![One-Netbook OneMix3S 付属ケーブル](/assets/images/blog/2020-07-19/onemix3s.jpg)

    GND+VBUS=225mΩ

<samp>SHELL-GND SHORT(A&B)</samp> の表示がない……。
規格に従ってないケーブルのようです。
これは使わないほうがよさそう。

## まとめ

RAVPower 製 90W USB PD 充電器 RP-PC128 と RAMPOW 製ケーブル RAD03 の組み合わせで、
65W を要求する Dell 製ノート PC が問題なく充電できました。

RP-PC128 は MacBook 付属の 61W USB-C 充電器と比べて
サイズがひと回り小さい (65 x 65 x 32 mm) ため持ち運びやすく、
90W の大出力により充電できる機器の幅が広がります。

また、電力に余裕があるため、BUFFALO の
5-in-1 ドッキングステーション LUD-U3-CGD/N
を間にはさんでも安定して動作しています
(61W 出力の PR-PC112 を使用したときは有線 LAN の通信がブツブツ切れていた)。
ケーブル1本で電源、ディスプレイ、有線 LAN、キーボードが繋がるのは便利です。

<div class="affiliate-product-list">
    <a href="https://www.amazon.co.jp/dp/B081ZZGWR7?tag=saasan-22" target="_blank" class="affiliate-product">
        <img src="https://m.media-amazon.com/images/I/51cDDhpM8AL._AC_SY355_.jpg" alt="バッファロー BUFFALO USB Type-C接続 5-in-1 ドッキングステーション LUD-U3-CGD/N PowerDelivery 有線LAN HDMI VGA USB 3.2(Gen 1)対応ポート【Macbook/Surface メーカー動作確認済み】ラップトップパソコン対応">
        <span class="affiliate-product-name">バッファロー BUFFALO USB Type-C接続 5-in-1 ドッキングステーション LUD-U3-CGD/N PowerDelivery 有線LAN HDMI VGA USB 3.2(Gen 1)対応ポート【Macbook/Surface メーカー動作確認済み】ラップトップパソコン対応</span>
    </a>
</div>

今回購入した RAMPOW 製ケーブルは問題ありませんでしたが、
手持ちの OneMix3S 付属ケーブルが規格違反だったのは意外でした。
USB Power Delivery では高電圧、大電流が流れるため、
ケーブル購入の際は信頼できるメーカーのものを選んだほうがよさそうです。

## 参考サイト

- [USBCableChecker2/README.md at master · bit-trade-one/USBCableChecker2](https://github.com/bit-trade-one/USBCableChecker2/blob/master/README.md){:target="_blank"}
- [ASCII.jp：USB 4の発表で、USB 3.2はどうなった？ (1/5)](https://ascii.jp/elem/000/001/848/1848727/){:target="_blank"}
- [USB 3.2とUSB4は従来のUSB規格から何が変わるのか？ 混乱しがちなUSBの最新事情を説明しよう - 4Gamer.net](https://www.4gamer.net/games/999/G999902/20190403022/){:target="_blank"}
- [USB Type-Cに置き換える方法 第1話 Type-Cの原理を知る \| 組込み技術ラボ](https://lab.fujiele.co.jp/articles/8968/){:target="_blank"}
