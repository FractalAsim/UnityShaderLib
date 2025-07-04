using UnityEngine;

public class UnityEditorWindowExample : MonoBehaviour
{
    [ContextMenu("Open Game")]
    void OpenGame()
    {
        UnityEditorWindow.OpenWindow(UnityEditorWindow.UnityWindowType.Game);
    }

    [ContextMenu("Open Scene")]
    void OpenScene()
    {
        UnityEditorWindow.OpenWindow(UnityEditorWindow.UnityWindowType.Scene);
    }

    [ContextMenu("Open Inspector")]
    void OpenInspector()
    {
        UnityEditorWindow.OpenWindow(UnityEditorWindow.UnityWindowType.Inspector);
    }

    [ContextMenu("Open Hierarchy")]
    void OpenHierarchy()
    {
        UnityEditorWindow.OpenWindow(UnityEditorWindow.UnityWindowType.Hierarchy);
    }
}
