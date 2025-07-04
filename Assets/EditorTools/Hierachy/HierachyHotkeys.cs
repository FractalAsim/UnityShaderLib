/*
 * About:
 * Provides hotkeys for quick actions in the heirachy window
 * 
 * Features:
 * Allow multiple selection under the same heirachy level
 * Allow multiscene selection under the same heirachy level
 * Input new name after Group
 * 
 * Actions:
 * Move Selections Up - [Ctrl + Alt + W]
 * Move Selections Down - [Ctrl + Alt + S]
 * Group Selections - [Ctrl + G]
 * 
 */

#if UNITY_EDITOR

using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

public class HierachyHotkeys
{
    // Arrow keys shortcut does not work in heirachy
    [MenuItem(nameof(EditorTools) + "/Hierachy/Move Up %&w")]
    static void MoveUp()
    {
        if (Selection.gameObjects.Length == 0) return;

        // Split Selections into their own scenes
        var Scenes = Selection.gameObjects.GroupBy(GO => GO.scene).ToArray();
        foreach (var scene in Scenes)
        {
            var selection = scene.ToArray();

            // Remove GameObject Selection In Project Folder (Prefab Selection)
            if (scene.Key.name == null)
            {
                var removedList = Selection.gameObjects.ToList();
                foreach (var item in selection)
                {
                    removedList.Remove(item);
                }
                Selection.objects = removedList.ToArray();
                continue;
            }

            var sameParent = true;
            var parent = selection[0].transform.parent;
            for (int i = 1; i < selection.Length; i++)
            {
                if (selection[i].transform.parent != parent)
                {
                    sameParent = false;
                    break;
                }
            }

            if (!sameParent)
            {
                var removedList = Selection.gameObjects.ToList();
                foreach (var item in selection)
                {
                    removedList.Remove(item);
                }
                Selection.objects = removedList.ToArray();
                continue;
            }

            int lastIndex = 0;
            bool isRootSelection = parent == null;
            if (isRootSelection)
            {
                Undo.RegisterCompleteObjectUndo(selection, "Move Up In Hierachy");
                lastIndex = SceneManager.GetActiveScene().GetRootGameObjects().Length - 1;
            }
            else
            {
                Undo.RegisterChildrenOrderUndo(parent, "Move Up In Hierachy");
                lastIndex = parent.childCount - 1;
            }

            bool hasChanged = false;
            var orderedSelection = selection.OrderBy(t => t.transform.GetSiblingIndex()).ToArray();
            for (int i = 0; i < orderedSelection.Length; i++)
            {
                var sibilingIndex = orderedSelection[i].transform.GetSiblingIndex();
                if (sibilingIndex == i) continue;

                hasChanged = true;
                orderedSelection[i].transform.SetSiblingIndex(sibilingIndex - 1);
            }

            // Fix for some reason, unity records undo even though no setsibling is called
            if (!hasChanged) Undo.RevertAllInCurrentGroup();
        }
    }

    // Arrow keys shortcut does not work in heirachy
    [MenuItem(nameof(EditorTools) + "/Hierachy/Move down %&s")]
    static void MoveDown()
    {
        if (Selection.gameObjects.Length == 0) return;

        // Split Selections into their own scenes
        var Scenes = Selection.gameObjects.GroupBy(GO => GO.scene).ToArray();
        foreach (var scene in Scenes)
        {
            var selection = scene.ToArray();

            // Remove GameObject Selection In Project Folder (Prefab Selection)
            if (scene.Key.name == null)
            {
                var removedList = Selection.gameObjects.ToList();
                foreach (var item in selection)
                {
                    removedList.Remove(item);
                }
                Selection.objects = removedList.ToArray();
                continue;
            }

            var sameParent = true;
            var parent = selection[0].transform.parent;
            for (int i = 1; i < selection.Length; i++)
            {
                if (selection[i].transform.parent != parent)
                {
                    sameParent = false;
                    break;
                }
            }

            if (!sameParent)
            {
                var removedList = Selection.gameObjects.ToList();
                foreach (var item in selection)
                {
                    removedList.Remove(item);
                }
                Selection.objects = removedList.ToArray();
                continue;
            }

            int lastIndex = 0;
            bool isRootSelection = parent == null;
            if (isRootSelection)
            {
                Undo.RegisterCompleteObjectUndo(selection, "Move Down In Hierachy");
                lastIndex = SceneManager.GetActiveScene().GetRootGameObjects().Length - 1;
            }
            else
            {
                Undo.RegisterChildrenOrderUndo(parent, "Move Down In Hierachy");
                lastIndex = parent.childCount - 1;
            }

            var hasChanged = false;
            var orderedSelection = selection.OrderByDescending(t => t.transform.GetSiblingIndex()).ToArray();
            for (int i = 0; i < orderedSelection.Length; i++)
            {
                var sibilingIndex = orderedSelection[i].transform.GetSiblingIndex();
                if (sibilingIndex == lastIndex - i) continue;

                hasChanged = true;
                orderedSelection[i].transform.SetSiblingIndex(sibilingIndex + 1);
            }

            // Fix for some reason, unity records undo even though no setsibling is called
            if (!hasChanged) Undo.RevertAllInCurrentGroup();
        }
    }

    static void TriggerRenameCommand()
    {

    }

    private static double renameTime;

    [MenuItem(nameof(EditorTools) + "/Hierachy/Group %g")]
    static void Group()
    {
        if (Selection.transforms.Length > 0)
        {
            GameObject groupGO = new GameObject("New Group");

            Vector3 centerPos = Vector3.zero;
            foreach (Transform g in Selection.transforms)
            {
                centerPos += g.transform.position;
            }
            groupGO.transform.position = centerPos / Selection.transforms.Length;

            Undo.RegisterCreatedObjectUndo(groupGO, "Create New GameObject Group");
            foreach (GameObject s in Selection.gameObjects)
            {
                Undo.SetTransformParent(s.transform, groupGO.transform, "Reparent to Group");
            }

            Selection.activeObject = groupGO;

            renameTime = EditorApplication.timeSinceStartup + 0.2;
            EditorApplication.update += TriggerRename;
        }
    }

    static void TriggerRename()
    {
        if (EditorApplication.timeSinceStartup >= renameTime)
        {
            var e = new Event
            {
                keyCode = KeyCode.F2,
                type = EventType.KeyDown
            };
            EditorWindow.focusedWindow.SendEvent(e);

            EditorApplication.update -= TriggerRename;
        }
    }
}

#endif