// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Advanced/TessellationDisplacement"
{
    Properties
    {
        _DisplacementMap ("Texture", 2D) = "white" {}
        _DisplacementFactor ("_Displacement Factor", Range(-0.1, 0.1)) = 0
        _NormalMap ("Texture", 2D) = "bump" {}
        _TessellationFactor ("Tessellation Factor", Range(1, 64)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma hull hs // Use "hs" function for Hull Shader
            #pragma domain ds // Use "ds" function for Domain Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            #include "UnityCG.cginc"

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 tangent : TANGENT;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
    
                float3x3 tangentToWorld : TEXCOORD1;
            };

            sampler2D _DisplacementMap;
            sampler2D _NormalMap;
            float _DisplacementFactor;

            // PlaceHolder - actual is done in domain shader
            appdata vert (appdata v) 
            {
	            return v;
            }

            [UNITY_domain("tri")] // get a patch of triangle verticies
            [UNITY_outputcontrolpoints(3)] // 3 vertices/CP per patch
            [UNITY_outputtopology("triangle_cw")] // output vertices winding order
            [UNITY_partitioning("fractional_odd")] // "integer" ,"fractional_odd","fractional_even"
            [UNITY_patchconstantfunc("PatchConstantFunction")] // register constant function, Name must match 
            appdata hs (InputPatch<appdata, 3> patch,
	            uint id : SV_OutputControlPointID) 
            {
                // Get a patch - which is a group of Vertex
                // return the vertex index by controlpoint id
                return patch[id];
            }
            // Tesselation Subdivide Settings (PatchConstantFunction)
            float _TessellationFactor;
            struct TessellationFactors 
            {
                float edge[3] : SV_TessFactor;
                float inside : SV_InsideTessFactor;
                //float3 bezierPoints[3] : BEZIERPOS;
            };
            TessellationFactors PatchConstantFunction(InputPatch<appdata, 3> patch) 
            {
	            TessellationFactors f;
                f.edge[0] = _TessellationFactor;
                f.edge[1] = _TessellationFactor;
                f.edge[2] = _TessellationFactor;
                f.inside = _TessellationFactor;
	            return f;
            }

            v2f vertTess (appdata i)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(i.pos);

                float3 worldTangent = UnityObjectToWorldDir(i.tangent.xyz);
                float3 worldNormal = UnityObjectToWorldNormal(i.normal);

                half tangentSign = i.tangent.w * unity_WorldTransformParams.w;
                float3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;

                // Apply Displacement
                float displacement = tex2Dlod(_DisplacementMap, float4(i.uv.xy, 0, 0)).r;
                o.pos.xyz -= worldNormal * displacement * _DisplacementFactor;

                o.tangentToWorld = float3x3(worldTangent, worldBinormal, worldNormal);

                o.uv = i.uv;
                return o;
            }
            #define BARYCENTRIC_INTERPOLATE(fieldName) \
		        patch[0].fieldName * barycentricCoordinates.x + \
		        patch[1].fieldName * barycentricCoordinates.y + \
		        patch[2].fieldName * barycentricCoordinates.z
            [UNITY_domain("tri")]
            v2f ds(TessellationFactors factors,
	            OutputPatch<appdata,3> patch,
	            float3 barycentricCoordinates : SV_DomainLocation) // Coordinates to be used for new vertice
            {
                appdata data;
                data.pos = BARYCENTRIC_INTERPOLATE(pos);
                data.normal = BARYCENTRIC_INTERPOLATE(normal);
                data.uv = BARYCENTRIC_INTERPOLATE(uv);
                data.tangent = BARYCENTRIC_INTERPOLATE(tangent);

                // Apply Vert Shader
                return vertTess(data);
            }

            uniform float4 _LightColor0;

            fixed4 frag (v2f i) : SV_Target
            {
                float3 texnormal = UnpackNormal(tex2D(_NormalMap, i.uv));

                // transform normal from tangent to world space
                float3 normal = mul(i.tangentToWorld, texnormal);

                // Basic light using NdotL
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(dot(normal, lightDir), 0.0);

                fixed4 col = _LightColor0 * NdotL;
                return col;
            }

            ENDCG
        }
    }
}