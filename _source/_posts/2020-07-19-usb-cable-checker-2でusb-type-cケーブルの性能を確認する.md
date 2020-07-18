---
layout: page
title: USB CABLE CHECKER 2 で USB Type-C ケーブルの性能を確認する
date: 2020-07-19 08:30:00 +0900
category: blog
tags:
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
[USB CABLE CHECKER 2 (ADUSBCIM)](https://bit-trade-one.co.jp/adusbcim/)
もついでに購入しました。

RAMPOW は [Web サイト](https://rampow.com/) を見ても本社所在地や電話番号等が一切書かれておらず怪しげなメーカーという印象だったため、
ケーブルを使用する前に念の為 USB CABLE CHECKER 2 で確認しようという寸法です。
(※購入後に気付いたのですが、RAMPOW の
[Amazon出品者プロフィール](https://www.amazon.co.jp/sp?_encoding=UTF8&seller=A2RPIWYAIJTBUL)
に住所と電話番号が書かれていました。中国深センの会社のようです。)

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=tf_til&t=saasan-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B0872MGDR2&linkId=fac28b4b22c51e4280bc86287fd8dd0a&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr"></iframe>

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=tf_til&t=saasan-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B0827NDHBQ&linkId=bc50d175b4811fb8739a0a5d77f6be35&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr"></iframe>

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=tf_til&t=saasan-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B07Y8BPVV4&linkId=b4348a77ed22af3503ea6572a01d34e9&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr"></iframe>

## RAMPOW 製ケーブル RAD03

さっそく RAMPOW 製ケーブルを確認してみます。

<a href="/img/blog/2020-07-19/rampow.jpg"><img src="/img/blog/2020-07-19/rampow.jpg"  alt="RAMPOW 製ケーブル RAD03"></a>

USB CABLE CHECKER 2 の表示は以下の通り。

<pre>GND+VBUS=188mΩ
CC:DOWN1K/E-MARKED
SHELL-GND SHORT(A&B)</pre>

表示の意味については
[取扱説明書](https://github.com/bit-trade-one/USBCableChecker2/blob/master/README.md)
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

##  RAVPower 製充電器 RP-PC128 付属ケーブル

購入時に気付いてなかったのですが、
RP-PC128 にも 1.5m の Type-C ケーブルが付属していたためこれも確認してみます。

<a href="/img/blog/2020-07-19/ravpower.jpg"><img src="/img/blog/2020-07-19/ravpower.jpg"  alt="RAVPower 製 90W USB PD 充電器 RP-PC128 付属ケーブル"></a>

<pre>GND+VBUS=170mΩ
CC:DOWN1K/E-MARKED
SHELL-GND SHORT(A&B)</pre>

eMarker が内蔵されているため 3A を超える電流が流せます。
connection のランプは USB 2.0 の部分と
[CC (Configuration Channel)](https://lab.fujiele.co.jp/articles/8968/) が点灯しています。
USB 2.0 対応の PD ケーブルとして使えるようです。

電源ケーブルとして使うならこれで十分ですね。
<del>RAMPOW のケーブルいらなかったのでは？</del>

##  Lenovo Yoga Book C930 付属ケーブル

手元にあったほかの USB Type-C ケーブルも確認してみます。

<a href="/img/blog/2020-07-19/lenovo.jpg"><img src="/img/blog/2020-07-19/lenovo.jpg"  alt="Lenovo Yoga Book C930 付属ケーブル"></a>

<pre>GND+VBUS=212mΩ
SHELL-GND SHORT(A&B)</pre>

eMarker が内蔵されていないため 3A までの電流しか流せません。
connection のランプは USB 3.2 が一部点灯しています。

[USB 3.0, 3,1 では TX1/RX1 と TX2/RX2 のどちらかが繋がっていれば良い](https://ascii.jp/elem/000/001/848/1848727/index-2.html)
ようです。
USB 3.2 では TX1/RX1 と TX2/RX2 の2レーンを使用して高速な通信を行う USB 3.2 Gen 2x2 というモードがありますが、このケーブルでは利用できません。

USB 3.1 対応の PD ケーブルとして使えそう。

##  One-Netbook OneMix3S 付属ケーブル

<a href="/img/blog/2020-07-19/onemix3s.jpg"><img src="/img/blog/2020-07-19/onemix3s.jpg"  alt="One-Netbook OneMix3S 付属ケーブル"></a>

<pre>GND+VBUS=225mΩ</pre>

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

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=tf_til&t=saasan-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B081ZZGWR7&linkId=9a6e62087527f859adc8ac8b19af537f&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr"></iframe>

今回購入した RAMPOW 製ケーブルは問題ありませんでしたが、
手持ちの OneMix3S 付属ケーブルが規格違反だったのは意外でした。
USB Power Delivery では高電圧、大電流が流れるため、
ケーブル購入の際は信頼できるメーカーのものを選んだほうがよさそうです。
