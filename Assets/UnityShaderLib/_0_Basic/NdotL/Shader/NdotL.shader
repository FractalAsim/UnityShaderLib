Shader "Basic/NdotL"
{
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

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;

                float3 normal : NORMAL;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;

                float3 worldNormal : NORMAL;
            };

            uniform float4 _LightColor0;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Basic light using NdotL
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(dot(i.worldNormal, lightDir), 0.0);

                fixed4 col = _LightColor0 * NdotL;
                return col;
            }

            ENDCG
        }
    }
}