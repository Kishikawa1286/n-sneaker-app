using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UniRx;

// 現在は使っていない
// シーンを超えてGameObjectを保存しておいて読み込みを短縮する実装をするときに使う
[CreateAssetMenu]
public class DataManager: ScriptableObject
{
  // GLBファイルの読込中や読込前はnull
  public string GlbFileName = "";

  // GLBファイルの読込中や読込前はnull
  public string GlbFileDownloadUrl = "";
}
