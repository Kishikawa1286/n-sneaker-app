using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;

public class ReloadScene : MonoBehaviour, IEventSystemHandler
{
    // This method is called from Flutter
    public void Reload(String message)
    {
        // https://unity-yuji.xyz/active-scene-re-load/
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
}
