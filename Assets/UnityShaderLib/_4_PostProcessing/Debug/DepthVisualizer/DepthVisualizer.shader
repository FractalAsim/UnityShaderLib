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

            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature_local _DEPTHSELECT_RAW _DEPTHSELECT_LINEAR // Compile shader variant only for this file for the shaders being used in material
            
            ZTest Always Cull Off ZWrite Off
            
            #include "UnityCG.cginc"

            struct appdata // Input To Vertex
            {
                float4 pos : POSITION;

                float2 uv : TEXCOORD0;
            };

            struct v2f // Input To Fragment
            {
                float4 pos : SV_POSITION;

                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                return o;
            }

            // Unity Injects this texture rendered from camera or gbuffer
            sampler2D _CameraDepthTexture;
            float4 _CameraDepthTexture_TexelSize;

            fixed4 frag(v2f i) : SV_Target
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