/* 
 * About:
 * Adds the ability to Toggle Lock on the current selected Inspector Window
 * 
 */

#if UNITY_EDITOR

using System;
using UnityEditor;

public static class ToggleInspectorLock
{
    [MenuItem(nameof(EditorTools) + "/Inspector/Toggle Inspector Lock &q")]
    static void ToggleLock()
    {
        var focusedWindow = EditorWindow.focusedWindow;

        if (focusedWindow == null) return;

        var type = Type.GetType(UnityEditorWindow.Inspector);
        if (focusedWindow.GetType() != type) return;

        var lockPropertyInfo = type.GetProperty("isLocked");
        if (lockPropertyInfo == null) return;

        bool toggleValue = (bool)lockPropertyInfo.GetValue(focusedWindow, null);
        lockPropertyInfo.SetValue(focusedWindow, !toggleValue, null);

        focusedWindow.Repaint();
    }
}

#endif
