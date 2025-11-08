// Texture Cell Bombing technique is used with view direction to add ontop of main texture to give a Reflective Foil Effect

Shader "Uncommon/Foil"
{
    Properties
    {
        _MainTex ("Main Tex", 2D) = "white" {}
        _FoilTex ("Main Tex", 2D) = "white" {}

        _Scale("Scale",range(0,5)) = 1
        _Intensity("Intensity",range(0,10)) = 1
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
                float4 uv : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _FoilTex;
            float4 _FoilTex_ST;

            float _Scale;
            float _Intensity;
            float3 _Col1;
            float3 _Col2;
            float3 _Col3;


            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.uv, _FoilTex);

                o.viewDir = WorldSpaceViewDir(v.pos);
                return o;
            }

            float3 PlasmaMorph(float2 uv)
            {
                uv = uv * _Scale - _Scale /2;
                float time = 0;
                
                float w1 = sin(uv.x + time);
                float w2 = sin(uv.y + time);
                float w3 = sin(uv.x + uv.y + time);

                float r = sin(sqrt(uv.x * uv.x * + uv.y * uv.y) + time) * 2;

                float finalValue = w1 + w2 + w3 + r;

                float c1 = sin(finalValue * UNITY_PI);
                float c2 = cos(finalValue * UNITY_PI);
                float c3 = sin(finalValue);

                return float3(c1,c2,c3);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv.xy);
                fixed4 foil = tex2D(_FoilTex, i.uv.zw);

                float2 newUV = i.viewDir.xy + foil.rg;
                float3 plasmacol = PlasmaMorph(newUV) * _Intensity;

                return fixed4(col.rgb + col.rgb * plasmacol,1);
            }

            ENDCG
        }
    }
}