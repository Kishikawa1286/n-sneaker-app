using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UniRx;

public class FileLoadingPresenter : MonoBehaviour
{
    [SerializeField] private Slider _DownloadProgressBar;
    [SerializeField] private GameObject _DownloadProgressWindow;

    [SerializeField] private Slider _LocalFileLoadingProgressBar;
    [SerializeField] private GameObject _LocalFileLoadingProgressWindow;

    [SerializeField] private FileLoadModel _FileLoadModel;

    void Start()
    {
        _FileLoadModel.downloading.Subscribe((value) => _DownloadProgressWindow.SetActive(value));
        _FileLoadModel.downloadProgress.Subscribe((value) => _DownloadProgressBar.value = value);
        _FileLoadModel.localFileLoading.Subscribe(
            (value) => _LocalFileLoadingProgressWindow.SetActive(value));
        _FileLoadModel.localFileLoadingProgress.Subscribe(
            (value) => _LocalFileLoadingProgressBar.value = value);
    }
}