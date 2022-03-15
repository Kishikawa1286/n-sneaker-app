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
        GameObject target = GameObject.Find("Target Sneaker");
        Destroy(target);

        session.Reset();
    }
}
