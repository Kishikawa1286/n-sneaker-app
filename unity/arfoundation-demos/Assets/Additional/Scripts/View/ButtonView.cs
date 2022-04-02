using System;//IObservableがUniRXとSystemで競合するため，Systemを記述．
using UnityEngine;
using UniRx;
using UnityEngine.UI;

class ButtonView : MonoBehaviour
{
  private Button _Button;

  void Awake() => _Button = this.gameObject.GetComponent<Button>();

  public IObservable<Unit> OnClickAsObservable() => _Button.OnClickAsObservable();
}