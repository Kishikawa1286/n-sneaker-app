// ref: https://qiita.com/jyouryuusui/items/46e70da01e4281864cee#%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%8B%E3%82%89%E3%81%AE%E3%83%AD%E3%83%BC%E3%83%89
using TriLibCore;
using TriLibCore.General;
using System;
using System.Collections;
using System.IO;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Networking;
using UniRx;

class JsonData
{
    public String url;
    public String fileName;
}

// LoadをFlutterから呼び出すのでComponentにUnityMessageManager
public class FileLoadModel : MonoBehaviour
{
    private String _GlbFileName = "";

    void Awake()
    {
        // see: https://kazupon.org/unity-ios-setnonackup-flag/
        // see: https://qiita.com/Ubermensch/items/75072ef89249cb3b30e7#2applicationplatform%E3%82%92%E4%BD%BF%E3%81%86
        // iCloudに保存しない
        #if UNITY_IOS
            UnityEngine.iOS.Device.SetNoBackupFlag(Application.persistentDataPath);
        #endif
    }

    // called by Flutter
    public void Load(String json)
    {
        JsonData jsonData = _parseJson(json);
        // 値が現在のものから変わっている場合には状態変数を初期化
        if (jsonData.fileName != _GlbFileName) {
            _initializeLoadingStates();
            _GlbFileName = jsonData.fileName;
        }
        if (_loaded.Value) {
            return;
        }
        if (_downloading.Value || _localFileLoading.Value)
        {
            return;
        }
        if (System.IO.File.Exists(_filePath(jsonData.fileName)))
        {
            _loadLocalFile(jsonData.fileName);
        }
        // 指定されたファイルが存在しなければダウンロード
        else
        {
            _downloadAndLoad(jsonData.fileName, jsonData.url);
        }
    }

    /* ロード状態の管理 */

    // ダウンロードの進捗
    // 0～1
    private ReactiveProperty<float> _downloadProgress = new ReactiveProperty<float>(0f);
    public ReactiveProperty<float> downloadProgress => _downloadProgress;

    // ファイルロードの進捗
    //0～1
    private ReactiveProperty<float> _localFileLoadingProgress = new ReactiveProperty<float>(0f);
    public ReactiveProperty<float> localFileLoadingProgress => _localFileLoadingProgress; 

    // ダウンロード中にtrue
    // その前後ではfalse
    private BoolReactiveProperty _downloading = new BoolReactiveProperty(false);
    public IReadOnlyReactiveProperty<bool> downloading => _downloading;

    // ファイルロード中にtrue
    // その前後ではfalse
    private BoolReactiveProperty _localFileLoading = new BoolReactiveProperty(false);
    public IReadOnlyReactiveProperty<bool> localFileLoading => _localFileLoading;

    // ファイルロード後にtrue
    // それ以前ではfalse
    private BoolReactiveProperty _loaded = new BoolReactiveProperty(false);
    public IReadOnlyReactiveProperty<bool> loaded => _loaded;

    private void _initializeLoadingStates()
    {
        _downloading.Value = false;
        _localFileLoading.Value = false;
        _loaded.Value = false;
        _downloadProgress.Value = 0f;
        _localFileLoadingProgress.Value = 0f;
    }

    // ダウンロード開始
    private void _onStartDownloading()
    {
        _downloading.Value = true;
        _loaded.Value = false;
        _downloadProgress.Value = 0f;
    }

    // ダウンロード完了
    private void _onFinishDownloading()
    {
        _downloading.Value = false;
        _loaded.Value = false;
        _downloadProgress.Value = 1f;
    }

    // ダウンロード失敗
    private void _onErrorDownloading()
    {
        _downloading.Value = false;
        _loaded.Value = false;
        _downloadProgress.Value = 0f;
    }

    // ローカルファイルのロード開始
    private void _onStartLocalFileLoading()
    {
        _localFileLoading.Value = true;
        _loaded.Value = false;
        _localFileLoadingProgress.Value = 0f;
    }

    // ローカルファイルのロード完了
    private void _onFinishLocalFileLoading()
    {
        _localFileLoading.Value = false;
        _loaded.Value = true;
        _localFileLoadingProgress.Value = 1f;
    }

    // ローカルファイルのロード失敗
    private void _onErrorLocalFileLoading()
    {
        _localFileLoading.Value = false;
        _loaded.Value = false;
        _localFileLoadingProgress.Value = 0f;
    }

    /* ダウンロード */

    private void _downloadAndLoad(String fileName, String url)
    {
        if (_downloading.Value || _localFileLoading.Value)
        {
            return;
        }
        _onStartDownloading();
        StartCoroutine(
            _downloadWithProgress(
                url,
                fileName,
                (progress) =>
                {
                    _downloadProgress.Value = progress;
                }
            )
        );
    }

    private IEnumerator _downloadWithProgress(String url, String fileName, System.Action<float> progress)
    {
        using (UnityWebRequest request = UnityWebRequest.Get(url))
        {
            var async = request.SendWebRequest();
            while (true)
            {
                // ダウンロード失敗
                if (request.result == UnityWebRequest.Result.ProtocolError
                    || request.result == UnityWebRequest.Result.ConnectionError)
                {
                    _onErrorDownloading();
                    yield break;
                }

                //正常終了
                if (async.isDone)
                {
                    try
                    {
                        File.WriteAllBytes(_filePath(fileName), request.downloadHandler.data);
                        _loadLocalFile(fileName);
                    }
                    // ファイルの書き込みに失敗
                    catch (Exception e)
                    {
                        _onErrorDownloading();
                        yield break;
                    }
                    _onFinishDownloading();
                    yield break;
                }

                // ダウンロード中
                yield return null;
                progress(async.progress); // コールバックとして進捗(0~1)を返す
            }
        }
    }

    /* ローカルファイルのロード */

    private void _loadLocalFile(String fileName)
    {
        // タップ時に配置されるPrefabの中にSneakerというGameObjectが入っている
        GameObject target = GameObject.Find("Sneaker");
        if (target == null)
        {
            return;
        }

        _onStartLocalFileLoading();
        var options = AssetLoader.CreateDefaultLoaderOptions();
        options.AlphaMaterialMode = AlphaMaterialMode.CutoutAndTransparent;
        // options.LoadTexturesAsSRGB = false;
        options.TextureCompressionQuality = TextureCompressionQuality.Best;
        AssetLoader.LoadModelFromFile(
            _filePath(fileName),
            _onLocalFileLoad,
            _onLocalFileMaterialLoad,
            _onProgressLocalFileLoading,
            _onError,
            target,
            options
        );
    }

    // このイベントは、すべてのモデルのGameObjectとメッシュが読み込まれたときに呼び出されます。
    // この段階ではまだマテリアルとテクスチャの処理が行われている可能性があります。
    private void _onLocalFileLoad(AssetLoaderContext assetLoaderContext)
    {
        // ルートにロードされたGameObjectは、"assetLoaderContext.RootGameObject"フィールドに割り当てられます。
        // すべてのマテリアルとテクスチャがロードされたときにのみGameObjectが表示されるようにしたい場合は、このステップで無効にすることができます。
        var myLoadedGameObject = assetLoaderContext.RootGameObject;
        myLoadedGameObject.SetActive(false);
    }

    private void _onLocalFileMaterialLoad(AssetLoaderContext assetLoaderContext)
    {
        // マテリアルの色に逆ガンマ補正をかける
        foreach (var kvp in assetLoaderContext.LoadedMaterials)
        {
            _inverseGammaCorrection(kvp.Value);
        }

        // ルートにロードされたGameObjectは、"assetLoaderContext.RootGameObject"フィールドに割り当てられます。
        // 必要に応じて、このステップでGameObjectを再び表示できます。
        var myLoadedGameObject = assetLoaderContext.RootGameObject;
        myLoadedGameObject.SetActive(true);

        //ここで，オブジェクトをマネージャーに飛ばす．
        _onFinishLocalFileLoading();
    }

    private void _onError(IContextualizedError contextualizedError)
    {
        _onErrorLocalFileLoading();
        if (File.Exists(_filePath("_GlbFileName")))
        {
            File.Delete(_filePath("_GlbFileName"));
        }
    }

    private void _onProgressLocalFileLoading(AssetLoaderContext assetLoaderContext, float progress)
    {
        _localFileLoadingProgress.Value = progress;
    }

    /* Utilitiies */

    private String _filePath(String fileName)
    {
        return Application.persistentDataPath + "/" + fileName;
    }

    private JsonData _parseJson(String json)
    {
        return JsonUtility.FromJson<JsonData>(json);
    }

    private void _inverseGammaCorrection(Material mat)
    {
        float r = mat.color[0];
        float g = mat.color[1];
        float b = mat.color[2];
        float a = mat.color[3];

        r = Mathf.Pow(r, 1/2.2f);
        g = Mathf.Pow(g, 1/2.2f);
        b = Mathf.Pow(b, 1/2.2f);

        mat.color = new Color(r, g, b, a);
        
        // mat.EnableKeyword("_EMISSION");
    }
}
