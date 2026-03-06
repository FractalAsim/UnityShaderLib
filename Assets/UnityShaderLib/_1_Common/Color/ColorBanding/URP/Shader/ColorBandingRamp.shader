Shader "Common/ColorBandingRamp"
{
    Properties
    {
        _Ramp           ("Ramp Texture", 2D) = "white" {}
        _RampSelect     ("Ramp Select (Row)", Float) = 0
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
            
            // Required for custom function: MainLightOnSurface, Remap1101
            #include "Assets/UnityShaderLib/Subgraphs_Inc/Common/Common.hlsl"

            // Input to Vertex Shader
            struct Attributes
            {
                float4 positionOS : POSITION; // Object Space Position

                float3 normal : NORMAL;
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position

                float3 normal : NORMAL;
            };

            TEXTURE2D(_Ramp);
            SAMPLER(sampler_Ramp);

            CBUFFER_START(UnityPerMaterial)
                float4 _Ramp_ST;
                float  _RampSelect;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                OUT.normal = IN.normal;
                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                half NdotL = MainLightOnSurface(IN.normal);

                // Using brightness value on surface, as x coord, and _rampSelect as y coord, to sample a ramp texture for color
                float2 uvSample = float2(Remap1101(NdotL), _RampSelect);
                half4 color = SAMPLE_TEXTURE2D(_Ramp, sampler_Ramp, uvSample);

                return color;
            }

            ENDHLSL
        }
    }
}