Shader "ShaderTemplate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} // "white" , "black" , "gray" , "bump"
        _Float ("Float", Float) = 1
        _Int ("Int", Int) = 1
        _Color ("Color", Color) = (1,1,1,1)
        _Vector ("Vector", Vector) = (1,1,1,1)
        _Range ("Range", Range(0, 10)) = 1
    }
    SubShader
    {
        // Render Options
        // "Queue" = "[name]+[offset]"
        // “RenderType” = "[name]"
        Tags { "RenderType"="Opaque" }

        // Get the frame buffer at this point into the named texture to be used in the next pass and other subshader?
        // Need to declare the named texture in the pass to use
        GrabPass {"FrameBufferTex"}

        LOD 100

        Pass
        {
            // Render Mode Options for the current pass
            // Cull Back | Front | Off
            // ZTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always)
            // ZWrite On | Off

            CGPROGRAM

            #pragma vertex vert  // Use "vert" function for Vertex Shader 
            #pragma hull hs // Use "hs" function for Hull Shader , automatically turns on #pragma target 5.0
            #pragma domain ds // Use "ds" function for Domain Shader , automatically turns on #pragma target 5.0
            #pragma geometry geo // compile function name as DX10 geometry shader. Having this option automatically turns on #pragma target 4.0, described below.
            #pragma fragment frag // Use "frag" function for Fragment Shader


            // Set Blending for the current pass
            // https://docs.unity3d.com/Manual/SL-Blend.html
            // Blend Off
            // Blend Source Dest // One , Zero , SrcColor , SrcAlpha,DstColor,DstAlpha,OneMinusSrcColor,OneMinusSrcAlpha,OneMinusDstColor,OneMinusDstAlpha
            // Blend rendertarget Source Dest // 1-7 

            // Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency
            // Blend One OneMinusSrcAlpha // Premultiplied transparency
            // Blend One One // Additive
            // Blend OneMinusDstColor One // Soft Additive
            // Blend DstColor Zero // Multiplicative
            // Blend DstColor SrcColor // 2x Multiplicative

            // Add Code from external file
            #include "UnityCG.cginc"
            
            // Define Input structs for shaders
            struct vertexdata // Input To Vertex
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;

                float2 uv : TEXCOORD0;
	            float2 uv1 : TEXCOORD1;
	            float2 uv2 : TEXCOORD2;
            };
            struct v2f // Input To Fragment
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;

                float2 uv : TEXCOORD0;

                float3 worldPos : TEXCOORD1;

                float3 worldTangent : TEXCOORD2;
                float3 worldBinormal : TEXCOORD3;
                float3 worldNormal : TEXCOORD4;
                float3x3 tangentToWorld : TEXCOORD7;
            };

            // Properties to use for this pass, shader input/config settings
            sampler2D _MainTex;
            float4 _MainTex_ST; // [tilingX,tilingY,offsetX,offsetY]

            // Vert shader is left empty when using tessalation, logic is shift to vertTess instead
            vertexdata vert (vertexdata i)
            {
                return i;
            }
            v2f vertTess (vertexdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos); // Convert for Frag Usage
                o.normal = v.normal;

                o.uv = TRANSFORM_TEX(v.uv, _MainTex); // apply _MainTex_ST
                
                o.worldPos = mul(unity_ObjectToWorld, v.pos).xyz;

                // World Tangent
                o.worldTangent = float4(UnityObjectToWorldDir(v.tangent.xyz),v.tangent.w);
                // World Normal
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                // World Binormal
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                o.worldBinormal = cross(o.worldNormal, o.worldTangent.xyz) * tangentSign;
                // TangentToworld (TBN) Matrix
                o.tangentToWorld = float3x3(o.worldTangent.xyz, o.worldBinormal, o.worldNormal);

                return o;
            }

            [UNITY_domain("tri")] // get a patch of triangle verticies
            [UNITY_outputcontrolpoints(3)] // 3 vertices/CP per patch
            [UNITY_outputtopology("triangle_cw")] // output vertices winding order
            [UNITY_partitioning("fractional_odd")] // "integer" ,"fractional_odd","fractional_even"
            [UNITY_patchconstantfunc("PatchConstantFunction")] // register constant function, Name must match 
            vertexdata hs (InputPatch<vertexdata, 3> patch,
	            uint id : SV_OutputControlPointID) 
            {
                // Get a patch - which is a group of Vertex
                // return the vertex, index by controlpoint id
                return patch[id];
            }
            struct TessellationFactors 
            {
                float edge[3] : SV_TessFactor;
                float inside : SV_InsideTessFactor;
                float3 bezierPoints[3] : BEZIERPOS;
            };
            TessellationFactors PatchConstantFunction(InputPatch<vertexdata, 3> patch) 
            {
	            TessellationFactors f;
                f.edge[0] = 1;
                f.edge[1] = 1;
                f.edge[2] = 1;
                f.inside = 1;
	            return f;
            }
            
            #define BARYCENTRIC_INTERPOLATE(fieldName) \
		        patch[0].fieldName * barycentricCoordinates.x + \
		        patch[1].fieldName * barycentricCoordinates.y + \
		        patch[2].fieldName * barycentricCoordinates.z
            [UNITY_domain("tri")]
            v2f ds(TessellationFactors factors,
	            OutputPatch<vertexdata,3> patch,
	            float3 barycentricCoordinates : SV_DomainLocation) // Coordinates to be used for new vertice
            {
                vertexdata data;

                data.pos = BARYCENTRIC_INTERPOLATE(pos);
                data.normal = BARYCENTRIC_INTERPOLATE(normal);
                data.tangent = BARYCENTRIC_INTERPOLATE(tangent);

                data.uv = BARYCENTRIC_INTERPOLATE(uv);
                data.uv1 = BARYCENTRIC_INTERPOLATE(uv1);
                data.uv2 = BARYCENTRIC_INTERPOLATE(uv2);

                // Apply Vert Shader
                return vertTess(data);
            }

            [maxvertexcount(3)]
            void geo(triangle v2f i[3],
                inout TriangleStream<v2f> OutputStream) // PointStream, LineStream , TriangleStream
            {
                // Simple Pass though to frag shader
                OutputStream.Append(i[0]);
                OutputStream.Append(i[1]);
                OutputStream.Append(i[2]);
            }

            uniform float4 _LightColor0;

            fixed4 frag (v2f i) : SV_Target
            {
                // Basic Texture Sample
                fixed4 col = tex2D(_MainTex, i.uv);

                // Basic light using NdotL
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(dot(i.normal, lightDir), 0.0);
                col.xyz = _LightColor0 * NdotL;

                return col;
            }

            ENDCG
        }
    }
}
