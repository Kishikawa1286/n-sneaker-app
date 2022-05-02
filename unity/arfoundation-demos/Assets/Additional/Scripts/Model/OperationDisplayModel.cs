using System;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

class OperationDisplayModel: MonoBehaviour
{
    private DataManager _dataManager;

    private BoolReactiveProperty _isVisibleMoveToDetectPlanes = new BoolReactiveProperty(true);
    public IReadOnlyReactiveProperty<bool> IsVisibleMoveToDetectPlanes => _isVisibleMoveToDetectPlanes;

    private BoolReactiveProperty _isVisibleTapToPlace = new BoolReactiveProperty(false);
    public IReadOnlyReactiveProperty<bool> IsVisibleTapToPlace => _isVisibleTapToPlace;

    // 秒で指定
    private float visibleMoveToDetectPlanesShowedDuration = 5f;

    private float timeSinceStart = 0f;

    void Awake()
    {
        _dataManager = Resources.Load<DataManager>("datamanager");
    }

    private void Update()
    {
        if (!_isVisibleMoveToDetectPlanes.Value && !_isVisibleTapToPlace.Value)
        {
            return;
        }

        if (timeSinceStart > visibleMoveToDetectPlanesShowedDuration)
        {
            _isVisibleMoveToDetectPlanes.Value = false;
            _isVisibleTapToPlace.Value = true;
        }

        if (_dataManager.Placed)
        {
            _isVisibleMoveToDetectPlanes.Value = false;
            _isVisibleTapToPlace.Value = false;
        }

        timeSinceStart += Time.deltaTime;
    }

    // called from flutter
    private void Initialize()
    {
        timeSinceStart = 0f;
        _isVisibleMoveToDetectPlanes.Value = true;
        _isVisibleTapToPlace.Value = false;
    }
}
