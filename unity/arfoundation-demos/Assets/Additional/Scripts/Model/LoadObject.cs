using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public class LoadObject : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField]
    private BoolReactiveProperty IsFileDownloaded = new BoolReactiveProperty(false);
    private BoolReactiveProperty IsFileLoaded = new BoolReactiveProperty(false);



    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
