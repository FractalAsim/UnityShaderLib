// Flatshading or Faccet Shadding on the Fragment using ddx, ddy function

Shader "Basic/FlatShadingFrag"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
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
            };

            uniform float4 _LightColor0;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.worldPos = mul(unity_ObjectToWorld, v.pos).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Calculate normals using ddx ddy
                float3 fddx = ddx(i.worldPos);
	            float3 fddy = ddy(i.worldPos);
	            float3 normal = normalize(cross(fddy,fddx));

                // Basic light using NdotL
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(dot(normal, lightDir), 0.0);

                return _LightColor0 * NdotL;
            }

            ENDCG
        }
    }
}