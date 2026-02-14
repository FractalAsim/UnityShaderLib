Shader "Basic/ViewSpaceVertexSnapping"
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

                // Object -> View Space
                float4 viewPos = mul(UNITY_MATRIX_MV, v.pos);

                // Round/Snap
                viewPos.xyz = round(viewPos.xyz / _SnapValue) * _SnapValue;

                // View -> Clip Space
                o.pos = mul(UNITY_MATRIX_P, viewPos);

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
