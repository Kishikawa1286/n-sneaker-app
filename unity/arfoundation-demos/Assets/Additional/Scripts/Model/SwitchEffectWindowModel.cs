using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class SwitchEffectWindowModel : MonoBehaviour
{
    public BoolReactiveProperty _isOn = new BoolReactiveProperty(false);

    //式形式で実装：https://docs.microsoft.com/ja-jp/dotnet/csharp/programming-guide/statements-expressions-operators/expression-bodied-members
    //C# 6 以降では、式本体の定義を使用して読み取り専用プロパティを実装することができます
    public IReadOnlyReactiveProperty<bool> IsOn => _isOn;
        public void SwitchValue(bool isOn)
    {
        //Debug.Log("SwitchValue");
        _isOn.Value = isOn;
    }
}
