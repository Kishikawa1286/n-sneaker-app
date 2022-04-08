using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class DirectionalLightModel : MonoBehaviour
{
    [SerializeField] GameObject directionalLight;

    private Light _light;

    void Start()
    {
        _light = directionalLight.GetComponent<Light>();
    }

    private void setLightDirection()
    {
        float theta = _theta.Value * Mathf.Deg2Rad;
        float phi = _phi.Value * Mathf.Deg2Rad;
        // see: https://yowabi.blogspot.com/2018/06/unity.html
        // direction vector
        Vector3 direction = new Vector3(
            Mathf.Sin(phi) * Mathf.Sin(theta),
            Mathf.Cos(phi),
            Mathf.Sin(phi) * Mathf.Cos(theta));
        directionalLight.transform.position = 100 * direction;
        directionalLight.transform.LookAt(new Vector3(0, 0, 0));
    }

    // 定数
    public readonly float MaxIntensity = 2f;
    public readonly float MinIntensity = 0.01f;
    static public readonly float DefaultIntensity = 1f;
    // Presenter で呼び出される更新処理
    public void SetIntensity(float _Value)
    {
        // see: https://yowabi.blogspot.com/2018/06/unity.html
        _light.intensity = Mathf.Clamp(_Value, MinIntensity, MaxIntensity);
    }

    // 影の濃さ
    // 定数
    public readonly float MaxShadowStrength = 1f;
    public readonly float MinShadowStrength = 0f;
    static public readonly float DefaultShadowStrength = 0.8f;
    // Presenter で呼び出される更新処理
    public void SetShadowStrength(float _Value)
    {
        // see: https://yowabi.blogspot.com/2018/06/unity.html
        _light.shadowStrength = Mathf.Clamp(_Value, MinShadowStrength, MaxShadowStrength);

    }

    // θ
    private readonly FloatReactiveProperty _theta = new FloatReactiveProperty(DefaultTheta);
    // 定数
    public readonly float MaxTheta = 180f;
    public readonly float MinTheta = -180f;
    static public readonly float DefaultTheta = 0f;
    // Presenter で呼び出される更新処理
    public void SetTheta(float _Value)
    {
        _theta.Value = Mathf.Clamp(_Value, MinTheta, MaxTheta);
        setLightDirection();
    }

    // φ
    private readonly FloatReactiveProperty _phi = new FloatReactiveProperty(DefaultPhi);
    // 定数
    public readonly float MaxPhi = 0f;
    public readonly float MinPhi = -70f;
    static public readonly float DefaultPhi = -35f;
    // Presenter で呼び出される更新処理
    public void SetPhi(float _Value)
    {
        _phi.Value = Mathf.Clamp(_Value, MinPhi, MaxPhi);
        setLightDirection();
    }
}
