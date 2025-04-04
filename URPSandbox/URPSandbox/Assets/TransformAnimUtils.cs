using UnityEngine;

public class TransformAnimUtils : MonoBehaviour
{
    public float animSpeed;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(0, 1 * animSpeed * Time.deltaTime, 0);
    }
}
