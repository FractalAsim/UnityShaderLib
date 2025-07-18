Shader "Common/Displacement"
{
    Properties
    {
       _Displacement ("Displacement", Vector) = (0,0,0,0)
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

            float4 _Displacement;

            v2f vert (appdata v)
            {
                v2f o;

                float TimeLoop01 = _SinTime.w * 0.5 + 0.5;
                v.pos = TimeLoop01 * _Displacement + v.pos;

                o.pos = UnityObjectToClipPos(v.pos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return float4(1,1,1,1);
            }

            ENDCG
        }
    }
}