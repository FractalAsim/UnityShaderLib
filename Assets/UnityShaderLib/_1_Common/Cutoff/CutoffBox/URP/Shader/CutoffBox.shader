// Common Shader that cuts off the fragment out side of a box range

Shader "Common/CutoffBox"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

        [Toggle] _Enable("Enable", float) = 0
        _Min("Min", Vector) = (0,0,0,0)
        _Max("Min", Vector) = (0,0,0,0)
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

                float3 positionWS    : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
                float4  _Color;
                float   _Enable;
                float3  _Min;
                float3  _Max;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                
                OUT.positionWS = TransformObjectToWorld(IN.positionOS.xyz);

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                // If the global position for the axis (x,y,z) is less than min, or more than max, the result wil be negative
                float3 subPos = (IN.positionWS - _Min) * (_Max - IN.positionWS);

                // If any axis is negative, return negative, otherwise positive
                float clipValue = min(min(subPos.x, subPos.y), subPos.z);

                clip(clipValue * _Enable);

                return _Color;
            }

            ENDHLSL
        }
    }
}
