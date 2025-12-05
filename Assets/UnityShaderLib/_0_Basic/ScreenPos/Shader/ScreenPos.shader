Shader "Basic/ScreenPos"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col;

                i.pos.xy = i.pos.xy / _ScreenParams.xy;
                col.rg =  i.pos.xy;

                return col;
            }

            ENDCG
        }
    }
}