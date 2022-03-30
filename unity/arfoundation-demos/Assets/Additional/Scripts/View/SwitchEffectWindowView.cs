using System.Collections;
using System.Collections.Generic;
using System;//IObservableがUniRXとSystemで競合するため，Systemを記述．
using UnityEngine;
using UniRx;
using UnityEngine.UI;
using Cysharp.Threading.Tasks;

public class SwitchEffectWindowView : MonoBehaviour
{
  // 
  // [SerializeField] private Toggle _switchEffectWindowToggle;
  // // イベント発効の核クラスを_OnToggleClickedとして発効．

  // //https://qiita.com/toRisouP/items/2f1643e344c741dd94f8#4iobserver%E3%81%A8iobservable
  // private Subject<bool> _OnToggleClicked = new Subject<bool>();
  // // _OnToggleClickedの機能を_OnToggleClickedだけに制限．
  // public IObservable<bool> OnToggleClicked => _OnToggleClicked;
  // private void Awake()
  // {
  //     //引数の値を受け取り時に実行する関数を登録する
  //     //_switchEffectWindowToggle.OnValueChangedAsObservable()はIobservable.引数として，IObserverを登録．
  //     _switchEffectWindowToggle.OnValueChangedAsObservable().Subscribe(_OnToggleClicked.OnNext);
  // }

  // //C# 7.0 以降では、式形式で値の変更が可能．
  // //ActiveToggle関数を用いて，引数isOnを_switchEffectWindowToggle.isOnに設定.
  // /// トグルの表示状態を変更する
  // public void ActivateToggle(bool isOn) => _switchEffectWindowToggle.isOn = isOn;
  // // Update is called once per frame

  [SerializeField] private GameObject _ScreenShotComponent;
  [SerializeField] private GameObject _EffectComponent;

  [SerializeField] private Toggle _SwitchEffectWindowToggle;

  private Subject<bool> _OnToggleClicked = new Subject<bool>();
  public IObservable<bool> OnToggleClicked 
  {
        get { return _OnToggleClicked; }
  }

  private void Awake()
  {
    //ゲーム開始時にイベントを登録しておけば，後から好きなタイミングでイベントを購読できる．
    //ここでは，トグルの値が変更されたタイミングでイベントが発効されるように，ゲーム開始時に登録している．
    _SwitchEffectWindowToggle.OnValueChangedAsObservable().Subscribe(_OnToggleClicked.OnNext);
  }

  public void SwitchEffectWindow(bool isOn)
  {
    if(isOn)
    {
        _ScreenShotComponent.SetActive(false);
        _EffectComponent.SetActive(true);
    }
    else
    {
        _ScreenShotComponent.SetActive(true);
        _EffectComponent.SetActive(false);
    }
  }
}
