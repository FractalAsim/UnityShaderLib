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
            sampler2D _CameraDepthNormalsTexture;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float4 enc = tex2D(_CameraDepthNormalsTexture, i.uv);
                float3 normal = DecodeViewNormalStereo(enc);

                // Remap normals from [-1,1] to [0,1]
                float4 col = float4(normal * 0.5 + 0.5, 1);

                return col;
            }
            ENDCG
        }
    }
}