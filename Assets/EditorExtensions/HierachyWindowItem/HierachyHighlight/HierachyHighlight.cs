/* 
 * About:
 * Script to highlight a gameobject in Hierachy
 * 
 * How It Works:
 * 1. An editor script (HierachyHighlightLoader) is loaded in unityeditor 
 * 2. Script adds custom draw calls to override/overdraw on default heirachy drawing 
 * 3. Script draw based on the gameobject's HierachyHighlight component
 * 
 * How To Use:
 * 1. Attach this script to a GameObject you want to highlight in inspector
 * 2. Adjust settings as needed
 */

#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;

public class HierachyHighlight : MonoBehaviour
{
    public Color32 backgroundColor = new Color32(0, 255, 0, 255);
    public Color32 textColor = new Color32(0, 0, 0, 255);
    [Range(1,20)] public int fontSize = 12;
    public FontStyle fontStyle = FontStyle.Normal;
    public TextAnchor textAlignment = TextAnchor.UpperLeft;

    void OnValidate()
    {
        EditorApplication.RepaintHierarchyWindow();
    }
}
#endif