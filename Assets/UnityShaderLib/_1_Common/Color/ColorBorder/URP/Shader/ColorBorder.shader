Shader "Common/ColorBorder"
{
    Properties
    {
        [HDR] _Color ("Color", Color)  = (0.331, 1.0, 0.0, 1.0)
        _Width ("Width", Range(0.0, 0.5)) = 0.1
        _Sharpness ("Sharpness", Range(0.0, 1.0)) = 0.0
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
            
            // Required for custom function: BorderMask
            #include "Assets/UnityShaderLib/Subgraphs_Inc/Masks/Masks.hlsl"


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

             CBUFFER_START(UnityPerMaterial)
                float4 _Color;
                float  _Width;
                float  _Sharpness;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                
                OUT.uv = IN.uv;

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = _Color * BorderMask(IN.uv, _Width, _Sharpness);

                return color;
            }

            ENDHLSL
        }
    }
}