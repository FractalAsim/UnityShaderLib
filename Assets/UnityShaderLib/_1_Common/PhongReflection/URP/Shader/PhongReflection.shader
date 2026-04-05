Shader "Common/PhongReflection"
{
    Properties
    {
        _MainTex ("Albedo", 2D) = "white" {}
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Range(1, 128)) = 32
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


            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float4 _SpecColor;
                float _Shininess;
            CBUFFER_END

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
                float3 positionWS : TEXCOORD1;
            };

            // Vertex Shader
            Varyings vert (Attributes IN) 
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
                OUT.positionWS = TransformObjectToWorld(IN.positionOS.xyz);

                return OUT;
            }

            // Fragment Shader
            half4 frag (Varyings IN) : SV_Target 
            {
                float3 N = normalize(IN.normalWS);
                float3 L = normalize(_MainLightPosition.xyz);

                // Diffuse
                float Kd = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv).rgb;
                float3 lightDir = normalize(_MainLightPosition.xyz);
                float NdotL = max(0.0, dot(normalize(IN.normalWS), lightDir));
                float3 diffuse = Kd * _MainLightColor.rgb * NdotL;

                // Specular
                float3 viewDir = normalize(_WorldSpaceCameraPos - IN.positionWS);
                float3 reflectSource = reflect(-L, N);
                float specularStrength = max(0, dot(viewDir, reflectSource));
                float3 specular = pow(specularStrength, _Shininess) * _SpecColor.rgb;

                float3 Intensity = diffuse + specular;

                return half4(Intensity, 1);
            }

            ENDHLSL
        }
    }
}
