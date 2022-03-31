using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class SwitchEffectWindowModel : MonoBehaviour
{
  // //_isOnにはBool型のReactivePropertyを設定．get,setの両方ができる．
  // public BoolReactiveProperty _isOn = new BoolReactiveProperty(false);

  // //式形式で実装：https://docs.microsoft.com/ja-jp/dotnet/csharp/programming-guide/statements-expressions-operators/expression-bodied-members
  // //C# 6 以降では、式本体の定義を使用して読み取り専用プロパティを実装することができます
  // //プライベートBoolReactivePropertyの値を返す，読み取り専用のIReadOnlyReactivePropertyを実装．これにより，Bool型のReactivePropertyはgetしかできない．
  // public IReadOnlyReactiveProperty<bool> IsOn => _isOn;

  // //別のクラスからアクセスするために，SwitchValue関数を作成．
  //  /// bool値の状態を変更する
  // public void SwitchValue(bool isOn)
  // {
  //     //Debug.Log("SwitchValue");
  //     _isOn.Value = isOn;
  // }

  public BoolReactiveProperty _isOn = new BoolReactiveProperty(false);
  public IReadOnlyReactiveProperty<bool> IsOn
  {
    get { return _isOn; }
  } 

  public void SwitchValue(bool isOn)
  {
    _isOn.Value = isOn;
  }
}
