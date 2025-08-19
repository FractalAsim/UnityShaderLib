// Using Geometry shader to calculate distance to opposite edge. and using distance to 
// create outlines on thouse edges. effectively a wireframe shader

Shader "Basic/WireframeDist"
{
    Properties
    {
        _WireframeColor ("Wireframe Color", Color) = (0, 0, 0, 0)
		_WireframeThickness ("Wireframe Thickness", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma geometry geom
            #pragma fragment frag // Use "frag" function for Fragment Shader

            #include "UnityCG.cginc"

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
            };

            // Input to Fragment Shader
            struct v2gf
            {
                float4 pos : SV_POSITION;
				float4 dist : TEXCOORD1;
            };

            float4 _WireframeColor;
            float _WireframeThickness;

            v2gf vert (appdata v)
            {
                v2gf o;
                o.pos = UnityObjectToClipPos(v.pos);
                return o;
            }

            [maxvertexcount(3)]
            void geom (triangle v2gf i[3],inout TriangleStream<v2gf> stream) 
            {
                float2 p0 = i[0].pos.xy / i[0].pos.w;
				float2 p1 = i[1].pos.xy / i[1].pos.w;
				float2 p2 = i[2].pos.xy / i[2].pos.w;

				float2 edge0 = p2 - p1;
				float2 edge1 = p2 - p0;
				float2 edge2 = p1 - p0;

                // Calculate Distance to edge using area of triangle
                // Distance = Height = = Area*2/Base
                float area = abs(edge1.x * edge2.y - edge1.y * edge2.x);
                float max = 300;

                i[0].dist.xyz = float3(area / length(edge0),0,0) * i[0].pos.w * max;
                i[0].dist.w = 1.0 / i[0].pos.w;

                i[1].dist.xyz = float3(0,area / length(edge1),0) * i[1].pos.w * max;
				i[1].dist.w = 1.0 / i[1].pos.w;

                i[2].dist.xyz = float3(0,0,area / length(edge2)) * i[2].pos.w  * max;
				i[2].dist.w = 1.0 / i[2].pos.w;

                stream.Append(i[0]);
	            stream.Append(i[1]);
	            stream.Append(i[2]);
            }

            fixed4 frag (v2gf i) : SV_Target
            {
                float4 col = float4(1,1,1,1);

                float3 dist = i.dist;
                dist = smoothstep(0, _WireframeThickness, dist);
                float minDist = min(dist.x, min(dist.y, dist.z));

                col.rgb = lerp(_WireframeColor, col, minDist);
                return col;
            }

            ENDCG
        }
    }
}