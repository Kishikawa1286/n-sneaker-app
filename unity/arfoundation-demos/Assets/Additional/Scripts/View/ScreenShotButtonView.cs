// using System.Collections;
// using System.Collections.Generic;
// using UnityEngine;

// public class ScreenShotButtonView : MonoBehaviour
// {
//     // Start is called before the first frame update
//     void Start()
//     {
        
//     }

//     // Update is called once per frame
//     void Update()
//     {
        
//     }
// }

using System;
using UnityEngine;
using UniRx;
using UnityEngine.UI;

class ScreenShotButtonView : MonoBehaviour
{
  private Button _ScreenShotButton;

  //IObservableインターフェースは、Rxにおける「イベントメッセージを購読できる」ふるまい．
  // Unit型は「メッセージの中身に意味は無い」ときに利用。
  //「イベントが発行されたタイミングが重要であって、OnNextメッセージの中身は何でもいい」場合に利用できる

    private void Awake() => _ScreenShotButton = this.gameObject.GetComponent<Button>();

  public IObservable<Unit> OnClickAsObservable()
  {
    return _ScreenShotButton.OnClickAsObservable();
  }
}