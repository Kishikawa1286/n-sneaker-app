using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

public class PlacementModePresenter : MonoBehaviour
{
    [SerializeField] private PlacementModeModel _PlacementModeModel;

    [SerializeField] private ButtonView _LightModeButtonView;
    [SerializeField] private ColorToggledImage _LightModeButtonImage;
    [SerializeField] private GameObject _LightModeComponent;

    [SerializeField] private ButtonView _ScreenshotModeButtonView;
    [SerializeField] private ColorToggledImage _ScreenshotModeButtonImage;
    [SerializeField] private GameObject _ScreenshotModeComponent;

    [SerializeField] private ButtonView _PlacementModeButtonView;
    [SerializeField] private ColorToggledImage _PlacementModeButtonImage;

    private void Start()
    {
        _OnTapPlacementModeButton(); // 初期状態はPlacement
        _LightModeButtonView.OnClickAsObservable().Subscribe(_ => _OnTapLightModeButton());
        _ScreenshotModeButtonView.OnClickAsObservable().Subscribe(_ => _OnTapScreenshotModeButton());
        _PlacementModeButtonView.OnClickAsObservable().Subscribe(_ => _OnTapPlacementModeButton());
    }

    private void _OnTapLightModeButton()
    {
        _PlacementModeModel.setUiModeAsLight();
        _LightModeComponent.SetActive(true);
        _ScreenshotModeComponent.SetActive(false);
        _LightModeButtonImage.setEnabledColor();
        _ScreenshotModeButtonImage.setDisabledColor();
        _PlacementModeButtonImage.setDisabledColor();
    }

    private void _OnTapScreenshotModeButton()
    {
        _PlacementModeModel.setUiModeAsScreenshot();
        _LightModeComponent.SetActive(false);
        _ScreenshotModeComponent.SetActive(true);
        _LightModeButtonImage.setDisabledColor();
        _ScreenshotModeButtonImage.setEnabledColor();
        _PlacementModeButtonImage.setDisabledColor();
    }

    private void _OnTapPlacementModeButton()
    {
        _PlacementModeModel.setUiModeAsPlacement();
        _LightModeComponent.SetActive(false);
        _ScreenshotModeComponent.SetActive(false);
        _LightModeButtonImage.setDisabledColor();
        _ScreenshotModeButtonImage.setDisabledColor();
        _PlacementModeButtonImage.setEnabledColor();
    }
}
