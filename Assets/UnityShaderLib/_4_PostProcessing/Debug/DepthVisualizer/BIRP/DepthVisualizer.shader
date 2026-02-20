Shader "Debug/DepthVisualizer"
{
    Properties
    {
        [KeywordEnum(RAW, LINEAR)] _DepthSelect("DepthType", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert_img // Macro for minimal vertex shader
            #pragma fragment frag

            #pragma shader_feature_local _DEPTHSELECT_RAW _DEPTHSELECT_LINEAR // Compile shader variant only for this file for the shaders being used in material
            
            #include "UnityCG.cginc"

            // Unity Injects this texture rendered from camera or gbuffer
            sampler2D _CameraDepthTexture;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float depth_raw = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);

                if(_DEPTHSELECT_RAW)
                {
                    return float4(depth_raw.xxx, 1.0);
                }
                else //if (_DEPTHSELECT_LINEAR)
                {
                    float depth_01 = Linear01Depth(depth_raw);
                    return float4(depth_01.xxx, 1.0);
                }
            }
            ENDCG
        }
    }
}