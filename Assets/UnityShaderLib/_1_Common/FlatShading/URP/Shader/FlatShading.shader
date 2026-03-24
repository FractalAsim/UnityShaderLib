// Flatshading or Faccet Shadding on the Fragment using ddx, ddy function

Shader "Common/FlatShadingFrag"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Required for GetMainLight() in RealtimeLights.hlsl
            // Required for _MainLightPosition, _MainLightColor in Input.hlsl
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            // Input to Vertex Shader
            struct Attributes
            {
                float4 positionOS : POSITION; // Object Space Position
            };

            // Input to Fragment Shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous Clip Space Position

                float3 positionWS  : TEXCOORD0;
            };

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
                // Calculate normals using ddx ddy
                float3 fddx = ddx(IN.positionWS);
	            float3 fddy = ddy(IN.positionWS);
	            float3 normal = normalize(cross(fddy,fddx));

                // Basic light using NdotL
                float3 lightDir = normalize(_MainLightPosition.xyz);
                float NdotL = max(dot(normalize(normal), lightDir), 0.0);

                half4 color = _MainLightColor * NdotL;
                return color;
            }

            ENDHLSL
        }
    }
}
