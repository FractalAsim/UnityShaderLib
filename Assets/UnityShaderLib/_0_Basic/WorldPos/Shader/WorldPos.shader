Shader "Basic/WorldPos"
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

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                // World Pos
                o.worldPos = mul(unity_ObjectToWorld, v.pos).xyz;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col;
                col.rgb = i.worldPos;
                return col;
            }

            ENDCG
        }
    }
}