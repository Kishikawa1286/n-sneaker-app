using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class ChangeShadowModel : MonoBehaviour
{
    // Start is called before the first frame update

    private readonly FloatReactiveProperty _value = new FloatReactiveProperty(0.0f);
    public IReadOnlyReactiveProperty<float> Value => _value;

     public readonly float MaxShadowValue = 0;
     public readonly float DefaultShadowValue = 0;
    public void SetShadow(float _Value)
    {
                _Value = Mathf.Clamp(_Value, 0, MaxShadowValue);
               //以下影の濃さの処理


        //ここまで
        _value.Value = _Value;


    }
}
