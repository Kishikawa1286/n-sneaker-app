using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.XR.ARFoundation;
// using UnityEngine.XR.ARSubsystems;

public class ReloadScene : MonoBehaviour, IEventSystemHandler
{
    [SerializeField]
    private ARSession session;

    // This method is called from Flutter
    public void Reload(String message)
    {
        #if UNITY_IOS
            SceneManager.LoadScene(SceneManager.GetActiveScene().name);
        #endif
        // GameObject target = GameObject.Find("Target Sneaker");
        // Destroy(target);

        // session.Reset();
    }
}
