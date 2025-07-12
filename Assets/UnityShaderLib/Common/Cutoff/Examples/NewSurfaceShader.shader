Shader "Unlit/ToggleRed"
{
    Properties
    {
        [Toggle] _RED ("Make red", Integer) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Add the keyword RED_ON, for when the toggle is on
            // Unity automatically adds a keyword for when the toggle is off 
            #pragma shader_feature _RED_ON

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Return red if the toggle is on
                #if _RED_ON
                    return fixed4(1, 0, 0, 1);
                #else
                    return fixed4(0, 0, 0, 1);
                #endif
            }
            ENDHLSL
        }
    }
}