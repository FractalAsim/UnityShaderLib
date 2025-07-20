using UnityEditor;
using UnityEngine;

public class ChannelSelectDrawer : MaterialPropertyDrawer
{
    enum Channels
    {
        R,
        G,
        B,
        A
    };
    public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
    {
        if (prop.propertyType == UnityEngine.Rendering.ShaderPropertyType.Vector)
        {
            EditorGUI.LabelField(position, label);
            position.x += EditorGUIUtility.labelWidth;
            position.width -= EditorGUIUtility.labelWidth;

            Channels enumValue;
            if (prop.vectorValue.w > 0)
            {
                enumValue = Channels.A;
            }
            else if (prop.vectorValue.z > 0)
            {
                enumValue = Channels.B;
            }
            else if (prop.vectorValue.y > 0)
            {
                enumValue = Channels.G;
            }
            else
            {
                enumValue = (int)Channels.R;
            }

            enumValue = (Channels)EditorGUI.EnumPopup(position, enumValue);

            switch (enumValue)
            {
                case Channels.A:
                    prop.vectorValue = new Vector4(0, 0, 0, 1);
                    break;
                case Channels.B:
                    prop.vectorValue = new Vector4(0, 0, 1, 0);
                    break;
                case Channels.G:
                    prop.vectorValue = new Vector4(0, 1, 0, 0);
                    break;
                default:
                    prop.vectorValue = new Vector4(1, 0, 0, 0);
                    break;
            }


        }
        else
        {
            editor.ShaderProperty(prop, label);
        }
    }
}