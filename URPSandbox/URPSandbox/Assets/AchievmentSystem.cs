using System.Collections.Generic;
using TMPro;
using UnityEngine;

[System.Serializable]
public class Achievement
{
    public string name;
    public string description;
    public bool achieved;
}

public class AchievmentSystem : MonoBehaviour
{
    public Achievement[] allAchievements;
    public TextMeshProUGUI result;
    
    public List<Achievement> unlockedAchievements;
    public void UnlockAchievement(string achievementName)
    {
        foreach (var achievment in allAchievements)
        {
            if (achievementName.Contains(achievment.name) && !unlockedAchievements.Contains(achievment))
            {
                if(achievment.achieved == true){
                    break;
                }
                achievment.achieved = true;
                result.text = achievment.description;
                unlockedAchievements.Add(achievment);
                break;
            }
            else
            {
                result.text = achievementName + " already unlocked or doesn't exist";
            }
        }
    }
}
