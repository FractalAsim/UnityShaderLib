// Construct a TangentToWorld matrix

Shader "Basic/TangentToWorld"
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
                float4 tangent : TANGENT;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;

                float4 worldTangent : TEXCOORD0;
                float3 worldBinormal : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
                float3x3 tangentToWorld : TEXCOORD3;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                // World Tangent
                o.worldTangent = float4(UnityObjectToWorldDir(v.tangent.xyz),v.tangent.w);
                // World Normal
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                // World Binormal
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                o.worldBinormal = cross(o.worldNormal, o.worldTangent.xyz) * tangentSign;
                // TangentToworld (TBN) Matrix
                o.tangentToWorld = float3x3(o.worldTangent.xyz, o.worldBinormal, o.worldNormal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = float4(1,1,1,1);
                return col;
            }

            ENDCG
        }
    }
}