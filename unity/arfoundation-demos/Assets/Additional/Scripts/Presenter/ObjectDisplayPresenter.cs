using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

public class ObjectDisplayPresenter : MonoBehaviour
{
  // Start is called before the first frame update
    [SerializeField] Button _ScreenShotButton;
    [SerializeField] Toggle _ChangeEffectToggle;
    [SerializeField] Button _ReloadButton;
    [SerializeField] ScreenshotModel _ScreenShotModel;
    [SerializeField] SceneReloadModel _SceneReloadModel;

    [SerializeField] SwitchEffectWindowModel _SwitchEffectWindowModel;

    [SerializeField] SwitchEffectWindowView _SwitchEffectWindowView;


    void Start()
    {
        //from View to Model
        _ReloadButton.onClick.AsObservable().Subscribe(_ => _SceneReloadModel.SceneReload());
        _ScreenShotButton.onClick.AsObservable().Subscribe(_ => _ScreenShotModel.Screenshot());

        //UniRXの仕様がよくわかってないので，一度保留．

        //ViewのToggleの値が変更された場合，Modelへ通知する．さらに，bool値の状態を変更する．
        //_SwitchEffectWindowView.OnToggleClicked.Subscribe(_SwitchEffectWindowModel.SwitchValue).AddTo(this);
        // _ChangeEffectToggle.OnValueChangedAsObservable()
        // .Where(x => x == true)
        // .Subscribe(_ChangeEffectToggle.isOn => 
        // {
        //     _ScreenShotButton.GetComponent<GameObject>().SetActive(false);
        //     _ScreenShotButton.GetComponent<GameObject>().SetActive(false);
        // });

  }
}
