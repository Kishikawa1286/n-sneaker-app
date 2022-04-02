using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;

public class SceneReloadModel : MonoBehaviour, IEventSystemHandler
{
  public void SceneReload()
  {
    SceneManager.LoadScene(SceneManager.GetActiveScene().name);
  }
}
