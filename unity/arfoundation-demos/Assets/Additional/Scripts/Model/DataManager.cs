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
  // Light / Placement / Screenshot
  //  UIの状態を動的に生成されるgameObjectに伝えるための変数
  public string UiMode = "Placement";

  // オブジェクトが設置されているかどうか
  public bool Placed = false;
}
