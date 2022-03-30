using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class ChangeShadowModel : MonoBehaviour
{
    // Start is called before the first frame update

    private readonly FloatReactiveProperty _value = new FloatReactiveProperty(0.0f);
    public IReadOnlyReactiveProperty<float> SetValue => _value;

     public readonly float MaxShadowValue = 0;
     public readonly float DefaultShadowValue = 0;
    public void SetShadow(float Value)
    {
        _value.Value = Value;

        //以下影の濃さの処理
    }
}
