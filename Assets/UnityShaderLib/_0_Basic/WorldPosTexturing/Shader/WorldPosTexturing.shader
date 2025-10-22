// Calculate world Position of pixels

Shader "Basic/WorldPosTexturing"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
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

            sampler2D _MainTex;
            float4 _MainTex_ST;

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
                // Use World Pos to sample texture
                fixed4 col = tex2D(_MainTex, i.worldPos);

                return col;
            }

            ENDCG
        }
    }
}