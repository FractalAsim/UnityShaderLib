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

                float3x3 tangentToWorld : TEXCOORD4;
            };

            sampler2D _NormalMap;

            uniform float4 _LightColor0;

            // Vertex Shader
            v2f vert (appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.pos);

                float4 worldTangent = float4(UnityObjectToWorldDir(v.tangent.xyz),v.tangent.w);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                float3 worldBinormal = cross(worldNormal, worldTangent.xyz) * tangentSign;
                o.tangentToWorld = float3x3(worldTangent.xyz, worldBinormal, worldNormal);

                o.uv = v.uv;
                return o;
            }


            // Fragment Shader
            fixed4 frag (v2f i) : SV_Target
            {
                // Special algorithm to get normals from texture
                float3 unpackedNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                
                // transform normal from tangent space to world space using TBN matrix
                float3 normal = mul(i.tangentToWorld, unpackedNormal);

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(dot(normal, lightDir), 0.0);

                fixed4 col = _LightColor0 * NdotL;
                return col;
            }
            ENDCG
        }
    }
}
