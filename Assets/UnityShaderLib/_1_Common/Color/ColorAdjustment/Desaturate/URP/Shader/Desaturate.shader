Shader "Common/Desaturate"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        [KeywordEnum(REC_601, REC_708, REC_2020, CIE_1931, AVG)] _Type ("Type", Float) = 2
        _Desaturate ("Desaturate ", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            #pragma shader_feature_local _TYPE_REC_601 _TYPE_REC_708 _TYPE_REC_2020 _TYPE_CIE_1931 _TYPE_AVG

            // Required for TEXTURE2D
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            // Required for custom function: MainLightOnSurface, Remap1101
            #include "Assets/UnityShaderLib/Subgraphs_Inc/Common/Common.hlsl"

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
                float4 _MainTex_ST;
                float  _Type;
                float  _Desaturate;
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

                half3 weights;

                #if _TYPE_REC_601
                weights = half3(0.299,0.587,0.114);
                #elif _TYPE_REC_708
                weights = half3(0.2126,0.7152,0.0722);
                #elif _TYPE_REC_2020
                weights = half3(0.2627,0.678,0.0593);
                #elif _TYPE_CIE_1931
                weights = half3(0.212671,0.71516,0.072169);
                #elif _TYPE_AVG
                weights = mainColor.rgb/3;
                #endif

                half4 desaturateColor = dot(weights,mainColor.rgb);

                half4 color = half4(lerp(mainColor.rgb, desaturateColor, _Desaturate), mainColor.a);

                return color;
            }

            ENDHLSL
        }
    }
}