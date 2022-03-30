using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EffectSliderPresenter : MonoBehaviour
{
    [SerializeField] Slider _ShadowSlider;
    [SerializeField] Slider _BlightnessSlider;
    [SerializeField] Slider _ObjectPhiAngleControllSlider;
    [SerializeField] Slider _ObjectThetaAngleControllSlider;


    [SerializeField] ChangePhiAngleModel _ChangePhiAngleModel;
    [SerializeField] ChangeThetaAngleModel _ChangeThetaAngleModel;
    [SerializeField] ChangeBrightnessModel _ChangeBrightnessModel;
    [SerializeField] ChangeShadowModel _ChangeShadowModel;

    private void Awake() {
        
    }
}
