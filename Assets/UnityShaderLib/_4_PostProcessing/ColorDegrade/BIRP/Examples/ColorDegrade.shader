Shader "PostProcessing/ColorDegrade"
{
    Properties
    {
        [HideInInspector] _MainTex ("Texture", 2D) = "white" {} // Input is actually ScreenBuffer

        _colorDepth ("_colorDepth", int) = 1.0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM

            #pragma vertex vert_img // Macro for minimal vertex shader
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float _colorDepth;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float3 screenCol = tex2D(_MainTex, i.uv).rgb;
                float4 col = fixed4(floor(screenCol * _colorDepth) / _colorDepth, 1.0);
                return col;
            }

            ENDCG
        }
    }
}
