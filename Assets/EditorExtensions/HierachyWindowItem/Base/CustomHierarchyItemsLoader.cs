/* 
 * About:
 * Base hierarchyWindowItemOnGUI Loader script that loads and runs custom Actions/Functions being registered in priority oreder 
 * 
 * How to use:
 * Use Add() to register your custom HierachyItem OnGUI Action/Function
 * 
 */

#if UNITY_EDITOR

using System.Collections.Generic;
using System;
using UnityEditor;
using UnityEngine;
using System.Linq;

[InitializeOnLoad]
public static class CustomHierarchyItemsLoader
{
    static CustomHierarchyItemsLoader()
    {
        EditorApplication.hierarchyWindowItemOnGUI = Load;
    }

    static readonly List<(Action<int, Rect>, int)> actions = new();

    public static void Add(Action<int, Rect> action, int priority)
    {
        actions.Add((action, priority));
    }

    private static void Load(int instanceID, Rect selectionRect)
    {
        var orderedActions = actions.OrderByDescending(i => i.Item2).Select(i => i.Item1);
        foreach (var action in orderedActions)
        {
            action.Invoke(instanceID, selectionRect);
        }
    }
}
#endif