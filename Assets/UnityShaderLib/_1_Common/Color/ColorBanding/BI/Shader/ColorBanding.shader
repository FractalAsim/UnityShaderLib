Shader "Common/ColorBanding"
{
    Properties
    {
       _BandCount ("Band Count", Float) = 5
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
            #include "Assets/UnityShaderLib/Subgraphs/Common/Common.cginc"

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
                float4 normal : NORMAL;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 normal : NORMAL;
            };

            float4 _Color;
            float _BandCount;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float NdotL = MainLightOnSurface(i.normal);
                float band = max(_BandCount,1);
                float color = ceil(Remap1101(NdotL) * band) / band;
                
                return float4(color.xxx,1);
            }

            ENDCG
        }
    }
}
