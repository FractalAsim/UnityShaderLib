Shader "Basic/Texturing"
{
    Properties
    {
        _Texture1 ("Texture1", 2D) = "white" {}
        _Texture2 ("Texture2", 2D) = "white" {}
        _Blend ("Blend", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float2 uv : TEXCOORD0;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD0;
            };

            sampler2D _Texture1;
            float4 _Texture1_ST;
            sampler2D _Texture2;
            float4 _Texture2_ST;
            float _Blend;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = TRANSFORM_TEX(v.uv, _Texture1);
                o.uv2 = TRANSFORM_TEX(v.uv, _Texture2);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return lerp(tex2D(_Texture1, i.uv),tex2D(_Texture2, i.uv2),_Blend);
            }
            ENDCG
        }
    }
}
