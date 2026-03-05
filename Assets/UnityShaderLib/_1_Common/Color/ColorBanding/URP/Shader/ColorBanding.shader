Shader "Common/ColorBanding"
{
    Properties
    {
        _BandCount ("Band Count", Float) = 5
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

            CBUFFER_START(UnityPerMaterial)
                float _BandCount;
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

                // Using brightness value on surface, flatten the color every each band segment
                half band = max(_BandCount,1);
                half color = ceil(Remap1101(NdotL) * band) / band;

                return color;
            }

            ENDHLSL
        }
    }
}