using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

public class ObjectDisplayPresenter : MonoBehaviour
{
  // Start is called before the first frame update

    [SerializeField] ScreenshotModel _ScreenShotModel;
    [SerializeField] SceneReloadModel _SceneReloadModel;

    [SerializeField] SwitchEffectWindowModel _SwitchEffectWindowModel;

    [SerializeField] SwitchEffectWindowView _SwitchEffectWindowView;

    [SerializeField] SceneReloadButtonView _SceneReloadButtonView;
    [SerializeField] ScreenShotButtonView _ScreenShotButtonView;

    //sliderはpresenter->model間のやりとりで簡潔




  void Start()
    {
    //from View to Model
    //subscribeは，Subjectに実行してほしい関数を登録する処理
    _SceneReloadButtonView.OnClickAsObservable().Subscribe(_ => _SceneReloadModel.SceneReload());
    //_ReloadButton.onClick.AsObservable().Subscribe(_ => _SceneReloadModel.SceneReload());
    _ScreenShotButtonView.OnClickAsObservable().Subscribe(_ => _ScreenShotModel.Screenshot());
    // _ScreenShotButton.onClick.AsObservable().Subscribe(_ => _ScreenShotModel.Screenshot());

    //UniRXの仕様がよくわかってないので，一度保留．
    //ViewのToggleの値が変更された場合，Modelへ通知する．さらに，bool値の状態を変更する．
    //（.OneNextは強制的にイベントを発効するだけ．別にイベントが発効できるなら，.OnNextを使わなくてもよい）
    _SwitchEffectWindowModel.IsOn.Subscribe(_SwitchEffectWindowView.SwitchEffectWindow);
    _SwitchEffectWindowView.OnToggleClicked.Subscribe(_SwitchEffectWindowModel.SwitchValue);

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
