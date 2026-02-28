Shader "Basic/UnpackNormals"
{
    Properties
    {
        _NormalMap ("Normal", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Required for _SinTime in Unityinput.hlsl
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            // Input to Vertex Shader
            struct Attributes
            {
                float4 positionOS : POSITION; // Object Space Position

                float2 uv : TEXCOORD0;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position

                float2 uv : TEXCOORD0;

                real3x3 tangentToWorld : TEXCOORD1;
            };

            TEXTURE2D(_NormalMap);
            SAMPLER(sampler_NormalMap);

            CBUFFER_START(UnityPerMaterial)
                float4 _NormalMap_ST;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = IN.uv;

                real3 tangentWS = real3(TransformObjectToWorldDir(IN.tangentOS.xyz));
                real3 normalWS = TransformObjectToWorldNormal(IN.normalOS);
                real tangentSign = real(IN.tangentOS.w) * GetOddNegativeScale();
                real3 binormalWS = real3(cross(normalWS, float3(tangentWS.xyz))) * tangentSign;
                OUT.tangentToWorld = real3x3(tangentWS, binormalWS, normalWS);

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                // Special algorithm to get normals from texture
                float3 unpackedNormal = UnpackNormal(SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, IN.uv));

                // Transform normals from tangent space to world space using TBN matrix
                float3 normal = mul(unpackedNormal, IN.tangentToWorld);

                // Use normals for other calculations
                Light mainLight = GetMainLight();
                float3 lightDir = normalize(mainLight.direction);
                float NdotL = max(dot(normal, lightDir), 0.0);

                half4 col = half4(mainLight.color * NdotL, 1.0);
                return col;
            }

            ENDHLSL
        }
    }
}
