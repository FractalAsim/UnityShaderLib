// Box Blur 3x3 kernel
// Blur by adding neighbours and getting the average
Shader "Common/BoxBlur"
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
                float4  _MainTex_ST;
                float   _Blur;
                float   _BlurSize;
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

                // Sample neighbours in 3x3 grid, add all, and get average. 
                [unroll]
                for (int y = -1; y <= 1; y++)
                {
                    [unroll]
                    for (int x = -1; x <= 1; x++)
                    {
                        float2 offset = float2(x, y) * _BlurSize;
                        blurColor += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + offset);
                    }
                }
                blurColor /= 9;


                half4 color = lerp(mainColor,blurColor,_Blur);

                return color;
            }

            ENDHLSL
        }
    }
}