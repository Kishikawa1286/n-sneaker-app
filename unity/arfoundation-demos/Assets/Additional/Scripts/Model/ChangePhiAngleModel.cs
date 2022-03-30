using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class ChangePhiAngleModel : MonoBehaviour
{


    private readonly FloatReactiveProperty _value = new FloatReactiveProperty(0.0f);
    public IReadOnlyReactiveProperty<float> Value => _value;

     public readonly float MaxPhiAngle = 0;
     public readonly float MinPhiAngle = 0;
     public readonly float DefaultPhiAngle = 0;
    public void SetPhiAngle(float _Value)
    {
 _Value = Mathf.Clamp(_Value, MinPhiAngle, MaxPhiAngle);
        //以下φの角度の処理

        //
        _value.Value = _Value;
    }
}
