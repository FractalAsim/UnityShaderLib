// Info: Property Drawers For Materials/Shaders

Shader "Info/PropertyDrawers"
{
    Properties
    {
        // Gives a Dropdown Selection
        [Enum(RED, GREEN, BLUE)] _ColorSelect("Axis", Float) = 0

        // Gives a Dropdown Selection To select Shader variant to used for branching
        [KeywordEnum(X, Y, Z)] _AxisSelect("Axis", Float) = 0

        // Gives a Checkbox 
        [Toggle] _Enable("_Enable",Integer) = 0

        // Gives a Slider with large increase near end
        [PowerSlider(3.0)] _Shininess ("Shininess", Range (0, 1)) = 0

        // Gives a Int Slider
        [IntRange] _Power ("IntRange", Range (0, 10)) = 00
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}
