Shader "Basic/TextureLerp"
{
    Properties
    {
        _Texture1 ("Texture 1", 2D) = "white" {}
        _Texture2 ("Texture 2", 2D) = "white" {}
        _Blend ("Blend", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // Required for CBUFFER_START, TEXTURE2D
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            // Input to Vertex Shader
            struct Attributes
            {
                float4 positionOS : POSITION; // Object Space Position

                float2 uv : TEXCOORD0;
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position
                
                float2 uv  : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            TEXTURE2D(_Texture1);
            SAMPLER(sampler_Texture1);

            TEXTURE2D(_Texture2);
            SAMPLER(sampler_Texture2);

            // Put properties here for SRP Batcher, all pass must use same CBUFFER
            CBUFFER_START(UnityPerMaterial)
                float4 _Texture1_ST;
                float4 _Texture2_ST;
                float _Blend;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv  = TRANSFORM_TEX(IN.uv, _Texture1);
                OUT.uv2 = TRANSFORM_TEX(IN.uv, _Texture2);

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                half4 col1 = SAMPLE_TEXTURE2D(_Texture1, sampler_Texture1, IN.uv);
                half4 col2 = SAMPLE_TEXTURE2D(_Texture2, sampler_Texture2, IN.uv2);
                half4 color = lerp(col1, col2, _Blend);

                return color;
            }

            ENDHLSL
        }
    }
}