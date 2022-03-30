using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class ChangeThetaAngleModel : MonoBehaviour
{
    // Start is called before the first frame update
        private readonly FloatReactiveProperty _value = new FloatReactiveProperty(0.0f);
    public IReadOnlyReactiveProperty<float> Value => _value;


//残りの4つも同様に宣言をしてる
         public readonly float MaxThetaAngle = 0;
     public readonly float MinThetaAngle = 0;
     public readonly float DefaultThetaAngle = 0;
    public void SetThetaAngle(float _Value)
    {
        _Value = Mathf.Clamp(_Value, MinThetaAngle, MaxThetaAngle);
        //以下θの角度の処理

        //ここまで
        _value.Value = _Value;
    }
    
}
