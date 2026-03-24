// Flatshading or Faccet Shadding using Geometry shader to calculate normals

Shader "Common/FlatShadingGeom"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma geometry geom
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
                float3 normalWS  : NORMAL;
            };

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                
                OUT.positionWS = TransformObjectToWorld(IN.positionOS.xyz);

                return OUT;
            }

             // Geometry Shader
            [maxvertexcount(3)]
            void geom(triangle Varyings IN[3], inout TriangleStream<Varyings> stream)
            {
                float3 p0 = IN[0].positionWS.xyz;
	            float3 p1 = IN[1].positionWS.xyz;
	            float3 p2 = IN[2].positionWS.xyz;

                float3 triangleNormal = normalize(cross(p1 - p0, p2 - p0));

                IN[0].normalWS = triangleNormal;
	            IN[1].normalWS = triangleNormal;
	            IN[2].normalWS = triangleNormal;

                stream.Append(IN[0]);
	            stream.Append(IN[1]);
	            stream.Append(IN[2]);
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                // Basic light using NdotL
                float3 lightDir = normalize(_MainLightPosition.xyz);
                float NdotL = max(dot(normalize(IN.normalWS), lightDir), 0.0);

                half4 color = _MainLightColor * NdotL;
                return color;
            }

            ENDHLSL
        }
    }
}
