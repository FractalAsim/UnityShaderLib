// Using Geometry shader to add in barycentricCoordinates for interpolation and using the coordinates to find nearest edge. /
// and create outlines on thouse edges. effectively a wireframe shader

Shader "Basic/WireframeGeom"
{
    Properties
    {
        _WireframeColor ("Wireframe Color", Color) = (0, 0, 0, 0)
		_WireframeSmoothing ("Wireframe Smoothing", Range(0, 10)) = 1
		_WireframeThickness ("Wireframe Thickness", Range(0, 10)) = 0.05
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
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 barycentricCoordinates : TEXCOORD1;
            };

            uniform float4 _LightColor0;

            float3 _WireframeColor;
            float _WireframeSmoothing;
            float _WireframeThickness;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                return o;
            }

            [maxvertexcount(3)]
            void geom (triangle v2f i[3],inout TriangleStream<v2f> stream) 
            {
                i[0].barycentricCoordinates = float3(1, 0, 0);
	            i[1].barycentricCoordinates = float3(0, 1, 0);
	            i[2].barycentricCoordinates = float3(0, 0, 1);

                stream.Append(i[0]);
	            stream.Append(i[1]);
	            stream.Append(i[2]);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = float4(1,1,1,1);

                float3 barys = i.barycentricCoordinates;

                float3 deltas = fwidth(barys);
                float3 smoothing = deltas * _WireframeSmoothing;
	            float3 thickness = deltas * _WireframeThickness;
                barys = smoothstep(thickness, thickness + smoothing, barys);

                float minBary = min(barys.x, min(barys.y, barys.z));

                col.rgb = lerp(_WireframeColor, col, minBary);;

                return col;
            }

            ENDCG
        }
    }
}