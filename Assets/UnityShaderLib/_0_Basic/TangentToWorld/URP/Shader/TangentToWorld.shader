Shader "Basic/TangentToWorld"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Required for TransformObjectToWorldDir, TransformObjectToWorldNormal, CreateTangentToWorld in SpaceTransforms.hlsl
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    
            // Input to Vertex Shader
            struct Attributes
            {
                float4 positionOS : POSITION; // Object Space Position

                float3 normalOS  : NORMAL;
                float4 tangentOS : TANGENT;
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position

                real3 tangentWS : TEXCOORD0;
                real3 binormalWS: TEXCOORD1;
                real3 normalWS  : TEXCOORD2;

                real3x3 tangentToWorld : TEXCOORD3;
            };

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                // World Tangent
                OUT.tangentWS = real3(TransformObjectToWorldDir(IN.tangentOS.xyz));

                // World Normal
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);

                // World Binormal
                real tangentSign = real(IN.tangentOS.w) * GetOddNegativeScale();
                // or
                //real tangentSign = IN.tangentOS.tangent.w * unity_WorldTransformParams.w; // not properly set at the moment ?

                OUT.binormalWS = real3(cross(OUT.normalWS, float3(OUT.tangentWS.xyz))) * tangentSign;

                // TangentToworld (TBN) Matrix
                OUT.tangentToWorld = real3x3(OUT.tangentWS.xyz, OUT.binormalWS, OUT.normalWS);
                // or
                //OUT.tangentToWorld = CreateTangentToWorld(OUT.tangentWS,OUT.normalWS,tangentSign);

                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = half4(1,1,1,1);

                return color;
            }

            ENDHLSL
        }
    }
}
