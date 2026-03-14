Shader "Common/ColorRim"
{
    Properties
    {
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimIntensity ("Rim Intensity", Float) = 1
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

                float3 normalOS   : NORMAL;
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position

                float3 normalWS    : NORMAL;
                float3 viewDirWS   : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _RimColor;
                float  _RimIntensity;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);

                float3 positionWS  = TransformObjectToWorld(IN.positionOS.xyz);
                OUT.viewDirWS = normalize(GetCameraPositionWS() - positionWS);

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                float3 color = Fresnel(IN.normalWS, IN.viewDirWS, _RimIntensity) * _RimColor.rgb;

                return float4(color, 1);
            }

            ENDHLSL
        }
    }
}