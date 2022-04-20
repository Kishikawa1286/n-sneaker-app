using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.XR.ARFoundation;

public class TrackingToggkerModel : MonoBehaviour, IEventSystemHandler
{
  [SerializeField] private ARSession _ARSession;

  // called from flutter
  private void EnableCamera()
  {
    _ARSession.enabled = true;
  }

  // called from flutter
  private void DisableCamera()
  {
    _ARSession.enabled = false;
  }
}
