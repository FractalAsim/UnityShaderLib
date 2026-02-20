Shader "Debug/WorldNormalsVisualizer"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert_img // Macro for minimal vertex shader
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Unity Injects this texture rendered from camera or gbuffer
            sampler2D _CameraMotionVectorsTexture;

            fixed4 frag(v2f_img i) : SV_Target
            {
                // Returns in [-1,1]
                float2 deltas = tex2D(_CameraMotionVectorsTexture, i.uv).rg;

                // Remap from [-1,1] to [0,1]
                float4 col = float4(deltas,0, 1);

                return col;
            }
            ENDCG
        }
    }
}