Shader "Basic/ScreenSpaceVertexSnapping"
{
    Properties
    {
        _SnapValue ("Snap Grid Size", Range(1, 8)) = 0.05
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
                
                // Object Space -> Clip Space
                float4 clipPos = UnityObjectToClipPos(v.pos);

                // Clip Space -> NDC
                float2 ndc = clipPos.xy / clipPos.w;

                // -1 1 to 0 1
                ndc = ndc * 0.5 + 0.5;

                // Scale by ScreenParams/Screen Resolution
                float2 screenPos = ndc * _ScreenParams.xy;

                // Round/Snap in Screen Space
                screenPos = floor(screenPos / _SnapValue) * _SnapValue;

                // screenPos ->  NDC
                ndc = screenPos / _ScreenParams.xy;
                ndc = ndc * 2 - 1;

                // NDC -> Clip Space
                clipPos.xy = ndc * clipPos.w;

                o.pos = clipPos;
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
