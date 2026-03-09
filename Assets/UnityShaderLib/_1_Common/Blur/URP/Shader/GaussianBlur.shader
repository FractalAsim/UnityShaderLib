// Gaussian Blur 3x3 kernel
// Blur by adding neighbours with gaussian weights
Shader "Common/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Blur ("Blur", Range(-2,1)) = 0
        _BlurSize ("BlurSize", Range(0,0.1)) = 0.1
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

                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float _Blur;
                float _BlurSize;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                float4 mainColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);

                float4 blurColor = float4(0, 0, 0, 0);

                // Sample neighbours in 3x3 grid with gaussian weights  
                // Gaussian blur kernel weights
                // +------+------+------+
                // | 1/16 | 2/16 | 1/16 |
                // +------+------+------+
                // | 2/16 | 4/16 | 2/16 |
                // +------+------+------+
                // | 1/16 | 2/16 | 1/16 |
                // +------+------+------+
                blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-_BlurSize,_BlurSize))  * 1;
                blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(0,_BlurSize))           * 2;
                blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(_BlurSize,_BlurSize))   * 1;

                blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-_BlurSize,0))          * 2;
                blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv)                                 * 4;
                blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(_BlurSize,0))           * 2;

                blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-_BlurSize,-_BlurSize)) * 1;
                blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(0,-_BlurSize))          * 2;
                blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(_BlurSize,-_BlurSize))  * 1;

                blurColor /= 16;

                half4 color = lerp(mainColor,blurColor,_Blur);

                return color;
            }

            ENDHLSL
        }
    }
}