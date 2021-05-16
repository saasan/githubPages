---
layout: page
title: M5StickC + Speaker Hat で SPIFFS から読み込んだ WAV ファイルを再生する
date: 2020-06-07 20:24:56 +0900
category: blog
tags: [ M5StickC, M5Stack, ESP32 ]
---

前回の
[M5StickC + Speaker Hat で音声データを再生する](/blog/2020/05/25/m5stickc-speaker-hat%E3%81%A7%E9%9F%B3%E5%A3%B0%E3%83%87%E3%83%BC%E3%82%BF%E3%82%92%E5%86%8D%E7%94%9F%E3%81%99%E3%82%8B.html)
では音声データを直接スケッチ上に書くというスマートとは言い難い方法でした。
今回は事前に SPIFFS へ保存した WAV ファイルを読み込んで再生します。

## WAV ファイルの作成

まずは再生したい音声データを以下の形式の WAV ファイルへ変換します。

- モノラル
- サンプリング周波数8000Hz
- Unsigned 8-bit PCM
- メタデータなし

スピーカーが1つなのでモノラル、
M5StickC (というか ESP32) の DAC が 8 ビットなので WAV ファイルも 8 ビットです。
サンプリング周波数は 8000Hz じゃなくてもいいかもしれませんが、
一般的に使用されている 44100Hz ではうまく動作しなかったためこの値にしています。

また、今回のスケッチではメタデータを一切考慮していないため、
メタデータがあるとシリアルモニタへ "invalid wave file header"
というエラーメッセージが表示されファイルが読み込まれません。

以下は
[FFmpeg](https://ffmpeg.org/)
で変換する場合のコマンド例です。
FFmpeg で変換すると「Lavf58.29.100」(数字部分はバージョンによる)
というメタデータが標準で追加されるので、
オプション <kbd>-fflags +bitexact</kbd> を付けてこの動作を抑制します。

    ffmpeg -i input.wav -ac 1 -ar 8000 -acodec pcm_u8 -fflags +bitexact output.wav

## WAV ファイルを SPIFFS へ保存する

[ESP32-WROOM-32 SPIFFS アップローダープラグインの使い方 \| mgo-tec電子工作](https://www.mgo-tec.com/blog-entry-spiffs-uploader-plugin-arduino-esp32.html)
に書かれている手順に従い、
[Arduino ESP32 filesystem uploader](https://github.com/me-no-dev/arduino-esp32fs-plugin)
を使用して事前に  WAV ファイルを SPIFFS へ保存しておきます。

## スケッチの書き込み

以下のスケッチを M5StickC へ書き込みます。
WAVE_FILE_NAME は SPIFFS へ保存した  WAV ファイルのファイル名です。
書き込み後、Aボタン(正面の「M5」ボタン)を押すと WAV ファイルが再生されます。

{% gist saasan/f03a6569138715d7d46a33e7a4d06e19 %}

## 参考サイト

- [ESP32-WROOM-32 SPIFFS アップローダープラグインの使い方 \| mgo-tec電子工作](https://www.mgo-tec.com/blog-entry-spiffs-uploader-plugin-arduino-esp32.html)
- [arduino-esp32/SPIFFS_Test.ino at master · espressif/arduino-esp32](https://github.com/espressif/arduino-esp32/blob/master/libraries/SPIFFS/examples/SPIFFS_Test/SPIFFS_Test.ino)
- [音ファイル（拡張子：WAVファイル）のデータ構造について](https://www.youfit.co.jp/archives/1418)
- [リニアPCMのWAVファイルを読み込む - yattのブログ](https://yatt.hatenablog.jp/entry/20090904/1252078381)
