// ref: https://qiita.com/jyouryuusui/items/46e70da01e4281864cee#%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%8B%E3%82%89%E3%81%AE%E3%83%AD%E3%83%BC%E3%83%89
using TriLibCore;
using TriLibCore.General;
using System;
using System.Collections;
using System.IO;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Networking;

public class ModelLoader : MonoBehaviour
{
    [SerializeField]
    private UnityMessageManager UnityMessageManager;

    private bool loading = false;

    void Awake()
    {
        // ref: https://kazupon.org/unity-ios-setnonackup-flag/
        // ref: https://qiita.com/Ubermensch/items/75072ef89249cb3b30e7#2applicationplatform%E3%82%92%E4%BD%BF%E3%81%86
        if (Application.platform == RuntimePlatform.IPhonePlayer)
        {
            UnityEngine.iOS.Device.SetNoBackupFlag(Application.persistentDataPath);
        }
        UnityMessageManager = GetComponent<UnityMessageManager>();
    }

    private String FileModelFilePath(String id)
    {
        return Application.persistentDataPath + "/" + id + "_fbx.zip";
    }

    private void LoadFile(String id)
    {
        loading = true;
        AssetLoaderZip.LoadModelFromZipFile(
            FileModelFilePath(id),
            OnLoad,
            OnMaterialsLoad,
            OnProgress,
            OnError,
            gameObject, // Scriptを適用するGameObject自身
            null,
            null,
            null,
            false
        );
    }

    // Flutterから呼び出す
    void LoadModel(String json)
    {
        JsonData data = JsonUtility.FromJson<JsonData>(json);
        String url = data.url;
        String id = data.id;
        // id と ファイルが一対一対応している
        // id で指定されたファイルが存在すればそれを読み込む
        if (loading)
        {
            return;
        }
        if (System.IO.File.Exists(FileModelFilePath(id)))
        {
            LoadFile(id);
        }
        // id で指定されたファイルが存在しなければダウンロード
        else
        {
            DownloadAndLoad(id, url);
        }
    }

    // このイベントは、モデルの読み込みの進行状況が変更されたときに呼び出されます。
    // このイベントを使用して、たとえば、読み込みの進行状況バーを更新できます。
    // 「progress」値は正規化されたfloatとして提供されます（0から1になります）。
    // UWPやWebGLなどのプラットフォームは、スレッドを使用しないため、現時点ではこのメソッドを呼び出しません。
    private void OnProgress(AssetLoaderContext assetLoaderContext, float progress)
    {
        UnityMessageManager.SendMessageToFlutter("{\"name\": \"load\", \"value\": \"" + progress.ToString() + "\"}");
    }

    // このイベントは、モデルの読み込み中に重大なエラーが発生したときに呼び出されます。
    // これを使用して、ユーザーにメッセージを表示できます。
    private void OnError(IContextualizedError contextualizedError)
    {
        UnityMessageManager.SendMessageToFlutter(contextualizedError.ToString());
        loading = false;
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
        loading = false;
        UnityMessageManager.SendMessageToFlutter("{\"name\": \"load\", \"value\": \"" + 1f.ToString() + "\"}");
    }

    // called from flutter
    // {
    //     "url": "https://......",
    //     "id": "firestore document id"
    // }
    private void DownloadAndLoad(String id, String url)
    {
        if (loading)
        {
            return;
        }
        loading = true;
        StartCoroutine(
            DownloadWithProgress(
                url,
                id,
                (progress) =>
                {
                    UnityMessageManager.SendMessageToFlutter("{\"name\": \"download\", \"value\": \"" + progress.ToString() + "\"}");
                }
            )
        );
    }

    private IEnumerator DownloadWithProgress(String url, String id, System.Action<float> progress)
    {
        using (UnityWebRequest request = UnityWebRequest.Get(url))
        {
            var async = request.SendWebRequest();
            while (true)
            {
                if (request.result == UnityWebRequest.Result.ProtocolError || request.result == UnityWebRequest.Result.ConnectionError)
                {
                    //エラー
                    UnityMessageManager.SendMessageToFlutter("[[DOWNLOAD_ASSET_ERROR]]" + request.error.ToString());
                    loading = false;
                    yield break;
                }

                if (async.isDone)
                {
                    try
                    {
                        //正常終了
                        File.WriteAllBytes(FileModelFilePath(id), request.downloadHandler.data);
                        UnityMessageManager.SendMessageToFlutter("{\"name\": \"download\", \"value\": \"" + 1f.ToString() + "\"}");
                        LoadFile(id);
                    }
                    catch (Exception e)
                    {
                        UnityMessageManager.SendMessageToFlutter("[[DOWNLOAD_ASSET_ERROR]]" + e.ToString());
                    }
                    loading = false;
                    yield break;
                }

                yield return null;
                //コールバックとして進捗(0~1)を返す
                progress(async.progress);
            }
        }
    }
}

class JsonData
{
    public String url;
    public String id;
}
