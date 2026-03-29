Shader "Common/FlowMap"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Main Tex", 2D) = "white" {}
        [NoScaleOffset] _FlowTex ("Flow Tex", 2D) = "white" {}
        [NoScaleOffset] _FlowMap ("Flow Map", 2D) = "white" {}
        _FlowSpeed ("Flow Speed", Vector) = (0.25,0.25,0,0)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Required for TransformObjectToHClip
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

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

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                OUT.uv = IN.uv;

                return OUT;
            }

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            TEXTURE2D(_FlowTex);
            SAMPLER(sampler_FlowTex);

            TEXTURE2D(_FlowMap);
            SAMPLER(sampler_FlowMap);

            CBUFFER_START(UnityPerMaterial)
                float3 _FlowSpeed;
            CBUFFER_END

            struct FlowMapOut
            {
                float2 UV_1st_Phase;
                float2 UV_2nd_Phase;
                float _Lerp;
                float Mask;
            };

            FlowMapOut UVFlowMap(TEXTURE2D(_FlowMap), SamplerState sampler_FlowMap, float2 FlowSpeed, float FlowTime, float2 UV)
            {
                FlowMapOut o;

                float4 flow = SAMPLE_TEXTURE2D(_FlowMap, sampler_FlowMap, UV);
                float2 flowremap = flow.rg * 2 - 1;
                flowremap *= -1;
                flowremap *= FlowSpeed;

                float2 fracTime = frac(FlowTime);

                o.UV_1st_Phase = fracTime * flowremap + UV;
                o.UV_2nd_Phase = frac(FlowTime + 0.5) * flowremap + UV;
                o._Lerp = abs(fracTime * 2 - 1); // ping pong from 0 <-> 1
                o.Mask = 1 - step(flow.b,0);

                return o;
            }

            // Fragment Shader
            half4 frag (Varyings IN) : SV_Target
            {
                FlowMapOut o = UVFlowMap(_FlowMap,sampler_FlowMap,_FlowSpeed,_Time.y,IN.uv);

                float4 flow1 = SAMPLE_TEXTURE2D(_FlowTex, sampler_FlowTex, o.UV_1st_Phase);
                float4 flow2 = SAMPLE_TEXTURE2D(_FlowTex, sampler_FlowTex, o.UV_2nd_Phase);
                float4 flowLoop = lerp(flow1,flow2,o._Lerp);
                float4 col = lerp(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv),flowLoop,o.Mask);

                return col;
            }

            ENDHLSL
        }
    }
}
