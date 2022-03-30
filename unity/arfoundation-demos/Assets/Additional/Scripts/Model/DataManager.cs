using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CreateAssetMenu]
public class DataManager : ScriptableObject
{

  public GameObject ModelData = null;
  public string ModelDataName = "";
  public float Theta = 0.0f;
  public float Phi = 0.0f;
  public float ShadowStrength = 0.0f;
  public float intensity = 0.0f;
  public bool IsModelRoaded = false;

  void Awake()
  {
    IsModelRoaded = false;
  }
  void OnDestroy()
  {
    IsModelRoaded = false;
    ModelData = null;
    ModelDataName = "";
  }

  // public void SetDataManager(GameObject _ModelData, string _ModelDataName)
  // {
  //   ModelData = _ModelData;
  //   ModelDataName = _ModelDataName;
  // }

  //  private void OnDestroy() {
  //   RawData = null;
  // }
}

