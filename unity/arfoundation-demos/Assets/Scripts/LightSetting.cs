using System;
using UnityEngine;
using UnityEngine.EventSystems;

public class LightSetting : MonoBehaviour, IEventSystemHandler
{
    // 0 <= Intensity <= 2
    [SerializeField]
    float Intensity;

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
        Intensity = 1;
        Theta = ToRadian(0);
        Phi = ToRadian(45);
    }

    // Update is called once per frame
    void Update()
    {
        // direction vector
        Vector3 direction = new Vector3(
            (float)(Math.Sin(Phi) * Math.Sin(Theta)),
            (float)(Math.Cos(Phi)),
            (float)(Math.Sin(Phi) * Math.Cos(Theta)));
        gameObject.transform.position = 100 * direction;
        gameObject.transform.rotation = Quaternion.Euler(-Phi, 0, -Theta);
        dlight.intensity = Intensity;
    }

    // This method is called from Flutter
    public void SetIntensity(String message)
    {
        Intensity = float.Parse(message);
    }

    // This method is called from Flutter
    public void SetTheta(String message)
    {
        Theta = ToRadian(float.Parse(message));
    }

    // This method is called from Flutter
    public void SetPhi(String message)
    {
        Phi = ToRadian(float.Parse(message));
    }

    private float ToRadian(float angle)
    {
        return (float)(angle * Math.PI / 180);
    }
}
