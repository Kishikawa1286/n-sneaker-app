// see: https://www.youtube.com/watch?v=7Ja67KpKLXw
using UnityEngine;

public class RotateOnSwiped : MonoBehaviour
{
    private DataManager _dataManager;

    private float speedModifier = 0.4f;

    private float formerDist;
    private float minRate = 0.3f;
    private float maxRate = 3f;

    void Awake()
    {
        _dataManager = Resources.Load<DataManager>("datamanager");
    }

    void Update()
    {
        if (_dataManager.UiMode != "Placement")
        {
            return;
        }

        if (Input.touchCount <= 0)
        {
            return;
        }

        if (Input.touchCount == 1)
        {
            Touch touch = Input.GetTouch(0);
            if (touch.phase == TouchPhase.Moved)
            {
                Quaternion rotationY = Quaternion.Euler(0f, -touch.deltaPosition.x * speedModifier, 0f);
                transform.rotation = rotationY * transform.rotation;
            }
            return;
        }

        // in case that: Input.touchCount >= 2
        // see: https://www.omoshiro-suugaku.com/entry/unity-drag-pinchin-out

        Touch touch1 = Input.GetTouch(0);
        Touch touch2 = Input.GetTouch(1);

        if (touch2.phase == TouchPhase.Began)
        {
            formerDist = Vector2.Distance(touch1.position, touch2.position);
            return;
        }

        // 2本指が画面に触れたまま、触れている2点が移動している場合のみ通過
        if (touch1.phase != TouchPhase.Moved || touch2.phase != TouchPhase.Moved)
        {
            return;
        }

        float dist = Vector2.Distance(touch1.position, touch2.position);
        // 指の間の距離が狭すぎる場合
        if (dist < 0.001f) {
            return;
        }

        float scale = transform.localScale.x;
        scale += (dist - formerDist) / 230f;
        if (scale > maxRate)
        {
            scale = maxRate;
        }
        if (scale < minRate)
        {
            scale = minRate;
        }
        formerDist = dist;
        transform.localScale = new Vector3(scale, scale, scale);
    }
}