// Common Shader that cuts off the fragment on one side of a plane

Shader "Common/CutoffPlane"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

        [Toggle] _Enable("Enable", float) = 0
        _PNormal("Plane Normal", Vector) = (0,0,0,0)
        _PCenter("Plane Center", Vector) = (0,0,0,0)
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
                float4  _PNormal;
                float4  _PCenter;
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
                float clipValue = dot(_PNormal, IN.positionWS - _PCenter);

                clip(clipValue * _Enable);

                return _Color;
            }

            ENDHLSL
        }
    }
}
