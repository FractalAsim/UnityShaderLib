using UnityEditor;
using UnityEngine;

public class Vector4ChannelDrawer : MaterialPropertyDrawer
{
    private readonly string[] channelOptions = { "X", "Y", "Z", "W" };

    public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
    {
        if (prop.type != MaterialProperty.PropType.Float)
        {
            EditorGUI.LabelField(position, label, "Use Vector4Channel with float");
            return;
        }

        // Draw dropdown
        int currentIndex = Mathf.Clamp((int)prop.floatValue, 0, 3);
        EditorGUI.BeginChangeCheck();
        int selected = EditorGUI.Popup(position, label, currentIndex, channelOptions);
        if (EditorGUI.EndChangeCheck())
        {
            prop.floatValue = selected;
        }
    }
}