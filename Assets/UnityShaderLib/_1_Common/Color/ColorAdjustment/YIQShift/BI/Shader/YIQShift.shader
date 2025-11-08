Shader "Common/YIQShift"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Main Tex", 2D) = "white" {}

        _HueShift ("Hue Shift", range(0,10)) = 0
        _Saturation ("Saturation Shift", range(0,5)) = 1
        _BrightnessShift ("Brightness Shift", range(-1,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            #include "UnityCG.cginc"
            #include "Assets/UnityShaderLib/Subgraphs_Inc/Color/Color.cginc"

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float _HueShift;
            float _Saturation;
            float _BrightnessShift;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = YIQShift(col.rgb,_HueShift,_Saturation,_BrightnessShift);
                return col;
            }

            ENDCG
        }
    }
}