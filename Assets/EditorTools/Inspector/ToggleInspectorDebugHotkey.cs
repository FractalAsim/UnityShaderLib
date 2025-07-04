/* 
 * About:
 * Adds the ability to Toggle Debug Mode on the current selected Inspector Window
 * 
 */

#if UNITY_EDITOR

using System;
using System.Reflection;
using UnityEditor;

public static class ToggleInspectorDebug
{
    [MenuItem(nameof(EditorTools) + "/Inspector/Toggle Inspector Debug &d")]
    static void ToggleDebug()
    {
        var focusedWindow = EditorWindow.focusedWindow;

        if (focusedWindow == null) return;

        var type = Type.GetType(UnityEditorWindow.Inspector);
        if (focusedWindow.GetType() != type) return;

        var inspectorMode = type.GetField("m_InspectorMode",
            BindingFlags.NonPublic | BindingFlags.Instance);
        var setModeMethod = type.GetMethod("SetMode",
            BindingFlags.NonPublic | BindingFlags.Instance);
        if (inspectorMode == null || setModeMethod == null) return;

        var mode = (InspectorMode)inspectorMode.GetValue(focusedWindow);
        if (mode == InspectorMode.Normal) mode = InspectorMode.Debug;
        else if (mode == InspectorMode.Debug || mode == InspectorMode.DebugInternal) mode = InspectorMode.Normal;
        setModeMethod.Invoke(focusedWindow, new object[] { mode });

        focusedWindow.Repaint();
    }
}

#endif