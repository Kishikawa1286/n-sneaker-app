using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.Networking;
using UniRx;

public class ScreenshotPresenter: MonoBehaviour
{
    [SerializeField] ScreenshotModel _ScreenshotModel;
    [SerializeField] ButtonView _ScreenshotButtonView;

    void Start()
    {
        _ScreenshotButtonView.OnClickAsObservable().Subscribe(_ => _ScreenshotModel.ShareScreenshot());
    }
}
