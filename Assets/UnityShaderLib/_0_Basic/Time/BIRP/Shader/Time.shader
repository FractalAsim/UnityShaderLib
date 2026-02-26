Shader "Basic/Time"
{
    Properties
    {
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
            };

            // Defined in "UnityCG.cginc"
            // float4 _Time; (t/20, t, t*2, t*3)
            // float4 _SinTime; (t/8, t/4, t/2, t)
            // float4 _CosTime; (t/8, t/4, t/2, t)
            // float4 unity_DeltaTime; (dt, 1/dt, smoothDt, 1/smoothDt)

            v2f vert (appdata v)
            {
                v2f o;

                v.pos.x += _SinTime.x;

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
