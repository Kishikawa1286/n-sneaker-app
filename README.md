# 環境構築

## Unity 導入

[Unity Hub](https://unity3d.com/get-unity/download)を導入する。

2020.30.30f1 をインストールする。
Android, iOS の Build Support を導入する。 Android SDK, NDK, JDK なども導入する。

<img width="500" alt="スクリーンショット 2022-03-10 16 44 15" src="https://user-images.githubusercontent.com/53816975/157612884-87a9bfd0-13ad-41df-8993-ee44cae27450.png">

## fvm 導入

[Dart](https://dart.dev/get-dart) をインストールする。

[fvm](https://fvm.app/docs/getting_started/installation) をインストールする。

必要に応じてパスを通す。（Windows だと必要だった）

## リポジトリのセットアップ

クローンして fvm で Flutter をインストールする。

```
git clone https://github.com/Kishikawa1286/n-sneaker-app.git
cd n-sneaker-app
fvm install
```

必要に応じて、 VSCodeなどのテキストエディタに fvm で導入した Flutter SDK のパスを与える。

## Unity プロジェクトのビルド

### Android

Unity で unity/arfoundation-demos を開いて、 Flutter > Export Android を実行する。

android/unityLibrary 下でバージョン管理されているファイルがいくつか上書きされるので、それらを `git reset` などで戻す。

android/local.properties の `ndk.dir` を Unity で使用している NDK のパスに設定する。 Unity で Preferences > External Tools > Android にパスが書いてある。

実機を接続し、 Flutter で実行する。
```
fvm flutter run --dart-define=temp
```

### iOS

coming soon...

## firebase, algolia 等
 coming soon...
