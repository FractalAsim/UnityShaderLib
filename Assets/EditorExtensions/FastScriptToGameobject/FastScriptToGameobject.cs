/*
 * About:
 * Auto creates a GameObject and attached MonoBehaviours when you DragDrop a Monobehaviour script onto the Heirachy
 * 
 * Features:
 * Allows dragging of multiple Scripts
 * 
 * How To Use:
 * This script is automatically loaded.
 * Simply Drag a monobehaviour script to hierachy
 * 
 */

#if UNITY_EDITOR

using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

[InitializeOnLoad]
static class FastScriptToGameobject
{
    static FastScriptToGameobject()
    {
        DragAndDrop.AddDropHandler(HierarchyDropHandler);
    }

    static DragAndDropVisualMode HierarchyDropHandler(int dropTargetInstanceID, HierarchyDropFlags dropMode, Transform parentForDraggedObjects, bool perform)
    {
        // 1. Check if drag items is of type MonoScript - a C# script and the script has a class that inherits Monobehaviour
        var dragItems = DragAndDrop.objectReferences;
        foreach (var dragItem in dragItems)
        {
            var isMonoScript = dragItem is MonoScript;

            if (!isMonoScript) return DragAndDropVisualMode.None;

            var script = dragItem as MonoScript;
            var isMonobehaviour = script.IsMonoBehaviour();

            if (!isMonobehaviour) return DragAndDropVisualMode.None;
        }

        // 2. Check if the item we are dropping on is the root hierachy (this acutally means dropping into the scene
        if (dropMode == HierarchyDropFlags.DropUpon &&
            dropTargetInstanceID == SceneManager.GetActiveScene().handle)
        {
            // 3. Create Emtpy GameObject and attach the monoscripts
            if (perform)
            {
                var newGO = new GameObject();
                foreach (var dragItem in dragItems)
                {
                    var script = dragItem as MonoScript;
                    newGO.AddComponent(script.GetClass());
                    newGO.name = script.name;
                }
            }

            return DragAndDropVisualMode.Copy;
        }

        return DragAndDropVisualMode.None;
    }
}

#endif