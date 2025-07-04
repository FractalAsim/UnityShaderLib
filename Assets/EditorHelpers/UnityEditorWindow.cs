/* 
 * About:
 * Helper class to provide reusable functions regarding UnityEditor Window
 */

#if UNITY_EDITOR

using System;
using UnityEditor;

public class UnityEditorWindow
{
    public const string GameView = "UnityEditor.GameView,UnityEditor";
    public const string SceneView = "UnityEditor.SceneView,UnityEditor";
    public const string Inspector = "UnityEditor.InspectorWindow,UnityEditor";
    public const string Project = "UnityEditor.ProjectWindow,UnityEditor";
    public const string Hierarchy = "UnityEditor.SceneHierarchyWindow,UnityEditor";
    public const string Console = "UnityEditor.ConsoleWindow,UnityEditor";
    public const string Animation = "UnityEditor.AnimationWindow,UnityEditor";
    public const string Animator = "UnityEditor.AnimatorControllerWindow,UnityEditor";
    public const string Profiler = "UnityEditor.ProfilerWindow,UnityEditor";
    public const string PackageManager = "UnityEditor.PackageManagerWindow,UnityEditor";

    public enum UnityWindowType
    {
        Game,
        Scene,
        Inspector,
        Project,
        Hierarchy,
        Console,
        Animation,
        Animator,
        Profiler,
        PackageManager
    }

    public static bool IsGameWindowFocused()
    {
        return EditorWindow.focusedWindow != null && EditorWindow.focusedWindow.titleContent.text == "Game";
    }

    public static bool IsHierarchyWindowFocused()
    {
        return EditorWindow.focusedWindow != null && EditorWindow.focusedWindow.titleContent.text == "Hierarchy";
    }

    public static void OpenWindow(UnityWindowType windowType)
    {
        var assemblyQualifiedName = windowType switch
        {
            UnityWindowType.Game => GameView,
            UnityWindowType.Scene => SceneView,
            UnityWindowType.Inspector => Inspector,
            UnityWindowType.Project => Project,
            UnityWindowType.Hierarchy => Hierarchy,
            UnityWindowType.Console => Console,
            UnityWindowType.Animation => Animation,
            UnityWindowType.Animator => Animator,
            UnityWindowType.Profiler => Profiler,
            UnityWindowType.PackageManager => PackageManager,
            _ => throw new ArgumentException($"Unknown window type: {windowType}")
        };

        EditorWindow window = EditorWindow.GetWindow(Type.GetType(assemblyQualifiedName));
        if (window != null)
        {
            window.Focus();
        }
    }
}
#endif