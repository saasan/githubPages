---
layout: page
title: Stable Diffusion を Windows 10 へインストールする方法と使い方、画像生成のコツ
date: 2023-03-06 15:15:00 +0900
category: blog
tags: [Stable Diffusion]
description: Windows 10 へのインストール方法と使い方、画像生成のコツを紹介
---

Stable Diffusion を Windows 10 のローカル環境へインストールする方法と使い方、
1ヶ月ほど使ってみて分かった画像生成のコツをメモしておく。

## 実行環境

- Windows 10 Pro 22H2
- GPU: [MSI GeForce RTX 3060 GAMING X 12G](https://www.amazon.co.jp/dp/B08WPJ5P4R/?tag=saasan-22) (VRAM 12 GB 版 NVIDIA GeForce RTX 3060)
- CPU: [AMD Ryzen 5 5600X](https://www.amazon.co.jp/dp/B08166SLDF/?tag=saasan-22)
- メモリ: 32 GB

<div class="affiliate-product-list">
    <a href="https://www.amazon.co.jp/dp/B08WPJ5P4R/?tag=saasan-22" class="affiliate-product">
        <img src="https://m.media-amazon.com/images/I/811sBakp3+L._AC_SX355_.jpg" alt="MSI GeForce RTX 3060 GAMING X 12G グラフィックスボード VD7552">
        <span class="affiliate-product-name">MSI GeForce RTX 3060 GAMING X 12G グラフィックスボード VD7552</span>
    </a>
    <a href="https://www.amazon.co.jp/dp/B08166SLDF/?tag=saasan-22" class="affiliate-product">
        <img src="https://m.media-amazon.com/images/I/51ld6RR8IrL._AC_SY450_.jpg" alt="AMD Ryzen 5 5600X with Wraith Stealth cooler 3.7GHz 6コア / 12スレッド 35MB 65W【国内正規代理店品】 100-100000065BOX">
        <span class="affiliate-product-name">AMD Ryzen 5 5600X with Wraith Stealth cooler 3.7GHz 6コア / 12スレッド 35MB 65W【国内正規代理店品】 100-100000065BOX</span>
    </a>
</div>

ドライバー等は最新のものを使用。
あくまでも私が実行した環境のためこのスペックを満たしている必要はない。

Stable Diffusion web UI は VRAM 4 GB 以上をサポートしているが、
GPU と VRAM の容量は画像生成速度と解像度に影響するため高性能なものが望ましい。

また、Stable Diffusion は NVIDIA 製 GPU で動かす前提となっている。
AMD や Intel 製 GPU に対応させたものもあるようだが以下の手順では使えない。

## CUDA Toolkit のインストール

Stable Diffusion に限らず、NVIDIA の GPU で機械学習やディープラーニングを行うには
CUDA という並列計算のライブラリが必要。

[NVIDIA の公式サイト](https://developer.nvidia.com/cuda-downloads)
から CUDA Toolkit をダウンロードしインストールする。

## Python, Git のインストール

Stable Diffusion web UI (以下 web UI と略す) を利用するのが楽なので、
これを動かすのに必要な Python, Git をインストールする。

### Python のインストール

**3.11 系では web UI が動作しないため必ず 3.10 系をインストールすること。**

1.  [Python の公式サイト](https://www.python.org/downloads/windows/) から Python 3.10.x をダウンロードする。  
    現在は 3.10.10 が最新のため「Stable Releases」の「Python 3.10.10 - Feb. 8, 2023」にある
    「Windows installer (64-bit)」をクリックしてダウンロードすればよい。
2.  ダウンロードしたファイルをダブルクリックしてインストーラーを起動する。
3.  **「Add python.exe to PATH」にチェックを入れる。**
4.  「Install Now」をクリックしインストールする。

### Git のインストール

1.  [Git の公式サイト](https://git-scm.com/download/win) から 64-bit Git for Windows Setup をダウンロードする。
2.  ダウンロードしたファイルをダブルクリックしてインストーラーを起動する。
3.  英語で色々聞かれるが全部「Next」をクリックして進める。
4.  最後に「Install」すればとりあえず使える状態になる。

## Stable Diffusion web UI のインストール

1.  [Stable Diffusion web UI のページ](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
    から「Code > Download ZIP」でファイルをダウンロードする。  
    Git を使える人は `git clone` してもよい。
2.  ダウンロードした ZIP ファイルを展開する。  
    展開したフォルダがそのままインストール先となるため、インストールしたいフォルダに展開すればよい。
3.  展開したフォルダにある「webui-user.bat」を右クリックしてプロパティをクリックする。
4.  プロパティ下部「セキュリティ」の右にある「許可する」にチェックを入れて OK をクリックする。
5.  「webui-user.bat」をダブルクリックして起動する。 (管理者ではない一般ユーザーで実行してよい)
6.  必要なファイルが自動でダウンロード・インストールされるため完了するまで待つ。
7.  インストールと起動が完了したら `Running on local URL:  http://127.0.0.1:7860` が表示される。
8.  ブラウザで `http://127.0.0.1:7860` を開く。

## web UI 起動時にエラーが発生する場合

### RuntimeError: Cannot add middleware after an application has started.

web UI のバージョンによっては webui-user.bat を起動後に以下のエラーが表示される。

    RuntimeError: Cannot add middleware after an application has started

この場合はコマンドプロンプトで以下を実行してから再度 webui-user.bat を起動する。

    cd [web UIのインストール先パス]
    venv\Scripts\activate.bat
    pip install --upgrade fastapi==0.90.1

### loading stable diffusion model: OutOfMemoryError や torch.cuda.OutOfMemoryError: CUDA out of memory.

VRAM が不足しているときに表示される。  
webui-user.bat を起動する前にタスクマネージャーを起動しておき、
「パフォーマンス」タブで GPU の「専用 GPU メモリ使用量」が 100% になっていないか確認するとよい。

VRAM が不足している場合は `--lowvram` オプションを指定することで起動できる場合がある。  
「webui-user.bat」をテキストエディタで開き

    set COMMANDLINE_ARGS=

となっている部分を以下のように変更し保存する。

    set COMMANDLINE_ARGS=--lowvram

## テキストからの画像生成 (txt2img)

web UI の URL を開くと txt2img の画面となる。
txt2img は文章、単語などの言葉から画像を生成できる。

### Prompt, Negative prompt

Prompt へ描かせたいもの、Negative prompt へ描かせたくないものを英語で入力し、
「Generate」をクリックすれば画像が生成される。
複数の要素を指定したい場合はカンマ (,) 区切りで入力する。

定番の「馬に乗った宇宙飛行士の写真」を生成させるなら Prompt へ以下を入力すればよい。

    a photograph of an astronaut riding a horse

`()` または `[]` で言葉を囲むことで強調/抑制できる。

- `(言葉)`: 1.1倍強調
- `((言葉))`: 1.21倍強調 (= 1.1×1.1)
- `[言葉]`: 1.1倍抑制
- `(言葉:1.5)`: 1.5倍強調

参考: [Attention/emphasis](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Features#attentionemphasis)

### Generate / Interrupt / Skip

前述の通り、「Generate」をクリックすると画像の生成が開始される。

生成が始まると Interrupt / Skip ボタンに変化する。
Interrupt で生成を中断し終了する。
Skip は後述の Batch で複数枚生成している場合に、現在生成しているものをスキップできる。

### 生成画像の出力先

生成後に画像下のフォルダボタンをクリックすると、出力先の outputs\txt2img-images フォルダが開かれる。

Save ボタンをクリックすると log\images フォルダにコピーが保存される。

## txt2img の設定項目

### Width, Height

生成する画像の幅と高さ。

モデルにもよるが、デフォルトの 512 x 512 が一番うまく画像を生成できる。
これでは小さいため解像度を上げたくなるが、
解像度を上げると破綻した画像が生成されやすくなる。

Width, Height はあまり上げずに下記の Hires. fix や
「Extras」タブにある拡大機能、画像からの画像生成 (img2img) がオススメ。

16:9 の画像を生成したいなら 896 x 512 を指定するとよい。

### Batch count, Batch size

Batch size が1回で生成する枚数で、Batch count が何回実行するか。
最終的に Batch size × Batch count の枚数が生成される。

Batch size を増やすと VRAM の必要量が増える。

### Seed

乱数の種。
Seed の値とモデル、プロンプト等の生成条件が同じであれば毎回同じ画像が生成される。

サイコロアイコンをクリックするか -1 を指定すればランダムに、
リサイクルアイコンをクリックすると前回と同じ Seed がセットされる。

基本的には -1 を指定し画像をランダム生成するが、
プロンプトやサンプリングの影響を比較したい場合には値を固定する。

右にある Extra にチェックを入れると追加の UI が表示される。
Seed を固定し Variation strength を上げることで、
大まかな構図はそのままに一部が変わった画像を生成できる。
全体の雰囲気はいいけど一部を修正したいときに使える。

### Sampling method, Sampling steps

Sampling steps を上げると精緻な絵になるが生成に時間がかかる。
上げすぎてもあまり違いがわからない。デフォルトの 20 から 50 くらいがよさそう。

Sampling method の違いはよくわからない。
「DPM++ SDE karras」を選ぶとデフォルトの「Euler a」より
ステップ数が少なくてもいい絵ができる気がする。

### CFG Scale

プロンプトに対してどの程度従うかを設定できるらしい。
値を大きくすればプロンプトに沿った画像が生成される反面、破綻した画像が生成されやすくなるとか。

デフォルトの 7 のままでよさそう。

参考: [画像生成AI「Stable Diffusion」でどれぐらいプロンプト・呪文の指示に従うかを決める「CFG(classifier-free guidance)」とは一体何なのか？ - GIGAZINE](https://gigazine.net/news/20220928-stable-diffusion-classifier-free-guidance/)

### Restore faces, Tiling

Restore faces は人間の顔を生成した際に補正してくれる機能だが、
二次元のアニメ調イラストではキャラの目の中に人間の目が描かれて気持ち悪くなるのでオフ推奨。

Tiling はタイルのように並べても継ぎ目のないシームレスな画像を生成する。
3D のテクスチャを作成するのに使えるらしい。

### Hires. fix

生成した画像を拡大して高解像度化してくれるがその分時間がかかる。
<del>気に入ったものだけをあとから拡大したほうが効率がよいのでオフ推奨。</del>

2023/04/10 追記：Hires. fix の Upscaler で Latent 系を選択すると細部の描き込みが追加される。
単純な拡大機能である「Extras」タブと違い、イラストが改変されるため元のイラストと印象が異なってくる。

#### Hires steps

おそらく Sampling steps と似たようなものだと思われるが上げてもあまり違いがわからない。
デフォルトの 0 では Sampling steps と同じ値が使用される。

#### Denoising strength

下げると元画像に近いがぼんやりとした画像、上げると元画像と違う画像になっていく。

デフォルトの 0.7 では大きく変わる場合があるため、元画像に似せたいなら 0.5 ～ 0.6 くらいへ下げるとよい。

## モデルのダウンロードと追加

web UI の初期状態でもモデルがインストールされるが、
画風は実写的でアニメ調の二次元イラストを生成するには向いていない。
モデルと呼ばれるファイルを追加することで画風を変えることができる。

### モデルのダウンロード

モデルは [Hugging Face](https://huggingface.co/spaces/huggingface-projects/diffusers-gallery) や
[Civitai](https://civitai.com/) などで探してダウンロードする。

拡張子が .ckpt または .safetensor のものをダウンロードすればよい。
両方用意されている場合は .safetensor のほうが安全性が高いためそちらをダウンロードする。

参考: [AIモデルのsafetensors形式とは何者か？ckptと比較しつつ解説する \| 経済的生活日誌](https://economylife.net/safetensors-ckpt-difference/)

#### モデルのファイル名に付いてる pruned や fp16 って何？

画像生成に影響の少ない部分を削って軽量化したもの。
pruned や fp16 が用意されている場合はそちらをダウンロードするとよい。

[TensorFlow のサイト](https://www.tensorflow.org/guide/mixed_precision?hl=ja)
によると「NVIDIA GPU は float32 よりも float16 で速く演算を実行でき」るらしい。 (float16 = fp16)

### モデルの追加方法

1.  モデルをダウンロードする。
2.  ダウンロードしたモデルを web UI のフォルダにある models\Stable-diffusion フォルダへ入れる。
3.  web UI 画面左上にある「Stable Diffusion checkpoint」右の更新ボタンを押す。
4.  リストでモデルが選択できるようになる。

### オススメの二次元イラスト系モデル

以下の2つのモデルはどちらも美しいイラストが生成できるためオススメ。

- [AbyssOrangeMix3 (AOM3)](https://huggingface.co/WarriorMama777/OrangeMixs)
- [Anything v4.5](https://huggingface.co/andite/anything-v4.0)

AbyssOrangeMix3 は A1 から A3 と A1B がある。
A1 がアニメ調、A2が絵画調、A1B と A3 が中間。

アニメ調 ← A1 A1B A3 A2 → 絵画調

どちらのモデルも一緒に VAE (後述) が公開されているのでそちらを利用する。

## VAE

同じモデルでも VAE によって色が変わり印象が異なってくる。
AbyssOrangeMix や Anything のように VAE が一緒に公開されているモデルは
そちらを利用したほうがよい。

### VAE を選択できるようにする

1.  「Settings」タブをクリック
2.  左の一覧から「User interface」をクリック
3.  下から4つ目くらいにある「Quicksettings list」に `,sd_vae` を追加する (`sd_model_checkpoint,sd_vae` になる)
4.  上部の「Apply settings」をクリック
5.  「Reload UI」をクリック

### VAE の追加方法

1.  VAE をダウンロードする。
2.  ダウンロードした VAE を web UI のフォルダにある models\VAE フォルダへ入れる。
3.  web UI 画面上部にある「SD VAE」右の更新ボタンを押す。
4.  リストで VAE が選択できるようになる。

## 過去に生成した画像のプロンプト等を確認 (PNG Info)

生成した画像を「PNG Info」タブにある「Source」へ
ドラッグアンドドロップすることでプロンプト、モデル、Seed 等を確認できる。

また、「Send to txt2img」等のボタンを押すことで txt2img 等へコピー可能。
過去に生成したものと似た画像を簡単に生成できる。
ただし、モデルと VAE は反映されないので注意。

## 画像とテキストからの画像生成 (img2img)

「img2img」タブで画像とテキストを元に新たな画像を生成できる。

画像により構図やポーズをある程度制御できるため、
txt2img と比べ出力画像の解像度を高くしても破綻しにくい。
よって、txt2img では解像度低めでランダムに大量生成し、
良いものができたら img2img で高解像度化、細部の修正を行うとよい。

また、txt2img で生成された画像に足りない要素を手で描き加えたあと再生成するといった使い方もできる。
例えば、肌色で直線を描けば腕や足として認識して描き直してくれる。
英語で伝えにくい構図やポーズを描かせるのにも有用。

プロンプト等の設定は txt2img と同じ。
プロンプトなしの画像のみでも生成できるが、プロンプトを入力したほうが当然精度は高い。
txt2img で作成した画像を img2img で高解像度化するのであれば同じプロンプトを指定するとよい。

### 元画像の指定

元となる画像を「ここに画像をドロップ」と書いてあるところにドラッグアンドドロップするだけ。

### Resize mode

Resize mode は元画像と生成画像の縦横比が違う場合の処理を指定できる。

- Just resize  
  元画像の縦横比を無視して生成画像全体に引き伸ばす。  
  元画像が 512 x 512、生成画像が 1280 x 960 なら、元画像が横長の 1280 x 960 に引き伸ばされる。
- Crop and resize  
  元画像の縦横比を維持して拡大/縮小し、はみ出た部分は無視する。  
  元画像が 512 x 512、生成画像が 1280 x 960 なら、元画像が 1280 x 1280 に引き伸ばされ上下が切れる。
- Resize and fill  
  元画像の縦横比を維持して拡大/縮小し、足りない部分を埋める。  
  元画像が 512 x 512、生成画像が 1280 x 960 なら、元画像が 960 x 960 に引き伸ばされ左右の足りない部分は自動生成される。
- Just resize (latent upscale)  
  元画像を高解像度化したあと Just resize と同様の処理を行う。

### Denoising strength

下げると元画像に近いがぼんやりとした画像、上げると元画像と違う画像になっていく。

デフォルトの 0.75 では大きく変わる場合があるため、元画像に似せたいなら 0.5 ～ 0.6 くらいへ下げるとよい。

## img2img 内のタブ

- Sketch: img2img とほとんど同じだが、画面上の元画像に対してその場で書き込んで修正が可能。
- Inpaint: 画像の一部のみを生成する。黒く塗りつぶした部分、または塗りつぶしていない部分を描き直す。
- Inpaint sketch: 画像の一部のみを生成する。色を塗った部分のみ、その色を反映して描き直す。
- Inpaint upload: Inpaint と同様だがマスクを別画像で指定できる。
- Batch: ディレクトリを指定してバッチ処理ができる。

## 画像からプロンプトを生成 (Interrogate CLIP, Interrogate DeepBooru)

画像を指定したあと「Interrogate CLIP」または「Interrogate DeepBooru」のボタンをクリックすると
画像からプロンプトを生成できる。

「Interrogate DeepBooru」は Danbooru のタグになる。

## 設定 (Settings)

「Settings」タブで設定が変更できる。
全部説明するとキリがないため個人的に便利だと思う設定を紹介。

### Saving images/grids \> Images filename pattern

出力するファイル名のパターン。

デフォルトの空欄状態だと同日内での連番と Seed 値になるため、
他の日付のものと同じフォルダに入れたとき順番がバラバラになる。
以下を設定し、直下にある「Add number to filename when saving」のチェックをはずすと、
ファイル名が日付と時刻となるため便利。

    [datetime<%Y-%m-%d %H%M%S><+0900>]-[seed]-[model_name]

ファイル名に使用できるタグは「Images filename pattern」という文字にマウスカーソルを合わせると表示される。

> [steps],
> [cfg],
> [prompt_hash],
> [prompt],
> [prompt_no_styles],
> [prompt_spaces],
> [width],
> [height],
> [styles],
> [sampler],
> [seed],
> [model_hash],
> [model_name],
> [prompt_words],
> [date],
> [datetime],
> [datetime\<Format\>],
> [datetime\<Format\>\<Time Zone\>],
> [job_timestamp]

### Saving images/grids \> Always save all generated image grids と<br>User interface \> Show grid in results for web

生成した画像を縦横に連結したグリッド画像を生成する設定。

Batch で大量の画像を生成すると、完了後に
Interrupt / Skip ボタンが Generate ボタンへ戻るのに時間がかかる。
これはグリッド画像の作成が原因のため、
待ちたくない場合は上記のチェックをはずすと良い。

## 起動時の引数設定

「webui-user.bat」をテキストエディタで編集することで web UI 起動時の引数を設定できる。

### xFormers の導入

xFormers を導入すると画像生成速度が向上しVRAMの使用量も削減される。
ただし、Seed 値を固定しても微妙に異なる画像が生成されるようになるという欠点がある。
欠点より利点が大きいため導入したほうがよい。

導入方法は簡単で、「webui-user.bat」をテキストエディタで開き

    set COMMANDLINE_ARGS=

となっている部分を以下のように変更し保存する。

    set COMMANDLINE_ARGS=--xformers

保存後の初回起動時に xFormers がインストールされる。

### --no-half-vae の指定

VAE を変更して画像を生成しているとまれにエラーが発生し、
エラーを回避するためには `--no-half-vae` というオプションを利用するよう指示されることがある。
この場合も同様に「webui-user.bat」をテキストエディタで編集すればよい。

`--no-half-vae` だけを指定するなら

    set COMMANDLINE_ARGS=--no-half-vae

xFormers と併用するなら

    set COMMANDLINE_ARGS=--xformers --no-half-vae
