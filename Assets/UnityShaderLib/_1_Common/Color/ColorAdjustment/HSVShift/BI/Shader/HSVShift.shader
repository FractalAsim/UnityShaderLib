Shader "Common/HSVShift"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Main Tex", 2D) = "white" {}

        _HueShift ("Hue Shift", range(0,360)) = 0
        _Saturation ("Saturation", range(0,10)) = 1
        _Brightness ("Brightness", range(0,10)) = 1
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
            #include "Assets/UnityShaderLib/Subgraphs_Inc/Easing/Easing.cginc"

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
            float _Brightness;

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
                
                // 1. Convert Space to HSV
                float3 hsv = RGBToHSV(col.rgb);

                // 2. Adjust values
                hsv.x += _HueShift/360.0;
                hsv.y = saturate(hsv.y * _Saturation);
                hsv.z = saturate(hsv.z * _Brightness);

                // 3. Convert back to RGB
                float3 rgb = HSVToRGB(hsv);
                Linear(1);

                col.rgb = rgb;

                return col;
            }

            ENDCG
        }
    }
}