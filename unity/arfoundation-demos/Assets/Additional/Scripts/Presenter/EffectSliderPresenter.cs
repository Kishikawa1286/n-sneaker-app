using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

public class EffectSliderPresenter : MonoBehaviour
{
    [SerializeField] Slider _ShadowSlider;
    [SerializeField] Slider _BlightnessSlider;
    [SerializeField] Slider _ObjectPhiAngleControllSlider;
    [SerializeField] Slider _ObjectThetaAngleControllSlider;

    [SerializeField] DirectionalLightModel _DirectionalLightModel;

    private void Start() {
        _ShadowSlider.OnValueChangedAsObservable().Subscribe(value =>  _DirectionalLightModel.SetShadowStrength(value));
        _BlightnessSlider.OnValueChangedAsObservable().Subscribe(value => _DirectionalLightModel.SetIntensity(value));
        _ObjectPhiAngleControllSlider.OnValueChangedAsObservable().Subscribe(value =>  _DirectionalLightModel.SetPhi(value));
        _ObjectThetaAngleControllSlider.OnValueChangedAsObservable().Subscribe(value =>  _DirectionalLightModel.SetTheta(value));
    }
}
