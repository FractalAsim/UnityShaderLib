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
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #pragma shader_feature_local _DEPTHSELECT_RAW _DEPTHSELECT_LINEAR // Compile shader variant only for this file for the shaders being used in material

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

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
