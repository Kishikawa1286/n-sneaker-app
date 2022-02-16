using System;
using UnityEngine;
using UnityEngine.EventSystems;
using System.IO;

public class ScreenShot : MonoBehaviour, IEventSystemHandler
{
    // This method is called from Flutter
    // capture entire screen
    // needs file path as message from flutter
    // https://nekojara.city/unity-screenshot
    private void CaptureScreenShot(string filePath)
    {
        ScreenCapture.CaptureScreenshot(filePath);
    }
}
