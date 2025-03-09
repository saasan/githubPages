---
layout: post
title: M5StickC + Speaker Hat で SPIFFS から読み込んだ WAV ファイルを再生する
date: 2020-06-07 20:24:56 +0900
category: blog
tags: [ M5Stack, M5StickC, ESP32 ]
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

```shell
ffmpeg -i input.wav -ac 1 -ar 8000 -acodec pcm_u8 -fflags +bitexact output.wav
```

## WAV ファイルを SPIFFS へ保存する

[ESP32-WROOM-32 SPIFFS アップローダープラグインの使い方 \| mgo-tec電子工作](https://www.mgo-tec.com/blog-entry-spiffs-uploader-plugin-arduino-esp32.html)
に書かれている手順に従い、
[Arduino ESP32 filesystem uploader](https://github.com/me-no-dev/arduino-esp32fs-plugin)
を使用して事前に  WAV ファイルを SPIFFS へ保存しておきます。

## スケッチの書き込み

以下のスケッチを M5StickC へ書き込みます。
WAVE_FILE_NAME は SPIFFS へ保存した  WAV ファイルのファイル名です。
書き込み後、Aボタン(正面の「M5」ボタン)を押すと WAV ファイルが再生されます。

```cpp
#include <vector>
#include <M5StickC.h>
#include "FS.h"
#include "SPIFFS.h"

// WAVファイル名
const char WAVE_FILE_NAME[] = "/hoge.wav";

// スピーカー出力ピンの番号
const uint8_t SPEAKER_PIN = GPIO_NUM_26;
// LOWでLED点灯、HIGHでLED消灯
const uint8_t LED_ON = LOW;
const uint8_t LED_OFF = HIGH;
// 電源ボタンが1秒未満押された
const uint8_t AXP_WAS_PRESSED = 2;

// PWM出力のチャンネル
const uint8_t PWM_CHANNEL = 0;
// PWM出力の分解能(ビット数)
const uint8_t PWM_RESOLUTION = 8;
// PWM出力の周波数
const uint32_t PWM_FREQUENCY = getApbFrequency() / (1U << PWM_RESOLUTION);
// 音声データのサンプリング周波数(Hz)
const uint32_t SOUND_SAMPLING_RATE = 8000;
// 音声データ再生時の待ち時間(マイクロ秒)
const uint32_t DELAY_INTERVAL = 1000000 / SOUND_SAMPLING_RATE;

// WAVファイルのヘッダー
typedef struct {
    uint32_t riff;              // "RIFF" (0x52494646)
    uint32_t fileSize;          // ファイルサイズ-8
    uint32_t wave;              // "WAVE" (0x57415645)
    uint32_t fmt;               // "fmt " (0x666D7420)
    uint32_t fmtSize;           // fmtチャンクのバイト数
    uint16_t format;            // 音声フォーマット (非圧縮リニアPCMは1)
    uint16_t channels;          // チャンネル数
    uint32_t samplingRate;      // サンプリングレート
    uint32_t avgBytesPerSecond; // 1秒あたりのバイト数の平均
    uint16_t blockAlign;        // ブロックサイズ
    uint16_t bitsPerSample;     // 1サンプルあたりのビット数
    uint32_t data;              // "data" (0x64617461)
    uint32_t dataSize;          // 波形データのバイト数
} wavfileheader_t;
// PCMフォーマット
const uint16_t WAVE_FORMAT_PCM = 0x0001;
// モノラル
const uint16_t WAVE_MONAURAL = 0x0001;

// 音声データ
std::vector<uint8_t> soundData;


// メッセージ出力
void showMessage(const char* message) {
    M5.Lcd.fillScreen(WHITE);
    M5.Lcd.setCursor(5, 30);
    M5.Lcd.setTextFont(4);
    M5.Lcd.setTextColor(BLACK);
    M5.Lcd.print(message);
}

// バイトオーダーを入れ替える
uint32_t reverseByteOrder(uint32_t x) {
    return ((x << 24 & 0xFF000000U) |
            (x <<  8 & 0x00FF0000U) |
            (x >>  8 & 0x0000FF00U) |
            (x >> 24 & 0x000000FFU));
}

// WAVファイルのヘッダーを検証する
bool validateWavHeader(wavfileheader_t& header) {
    Serial.printf("riff: 0x%x\n", header.riff);
    Serial.printf("wave: 0x%x\n", header.wave);
    Serial.printf("fmt : 0x%x\n", header.fmt);
    Serial.printf("data: 0x%x\n", header.data);
    Serial.printf("format: %d\n", header.format);
    Serial.printf("channels: %d\n", header.channels);
    Serial.printf("samplingRate: %d\n", header.samplingRate);
    Serial.printf("bitsPerSample: %d\n", header.bitsPerSample);

    return  header.riff             == 0x52494646
            && header.wave          == 0x57415645
            && header.fmt           == 0x666D7420
            && header.data          == 0x64617461
            && header.format        == WAVE_FORMAT_PCM
            && header.channels      == WAVE_MONAURAL
            && header.samplingRate  == SOUND_SAMPLING_RATE
            && header.bitsPerSample == PWM_RESOLUTION;
}

// WAVファイルを読み込む
void readWavFile(fs::FS& fs, const char* path, std::vector<uint8_t>& data) {
    Serial.printf("Reading file: %s\n", path);

    File file = fs.open(path);
    if (!file || file.isDirectory()) {
        Serial.println("- failed to open file for reading");
        return;
    }

    // WAVファイルのヘッダー
    wavfileheader_t header;

    // ファイルサイズがヘッダーサイズ以下の場合は終了
    size_t fileSize = file.size();
    if (fileSize <= sizeof(header)) {
        Serial.println("invalid wave file");
        return;
    }

    // ヘッダーサイズ分読み込む
    file.read((uint8_t*)&header, sizeof(header));

    // バイトオーダーを入れ替え
    header.riff = reverseByteOrder(header.riff);
    header.wave = reverseByteOrder(header.wave);
    header.fmt  = reverseByteOrder(header.fmt);
    header.data = reverseByteOrder(header.data);

    // ヘッダーのチェック
    if (!validateWavHeader(header)) {
        Serial.println("invalid wave file header");
        return;
    }

    // ファイルの読み込み
    while (file.available()) {
        data.push_back(file.read());
    }
}

// 音声データを再生する
void playSound(std::vector<uint8_t>& soundData) {
    for (const auto& level : soundData) {
        ledcWrite(PWM_CHANNEL, level);
        delayMicroseconds(DELAY_INTERVAL);
    }

    ledcWrite(PWM_CHANNEL, 0);
}

void setup() {
    M5.begin();
    M5.Lcd.setRotation(1);
    showMessage("SPIFFS WAV");

    // シリアルモニターの設定
    Serial.begin(115200);

    // スピーカーの設定
    ledcSetup(PWM_CHANNEL, PWM_FREQUENCY, PWM_RESOLUTION);
    ledcAttachPin(SPEAKER_PIN, PWM_CHANNEL);
    ledcWrite(PWM_CHANNEL, 0);

    // LEDの設定
    pinMode(M5_LED, OUTPUT);
    digitalWrite(M5_LED, LED_OFF);

    // SPIFFSの設定
    if (!SPIFFS.begin()) {
        Serial.println("SPIFFS Mount Failed");
        return;
    }

    // 音声データを読み込む
    readWavFile(SPIFFS, WAVE_FILE_NAME, soundData);
}

void loop() {
    delay(10);

    // ボタンの状態を更新
    M5.update();

    // Aボタンが押されたら音声データ再生
    if (M5.BtnA.wasPressed()) {
        // LED点灯
        digitalWrite(M5_LED, LED_ON);
        // 音声データ再生
        playSound(soundData);
        // LED消灯
        digitalWrite(M5_LED, LED_OFF);
    }

    // 電源ボタンが押されたらリセット
    if (M5.Axp.GetBtnPress() == AXP_WAS_PRESSED) {
        esp_restart();
    }
}
```

## 参考サイト

- [ESP32-WROOM-32 SPIFFS アップローダープラグインの使い方 \| mgo-tec電子工作](https://www.mgo-tec.com/blog-entry-spiffs-uploader-plugin-arduino-esp32.html)
- [arduino-esp32/SPIFFS_Test.ino at master · espressif/arduino-esp32](https://github.com/espressif/arduino-esp32/blob/master/libraries/SPIFFS/examples/SPIFFS_Test/SPIFFS_Test.ino)
- [音ファイル（拡張子：WAVファイル）のデータ構造について](https://www.youfit.co.jp/archives/1418)
- [リニアPCMのWAVファイルを読み込む - yattのブログ](https://yatt.hatenablog.jp/entry/20090904/1252078381)
