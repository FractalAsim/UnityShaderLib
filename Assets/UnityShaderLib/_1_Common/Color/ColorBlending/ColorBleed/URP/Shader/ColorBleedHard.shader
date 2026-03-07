Shader "Common/ColorBleedHard"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,0,0,1)
        _DifferenceThreshold ("Difference Threshold", Range(0,10)) = 0
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
                float4  _Color;
                float   _DifferenceThreshold;
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
                half4 mainColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                float dist = distance(_Color.rgb, mainColor.rgb);

                half4 color;
                if(dist < _DifferenceThreshold)
                {
                    color = _Color;
                }
                else
                {
                    color = mainColor;
                }

                return color;
            }

            ENDHLSL
        }
    }
}