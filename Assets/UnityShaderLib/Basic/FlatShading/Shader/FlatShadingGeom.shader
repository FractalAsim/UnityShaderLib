// Flatshading or Faccet Shadding using Geom to set normals

Shader "Basic/FlatShadingGeom"
{
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
                float3 worldPos : TEXCOORD0;
                float3 normal : NORMAL;
            };

            uniform float4 _LightColor0;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.worldPos = mul(unity_ObjectToWorld, v.pos).xyz;
                return o;
            }

            [maxvertexcount(3)]
            void geom (triangle v2f i[3],inout TriangleStream<v2f> stream) 
            {
                float3 p0 = i[0].worldPos.xyz;
	            float3 p1 = i[1].worldPos.xyz;
	            float3 p2 = i[2].worldPos.xyz;

                float3 triangleNormal = normalize(cross(p1 - p0, p2 - p0));

                i[0].normal = triangleNormal;
	            i[1].normal = triangleNormal;
	            i[2].normal = triangleNormal;

                stream.Append(i[0]);
	            stream.Append(i[1]);
	            stream.Append(i[2]);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Basic light using NdotL
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(dot(i.normal, lightDir), 0.0);

                return _LightColor0 * NdotL;
            }

            ENDCG
        }
    }
}