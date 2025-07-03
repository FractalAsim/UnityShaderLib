#if UNITY_EDITOR

using System;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(RectTransform), true)]
[CanEditMultipleObjects]
public class ExtendedRectTransformEditor : Editor
{
    Editor defaultEditor = null;
    RectTransform rectTransform;

    private static RectTransformData copiedData;

    void OnEnable()
    {
        // Use reflection to get the default Unity RectTransform editor
        defaultEditor = Editor.CreateEditor(targets, Type.GetType("UnityEditor.RectTransformEditor, UnityEditor"));
        rectTransform = target as RectTransform;
    }

    public override void OnInspectorGUI()
    {
        defaultEditor.OnInspectorGUI();

        EditorGUILayout.Space();

        GUILayout.BeginHorizontal();
        if (GUILayout.Button("Copy", GUILayout.Width(100)))
        {
            CopyRectTransform(rectTransform);
        }

        if (GUILayout.Button("Paste", GUILayout.Width(100)))
        {
            PasteRectTransform(rectTransform);
        }
        GUILayout.EndHorizontal();
    }

    void CopyRectTransform(RectTransform rectTransform)
    {
        copiedData = new RectTransformData(rectTransform);
        Debug.Log("RectTransform copied!");
    }

    void PasteRectTransform(RectTransform rectTransform)
    {
        if (copiedData == null)
        {
            Debug.LogWarning("No RectTransform data to paste!");
            return;
        }

        Undo.RecordObject(rectTransform, "Paste RectTransform");

        copiedData.ApplyTo(rectTransform);
        Debug.Log("RectTransform pasted!");

        EditorUtility.SetDirty(rectTransform);
    }

    private class RectTransformData
    {
        public Vector2 anchorMin;
        public Vector2 anchorMax;
        public Vector2 anchoredPosition;
        public Vector2 sizeDelta;
        public Vector2 pivot;
        public Quaternion rotation;

        public RectTransformData(RectTransform rectTransform)
        {
            anchorMin = rectTransform.anchorMin;
            anchorMax = rectTransform.anchorMax;
            anchoredPosition = rectTransform.anchoredPosition;
            sizeDelta = rectTransform.sizeDelta;
            pivot = rectTransform.pivot;
            rotation = rectTransform.rotation;
        }
        public void ApplyTo(RectTransform rectTransform)
        {
            rectTransform.anchorMin = anchorMin;
            rectTransform.anchorMax = anchorMax;
            rectTransform.anchoredPosition = anchoredPosition;
            rectTransform.sizeDelta = sizeDelta;
            rectTransform.pivot = pivot;
            rectTransform.rotation = rotation;
        }
    }
}
#endif
