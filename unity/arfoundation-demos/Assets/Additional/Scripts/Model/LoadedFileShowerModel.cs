using System;
using System.Collections;
using System.IO;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Networking;

public class LoadedFileShowerModel: MonoBehaviour
{
    [SerializeField] private DataManager _dataManager;

    private String _currentFileName = "";

    void Awake()
    {
        _dataManager = Resources.Load<DataManager>("datamanager");
    }

    void Update()
    {
        GameObject child = _dataManager.ModelData;
        String fileName = _dataManager.GlbFileName;
        // ローカルファイルのロードまで終わっていて、かつ指定されているファイルが変わっている
        if (child != null || _currentFileName == fileName) {
            return;
        }
        _currentFileName = fileName;
        child.transform.parent = transform;
    }
}
