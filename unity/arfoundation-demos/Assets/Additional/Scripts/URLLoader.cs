// ref: https://qiita.com/jyouryuusui/items/46e70da01e4281864cee#%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%8B%E3%82%89%E3%81%AE%E3%83%AD%E3%83%BC%E3%83%89
using TriLibCore;
using TriLibCore.General;
using System;
using UnityEngine;
using UnityEngine.EventSystems;

public class URLLoader : MonoBehaviour
{
    private String url = "";

    // 同時に2つ読み込みに行かない
    // semaphore
    private bool downloading = false;

    // Flutterから呼び出す
    void SetDownloadURL(String message)
    {
        // 3D モデルが切り替わるときだけ処理が走る
        // それ以外は早期return
        if (url == message || message == "" || downloading)
        {
            return;
        }
        url = message;
        // AssetLoaderOptionsインスタンスを作成します。
        // AssetLoaderOptionsは、ロードプロセスの多くの側面を構成するために使用されるクラスです。
        // 今回はデフォルト設定を変更しないので、インスタンスをそのまま使用できます。
        var assetLoaderOptions = AssetLoader.CreateDefaultLoaderOptions();

        // Webリクエストを作成します。
        //  web-requestには、モデルのダウンロード方法に関する情報が含まれています。
        // TriLibWebサイトから003_visemes.zipモデルをダウンロード
        var webRequest = AssetDownloader.CreateWebRequest(url);

        downloading = true;

        // モデルのダウンロードを開始します。
        AssetDownloader.LoadModelFromUri(webRequest, OnLoad, OnMaterialsLoad, OnProgress, OnError, gameObject, assetLoaderOptions, null, null, true);
    }

    // このイベントは、モデルの読み込みの進行状況が変更されたときに呼び出されます。
    // このイベントを使用して、たとえば、読み込みの進行状況バーを更新できます。
    // 「progress」値は正規化されたfloatとして提供されます（0から1になります）。
    // UWPやWebGLなどのプラットフォームは、スレッドを使用しないため、現時点ではこのメソッドを呼び出しません。
    private void OnProgress(AssetLoaderContext assetLoaderContext, float progress)
    {

    }

    // このイベントは、モデルの読み込み中に重大なエラーが発生したときに呼び出されます。
    // これを使用して、ユーザーにメッセージを表示できます。
    private void OnError(IContextualizedError contextualizedError)
    {

    }

    // このイベントは、すべてのモデルのGameObjectとメッシュが読み込まれたときに呼び出されます。
    // の段階ではまだマテリアルとテクスチャの処理が行われている可能性があります。
    private void OnLoad(AssetLoaderContext assetLoaderContext)
    {
        // ルートにロードされたGameObjectは、"assetLoaderContext.RootGameObject"フィールドに割り当てられます。
        // すべてのマテリアルとテクスチャがロードされたときにのみGameObjectが表示されるようにしたい場合は、このステップで無効にすることができます。
        var myLoadedGameObject = assetLoaderContext.RootGameObject;
        myLoadedGameObject.SetActive(false);
    }

    // このイベントは、すべてのマテリアルとテクスチャがロードされたときにOnLoadの後に呼び出されます。
    // このイベントは、重大な読み込みエラーの後にも呼び出されるため、必要なリソースをクリーンアップできます。
    private void OnMaterialsLoad(AssetLoaderContext assetLoaderContext)
    {
        // ルートにロードされたGameObjectは、"assetLoaderContext.RootGameObject"フィールドに割り当てられます。
        // 必要に応じて、このステップでGameObjectを再び表示できます。
        var myLoadedGameObject = assetLoaderContext.RootGameObject;
        myLoadedGameObject.SetActive(true);
        downloading = false;
    }
}
