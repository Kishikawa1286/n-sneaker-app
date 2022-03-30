using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System;
using UnityEngine.UI;
using NatSuite.Sharing;

public class ScreenshotModel : MonoBehaviour
{
  // Start is called before the first frame update
  [SerializeField] private Camera ArCam;

  public void ShareScreenshot()
    {
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
}
