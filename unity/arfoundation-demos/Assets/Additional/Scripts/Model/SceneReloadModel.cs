using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.XR.ARFoundation;

public class SceneReloadModel : MonoBehaviour, IEventSystemHandler
{
  private UnityMessageManager _UnityMessageManager;

  void Awake()
  {
    _UnityMessageManager = GetComponent<UnityMessageManager>();
  }

  public void SceneReload()
  {
    SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    _UnityMessageManager.SendMessageToFlutter("[[RELOADED]]");
  }
}
