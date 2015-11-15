---
layout: default
title: TweenXCore - lightweight motion library for haxe
---



# TweenXCore

TweenXCoreはトゥイーンライブラリ**ではありません**。

気持ちの良いモーションをトゥイーンライブラリは異なる方法で実現するためのライブラリです。

{% include movie.html file="core/Demo" %}



## 特徴
* シンプル
* 自由
* 高速

TweenXCoreは、実行速度と、開発速度、バグの少なさ、学習コストの少なさ、そしてモーションの面白さを両立するために作られています。



## 機能

* 46種類のイージング関数
* ヨーヨー、ジグザグ運動
* ブレンド、クロスフェード、連結などのイージングのカスタム機能
* HSVカラー、RGBカラー
* 極座標
*　ベジェ曲線
*　lerp、inverseLerp、clampなど、Floatの機能を拡張するツール



### TweenXCoreが持たないもの

* バックグラウンドでの動作
 * TweenXCoreはバックグラウンドでオブジェクトを操作することはありません。今どういう状態であるべきか毎フレームごとで記述するスタイルを取ります。
* イベントリスナー
 * TweenXCoreは何かしらの処理を予約しておくことはできません。モーションの終了タイミングなどはif文を書くことで、判別します。
* ツリー構造
 * TweenXCoreは独自のツリー構造を持ちません。


上記のような機能はこのライブラリの対象外です。



## 速度

既存のFlashプラットフォーム上で動作するトゥイーンライブラリとしておそらく最速であるBetweenAS3よりも、さらに高速に動作しています。

[[サンプルコード全体]](https://github.com/shohei909/tweenx/tree/develop/sample/tweenx/800_BenchMark/src)



## 対応バージョン

Haxeの3.1.3での動作を確認しています。


## TweenXCoreが持つ思想


### トゥイーンライブラリの反省

トゥイーンライブラリはバグの温床になりやすいものです。

同じオブジェクトに対して2つのトゥイーンが走ったときの挙動は混乱を生みます。常にメモリリークを気にかけながら実装を行う必要があります。イベントハンドラの取り扱いも厄介です。

トゥイーンライブラリはとりあえず動くコードを書くのに便利で、プロトタイプや小さなゲームを作るのに向いていますが、製品版のプログラムに使うには心もとないです。

例えばゲームの場合、**「一時停止ボタンが押されたときにゲーム内のアニメーションをすべて一時停止した上で、さらにアニメーション付きでポップアップを表示させたい」**ことがあります。通信待ちのインジケータなら、 **「インジケータのフェードイン中に通信が終われば、フェードインの途中からフェードアウトに切り替えをしたい」** と思うはずです。

このような要求は、トゥイーンライブラリが苦手とする分野です。

もちろんTweenXはそのような用途にも耐えうるように細心の注意をはらって設計していますが、それでもこういった動作を実装する場合は詳細の挙動にまで精通している必要ありますし、コードの量も複雑度も大きくなりがちです。

わたし自身も気づけばTweenXのバックグラウンドで何かをやってくれるような機能は使わなくなり、TweenXのイージング関数を直接使ってモーションのコードを書くようになっていました。

そして、その方法のほうがより高いの表現力と使い勝手の良さを手に入れられることがわかりました。



### 0.0から始まり、1.0で終わる

TweenXCoreの世界では、始まりの値は0.0であり、終わりの値は1.0です。

つまり、モーションの時刻の場合、開始時刻は0.0で表し終了時刻は1.0を使います。
アルファ値の場合、完全な透明は0.0で完全な不透明は1.0です。
円の1周の場合、0度は0.0であり360度は1.0です。
RGBカラーのRed値の場合、0.0が赤みが全くなく1.0が完全な赤です。

TweenXCoreでは、このような0.0から1.0を基準とする値について`rate`という変数名をよく使います。

TweenXCoreはトゥイーンライブラリではありません。**この0.0から1.0を基準とする値を、上手にあやつるためのツール**だと考えてください。




## Hello TweenXCore

TweenXCoreの最初のサンプルとして四角のx座標を0から420まで、動かすコードを見てみます。

{% include movie.html file="core/Simplest" %}

```haxe
import sample.SampleSuport.GridSprite;
import sample.SampleSuport.Square;
import openfl.events.Event;

import tweenxcore.structure.FloatChange;
using tweenxcore.tools.Tools;

class SampleSprite extends GridSprite {
    var square:Square;
    var frame = 0;

	public function new() {
		super();
        addChild(square = new Square(0, GridSprite.CELL_SIZE * 4));
        addEventListener(Event.ENTER_FRAME, onFrame);
    }

    // フレームごとに実行される。
    function onFrame(e:Event) {
        var change = new FloatChange(frame, frame + 1);
        change.part(0, 20, updateSquare);
        frame++;
	}

    // 四角の位置を更新する。
    function updateSquare(change:FloatChangePart) {
        square.x = change.current.lerp(0, 420);
    }
}
```

[[サンプルコード全体]](https://github.com/shohei909/tweenx/blob/develop/sample/tweenxcore/301_SimplestTween/Main.hx)


TweenXCoreの説明として重要なのは以下のコードです。

```haxe
using tweenxcore.Tools;
```

```haxe
    // フレームごとに実行される。
    function onFrame(e:Event) {
        var change = new FloatChange(frame, frame + 1);
        change.part(0, 20, updateSquare);
        frame++;
	}

    // 四角の位置を更新する。
    function updateSquare(change:FloatChangePart) {
        square.x = change.current.lerp(0, 420);
    }
```



それでは1つづつ要素を見ていきます。


### tweenxcore.tools.Tools
`using tweenxcore.tools.Tools;`は、Floatなどの既存のデータ型に対する拡張のインポートです。

Tools.hxの中身は[このように](https://github.com/shohei909/tweenx/blob/develop/src/tweenxcore/tweenxcore/tools/Tools.hx)なっており、TweenXCoreが持つ6種類の拡張をいっぺんにインポートできます。それぞれがどのような機能を持っているのかは後々説明をします。



### FloatChange、FloatChangePart
`FloatChange`はTweenXCoreが提供している型で、直前のFloat値と現在のFloat値をまとめて1つの型に持つことで、値の変化を簡単に扱えるようにします。

この`FloatChange`の`part`関数は、値が指定した範囲にあった場合にすぐに関数呼び出しを行います。つまり例では、`frame`または`frame + 1`が`0 < 値 < 20`の範囲にあるとき、`updateSquare`関数を呼び出します。

`FloatChangePart`は、`FloatChange`のある範囲の値を0から1までの値に変換させた`FloatChange`です。例の場合、`frame`の0から20を、0.0から1.0の範囲に変換しています。

`FloatChange`と同様、変数`current`で現在の値を取得できます。この値は`0.0 < current <= 1.0`の範囲にあります。


### lerp

`lerp`は線形補間の関数で、`tweenxcore.tools.FloatTools`が持つ拡張です。0.0から1.0の値を指定した範囲の値、例の場合、0から420までの値に変換しています。これにより、`change.current`が0.0から1.0まで変化する間に、‘square.x‘は0から420へと移動します。



## イージング関数

{% include movie.html file="core/EasingVisualizer" %}

TweenXCoreでは、[Robert Pennerのイージング関数](http://easings.net/)を基本として、中央で減速して再度加速するInOutのモードと、瞬間的に移動を行うwarpが追加された計46個の関数が提供されています。

さて一般的なトゥイーンライブラリとの表面的な部分での違いはあまりありませんが、内部的には大きな違いがあります。

一般的なトゥイーンライブラリでは、cubicInの関数は以下の形です。

```haxe
function cubicIn(t:Float, b:Float, c:Float, d:Float):Float {
    return c * (t /= d) * t * t + b;
}
```

この関数には4つの引数があり、それぞれ

* `t`は動き始めてからの経過時刻
* `b`は値の初期値
* `c`は値の変化量
* `d`は完了までの時間

です。

そして、TweenXCoreでのeasing関数は以下の通りです。

```haxe
function cubicIn(t:Float):Float {
    return t * t * t;
}
```

引数が1つだけになっています。一般的なものよりずっとシンプルです。

TweenXCoreの引数が1つしかない理由は明確です。TweenXCoreの世界では**始まりの値は0.0であり、終わりの値は1.0**だからです。このルールに従うと、元の4つの引数は以下のように考えることができます。

* `t`は、経過時刻を0.0から1.0までで表したもの
* 値の初期値は0.0
* 値の変化量は1.0
* 完了までの時間は1.0

つまり、TweenXCoreの世界では変数なのはtのみで、他は3つは定数と考えられます。

TweenXCoreの場合のEasing関数は、トゥイーン関数に渡すものではなく自分の手で使っていくものですから、引数が4つもあると小回りがきかず不便です。このように引数が1つになることで、Easing関数を直接あつかっても何をやっているのか明瞭でわかりやすくなります。

それでは、この関数を使って先述のサンプルコードにEasingをつけてみます。たった1行、以下のように変更を加えます。

```haxe
        square.x = change.current.cubicIn().lerp(0, 420);
```

`change.current`の0.0から1.0までの値を、cubicIn()を使ってカーブをつけた後に、`lerp`関数で0から420の値に変換しています。TweenXCoreを使用するコードでは、このようなFloatの値に対するメソッドチェーンがよく出てきます。

{% include movie.html file="core/Easing" %}

[[サンプルコード全体]](https://github.com/shohei909/tweenx/blob/develop/sample/tweenxcore/302_Easing/Main.hx)


# Haxe/OpenFl アニメーションプログラミング

## 基本的な動き
### 繰り返し
### ヨーヨー、ジグザグ
### モーションの開始時、終了時の処理
### 複数の動きをあつかう


## イージングの自作する
### 多重のイージング
### クロスフェード
### 連結(connect)
### 接合(join)


## 2次元的な処理
### マトリックス
### 極座標
### ベジェ曲線

## 色
### RGBカラー、HSVカラー
## パラパラアニメーション
## 音に合わせる