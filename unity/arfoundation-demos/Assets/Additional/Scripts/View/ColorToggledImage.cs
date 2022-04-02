using System;//IObservableがUniRXとSystemで競合するため，Systemを記述．
using UnityEngine;
using UniRx;
using UnityEngine.UI;

public class ColorToggledImage: MonoBehaviour
{
    private Image _Image;

    void Awake() => _Image = this.gameObject.GetComponent<Image>();

    private Color _EnabledColor = new Color32(107, 154, 255, 255);
    private Color _DisabledColor = new Color32(242, 242, 242, 255);

    public void setEnabledColor()
    {
        _Image.color = _EnabledColor;
    }

    public void setDisabledColor()
    {
        _Image.color = _DisabledColor;
    }
}
