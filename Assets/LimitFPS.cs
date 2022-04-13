using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LimitFPS : MonoBehaviour
{
    private bool isvSyncOn = false;
    public void Start()
    {
        QualitySettings.vSyncCount = isvSyncOn ? 0 : 4;
    }

    public void SetTargetFPS(int fps)
    {
        Application.targetFrameRate = fps;
    }
    
    public void ChangevSync()
    {
        isvSyncOn = !isvSyncOn;
        QualitySettings.vSyncCount = isvSyncOn ? 0 : 1;
    }
}
