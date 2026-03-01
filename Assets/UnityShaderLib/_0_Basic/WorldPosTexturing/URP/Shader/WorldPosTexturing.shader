Shader "Basic/WorldPosTexturing"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position

                float3 positionWS  : TEXCOORD0;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                OUT.positionWS  = TransformObjectToWorld(IN.positionOS);

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                half4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.positionWS);
                return col;
            }

            ENDHLSL
        }
    }
}
