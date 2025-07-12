#if UNITY_EDITOR

using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(HierachyHighlight))]
[CanEditMultipleObjects]
public class HierachyHighlightEditor : Editor
{
    SerializedProperty backgroundColor;
    SerializedProperty textColor;
    SerializedProperty fontSize;
    SerializedProperty fontStyle;
    SerializedProperty textAlignment;

    TextAnchorMini anchor;

    void OnEnable()
    {
        backgroundColor = serializedObject.FindProperty(nameof(HierachyHighlight.backgroundColor));
        textColor = serializedObject.FindProperty(nameof(HierachyHighlight.textColor));
        fontSize = serializedObject.FindProperty(nameof(HierachyHighlight.fontSize));
        fontStyle = serializedObject.FindProperty(nameof(HierachyHighlight.fontStyle));
        textAlignment = serializedObject.FindProperty(nameof(HierachyHighlight.textAlignment));

        anchor = TextAnchorToMini((TextAnchor)textAlignment.enumValueIndex);
    }
    public override void OnInspectorGUI()
    {
        EditorGUILayout.PropertyField(backgroundColor, new GUIContent("Font Style"));
        EditorGUILayout.PropertyField(textColor, new GUIContent("Font Style"));
        EditorGUILayout.PropertyField(fontSize, new GUIContent("Font Style"));
        EditorGUILayout.PropertyField(fontStyle, new GUIContent("Font Style"));

        anchor = (TextAnchorMini)EditorGUILayout.EnumPopup("Font Alignment", anchor);
        switch (anchor)
        {
            case TextAnchorMini.Left:
                textAlignment.enumValueIndex = (int)TextAnchor.MiddleLeft;
                break;

            case TextAnchorMini.Center:
                textAlignment.enumValueIndex = (int)TextAnchor.MiddleCenter;
                break;

            case TextAnchorMini.Right:
                textAlignment.enumValueIndex = (int)TextAnchor.MiddleRight;
                break;
        }

        serializedObject.ApplyModifiedProperties();

        //base.OnInspectorGUI();
    }

    enum TextAnchorMini
    {
        Left, Center, Right
    }
    TextAnchorMini TextAnchorToMini(TextAnchor textAnchor)
    {
        switch (textAnchor)
        {
            case TextAnchor.UpperLeft:
            case TextAnchor.MiddleLeft:
            case TextAnchor.LowerLeft:
                return TextAnchorMini.Left;

            case TextAnchor.UpperCenter:
            case TextAnchor.MiddleCenter:
            case TextAnchor.LowerCenter:
                return TextAnchorMini.Center;

            case TextAnchor.UpperRight:
            case TextAnchor.MiddleRight:
            case TextAnchor.LowerRight:
                return TextAnchorMini.Right;

            default:
                return TextAnchorMini.Center;
        }
    }
}
#endif