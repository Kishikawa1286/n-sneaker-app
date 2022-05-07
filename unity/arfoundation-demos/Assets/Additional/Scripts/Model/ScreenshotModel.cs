using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using NatSuite.Sharing;

public class ScreenshotModel : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] private Camera ArCam;

    private UnityMessageManager _UnityMessageManager;

    // 連続で実行されるのを防ぐ
    private float thresholdTime = 0.05f;
    private float time = 0f;

    void Awake()
    {
        _UnityMessageManager = GetComponent<UnityMessageManager>();
    }

    void Update()
    {
        time += Time.deltaTime;
    }

    public void SaveScreenshot()
    {
        if (time < thresholdTime) {
            return;
        }
        time = 0f;

        Texture2D screenShot = new Texture2D(Screen.width, Screen.height, TextureFormat.RGB24, false);
        RenderTexture rt = new RenderTexture(screenShot.width, screenShot.height, 24);
        RenderTexture prev = ArCam.targetTexture;
        ArCam.targetTexture = rt;
        ArCam.Render();
        ArCam.targetTexture = prev;
        RenderTexture.active = rt;
        screenShot.ReadPixels(new Rect(0, 0, screenShot.width, screenShot.height), 0, 0);
        screenShot.Apply();

        // see: https://qiita.com/OKsaiyowa/items/21a9ca438efbf605c52d#applicationpersistentdatapath
        byte[] bytes = screenShot.EncodeToPNG();
        string path = GetSavePath();
        File.WriteAllBytes(path, bytes);
        _UnityMessageManager.SendMessageToFlutter(path);
    }

    public void ShareScreenshot()
    {
        if (time < thresholdTime) {
            return;
        }
        time = 0f;

        Texture2D screenShot = new Texture2D(Screen.width, Screen.height, TextureFormat.RGB24, false);
        RenderTexture rt = new RenderTexture(screenShot.width, screenShot.height, 24);
        RenderTexture prev = ArCam.targetTexture;
        ArCam.targetTexture = rt;
        ArCam.Render();
        ArCam.targetTexture = prev;
        RenderTexture.active = rt;
        screenShot.ReadPixels(new Rect(0, 0, screenShot.width, screenShot.height), 0, 0);
        screenShot.Apply();

        // see: https://github.com/natmlx/NatShare
        SharePayload payload = new SharePayload();
        payload.AddImage(screenShot);
        payload.Commit();
    }

    private string GetSavePath()
    {
        string directoryPath = Application.temporaryCachePath + "/ar_screenshots/";

        if (!Directory.Exists(directoryPath))
        {
            //まだ存在してなかったら作成
            Directory.CreateDirectory(directoryPath);
        }

        DateTime now = DateTime.Now;
        return directoryPath + now.ToString("yyyyMMddHHmmss") + ".png";
    }
}
