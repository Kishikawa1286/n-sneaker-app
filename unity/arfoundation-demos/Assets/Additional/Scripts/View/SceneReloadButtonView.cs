using System;//IObservableがUniRXとSystemで競合するため，Systemを記述．
using UnityEngine;
using UniRx;
using UnityEngine.UI;

class SceneReloadButtonView : MonoBehaviour
{
  private Button _ScneReloadButton;

  //IObservableインターフェースは、Rxにおける「イベントメッセージを購読できる」ふるまい．
  // Unit型は「メッセージの中身に意味は無い」ときに利用。
  //「イベントが発行されたタイミングが重要であって、OnNextメッセージの中身は何でもいい」場合に利用できる

  void Awake() => _ScneReloadButton = this.gameObject.GetComponent<Button>();
  public IObservable<Unit> OnClickAsObservable()
  {
    return _ScneReloadButton.OnClickAsObservable();
  }
}