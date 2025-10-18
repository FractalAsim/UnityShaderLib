Shader "Advanced/TessellationBasic"
{
    Properties
    {
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

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

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

            v2f vertTess (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
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

                // Apply Vert Shader
                return vertTess(data);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return float4(1,1,1,1);
            }

            ENDCG
        }
    }
}