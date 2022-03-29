using System.Collections;
using System.Collections.Generic;
using System;//IObservableがUniRXとSystemで競合するため，Systemを記述．
using UnityEngine;
using UniRx;
using UnityEngine.UI;

public class SwitchEffectWindowView : MonoBehaviour
{
    [SerializeField] private Toggle _switchEffectWindowToggle;
    // Start is called before the first frame update
     private Subject<bool> _OnToggleClicked = new Subject<bool>();
    public IObservable<bool> OnToggleClicked => _OnToggleClicked;
    private void Awake()
    {
        _switchEffectWindowToggle.OnValueChangedAsObservable().Subscribe(_OnToggleClicked.OnNext);
    }
    
    //C# 7.0 以降では、式形式で値の変更が可能．
    public void ActivateToggle(bool isOn) => _switchEffectWindowToggle.isOn = isOn;
    // Update is called once per frame
}
