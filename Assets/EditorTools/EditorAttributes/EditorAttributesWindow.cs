/*
 * About:
 * Provides a custom unity window to display all internal editor icons unity has
 * 
 * Note:
 * Page too long, unity select buffer unable to support?
 * 
 * Source:
 * https://github.com/nukadelic/UnityEditorIcons/blob/master/EditorIcons.cs
 * 
 */

#if UNITY_EDITOR

using System;
using System.Text;
using UnityEditor;
using UnityEngine;

public class EditorAttributesWindow : EditorWindow
{
    [MenuItem("EditorTools/Editor Attributes")]
    public static void ShowWindow()
    {
        var windowName = "Editor Attributes";
        var window = GetWindow<EditorAttributesWindow>(windowName);

        window.ShowUtility();
        window.minSize = new Vector2(320, 450);
    }

    StringBuilder sb;
    void OnEnable()
    {
        sb = new StringBuilder();

        System.Reflection.Assembly[] assemblies = AppDomain.CurrentDomain.GetAssemblies();
        foreach (var assembly in assemblies)
        {
            if (assembly.FullName.StartsWith("UnityEngine") || 
                assembly.FullName.StartsWith("UnityEditor") ||
                assembly.FullName.StartsWith("Assembly-CSharp"))
            {
                Type[] types = assembly.GetTypes();
                for (var i = 0; i < types.Length; i++)
                {
                    if (types[i].IsSubclassOf(typeof(Attribute)) || 
                        types[i].IsSubclassOf(typeof(PropertyAttribute)))
                    {
                        sb.AppendLine(types[i].ToString());
                    }
                }
            }
        }
    }

    Vector2 scroll;

    void OnGUI()
    {
        EditorGUILayout.LabelField("Editor Attributes:");

        scroll = EditorGUILayout.BeginScrollView(scroll, GUILayout.Height(position.height - 30));

        var height = GUI.skin.GetStyle("label").CalcHeight(new GUIContent(sb.ToString()), EditorGUIUtility.currentViewWidth);

        EditorGUILayout.SelectableLabel(sb.ToString(),EditorStyles.textField, GUILayout.Height(height));
        EditorGUILayout.EndScrollView();
    }

    public bool toggle_me = false;

    void OnValidate()
    {
        System.Reflection.Assembly[] assemblies = System.AppDomain.CurrentDomain.GetAssemblies();
        foreach (var assembly in assemblies)
        {
            if (assembly.FullName.StartsWith("UnityEngine") || assembly.FullName.StartsWith("UnityEditor"))
            {
                Type[] types = assembly.GetTypes();
                for (var i = 0; i < types.Length; i++)
                {
                    if (types[i].IsSubclassOf(typeof(Attribute)))
                    {
                        //print(types[i]);
                    }
                }
            }
        }
    }
}
#endif