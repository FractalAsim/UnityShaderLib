Shader "Common/YIQShift"
{
    Properties
    {
        _MainTex ("Main Tex", 2D) = "white" {}

        _HueShift ("Hue Shift", range(0,10)) = 0
        _Saturation ("Saturation Shift", range(0,5)) = 1
        _BrightnessShift ("Brightness Shift", range(-1,1)) = 0
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
            
            // Required for custom function: YIQShift
            #include "Assets/UnityShaderLib/Subgraphs_Inc/Color/Color.hlsl"

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
                float   _HueShift;
                float   _Saturation;
                float   _BrightnessShift;
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
                half4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);

                color.rgb = YIQShift(color.rgb,_HueShift,_Saturation,_BrightnessShift);
                
                return color;
            }

            ENDHLSL
        }
    }
}