using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.Networking;
using UniRx;

public class SceneReloadPresenter: MonoBehaviour
{
    [SerializeField] SceneReloadModel _SceneReloadModel;
    [SerializeField] ButtonView _SceneReloadButtonView;

    void Start()
    {
        _SceneReloadButtonView.OnClickAsObservable().Subscribe(_ => _SceneReloadModel.SceneReload());
    }
}
