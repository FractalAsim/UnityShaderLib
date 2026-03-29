// Classic Lambert Model

Shader "Common/LambertianDiffuse"
{
    Properties 
    {
        _MainTex ("Albedo", 2D) = "white" {}
    }
    SubShader 
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass 
        {

            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Required for TEXTURE2D
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            // Required for _MainLightPosition, _MainLightColor in Input.hlsl
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            // Input to Vertex Shader
            struct Attributes 
            {
                float4 positionOS : POSITION;

                float2 uv : TEXCOORD0;
                float3 normalOS : NORMAL;
            };

            // Input to Fragment Shader
            struct Varyings 
            {
                float4 positionHCS : SV_POSITION;

                float2 uv  : TEXCOORD0;
                float3 normalWS : NORMAL;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
            CBUFFER_END

            // Vertex Shader
            Varyings vert (Attributes IN) 
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);

                return OUT;
            }

            // Fragment Shader
            half4 frag (Varyings IN) : SV_Target 
            {
                // Material diffuse coefficient - aka albedo
                float3 Kd = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv).rgb;

                // NdotL
                float3 lightDir = normalize(_MainLightPosition.xyz);
                float NdotL = max(dot(normalize(IN.normalWS), lightDir), 0.0);

                // Ambient coefficient
                float3 Ka = float3(0,0,0);

                // Equation
                float3 Intensity = Kd * _MainLightColor.rgb * NdotL + Ka;

                return float4(Intensity, 1);
            }

            ENDHLSL
        }
    }
}
