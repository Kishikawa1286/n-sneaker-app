using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

class FadingPresenter: MonoBehaviour
{
    [SerializeField] private CanvasFaderView _MoveToDetectPlanesCanvasFaderView;
    [SerializeField] private CanvasFaderView _TapToPlaceCanvasFaderView;

    [SerializeField] private OperationDisplayModel _OperationDisplayModel;

    private void Start() {
        _OperationDisplayModel.IsVisibleMoveToDetectPlanes.Subscribe((value) => _MoveToDetectPlanesCanvasFaderView.Play(!value));
        _OperationDisplayModel.IsVisibleTapToPlace.Subscribe((value) => _TapToPlaceCanvasFaderView.Play(!value));
    }
}
