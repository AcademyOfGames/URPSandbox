using TMPro;
using UnityEngine;

[System.Serializable]
public class Achievement
{
    public string ID;
    public string description;
}

public class AchievmentSystem : MonoBehaviour
{
    public Achievement[] allAchievements;
    private int currentAchievementIndex = 0;
    public TextMeshProUGUI result;

    public Achievement currentAchievement;
    public void UnlockAchievement(string achievementID)
    {
        if (achievementID == currentAchievement.ID)
        {
            currentAchievementIndex++;
            if (currentAchievementIndex < allAchievements.Length)
            {
                currentAchievement = allAchievements[currentAchievementIndex];
            }
            else
            {
                //end level
            }
            //UIManager display UI
        }



    }
}
