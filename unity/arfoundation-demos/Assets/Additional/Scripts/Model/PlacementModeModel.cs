using System;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class PlacementModeModel : MonoBehaviour
{
  private DataManager _dataManager;

  void Awake()
  {
    _dataManager = Resources.Load<DataManager>("datamanager");
    _UiMode.Value = _initialUiMode; // シーンリロード時にdata managerの値を初期値に
  }

  // Light / Placement / Screenshot
  // どのUIを表示するのかの設定
  private ReactiveProperty<String> _UiMode = new ReactiveProperty<String>(_initialUiMode);
  public ReactiveProperty<String> UiMode => _UiMode;
  static private String _initialUiMode = "Placement";

  private void _setUIMode(string mode)
  {
    _UiMode.Value = mode;
    _dataManager.UiMode = mode;
  }

  public void setUiModeAsPlacement() => _setUIMode("Placement");

  public void setUiModeAsLight() => _setUIMode("Light");

  public void setUiModeAsScreenshot() => _setUIMode("Screenshot");
}
