# 環境構築

## Android Studio の導入

[Android Studio](https://developer.android.com/studio) をインストールする。

android/ で指定している SDK などを適宜インストールする。

## Unity 導入

[Unity Hub](https://unity3d.com/get-unity/download)を導入する。

2020.30.31f1 をインストールする。
Android, iOS の Build Support を導入する。 Android SDK, NDK, JDK なども導入する。

<img width="500" alt="スクリーンショット 2022-03-10 16 44 15" src="https://user-images.githubusercontent.com/53816975/157612884-87a9bfd0-13ad-41df-8993-ee44cae27450.png">

## fvm 導入

[Dart](https://dart.dev/get-dart) をインストールする。

[fvm](https://fvm.app/docs/getting_started/installation) をインストールする。

必要に応じてパスを通す。（Windows だと必要だった）

## リポジトリのセットアップ

### Flutter の導入

クローンして fvm で Flutter をインストールする。

```
git clone https://github.com/Kishikawa1286/n-sneaker-app.git
cd n-sneaker-app
fvm install
```

必要に応じて、 VSCodeなどのテキストエディタに fvm で導入した Flutter SDK のパスを与える。

`fvm flutter doctor` を実行して、警告に対応する。

## 開発ビルド

### Android ビルド準備

一度 Flutter で Android アプリのビルドを実行すると `android/local.properties` が生成される。  
ここに `ndk.dir` を設定する。
```
sdk.dir=・・・
flutter.sdk=・・・
flutter.buildMode=・・・
flutter.versionName=・・・
ndk.dir=/Applications/Unity/Hub/Editor/2020.3.31f1/PlaybackEngines/AndroidPlayer/NDK
```

### Androidビルド手順

Unity で unity/arfoundation-demos を開いて、 Flutter > Export Android を実行する。

android/unityLibrary 下でバージョン管理されているファイルがいくつか上書きされるので、それらを `git reset` などで戻す。

android/local.properties の `ndk.dir` を Unity で使用している NDK のパスに設定する。 Unity で Preferences > External Tools > Android にパスが書いてある。

実機を接続し、 Flutter で実行する。
```
fvm flutter run --dart-define=temp
```

- 動かないときの確認事項
    - Android 端末の USB デバッグが有効になっているか？
    - local.properties の `ndk.dir` が設定されているか？
        - local.properties のパスの指定でバックスラッシュが2個になっているか？（Windows ではパスを貼り付けたあとに編集が必要）  
        例: `C:\\Program Files\\Unity\\Hub\\Editor\\2020.3.29f1\\Editor\\Data\\PlaybackEngines\\AndroidPlayer\\NDK`

### iOS

coming soon...

## firebase, algolia 等

# デプロイ

## App Store

Flutter で `FLAVOR=prod` を指定してビルド。
```
fvm flutter build ios --dart-define=FLAVOR=prod --release
```

XCode で unity-Framework の Build Setting の Skip Install を YES にする。

XCode で Build Number とバージョンを更新する。


通常のプロジェクトと同様に Archive し、 Organizer から App Store にアップロードする。

## Play Store

coming soon...
