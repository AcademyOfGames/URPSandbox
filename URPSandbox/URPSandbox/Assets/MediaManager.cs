using UnityEngine;
using UnityEngine.Video;

public class MediaManager : MonoBehaviour
{
    int currentClipIndex = 0;
    public VideoClip[] clips;
    private VideoPlayer player;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        player = FindAnyObjectByType<VideoPlayer>();
    }

    public void UpdateClipIndex(int clipIndex)
    {
        if (clipIndex < 0)
        {
            currentClipIndex = clips.Length - 1;
        }
        else if (clipIndex >= clips.Length)
        {
            currentClipIndex = 0;
        }
        else
        {
            currentClipIndex += clipIndex;
        }
        player.clip = clips[currentClipIndex];
        player.Play();

    }
    // Update is called once per frame
    void Update()
    {

    }
}
