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


    [SerializeField] ChangeShadowModel _ChangeShadowModel;
    [SerializeField] ChangeBrightnessModel _ChangeBrightnessModel;
    [SerializeField] ChangePhiAngleModel _ChangePhiAngleModel;
    [SerializeField] ChangeThetaAngleModel _ChangeThetaAngleModel;

    private void Start() {
        // _ShadowSlider.OnValueChangedAsObservable().Subscribe(value =>  _ChangeShadowModel.SetShadow(value));
        // _BlightnessSlider.OnValueChangedAsObservable().Subscribe(value =>  _ChangeThetaAngleModel.SetThetaAngle(value));
        // _ObjectPhiAngleControllSlider.OnValueChangedAsObservable().Subscribe(value =>  _ChangeBrightnessModel.SetBlightness(value));
        // _ObjectThetaAngleControllSlider.OnValueChangedAsObservable().Subscribe(value =>  _ChangeShadowModel.SetShadow(value));

        _ShadowSlider.OnValueChangedAsObservable().Subscribe(value =>  _ChangeShadowModel.SetShadow(value));
        _BlightnessSlider.OnValueChangedAsObservable().Subscribe(value => _ChangeBrightnessModel.SetBlightness(value));
        _ObjectPhiAngleControllSlider.OnValueChangedAsObservable().Subscribe(value =>  _ChangePhiAngleModel.SetPhiAngle(value));
        _ObjectThetaAngleControllSlider.OnValueChangedAsObservable().Subscribe(value =>  _ChangeThetaAngleModel.SetThetaAngle(value));
  }
}
