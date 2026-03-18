// Common Shader that cuts off the fragment in horizontal segments. Like being slice in parts

Shader "Common/HorizontalSlice"
{
    Properties
    {
        _Slice("Slice", Range(0,1)) = 0
        _SliceAmt("Slice Amt", Float) = 2
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Required for custom function: Fresnel
            #include "Assets/UnityShaderLib/Subgraphs_Inc/Common/Common.hlsl"

            // Input to Vertex Shader
            struct Attributes
            {
                float4 positionOS : POSITION; // Object Space Position
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position

                float3 positionOS    : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
                float   _Slice;
                float  _SliceAmt;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                
                OUT.positionOS = IN.positionOS.xyz;

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                float start = (IN.positionOS.y + 0.4999) * _SliceAmt;
                float fractional = frac(start);
                float clipValue = step(fractional, _Slice) - 0.01;

                clip(clipValue);

                return float4(fractional.xxx,1);
            }

            ENDHLSL
        }
    }
}
