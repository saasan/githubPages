---
layout: post
title: M5StickC + Speaker Hat で音声データを再生する
date: 2020-05-25 10:59:30 +0900
category: blog
tags: [ M5Stack, M5StickC, ESP32 ]
---

M5StickC + Speaker Hat で音声や音楽を再生しようと思ったら
意外と情報が見つからなかったので再生方法をメモしておきます。

## 音声データの変換

まずは WAV や MP3 など再生したい音声データを
[【Arduino】WAVまたはMP3ファイルを再生する - おもちゃラボ](https://nn-hokuson.hatenablog.com/entry/2017/09/01/092945)
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

```cpp
#include <M5StickC.h>

// スピーカー出力ピンの番号
const uint8_t SPEAKER_PIN = GPIO_NUM_26;
// LOWでLED点灯、HIGHでLED消灯
const uint8_t LED_ON = LOW;
const uint8_t LED_OFF = HIGH;

// PWM出力のチャンネル
const uint8_t PWM_CHANNEL = 0;
// PWM出力の分解能
const uint8_t PWM_RESOLUTION = 8;
// PWM出力の周波数
const uint32_t PWM_FREQUENCY = getApbFrequency() / (1U << PWM_RESOLUTION);
// 音声データのサンプリング周波数(Hz)
const uint32_t SOUND_SAMPLING_RATE = 8000U;

// 音声データ
const uint8_t SOUND_DATA[] PROGMEM = {
    0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, …
};

// メッセージ出力
void showMessage(char *message) {
    M5.Lcd.fillScreen(TFT_BLACK);
    M5.Lcd.setCursor(5, 30);
    M5.Lcd.setTextFont(4);
    M5.Lcd.print(message);
}

void setup() {
    M5.begin();
    M5.Lcd.setRotation(1);
    showMessage("Sound");

    // スピーカーの設定
    ledcSetup(PWM_CHANNEL, PWM_FREQUENCY, PWM_RESOLUTION);
    ledcAttachPin(SPEAKER_PIN, PWM_CHANNEL);
    ledcWrite(PWM_CHANNEL, 0);

    // LEDの設定
    pinMode(M5_LED, OUTPUT);
    digitalWrite(M5_LED, LED_OFF);
}

void playMusic(const uint8_t* music_data, uint32_t sample_rate) {
    uint32_t length = strlen((char*)music_data);
    uint32_t delay_interval = ((uint32_t)1000000U / sample_rate);
    for (int i = 0; i < length; i++) {
        ledcWrite(PWM_CHANNEL, music_data[i]);
        delayMicroseconds(delay_interval);
    }
    ledcWrite(PWM_CHANNEL, 0);
}

void loop() {
    delay(10U);

    // ボタンの状態を更新
    M5.update();

    // ボタンが押された場合の処理
    if (M5.BtnA.wasPressed())
    {
        // LED点灯
        digitalWrite(M5_LED, LED_ON);
        // 音声データ再生
        playMusic(SOUND_DATA, SOUND_SAMPLING_RATE);
        // LED消灯
        digitalWrite(M5_LED, LED_OFF);
    }
}
```

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
- [【Arduino】WAVまたはMP3ファイルを再生する - おもちゃラボ](https://nn-hokuson.hatenablog.com/entry/2017/09/01/092945)
- [バイナリファイルをC言語のデータ配列に変換する：放課後マイコンクラブ：SSブログ](https://hello-world.blog.ss-blog.jp/2016-10-16)
- [ESP32のPWM出力は255が最大じゃなかった – Lang-ship](https://lang-ship.com/blog/work/esp32-pwm-max/)
- [PCM の基本](https://wisdom.sakura.ne.jp/system/winapi/media/mm5.html)
