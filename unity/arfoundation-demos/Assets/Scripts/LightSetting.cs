using System;
using UnityEngine;
using UnityEngine.EventSystems;

public class LightSetting : MonoBehaviour, IEventSystemHandler
{
    // 0 <= Intensity <= 2
    [SerializeField]
    float Intensity;

    // 0 <= ShadowStrength <= 1
    [SerializeField]
    float ShadowStrength;

    // [rad]
    // -180 <= Theta <= 180
    [SerializeField]
    float Theta;

    // [rad]
    // 0 <= Phi <= 90
    [SerializeField]
    float Phi;

    Light dlight;

    // Start is called before the first frame update
    void Start()
    {
        dlight = gameObject.GetComponent<Light>();
        Intensity = 1f;
        ShadowStrength = 0.8f;
        Theta = 0f * Mathf.Deg2Rad;
        Phi = 45f * Mathf.Deg2Rad;
    }

    // Update is called once per frame
    void Update()
    {
        // ref: https://yowabi.blogspot.com/2018/06/unity.html
        // direction vector
        Vector3 direction = new Vector3(
            Mathf.Sin(Phi) * Mathf.Sin(Theta),
            Mathf.Cos(Phi),
            Mathf.Sin(Phi) * Mathf.Cos(Theta));
        gameObject.transform.position = 100 * direction;
        gameObject.transform.rotation = Quaternion.FromToRotation(Vector3.up, -direction);
        dlight.intensity = Intensity;
        dlight.shadowStrength = ShadowStrength;
    }

    // This method is called from Flutter
    public void SetIntensity(String message)
    {
        Intensity = float.Parse(message);
    }

    // This method is called from Flutter
    public void SetShadowStrength(String message)
    {
        ShadowStrength = float.Parse(message);
    }


    // This method is called from Flutter
    public void SetTheta(String message)
    {
        Theta = float.Parse(message) * Mathf.Deg2Rad;
    }

    // This method is called from Flutter
    public void SetPhi(String message)
    {
        Phi = float.Parse(message) * Mathf.Deg2Rad;
    }
}
