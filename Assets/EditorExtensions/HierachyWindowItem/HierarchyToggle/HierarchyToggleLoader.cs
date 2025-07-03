/* 
 * About:
 * Script that adds modifies the drawing of Hierachy Window Items
 * Highlights the hierachy item based on the gameobject monobehaviour component "HierachyHighlight"
 */

#if UNITY_EDITOR

using UnityEngine;
using UnityEditor;

[InitializeOnLoad]
public static class HierarchyToggleLoader
{
    const int Priority = 10;
    static HierarchyToggleLoader() => CustomHierarchyItemsLoader.Add(OnGUI, Priority);

    static void OnGUI(int instanceID, Rect selectionRect)
    {
        GameObject gameObject = (GameObject)EditorUtility.InstanceIDToObject(instanceID);

        if (gameObject == null) return;

        var rect = new Rect
            (selectionRect.x + selectionRect.width - 16f,
            selectionRect.y, 16f, 16f);

        bool isactive = EditorGUI.Toggle(rect, gameObject.activeSelf);
        if (isactive != gameObject.activeSelf) gameObject.SetActive(isactive);
    }
}
#endif