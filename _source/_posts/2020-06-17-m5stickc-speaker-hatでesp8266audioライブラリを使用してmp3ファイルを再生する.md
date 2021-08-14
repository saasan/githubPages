---
layout: page
title: M5StickC + Speaker Hat で ESP8266Audio ライブラリを使用して MP3 ファイルを再生する
date: 2020-06-17 19:59:34 +0900
category: blog
tags: [ M5Stack, M5StickC, ESP32, ESP8266Audio ]
---

前回の
[M5StickC + Speaker Hat で SPIFFS から読み込んだ WAV ファイルを再生する](/blog/2020/06/07/m5stickc-speaker-hat%E3%81%A7spiffs%E3%81%8B%E3%82%89%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%82%93%E3%81%A0wav%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E5%86%8D%E7%94%9F%E3%81%99%E3%82%8B.html)
では自力で WAV ファイルを読み込んでいましたが、
[ESP8266Audio](https://github.com/earlephilhower/ESP8266Audio)
というライブラリを用いることで ESP32-PICO 搭載の M5StickC でも MP3 が再生できることを教えて頂きました。
ということで、今回は事前に SPIFFS へ保存した MP3 ファイルを ESP8266Audio で読み込んで再生します。

## スケッチ

以下は A ボタン(正面の「M5」ボタン)を押すと MP3 ファイルが再生されるスケッチです。

{% gist saasan/ed2ee155ed1a16865015c1967cf875c3 %}

SPIFFS からファイルを読み込む AudioFileSourceSPIFFS クラス、
MP3 を再生する AudioGeneratorMP3 クラス、
I2S で出力する AudioOutputI2S クラスを使用しています。
ESP8266Audio は MP3 以外にも WAV, FLAC, MIDI, AAC などのファイル形式を読み込めるようになっており、
それぞれのファイル形式に対応した generator クラスを使用する必要があります。

generator->isRunning() で再生中か確認し、再生中でない場合にボタンが押されたら MP3 ファイルを再生しています。
一度再生が終わり generator->stop() を呼び出すとファイルが閉じられます。
そのため、2回目以降の再生時はファイルを再び開く必要があります。
source->isOpen() でファイルが開かれているかを確認し、
開かれていない場合は source->open() でファイルを開いています。

AudioFileSourceSPIFFS クラスでは再生する度にファイルを読み込むため、
ESP32-PICO のメモリ (520KB) に収まるサイズのファイルを何度も再生するのであれば、
以下のように setup() 内でファイルを読み込み
AudioFileSourcePROGMEM クラスを使用した方がよいかと思います。

{% gist saasan/b6d9cb8fc8786d9c0407560f6206af22 %}

## 自力での WAV ファイル再生との比較

前回行った自力での WAV ファイル再生では 8bit, 8000Hz 限定だったこともあり、
比較すると音質はかなり改善しましたが、
再生の前後にプチプチとノイズが入るようになりました。
また、コンパイルにかかる時間もかなり長くなっています。

コンパイル時間はどうしようもないと思いますが、
再生前後のプチプチは下記参考サイトのクリックノイズ対策を行えば消せるかもしれません。

## 参考サイト

- [earlephilhower/ESP8266Audio: Arduino library to play MOD, WAV, FLAC, MIDI, RTTTL, MP3, and AAC files on I2S DACs or with a software emulated delta-sigma DAC on the ESP8266 and ESP32](https://github.com/earlephilhower/ESP8266Audio)
- [ESP32でGoogle Play Musicを再生する - Qiita](https://qiita.com/odetarou/items/0f37ed2eeeb9bd051c0c)
- [ESP32でサウンド出力時のクリックノイズ対策（I2S+内蔵DAC） \| N.Yamazaki's blog](http://blog-yama.a-quest.com/?eid=970190)
