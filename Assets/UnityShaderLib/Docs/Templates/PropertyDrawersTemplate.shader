// Info: Property Drawers For Materials/Shaders

Shader "PropertyDrawersTemplate"
{
    Properties
    {
        // Hide in inspector - No point doing this. as shader variables are hidden if not declared here anyways. Unless for readability and clean code sake
        [HideInInspector] _HiddenFloat("HiddenFloat",Float) = 0

        // Gives a Dropdown Selection
        [Enum(RED,0, GREEN,1, BLUE,2)] _ColorSelect("Axis", Float) = 0

        // Gives a Dropdown Selection which is used to select the "shader keyword";Shader variant to be used for branching
        [KeywordEnum(X, Y, Z)] _AxisSelect("Axis", Float) = 0

        // Gives a Checkbox 
        [Toggle] _Enable("_Enable",Integer) = 0

        // Gives a Int Slider
        [IntRange] _Power ("IntRange", Range (0, 10)) = 00

        // Gives a Normal float Slider
        _Blend ("Blend", Range(0, 1)) = 0

        // Gives a Slider with large increase near end
        [PowerSlider(3.0)] _Shininess ("Shininess", Range (0, 1)) = 0

        // Gives a HDR Color picker
        [HDR] _HDRColor("_HDRColor", Color) = (1,1,1,1)

        // Mark this as gamma color space, and should not be gamma corrected
        [Gamma] _GammaColor("_GammaColor", Color) = (1,1,1,1)

        // Inspector for this texture will not include tilling and offset (for ST). Use mostly for normal maps
        [NoScaleOffset] _NormalMap ("Normal Map", 2D) = "bump" {}

        // Mark this property to be set by script though a MaterialPropertyBlock (Obsolete maybe)
        [PerRendererData] _UniqueVector("_UniqueVector", Vector) = (1,1,1,1)

        // For Unity Internally use - Do not allow this texture property to be edited in the Inspector.
        //[NonModifiableTextureData]

        //[Vector4ChannelDrawer] _UniqueVector2("_UniqueVector", float) = 1
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
