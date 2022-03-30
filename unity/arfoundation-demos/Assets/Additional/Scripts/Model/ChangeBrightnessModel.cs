using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class ChangeBrightnessModel : MonoBehaviour
{
    private readonly FloatReactiveProperty _value = new FloatReactiveProperty(0.0f);
    public IReadOnlyReactiveProperty<float> SetValue => _value;

     public readonly float MaxBlightnessValue = 0;
     public readonly float DefaultBlightnessValue = 0;
    public void SetBlightness(float Value)
    {
        _value.Value = Value;

        //以下明るさの処理
    }
}
