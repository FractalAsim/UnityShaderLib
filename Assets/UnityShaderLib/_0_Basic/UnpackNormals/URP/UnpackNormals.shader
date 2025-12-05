Shader "Basic/UnpackNormals"
{
    Properties
    {
        _NormalMap ("Normal", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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

                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;

                float4 worldTangent : TEXCOORD1;
                float3 worldBinormal : TEXCOORD2;
                float3 worldNormal : TEXCOORD3;
                float3x3 tangentToWorld : TEXCOORD4;
            };

            sampler2D _NormalMap;

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

                o.uv = v.uv;
                return o;
            }

            uniform float4 _LightColor0;

            fixed4 frag (v2f i) : SV_Target
            {
                float3 unpackedNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                
                //unpackedNormal = UnpackNormalRGB(tex2D(_NormalMap, i.uv));

                // transform normal from tangent to world space
                float3 normal = mul(i.tangentToWorld, unpackedNormal);

                // Basic light using NdotL
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(dot(normal, lightDir), 0.0);

                fixed4 col = _LightColor0 * NdotL;
                return col;
            }
            ENDCG
        }
    }
}
