// Using Geometry shader to add in barycentricCoordinates for interpolation and using the coordinates to find nearest edge. 
// and create outlines on those edges. effectively a wireframe shader

Shader "Common/WireframeBary"
{
    Properties
    {
        _WireframeColor ("Wireframe Color", Color) = (0, 0, 0, 0)
		_WireframeSmoothing ("Wireframe Smoothing", Range(0, 10)) = 1
		_WireframeThickness ("Wireframe Thickness", Range(0, 10)) = 0.05

        [KeywordEnum(Wire, Fill, Both)] _Mode("Mode Select", float) = 0 // 3 Enum Selection (shader variants)
        [Toggle] _RemoveDiag("Remove diagonals", float) = 0
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

            #pragma shader_feature_local _MODE_WIRE _MODE_FILL _MODE_BOTH
            #pragma shader_feature _REMOVEDIAG_ON


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

                #if _REMOVEDIAG_ON
                float4 worldPos : TEXCOORD0;
                #endif

                float3 bary : TEXCOORD1;
				float4 dist : TEXCOORD2;
            };

            float4 _WireframeColor;
            float _WireframeSmoothing;
            float _WireframeThickness;

            float _WireframeThickness2;

            v2gf vert (appdata v)
            {
                v2gf o;
                o.pos = UnityObjectToClipPos(v.pos);

                #if _REMOVEDIAG_ON
                o.worldPos = mul(unity_ObjectToWorld, v.pos);
                #endif
                
                return o;
            }

            [maxvertexcount(3)]
            void geom (triangle v2gf i[3],inout TriangleStream<v2gf> stream) 
            {
                i[0].bary = float3(1, 0, 0);
	            i[1].bary = float3(0, 0, 1);
	            i[2].bary = float3(0, 1, 0);

                #if _REMOVEDIAG_ON
                float3 param = float3(0.0, 0.0, 0.0);

                // Use world pos to get largest edge to remove, but doing do will need to recalculate clip pos
                float EdgeA = length(i[0].worldPos - i[1].worldPos);
                float EdgeB = length(i[1].worldPos - i[2].worldPos);
                float EdgeC = length(i[2].worldPos - i[0].worldPos);

                i[0].pos = mul(UNITY_MATRIX_VP, i[0].worldPos);
                i[1].pos = mul(UNITY_MATRIX_VP, i[1].worldPos);
                i[2].pos = mul(UNITY_MATRIX_VP, i[2].worldPos);
               
                // Find largest length, set opposite bary
                if(EdgeA > EdgeB && EdgeA > EdgeC)
                    param.y = 1.0;
                else if (EdgeB > EdgeC && EdgeB > EdgeA)
                    param.x = 1.0;
                else
                    param.z = 1.0;

                i[0].bary += param;
	            i[1].bary += param;
	            i[2].bary += param;
                #endif

                stream.Append(i[0]);
	            stream.Append(i[1]);
	            stream.Append(i[2]);
            }

            fixed4 frag (v2gf i) : SV_Target
            {
                float4 col = float4(1,1,1,1);

                // if using bary interpolated
                float3 barys = i.bary;

                float3 deltas = fwidth(barys);
                float3 smoothing = deltas * _WireframeSmoothing;
	            float3 thickness = deltas * _WireframeThickness;
                barys = smoothstep(thickness, thickness + smoothing, barys);

                float minBary = min(barys.x, min(barys.y, barys.z));

                if(_MODE_WIRE)
                {
                    //clip(minBary + thickness.x + smoothing.x);
                    if(minBary > thickness.x + smoothing.x)
                    {
                        discard;    
                    }
                }
                else if (_MODE_FILL)
                {
                    if(minBary < thickness.x + smoothing.x)
                    {
                        discard;    
                    }
                }

                col.rgb = lerp(_WireframeColor, col, minBary);

                return col;
            }

            ENDCG
        }
    }
}