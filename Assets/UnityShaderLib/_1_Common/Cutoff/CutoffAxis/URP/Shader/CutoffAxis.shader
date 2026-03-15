// Common Shader that cuts off the fragment when it's position in a selected axis is above a certain value Interpolated though a range.
// Addition Reverse var to go from max->min instead

Shader "Common/CutoffAxis"
{
    Properties
    {
         _Color ("Color", Color) = (1,1,1,1)

        [KeywordEnum(X, Y, Z)] _Axis("Cutoff Axis", Float) = 0 // 3 Enum Selection (shader variants)
        [Toggle] _Reverse("Reverse",Integer) = 0 // Boolean selection (shader variant)

        _Cutoff("Cutoff", Range(0,1)) = 1 // Interpolate
        _RangeMin("Min Cutoff", Float) = 0 // The Min X/Y/Z position value in worldspace to when @ 0% cutoff
        _RangeMax("Max Cutoff", Float) = 10 // The Max X/Y/Z position value in worldspace to when @ 100% cutoff
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            #pragma shader_feature_local _AXIS_X _AXIS_Y _AXIS_Z // Compile shader variant only for this file for the shaders being used in material
            #pragma shader_feature_local _REVERSE_ON

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
                float4 _Color;
                float _Cutoff;
                float  _RangeMin;
                float  _RangeMax;
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
                float clipValue = 0;
                float pos;

                if(_AXIS_X)
                {
                    pos = IN.positionWS.x;
                }
                else if(_AXIS_Y)
                {
                    pos = IN.positionWS.y;
                }
                else if(_AXIS_Z)
                {
                    pos = IN.positionWS.z;
                }

                if(_REVERSE_ON)
                {
                    clipValue = lerp(_RangeMin, _RangeMax, _Cutoff) - (_RangeMax - pos);
                }
                else
                {
                    clipValue = lerp(_RangeMin, _RangeMax, _Cutoff) - (pos - _RangeMin);
                }

                clip(clipValue);

                return _Color;
            }

            ENDHLSL
        }
    }
}