---
layout: page
title: M5StickC + Speaker Hat で音声データを再生する
date: 2020-05-25 10:59:30 +0900
category: blog
tags: [ M5Stack, M5StickC, ESP32 ]
---

M5StickC + Speaker Hat で音声や音楽を再生しようと思ったら
意外と情報が見つからなかったので再生方法をメモしておきます。

## 音声データの変換

まずは WAV や MP3 など再生したい音声データを
[【Arduino】WAVまたはMP3ファイルを再生する - おもちゃラボ](http://nn-hokuson.hatenablog.com/entry/2017/09/01/092945)
に書かれている方法で以下の形式へ変換します。

- モノラル
- サンプリング周波数8000Hz
- Unsigned 8-bit PCM
- ヘッダなし

## 配列化

その後C言語の配列に変換する必要がありますが、
Windows 環境では xxd コマンドがないため
[バイナリファイルをC言語のデータ配列に変換する：放課後マイコンクラブ：SSブログ](https://hello-world.blog.ss-blog.jp/2016-10-16)
の「PROGMEM作蔵さん」を使用して変換しました。

## スケッチへ貼り付けて書き込み

配列ができたら以下のスケッチの SOUND_DATA 部分に貼り付け、M5StickC へ書き込みます。
Aボタン(正面の「M5」ボタン)を押すと音声データが再生されます。

{% gist saasan/5ae9fc7ede308cd513e9769c4335c94f %}

playMusic 関数は公式の
[サンプルスケッチ](https://github.com/m5stack/M5StickC/blob/master/examples/Hat/SPEAKER/SPEAKER.ino)
のものですが、
そのままでは音声が正常に再生されなかったため
ledcWriteTone から ledcWrite へ変更しています。
(公式のサンプルスケッチが間違ってるとは思わなかったのでここでハマった。)

今回は短い音声の再生だったためスケッチにそのまま配列として書きましたが、
音声データ部分だけで500行を超えましたし、
配列への変換も面倒なのでファイルから読み込むようにしたいですね。
[SPIFFS](https://lang-ship.com/reference/unofficial/M5StickC/Storage/SPIFFS/)
を使えば実現できそう。

## 参考サイト

- [M5StickC/SPEAKER.ino at master · m5stack/M5StickC](https://github.com/m5stack/M5StickC/blob/master/examples/Hat/SPEAKER/SPEAKER.ino)
- [【Arduino】WAVまたはMP3ファイルを再生する - おもちゃラボ](http://nn-hokuson.hatenablog.com/entry/2017/09/01/092945)
- [バイナリファイルをC言語のデータ配列に変換する：放課後マイコンクラブ：SSブログ](https://hello-world.blog.ss-blog.jp/2016-10-16)
- [ESP32のPWM出力は255が最大じゃなかった – Lang-ship](https://lang-ship.com/blog/work/esp32-pwm-max/)
- [PCM の基本](http://wisdom.sakura.ne.jp/system/winapi/media/mm5.html)
