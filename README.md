# N-Sneaker

## デモ

https://github.com/Kishikawa1286/n-sneaker-app/assets/53816975/f1928d82-0d0f-4769-8790-4b7f3ed50f6a

## 環境構築

### リポジトリのセットアップ

```
git clone https://github.com/Kishikawa1286/n-sneaker-app.git
```

### Dart, fvmの導入

1. 開発環境に合わせて Dart をインストールする  
  [Get the Dart SDK](https://dart.dev/get-dart)
2. fvm をインストールする  
  [fluttertools/fvm](https://github.com/fluttertools/fvm)
3. プロジェクトルートに移動して `fvm install` を実行
4. `fvm flutter pub get` を実行してパッケージをダウンロード（テキストエディタが自動実行している場合は飛ばす）
5. `fvm flutter doctor` を実行して警告に対応していく  
  [XCode](https://developer.apple.com/xcode/), [Android Studio](https://developer.android.com/studio) の導入などを行う

### Unity の導入

1. [Unity Hub](https://unity3d.com/get-unity/download) をインストールする
2. Unity のライセンス認証を行う
3. Unity 2020.3.31f1 をダウンロード  
  Android, iOS の Build Support および Android SDK, NDK, JDK をインストールする設定にしておく

### Android ビルドの準備

一度 Android アプリのビルド（`fvm flutter build apk`）を実行すると `android/local.properties` が生成される  
ここに以下のように `ndk.dir` を設定する（プロジェクトの Unity バージョンに合わせる）  
Windows の場合は `/` を `\\` に変える（`android/local.properties` の `sdk.dir` などを参考に）

```raw
sdk.dir=・・・
flutter.sdk=・・・
flutter.buildMode=・・・
flutter.versionName=・・・
ndk.dir=/Applications/Unity/Hub/Editor/2020.3.31f1/PlaybackEngines/AndroidPlayer/NDK
```

### iOS ビルドの準備 (Mac のみ)

1. XCode で `ios/Runner.xcworkspace` を開く
2. 証明書の設定を行う

## 開発ビルド

### Android

1. Unity で `unity/ar` を開いて `Flutter > Export Android` （メニューバーにある `Flutter` を開くと出てくる）を実行
2. `android/unityLibrary` 下でバージョン管理されているファイルがいくつか上書きされるので、それらを `git reset` などで戻し、新しく生成されたものは消す  
  対象ファイルは次の通り
  - `android/unityLibrary/build.gradle`
  - `android/unityLibrary/proguard-unity.txt`
  - `android/unityLibrary/libs/libarpresto_api.so`
  - `android/unityLibrary/libs/libUnityARCore.so`
  - `android/unityLibrary/libs/unityandroidpermissions.aar`

3. **実機**を接続
4. 以下を実行する  
  ```raw
  fvm flutter run --dart-define=FLAVOR=dev
  ```

<details>
  <summary>動かないときの確認事項</summary>
  <p>
  
  - Android 端末の USB デバッグが有効になっているか？  
    [USB デバッグ モードを無効にする](https://docs.microsoft.com/ja-jp/mem/intune/user-help/you-need-to-turn-off-usb-debugging-android)
  - local.properties の `ndk.dir` が設定されているか？
    - local.properties のパスの指定でバックスラッシュが2個になっているか？（Windows ではパスを貼り付けたあとに編集が必要）  
        例  
        ```
        C:\\Program Files\\Unity\\Hub\\Editor\\2020.3.31f1\\Editor\\Data\\PlaybackEngines\\AndroidPlayer\\NDK
        ```
  </p>
</details>

<details>
  <summary>flutter run が Installing build\app\outputs\flutter-apk\app.apk... で止まるとき</summary>
  <p>
  
  - 一度タスクキルをして再び `flutter run`
  - `flutter clean`
  </p>
</details>

### iOS

1. Unity で `unity/ar` を開いて `Flutter > Export iOS` （ヘッダーにある `Flutter` を開くと出てくる）を実行
2. **実機**を接続
3. 以下を実行する  
  ```raw
  fvm flutter run --dart-define=FLAVOR=dev
  ```

<details>
  <summary>_onUnitySceneLoaded が無いといわれてビルド失敗</summary>
  <p>
  
  - `unity/ar/FlutterUnityIntegration-v4.1.0.unitypackage` をインポートし直す  
    [Undefined symbols for architecture arm64: "_onUnitySceneLoaded"](https://github.com/juicycleff/flutter-unity-view-widget/issues/221)
  </p>
</details>

<details>
  <summary>本番環境でUnityが起動しない</summary>
  <p>
  
  - [Unity側のプロジェクトで「Data」フォルダのTarget Membershipを「UnityFramework」にチェックを入れる](https://qiita.com/warapuri/items/1353c60eb615b4974e88#a-unity%E5%81%B4%E3%81%AE%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E3%81%A7data%E3%83%95%E3%82%A9%E3%83%AB%E3%83%80%E3%81%AEtarget-membership%E3%82%92unityframework%E3%81%AB%E3%83%81%E3%82%A7%E3%83%83%E3%82%AF%E3%82%92%E5%85%A5%E3%82%8C%E3%82%8B)
  </p>
</details>

## デプロイ

### Android

1. `pubspec.yaml` を編集してビルド番号とバージョンを更新する
2. 以下を実行  
  ```
  fvm flutter build appbundle --dart-define=FLAVOR=prod --release
  ```
3. 生成されたファイル（ログにパスが表示される）を Google Play Console からアップロード

### iOS

1. XCode で Unity-Framework の Build Setting の Skip Install を YES にする  
  これを忘れると3.で詰まるのでやり忘れた場合はここからやり直し
2. XCode でビルド番号とバージョンを更新する
3. Archive して Organizer から App Store にアップロードする

## Flutter の各種設定

### [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)

設定ファイルは `flutter_native_splash.yaml`  
以下のコマンドで設定を反映する
```raw
fvm flutter pub run flutter_native_splash:create
```

### [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

設定ファイルは `pubspec.yaml`, `flutter_launcher_icons-dev.yaml`, `flutter_launcher_icons-prod.yaml`  
以下のコマンドで設定を反映する
```raw
fvm flutter pub run flutter_launcher_icons:main
```
[FlutterでDart-defineのみを使って開発環境と本番環境を分ける](https://zenn.dev/riscait/articles/separating-environments-in-flutter)

## Flutter 部分のアーキテクチャ

- Interface: アプリの外部とのやり取り
- Repository: Interfaceの処理の呼び出しと外部から取得したデータの整形
- Service: アプリ全体で共有する値の管理
- ViewModel: UI の状態管理
- View: UI や画面遷移を記述

<img width="250" src="https://user-images.githubusercontent.com/53816975/198882094-591eed90-2fc2-4562-aaa2-d1337b95e04c.png">

Unity アプリとのやり取りの部分はパッケージの設計の関係上上記の設計に従っていない  
View から ViewModel に値が渡されて VirewModel から Unity アプリに メッセージが飛ぶ

ViewModel および Service における値の保持などには [Riverpod](https://riverpod.dev/) を使用している

## Unity

Unity プロジェクトファイルは `unity/ar/`

Unity 部分は [Unity-Technologies/arfoundation-demos](https://github.com/Unity-Technologies/arfoundation-demos) を元に作成（Unity Companion License が適用されている）しており、使っていないファイルが多数存在する  
使っているシーンは `unity/ar/Assets/Shaders/CameraGrain/Scenes/CameraGrain.unity` で、他は使っていない

自作したファイルは `sbinft-ar/unity/ar/Assets/Additional/` に入っている
