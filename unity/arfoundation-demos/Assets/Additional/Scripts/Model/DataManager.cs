using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CreateAssetMenu]
public class DataManager: ScriptableObject
{
  // GLBファイルの読込中や読込前はnull
  public GameObject ModelData = null;

  // GLBファイルの読込中や読込前はnull
  public string GlbFileName = "";

  // GLBファイルの読込中や読込前はnull
  public string GlbFileDownloadUrl = "";
}
