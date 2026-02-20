Shader "Basic/WorldPosVertexSnapping"
{
    Properties
    {
        _SnapValue ("Snap Grid Size", Range(0.0001, 0.2)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            #include "UnityCG.cginc"
            #include "Assets/UnityShaderLib/Subgraphs_Inc/Common/Common.cginc"

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

            float _SnapValue;

            v2f vert (appdata v)
            {
                v2f o;
                
                v.pos.y += TimeLoop01();

                // Object Space -> World Space
                float4 worldPos = mul(unity_ObjectToWorld, v.pos);

                // Snap in World Space
                worldPos.xy = round(worldPos.xy / _SnapValue) * _SnapValue;

                // World Space -> Clip Space
                o.pos = UnityWorldToClipPos(worldPos);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(1,1,1,1);
            }

            ENDCG
        }
    }
}
