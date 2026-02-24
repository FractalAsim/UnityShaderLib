Shader "Basic/NdotL"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // Required for CBUFFER_START

            // Required for GetMainLight() in RealtimeLights.hlsl
            // Required for _MainLightPosition, _MainLightColor in Input.hlsl
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            // Input to Vertex Shader
            struct Attributes
            {
                float4 positionOS : POSITION; // Object Space Position

                float3 normalOS : NORMAL;
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position

                float3 worldNormal : NORMAL;
            };

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                OUT.worldNormal = TransformObjectToWorldNormal(IN.normalOS);

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                // 1. Basic light using NdotL
                float3 lightDir = normalize(_MainLightPosition.xyz);
                float NdotL = max(dot(normalize(IN.worldNormal), lightDir), 0.0);

                half4 color = _MainLightColor * NdotL;

                return color;

                
                // 2. Basic light using NdotL using GetMainLight()
                // Light mainLight = GetMainLight();
                // float3 lightDir = normalize(mainLight.direction);
                // float NdotL = max(dot(normalize(IN.worldNormal), lightDir), 0.0);

                // half4 color = half4(mainLight.color * NdotL, 1.0);

                // return color;
            }

            ENDHLSL
        }
    }
}
