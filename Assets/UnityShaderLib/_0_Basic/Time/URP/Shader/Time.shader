Shader "Basic/Time"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Required for _SinTime in Unityinput.hlsl
            // float4 _Time; // (t/20, t, t*2, t*3)
            // float4 _SinTime; // sin(t/8), sin(t/4), sin(t/2), sin(t)
            // float4 _CosTime; // cos(t/8), cos(t/4), cos(t/2), cos(t)
            // float4 unity_DeltaTime; // dt, 1/dt, smoothdt, 1/smoothdt
            // float4 _TimeParameters; // t, sin(t), cos(t)
            // float4 _LastTimeParameters; // t, sin(t), cos(t)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    
            // Input to Vertex Shader
            struct Attributes
            {
                float4 positionOS : POSITION; // Object Space Position
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position
            };

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                IN.positionOS.x += _SinTime.x;

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                return float4(1,1,1,1);
            }

            ENDHLSL
        }
    }
}
