Shader "Common/YIQShift"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}

        _HueShift ("Hue Shift", Range(0,10)) = 0
        _Saturation ("Saturation Shift", Range(0,5)) = 1
        _BrightnessShift ("Brightness Shift", Range(-1,1)) = 0
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

            // Vertex Shader
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = v.uv;
                return o;
            }

            // Fragment Shader
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