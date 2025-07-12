/* 
 * About:
 * Script that adds modifies the drawing of Hierachy Window Items
 * Highlights the hierachy item based on the gameobject monobehaviour component "HierachyHighlight"
 */

#if UNITY_EDITOR

using System;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;

[InitializeOnLoad]
public static class HierachyHighlightLoader
{
    const int Priority = 100;
    static HierachyHighlightLoader() => CustomHierarchyItemsLoader.Add(OnGUI, Priority);

    static void OnGUI(int instanceID, Rect selectionRect)
    {
        UnityEngine.Object instance = EditorUtility.InstanceIDToObject(instanceID);

        if (instance == null) return;

        if (!(instance as GameObject).TryGetComponent<HierachyHighlight>(out var highlight)) return;

        HierarchyItem item = new HierarchyItem(instanceID, selectionRect);

        DrawHierachyItemWithHighlight(item, highlight);
    }

    static void DrawHierachyItemWithHighlight(HierarchyItem item, HierachyHighlight highlight)
    {
        // Background
        Color32 bgcolor = item.IsSelected ?
           UnityEditorColors.GetDefaultBackgroundColor(UnityEditorWindow.IsHierarchyWindowFocused(), item.IsSelected) :
           highlight.backgroundColor;

        EditorGUI.DrawRect(item.BackgroundRect, bgcolor);

        // Child Foldout
        if (highlight.gameObject.transform.childCount > 0)
        {
            Type sceneHierarchyWindowType = typeof(Editor).Assembly.GetType("UnityEditor.SceneHierarchyWindow");
            PropertyInfo sceneHierarchyWindow = sceneHierarchyWindowType.GetProperty("lastInteractedHierarchyWindow", BindingFlags.Public | BindingFlags.Static);

            int[] expandedIDs = (int[])sceneHierarchyWindowType.GetMethod("GetExpandedIDs", BindingFlags.NonPublic | BindingFlags.Instance).Invoke(sceneHierarchyWindow.GetValue(null), null);

            string iconID = expandedIDs.Contains(item.InstanceID) ? "IN Foldout on" : "IN foldout";

            GUI.DrawTexture(item.CollapseToggleIconRect, EditorGUIUtility.IconContent(iconID).image);
        }

        // Icon
        GUIContent content = EditorGUIUtility.ObjectContent(EditorUtility.InstanceIDToObject(item.InstanceID), null);
        GUI.DrawTexture(item.PrefabIconRect, content.image);

        // Text
        Color textColor = item.IsSelected ?
            UnityEditorColors.GetDefaultTextColor(UnityEditorWindow.IsHierarchyWindowFocused(), item.IsSelected) :
            highlight.textColor;

        GUIStyle labelGUIStyle = new GUIStyle
        {
            normal = new GUIStyleState { textColor = textColor },
            fontStyle = highlight.fontStyle,
            alignment = highlight.textAlignment,
            fontSize = highlight.fontSize,
        };

        EditorGUI.LabelField(item.TextRect, highlight.name, labelGUIStyle);

        // Prefab
        if (PrefabUtility.GetCorrespondingObjectFromOriginalSource(highlight.gameObject) != null && PrefabUtility.IsAnyPrefabInstanceRoot(highlight.gameObject))
        {
            GUI.DrawTexture(item.EditPrefabIconRect, EditorGUIUtility.IconContent("ArrowNavigationRight").image);
        }
    }
}
#endif