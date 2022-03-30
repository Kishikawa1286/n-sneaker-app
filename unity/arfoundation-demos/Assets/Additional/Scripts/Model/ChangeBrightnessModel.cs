using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class ChangeBrightnessModel : MonoBehaviour
{
    private readonly FloatReactiveProperty _value = new FloatReactiveProperty(0.0f);
    public IReadOnlyReactiveProperty<float> Value => _value;//getterの簡略記法

     public readonly float MaxBlightnessValue = 100;
     public readonly float DefaultBlightnessValue = 0;
    public void SetBlightness(float _Value)
    {
        _Value = Mathf.Clamp(_Value, 0, MaxBlightnessValue);
    //以下明るさの処理

    Debug.Log(_Value);
    //
    _value.Value = _Value;

    }
}
