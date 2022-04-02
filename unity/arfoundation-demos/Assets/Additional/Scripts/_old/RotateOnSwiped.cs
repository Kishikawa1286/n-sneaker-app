// ref: https://www.youtube.com/watch?v=7Ja67KpKLXw
using UnityEngine;

public class RotateOnSwiped : MonoBehaviour
{
    private DataManager _dataManager;

    private Touch touch;

    private Quaternion rotationY;

    private float speedModifier = 0.4f;

    void Awake()
    {
        _dataManager = Resources.Load<DataManager>("datamanager");
    }

    void Update()
    {
        if (_dataManager.UiMode == "Placement")
        {
            if (Input.touchCount > 0)
            {
                touch = Input.GetTouch(0);
                if (touch.phase == TouchPhase.Moved)
                {
                    rotationY = Quaternion.Euler(0f, -touch.deltaPosition.x * speedModifier, 0f);
                    transform.rotation = rotationY * transform.rotation;
                }
            }
        }
    }
}